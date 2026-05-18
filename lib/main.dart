import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:facebook_app_events/facebook_app_events.dart';

import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/core/providers/settings_provider.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/core/services/api_client.dart';
import 'package:petapp/core/services/auth_service.dart';
import 'package:petapp/core/services/connectivity_service.dart';
import 'package:petapp/core/services/error_handler_service.dart';
import 'package:petapp/core/services/image_cache_service.dart';
import 'package:petapp/core/services/location_service.dart';
import 'package:petapp/core/services/token_service.dart';
import 'package:petapp/core/services/activity_lifecycle_manager.dart';
import 'package:petapp/core/services/app_lifecycle_actions.dart';
import 'package:petapp/core/services/notification_service.dart';
import 'package:petapp/core/themes/app_theme.dart';
import 'package:petapp/di/service_locator.dart';
import 'package:petapp/features/pet/controllers/pet_controller.dart';
import 'package:petapp/features/profile/controllers/profile_controller.dart';


import 'firebase_options.dart';

// Add this function to reset app state
Future<void> resetAppState() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', false);
  await prefs.setBool('isOnboardingCompleted', false);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await resetAppState();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance
      .getAPNSToken()
      .then(
        (value) => print("FCM: $value"),
      )
      .catchError((e) => print("FCM error $e"));

  final facebookAppEvents = FacebookAppEvents();
  try {
    await facebookAppEvents.setAutoLogAppEventsEnabled(true);
    await facebookAppEvents.setAdvertiserTracking(enabled: true);
  } catch (e) {
    debugPrint('⚠️ Facebook SDK init skipped: $e');
  }

  // Initialize SharedPreferences once — registered as singleton in GetIt
  final sharedPreferences = await SharedPreferences.getInstance();

  // Initialize dependencies
  await setupServiceLocator(sharedPreferences: sharedPreferences);

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
  // Initialize ErrorHandlerService first
  Get.put(ErrorHandlerService());

  // Initialize ImageCacheService
  Get.put(ImageCacheService());

  // Initialize Activity Lifecycle Manager
  final lifecycleManager = Get.put(ActivityLifecycleManager());
  // onInit() is called automatically by GetX, no need to await it

  // Initialize location service
  await Get.putAsync(() async => LocationService());
  await Get.putAsync(() async => ConnectivityService());

  // Register TokenService with GetX
  Get.put(sl<TokenService>());

  // Register ApiClient with GetX (needed for ClinicService and other services)
  Get.put(sl<ApiClient>());

  // Initialize AuthService
  await Get.putAsync(() async => await sl<AuthService>().init());

  // Initialize NotificationService
  await Get.putAsync(() async => await sl<NotificationService>().init());

  // Initialize App Lifecycle Actions
  final authService = Get.find<AuthService>();
  final connectivityService = Get.find<ConnectivityService>();
  final lifecycleActions = AppLifecycleActions(
    lifecycleManager: lifecycleManager,
    authService: authService,
    connectivityService: connectivityService,
  );
  lifecycleActions.initialize();
  Get.put(lifecycleActions);

  // Initialize controllers
  Get.lazyPut(() => sl<PetController>());
  Get.lazyPut(() => sl<ProfileController>());
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
    // Configure system UI overlay style based on theme
    final isDark = _settingsProvider.getThemeMode() == ThemeMode.dark ||
        (_settingsProvider.getThemeMode() == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: isDark ? Colors.black : Colors.white,
        systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
    );

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
      builder: (context, child) {
        return child!;
        // Wrap the entire app to automatically convert numbers to Arabic numerals
        return _ArabicNumeralWrapper(child: child ?? const SizedBox.shrink());
      },
    );
  }
}

/// Wrapper widget that automatically converts numbers in Text widgets
/// to Arabic numerals when the locale is Arabic
class _ArabicNumeralWrapper extends StatelessWidget {
  final Widget child;

  const _ArabicNumeralWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
