import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataCacheService {
  // Cache data with expiration
  Future<bool> cacheData(String key, dynamic data, {Duration? expiration}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Convert data to JSON string
      final jsonString = jsonEncode(data);
      
      // Set expiration timestamp
      final timestamp = DateTime.now().add(expiration ?? const Duration(hours: 1))
          .millisecondsSinceEpoch;
      
      // Save data and timestamp
      await prefs.setString('cache_$key', jsonString);
      await prefs.setInt('cache_time_$key', timestamp);
      
      return true;
    } catch (e) {
      debugPrint('Error caching data: $e');
      return false;
    }
  }
  
  // Get cached data if not expired
  Future<T?> getCachedData<T>(String key, {T Function(Map<String, dynamic>)? fromJson}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Check if cache exists and is not expired
      final cacheTimeKey = 'cache_time_$key';
      if (!prefs.containsKey(cacheTimeKey)) return null;
      
      final expiry = prefs.getInt(cacheTimeKey);
      if (expiry == null || expiry < DateTime.now().millisecondsSinceEpoch) {
        // Cache expired
        await prefs.remove('cache_$key');
        await prefs.remove(cacheTimeKey);
        return null;
      }
      
      final cachedData = prefs.getString('cache_$key');
      if (cachedData == null) return null;
      
      // Parse the JSON string
      dynamic decoded = jsonDecode(cachedData);
      
      if (fromJson != null && decoded is Map<String, dynamic>) {
        return fromJson(decoded);
      } else {
        return decoded as T;
      }
    } catch (e) {
      debugPrint('Error reading cached data: $e');
      return null;
    }
  }
  
  // Clear specific cache
  Future<bool> clearCache(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('cache_$key');
      await prefs.remove('cache_time_$key');
      return true;
    } catch (e) {
      debugPrint('Error clearing cache: $e');
      return false;
    }
  }
  
  // Clear all cached data
  Future<bool> clearAllCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      
      for (final key in keys) {
        if (key.startsWith('cache_')) {
          await prefs.remove(key);
        }
      }
      
      return true;
    } catch (e) {
      debugPrint('Error clearing all cache: $e');
      return false;
    }
  }
}