import 'package:get/get.dart';
import '../../controllers.onboarding/controllers.onboarding.dart';
import 'Package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePage,
            children: const [
              OnBoardingPage(
                  image: Constants.onboardingImage1,
                  title: 'Find Your Pet',
                  subtitle:
                      'Find your perfect pet match with our advanced search and filter options.'),
              OnBoardingPage(
                  image: Constants.onboardingImage2,
                  title: 'Adopt a Pet',
                  subtitle: 'Adopt a pet and give them a loving home.'),
              OnBoardingPage(
                  image: Constants.onboardingImage3,
                  title: 'Pet Care',
                  subtitle:
                      'Get tips and advice on how to care for your new pet.'),
            ],
          ),

          // Skip button
          const OnBoardingSkip(),

          // Dots navigation Smooth Page Indicator
          const OnBoardingDots(),

          // Next Circular button
          const OnBoardingBtn(),
        ],
      ),
    );
  }
}

class OnBoardingBtn extends StatelessWidget {
  const OnBoardingBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Positioned(
      bottom: kBottomNavigationBarHeight,
      right: 24,
      child: ElevatedButton(
        onPressed: () => OnboardingController.instance.nextOnboarding(),
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: dark ? AppColors.orange : AppColors.black,
        ),
        child: const Icon(Iconsax.arrow_right_3), // Arrow icon
      ),
    );
  }
}

class OnBoardingDots extends StatelessWidget {
  const OnBoardingDots({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingController.instance;
    final dark = THelperFunctions.isDarkMode(context);
    return Positioned(
     
      bottom: kBottomNavigationBarHeight + 20 ,
      left: 24,
      child: SmoothPageIndicator(
        count: 3,
        controller: controller.pageController,
        onDotClicked: controller.doNavigationClick,
        effect: ExpandingDotsEffect(
          dotHeight: 6,
          activeDotColor: dark ? AppColors.white : AppColors.black,
        ),
      ),
    );
  }
}

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: kTextTabBarHeight,
      right: 24,
      child: TextButton(
        onPressed: () => OnboardingController.instance.skipOnboarding(),
        style: TextButton.styleFrom(
          foregroundColor: THelperFunctions.isDarkMode(context)
              ? AppColors.white
              : AppColors.black,
        ),
        child: const Text(
          'Skip',
        ),
      ),
    );
  }
}

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  final String image, title, subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SvgPicture.asset(
            image,
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.6,
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
