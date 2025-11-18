import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/core/screens/base_screen.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/widgets/custom_app_bar.dart';
import 'package:petapp/core/widgets/rewards_card.dart';
import 'package:petapp/core/services/location_service.dart';
import 'package:petapp/core/services/auth_service.dart';
import 'package:petapp/core/services/points_service.dart';
import 'package:petapp/features/vets/models/vet_model.dart';
import 'package:petapp/features/vets/services/vet_service.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/di/service_locator.dart';

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

  @override
  void initState() {
    super.initState();
    _locationService = Get.put(LocationService());
    _isGuestUser = _authService.authStatus == AuthStatus.guest;
    _initializeHomeScreen();
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

  /// Load nearby vets
  Future<void> _loadNearbyVets() async {
    if (!mounted) return;

    setState(() {
      _isLoadingVets = true;
    });

    try {
      final vets = await _vetService.getNearByVets();
      if (mounted) {
        setState(() {
          nearbyVets = vets;
        });
      }
    } catch (e) {
      throw Exception('Error loading nearby vets: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingVets = false;
        });
      }
    }
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
                    : Icon(
                        _locationService.isPermissionGranted
                            ? Icons.location_on
                            : Icons.location_off,
                        color: _locationService.isPermissionGranted
                            ? AppColors.orange
                            : Colors.grey,
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

                        // Featured Services Row - All in one row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildCompactServiceItem(
                              context,
                              localizations.vetVisit,
                              'assets/icons/icons-01.png',
                              isDark,
                              onTap: () => Get.toNamed(AppRoutes.vetExplorer),
                            ),
                            _buildCompactServiceItem(
                              context,
                              localizations.animalView3D,
                              'assets/icons/icons-02.png',
                              isDark,
                              onTap: () =>
                                  Get.toNamed(AppRoutes.pet3DModelSelector),
                            ),
                            _buildCompactVaccinationServiceItem(
                              context,
                              localizations.vaccination,
                              Icons.vaccines,
                              isDark,
                              onTap: () => Get.toNamed(
                                  AppRoutes.selectPetForVaccination),
                            ),
                          ],
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
                                Icon(
                                  Icons.search,
                                  color:
                                      isDark ? Colors.grey[400] : Colors.grey,
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
                                      const Icon(Icons.error_outline,
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
                                vouchers: 0, // Removed vouchers feature
                                onRedeemTap: () =>
                                    Get.toNamed(AppRoutes.pointsHistory),
                                onVouchersTap: null, // Removed vouchers feature
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
                                        return Padding(
                                          padding: EdgeInsets.only(
                                            right:
                                                index == nearbyVets.length - 1
                                                    ? 0
                                                    : 16.0,
                                          ),
                                          child: _buildNearbyCard(
                                            context,
                                            vet: vet,
                                            isDark: isDark,
                                            onTap: () =>
                                                _navigateToVetDetail(vet),
                                          ),
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
              child: const Icon(
                Icons.location_off,
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
            child: const Icon(
              Icons.location_on,
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
              icon: const Icon(Icons.refresh, size: 18),
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
                'Loading vets...',
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
          Icon(
            Icons.location_searching,
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
        width: 100,
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

  // Compact vaccination service item
  Widget _buildCompactVaccinationServiceItem(
      BuildContext context, String title, IconData icon, bool isDark,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
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
            // Icon container
            Container(
              padding: const EdgeInsets.all(8),
              decoration: !isDark
                  ? BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.orange.withValues(alpha: 0.1),
                    )
                  : null,
              child: Icon(
                icon,
                size: 45,
                color: AppColors.orange,
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
                  child: _buildVetImage(vet.primaryImage, 120),
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
                        const Icon(
                          Icons.star,
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
              ],
            ),
            // Info Section
            Padding(
              padding: const EdgeInsets.all(10.0),
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
                  const SizedBox(height: 4),
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
                  const SizedBox(height: 4),
                  // Address/Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
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
                          maxLines: 2,
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
      return Image.network(
        imagePath,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: double.infinity,
            height: height,
            color: Colors.grey[300],
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
                color: AppColors.orange,
                strokeWidth: 2,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: height,
            color: Colors.grey[300],
            child: const Icon(
              Icons.local_hospital,
              size: 40,
              color: Colors.grey,
            ),
          );
        },
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
            child: const Icon(
              Icons.local_hospital,
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
          const Icon(
            Icons.info_outline,
            color: AppColors.orange,
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'You\'re browsing as a guest. Some features require login.',
              style: TextStyle(
                color: AppColors.orange,
                fontSize: 14,
                fontWeight: FontWeight.w500,
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
            child: const Text(
              'Login',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Load user rewards data from Points API
  Future<Map<String, dynamic>> _loadUserRewardsData() async {
    try {
      final balance = await _pointsService.getPointsBalance();

      return {
        'points': balance['balance'] ?? balance['points'] ?? 0,
        'history': balance['recent'] ?? [],
      };
    } catch (e) {
      print('❌ Error loading user rewards data: $e');
      return {
        'points': 0,
        'history': [],
      };
    }
  }

  // TODO: Uncomment and implement when APIs are ready
  /*
  /// Load user rewards data from API
  Future<Map<String, dynamic>> _loadUserRewardsData() async {
    try {
      // TODO: Replace with actual API calls
      // final pointsResponse = await ApiService.getUserPoints();
      // final vouchersResponse = await ApiService.getUserVouchers();
      
      // For now, return mock data structure
      return {
        'points': 0, // pointsResponse.data['points']
        'vouchers': 0, // vouchersResponse.data['available_vouchers']
        'history': [], // pointsResponse.data['history']
      };
    } catch (e) {
      print('Error loading user rewards data: $e');
      return {
        'points': 0,
        'vouchers': 0,
        'history': [],
      };
    }
  }

  /// Build rewards card with API data
  Widget _buildRewardsCard() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _loadUserRewardsData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.orange),
            ),
          );
        }
        
        if (snapshot.hasError) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Failed to load rewards data. Please try again.',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          );
        }
        
        final userData = snapshot.data ?? {};
        return RewardsCard(
          points: userData['points'] ?? 0,
          vouchers: userData['vouchers'] ?? 0,
          onRedeemTap: () {
            if (userData['points'] > 0) {
              Get.toNamed('/redeem');
            } else {
              _showNoPointsDialog();
            }
          },
          onVouchersTap: () => Get.toNamed(AppRoutes.vouchers),
          onViewHistoryTap: () => Get.toNamed(AppRoutes.pointsHistory),
        );
      },
    );
  }

  /// Show dialog when user has no points
  void _showNoPointsDialog() {
    final localizations = AppLocalizations.of(Get.context!);
    Get.dialog(
      AlertDialog(
        title: Text(localizations.noPointsAvailable),
        content: Text(localizations.noPointsMessage),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(localizations.ok),
          ),
        ],
      ),
    );
  }
  */
}
