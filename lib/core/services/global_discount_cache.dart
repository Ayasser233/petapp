import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the app-level `globalDiscount` object so it can be shown
/// immediately on the home screen (before the vets API responds).
///
/// Lifecycle:
///   - [save]  — called whenever the API returns an active discount
///   - [load]  — called at app launch to restore the cached value instantly
///   - [clear] — called when the API returns no active discount (removed from dashboard)
class GlobalDiscountCache {
  GlobalDiscountCache._();

  static const _key = 'global_discount_cache';

  /// Persist [data] to SharedPreferences.
  static Future<void> save(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, jsonEncode(data));
    } catch (e) {
      debugPrint('GlobalDiscountCache.save: $e');
    }
  }

  /// Return the last-saved discount, or `null` if nothing is cached.
  static Future<Map<String, dynamic>?> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);
      if (raw == null) return null;
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (e) {
      debugPrint('GlobalDiscountCache.load: $e');
    }
    return null;
  }

  /// Remove the persisted discount (called when backend deactivates / removes it).
  static Future<void> clear() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_key);
    } catch (e) {
      debugPrint('GlobalDiscountCache.clear: $e');
    }
  }
}
