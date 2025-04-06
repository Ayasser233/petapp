import 'package:flutter/material.dart';
import 'package:petapp/core/themes/elevated_btn_theme.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/app_style.dart';

class AppTheme{

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    primaryColor: AppColors.orange,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    textTheme: AppStyles.lightTextTheme,
    elevatedButtonTheme: elevatedButtonTheme.lightElevatedThemeButton
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    primaryColor: AppColors.orange,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    textTheme: AppStyles.darkTextTheme,
    elevatedButtonTheme: elevatedButtonTheme.darkElevatedThemeButton
  );
}