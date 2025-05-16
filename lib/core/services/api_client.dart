import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio = Dio();
  final String baseUrl = 'https://your-api-url.com'; // Replace with your API URL

  ApiClient() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    // Add interceptors for token handling, logging, etc.
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // You can add auth token here if needed
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        return handler.next(e);
      },
    ));
  }

  // Authentication methods
  Future<Response> register(Map<String, dynamic> userData) async {
    try {
      return await _dio.post('/api/auth/register', data: userData);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> login(String email, String password) async {
    try {
      return await _dio.post('/api/auth/login', 
        data: {'email': email, 'password': password});
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> verifyEmail(String email, String otp) async {
    try {
      return await _dio.post('/api/auth/verify-email', 
        data: {'email': email, 'otp': otp});
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> resendVerification(String email) async {
    try {
      return await _dio.post('/api/auth/resend-verification', 
        data: {'email': email});
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> forgotPassword(String email) async {
    try {
      return await _dio.post('/api/auth/forgot-password', 
        data: {'email': email});
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> resetPassword(String token, String password) async {
    try {
      return await _dio.post('/api/auth/reset-password', 
        data: {'token': token, 'password': password});
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> logout() async {
    try {
      return await _dio.post('/api/auth/logout');
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getUserProfile() async {
    try {
      return await _dio.get('/api/auth/profile');
    } catch (e) {
      rethrow;
    }
  }
}