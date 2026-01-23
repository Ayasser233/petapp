import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
//import 'package:petapp/core/services/api_error_handler.dart';
import 'package:petapp/core/services/error_handler_service.dart';
import 'package:petapp/core/utils/api_constants.dart';
import 'package:petapp/core/services/token_service.dart';
import 'package:petapp/core/services/connectivity_service.dart';

class ApiClient {
  late final Dio _dio;
  final ErrorHandlerService errorHandler;
  final TokenService tokenService;
  final ConnectivityService connectivityService;

  // Base URL handling with fallback
  late final String _baseUrl;
  final String _fallbackUrl = ApiConstants.fallbackApiBaseUrl;
  bool _usingFallbackUrl = false;

  // Token refresh handling
  bool _isRefreshing = false;
  final List<void Function(String token)> _pendingRequests = [];

  ApiClient({
    required this.errorHandler,
    required this.tokenService,
    required this.connectivityService,
  }) {
    _baseUrl = ApiConstants.apiBaseUrl; // Get platform-specific base URL
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: ApiConstants.connectionTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        sendTimeout: ApiConstants.sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add auth token if available
        final token = await tokenService.getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        // Check connectivity before making request
        final isConnected = await connectivityService.isConnected();
        if (!isConnected) {
          return handler.reject(
            DioException(
                requestOptions: options,
                type: DioExceptionType.connectionError,
                error: 'No internet connection'),
          );
        }

        return handler.next(options);
      },
      onResponse: (response, handler) {
        // If using fallback and it works, try switching back to primary on next request
        if (_usingFallbackUrl) {
          _checkPrimaryUrl();
        }

        return handler.next(response);
      },
      onError: (DioException error, handler) async {
        // Handle 401 Unauthorized - Token expired
        if (error.response?.statusCode == 401) {
          debugPrint('🔄 Token expired, attempting to refresh...');

          // Try to refresh the token
          final newToken = await _refreshAccessToken();

          if (newToken != null) {
            // Retry the original request with new token
            error.requestOptions.headers['Authorization'] = 'Bearer $newToken';

            try {
              final response = await _dio.request(
                error.requestOptions.path,
                data: error.requestOptions.data,
                queryParameters: error.requestOptions.queryParameters,
                options: Options(
                  method: error.requestOptions.method,
                  headers: error.requestOptions.headers,
                ),
              );
              return handler.resolve(response);
            } catch (e) {
              // If retry fails, continue with error handling
              debugPrint('❌ Retry after refresh failed: $e');
            }
          } else {
            // Token refresh failed, user needs to login again
            debugPrint('❌ Token refresh failed, logging out...');
            await tokenService.clearAllTokens();
          }
        }

        // If server is unreachable and not using fallback URL yet
        if (_canUseFallback(error) && !_usingFallbackUrl) {
          debugPrint('Primary API unreachable, switching to fallback URL');

          // Switch to fallback URL
          _usingFallbackUrl = true;
          _dio.options.baseUrl = _fallbackUrl;

          // Retry the request with fallback URL
          try {
            final response = await _dio.request(
              error.requestOptions.path,
              data: error.requestOptions.data,
              queryParameters: error.requestOptions.queryParameters,
              options: Options(
                method: error.requestOptions.method,
                headers: error.requestOptions.headers,
              ),
            );

            return handler.resolve(response);
          } catch (e) {
            // If fallback also fails, continue with error handling
          }
        }

        // Let the error handler take care of the error
        return handler.next(error);
      },
    ));

    // Add logging in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
    }
  }

  bool _canUseFallback(DioException error) {
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.unknown;
  }

  // Check if the primary URL is back online
  Future<void> _checkPrimaryUrl() async {
    try {
      final testDio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ));

      final response =
          await testDio.get('$_baseUrl${ApiConstants.healthEndpoint}');

      if (response.statusCode == 200) {
        _usingFallbackUrl = false;
        _dio.options.baseUrl = _baseUrl;
        debugPrint('Switched back to primary API URL');
      }
    } catch (e) {
      // Primary still down, keep using fallback
    }
  }

  // Authentication methods
  Future<Response> register(Map<String, dynamic> userData) async {
    try {
      final response =
          await _dio.post(ApiConstants.registerEndpoint, data: userData);
      return response;
    } catch (e) {
      log(e.toString());
      ErrorHandlerService.instance.handleError(e);
      rethrow;
    }
  }

  Future<Response> login(String identifier, String password) async {
    try {
      final Map<String, dynamic> data = {
        'identifier': identifier,
        'password': password,
      };

      final response = await _dio.post(ApiConstants.loginEndpoint, data: data);
      await _handleTokenResponse(response);
      return response;
    } catch (e) {
      ErrorHandlerService.instance.handleError(e);
      rethrow;
    }
  }

  Future<Response> confirmEmail(String email, String otp) async {
    try {
      final response = await _dio.post(ApiConstants.confirmEndpoint,
          data: {'email': email, 'otp': otp});
      await _handleTokenResponse(response);
      return response;
    } catch (e) {
      ErrorHandlerService.instance.handleError(e);
      rethrow;
    }
  }

  Future<Response> resendOtp(String email) async {
    try {
      final response = await _dio
          .post(ApiConstants.resendOtpEndpoint, data: {'email': email});
      return response;
    } catch (e) {
      ErrorHandlerService.instance.handleError(e);
      rethrow;
    }
  }

  Future<Response> confirmNewEmail(String email, String otp) async {
    try {
      final response = await _dio.post(ApiConstants.confirmNewEmailEndpoint,
          data: {'email': email, 'otp': otp});
      return response;
    } catch (e) {
      ErrorHandlerService.instance.handleError(e);
      rethrow;
    }
  }

  Future<Response> forgotPassword(String email) async {
    try {
      final response = await _dio
          .post(ApiConstants.forgotPasswordEndpoint, data: {'email': email});
      return response;
    } catch (e) {
      ErrorHandlerService.instance.handleError(e);
      rethrow;
    }
  }

  Future<Response> verifyResetOtp(String email, String otp) async {
    try {
      final response = await _dio.post(ApiConstants.verifyResetOtpEndpoint,
          data: {'email': email, 'otp': otp});
      return response;
    } catch (e) {
      ErrorHandlerService.instance.handleError(e);
      rethrow;
    }
  }

  Future<Response> resendResetOtp(String email) async {
    try {
      final response = await _dio
          .post(ApiConstants.resendResetOtpEndpoint, data: {'email': email});
      return response;
    } catch (e) {
      ErrorHandlerService.instance.handleError(e);
      rethrow;
    }
  }

  Future<Response> resetPassword(
      String email, String resetToken, String password) async {
    try {
      final response = await _dio.post(ApiConstants.resetPasswordEndpoint,
          data: {
            'email': email,
            'resetToken': resetToken,
            'password': password
          });
      return response;
    } catch (e) {
      ErrorHandlerService.instance.handleError(e);
      rethrow;
    }
  }

  Future<Response> changePassword(
      String currentPassword, String newPassword) async {
    try {
      final response = await _dio.patch(ApiConstants.changePasswordEndpoint,
          data: {
            'oldPassword': currentPassword,
            'newPassword': newPassword
          });
      return response;
    } catch (e) {
      ErrorHandlerService.instance.handleError(e);
      rethrow;
    }
  }

  Future<Response> refreshToken(String refreshToken) async {
    try {
      final response = await _dio.post(ApiConstants.refreshTokenEndpoint,
          data: {'refreshToken': refreshToken});
      await _handleTokenResponse(response);
      return response;
    } catch (e) {
      ErrorHandlerService.instance.handleError(e);
      rethrow;
    }
  }

  Future<Response> logout() async {
    try {
      final response = await _dio.post(ApiConstants.logoutEndpoint);
      await tokenService.clearAllTokens();
      return response;
    } catch (e) {
      await tokenService.clearAllTokens(); // Clear tokens even if logout fails
      ErrorHandlerService.instance.handleError(e);
      rethrow;
    }
  }

  Future<Response> getUserProfile() async {
    try {
      final response = await _dio.get(ApiConstants.profileEndpoint);
      return response;
    } catch (e) {
      ErrorHandlerService.instance.handleError(e);
      rethrow;
    }
  }

  Future<Response> updateUserProfile(Map<String, dynamic> userData) async {
    try {
      // Get user ID from token service
      final userId = await tokenService.getUserId();

      if (userId == null || userId.isEmpty) {
        throw Exception('User ID not found. Please log in again.');
      }

      final endpoint = ApiConstants.updateProfileEndpoint(userId);

      final response = await _dio.patch(endpoint, data: userData);

      return response;
    } catch (e) {
      ErrorHandlerService.instance.handleError(e);
      rethrow;
    }
  }

  Future<Response> googleLogin(String idToken) async {
    try {
      debugPrint('🔐 Attempting Google login with token...');
      final response = await _dio.post(
        ApiConstants.googleLoginEndpoint,
        data: {'idToken': idToken},
      );
      debugPrint('✅ Google login successful');
      await _handleTokenResponse(response);
      return response;
    } catch (e) {
      debugPrint('❌ Google login failed: $e');
      ErrorHandlerService.instance.handleError(e);
      rethrow;
    }
  }

  Future<Response> appleLogin(String identityToken, {String? authorizationCode}) async {
    try {
      debugPrint('🍎 Attempting Apple login with token...');
      final data = {
        'identityToken': identityToken,
      };
      if (authorizationCode != null) {
        data['authorizationCode'] = authorizationCode;
      }
      final response = await _dio.post(
        ApiConstants.appleLoginEndpoint,
        data: data,
      );
      debugPrint('✅ Apple login successful');
      await _handleTokenResponse(response);
      return response;
    } catch (e) {
      debugPrint('❌ Apple login failed: $e');
      ErrorHandlerService.instance.handleError(e);
      rethrow;
    }
  }

  /// Save FCM notification token to the server
  Future<Response> saveNotificationToken(String fcmToken) async {
    try {
      debugPrint('📱 Saving FCM token to server: ${fcmToken.substring(0, 20)}...');
      debugPrint('📤 Request body: {"notificationToken": "$fcmToken"}');
      final response = await _dio.patch(
        ApiConstants.notificationTokenEndpoint,
        data: {'notificationToken': fcmToken},
      );
      debugPrint('✅ FCM token saved successfully');
      return response;
    } catch (e) {
      debugPrint('❌ Failed to save FCM token: $e');
      // Suppress user notification for FCM token errors - not critical
      ErrorHandlerService.instance.handleError(e, suppressUserNotification: true);
      rethrow;
    }
  }

  /// Delete user account (soft delete)
  Future<Response> deleteAccount() async {
    try {
      debugPrint('🗑️ Deleting user account (soft delete)...');
      final response = await _dio.delete(ApiConstants.deleteAccountEndpoint);

      // Clear all tokens after successful deletion
      await tokenService.clearAllTokens();

      debugPrint('✅ Account deleted successfully');
      return response;
    } catch (e) {
      debugPrint('❌ Failed to delete account: $e');
      ErrorHandlerService.instance.handleError(e);
      rethrow;
    }
  }

  // Handle possible token in response
  Future<void> _handleTokenResponse(Response response) async {
    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;

      // Handle both accessToken and access_token formats
      final accessToken = data['accessToken'] ?? data['access_token'];
      final refreshToken = data['refreshToken'] ?? data['refresh_token'];

      if (accessToken != null) {
        await tokenService.saveToken(accessToken.toString());
      }

      if (refreshToken != null) {
        await tokenService.saveRefreshToken(refreshToken.toString());
      }

      // Save user ID if available in the response
      final user = data['user'];
      if (user != null && user is Map<String, dynamic>) {
        final userId = user['id'] ?? user['_id'];
        if (userId != null) {
          await tokenService.saveUserId(userId.toString());
        }
      }
    }
  }

  // Refresh access token using refresh token
  Future<String?> _refreshAccessToken() async {
    try {
      // Prevent multiple simultaneous refresh requests
      if (_isRefreshing) {
        debugPrint('🔄 Refresh already in progress, waiting...');
        // Wait for the ongoing refresh to complete
        final completer = Completer<String?>();
        _pendingRequests.add((token) => completer.complete(token));
        return await completer.future;
      }

      _isRefreshing = true;

      final refreshTokenValue = await tokenService.getRefreshToken();
      if (refreshTokenValue == null || refreshTokenValue.isEmpty) {
        debugPrint('❌ No refresh token available');
        _isRefreshing = false;
        return null;
      }

      debugPrint('🔄 Refreshing token...');

      // Create a new Dio instance without interceptors to avoid infinite loop
      final refreshDio = Dio(BaseOptions(
        baseUrl: _dio.options.baseUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ));

      final response = await refreshDio.post(
        ApiConstants.refreshTokenEndpoint,
        data: {'refreshToken': refreshTokenValue},
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        final newAccessToken = data['accessToken'] ?? data['access_token'];
        final newRefreshToken = data['refreshToken'] ?? data['refresh_token'];

        if (newAccessToken != null) {
          await tokenService.saveToken(newAccessToken.toString());

          if (newRefreshToken != null) {
            await tokenService.saveRefreshToken(newRefreshToken.toString());
          }

          debugPrint('✅ Token refreshed successfully');

          // Resolve all pending requests with the new token
          for (var callback in _pendingRequests) {
            callback(newAccessToken.toString());
          }
          _pendingRequests.clear();

          _isRefreshing = false;
          return newAccessToken.toString();
        }
      }

      debugPrint('❌ Failed to refresh token: Invalid response');
      _isRefreshing = false;
      return null;
    } catch (e) {
      debugPrint('❌ Error refreshing token: $e');
      _isRefreshing = false;
      _pendingRequests.clear();
      return null;
    }
  }

  // Generic HTTP methods
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      ErrorHandlerService.instance.handleError(e);
      rethrow;
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      ErrorHandlerService.instance.handleError(e);
      rethrow;
    }
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      ErrorHandlerService.instance.handleError(e);
      rethrow;
    }
  }

  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      ErrorHandlerService.instance.handleError(e);
      rethrow;
    }
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      ErrorHandlerService.instance.handleError(e);
      rethrow;
    }
  }
}
