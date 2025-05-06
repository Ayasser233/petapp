import 'package:flutter/material.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/app_style.dart';

// ignore: camel_case_types
class elevatedButtonTheme{
  elevatedButtonTheme._();

  static final lightElevatedThemeButton = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: AppColors.white,
      backgroundColor: AppColors.orange,
      disabledBackgroundColor: AppColors.lightorange,
      disabledForegroundColor: Colors.grey,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      textStyle: AppStyles.lightTextTheme.bodyMedium
    ),
    );


    static final darkElevatedThemeButton = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: AppColors.white,
      backgroundColor: AppColors.orange,
      disabledBackgroundColor: AppColors.lightorange,
      disabledForegroundColor: Colors.grey,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      textStyle: AppStyles.darkTextTheme.bodyMedium
    ),
    );
}