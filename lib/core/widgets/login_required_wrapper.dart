import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/core/services/auth_service.dart';
import 'package:petapp/core/utils/app_colors.dart';

class LoginRequiredWrapper extends StatelessWidget {
  final Widget child;
  final Function? onLoginRequired;
  final String? feature;

  const LoginRequiredWrapper({
    super.key, 
    required this.child,
    this.onLoginRequired,
    this.feature,
  });

  void _handleProtectedAction(BuildContext context) async {
    final authService = Get.find<AuthService>();
    
    if (authService.canAccessProtectedFeature()) {
      // User is already logged in, allow the action
      if (onLoginRequired != null) {
        onLoginRequired!();
      }
    } else {
      // Show login prompt
      final shouldLogin = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Required'),
          content: Text(
            feature != null
              ? 'You need to be logged in to use $feature.'
              : 'You need to be logged in to use this feature.'
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orange,
              ),
              child: const Text('Login'),
            ),
          ],
        ),
      ) ?? false;
      
      if (shouldLogin) {
        Get.toNamed(AppRoutes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleProtectedAction(context),
      child: child,
    );
  }
}
