import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:petapp/core/services/api_error_handler.dart';
import 'package:petapp/core/utils/api_constants.dart';
import 'package:petapp/core/services/token_service.dart';
import 'package:petapp/core/services/connectivity_service.dart';

class ApiClient {
  late final Dio _dio;
  final ApiErrorHandler errorHandler;
  final TokenService tokenService;
  final ConnectivityService connectivityService;
  
  // Base URL handling with fallback
  final String _baseUrl = ApiConstants.apiBaseUrl;
  final String _fallbackUrl = ApiConstants.fallbackApiBaseUrl;
  bool _usingFallbackUrl = false;
  
  ApiClient({
    required this.errorHandler,
    required this.tokenService,
    required this.connectivityService,
  }) {
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
              error: 'No internet connection'
            ),
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
      
      final response = await testDio.get('$_baseUrl${ApiConstants.healthEndpoint}');
      
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
      final response = await _dio.post(ApiConstants.registerEndpoint, data: userData);
      await _handleTokenResponse(response);
      return response;
    } catch (e) {
      throw errorHandler.handleError(e);
    }
  }
  
  Future<Response> login(String email, String password) async {
    try {
      final response = await _dio.post(ApiConstants.loginEndpoint, 
        data: {'email': email, 'password': password});
      await _handleTokenResponse(response);
      return response;
    } catch (e) {
      throw errorHandler.handleError(e);
    }
  }
  
  Future<Response> verifyEmail(String email, String otp) async {
    try {
      final response = await _dio.post(ApiConstants.verifyEmailEndpoint, 
        data: {'email': email, 'otp': otp});
      return response;
    } catch (e) {
      throw errorHandler.handleError(e);
    }
  }
  
  Future<Response> resendVerification(String email) async {
    try {
      final response = await _dio.post(ApiConstants.resendVerificationEndpoint, 
        data: {'email': email});
      return response;
    } catch (e) {
      throw errorHandler.handleError(e);
    }
  }
  
  Future<Response> forgotPassword(String email) async {
    try {
      final response = await _dio.post(ApiConstants.forgotPasswordEndpoint, 
        data: {'email': email});
      return response;
    } catch (e) {
      throw errorHandler.handleError(e);
    }
  }
  
  Future<Response> resetPassword(String token, String password) async {
    try {
      final response = await _dio.post(ApiConstants.resetPasswordEndpoint, 
        data: {'token': token, 'password': password});
      await _handleTokenResponse(response);
      return response;
    } catch (e) {
      throw errorHandler.handleError(e);
    }
  }
  
  Future<Response> logout() async {
    try {
      final response = await _dio.post(ApiConstants.logoutEndpoint);
      await tokenService.clearToken();
      return response;
    } catch (e) {
      await tokenService.clearToken(); // Clear token even if logout fails
      throw errorHandler.handleError(e);
    }
  }
  
  Future<Response> getUserProfile() async {
    try {
      final response = await _dio.get(ApiConstants.profileEndpoint);
      return response;
    } catch (e) {
      throw errorHandler.handleError(e);
    }
  }
  
  // Handle possible token in response
  Future<void> _handleTokenResponse(Response response) async {
    if (response.data is Map &&
        response.data['token'] != null &&
        response.data['token'] is String) {
      await tokenService.saveToken(response.data['token']);
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
      throw errorHandler.handleError(e);
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
      throw errorHandler.handleError(e);
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
      throw errorHandler.handleError(e);
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
      throw errorHandler.handleError(e);
    }
  }
}