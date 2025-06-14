import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/services/location_service.dart';
import 'package:petapp/features/clinic/models/clinic_model.dart';
import 'package:petapp/features/clinic/services/clinic_service.dart';

class ClinicExplorerController extends GetxController {
  final ClinicService _clinicService = ClinicService();
  final LocationService _locationService = Get.find<LocationService>();

  // Observable properties
  final RxList<ClinicModel> allClinics = <ClinicModel>[].obs;
  final RxList<ClinicModel> filteredClinics = <ClinicModel>[].obs;
  final RxList<String> availableCategories = <String>[].obs;
  final RxList<String> availableServices = <String>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'All Category'.obs;
  final RxString selectedRegion = 'All Regions'.obs;
  final RxString selectedService = 'All Services'.obs;
  final RxString sortOption = 'Default'.obs;
  final RxDouble maxDistance = 50.0.obs;

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  // Category tabs
  final List<String> categories = [
    'All Category',
    'Popular',
    'Recommended',
    'Latest',
  ];

  // Hierarchical regions data structure
  final RxMap<String, List<String>> regionHierarchy = <String, List<String>>{}.obs;
  final RxList<String> regions = <String>[
    'All Regions',
    'Nearby (Auto-detect)',
  ].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeFromArguments();
    loadData();

    // Listen to search changes with debounce
    debounce(searchQuery, (_) => applyFilters(),
        time: const Duration(milliseconds: 500));
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }

  /// Initialize data from navigation arguments
  void _initializeFromArguments() {
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      if (args['category'] != null) {
        selectedCategory.value = args['category'];
      }
      if (args['openSearch'] == true) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          focusSearch();
        });
      }
      if (args['openFilters'] == true) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showFilterModal();
        });
      }
      if (args['sortBy'] != null) {
        sortOption.value = args['sortBy'] == 'distance' ? 'Nearby' : 'Default';
      }
    }
  }

  /// Load all data
  Future<void> loadData() async {
    try {
      isLoading.value = true;

      // Load clinics
      final clinics = await _clinicService.getAllClinics();
      allClinics.value = clinics;

      // Load available categories and services
      availableCategories.value = _clinicService.getAvailableCategories();
      availableServices.value = _clinicService.getAvailableServices();

      // Update regions with clinic locations
      _updateRegions();

      // Apply initial filters
      applyFilters();
    } catch (e) {
      print('Error loading clinic data: $e');
      Get.snackbar('Error', 'Failed to load clinics. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  /// Update regions list with hierarchical structure based on clinic locations
  void _updateRegions() {
    final Map<String, Set<String>> governoratesCities = {};
    final Set<String> allUniqueRegions = {'All Regions'};

    // Add nearby option if location is available
    if (_locationService.isPermissionGranted) {
      allUniqueRegions.add('Nearby (Auto-detect)');
    }

    // Parse clinic locations to extract governorates and cities
    for (final clinic in allClinics) {
      final locationParts = clinic.location.split(',');
      
      if (locationParts.length >= 2) {
        // Format: "City, State/Governorate" or "City, State, Country"
        final city = locationParts[0].trim();
        final governorate = locationParts[1].trim();
        
        // Initialize governorate if not exists
        if (!governoratesCities.containsKey(governorate)) {
          governoratesCities[governorate] = <String>{};
        }
        
        // Add city to governorate
        governoratesCities[governorate]!.add(city);
        
        // Add both governorate and specific location to regions
        allUniqueRegions.add(governorate);
        allUniqueRegions.add(clinic.location);
      } else {
        // Single location format
        allUniqueRegions.add(clinic.location);
      }
    }

    // Build hierarchy map
    final Map<String, List<String>> hierarchy = {};
    
    // Add governorates and their cities
    governoratesCities.forEach((governorate, cities) {
      if (cities.length > 1) {
        // Only create hierarchy if governorate has multiple cities
        hierarchy[governorate] = cities.toList()..sort();
      }
    });

    regionHierarchy.value = hierarchy;
    regions.value = allUniqueRegions.toList()..sort();

    print('Region Hierarchy: $hierarchy');
    print('All Regions: ${regions.value}');
  }

  /// Get cities for a specific governorate
  List<String> getCitiesForGovernorate(String governorate) {
    return regionHierarchy[governorate] ?? [];
  }

  /// Check if a region is a governorate (has sub-cities)
  bool isGovernorate(String region) {
    return regionHierarchy.containsKey(region);
  }

  /// Apply all filters
  Future<void> applyFilters() async {
    try {
      List<ClinicModel> filtered = List.from(allClinics);

      // Apply search filter
      if (searchQuery.value.isNotEmpty) {
        filtered = await _clinicService.searchClinics(query: searchQuery.value);
      }

      // Apply category filter
      filtered = _applyCategoryFilter(filtered);

      // Apply region/location filter
      filtered = await _applyLocationFilter(filtered);

      // Apply service filter
      filtered = _applyServiceFilter(filtered);

      // Apply sorting
      filtered = await _applySorting(filtered);

      filteredClinics.value = filtered;
    } catch (e) {
      print('Error applying filters: $e');
    }
  }

  /// Apply category filter
  List<ClinicModel> _applyCategoryFilter(List<ClinicModel> clinics) {
    switch (selectedCategory.value) {
      case 'Popular':
        return clinics.where((clinic) => clinic.rating >= 4.7).toList();
      case 'Recommended':
        return clinics.where((clinic) => clinic.reviews >= 200).toList();
      case 'Latest':
        // Return first 3 clinics as "latest" for demo
        return clinics.take(3).toList();
      case 'All Category':
      default:
        return clinics;
    }
  }

  /// Apply location/region filter with hierarchical support
  Future<List<ClinicModel>> _applyLocationFilter(List<ClinicModel> clinics) async {
    if (selectedRegion.value == 'All Regions') {
      return clinics;
    }

    if (selectedRegion.value == 'Nearby (Auto-detect)') {
      if (_locationService.isPermissionGranted) {
        return await _clinicService.getClinicsWithinDistance(maxDistance.value);
      } else {
        // Request location permission
        final granted = await _locationService.requestLocationPermission();
        if (granted) {
          return await _clinicService.getClinicsWithinDistance(maxDistance.value);
        }
      }
      return clinics; // Return all if location not available
    }

    // Check if selected region is a governorate (has sub-cities)
    if (isGovernorate(selectedRegion.value)) {
      // Filter by governorate - include all cities in this governorate
      return clinics.where((clinic) {
        final locationParts = clinic.location.split(',');
        if (locationParts.length >= 2) {
          final governorate = locationParts[1].trim();
          return governorate == selectedRegion.value;
        }
        return false;
      }).toList();
    } else {
      // Filter by specific city/location
      return clinics.where((clinic) => 
          clinic.location == selectedRegion.value ||
          clinic.location.contains(selectedRegion.value)
      ).toList();
    }
  }

  /// Apply service filter
  List<ClinicModel> _applyServiceFilter(List<ClinicModel> clinics) {
    if (selectedService.value == 'All Services') return clinics;

    final selectedServices = selectedService.value.split(',');
    return clinics.where((clinic) {
      return selectedServices.any((service) => clinic.services.any(
          (clinicService) =>
              clinicService.toLowerCase().contains(service.toLowerCase())));
    }).toList();
  }

  /// Apply sorting
  Future<List<ClinicModel>> _applySorting(List<ClinicModel> clinics) async {
    switch (sortOption.value) {
      case 'Nearby':
        if (_locationService.isPermissionGranted) {
          return await _clinicService.searchClinics(
            sortBy: 'distance',
            maxDistanceKm: maxDistance.value,
          );
        }
        return clinics;
      case 'Rating':
        clinics.sort((a, b) => b.rating.compareTo(a.rating));
        return clinics;
      case 'Reviews':
        clinics.sort((a, b) => b.reviews.compareTo(a.reviews));
        return clinics;
      case 'Name':
        clinics.sort((a, b) => a.name.compareTo(b.name));
        return clinics;
      default:
        // Default sorting by rating
        clinics.sort((a, b) => b.rating.compareTo(a.rating));
        return clinics;
    }
  }

  /// Update search query
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  /// Update category selection
  void updateCategory(String category) {
    selectedCategory.value = category;
    applyFilters();
  }

  /// Update filters and apply
  void updateFilters({
    String? region,
    String? service,
    String? sort,
    double? distance,
  }) {
    if (region != null) selectedRegion.value = region;
    if (service != null) selectedService.value = service;
    if (sort != null) sortOption.value = sort;
    if (distance != null) maxDistance.value = distance;
    applyFilters();
  }

  /// Focus search field
  void focusSearch() {
    searchFocusNode.requestFocus();
  }

  /// Show filter modal
  void showFilterModal() {
    Get.bottomSheet(
      FilterBottomSheet(controller: this),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  /// Navigate to clinic detail
  void navigateToClinicDetail(ClinicModel clinic) {
    Get.toNamed(AppRoutes.clinicDetail, arguments: clinic.toMap());
  }

  /// Refresh data including location
  Future<void> refreshData() async {
    await _locationService.refreshLocation();
    await loadData();
  }

  /// Request location permission
  Future<void> requestLocationPermission() async {
    final granted = await _locationService.requestLocationPermission();
    if (granted) {
      _updateRegions();
      applyFilters();
    }
  }
}

class ClinicExplorerScreen extends StatelessWidget {
  const ClinicExplorerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ClinicExplorerController());
    final isDark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        title: const Text('Find Clinics'),
        centerTitle: true,
        elevation: 0,
        actions: [
          // Location indicator
          Obx(() => IconButton(
                onPressed: () {
                  if (controller._locationService.isPermissionGranted) {
                    controller.refreshData();
                  } else {
                    controller.requestLocationPermission();
                  }
                },
                icon: controller._locationService.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppColors.orange),
                        ),
                      )
                    : Icon(
                        controller._locationService.isPermissionGranted
                            ? Icons.location_on
                            : Icons.location_off,
                        color: controller._locationService.isPermissionGranted
                            ? AppColors.orange
                            : Colors.grey,
                      ),
                tooltip: controller._locationService.isPermissionGranted
                    ? 'Refresh location'
                    : 'Enable location',
              )),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.refreshData,
          color: AppColors.orange,
          child: CustomScrollView(
            slivers: [
              // Location status banner (scrollable)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Obx(() => _buildLocationBanner(context, controller, isDark)),
                ),
              ),

              // Search bar (scrollable)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildSearchBar(context, controller, isDark),
                ),
              ),

              // Category tabs (scrollable)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: _buildCategoryTabs(context, controller, isDark),
                ),
              ),

              // Search results header (scrollable)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child: Obx(() => _buildResultsHeader(context, controller, isDark)),
                ),
              ),

              // Clinic list (scrollable)
              Obx(() => _buildClinicSliverList(context, controller, isDark)),
            ],
          ),
        ),
      ),
    );
  }

  /// Build location status banner
  Widget _buildLocationBanner(
      BuildContext context, ClinicExplorerController controller, bool isDark) {
    if (controller._locationService.isPermissionGranted) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on, color: AppColors.orange, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Location',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    controller._locationService.currentCity.isNotEmpty
                        ? controller._locationService.currentCity
                        : 'Getting location...',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'Within ${controller.maxDistance.value.round()}km',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_off, color: AppColors.orange, size: 20),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Enable location for distance-based results',
              style: TextStyle(fontSize: 14),
            ),
          ),
          TextButton(
            onPressed: controller.requestLocationPermission,
            child: const Text('Enable'),
          ),
        ],
      ),
    );
  }

  /// Build search bar
  Widget _buildSearchBar(
      BuildContext context, ClinicExplorerController controller, bool isDark) {
    final searchBgColor = isDark ? AppColors.lightblack : Colors.grey[100];
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[700];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: searchBgColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(Icons.search, color: subTextColor),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller.searchController,
              focusNode: controller.searchFocusNode,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: 'Search clinics, services, locations...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: subTextColor),
              ),
              onChanged: controller.updateSearchQuery,
            ),
          ),
          IconButton(
            icon: Icon(Icons.tune, color: subTextColor),
            onPressed: controller.showFilterModal,
          ),
        ],
      ),
    );
  }

  /// Build category tabs
  Widget _buildCategoryTabs(
      BuildContext context, ClinicExplorerController controller, bool isDark) {
    final textColor = isDark ? Colors.white : Colors.black;

    return SizedBox(
      height: 40,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.categories.length,
          itemBuilder: (context, index) {
            final category = controller.categories[index];
            return Obx(() {
              final isSelected = controller.selectedCategory.value == category;

              return GestureDetector(
                  onTap: () => controller.updateCategory(category),
                  child: Container(
                    margin: const EdgeInsets.only(right: 16),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.orange.withOpacity(isDark ? 0.2 : 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color:
                            isSelected ? AppColors.orange : Colors.transparent,
                      ),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? AppColors.orange : textColor,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ));
            });
          }),
    );
  }

  /// Build results header
  Widget _buildResultsHeader(
      BuildContext context, ClinicExplorerController controller, bool isDark) {
    final textColor = isDark ? Colors.white : Colors.black;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Search Result',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
        ),
        Text(
          '${controller.filteredClinics.length} found',
          style: const TextStyle(
            color: AppColors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// Build clinic sliver list
  Widget _buildClinicSliverList(
      BuildContext context, ClinicExplorerController controller, bool isDark) {
    if (controller.isLoading.value) {
      return const SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.orange),
          ),
        ),
      );
    }

    if (controller.filteredClinics.isEmpty) {
      return SliverFillRemaining(
        child: _buildEmptyState(context, controller, isDark),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final clinic = controller.filteredClinics[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildClinicCard(context, clinic, controller, isDark),
          );
        },
        childCount: controller.filteredClinics.length,
      ),
    );
  }

  /// Build empty state
  Widget _buildEmptyState(
      BuildContext context, ClinicExplorerController controller, bool isDark) {
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[700];

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: subTextColor,
          ),
          const SizedBox(height: 16),
          Text(
            'No clinics found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: textColor,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: subTextColor,
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              controller.searchQuery.value = '';
              controller.selectedCategory.value = 'All Category';
              controller.selectedRegion.value = 'All Regions';
              controller.selectedService.value = 'All Services';
              controller.searchController.clear();
              controller.applyFilters();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Clear Filters',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// Build clinic card
  Widget _buildClinicCard(
    BuildContext context,
    ClinicModel clinic,
    ClinicExplorerController controller,
    bool isDark,
  ) {
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[700];
    final cardColor = isDark ? Colors.grey[850] : Colors.white;
    final chipBgColor = isDark ? Colors.grey[800] : Colors.grey[200];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: cardColor,
      shadowColor: isDark ? Colors.black : Colors.grey.withOpacity(0.3),
      elevation: isDark ? 8 : 4,
      child: InkWell(
        onTap: () => controller.navigateToClinicDetail(clinic),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Clinic image with overlays
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(
                    clinic.image,
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                // Rating badge
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${clinic.rating} (${clinic.reviews})',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Category badge
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.orange,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      clinic.category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Distance badge (if available)
                if (controller._locationService.isPermissionGranted)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.directions_car,
                            color: Colors.white,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            clinic.distance,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Clinic name
                  Text(
                    clinic.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Location and additional info
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: AppColors.orange,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          clinic.location,
                          style: TextStyle(
                            color: subTextColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Text(
                        '${clinic.yearsExperience} years',
                        style: TextStyle(
                          color: subTextColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Opening status (if available)
                  if (clinic.openingHours.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: clinic.isCurrentlyOpen
                            ? Colors.green.withOpacity(0.1)
                            : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        clinic.openingStatus,
                        style: TextStyle(
                          fontSize: 12,
                          color: clinic.isCurrentlyOpen
                              ? Colors.green
                              : Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                  const SizedBox(height: 12),

                  // Services
                  if (clinic.services.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: clinic.services.take(4).map((service) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: chipBgColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            service,
                            style: TextStyle(
                              fontSize: 12,
                              color: textColor,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                  const SizedBox(height: 16),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () =>
                              controller.navigateToClinicDetail(clinic),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: isDark ? 8 : 2,
                          ),
                          child: const Text(
                            'View Details',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Quick call button (if phone available)
                      if (clinic.phone != null)
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.orange),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            onPressed: () {
                              Get.snackbar(
                                'Call Clinic',
                                'Calling ${clinic.phone}',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            },
                            icon: const Icon(Icons.phone,
                                color: AppColors.orange),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterBottomSheet extends StatefulWidget {
  final ClinicExplorerController controller;

  const FilterBottomSheet({super.key, required this.controller});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String tempLocationOption;
  late String tempRegion;
  late List<String> tempSelectedServices;
  late String tempSortOption;
  late double tempMaxDistance;
  String? selectedGovernorate;

  @override
  void initState() {
    super.initState();

    // Initialize temporary values
    if (widget.controller.selectedRegion.value == 'Nearby (Auto-detect)') {
      tempLocationOption = 'Nearby';
    } else if (widget.controller.selectedRegion.value != 'All Regions') {
      tempLocationOption = 'Region';
    } else {
      tempLocationOption = 'All Clinics';
    }

    tempRegion = widget.controller.selectedRegion.value;
    tempSelectedServices =
        widget.controller.selectedService.value == 'All Services'
            ? ['All Services']
            : widget.controller.selectedService.value.split(',');
    tempSortOption = widget.controller.sortOption.value;
    tempMaxDistance = widget.controller.maxDistance.value;

    // Initialize governorate selection
    if (widget.controller.isGovernorate(tempRegion)) {
      selectedGovernorate = tempRegion;
    } else {
      // Check if tempRegion belongs to any governorate
      for (final entry in widget.controller.regionHierarchy.entries) {
        if (entry.value.any((city) => tempRegion.contains(city))) {
          selectedGovernorate = entry.key;
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[700];
    final borderColor = isDark ? Colors.grey[700] : Colors.grey[300];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'Filters',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),

          const SizedBox(height: 24),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location filter
                  Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Location options
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildFilterChip(
                        'All Clinics',
                        tempLocationOption == 'All Clinics',
                        () {
                          setState(() {
                            tempLocationOption = 'All Clinics';
                            tempRegion = 'All Regions';
                            selectedGovernorate = null;
                          });
                        },
                        isDark,
                        borderColor,
                      ),
                      if (widget
                          .controller._locationService.isPermissionGranted)
                        _buildFilterChip(
                          'Nearby',
                          tempLocationOption == 'Nearby',
                          () {
                            setState(() {
                              tempLocationOption = 'Nearby';
                              tempRegion = 'Nearby (Auto-detect)';
                              selectedGovernorate = null;
                            });
                          },
                          isDark,
                          borderColor,
                        ),
                      _buildFilterChip(
                        'Specific Region',
                        tempLocationOption == 'Region',
                        () {
                          setState(() {
                            tempLocationOption = 'Region';
                            if (tempRegion == 'All Regions' &&
                                widget.controller.regions.length > 2) {
                              // Set first governorate if available
                              final governorates = widget.controller.regionHierarchy.keys.toList();
                              if (governorates.isNotEmpty) {
                                selectedGovernorate = governorates.first;
                                tempRegion = governorates.first;
                              }
                            }
                          });
                        },
                        isDark,
                        borderColor,
                      ),
                    ],
                  ),

                  // Distance slider (only show when Nearby is selected)
                  if (tempLocationOption == 'Nearby') ...[
                    const SizedBox(height: 16),
                    Text(
                      'Distance Range',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Slider(
                      value: tempMaxDistance,
                      min: 1.0,
                      max: 100.0,
                      divisions: 99,
                      activeColor: AppColors.orange,
                      label: '${tempMaxDistance.round()}km',
                      onChanged: (value) {
                        setState(() {
                          tempMaxDistance = value;
                        });
                      },
                    ),
                    Text(
                      'Within ${tempMaxDistance.round()}km',
                      style: TextStyle(
                        fontSize: 12,
                        color: subTextColor,
                      ),
                    ),
                  ],

                  // Hierarchical region selection (only show when Region is selected)
                  if (tempLocationOption == 'Region') ...[
                    const SizedBox(height: 16),
                    
                    // Governorate selection
                    Text(
                      'Select Governorate/State',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: borderColor!),
                        borderRadius: BorderRadius.circular(8),
                        color: isDark ? AppColors.lightblack : Colors.grey[50],
                      ),
                      child: Obx(() => DropdownButton<String>(
                            value: selectedGovernorate,
                            isExpanded: true,
                            underline: const SizedBox(),
                            dropdownColor: isDark ? Colors.grey[850] : Colors.white,
                            style: TextStyle(color: textColor),
                            hint: Text('Select Governorate/State', 
                                style: TextStyle(color: subTextColor)),
                            items: [
                              // Add governorates
                              ...widget.controller.regionHierarchy.keys.map((governorate) {
                                return DropdownMenuItem<String>(
                                  value: governorate,
                                  child: Text('🏛️ $governorate (All Cities)'),
                                );
                              }),
                              // Add standalone regions that are not governorates
                              ...widget.controller.regions
                                  .where((region) => 
                                      region != 'All Regions' && 
                                      region != 'Nearby (Auto-detect)' &&
                                      !widget.controller.regionHierarchy.containsKey(region) &&
                                      !widget.controller.regionHierarchy.values
                                          .any((cities) => cities.any((city) => region.contains(city))))
                                  .map((region) {
                                return DropdownMenuItem<String>(
                                  value: region,
                                  child: Text('📍 $region'),
                                );
                              }),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedGovernorate = value;
                                  tempRegion = value;
                                });
                              }
                            },
                          )),
                    ),

                    // City selection (only show if a governorate with cities is selected)
                    if (selectedGovernorate != null && 
                        widget.controller.isGovernorate(selectedGovernorate!)) ...[
                      const SizedBox(height: 16),
                      Text(
                        'Select Specific City (Optional)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: borderColor),
                          borderRadius: BorderRadius.circular(8),
                          color: isDark ? AppColors.lightblack : Colors.grey[50],
                        ),
                        child: DropdownButton<String>(
                          value: widget.controller.getCitiesForGovernorate(selectedGovernorate!)
                              .any((city) => tempRegion.contains(city)) ? tempRegion : null,
                          isExpanded: true,
                          underline: const SizedBox(),
                          dropdownColor: isDark ? Colors.grey[850] : Colors.white,
                          style: TextStyle(color: textColor),
                          hint: Text('All cities in $selectedGovernorate', 
                              style: TextStyle(color: subTextColor)),
                          items: [
                            DropdownMenuItem<String>(
                              value: selectedGovernorate,
                              child: Text('All cities in $selectedGovernorate',
                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            ...widget.controller.getCitiesForGovernorate(selectedGovernorate!)
                                .map((city) {
                              // Find the full location that contains this city
                              final fullLocation = widget.controller.allClinics
                                  .firstWhere((clinic) => clinic.location.contains(city),
                                      orElse: () => widget.controller.allClinics.first)
                                  .location;
                              return DropdownMenuItem<String>(
                                value: fullLocation,
                                child: Text('  • $city'),
                              );
                            }),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                tempRegion = value;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ],

                  const SizedBox(height: 24),

                  // Services filter
                  Text(
                    'Services',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Service chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildMultiSelectChip(
                        'All Services',
                        tempSelectedServices.contains('All Services'),
                        () {
                          setState(() {
                            tempSelectedServices = ['All Services'];
                          });
                        },
                        isDark,
                        borderColor,
                      ),
                      ...widget.controller.availableServices
                          .take(8)
                          .map((service) {
                        return _buildMultiSelectChip(
                          service,
                          tempSelectedServices.contains(service),
                          () {
                            setState(() {
                              if (tempSelectedServices
                                  .contains('All Services')) {
                                tempSelectedServices.remove('All Services');
                              }

                              if (tempSelectedServices.contains(service)) {
                                tempSelectedServices.remove(service);
                                if (tempSelectedServices.isEmpty) {
                                  tempSelectedServices = ['All Services'];
                                }
                              } else {
                                tempSelectedServices.add(service);
                              }
                            });
                          },
                          isDark,
                          borderColor,
                        );
                      }),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Sort options
                  Text(
                    'Sort By',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['Default', 'Nearby', 'Rating', 'Reviews', 'Name']
                        .map((sort) {
                      return _buildFilterChip(
                        sort,
                        tempSortOption == sort,
                        () {
                          setState(() {
                            tempSortOption = sort;
                          });
                        },
                        isDark,
                        borderColor,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Buttons
          Row(
            children: [
              // Reset button
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      tempLocationOption = 'All Clinics';
                      tempRegion = 'All Regions';
                      tempSelectedServices = ['All Services'];
                      tempSortOption = 'Default';
                      tempMaxDistance = 50.0;
                      selectedGovernorate = null;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    side: BorderSide(color: borderColor!),
                    foregroundColor: textColor,
                  ),
                  child: const Text('Reset'),
                ),
              ),

              const SizedBox(width: 16),

              // Apply button
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Apply filters
                    widget.controller.updateFilters(
                      region: tempRegion,
                      service: tempSelectedServices.contains('All Services')
                          ? 'All Services'
                          : tempSelectedServices.join(','),
                      sort: tempSortOption,
                      distance: tempMaxDistance,
                    );

                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: isDark ? 8 : 2,
                  ),
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    bool isSelected,
    VoidCallback onTap,
    bool isDark,
    Color? borderColor,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.orange.withOpacity(isDark ? 0.2 : 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.orange : borderColor!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? AppColors.orange
                : (isDark ? Colors.grey[400] : Colors.grey[700]),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildMultiSelectChip(
    String label,
    bool isSelected,
    VoidCallback onTap,
    bool isDark,
    Color? borderColor,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.orange.withOpacity(isDark ? 0.2 : 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.orange : borderColor!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? AppColors.orange
                : (isDark ? Colors.grey[400] : Colors.grey[700]),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
