import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/services/api_client.dart';
import 'package:petapp/core/services/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthStatus { authenticated, unauthenticated, guest }

class AuthService extends GetxService {
  final TokenService _tokenService;
  ApiClient? _apiClient;

  // Observable auth status
  final Rx<AuthStatus> _authStatus = AuthStatus.unauthenticated.obs;

  AuthService({required TokenService tokenService})
      : _tokenService = tokenService;

  // Getter for auth status (reactive)
  AuthStatus get authStatus => _authStatus.value;

  // Getter for reactive auth status
  Rx<AuthStatus> get authStatusRx => _authStatus;

  // Stream to listen for auth changes
  Stream<AuthStatus> get authStateChanges => _authStatus.stream;

  // Initialize the auth service
  Future<AuthService> init() async {
    // Check if user has a valid session (access token or refresh token)
    if (await hasValidSession()) {
      _authStatus.value = AuthStatus.authenticated;
    } else {
      // Check if user is in guest mode
      final prefs = await SharedPreferences.getInstance();
      final isGuest = prefs.getBool('isGuestMode') ?? false;

      _authStatus.value =
          isGuest ? AuthStatus.guest : AuthStatus.unauthenticated;
    }

    // Set up listener for authentication status changes
    _setupAuthStatusListener();

    return this;
  }

  // Set up listener to handle authentication status changes
  void _setupAuthStatusListener() {
    _authStatus.listen((status) {
      if (status == AuthStatus.unauthenticated) {
        // Delay the logout to avoid conflicts during initialization
        Future.delayed(const Duration(milliseconds: 100), () {
          _performAutomaticLogout();
        });
      }
    });
  }

  // Set guest mode
  Future<void> setGuestMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isGuestMode', true);
    await prefs.setBool('isLoggedIn', false);
    await prefs.setBool('isOnboardingCompleted', true);
    _authStatus.value = AuthStatus.guest;
  }

  // Clear guest mode (used when logging in)
  Future<void> clearGuestMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isGuestMode', false);
  }

  // Set authenticated state
  void setAuthenticated() {
    _authStatus.value = AuthStatus.authenticated;

    // Trigger FCM token sync after authentication
    _syncFCMToken();
  }

  // Set unauthenticated state (automatic logout handled by listener)
  Future<void> setUnauthenticated() async {
    await _tokenService.clearToken();
    _authStatus.value = AuthStatus.unauthenticated;
  }

  // Handle token expiration or invalid token
  Future<void> handleTokenExpiration() async {
    await setUnauthenticated();
  }

  // Try to refresh token and restore session
  Future<bool> tryRefreshToken() async {
    try {
      final refreshToken = await _tokenService.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  // Check if tokens are still valid
  Future<bool> hasValidSession() async {
    final hasAccessToken = await _tokenService.hasToken();
    final hasRefreshToken = await _tokenService.hasRefreshToken();
    return hasAccessToken || hasRefreshToken;
  }

  // Perform automatic logout when user becomes unauthenticated
  Future<void> _performAutomaticLogout() async {
    try {
      // Clear all user data and preferences
      await _tokenService.clearAllTokens();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      await prefs.setBool('isGuestMode', false);

      // Navigate to login page
      if (Get.currentRoute != '/login' && Get.currentRoute != '/onboarding') {
        // Show a message to inform user about automatic logout
        Get.snackbar(
          'Session Expired',
          'You have been logged out. Please login again.',
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
        );

        // Navigate to login screen and clear all previous routes
        Get.offAllNamed('/login');
      }
    } catch (e) {
      print('❌ Error during automatic logout: $e');
    }
  }

  // Sign out user (calls logout API)
  Future<void> signOut() async {
    try {
      // Call logout API if user is authenticated
      if (_authStatus.value == AuthStatus.authenticated) {
        try {
          // Get ApiClient instance and call logout endpoint
          _apiClient ??= Get.find<ApiClient>();
          await _apiClient!.logout();
        } catch (apiError) {
          // Silent local cleanup is fine here
        }
      }

      // Delete FCM token
      try {
        if (Get.isRegistered<dynamic>(tag: 'NotificationService')) {
          final notificationService = Get.find(tag: 'NotificationService');
          if (notificationService != null) {
            await (notificationService as dynamic).deleteToken();
          }
        }
      } catch (e) {
        debugPrint('⚠️ Could not delete FCM token: $e');
      }

      // Clear all tokens and local data
      await _tokenService
          .clearAllTokens(); // Clear both access and refresh tokens
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      await prefs.setBool('isGuestMode', false);

      // Update auth status
      _authStatus.value = AuthStatus.unauthenticated;
    } catch (e) {
      // Even if there's an error, ensure we clear local state
      await _tokenService.clearAllTokens();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      _authStatus.value = AuthStatus.unauthenticated;
    }
  }

  // Check if user can access protected features
  bool canAccessProtectedFeature() {
    return _authStatus.value == AuthStatus.authenticated;
  }

  // Show login prompt dialog
  Future<bool> showLoginPrompt(BuildContext context) async {
    if (_authStatus.value == AuthStatus.authenticated) {
      return true;
    }

    // Return the result of the dialog (true if user chooses to login)
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Login Required'),
            content:
                const Text('You need to be logged in to use this feature.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: const Text('Login'),
              ),
            ],
          ),
        ) ??
        false;
  }

  // Helper method to sync FCM token with server after login
  void _syncFCMToken() {
    // Use a delayed call to avoid circular dependencies
    Future.delayed(const Duration(milliseconds: 500), () {
      try {
        // Try to get NotificationService if it's registered
        if (Get.isRegistered<dynamic>(tag: 'NotificationService')) {
          final notificationService = Get.find(tag: 'NotificationService');
          if (notificationService != null) {
            (notificationService as dynamic).syncTokenWithServer();
          }
        }
      } catch (e) {
        // NotificationService might not be initialized yet, ignore
        debugPrint('⚠️ Could not sync FCM token: $e');
      }
    });
  }
}
