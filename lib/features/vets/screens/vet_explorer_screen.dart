import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/core/services/location_service.dart';
import 'package:petapp/core/constants/egypt_regions.dart';
import 'package:petapp/features/vets/models/vet_model.dart';
import 'package:petapp/features/vets/services/vet_service.dart';
import '../widgets/vet_explorer_screen_widget/vet_explorer_header.dart';
import '../widgets/vet_explorer_screen_widget/vet_explorer_search_bar.dart';
import '../widgets/vet_explorer_screen_widget/vet_explorer_category_tabs.dart';
import '../widgets/vet_explorer_screen_widget/vet_explorer_location_banner.dart';
import '../widgets/vet_explorer_screen_widget/vet_explorer_filter_sheet.dart';
import '../widgets/vet_explorer_screen_widget/vet_explorer_card.dart';

class VetExplorerController extends GetxController {
  final VetService _vetService = VetService();
  final LocationService _locationService = Get.find<LocationService>();

  // Observable properties
  final RxList<VetModel> allVets = <VetModel>[].obs;
  final RxList<VetModel> filteredVets = <VetModel>[].obs;
  final RxList<String> availableCategories = <String>[].obs;
  final RxList<String> availableServices = <String>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = ''.obs;
  final RxString selectedRegion = ''.obs;
  final RxString selectedService = ''.obs;
  final RxString sortOption = ''.obs;
  final RxDouble maxDistance = 50.0.obs;

  // API pagination properties
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxInt totalVets = 0.obs;
  final RxBool hasMorePages = false.obs;

  // Price filter properties
  final RxDouble minPrice = 0.0.obs;
  final RxDouble maxPrice = 5000.0.obs;
  final RxInt minExperience = 0.obs;

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  // Hierarchical regions data structure
  final RxMap<String, List<String>> regionHierarchy =
      <String, List<String>>{}.obs;
  final RxList<String> regions = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeDefaults();
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

