import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/core/services/connectivity_service.dart';
import 'package:petapp/core/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:facebook_app_events/facebook_app_events.dart';

class NetworkSplashScreen extends StatefulWidget {
  const NetworkSplashScreen({super.key});

  @override
  State<NetworkSplashScreen> createState() => _NetworkSplashScreenState();
}

class _NetworkSplashScreenState extends State<NetworkSplashScreen>
    with SingleTickerProviderStateMixin {
  final ConnectivityService _connectivityService = Get.find<ConnectivityService>();
  final AuthService _authService = Get.find<AuthService>();
  bool _hasNavigated = false;
  bool _hasConnection = false;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _checkAndNavigate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ← الـ function الجديدة
  Future<void> _requestTrackingPermission() async {
    try {
      final status =
      await AppTrackingTransparency.requestTrackingAuthorization();

      final facebookAppEvents = FacebookAppEvents();

      if (status == TrackingStatus.authorized) {
        await facebookAppEvents.setAdvertiserIdCollectionEnabled(true);
        debugPrint('✅ ATT Authorized');
      } else {
        await facebookAppEvents.setAdvertiserIdCollectionEnabled( false);
        debugPrint('⚠️ ATT Denied - status: $status');
      }
    } catch (e) {
      // على Android هيعدي من هنا عادي بدون error
      debugPrint('ℹ️ ATT not applicable: $e');
    }
  }

  Future<void> _checkAndNavigate() async {
    // استنى الـ animation
    await Future.delayed(const Duration(milliseconds: 2750));

    // ← اطلب ATT permission هنا — بعد الـ animation وقبل الـ navigation
    await _requestTrackingPermission();

    // Check connection
    _hasConnection = await _connectivityService.isConnected();

    if (_hasConnection && !_hasNavigated) {
      _hasNavigated = true;
      final prefs = await SharedPreferences.getInstance();
      final isOnboardingCompleted =
          prefs.getBool('isOnboardingCompleted') ?? false;

      final authStatus = _authService.authStatus;

      if (!isOnboardingCompleted) {
        Get.offAllNamed(AppRoutes.onboarding);
      } else if (authStatus == AuthStatus.authenticated) {
        Get.offAllNamed(AppRoutes.home);
      } else if (authStatus == AuthStatus.guest) {
        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    } else if (!_hasConnection) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Center(
        child: Lottie.asset(
          isDark
              ? 'assets/animations/splash_dark.json'
              : 'assets/animations/splash_light.json',
          width: 350,
          height: 500,
          fit: BoxFit.contain,
          repeat: false,
          animate: true,
          controller: _controller,
          onLoaded: (composition) {
            _controller.duration = composition.duration * 0.75;
            _controller.forward();
          },
        ),
      ),
    );
  }
}