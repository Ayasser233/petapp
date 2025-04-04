import 'package:get/get.dart';

class OnboardingController extends GetxController {
  static OnboardingController get to => Get.find();
  // Define any properties or methods needed for the onboarding process
  final currentPage = 0.obs;

  void updatePage(index) {}

  void doNavigationClick(index) {}

  void skipOnboarding() {}

  void nextOnboarding() {}
}
