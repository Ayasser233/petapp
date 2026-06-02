import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityService {
  final Connectivity _connectivity;

  // Cache
  bool? _cachedResult;
  DateTime? _lastChecked;
  static const _cacheDuration = Duration(seconds: 5);

  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  // Check if device is connected to internet
  Future<bool> isConnected() async {
    // Return cached result if still fresh
    if (_cachedResult != null &&
        _lastChecked != null &&
        DateTime.now().difference(_lastChecked!) < _cacheDuration) {
      return _cachedResult!;
    }

    try {
      final connectivityResult = await _connectivity.checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        _cachedResult = false;
        _lastChecked = DateTime.now();
        return false;
      }

      // Double check with actual internet access
      try {
        final result = await InternetAddress.lookup('google.com');
        final connected = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
        _cachedResult = connected;
        _lastChecked = DateTime.now();
        return connected;
      } on SocketException catch (_) {
        _cachedResult = false;
        _lastChecked = DateTime.now();
        return false;
      }
    } catch (e) {
      debugPrint('Error checking connectivity: $e');
      return _cachedResult ?? false;
    }
  }

  /// Invalidate the cache immediately (e.g. when the app comes back to foreground).
  void invalidateCache() {
    _cachedResult = null;
    _lastChecked = null;
  }

  // Stream of connectivity changes
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map((result) {
      final connected = result != ConnectivityResult.none;
      // Keep cache in sync with live changes
      _cachedResult = connected;
      _lastChecked = DateTime.now();
      return connected;
    });
  }
}