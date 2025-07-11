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
import 'package:petapp/features/clinic/models/clinic_model.dart';
import 'package:petapp/features/clinic/services/clinic_service.dart';
import 'package:petapp/core/localization/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ClinicService _clinicService = ClinicService();
  late final LocationService _locationService;
  final AuthService _authService = Get.find<AuthService>();
  
  List<ClinicModel> nearbyClinics = [];
  bool _isLoadingClinics = true;
  bool _locationDialogShown = false;
  bool _isGuestUser = false;

  @override
  void initState() {
    super.initState();
    _locationService = Get.put(LocationService());
    _isGuestUser = _authService.authStatus == AuthStatus.guest;
    _initializeHomeScreen();
  }

  /// Initialize home screen with location and clinics
  Future<void> _initializeHomeScreen() async {
    try {
      // Wait a bit for the screen to settle
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Show location permission dialog on first launch
      if (_locationService.isFirstLaunch && !_locationDialogShown) {
        _locationDialogShown = true;
        final shouldRequestLocation = await _locationService.showFirstTimeLocationDialog();
        
        if (shouldRequestLocation) {
          await _locationService.requestLocationPermission();
        }
      }

      // Load nearby clinics
      await _loadNearbyClinics();
    } catch (e) {
      throw Exception('Error initializing home screen: $e');
    }
  }

  /// Load nearby clinics
  Future<void> _loadNearbyClinics() async {
    if (!mounted) return;
    
    setState(() {
      _isLoadingClinics = true;
    });

    try {
      final clinics = await _clinicService.getNearByClinics();
      if (mounted) {
        setState(() {
          nearbyClinics = clinics;
        });
      }
    } catch (e) {
      throw Exception('Error loading nearby clinics: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingClinics = false;
        });
      }
    }
  }

  /// Handle refresh
  Future<void> _handleRefresh() async {
    await _locationService.refreshLocation();
    await _loadNearbyClinics();
  }

  void _navigateToClinicDetail(ClinicModel clinic) {
    Get.toNamed(
      AppRoutes.clinicDetail,
      arguments: clinic.toMap(),
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
                    _loadNearbyClinics();
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
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.orange),
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
                ? 'Refresh location' 
                : 'Enable location',
          )),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Guest user banner
            if (_isGuestUser)
              _buildGuestBanner(context),
              
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
                        Obx(() => _buildLocationHeader(context, isDark, localizations)),

                        const SizedBox(height: 16),

                        // Featured Services Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildServiceItem(
                              context, 
                              localizations.clinicVisit,
                              'assets/icons/icons-01.png',
                              isDark,
                              onTap: () => Get.toNamed(AppRoutes.clinicExplorer)
                            ),
                            _buildServiceItem(
                              context, 
                              localizations.animalView3D, 
                              'assets/icons/icons-02.png',
                              isDark,
                              onTap: () => Get.toNamed(AppRoutes.pet3DModelSelector)
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Search bar
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.clinicExplorer, arguments: {'openSearch': true});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.lightblack : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: isDark ? Colors.grey[400] : Colors.grey,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    localizations.searchPlaceholder,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: isDark ? Colors.grey[400] : Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),

                      // Reusable Rewards Card
                      RewardsCard(
                        points: 3540,
                        vouchers: 3,
                        onRedeemTap: () {
                          // Navigate to redeem screen
                          Get.toNamed('/redeem');
                        },
                        onVouchersTap: () {
                          Get.toNamed(AppRoutes.vouchers);
                        },
                        onViewHistoryTap: () {
                          Get.toNamed(AppRoutes.pointsHistory);
                        },
                      ),
                      
                      const SizedBox(height: 24),

                        // Near You section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              localizations.nearYou,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.toNamed(AppRoutes.clinicExplorer);
                              },
                              child: Text(
                                localizations.seeAll,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                          child: _isLoadingClinics
                              ? _buildLoadingClinics(isDark)
                              : nearbyClinics.isEmpty
                                  ? _buildEmptyState(context, isDark)
                                  : ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: nearbyClinics.length,
                                      itemBuilder: (context, index) {
                                        final clinic = nearbyClinics[index];
                                        return Padding(
                                          padding: EdgeInsets.only(
                                            right: index == nearbyClinics.length - 1 ? 0 : 16.0,
                                          ),
                                          child: _buildNearbyCard(
                                            context,
                                            clinic: clinic,
                                            isDark: isDark,
                                            onTap: () => _navigateToClinicDetail(clinic),
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
  Widget _buildLocationHeader(BuildContext context, bool isDark, AppLocalizations localizations) {
    if (!_locationService.isPermissionGranted) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.orange.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.orange.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.location_off,
                color: AppColors.orange,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Location Access Disabled',
                    style:  TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.lightorange,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Enable location to find nearby clinics',
                    style: TextStyle(
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text('Enable', style: TextStyle(fontSize: 12)),
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
              color: AppColors.orange.withOpacity(0.2),
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
                  'Current Location',
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
              tooltip: 'Refresh location',
            ),
        ],
      ),
    );
  }

  /// Build loading clinics widget
  Widget _buildLoadingClinics(bool isDark) {
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
                'Loading clinics...',
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
            'No clinics found nearby',
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
            child: const Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(
    BuildContext context, 
    String title, 
    String icon,
    bool isDark,
    {VoidCallback? onTap}
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 150,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          // Enhanced background for light theme
          color: isDark 
            ? AppColors.lightblack 
            : Colors.white,
          borderRadius: BorderRadius.circular(16),
          // Enhanced shadow for light theme
          boxShadow: [
            if (!isDark) BoxShadow(
              color: Colors.grey.withOpacity(0.25), // More pronounced shadow
              blurRadius: 12, // Larger blur
              spreadRadius: 1, // Add spread
              offset: const Offset(0, 4), // Deeper shadow
            ),
          ],
          // Add subtle border in light theme for extra definition
          border: !isDark
            ? Border.all(color: Colors.grey.withOpacity(0.1), width: 1.0)
            : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image container with highlight effect
            Container(
              padding: const EdgeInsets.all(12),
              decoration: !isDark ? BoxDecoration(
                // Add a subtle circular background for the icon in light theme
                shape: BoxShape.circle,
                color: AppColors.orange.withOpacity(0.1),
              ) : null,
              child: Image.asset(
                icon,
                width: 70, // Slightly smaller for better proportions
                height: 70,
              ),
            ),
            const SizedBox(height: 8),
            // Title text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black87,
                  letterSpacing: !isDark ? 0.3 : null,
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
    required ClinicModel clinic,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200, // Slightly wider for better content display
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isDark ? AppColors.lightblack : Colors.white,
          boxShadow: [
            BoxShadow(
              color: isDark 
                ? Colors.black.withOpacity(0.2) 
                : Colors.grey.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // Clinic image with rounded corners
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.asset(
                    clinic.image,
                    height: 110,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // Distance indicator
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
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
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white,
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
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Clinic name
                  Text(
                    clinic.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Location
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
                          clinic.location,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Rating
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 16,
                        color: AppColors.orange,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        clinic.rating.toString(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${clinic.reviews})',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
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

  /// Build guest user banner
  Widget _buildGuestBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      color: AppColors.orange.withOpacity(0.1),
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
}
