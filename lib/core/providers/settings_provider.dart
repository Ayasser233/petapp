import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart'; // Add this import

enum ThemePreference { light, dark, system }
enum LanguagePreference { english, arabic }

class SettingsProvider extends ChangeNotifier {
  late SharedPreferences _prefs;
  
  // Default values
  ThemePreference _themeMode = ThemePreference.system;
  LanguagePreference _language = LanguagePreference.english;
  bool _notificationsEnabled = true;
  bool _emailNotificationsEnabled = true;
  bool _soundEnabled = true;
  
  // Getters
  ThemePreference get themeMode => _themeMode;
  LanguagePreference get language => _language;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get emailNotificationsEnabled => _emailNotificationsEnabled;
  bool get soundEnabled => _soundEnabled;
  
  // Initialize settings from SharedPreferences
  Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    
    // Load theme preference
    final themeModeString = _prefs.getString('themeMode') ?? 'system';
    if (themeModeString == 'light') {
      _themeMode = ThemePreference.light;
    } else if (themeModeString == 'dark') {
      _themeMode = ThemePreference.dark;
    } else {
      _themeMode = ThemePreference.system;
    }
    
    // Load language preference
    final languageString = _prefs.getString('language') ?? 'english';
    _language = languageString == 'arabic' ? LanguagePreference.arabic : LanguagePreference.english;
    
    // Load notification settings
    _notificationsEnabled = _prefs.getBool('notificationsEnabled') ?? true;
    _emailNotificationsEnabled = _prefs.getBool('emailNotificationsEnabled') ?? true;
    _soundEnabled = _prefs.getBool('soundEnabled') ?? true;
    
    notifyListeners();
  }
  
  // Theme mode methods
  Future<void> setThemeMode(ThemePreference mode) async {
    _themeMode = mode;
    await _prefs.setString('themeMode', mode.toString().split('.').last);
    notifyListeners();
  }
  
  // Language methods
  Future<void> setLanguage(LanguagePreference lang) async {
    _language = lang;
    await _prefs.setString('language', lang.toString().split('.').last);
    
    // Update Get locale immediately
    final newLocale = getLocale();
    Get.updateLocale(newLocale);
    
    notifyListeners();
  }
  
  // Notification methods
  Future<void> setNotificationsEnabled(bool value) async {
    _notificationsEnabled = value;
    await _prefs.setBool('notificationsEnabled', value);
    notifyListeners();
  }
  
  Future<void> setEmailNotificationsEnabled(bool value) async {
    _emailNotificationsEnabled = value;
    await _prefs.setBool('emailNotificationsEnabled', value);
    notifyListeners();
  }
  
  Future<void> setSoundEnabled(bool value) async {
    _soundEnabled = value;
    await _prefs.setBool('soundEnabled', value);
    notifyListeners();
  }
  
  // Get ThemeMode for MaterialApp
  ThemeMode getThemeMode() {
    switch (_themeMode) {
      case ThemePreference.light:
        return ThemeMode.light;
      case ThemePreference.dark:
        return ThemeMode.dark;
      case ThemePreference.system:
      default:
        return ThemeMode.system;
    }
  }
  
  // Get Locale for MaterialApp
  Locale getLocale() {
    switch (_language) {
      case LanguagePreference.arabic:
        return const Locale('ar', '');
      case LanguagePreference.english:
      default:
        return const Locale('en', '');
    }
  }
}