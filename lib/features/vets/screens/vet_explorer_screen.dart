import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:easy_debounce/easy_debounce.dart';
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

  // API pagination properties
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxInt totalVets = 0.obs;
  final RxBool hasMorePages = false.obs;
  final RxBool isLoadingMore = false.obs;

  // Price filter properties
  final RxDouble minPrice = 0.0.obs;
  final RxDouble maxPrice = 5000.0.obs;
  final RxInt minExperience = 0.obs;

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  final ScrollController scrollController = ScrollController();

  // Hierarchical regions data structure
  final RxMap<String, List<String>> regionHierarchy =
      <String, List<String>>{}.obs;
  final RxList<String> regions = <String>[].obs;

  // Track if we've preloaded emergency vets on initial all-category load
  bool _hasPreloadedEmergencyVets = false;

  @override
  void onInit() {
    super.onInit();
    _initializeDefaults();
    _initializeFromArguments();
    loadData();

    // Listen to search changes with debounce
    // If user types a query we should search server-side (reset pages and fetch)
    // to cover clinics that are not yet loaded locally. If query is empty we
    // fall back to local filters for faster UX.
    debounce(searchQuery, (_) => _onSearchChanged(),
        time: const Duration(milliseconds: 500));

    // Add scroll listener for pagination
    scrollController.addListener(_onScroll);

    // ── Reactive location listeners ──────────────────────────────────────────
    // When the GPS position first arrives (or updates), recalculate every
    // vet's distance and re-sort the list immediately — no manual refresh needed.
    ever(_locationService.currentPositionRx, (_) async {
      if (allVets.isEmpty) return;
      allVets.value = await _updateVetsWithDistances(allVets.toList());
      applyFilters();
    });

    // When location permission is granted after the screen is open, refresh
    // the regions list (adds "Nearby" option), switch to nearby and re-sort.
    ever(_locationService.isPermissionGrantedRx, (bool granted) {
      if (granted) {
        // Auto-select nearby region now that we have permission
        if (selectedRegion.value == 'allRegions') {
          selectedRegion.value = 'nearbyAutoDetect';
        }
        sortOption.value = 'nearby';
        _updateRegions();
        applyFilters();
      }
    });
  }

  /// Fetch schedule slots and opening info for the provided vets in the
  /// background. Updates `allVets` in-place when each vet's extra info
  /// becomes available and re-applies filters.
  void _fetchSchedulesForVets(List<VetModel> vets) {
    for (final vet in vets) {
      _vetService.getVetScheduleSlots(vet.id).then((slots) async {
        try {
          final openingInfo = await _vetService.getVetOpeningInfo(vet.id);

          // Resolve coordinates from mapUrl if lat/lng missing (fallback)
          double? resolvedLat = vet.latitude;
          double? resolvedLng = vet.longitude;
          String? updatedDistance = vet.distance;

          if ((resolvedLat == null || resolvedLng == null) &&
              vet.mapUrl != null && vet.mapUrl!.isNotEmpty) {
            final coords = await VetModel.resolveMapUrlCoords(vet.mapUrl!);
            if (coords != null) {
              resolvedLat = coords.$1;
              resolvedLng = coords.$2;

              // Recalculate distance immediately if coordinates resolved
              final pos = _locationService.currentPosition;
              if (pos != null) {
                final meters = Geolocator.distanceBetween(
                    pos.latitude, pos.longitude, resolvedLat, resolvedLng);
                updatedDistance = _locationService.formatDistance(meters);
              }
            }
          }

          final updated = vet.copyWith(
            scheduleSlots: slots,
            isAvailable: openingInfo['isOpen'] as bool?,
            openingDaysText: openingInfo['openingDays'] != null &&
                    (openingInfo['openingDays'] as List).isNotEmpty
                ? (openingInfo['openingDays'] as List<String>).join(', ')
                : null,
            latitude: resolvedLat,
            longitude: resolvedLng,
            distance: updatedDistance,
          );

          final idx = allVets.indexWhere((e) => e.id == vet.id);
          if (idx != -1) {
            allVets[idx] = updated;
            // Debounced applyFilters to prevent rapid-fire UI updates
            _debouncedApplyFilters();
          }
        } catch (_) {}
      }).catchError((_) {});
    }
  }

  // Debounce applyFilters for background updates
  final _filterDebouncer = const Duration(milliseconds: 300);

  void _debouncedApplyFilters() {
    // Simple manual debouncing for GetX
    EasyDebounce.debounce(
      'vet-filter-debounce',
      _filterDebouncer,
      () => applyFilters(),
    );
  }

  /// Called when the search query changes (debounced)
  Future<void> _onSearchChanged() async {
    final q = searchQuery.value.trim();
    if (q.isEmpty) {
      // No query -> just apply local filters on loaded data
      applyFilters();
      return;
    }

    // Query present -> perform server-side search across pages
    try {
      // Reset pagination and load page 1 with search param
      currentPage.value = 1;
      _hasPreloadedEmergencyVets = false;
      // Debug
      try {
        print('DEBUG: VetExplorerController._onSearchChanged - performing server search for "$q"');
      } catch (_) {}
      await loadData();
    } catch (e) {
      // Fallback to local filters if network/search fails
      applyFilters();
    }
  }
  
  /// Handle scroll events for pagination
  void _onScroll() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
      // User is near bottom, load more if available
      if (hasMorePages.value && !isLoadingMore.value && !isLoading.value) {
        loadMorePages();
      }
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    scrollController.dispose();
    super.onClose();
  }

  /// Initialize default values
  void _initializeDefaults() {
    selectedCategory.value = 'allCategory';
    selectedService.value = 'allServices';
    sortOption.value = 'nearby';

    // Default to nearby region immediately if location permission is already granted
    if (_locationService.isPermissionGranted) {
      selectedRegion.value = 'nearbyAutoDetect';
    } else {
      selectedRegion.value = 'allRegions';
    }
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
      'emergency',
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
      case 'emergency':
        return AppLocalizations.of(context).emergency;
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

  Future<List<VetModel>> _fetchAllEmergencyVets({
    String? search,
    double? minPrice,
    double? maxPrice,
    int? minExperience,
    double? latitude,
    double? longitude,
  }) async {
    final firstPage = await _vetService.getVets(
      page: 1,
      limit: 10,
      search: search,
      minPrice: minPrice,
      maxPrice: maxPrice,
      minExperience: minExperience,
      hasEmergency: true,
      latitude: latitude,
      longitude: longitude,
    );

    final emergencyVets =
        List<VetModel>.from(firstPage['vets'] as List<VetModel>);
    final emergencyLastPage = firstPage['totalPages'] as int;

    for (int page = 2; page <= emergencyLastPage; page++) {
      final extraPage = await _vetService.getVets(
        page: page,
        limit: 10,
        search: search,
        minPrice: minPrice,
        maxPrice: maxPrice,
        minExperience: minExperience,
        hasEmergency: true,
        latitude: latitude,
        longitude: longitude,
      );
      emergencyVets.addAll(extraPage['vets'] as List<VetModel>);
    }

    return emergencyVets;
  }

  /// Load data from API
  Future<void> loadDataFromApi() async {
    try {
      // Only show full-screen spinner on fresh loads, not when paginating
      if (!isLoadingMore.value) isLoading.value = true;

      // ── Step 1: Wait for Location if Permission Granted ───────────────────
      // If we have permission but no position yet, wait briefly for GPS lock.
      // This ensures distances are available for the very first render.
      if (_locationService.isPermissionGranted &&
          _locationService.currentPosition == null) {
        try {
          // Wait up to 1.5s for a fresh position
          await _locationService.refreshLocation()
              .timeout(const Duration(milliseconds: 1500));
        } catch (_) {
          // Timeout or error: proceed with API call using old or null position
        }
      }

      // Determine if filtering by emergency (from category tab)
      final bool? filterEmergency = selectedCategory.value == 'emergency' ? true : null;

      // Include user coordinates so the server can sort by nearest distance
      final pos = _locationService.currentPosition;

      // Load vets from API
      final response = await _vetService.getVets(
        page: currentPage.value,
        limit: 10,
        search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
        minPrice: minPrice.value > 0 ? minPrice.value : null,
        maxPrice: maxPrice.value < 5000 ? maxPrice.value : null,
        minExperience: minExperience.value > 0 ? minExperience.value : null,
        hasEmergency: filterEmergency,
        latitude: pos?.latitude,
        longitude: pos?.longitude,
      );

      final vets = response['vets'] as List<VetModel>;
      final responseTotalPages = response['totalPages'] as int;

      // During emergency hours in All Category on first load:
      // Preload ALL emergency vets upfront so they appear immediately on top.
      // Don't preload on pagination (page > 1) or if already preloaded.
      List<VetModel> fetchedVets = vets;
      final shouldPreloadEmergencyList =
          currentPage.value == 1 &&
          !_hasPreloadedEmergencyVets &&
          selectedCategory.value == 'allCategory' &&
          THelperFunctions.isEmergencyTime();

      if (shouldPreloadEmergencyList) {
        final emergencyVets = await _fetchAllEmergencyVets(
          search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
          minPrice: minPrice.value > 0 ? minPrice.value : null,
          maxPrice: maxPrice.value < 5000 ? maxPrice.value : null,
          minExperience: minExperience.value > 0 ? minExperience.value : null,
          latitude: pos?.latitude,
          longitude: pos?.longitude,
        );

        // Show: [all emergency vets] + [first page of non-emergency vets for pagination]
        final nonEmergencyVets =
            vets.where((vet) => !vet.hasEmergency).toList();
        fetchedVets = [...emergencyVets, ...nonEmergencyVets];
        // Mark that we've preloaded emergency vets so we don't re-fetch on pagination
        _hasPreloadedEmergencyVets = true;
      }

      // ── Step 2: Synchronous Distance Pre-calculation ─────────────────────
      // We calculate distances for the NEWLY fetched batch before assigning
      // to the UI observables. This prevents the "calculating..." flicker.
      final vetsWithDistances = await _updateVetsWithDistances(fetchedVets);

      if (currentPage.value == 1) {
        allVets.value = vetsWithDistances;
      } else {
        final existingIds = allVets.map((v) => v.id).toSet();
        final uniqueNew =
            vetsWithDistances.where((v) => !existingIds.contains(v.id)).toList();
        allVets.addAll(uniqueNew);
      }

      // Fire-and-forget: fetch schedules/opening info for the newly loaded
      // vets in the background. Note: distances are already done above.
      _fetchSchedulesForVets(vetsWithDistances);

      totalVets.value = response['total'] as int;
      totalPages.value = responseTotalPages;
      currentPage.value = response['page'] as int;
      hasMorePages.value = currentPage.value < totalPages.value;

      // Extract available categories and services from API data
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
      if (!isLoadingMore.value) isLoading.value = false;
    }
  }

  // Mock data loading removed - using API only

  /// Load more pages (pagination)
  Future<void> loadMorePages() async {
    if (!hasMorePages.value || isLoading.value || isLoadingMore.value) return;

    try {
      isLoadingMore.value = true;
      currentPage.value++;
      // During pagination, don't preload emergency vets (only happens on page 1)
      _hasPreloadedEmergencyVets = true;
      await loadDataFromApi();
    } catch (e) {
      // Revert page increment on error
      currentPage.value--;
      Get.snackbar(
        AppLocalizations.of(Get.context!).error,
        'Failed to load more vets',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// Update regions list with Egypt's 28 governorates and parse clinic addresses
  void _updateRegions() {
    // Start with Egypt's governorates (only Cairo and Giza)
    final Map<String, Set<String>> governoratesCities = {};

    // Initialize with available governorates (Cairo and Giza) and their cities using current locale
    final isArabic = EgyptRegions.isArabic;
    final governoratesMap = isArabic ? EgyptRegions.governorates : EgyptRegions.governoratesEn;
    final availableGovernorates = EgyptRegions.getAllGovernorates();

    // Only add Cairo and Giza
    for (final governorate in availableGovernorates) {
      if (governoratesMap.containsKey(governorate)) {
        governoratesCities[governorate] = governoratesMap[governorate]!.toSet();
      }
    }

    // Add additional cities from vet addresses if not already present
    // Only add if the governorate is Cairo or Giza
    for (final vet in allVets) {
      final parsed = EgyptRegions.parseAddress(vet.location);

      if (parsed != null) {
        final governorate = parsed['governorate'];
        final city = parsed['city'];

        if (governorate != null && availableGovernorates.contains(governorate)) {
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

  /// Update vets with calculated distances from current location.
  /// Also attempts to resolve missing coordinates from mapUrl in parallel
  /// to ensure distances are ready for the initial load.
  Future<List<VetModel>> _updateVetsWithDistances(List<VetModel> vets) async {
    try {
      if (!_locationService.isPermissionGranted) return vets;
      final pos = _locationService.currentPosition;
      if (pos == null) return vets;

      // ── Step 1: Parallel Coordinate Resolution ────────────────────────────
      // Identify vets missing lat/lng and attempt resolution in parallel
      final resolveFutures = <Future<void>>[];
      final resolvedVets = List<VetModel>.from(vets);

      for (int i = 0; i < resolvedVets.length; i++) {
        final v = resolvedVets[i];
        if ((v.latitude == null || v.longitude == null) &&
            v.mapUrl != null && v.mapUrl!.isNotEmpty) {
          resolveFutures.add(
            VetModel.resolveMapUrlCoords(v.mapUrl!).then((coords) {
              if (coords != null) {
                resolvedVets[i] = v.copyWith(
                  latitude: coords.$1,
                  longitude: coords.$2,
                );
              }
            }),
          );
        }
      }

      if (resolveFutures.isNotEmpty) {
        // Wait for all resolutions with a strict 2s timeout
        await Future.wait(resolveFutures).timeout(const Duration(seconds: 2));
      }

      // ── Step 2: Synchronous Distance Calculation ─────────────────────────
      return resolvedVets.map((vet) {
        final lat = vet.latitude;
        final lng = vet.longitude;
        if (lat == null || lng == null) return vet;

        final meters = Geolocator.distanceBetween(
            pos.latitude, pos.longitude, lat, lng);

        final formatted = _locationService.formatDistance(meters);

        return vet.copyWith(distance: formatted);
      }).toList();
    } catch (_) {
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
      case 'emergency':
        // Emergency filter is handled by API, so no local filtering needed
        // But we can still filter here as a fallback for already loaded data
        return vets.where((vet) => vet.hasEmergency).toList();
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
    // ── Specific governorate / city ──────────────────────────────────────────
    if (selectedRegion.value != 'allRegions' &&
        selectedRegion.value != 'nearbyAutoDetect') {
      if (isGovernorate(selectedRegion.value)) {
        vets = vets.where((vet) {
          final parsed = EgyptRegions.parseAddress(vet.location);
          if (parsed?['governorate'] != null) {
            return parsed!['governorate'] == selectedRegion.value;
          }
          return vet.location
              .toLowerCase()
              .contains(selectedRegion.value.toLowerCase());
        }).toList();
      } else {
        vets = vets.where((vet) {
          final parsed = EgyptRegions.parseAddress(vet.location);
          if (parsed?['city'] != null) {
            return parsed!['city'] == selectedRegion.value;
          }
          return vet.location
              .toLowerCase()
              .contains(selectedRegion.value.toLowerCase());
        }).toList();
      }
    }

    // Distance-based filtering has been removed per request: do not apply
    // any range/distance cap here. Keep all clinics regardless of meters away.

    return vets;
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
    // You already store a formatted distance string on each vet (e.g. "13km", "500m", "2.5 km").
    // We parse it robustly into meters for correct ordering.
    double parseDistanceMeters(String distanceStr) {
      final raw = distanceStr.trim();
      if (raw.isEmpty || raw == 'unknown' || raw == 'calculating...') {
        return double.maxFinite;
      }

      // Supports Arabic units (كم / م) AND Latin units (km / m)
      // e.g. "1.3 كم", "500 الم", "2.5km", "300m"
      final match = RegExp(
        r'([0-9]+(?:[.,][0-9]+)?)\s*(كم|km|الم|m)',
        caseSensitive: false,
      ).firstMatch(raw.replaceAll(',', '.'));
      if (match == null) return double.maxFinite;

      final value = double.tryParse(match.group(1) ?? '');
      final unit = match.group(2);
      if (value == null || unit == null) return double.maxFinite;

      if (unit == 'كم' || unit.toLowerCase() == 'km') return value * 1000;
      return value; // metres
    }

    int compareByDistance(VetModel a, VetModel b) {
      return parseDistanceMeters(a.distance).compareTo(parseDistanceMeters(b.distance));
    }

    // Emergency priority time window: 10pm -> 7am Africa/Cairo.
    bool shouldPrioritizeEmergencyNow() {
      final nowUtc = DateTime.now().toUtc();
      final cairoNow = nowUtc.add(const Duration(hours: 2));
      final hour = cairoNow.hour;
      return hour >= 22 || hour < 7;
    }

    List<VetModel> applyTimeBasedEmergencyPriorityIfNeeded(List<VetModel> list) {
      if (!shouldPrioritizeEmergencyNow()) {
        list.sort(compareByDistance);
        return list;
      }

      final emergency = <VetModel>[];
      final nonEmergency = <VetModel>[];

      for (final vet in list) {
        (vet.hasEmergency ? emergency : nonEmergency).add(vet);
      }

      emergency.sort(compareByDistance);
      nonEmergency.sort(compareByDistance);

      return [...emergency, ...nonEmergency];
    }

    switch (sortOption.value) {
      case 'nearby':
      case 'default': // default → nearest first
        return applyTimeBasedEmergencyPriorityIfNeeded(vets);
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
        return applyTimeBasedEmergencyPriorityIfNeeded(vets);
    }
  }

  /// Update search query
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  /// Update category selection
  void updateCategory(String category) async {
    final previousCategory = selectedCategory.value;
    selectedCategory.value = category;

    // Reload from API whenever:
    //  - switching TO emergency (needs hasEmergency=true filter)
    //  - switching FROM emergency (emergency dataset only had hasEmergency vets;
    //    we need the full "all vets" pool back)
    if (category == 'emergency' ||
        (previousCategory == 'emergency' && category != 'emergency')) {
      currentPage.value = 1;
      _hasPreloadedEmergencyVets = false;
      await loadData();
    } else {
      applyFilters();
    }
  }

  /// Update filters and apply
  void updateFilters({
    String? region,
    String? service,
    String? sort,
  }) {
    if (region != null) selectedRegion.value = region;
    if (service != null) selectedService.value = service;
    if (sort != null) sortOption.value = sort;
    applyFilters(); // fire-and-forget is fine here
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
    currentPage.value = 1;
    _hasPreloadedEmergencyVets = false;
    // Refresh location first so distances are up-to-date immediately after reload
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
    selectedRegion.value =
        _locationService.isPermissionGranted ? 'nearbyAutoDetect' : 'allRegions';
    selectedService.value = 'allServices';
    sortOption.value = 'nearby';
    searchController.clear();
    currentPage.value = 1;
    _hasPreloadedEmergencyVets = false;
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
          child: Obx(() => CustomScrollView(
            controller: controller.scrollController,
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
                  child: _buildResultsHeader(context, controller),
                ),
              ),

              // Vet list
              _buildVetSliverList(context, controller),

              // Loading indicator at bottom
              _buildLoadingMoreIndicator(controller),
            ],
          )),
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

  /// Build loading more indicator at bottom
  Widget _buildLoadingMoreIndicator(VetExplorerController controller) {
    if (!controller.isLoadingMore.value) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        child: const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.orange),
        ),
      ),
    );
  }
}