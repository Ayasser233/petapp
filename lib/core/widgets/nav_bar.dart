import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Add this import
import 'package:get/get.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart'; // Add this import

class CommonBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CommonBottomNavBar({
    super.key, 
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final backgroundColor = isDark ? AppColors.black : AppColors.white;
    final localizations = AppLocalizations.of(context); // Get localizations
    
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: backgroundColor,
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.orange,
          unselectedItemColor: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          items: [
            _buildNavItem(Icons.home_outlined, Icons.home, 'Home', 0),
            _buildCenterNavItem('My Activity', 1),
            _buildNavItem(Icons.person_outline, Icons.person, 'Profile', 2),
          ],
          // Then modify the onTap method:
          onTap: (index) {
            if (index == currentIndex) return;
            
            // Add haptic feedback
            HapticFeedback.lightImpact();
            
            switch (index) {
              case 0:
                Get.offAllNamed(AppRoutes.home);
                break;
              case 1:
                Get.offAllNamed(AppRoutes.activity);
                break;
              case 2:
                Get.offAllNamed(AppRoutes.profile);
                break;
            }
          },
        ),
      ),
    );
  }
  
  BottomNavigationBarItem _buildNavItem(IconData inactiveIcon, IconData activeIcon, String label, int index) {
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: currentIndex == index ? AppColors.lightorange.withOpacity(0.3) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(currentIndex == index ? activeIcon : inactiveIcon),
      ),
      label: label,
    );
  }
  
  BottomNavigationBarItem _buildCenterNavItem(String label, int index) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: currentIndex == index 
                ? [AppColors.orange, AppColors.orange.withOpacity(0.8)]
                : [Colors.grey.shade300, Colors.grey.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: currentIndex == index ? [
            BoxShadow(
              color: AppColors.orange.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, 2),
            ),
          ] : [],
        ),
        child: Icon(
          Icons.pets, 
          color: currentIndex == index ? Colors.white : Colors.grey,
          size: 22,
        ),
      ),
      label: label,
    );
  }
}
