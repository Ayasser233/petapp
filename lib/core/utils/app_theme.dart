import 'package:flutter/material.dart';
import 'package:petapp/core/utils/app_style.dart';

class AppTheme{

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    primaryColor: Colors.blue,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
      headlineLarge: AppStyles.headlineLargeBlack,
      headlineMedium: AppStyles.headlineMedBlack,
    ),
    
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    primaryColor: Colors.blue,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
      headlineLarge: AppStyles.headlineLargeWhite,
      headlineMedium: AppStyles.headlineMedWhite,
    ),
  );
}