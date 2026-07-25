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
import 'package:petapp/core/services/global_discount_cache.dart';
import 'package:petapp/features/home/widgets/home_global_discount_banner.dart';
import 'package:petapp/features/home/widgets/home_guest_banner.dart';
import 'package:petapp/features/home/widgets/home_location_header.dart';
import 'package:petapp/features/home/widgets/home_promo_banner.dart';
import 'package:petapp/features/home/widgets/home_services_row.dart';
import 'package:petapp/features/home/widgets/home_section_header.dart';
import 'package:petapp/features/home/widgets/home_aleefy_picks_section.dart';
import 'package:petapp/features/home/widgets/home_vet_search_bar.dart';
import 'package:petapp/features/home/widgets/home_nearby_vets_section.dart';
import 'package:petapp/features/vets/models/vet_model.dart';
import 'package:petapp/features/vets/services/vet_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ── Services & controllers ──────────────────────────────────────────────────
  final VetService _vetService = VetService();
  final PointsService _pointsService = sl<PointsService>();
  late final LocationService _locationService;
  final AuthService _authService = Get.find<AuthService>();

  // ── State ───────────────────────────────────────────────────────────────────
  List<VetModel> nearbyVets = [];
  bool _isLoadingVets = true;
  bool _locationDialogShown = false;
  bool _isGuestUser = false;
  Map<String, dynamic>? _globalDiscount;
  bool _globalDiscountAlreadyUsed = false;

  // ── Lifecycle ───────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _locationService = Get.put(LocationService());
    _isGuestUser = _authService.authStatus == AuthStatus.guest;

    // Ensure store controllers are available globally
    Get.lazyPut<CartController>(() => CartController(), fenix: true);
    Get.lazyPut<StoreController>(() => StoreController(), fenix: true);

    _globalDiscountAlreadyUsed = _vetService.getCachedGlobalDiscountUsage();

    // Show cached discount immediately (before any API call)
    GlobalDiscountCache.load().then((cached) {
      if (mounted && cached != null) {
        setState(() => _globalDiscount = cached);
      }
    });

    _initializeHomeScreen();
    _checkDiscountUsage();

    // Re-sort and reload whenever GPS delivers the first position
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

  // ── Data loading ────────────────────────────────────────────────────────────

  Future<void> _checkDiscountUsage() async {
    try {
      final used = await _vetService.hasUserUsedGlobalDiscount();
      if (mounted) setState(() => _globalDiscountAlreadyUsed = used);
    } catch (_) {}
  }

  Future<void> _initializeHomeScreen() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      if (_locationService.isFirstLaunch && !_locationDialogShown) {
        _locationDialogShown = true;
        final shouldRequest =
            await _locationService.showFirstTimeLocationDialog();
        if (shouldRequest) {
          await _locationService.requestLocationPermission();
        }
      }
      await _loadNearbyVets();
    } catch (e) {
      throw Exception('Error initializing home screen: $e');
    }
  }

  Future<void> _loadNearbyVets() async {
    if (!mounted) return;
    setState(() => _isLoadingVets = true);
    try {
      final pos = _locationService.currentPosition;
      final response = await _vetService.getVets(
        page: 1,
        limit: 10,
        latitude: pos?.latitude,
        longitude: pos?.longitude,
      );
      final vets = response['vets'] as List<VetModel>;
      final gd = response['globalDiscount'] as Map<String, dynamic>?;
      if (mounted) {
        if (gd != null) {
          setState(() => _globalDiscount = gd);
          GlobalDiscountCache.save(gd);
        } else {
          setState(() => _globalDiscount = null);
          GlobalDiscountCache.clear();
        }
        _sortAndUpdateNearbyVets(vets);
      }
    } catch (_) {
      // silently ignore — empty state will show
    } finally {
      if (mounted) setState(() => _isLoadingVets = false);
    }
  }

  void _sortAndUpdateNearbyVets(List<VetModel> vets) {
    if (!mounted) return;
    final pos = _locationService.currentPosition;
    List<VetModel> updated;
    if (pos != null) {
      final withDist = vets.map((vet) {
        final lat = vet.latitude;
        final lng = vet.longitude;
        if (lat == null || lng == null) {
          return (vet: vet, meters: double.maxFinite);
        }
        final meters = Geolocator.distanceBetween(
            pos.latitude, pos.longitude, lat, lng);
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

  Future<void> _handleRefresh() async {
    await _locationService.refreshLocation();
    await _loadNearbyVets();
  }

  void _navigateToVetDetail(VetModel vet) {
    Get.toNamed(AppRoutes.vetDetail, arguments: vet.toMap());
  }

  Future<Map<String, dynamic>> _loadUserRewardsData() async {
    try {
      final balance = await _pointsService.getPointsBalance();
      return {
        'points': balance['currentBalance'] ?? 0,
        'history': balance['recent'] ?? [],
      };
    } catch (_) {
      return {'points': 0, 'history': []};
    }
  }

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final l10n = AppLocalizations.of(context);

    return BaseScreen(
      navBarIndex: 0,
      appBar: CustomAppBar(
        showLogo: true,
        isDark: isDark,
        actions: [
          // Cart icon with reactive badge
          Obx(() {
            final cartCtrl = Get.find<CartController>();
            return Stack(
              children: [
                IconButton(
                  onPressed: () => Get.toNamed(AppRoutes.cart),
                  icon: FaIcon(FontAwesomeIcons.cartShopping,
                      size: 20,
                      color: isDark ? Colors.white : Colors.black87),
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
                          shape: BoxShape.circle),
                      child: Center(
                        child: Text(
                          '${cartCtrl.itemCount}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold),
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
                    _locationService
                        .requestLocationPermission()
                        .then((_) {
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
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.orange),
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
                    ? l10n.refreshLocation
                    : l10n.enableLocation,
              )),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── Guest banner ─────────────────────────────────────────
            if (_isGuestUser) const HomeGuestBanner(),

            Expanded(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                color: AppColors.orange,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Location header ────────────────────────────
                        HomeLocationHeader(onRefresh: _handleRefresh),
                        const SizedBox(height: 16),

                        // ── Promo banner ───────────────────────────────
                        const HomePromoBanner(),
                        const SizedBox(height: 20),

                        // ── Services row ───────────────────────────────
                        Text(
                          'What are you looking for?',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 14),
                        const HomeServicesRow(),
                        const SizedBox(height: 24),

                        // ── Aleefy Picks ───────────────────────────────
                        HomeSectionHeader(
                          title: 'Aleefy Picks',
                          seeAllLabel: 'See more',
                          onSeeAll: () => Get.toNamed(AppRoutes.store),
                        ),
                        const SizedBox(height: 10),
                        const SizedBox(
                          height: 310,
                          child: HomeAleefyPicksSection(),
                        ),
                        const SizedBox(height: 24),

                        // ── Vet search bar ─────────────────────────────
                        HomeVetSearchBar(
                          onTap: () => Get.toNamed(
                              AppRoutes.vetExplorer,
                              arguments: {'openSearch': true}),
                        ),
                        const SizedBox(height: 24),

                        // ── Global discount banner ─────────────────────
                        if (_globalDiscount != null &&
                            !_globalDiscountAlreadyUsed) ...[
                          HomeGlobalDiscountBanner(
                              discountData: _globalDiscount!),
                          const SizedBox(height: 20),
                        ],

                        // ── Rewards card (auth users only) ─────────────
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
                                    borderRadius:
                                        BorderRadius.circular(16),
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
                                    color: Colors.red
                                        .withValues(alpha: 0.1),
                                    borderRadius:
                                        BorderRadius.circular(16),
                                    border: Border.all(
                                        color: Colors.red
                                            .withValues(alpha: 0.3)),
                                  ),
                                  child: Row(
                                    children: [
                                      const FaIcon(
                                          FontAwesomeIcons
                                              .triangleExclamation,
                                          color: Colors.red),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          l10n.failedToLoadRewardsData,
                                          style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 14),
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
                                onRedeemTap: () => Get.toNamed(
                                    AppRoutes.pointsHistory),
                                onVouchersTap: null,
                                onViewHistoryTap: () => Get.toNamed(
                                    AppRoutes.pointsHistory),
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                        ],

                        // ── Near You section ───────────────────────────
                        HomeSectionHeader(
                          title: l10n.nearYou,
                          seeAllLabel: l10n.seeAll,
                          onSeeAll: () =>
                              Get.toNamed(AppRoutes.vetExplorer),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 220,
                          child: HomeNearbyVetsSection(
                            isLoading: _isLoadingVets,
                            vets: nearbyVets,
                            onVetTap: _navigateToVetDetail,
                            onRefresh: _handleRefresh,
                          ),
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
}