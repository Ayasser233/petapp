import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

/// App Lifecycle States
enum AppLifecycleStatus {
  resumed,
  inactive,
  paused,
  detached,
  hidden,
}

/// Activity Lifecycle Manager
/// Handles all app lifecycle events and state management
class ActivityLifecycleManager extends GetxService with WidgetsBindingObserver {
  // Current lifecycle state
  final Rx<AppLifecycleStatus> _lifecycleState = AppLifecycleStatus.resumed.obs;
  AppLifecycleStatus get lifecycleState => _lifecycleState.value;

  // Track if app is in foreground
  final RxBool _isAppInForeground = true.obs;
  bool get isAppInForeground => _isAppInForeground.value;

  // Track background time
  DateTime? _backgroundTime;
  DateTime? _foregroundTime;

  // Session management
  final RxInt _sessionDuration = 0.obs;
  Timer? _sessionTimer;

  // App state flags
  final RxBool _isFirstLaunch = true.obs;
  bool get isFirstLaunch => _isFirstLaunch.value;

  // Lifecycle callbacks
  final List<VoidCallback> _onResumedCallbacks = [];
  final List<VoidCallback> _onPausedCallbacks = [];
  final List<VoidCallback> _onInactiveCallbacks = [];
  final List<VoidCallback> _onDetachedCallbacks = [];
  final List<Function(Duration)> _onBackgroundTimeExceededCallbacks = [];

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _loadAppState();
    _startSessionTimer();
    print('🔄 ActivityLifecycleManager initialized');
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _sessionTimer?.cancel();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('🔄 App Lifecycle State Changed: $state');

