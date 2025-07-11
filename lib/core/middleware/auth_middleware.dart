import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/core/services/auth_service.dart';

class AuthMiddleware extends GetMiddleware {
  final AuthService _authService = Get.find<AuthService>();
  
  @override
  RouteSettings? redirect(String? route) {
    // If trying to access a protected route
    if (_isProtectedRoute(route) && !_authService.canAccessProtectedFeature()) {
      // Show a dialog and redirect to login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.dialog(
          AlertDialog(
            title: const Text('Login Required'),
            content: const Text('You need to be logged in to access this feature.'),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                  // Return to previous screen or go home
                  Get.offNamed(AppRoutes.home);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                  Get.toNamed(AppRoutes.login);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Get.theme.colorScheme.primary,
                ),
                child: const Text('Login'),
              ),
            ],
          ),
        );
      });
      
      // Return to home
      return const RouteSettings(name: AppRoutes.home);
    }
    
    // No redirection needed
    return null;
  }
  
  // Check if a route is protected
  bool _isProtectedRoute(String? route) {
    final protectedRoutes = [
      AppRoutes.addPet,
      AppRoutes.myPets,
      AppRoutes.petProfile,
      AppRoutes.hospitalBooking,
      AppRoutes.accountDetails,
      AppRoutes.pointsHistory,
      AppRoutes.vouchers,
      AppRoutes.redeem,
      // Add other protected routes here
    ];
    
    return protectedRoutes.contains(route);
  }
}
