import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/themes/app_theme.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final isOnboardingCompleted = prefs.getBool('isOnboardingCompleted') ?? false;
  runApp(MyApp(initialRoute: isOnboardingCompleted ? AppRoutes.signUp : AppRoutes.onboarding));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({required this.initialRoute, super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pet App',
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: initialRoute, // Set the initial route
      getPages: AppRoutes.getPages, // Use the centralized routes
    );
  }
}
