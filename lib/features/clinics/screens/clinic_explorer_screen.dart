import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/core/services/location_service.dart';
import 'package:petapp/features/clinics/models/clinic_model.dart';
import 'package:petapp/features/clinics/services/clinic_service.dart';
import '../widgets/clinic_explorer_screen_widget/clinic_explorer_header.dart';
import '../widgets/clinic_explorer_screen_widget/clinic_explorer_search_bar.dart';
import '../widgets/clinic_explorer_screen_widget/clinic_explorer_category_tabs.dart';
import '../widgets/clinic_explorer_screen_widget/clinic_explorer_location_banner.dart';
import '../widgets/clinic_explorer_screen_widget/clinic_explorer_filter_sheet.dart';
import '../widgets/clinic_explorer_screen_widget/clinic_explorer_card.dart';

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
  final RxString selectedCategory = ''.obs;
  final RxString selectedRegion = ''.obs;
  final RxString selectedService = ''.obs;
  final RxString sortOption = ''.obs;
  final RxDouble maxDistance = 50.0.obs;

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  // Hierarchical regions data structure
  final RxMap<String, List<String>> regionHierarchy = <String, List<String>>{}.obs;
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
      Get.snackbar(
        AppLocalizations.of(Get.context!).error,
        AppLocalizations.of(Get.context!).failedToLoadClinics,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Update regions list with hierarchical structure based on clinic locations
  void _updateRegions() {
    final Map<String, Set<String>> governoratesCities = {};
    final Set<String> allUniqueRegions = {};

    // Add default options
    regions.value = [
      'allRegions',
      if (_locationService.isPermissionGranted) 'nearbyAutoDetect',
    ];

    // Parse clinic locations to extract governorates and cities
    for (final clinic in allClinics) {
      final locationParts = clinic.location.split(',');
      
      if (locationParts.length >= 2) {
        final city = locationParts[0].trim();
        final governorate = locationParts[1].trim();
        
        if (!governoratesCities.containsKey(governorate)) {
          governoratesCities[governorate] = <String>{};
        }
        
        governoratesCities[governorate]!.add(city);
        allUniqueRegions.add(governorate);
        allUniqueRegions.add(clinic.location);
      } else {
        allUniqueRegions.add(clinic.location);
      }
    }

    // Build hierarchy map
    final Map<String, List<String>> hierarchy = {};
    
    governoratesCities.forEach((governorate, cities) {
      if (cities.length > 1) {
        hierarchy[governorate] = cities.toList()..sort();
      }
    });

    regionHierarchy.value = hierarchy;
    regions.addAll(allUniqueRegions.toList()..sort());
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
      Get.snackbar(
        AppLocalizations.of(Get.context!).error,
        AppLocalizations.of(Get.context!).errorApplyingFilters,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Apply category filter
  List<ClinicModel> _applyCategoryFilter(List<ClinicModel> clinics) {
    switch (selectedCategory.value) {
      case 'popular':
        return clinics.where((clinic) => clinic.rating >= 4.7).toList();
      case 'recommended':
        return clinics.where((clinic) => clinic.reviews >= 200).toList();
      case 'latest':
        return clinics.take(3).toList();
      case 'allCategory':
      default:
        return clinics;
    }
  }

  /// Apply location/region filter with hierarchical support
  Future<List<ClinicModel>> _applyLocationFilter(List<ClinicModel> clinics) async {
    if (selectedRegion.value == 'allRegions') {
      return clinics;
    }

    if (selectedRegion.value == 'nearbyAutoDetect') {
      if (_locationService.isPermissionGranted) {
        return await _clinicService.getClinicsWithinDistance(maxDistance.value);
      } else {
        final granted = await _locationService.requestLocationPermission();
        if (granted) {
          return await _clinicService.getClinicsWithinDistance(maxDistance.value);
        }
      }
      return clinics;
    }

    if (isGovernorate(selectedRegion.value)) {
      return clinics.where((clinic) {
        final locationParts = clinic.location.split(',');
        if (locationParts.length >= 2) {
          final governorate = locationParts[1].trim();
          return governorate == selectedRegion.value;
        }
        return false;
      }).toList();
    } else {
      return clinics.where((clinic) => 
          clinic.location == selectedRegion.value ||
          clinic.location.contains(selectedRegion.value)
      ).toList();
    }
  }

  /// Apply service filter
  List<ClinicModel> _applyServiceFilter(List<ClinicModel> clinics) {
    if (selectedService.value == 'allServices') return clinics;

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
      case 'nearby':
        if (_locationService.isPermissionGranted) {
          return await _clinicService.searchClinics(
            sortBy: 'distance',
            maxDistanceKm: maxDistance.value,
          );
        }
        return clinics;
      case 'rating':
        clinics.sort((a, b) => b.rating.compareTo(a.rating));
        return clinics;
      case 'reviews':
        clinics.sort((a, b) => b.reviews.compareTo(a.reviews));
        return clinics;
      case 'name':
        clinics.sort((a, b) => a.name.compareTo(b.name));
        return clinics;
      default:
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
      ClinicExplorerFilterSheet(controller: this),
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

class ClinicExplorerScreen extends StatelessWidget {
  const ClinicExplorerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ClinicExplorerController());
    final isDark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: ClinicExplorerHeader(controller: controller),
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
                  child: ClinicExplorerLocationBanner(
                    controller: controller,
                  ),
                ),
              ),

              // Search bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ClinicExplorerSearchBar(controller: controller),
                ),
              ),

              // Category tabs
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: ClinicExplorerCategoryTabs(controller: controller),
                ),
              ),

              // Search results header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child: Obx(() => _buildResultsHeader(context, controller)),
                ),
              ),

              // Clinic list
              Obx(() => _buildClinicSliverList(context, controller)),
            ],
          ),
        ),
      ),
    );
  }

  /// Build results header
  Widget _buildResultsHeader(BuildContext context, ClinicExplorerController controller) {
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
          AppLocalizations.of(context).clinicsFound(controller.filteredClinics.length),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.orange,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  /// Build clinic sliver list
  Widget _buildClinicSliverList(BuildContext context, ClinicExplorerController controller) {
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
        child: _buildEmptyState(context, controller),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final clinic = controller.filteredClinics[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClinicExplorerCard(
              clinic: clinic,
              controller: controller,
            ),
          );
        },
        childCount: controller.filteredClinics.length,
      ),
    );
  }

  /// Build empty state
  Widget _buildEmptyState(BuildContext context, ClinicExplorerController controller) {
    final isDark = THelperFunctions.isDarkMode(context);
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
            AppLocalizations.of(context).noClinicsFound,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: textColor,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).tryAdjustingFilters,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: subTextColor,
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: controller.clearAllFilters,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              foregroundColor: Colors.white,
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
    );
  }
}
