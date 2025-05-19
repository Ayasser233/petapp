import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/themes/app_theme.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:provider/provider.dart';
import 'package:petapp/core/providers/settings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:petapp/core/localization/app_localizations.dart';

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

// Convert to StatefulWidget
class MyApp extends StatefulWidget {
  final String initialRoute;
  
  const MyApp({required this.initialRoute, super.key});

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
      title: 'Pet App',
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
      initialRoute: widget.initialRoute,
      getPages: AppRoutes.getPages,
    );
  }
}
