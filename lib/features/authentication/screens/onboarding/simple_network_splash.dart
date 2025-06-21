import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/core/services/connectivity_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkSplashScreen extends StatefulWidget {
  const NetworkSplashScreen({super.key});

  @override
  State<NetworkSplashScreen> createState() => _NetworkSplashScreenState();
}

class _NetworkSplashScreenState extends State<NetworkSplashScreen>
    with SingleTickerProviderStateMixin {
  final ConnectivityService _connectivityService = Get.find<ConnectivityService>();
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

  Future<void> _checkAndNavigate() async {
    // Optional: Wait a moment to let the animation show
    await Future.delayed(const Duration(milliseconds: 2750));

    // Check connection
    _hasConnection = await _connectivityService.isConnected();

    if (_hasConnection && !_hasNavigated) {
      _hasNavigated = true;
      final prefs = await SharedPreferences.getInstance();
      final isOnboardingCompleted = prefs.getBool('isOnboardingCompleted') ?? false;
      final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

      if (!isOnboardingCompleted) {
        Get.offAllNamed(AppRoutes.onboarding);
      } else if (isLoggedIn) {
        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    } else if (!_hasConnection) {
      setState(() {}); // To update the animation state
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
            _controller.duration = composition.duration * 0.75; // 2x speed
            _controller.forward();
          },
        ),
      ),
    );
  }
}