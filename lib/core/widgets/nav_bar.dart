import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';

class CommonBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CommonBottomNavBar({
    super.key, 
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return BottomNavigationBar(
      backgroundColor: isDark? AppColors.black: AppColors.white,
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.orange,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: currentIndex == 1 ? AppColors.orange : Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.pets, 
              color: currentIndex == 1 ? Colors.white : Colors.grey,
              size: 20,
            ),
          ),
          label: 'My Activity',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      onTap: (index) {
        if (index == currentIndex) return;
        
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
    );
  }
}