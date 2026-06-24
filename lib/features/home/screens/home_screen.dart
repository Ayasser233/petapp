import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/core/screens/base_screen.dart';
import 'package:petapp/core/services/auth_service.dart';
import 'package:petapp/core/services/location_service.dart';
import 'package:petapp/core/services/points_service.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/widgets/custom_app_bar.dart';
import 'package:petapp/core/widgets/rewards_card.dart';
import 'package:petapp/di/service_locator.dart';
import 'package:petapp/features/store/controllers/cart_controller.dart';
import 'package:petapp/features/store/controllers/store_controller.dart';
import 'package:petapp/features/store/data/mock_products.dart';
import 'package:petapp/features/store/widgets/product_card.dart';
import 'package:petapp/core/services/global_discount_cache.dart';
import 'package:petapp/features/home/widgets/home_global_discount_banner.dart';
import 'package:petapp/features/vets/models/vet_model.dart';
import 'package:petapp/features/vets/services/vet_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final VetService _vetService = VetService();
  final PointsService _pointsService = sl<PointsService>();
  late final LocationService _locationService;
  final AuthService _authService = Get.find<AuthService>();

  List<VetModel> nearbyVets = [];
  bool _isLoadingVets = true;
  bool _locationDialogShown = false;
  bool _isGuestUser = false;
  /// App-level global discount fetched alongside the vets list.
  Map<String, dynamic>? _globalDiscount;
  bool _globalDiscountAlreadyUsed = false;

  @override
  void initState() {
    super.initState();
    _locationService = Get.put(LocationService());
    _isGuestUser = _authService.authStatus == AuthStatus.guest;
    // Ensure store controllers are available globally
    Get.lazyPut<CartController>(() => CartController(), fenix: true);
    Get.lazyPut<StoreController>(() => StoreController(), fenix: true);

    // ── Get cached discount usage immediately ──
    _globalDiscountAlreadyUsed = _vetService.getCachedGlobalDiscountUsage();

    // ── Show cached discount immediately (before any API call) ──
    GlobalDiscountCache.load().then((cached) {
      if (mounted && cached != null) {
        setState(() => _globalDiscount = cached);
      }
    });

    _initializeHomeScreen();
    _checkDiscountUsage();

    // Re-sort and RE-LOAD whenever GPS delivers the first position
    // This ensures server-side distance calculation is triggered with real coordinates
    _locationService.currentPositionRx.listen((pos) {
      if (mounted) {
        if (pos != null && nearbyVets.isEmpty) {
          _loadNearbyVets();
        } else if (mounted && nearbyVets.isNotEmpty) {
          _sortAndUpdateNearbyVets(nearbyVets);
        }
      }
    });
  }

  Future<void> _checkDiscountUsage() async {
    try {
      final used = await _vetService.hasUserUsedGlobalDiscount();
      if (mounted) {
        setState(() {
          _globalDiscountAlreadyUsed = used;
        });
      }
    } catch (_) {
      // Best effort - keep cached value
    }
  }

  /// Initialize home screen with location and vets
  Future<void> _initializeHomeScreen() async {
    try {
      // Wait a bit for the screen to settle
      await Future.delayed(const Duration(milliseconds: 500));

      // Show location permission dialog on first launch
      if (_locationService.isFirstLaunch && !_locationDialogShown) {
        _locationDialogShown = true;
        final shouldRequestLocation =
            await _locationService.showFirstTimeLocationDialog();

        if (shouldRequestLocation) {
          await _locationService.requestLocationPermission();
        }
      }

      // Load nearby vets
      await _loadNearbyVets();
    } catch (e) {
      throw Exception('Error initializing home screen: $e');
    }
  }

  /// Load nearby vets, calculate distances, and sort nearest-first
  Future<void> _loadNearbyVets() async {
    if (!mounted) return;
    setState(() => _isLoadingVets = true);

    try {
      final pos = _locationService.currentPosition;

      // Load a bigger pool so we can pick the truly closest after sorting.
      // Also send coordinates so the server can pre-sort by nearest distance.
      final response = await _vetService.getVets(
        page: 1,
        limit: 10,
        latitude: pos?.latitude,
        longitude: pos?.longitude,
      );
      final vets = response['vets'] as List<VetModel>;
      // Capture app-level global discount returned alongside vets
      final gd = response['globalDiscount'] as Map<String, dynamic>?;
      if (mounted) {
        if (gd != null) {
          // Active discount — update UI and persist to cache
          setState(() => _globalDiscount = gd);
          GlobalDiscountCache.save(gd);
        } else {
          // Discount was removed from the dashboard — clear cache and hide banner
          setState(() => _globalDiscount = null);
          GlobalDiscountCache.clear();
        }
      }
      if (mounted) {
        _sortAndUpdateNearbyVets(vets);
      }
    } catch (e) {
      // silently ignore – empty state will show
    } finally {
      if (mounted) setState(() => _isLoadingVets = false);
    }
  }

  /// Calculate distances for every vet, sort nearest-first, keep top 5
  void _sortAndUpdateNearbyVets(List<VetModel> vets) {
    if (!mounted) return;

    final pos = _locationService.currentPosition;

    List<VetModel> updated;
    if (pos != null) {
      // Attach computed distance string + raw meters for sorting
      final withDist = vets.map((vet) {
        final lat = vet.latitude;
        final lng = vet.longitude;
        
        // If we don't have coordinates, we can't calculate distance here, 
        // so we use the server's distance or infinity for sorting
        if (lat == null || lng == null) {
          return (vet: vet, meters: double.maxFinite);
        }

        final meters = Geolocator.distanceBetween(pos.latitude, pos.longitude, lat, lng);
        final formatted = _locationService.formatDistance(meters);
        return (vet: vet.copyWith(distance: formatted), meters: meters);
      }).toList();

      withDist.sort((a, b) => a.meters.compareTo(b.meters));
      updated = withDist.take(5).map((e) => e.vet).toList();
    } else {
      updated = vets.take(5).toList();
    }

    setState(() => nearbyVets = updated);
  }

  /// Handle refresh
  Future<void> _handleRefresh() async {
    await _locationService.refreshLocation();
    await _loadNearbyVets();
  }

  void _navigateToVetDetail(VetModel vet) {
    Get.toNamed(
      AppRoutes.vetDetail,
      arguments: vet.toMap(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final localizations = AppLocalizations.of(context);

    return BaseScreen(
      navBarIndex: 0,
      appBar: CustomAppBar(
        showLogo: true,
        isDark: isDark,
        actions: [
          // Cart icon with badge
          Obx(() {
            final cartCtrl = Get.find<CartController>();
            return Stack(
              children: [
                IconButton(
                  onPressed: () => Get.toNamed(AppRoutes.cart),
                  icon: FaIcon(
                    FontAwesomeIcons.cartShopping,
                    size: 20,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                if (cartCtrl.itemCount > 0)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: AppColors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${cartCtrl.itemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }),
          // Location indicator button
          Obx(() => IconButton(
                onPressed: () {
                  if (_locationService.isPermissionGranted) {
                    _handleRefresh();
                  } else {
                    _locationService.requestLocationPermission().then((_) {
                      if (_locationService.isPermissionGranted) {
                        _loadNearbyVets();
                      }
                    });
                  }
                },
                icon: _locationService.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppColors.orange),
                        ),
                      )
                    : FaIcon(
                        _locationService.isPermissionGranted
                            ? FontAwesomeIcons.locationDot
                            : FontAwesomeIcons.locationCrosshairs,
                        color: _locationService.isPermissionGranted
                            ? AppColors.orange
                            : Colors.grey,
                        size: 20,
                      ),
                tooltip: _locationService.isPermissionGranted
                    ? localizations.refreshLocation
                    : localizations.enableLocation,
              )),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Guest user banner
            if (_isGuestUser) _buildGuestBanner(context),

            Expanded(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                color: AppColors.orange,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Location header
                        Obx(() => _buildLocationHeader(
                            context, isDark, localizations)),

                        const SizedBox(height: 16),

                        // ── Promo Banner ──────────────────────────────────
                        _buildPromoBanner(context, isDark),

                        const SizedBox(height: 20),

                        // ── What are you looking for? ─────────────────────
                        Text(
                          'What are you looking for?',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 14),

                        // Services (scrollable horizontal list)
                        SizedBox(
                          height: 100,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _buildServiceItem(context, localizations.vetVisit,
                                  'assets/icons/icons-01.png', isDark,
                                  onTap: () => Get.toNamed(AppRoutes.vetExplorer)),
                              _buildServiceItem(context, 'Aleefy\nPharmacy',
                                  'assets/icons/icons-03.png', isDark,
                                  onTap: () => Get.toNamed(AppRoutes.store)),
                              _buildServiceItem(context, 'Aleefy\nStore',
                                  'assets/icons/icons-02.png', isDark,
                                  onTap: () => Get.toNamed(AppRoutes.store),
                                  highlight: true),
                              _buildServiceItem(context, 'Emergency',
                                  'assets/icons/icons-04.png', isDark,
                                  onTap: () => Get.toNamed(AppRoutes.vetExplorer,
                                      arguments: {'filter': 'emergency'})),
                              _buildServiceItem(context, 'Grooming',
                                  'assets/icons/icons-05.png', isDark,
                                  onTap: () => Get.toNamed(AppRoutes.vetExplorer)),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ── Aleefy Picks ────────────────────────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Aleefy Picks',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                              onPressed: () => Get.toNamed(AppRoutes.store),
                              child: Text(
                                'See more',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: AppColors.orange),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 270,
                          child: _buildAleefyPicks(context, isDark),
                        ),

                        const SizedBox(height: 24),

                        // Search bar
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.vetExplorer,
                                arguments: {'openSearch': true});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.lightblack
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            child: Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.magnifyingGlass,
                                  color:
                                      isDark ? Colors.grey[400] : Colors.grey,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    localizations.searchPlaceholder,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: isDark
                                              ? Colors.grey[400]
                                              : Colors.grey,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ── Global Discount Banner (app-wide, before rewards) ──
                        if (_globalDiscount != null && !_globalDiscountAlreadyUsed) ...[
                          HomeGlobalDiscountBanner(
                              discountData: _globalDiscount!),
                          const SizedBox(height: 20),
                        ],

                        // Rewards Card - Only show for authenticated users
                        if (!_isGuestUser) ...[
                          FutureBuilder<Map<String, dynamic>>(
                            future: _loadUserRewardsData(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container(
                                  height: 150,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppColors.orange,
                                        Color(0xFFF5A623)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.white),
                                  ),
                                );
                              }

                              if (snapshot.hasError) {
                                return Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                        color:
                                            Colors.red.withValues(alpha: 0.3)),
                                  ),
                                  child: Row(
                                    children: [
                                      const FaIcon(FontAwesomeIcons.triangleExclamation,
                                          color: Colors.red),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          localizations.failedToLoadRewardsData,
                                          style: const TextStyle(
                                              color: Colors.red, fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              final userData = snapshot.data;
                              return RewardsCard(
                                points: userData?['points'] ?? 0,
                                vouchers: 0,
                                // Removed vouchers feature
                                onRedeemTap: () =>
                                    Get.toNamed(AppRoutes.pointsHistory),
                                onVouchersTap: null,
                                // Removed vouchers feature
                                onViewHistoryTap: () =>
                                    Get.toNamed(AppRoutes.pointsHistory),
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                        ],

                        // Near You section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              localizations.nearYou,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        isDark ? Colors.white : Colors.black87,
                                  ),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.toNamed(AppRoutes.vetExplorer);
                              },
                              child: Text(
                                localizations.seeAll,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppColors.orange,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Near You cards
                        SizedBox(
                          height: 220,
                          child: _isLoadingVets
                              ? _buildLoadingVets(isDark)
                              : nearbyVets.isEmpty
                                  ? _buildEmptyState(context, isDark)
                                  : ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: nearbyVets.length,
                                      itemBuilder: (context, index) {
                                        final vet = nearbyVets[index];
                                        return _buildNearbyCard(
                                          context,
                                          vet: vet,
                                          isDark: isDark,
                                          onTap: () =>
                                              _navigateToVetDetail(vet),
                                        );
                                      }),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build location header
  Widget _buildLocationHeader(
      BuildContext context, bool isDark, AppLocalizations localizations) {
    if (!_locationService.isPermissionGranted) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.orange.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.orange.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.orange.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const FaIcon(
                FontAwesomeIcons.locationCrosshairs,
                color: AppColors.orange,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).locationAccessDisabled,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.lightorange,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context).enableLocationToFindVets,
                    style: const TextStyle(
                      color: AppColors.lightorange,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => _locationService.requestLocationPermission(),
              style: TextButton.styleFrom(
                backgroundColor: AppColors.orange,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Text(localizations.enable,
                  style: const TextStyle(fontSize: 12)),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.orange.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const FaIcon(
              FontAwesomeIcons.locationDot,
              color: AppColors.orange,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).currentLocation,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _locationService.currentCity.isNotEmpty
                      ? _locationService.currentCity
                      : 'Getting location...',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
          if (_locationService.isLoading)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.orange),
              ),
            )
          else
            IconButton(
              onPressed: _handleRefresh,
              icon: const FaIcon(FontAwesomeIcons.arrowsRotate, size: 18),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
              tooltip: localizations.refreshLocation,
            ),
        ],
      ),
    );
  }

  /// Build loading vets widget
  Widget _buildLoadingVets(bool isDark) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          width: 200,
          margin: EdgeInsets.only(right: index == 2 ? 0 : 16),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.orange),
              ),
              const SizedBox(height: 12),
              Text(
                AppLocalizations.of(context).loadingVets,
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Build empty state
  Widget _buildEmptyState(BuildContext context, bool isDark) {
    final localizations = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            FontAwesomeIcons.locationCrosshairs,
            size: 48,
            color: isDark ? Colors.grey[500] : Colors.grey[400],
          ),
          const SizedBox(height: 12),
          Text(
            'No vets found nearby',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try enabling location or check back later',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isDark ? Colors.grey[500] : Colors.grey[500],
                ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _handleRefresh,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(localizations.retry,
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Compact service item for horizontal layout
  Widget _buildCompactServiceItem(
      BuildContext context, String title, String icon, bool isDark,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 110,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isDark ? AppColors.lightblack : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.2),
                blurRadius: 8,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
          ],
          border: !isDark
              ? Border.all(
                  color: Colors.grey.withValues(alpha: 0.1), width: 1.0)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image container
            Container(
              padding: const EdgeInsets.all(8),
              decoration: !isDark
                  ? BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.orange.withValues(alpha: 0.1),
                    )
                  : null,
              child: Image.asset(
                icon,
                width: 45,
                height: 45,
              ),
            ),
            const SizedBox(height: 6),
            // Title text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 11,
                    ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
  // Build nearby vet card
  Widget _buildNearbyCard(
    BuildContext context, {
    required VetModel vet,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200, // Fixed width for horizontal scrolling
        margin: const EdgeInsets.only(right: 12), // Add spacing between cards
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isDark ? AppColors.lightblack : Colors.white,
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.3)
                  : Colors.grey.withValues(alpha: 0.2),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: _buildVetImage(vet.primaryImage, 110),
                ),
                // Rating Badge
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.star,
                          color: Colors.amber,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          vet.rating.toString(),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Distance badge
                Obx(() {
                  final pos = _locationService.currentPositionRx.value;
                  String displayDistance = vet.distance;

                  if (pos != null && vet.latitude != null && vet.longitude != null) {
                    final meters = Geolocator.distanceBetween(
                      pos.latitude,
                      pos.longitude,
                      vet.latitude!,
                      vet.longitude!,
                    );
                    displayDistance = _locationService.formatDistance(meters);
                  }

                  if (displayDistance.isEmpty || 
                      displayDistance == 'unknown' || 
                      !_locationService.isPermissionGranted) {
                    return const SizedBox.shrink();
                  }

                  return Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.orange.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.locationDot,
                            color: Colors.white,
                            size: 10,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            displayDistance,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
            // Info Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    vet.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  // Specialization/Category
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      vet.category,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.orange,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 3),
                  // Address/Location
                  Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.locationDot,
                        size: 14,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          vet.location,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: isDark
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                    fontSize: 11,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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

  Widget _buildVetImage(String imagePath, double height) {
    // Check if it's a network URL or local asset
    final isNetworkImage = imagePath.startsWith('http://') ||
        imagePath.startsWith('https://') ||
        imagePath.startsWith('www.');

    if (isNetworkImage) {
      return CachedNetworkImage(
        imageUrl: imagePath,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: double.infinity,
          height: height,
          color: Colors.grey[300],
          child: const Center(
            child: CircularProgressIndicator(
              color: AppColors.orange,
              strokeWidth: 2,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: double.infinity,
          height: height,
          color: Colors.grey[300],
          child: const FaIcon(
            FontAwesomeIcons.houseMedical,
            size: 40,
            color: Colors.grey,
          ),
        ),
      );
    } else {
      return Image.asset(
        imagePath,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: height,
            color: Colors.grey[300],
            child: const FaIcon(
              FontAwesomeIcons.houseMedical,
              size: 40,
              color: Colors.grey,
            ),
          );
        },
      );
    }
  }

  /// Build guest user banner
  Widget _buildGuestBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      color: AppColors.orange.withValues(alpha: 0.1),
      child: Row(
        children: [
          const FaIcon(
            FontAwesomeIcons.circleInfo,
            color: AppColors.orange,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              AppLocalizations.of(context).guestBrowsingMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.orange,
                    fontWeight: FontWeight.normal,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.toNamed(AppRoutes.login);
            },
            style: TextButton.styleFrom(
              backgroundColor: AppColors.orange,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              AppLocalizations.of(context).login,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Store helpers ──────────────────────────────────────────────────────────

  /// Promotional banner for the store
  Widget _buildPromoBanner(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.store),
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFEA9249), Color(0xFFF5C518)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Stack(
          children: [
            // Background paw print decorations
            const Positioned(
              right: -10,
              top: -10,
              child: Opacity(
                opacity: 0.12,
                child: Icon(Icons.pets, size: 100,
                    color: Colors.white),
              ),
            ),
            const Positioned(
              right: 60,
              bottom: -5,
              child: Opacity(
                opacity: 0.08,
                child: Icon(Icons.pets, size: 70, color: Colors.white),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Never run out of',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                  ),
                  Text(
                    'your pet essentials',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Get.toNamed(AppRoutes.store),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                      elevation: 0,
                    ),
                    child: const Text(
                      'SHOP',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, letterSpacing: 1),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Single service icon item (scrollable)
  Widget _buildServiceItem(
    BuildContext context,
    String title,
    String iconPath,
    bool isDark, {
    VoidCallback? onTap,
    bool highlight = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: highlight
                    ? AppColors.orange.withValues(alpha: 0.15)
                    : isDark
                        ? AppColors.lightblack
                        : Colors.grey.shade100,
                shape: BoxShape.circle,
                border: highlight
                    ? Border.all(
                        color: AppColors.orange.withValues(alpha: 0.4),
                        width: 1.5)
                    : null,
              ),
              child: Center(
                child: Image.asset(
                  iconPath,
                  width: 34,
                  height: 34,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.pets,
                    size: 28,
                    color: highlight ? AppColors.orange : Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                    fontWeight:
                        highlight ? FontWeight.bold : FontWeight.w500,
                    color: highlight
                        ? AppColors.orange
                        : isDark
                            ? Colors.white
                            : Colors.black87,
                  ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  /// Aleefy Picks horizontal product scroll
  Widget _buildAleefyPicks(BuildContext context, bool isDark) {
    final cartCtrl = Get.find<CartController>();
    final storeCtrl = Get.find<StoreController>();
    final picks = MockProducts.all.take(5).toList();

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: picks.length,
      itemBuilder: (ctx, i) {
        final product = picks[i];
        return Obx(() {
          // find live state from storeCtrl (for favorite toggle)
          final liveProduct = storeCtrl.filteredProducts
              .cast<dynamic>()
              .firstWhere(
                (p) => p.id == product.id,
                orElse: () => product,
              );
          return Padding(
            padding: EdgeInsets.only(right: i == picks.length - 1 ? 0 : 12),
            child: ProductCard(
              product: liveProduct,
              isFavorite: liveProduct.isFavorite,
              isInCart: cartCtrl.isInCart(product.id),
              onAddToCart: () => cartCtrl.addProduct(product),
              onFavoriteToggle: () => storeCtrl.toggleFavorite(product.id),
              onTap: () => Get.toNamed(AppRoutes.store),
              width: 165,
            ),
          );
        });
      },
    );
  }

  /// Load user rewards data from Points API
  Future<Map<String, dynamic>> _loadUserRewardsData() async {
    try {
      final balance = await _pointsService.getPointsBalance();

      return {
        'points': balance['currentBalance'] ?? 0,
        'history': balance['recent'] ?? [],
      };
    } catch (e) {
      return {
        'points': 0,
        'history': [],
      };
    }
  }
}