    switch (state) {
      case AppLifecycleState.resumed:
        _handleResumed();
        break;
      case AppLifecycleState.inactive:
        _handleInactive();
        break;
      case AppLifecycleState.paused:
        _handlePaused();
        break;
      case AppLifecycleState.detached:
        _handleDetached();
        break;
      case AppLifecycleState.hidden:
        _handleHidden();
        break;
    }
  }

  /// Handle app resumed (foreground)
  void _handleResumed() {
    _lifecycleState.value = AppLifecycleStatus.resumed;
    _isAppInForeground.value = true;
    _foregroundTime = DateTime.now();

    // Calculate background duration
    if (_backgroundTime != null) {
      final backgroundDuration = _foregroundTime!.difference(_backgroundTime!);
      print('⏱️ App was in background for: ${backgroundDuration.inSeconds} seconds');

      // Notify listeners if background time exceeded threshold
      _notifyBackgroundTimeExceeded(backgroundDuration);
    }

    _isFirstLaunch.value = false;
    _saveAppState();

    // Execute resumed callbacks
    for (var callback in _onResumedCallbacks) {
      callback();
    }

    print('✅ App RESUMED - User returned to app');
  }

  /// Handle app inactive (transitioning)
  void _handleInactive() {
    _lifecycleState.value = AppLifecycleStatus.inactive;
    print('⚠️ App INACTIVE - Transitioning state');

    // Execute inactive callbacks
    for (var callback in _onInactiveCallbacks) {
      callback();
    }
  }

  /// Handle app paused (background)
  void _handlePaused() {
    _lifecycleState.value = AppLifecycleStatus.paused;
    _isAppInForeground.value = false;
    _backgroundTime = DateTime.now();
    _saveAppState();

    // Execute paused callbacks
    for (var callback in _onPausedCallbacks) {
      callback();
    }

    print('⏸️ App PAUSED - Moved to background');
  }

  /// Handle app detached (about to be destroyed)
  void _handleDetached() {
    _lifecycleState.value = AppLifecycleStatus.detached;
    _saveAppState();

    // Execute detached callbacks
    for (var callback in _onDetachedCallbacks) {
      callback();
    }

    print('🛑 App DETACHED - App is closing');
  }

  /// Handle app hidden (iOS specific)
  void _handleHidden() {
    _lifecycleState.value = AppLifecycleStatus.hidden;
    print('👁️ App HIDDEN');
  }

  /// Register callback for when app resumes
  void onResumed(VoidCallback callback) {
    _onResumedCallbacks.add(callback);
  }

  /// Register callback for when app pauses
  void onPaused(VoidCallback callback) {
    _onPausedCallbacks.add(callback);
  }

  /// Register callback for when app becomes inactive
  void onInactive(VoidCallback callback) {
    _onInactiveCallbacks.add(callback);
  }

  /// Register callback for when app detaches
  void onDetached(VoidCallback callback) {
    _onDetachedCallbacks.add(callback);
  }

  /// Register callback for when background time exceeds threshold
  void onBackgroundTimeExceeded(Function(Duration) callback, {Duration threshold = const Duration(minutes: 5)}) {
    _onBackgroundTimeExceededCallbacks.add(callback);
  }

  /// Notify listeners about background time
  void _notifyBackgroundTimeExceeded(Duration duration) {
    for (var callback in _onBackgroundTimeExceededCallbacks) {
      callback(duration);
    }
  }

  /// Start session timer
  void _startSessionTimer() {
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isAppInForeground.value) {
        _sessionDuration.value++;
      }
    });
  }

  /// Get current session duration
  Duration get sessionDuration => Duration(seconds: _sessionDuration.value);

  /// Reset session
  void resetSession() {
    _sessionDuration.value = 0;
    print('🔄 Session reset');
  }

  /// Save app state to persistent storage
  Future<void> _saveAppState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('app_first_launch', false);
      await prefs.setString('last_foreground_time', _foregroundTime?.toIso8601String() ?? '');
      await prefs.setString('last_background_time', _backgroundTime?.toIso8601String() ?? '');
      await prefs.setInt('session_duration', _sessionDuration.value);
      print('💾 App state saved');
    } catch (e) {
      print('❌ Error saving app state: $e');
    }
  }

  /// Load app state from persistent storage
  Future<void> _loadAppState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isFirstLaunch.value = prefs.getBool('app_first_launch') ?? true;

      final lastForeground = prefs.getString('last_foreground_time');
      if (lastForeground != null && lastForeground.isNotEmpty) {
        _foregroundTime = DateTime.parse(lastForeground);
      }

      final lastBackground = prefs.getString('last_background_time');
      if (lastBackground != null && lastBackground.isNotEmpty) {
        _backgroundTime = DateTime.parse(lastBackground);
      }

      _sessionDuration.value = prefs.getInt('session_duration') ?? 0;
      print('📂 App state loaded');
    } catch (e) {
      print('❌ Error loading app state: $e');
    }
  }

  /// Get time since last background
  Duration? getTimeSinceBackground() {
    if (_backgroundTime == null) return null;
    return DateTime.now().difference(_backgroundTime!);
  }

  /// Get time in foreground
  Duration? getTimeInForeground() {
    if (_foregroundTime == null) return null;
    return DateTime.now().difference(_foregroundTime!);
  }

  /// Check if app was in background for longer than duration
  bool wasInBackgroundLongerThan(Duration duration) {
    final timeSinceBackground = getTimeSinceBackground();
    if (timeSinceBackground == null) return false;
    return timeSinceBackground > duration;
  }

  /// Clear all callbacks
  void clearCallbacks() {
    _onResumedCallbacks.clear();
    _onPausedCallbacks.clear();
    _onInactiveCallbacks.clear();
    _onDetachedCallbacks.clear();
    _onBackgroundTimeExceededCallbacks.clear();
  }

  /// Print current state
  void printState() {
    print('''
    ════════════════════════════════════════
    📊 Activity Lifecycle State
    ════════════════════════════════════════
    Current State: $_lifecycleState
    Is Foreground: $_isAppInForeground
    Is First Launch: $_isFirstLaunch
    Session Duration: ${sessionDuration.inMinutes}m ${sessionDuration.inSeconds % 60}s
    Last Background: $_backgroundTime
    Last Foreground: $_foregroundTime
    ════════════════════════════════════════
    ''');
  }
}

