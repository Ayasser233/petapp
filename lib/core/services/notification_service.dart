import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:petapp/core/services/api_client.dart';
import 'package:petapp/core/services/auth_service.dart';

/// Service to manage Firebase Cloud Messaging (FCM) notifications
class NotificationService extends GetxService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final ApiClient _apiClient;
  final AuthService _authService;

  static const String _fcmTokenKey = 'fcm_token';
  static const String _fcmTokenSentKey = 'fcm_token_sent';

  NotificationService({
    required ApiClient apiClient,
    required AuthService authService,
  })  : _apiClient = apiClient,
        _authService = authService;

  /// Initialize the notification service
  Future<NotificationService> init() async {
    debugPrint('🔔 Initializing Notification Service...');

    // Request notification permissions
    await requestPermissions();

    // Get FCM token
    await _setupFCMToken();

    // Listen to token refresh
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      debugPrint('🔄 FCM Token refreshed: ${newToken.substring(0, 20)}...');
      _saveFCMTokenToServer(newToken);
    });

    // Listen to auth state changes to send token when user logs in
    _authService.authStateChanges.listen((authStatus) {
      if (authStatus == AuthStatus.authenticated) {
        debugPrint('🔐 User authenticated, syncing FCM token...');
        _setupFCMToken();
      }
    });

    debugPrint('✅ Notification Service initialized');
    return this;
  }

  /// Request notification permissions from the user
  Future<NotificationSettings> requestPermissions() async {
    try {
      debugPrint('📱 Requesting notification permissions...');

      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      debugPrint(
          '✅ Notification permission status: ${settings.authorizationStatus}');

      return settings;
    } catch (e) {
      debugPrint('❌ Error requesting notification permissions: $e');
      rethrow;
    }
  }

  /// Setup FCM token - get token and save to server
  Future<void> _setupFCMToken() async {
    try {
      // Get the FCM token
      final token = await _firebaseMessaging.getToken();

      if (token == null || token.isEmpty) {
        debugPrint('⚠️ FCM token is null or empty');
        return;
      }

      debugPrint('📱 FCM Token: ${token.substring(0, 20)}...');

      // Check if token has changed
      final prefs = await SharedPreferences.getInstance();
      final savedToken = prefs.getString(_fcmTokenKey);

      if (savedToken != token) {
        debugPrint('🔄 FCM Token has changed, updating...');
        await prefs.setString(_fcmTokenKey, token);
        await prefs.setBool(_fcmTokenSentKey, false);
      }

      // Send token to server if user is authenticated
      if (_authService.authStatus == AuthStatus.authenticated) {
        await _saveFCMTokenToServer(token);
      } else {
        debugPrint('⚠️ User not authenticated, will send token after login');
      }
    } catch (e) {
      debugPrint('❌ Error setting up FCM token: $e');
    }
  }

  /// Save FCM token to the server
  Future<void> _saveFCMTokenToServer(String token) async {
    try {
      // Check if user is authenticated
      if (_authService.authStatus != AuthStatus.authenticated) {
        debugPrint('⚠️ User not authenticated, skipping FCM token sync');
        return;
      }

      // Check if token has already been sent
      final prefs = await SharedPreferences.getInstance();
      final tokenSent = prefs.getBool(_fcmTokenSentKey) ?? false;
      final savedToken = prefs.getString(_fcmTokenKey);

      if (tokenSent && savedToken == token) {
        debugPrint('✅ FCM token already synced with server');
        return;
      }

      debugPrint('📤 Sending FCM token to server...');

      // Send token to server
      await _apiClient.saveNotificationToken(token);

      // Mark token as sent
      await prefs.setBool(_fcmTokenSentKey, true);
      await prefs.setString(_fcmTokenKey, token);

      debugPrint('✅ FCM token synced with server successfully');
    } on DioException catch (e) {
      // The server has a unique constraint on (user, token).
      // A 500 "duplicate key" means the token is already registered — treat as success.
      final isDuplicate = e.response?.statusCode == 500 &&
          (e.response?.data?.toString() ?? '').contains('duplicate key');

      if (isDuplicate) {
        debugPrint('✅ FCM token already registered on server (duplicate key — OK)');
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_fcmTokenSentKey, true);
        await prefs.setString(_fcmTokenKey, token);
        return;
      }

      debugPrint('❌ Failed to save FCM token to server: $e');
      // Don't throw error - notification token sync is not critical
    } catch (e) {
      debugPrint('❌ Failed to save FCM token to server: $e');
      // Don't throw error - notification token sync is not critical
    }
  }

  /// Get the current FCM token
  Future<String?> getToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      debugPrint('❌ Error getting FCM token: $e');
      return null;
    }
  }

  /// Delete the FCM token (call when user logs out)
  Future<void> deleteToken() async {
    try {
      debugPrint('🗑️ Deleting FCM token...');
      await _firebaseMessaging.deleteToken();

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_fcmTokenKey);
      await prefs.remove(_fcmTokenSentKey);

      debugPrint('✅ FCM token deleted');
    } catch (e) {
      debugPrint('❌ Error deleting FCM token: $e');
    }
  }

  /// Manually sync FCM token with server (useful after login)
  Future<void> syncTokenWithServer() async {
    try {
      final token = await getToken();
      if (token != null) {
        await _saveFCMTokenToServer(token);
      }
    } catch (e) {
      debugPrint('❌ Error syncing FCM token with server: $e');
    }
  }

  /// Handle foreground messages
  void setupForegroundMessageHandler(
      Function(RemoteMessage) onMessageReceived) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('📬 Foreground message received:');
      debugPrint('  Title: ${message.notification?.title}');
      debugPrint('  Body: ${message.notification?.body}');
      debugPrint('  Data: ${message.data}');

      onMessageReceived(message);
    });
  }

  /// Handle notification taps when app is in background
  void setupBackgroundMessageHandler(Function(RemoteMessage) onMessageTapped) {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('📬 Background message tapped:');
      debugPrint('  Title: ${message.notification?.title}');
      debugPrint('  Body: ${message.notification?.body}');
      debugPrint('  Data: ${message.data}');

      onMessageTapped(message);
    });
  }

  /// Handle notification that opened the app from terminated state
  Future<void> handleInitialMessage(
      Function(RemoteMessage) onMessageTapped) async {
    final message = await _firebaseMessaging.getInitialMessage();

    if (message != null) {
      debugPrint('📬 App opened from terminated state via notification:');
      debugPrint('  Title: ${message.notification?.title}');
      debugPrint('  Body: ${message.notification?.body}');
      debugPrint('  Data: ${message.data}');

      onMessageTapped(message);
    }
  }
}

