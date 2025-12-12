import 'package:flutter/material.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/app_fonts.dart';


class AppStyles {
  AppStyles._(); // Private constructor to prevent instantiation

  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(fontSize: AppFonts.s30, fontWeight: AppFonts.bold, color: AppColors.black, fontFamily: AppFonts.fontFamily),
    headlineMedium: const TextStyle().copyWith(fontSize: AppFonts.s22, fontWeight: AppFonts.semiBold, color: AppColors.black, fontFamily: AppFonts.fontFamily),
    headlineSmall: const TextStyle().copyWith(fontSize: AppFonts.s18, fontWeight: AppFonts.semiBold, color: AppColors.black, fontFamily: AppFonts.fontFamily),
    bodyLarge: const TextStyle().copyWith(fontSize: AppFonts.s14, fontWeight: AppFonts.medium, color: AppColors.black, fontFamily: AppFonts.fontFamily),
    bodyMedium: const TextStyle().copyWith(fontSize: AppFonts.s14, fontWeight: AppFonts.regular, color: AppColors.black, fontFamily: AppFonts.fontFamily),
    bodySmall: const TextStyle().copyWith(fontSize: AppFonts.s14, fontWeight: AppFonts.regular, color: AppColors.lightblack, fontFamily: AppFonts.fontFamily),
    labelLarge: const TextStyle().copyWith(fontSize: AppFonts.s12, fontWeight: AppFonts.regular, color: AppColors.black, fontFamily: AppFonts.fontFamily),
    labelMedium: const TextStyle().copyWith(fontSize: AppFonts.s12, fontWeight: AppFonts.regular, color: AppColors.black, fontFamily: AppFonts.fontFamily),
    labelSmall: const TextStyle().copyWith(fontSize: AppFonts.s12, fontWeight: AppFonts.regular, color: AppColors.lightblack, fontFamily: AppFonts.fontFamily),
  );

  static TextTheme darkTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(fontSize: AppFonts.s30, fontWeight: AppFonts.bold, color: AppColors.white, fontFamily: AppFonts.fontFamily),
    headlineMedium: const TextStyle().copyWith(fontSize: AppFonts.s22, fontWeight: AppFonts.semiBold, color: AppColors.white, fontFamily: AppFonts.fontFamily),
    headlineSmall: const TextStyle().copyWith(fontSize: AppFonts.s18, fontWeight: AppFonts.semiBold, color: AppColors.white, fontFamily: AppFonts.fontFamily),
    bodyLarge: const TextStyle().copyWith(fontSize: AppFonts.s14, fontWeight: AppFonts.medium, color: AppColors.white, fontFamily: AppFonts.fontFamily),
    bodyMedium: const TextStyle().copyWith(fontSize: AppFonts.s14, fontWeight: AppFonts.regular, color: AppColors.white, fontFamily: AppFonts.fontFamily),
    bodySmall: const TextStyle().copyWith(fontSize: AppFonts.s14, fontWeight: AppFonts.regular, color: Colors.white70, fontFamily: AppFonts.fontFamily),
    labelLarge: const TextStyle().copyWith(fontSize: AppFonts.s12, fontWeight: AppFonts.regular, color: AppColors.white, fontFamily: AppFonts.fontFamily),
    labelMedium: const TextStyle().copyWith(fontSize: AppFonts.s12, fontWeight: AppFonts.regular, color: AppColors.white, fontFamily: AppFonts.fontFamily),
    labelSmall: const TextStyle().copyWith(fontSize: AppFonts.s12, fontWeight: AppFonts.regular, color: Colors.white70, fontFamily: AppFonts.fontFamily),
  );


}