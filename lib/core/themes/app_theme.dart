import 'package:flutter/material.dart';
import 'package:petapp/core/themes/elevated_btn_theme.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/app_style.dart';

class AppTheme{

  static ThemeData lightTheme = ThemeData(
    // surfaceTintColor: AppColors.orange,
    useMaterial3: true,
    fontFamily: 'Poppins',
    primaryColor: AppColors.orange,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      surfaceTintColor: Colors.white,
    ),
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    textTheme: AppStyles.lightTextTheme,
    elevatedButtonTheme: elevatedButtonTheme.lightElevatedThemeButton
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    primaryColor: AppColors.orange,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      surfaceTintColor: Colors.black,
    ),
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    textTheme: AppStyles.darkTextTheme,
    elevatedButtonTheme: elevatedButtonTheme.darkElevatedThemeButton
  );
}