  /// Initialize default values
  void _initializeDefaults() {
    selectedCategory.value = 'allCategory';
    selectedRegion.value = 'allRegions';
    selectedService.value = 'allServices';
    sortOption.value = 'default';
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
        sortOption.value = args['sortBy'] == 'distance' ? 'nearby' : 'default';
      }
    }
  }

  /// Get localized categories
  List<String> getLocalizedCategories(BuildContext context) {
    return [
      'allCategory',
      'popular',
      'recommended',
      'latest',
    ];
  }

  /// Get category display name
  String getCategoryDisplayName(BuildContext context, String category) {
    switch (category) {
      case 'allCategory':
        return AppLocalizations.of(context).allCategory;
      case 'popular':
        return AppLocalizations.of(context).popular;
      case 'recommended':
        return AppLocalizations.of(context).recommended;
      case 'latest':
        return AppLocalizations.of(context).latest;
      default:
        return category;
    }
  }

  /// Load all data from API only
  Future<void> loadData() async {
    await loadDataFromApi();
  }

  /// Load data from API
  Future<void> loadDataFromApi() async {
    try {
      isLoading.value = true;

      // Load vets from API
      final response = await _vetService.getVets(
        page: currentPage.value,
        limit: 10,
        search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
        minPrice: minPrice.value > 0 ? minPrice.value : null,
        maxPrice: maxPrice.value < 5000 ? maxPrice.value : null,
        minExperience: minExperience.value > 0 ? minExperience.value : null,
      );

      final vets = response['vets'] as List<VetModel>;


      // Update vets with calculated distances
      final vetsWithDistances = await _updateVetsWithDistances(vets);

      if (currentPage.value == 1) {
        allVets.value = vetsWithDistances;
      } else {
        allVets.addAll(vetsWithDistances);
      }


      totalVets.value = response['total'] as int;
      totalPages.value = response['totalPages'] as int;
      currentPage.value = response['page'] as int;
      hasMorePages.value = currentPage.value < totalPages.value;

      // Extract available categories and services from API data (vets loaded from API)
      _extractCategoriesFromVets();
      _extractServicesFromVets();

      // Update regions with clinic locations
      _updateRegions();

      // Apply initial filters
      applyFilters();

    } catch (e) {
      Get.snackbar(
        AppLocalizations.of(Get.context!).error,
        'Failed to load vets: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Mock data loading removed - using API only

  /// Load more pages (pagination)
  Future<void> loadMorePages() async {
    if (!hasMorePages.value || isLoading.value) return;

    currentPage.value++;
    await loadData();
  }

  /// Update regions list with Egypt's 28 governorates and parse clinic addresses
  void _updateRegions() {
    // Start with Egypt's governorates
    final Map<String, Set<String>> governoratesCities = {};

    // Initialize with Egypt's governorates and their cities using current locale
    final isArabic = EgyptRegions.isArabic;
    final governoratesMap = isArabic ? EgyptRegions.governorates : EgyptRegions.governoratesEn;

    for (final entry in governoratesMap.entries) {
      governoratesCities[entry.key] = entry.value.toSet();
    }

    // Add additional cities from vet addresses if not already present
    for (final vet in allVets) {
      final parsed = EgyptRegions.parseAddress(vet.location);

      if (parsed != null) {
        final governorate = parsed['governorate'];
        final city = parsed['city'];

        if (governorate != null) {
          if (!governoratesCities.containsKey(governorate)) {
            governoratesCities[governorate] = <String>{};
          }

          if (city != null && !governoratesCities[governorate]!.contains(city)) {
            governoratesCities[governorate]!.add(city);
          }
        }
      }
    }

    // Build regions list with default options
    regions.value = [
      'allRegions',
      if (_locationService.isPermissionGranted) 'nearbyAutoDetect',
    ];

    // Add all governorates (sorted)
    final governorateList = governoratesCities.keys.toList()..sort();
    regions.addAll(governorateList);

    // Build hierarchy map
    final Map<String, List<String>> hierarchy = {};
    governoratesCities.forEach((governorate, cities) {
      hierarchy[governorate] = cities.toList()..sort();
    });

    regionHierarchy.value = hierarchy;
  }

  /// Update vets with calculated distances from current location
  Future<List<VetModel>> _updateVetsWithDistances(List<VetModel> vets) async {
    try {
      final currentPosition = _locationService.currentPosition;

      if (currentPosition == null) {
        return vets;
      }


      return vets.map((vet) {
        try {
          if (vet.latitude == null || vet.longitude == null) {
            return vet;
          }

          final distance = vet.calculateDistanceFromCurrentLocation(
            currentPosition.latitude,
            currentPosition.longitude,
          );

          final formattedDistance = distance != null
              ? _locationService.formatDistance(distance)
              : 'Unknown';

          return vet.copyWith(distance: formattedDistance);
        } catch (e) {
          return vet;
        }
      }).toList();
    } catch (e) {
      return vets;
    }
  }

  /// Extract unique categories from loaded vets (API data only)
  void _extractCategoriesFromVets() {
    try {
      final categories = allVets.map((vet) => vet.category).toSet().toList();

      // Add 'All' as first option
      categories.insert(0, 'All');

      availableCategories.value = categories;
    } catch (e) {
      availableCategories.value = ['All'];
    }
  }

  /// Extract unique services from loaded vets (API data only)
  void _extractServicesFromVets() {
    try {
      final services = <String>{};

      for (final vet in allVets) {
        services.addAll(vet.services);
      }

      availableServices.value = services.toList()..sort();
    } catch (e) {
      availableServices.value = [];
    }
  }

  /// Get cities for a specific governorate
  List<String> getCitiesForGovernorate(String governorate) {
    return regionHierarchy[governorate] ?? EgyptRegions.getCitiesForGovernorate(governorate);
  }

  /// Check if a region is a governorate (has sub-cities)
  bool isGovernorate(String region) {
    return EgyptRegions.isGovernorate(region) || regionHierarchy.containsKey(region);
  }

  /// Apply all filters
  Future<void> applyFilters() async {
    try {
      List<VetModel> filtered = List.from(allVets);

      // Ensure distances are updated for all clinics if location is available
      if (_locationService.isPermissionGranted &&
          _locationService.currentPosition != null) {
        filtered = await _updateVetsWithDistances(filtered);
      }

      // Apply search filter (search within API data only)
      if (searchQuery.value.isNotEmpty) {
        filtered = _applySearchFilter(filtered, searchQuery.value);
      }

      // Apply category filter
      filtered = _applyCategoryFilter(filtered);

      // Apply region/location filter
      filtered = await _applyLocationFilter(filtered);

      // Apply service filter
      filtered = _applyServiceFilter(filtered);

      // Apply sorting
      filtered = await _applySorting(filtered);

      filteredVets.value = filtered;
    } catch (e) {
      Get.snackbar(
        AppLocalizations.of(Get.context!).error,
        AppLocalizations.of(Get.context!).errorApplyingFilters,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Apply search/query filter (search within loaded API data)
  List<VetModel> _applySearchFilter(List<VetModel> vets, String query) {
    if (query.isEmpty) return vets;

    final lowerQuery = query.toLowerCase();
    return vets.where((vet) {
      return vet.name.toLowerCase().contains(lowerQuery) ||
          vet.location.toLowerCase().contains(lowerQuery) ||
          vet.description.toLowerCase().contains(lowerQuery) ||
          vet.category.toLowerCase().contains(lowerQuery) ||
          vet.services
              .any((service) => service.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  /// Apply category filter
  List<VetModel> _applyCategoryFilter(List<VetModel> vets) {
    switch (selectedCategory.value) {
      case 'popular':
        return vets.where((vet) => vet.rating >= 4.7).toList();
      case 'recommended':
        return vets.where((vet) => vet.reviews >= 200).toList();
      case 'latest':
        return vets.take(3).toList();
      case 'allCategory':
      default:
        return vets;
    }
  }

  /// Apply location/region filter with hierarchical support and Egypt governorates
  Future<List<VetModel>> _applyLocationFilter(List<VetModel> vets) async {
    if (selectedRegion.value == 'allRegions') {
      return vets;
    }

    if (selectedRegion.value == 'nearbyAutoDetect') {
      if (!_locationService.isPermissionGranted) {
        final granted = await _locationService.requestLocationPermission();
        if (!granted) {
          return vets;
        }
      }

      // Filter by distance using current position (from API data only)
      final currentPosition = _locationService.currentPosition;
      if (currentPosition != null) {
        return vets.where((vet) {
          if (vet.latitude == null || vet.longitude == null) {
            return false;
          }
          final distance = vet.calculateDistanceFromCurrentLocation(
            currentPosition.latitude,
            currentPosition.longitude,
          );
          return distance != null && distance / 1000 <= maxDistance.value;
        }).toList();
      }
      return vets;
    }

    // Check if it's a governorate filter
    if (isGovernorate(selectedRegion.value)) {
      return vets.where((vet) {
        final parsed = EgyptRegions.parseAddress(vet.location);
        if (parsed != null && parsed['governorate'] != null) {
          return parsed['governorate'] == selectedRegion.value;
        }

        // Fallback: check if location contains governorate name
        return vet.location.toLowerCase().contains(selectedRegion.value.toLowerCase());
      }).toList();
    } else {
      // Filter by specific city/district
      return vets.where((vet) {
        final parsed = EgyptRegions.parseAddress(vet.location);
        if (parsed != null && parsed['city'] != null) {
          return parsed['city'] == selectedRegion.value;
        }

        // Fallback: check if location contains city name
        return vet.location.toLowerCase().contains(selectedRegion.value.toLowerCase());
      }).toList();
    }
  }

  /// Apply service filter
  List<VetModel> _applyServiceFilter(List<VetModel> vets) {
    if (selectedService.value == 'allServices') return vets;

    final selectedServices = selectedService.value.split(',');
    return vets.where((vet) {
      return selectedServices.any((service) => vet.services.any((vetService) =>
          vetService.toLowerCase().contains(service.toLowerCase())));
    }).toList();
  }

  /// Apply sorting
  Future<List<VetModel>> _applySorting(List<VetModel> vets) async {
    switch (sortOption.value) {
      case 'nearby':
        if (_locationService.isPermissionGranted &&
            _locationService.currentPosition != null) {
          // Sort by distance (already calculated in vets from API data)
          vets.sort((a, b) {
            // Extract numeric value from distance string (e.g., "2.5 km" -> 2.5)
            double getDistanceValue(String distanceStr) {
              if (distanceStr == 'Unknown' || distanceStr == 'Calculating...') {
                return double.maxFinite;
              }
              final parts = distanceStr.split(' ');
              if (parts.isEmpty) return double.maxFinite;
              try {
                final value = double.parse(parts[0]);
                // Convert meters to km if needed
                if (parts.length > 1 && parts[1].toLowerCase() == 'm') {
                  return value / 1000;
                }
                return value;
              } catch (e) {
                return double.maxFinite;
              }
            }

            return getDistanceValue(a.distance)
                .compareTo(getDistanceValue(b.distance));
          });
        }
        return vets;
      case 'rating':
        vets.sort((a, b) => b.rating.compareTo(a.rating));
        return vets;
      case 'reviews':
        vets.sort((a, b) => b.reviews.compareTo(a.reviews));
        return vets;
      case 'name':
        vets.sort((a, b) => a.name.compareTo(b.name));
        return vets;
      default:
        vets.sort((a, b) => b.rating.compareTo(a.rating));
        return vets;
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
      VetExplorerFilterSheet(controller: this),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  /// Navigate to vet detail
  void navigateToVetDetail(VetModel vet) {
    Get.toNamed(AppRoutes.vetDetail, arguments: vet.toMap());
  }

  /// Refresh data including location
  Future<void> refreshData() async {
    currentPage.value = 1; // Reset to first page
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

  /// Clear all filters
  void clearAllFilters() {
    searchQuery.value = '';
    selectedCategory.value = 'allCategory';
    selectedRegion.value = 'allRegions';
    selectedService.value = 'allServices';
    sortOption.value = 'default';
    searchController.clear();
    applyFilters();
  }
}

class VetExplorerScreen extends StatelessWidget {
  const VetExplorerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VetExplorerController());
    final isDark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: VetExplorerHeader(controller: controller),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.refreshData,
          color: AppColors.orange,
          child: CustomScrollView(
            slivers: [
              // Location status banner
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: VetExplorerLocationBanner(
                    controller: controller,
                  ),
                ),
              ),

              // Search bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: VetExplorerSearchBar(controller: controller),
                ),
              ),

              // Category tabs
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: VetExplorerCategoryTabs(controller: controller),
                ),
              ),

              // Search results header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child: Obx(() => _buildResultsHeader(context, controller)),
                ),
              ),

              // Vet list
              Obx(() => _buildVetSliverList(context, controller)),
            ],
          ),
        ),
      ),
    );
  }

  /// Build results header
  Widget _buildResultsHeader(
      BuildContext context, VetExplorerController controller) {
    final isDark = THelperFunctions.isDarkMode(context);
    final textColor = isDark ? Colors.white : Colors.black;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context).searchResult,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
        ),
        Text(
          AppLocalizations.of(context)
              .vetsFound(controller.filteredVets.length),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.orange,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  /// Build vet sliver list
  Widget _buildVetSliverList(
      BuildContext context, VetExplorerController controller) {
    if (controller.isLoading.value) {
      return const SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.orange),
          ),
        ),
      );
    }

    if (controller.filteredVets.isEmpty) {
      return SliverFillRemaining(
        child: _buildEmptyState(context, controller),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final vet = controller.filteredVets[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: VetExplorerCard(
              vet: vet,
              controller: controller,
            ),
          );
        },
        childCount: controller.filteredVets.length,
      ),
    );
  }

  /// Build empty state
  Widget _buildEmptyState(
      BuildContext context, VetExplorerController controller) {
    final isDark = THelperFunctions.isDarkMode(context);
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[700];

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search_off,
                size: 64,
                color: subTextColor,
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context).noVetsFound,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: textColor,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context).tryAdjustingFilters,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: subTextColor,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: controller.clearAllFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context).clearFilters,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
