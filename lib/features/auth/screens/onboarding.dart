import 'Package:flutter/material.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/app_style.dart';
import 'package:petapp/core/utils/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: SvgPicture.asset(
                  Constants.onboardingImage3,
                  fit: BoxFit.cover,
                  width: double.infinity, // Full width
                  height: 300,
                ),
              )),
          Positioned(
              top: 200, // Adjust position
              left: 0,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Prevent overflow
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Icon(
                          Icons.pets,
                          size: 50,
                          color: AppColors.orange,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Welcome to PetApp',
                          style: AppStyles.headlineMedBlack,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Your one-stop solution for all your pet needs.',
                          style: AppStyles.bodyMedBlack,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            3,
                            (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: index == 1 ? 12 : 8,
                              height: index == 1 ? 12 : 8,
                              decoration: BoxDecoration(
                                color: index == 0
                                    ? AppColors.orange
                                    : AppColors.lightblack,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
