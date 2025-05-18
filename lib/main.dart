import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/themes/app_theme.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:provider/provider.dart';
import 'package:petapp/core/providers/settings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Add this function to reset app state
Future<void> resetAppState() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', false);
  await prefs.setBool('isOnboardingCompleted', false);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Uncomment the next line to reset the app state when you need to test from beginning
  // await resetAppState();
  
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final isOnboardingCompleted = prefs.getBool('isOnboardingCompleted') ?? false;

  String initialRoute;
  if (!isOnboardingCompleted) {
    initialRoute = AppRoutes.onboarding;
  } else if (isLoggedIn) {
    initialRoute = AppRoutes.home;
  } else {
    initialRoute = AppRoutes.signUp;
  }
  
  // Initialize settings provider
  final settingsProvider = SettingsProvider();
  await settingsProvider.initPrefs();
  
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: settingsProvider),
    ],
    child: MyApp(initialRoute: initialRoute),
  ));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({required this.initialRoute, super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pet App',
      themeMode: settingsProvider.getThemeMode(),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      locale: settingsProvider.getLocale(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('ar', ''), // Arabic
      ],
      initialRoute: initialRoute,
      getPages: AppRoutes.getPages,
    );
  }
}
