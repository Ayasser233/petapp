import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/themes/app_theme.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:provider/provider.dart';
import 'package:petapp/core/providers/settings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/di/service_locator.dart';
import 'package:petapp/core/services/location_service.dart';
import 'package:petapp/core/services/connectivity_service.dart';
import 'package:petapp/core/services/token_service.dart';
import 'package:petapp/features/pet/controllers/pet_controller.dart';

// Add this function to reset app state
Future<void> resetAppState() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', false);
  await prefs.setBool('isOnboardingCompleted', false);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await resetAppState();  
  // Register ConnectivityService with GetX

  // Initialize dependencies
  await setupServiceLocator();

  // Initialize services
  await initServices();

  

  // Initialize settings provider
  final settingsProvider = SettingsProvider();
  await settingsProvider.initPrefs();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: settingsProvider),
    ],
    child: const MyApp(),
  ));
}

/// Initialize all services
Future<void> initServices() async {
  // Initialize location service
  await Get.putAsync(() async => LocationService());
  await Get.putAsync(() async => ConnectivityService());
  
  // Register TokenService with GetX
  Get.put(sl<TokenService>());
  
  // Initialize controllers
  Get.lazyPut(() => sl<PetController>());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late SettingsProvider _settingsProvider;

  @override
  void initState() {
    super.initState();
    // Get the settings provider
    _settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

    // Add listener to update the UI when settings change
    _settingsProvider.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    // Remove listener when widget is disposed
    _settingsProvider.removeListener(_onSettingsChanged);
    super.dispose();
  }

  // This will force the app to rebuild when settings change
  void _onSettingsChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aleefy',
      themeMode: _settingsProvider.getThemeMode(),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      locale: _settingsProvider.getLocale(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: AppRoutes.networkSplash, // Always start with the splash
      getPages: AppRoutes.getPages,
    );
  }
}
