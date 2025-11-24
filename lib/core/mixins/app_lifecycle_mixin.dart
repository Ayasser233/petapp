import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/services/activity_lifecycle_manager.dart';

/// Mixin for screens that need to react to app lifecycle events
///
/// Usage:
/// ```dart
/// class MyScreen extends StatefulWidget {
///   const MyScreen({super.key});
///
///   @override
///   State<MyScreen> createState() => _MyScreenState();
/// }
///
/// class _MyScreenState extends State<MyScreen> with AppLifecycleMixin {
///   @override
///   void onAppResumed() {
///     // Called when app comes to foreground
///     print('Screen is visible again');
///   }
///
///   @override
///   void onAppPaused() {
///     // Called when app goes to background
///     print('Screen is hidden');
///   }
/// }
/// ```
mixin AppLifecycleMixin<T extends StatefulWidget> on State<T> {
  ActivityLifecycleManager? _lifecycleManager;
  VoidCallback? _resumedCallback;
  VoidCallback? _pausedCallback;
  VoidCallback? _inactiveCallback;

  @override
  void initState() {
    super.initState();
    _setupLifecycleCallbacks();
  }

  @override
  void dispose() {
    _cleanupLifecycleCallbacks();
    super.dispose();
  }

  void _setupLifecycleCallbacks() {
    try {
      _lifecycleManager = Get.find<ActivityLifecycleManager>();

      _resumedCallback = () => onAppResumed();
      _pausedCallback = () => onAppPaused();
      _inactiveCallback = () => onAppInactive();

      _lifecycleManager?.onResumed(_resumedCallback!);
      _lifecycleManager?.onPaused(_pausedCallback!);
      _lifecycleManager?.onInactive(_inactiveCallback!);
    } catch (e) {
      debugPrint('⚠️ ActivityLifecycleManager not found: $e');
    }
  }

  void _cleanupLifecycleCallbacks() {
    // Note: Current implementation doesn't support callback removal
    // This is a placeholder for future enhancement
    _resumedCallback = null;
    _pausedCallback = null;
    _inactiveCallback = null;
  }

  /// Called when app resumes (comes to foreground)
  /// Override this method to handle app resume
  void onAppResumed() {
    // Override in child class
  }

  /// Called when app pauses (goes to background)
  /// Override this method to handle app pause
  void onAppPaused() {
    // Override in child class
  }

  /// Called when app becomes inactive (transitioning)
  /// Override this method to handle app inactive state
  void onAppInactive() {
    // Override in child class
  }

  /// Check if app is currently in foreground
  bool get isAppInForeground => _lifecycleManager?.isAppInForeground ?? true;

  /// Get current lifecycle state
  AppLifecycleStatus? get currentLifecycleState => _lifecycleManager?.lifecycleState;
}

/// Stateless widget version - use with GetX controllers
mixin AppLifecycleControllerMixin on GetxController {
  ActivityLifecycleManager? _lifecycleManager;

  @override
  void onInit() {
    super.onInit();
    _setupLifecycleCallbacks();
  }

  @override
  void onClose() {
    _cleanupLifecycleCallbacks();
    super.onClose();
  }

  void _setupLifecycleCallbacks() {
    try {
      _lifecycleManager = Get.find<ActivityLifecycleManager>();

      _lifecycleManager?.onResumed(() => onAppResumed());
      _lifecycleManager?.onPaused(() => onAppPaused());
      _lifecycleManager?.onInactive(() => onAppInactive());
    } catch (e) {
      debugPrint('⚠️ ActivityLifecycleManager not found: $e');
    }
  }

  void _cleanupLifecycleCallbacks() {
    _lifecycleManager = null;
  }

  /// Called when app resumes (comes to foreground)
  /// Override this method to handle app resume
  void onAppResumed() {
    // Override in child class
  }

  /// Called when app pauses (goes to background)
  /// Override this method to handle app pause
  void onAppPaused() {
    // Override in child class
  }

  /// Called when app becomes inactive (transitioning)
  /// Override this method to handle app inactive state
  void onAppInactive() {
    // Override in child class
  }

  /// Check if app is currently in foreground
  bool get isAppInForeground => _lifecycleManager?.isAppInForeground ?? true;

  /// Get current lifecycle state
  AppLifecycleStatus? get currentLifecycleState => _lifecycleManager?.lifecycleState;
}

