import 'package:flutter/material.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/app_fonts.dart';


class AppStyles {
  AppStyles._(); // Private constructor to prevent instantiation

  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(fontSize: AppFonts.s30, fontWeight: AppFonts.bold,color: AppColors.black),
    headlineMedium: const TextStyle().copyWith(fontSize: AppFonts.s22, fontWeight: AppFonts.semiBold,color: AppColors.black),
    headlineSmall: const TextStyle().copyWith(fontSize: AppFonts.s18, fontWeight: AppFonts.semiBold,color: AppColors.black),
    bodyLarge: const TextStyle().copyWith(fontSize: AppFonts.s14, fontWeight: AppFonts.medium,color: AppColors.black),
    bodyMedium: const TextStyle().copyWith(fontSize: AppFonts.s14, fontWeight: AppFonts.regular,color: AppColors.black),
    bodySmall: const TextStyle().copyWith(fontSize: AppFonts.s14, fontWeight: AppFonts.regular,color: AppColors.lightblack),
    labelLarge: const TextStyle().copyWith(fontSize: AppFonts.s12, fontWeight: AppFonts.regular,color: AppColors.black),
    labelMedium: const TextStyle().copyWith(fontSize: AppFonts.s12, fontWeight: AppFonts.regular,color: AppColors.black),
    labelSmall: const TextStyle().copyWith(fontSize: AppFonts.s12, fontWeight: AppFonts.regular,color: AppColors.lightblack),
  );

  static TextTheme darkTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(fontSize: AppFonts.s30, fontWeight: AppFonts.bold,color: AppColors.white),
    headlineMedium: const TextStyle().copyWith(fontSize: AppFonts.s22, fontWeight: AppFonts.semiBold,color: AppColors.white),
    headlineSmall: const TextStyle().copyWith(fontSize: AppFonts.s18, fontWeight: AppFonts.semiBold,color: AppColors.white),
    bodyLarge: const TextStyle().copyWith(fontSize: AppFonts.s14, fontWeight: AppFonts.medium,color: AppColors.white),
    bodyMedium: const TextStyle().copyWith(fontSize: AppFonts.s14, fontWeight: AppFonts.regular,color: AppColors.white),
    bodySmall: const TextStyle().copyWith(fontSize: AppFonts.s14, fontWeight: AppFonts.regular,color: Colors.white70),
    labelLarge: const TextStyle().copyWith(fontSize: AppFonts.s12, fontWeight: AppFonts.regular,color: AppColors.white),
    labelMedium: const TextStyle().copyWith(fontSize: AppFonts.s12, fontWeight: AppFonts.regular,color: AppColors.white),
    labelSmall: const TextStyle().copyWith(fontSize: AppFonts.s12, fontWeight: AppFonts.regular,color: Colors.white70),
  );


}