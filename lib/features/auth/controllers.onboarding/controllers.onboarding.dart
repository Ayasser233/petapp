import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  static OnboardingController get instance => Get.find();

  final pageController = PageController();
  // Define any properties or methods needed for the onboarding process
  Rx<int> currentPage = 0.obs;

  void updatePage(index) => currentPage.value = index;

  void doNavigationClick(index) {
   currentPage.value = index;
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  void skipOnboarding() {
    // Logic to skip onboarding
    // For example, navigate to the home screen or set a flag in shared preferences
    currentPage.value = 2; // Assuming the last page is at index 2
    pageController.jumpToPage(2); // Replace with your home screen route
  }

  void nextOnboarding() {
    // Logic to navigate to the next page
    if (currentPage.value == 2) {
      // Get.to(LoginScreen());
    } else {
      currentPage.value++;
      pageController.nextPage(
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }
}
