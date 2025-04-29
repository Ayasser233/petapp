import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/routes/routes.dart';

class OnboardingController extends GetxController {
  static OnboardingController get instance => Get.find();

  final pageController = PageController();
  Rx<int> currentPage = 0.obs;

  // Update the current page index
  void updatePage(int index) => currentPage.value = index;

  // Navigate to a specific page when a dot is clicked
  void doNavigationClick(int index) {
    currentPage.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  // Skip to the last page
  void skipOnboarding() {
    currentPage.value = 2; // Assuming the last page is at index 2
    pageController.jumpToPage(2);
  }

  // Navigate to the next page
  void nextOnboarding() {
    if (isLastPage) {
      // Logic to complete onboarding (e.g., navigate to the next screen)
      Get.toNamed(AppRoutes.signUp); // Uncomment and replace with your route
    } else {
      currentPage.value++;
      pageController.nextPage(
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }
  // Check if the current page is the last page
  bool get isLastPage => currentPage.value == 2; // Assuming there are 3 pages
}
