import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:petapp/features/auth/data/repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial());

  Future<void> register(Map<String, dynamic> userData) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.register(userData);
      emit(AuthRegistrationSuccess(
        user: user, 
        email: userData['email']
      ));
    } on DioException catch (e) {
      emit(AuthFailure(
        message: _formatDioError(e, isSignup: true),
        errorCode: e.response?.statusCode,
        fieldErrors: _extractFieldErrors(e),
      ));
    } catch (e) {
      emit(AuthFailure(
        message: 'An unexpected error occurred. Please try again.',
        errorDetails: e.toString()
      ));
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.login(email, password);
      emit(AuthLoginSuccess(user: user));
    } on DioException catch (e) {
      emit(AuthFailure(
        message: _formatDioError(e, isSignup: false),
        errorCode: e.response?.statusCode,
      ));
    } catch (e) {
      emit(AuthFailure(
        message: 'Unable to login. Please check your credentials and try again.',
        errorDetails: e.toString()
      ));
    }
  }
  
  // Helper method to format DioException errors
  String _formatDioError(DioException e, {bool isSignup = false}) {
    // Default messages based on context
    final defaultMessage = isSignup 
        ? 'Unable to create account.' 
        : 'Login failed.';
        
    // Handle no response cases
    if (e.response == null) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return 'Connection timed out. Please check your internet and try again.';
      }
      if (e.type == DioExceptionType.connectionError) {
        return 'No internet connection. Please check your network settings.';
      }
      return '$defaultMessage Please try again later.';
    }
    
    // Handle different status codes
    switch (e.response?.statusCode) {
      case 400:
        return _extractErrorMessage(e.response?.data) ?? 
            'Please check your information and try again.';
      case 401:
        return isSignup 
            ? 'Authentication failed. Please try again.' 
            : 'Invalid email or password.';
      case 403:
        return 'You don\'t have permission to perform this action.';
      case 404:
        return 'Service not found. Please try again later.';
      case 409:
        return isSignup 
            ? 'Account already exists with this email or phone number.' 
            : 'Account conflict. Please contact support.';
      case 422:
        return _extractErrorMessage(e.response?.data) ?? 
            'Please fix the errors in your submission.';
      case 429:
        return 'Too many attempts. Please try again later.';
      case 500:
      case 501:
      case 502:
      case 503:
        return 'Server error. Please try again later.';
      default:
        return _extractErrorMessage(e.response?.data) ?? '$defaultMessage Please try again.';
    }
  }
  
  // Helper method to extract error message from response data
  String? _extractErrorMessage(dynamic responseData) {
    try {
      if (responseData == null) return null;
      
      if (responseData is Map) {
        // Check common patterns
        if (responseData.containsKey('message')) {
          return responseData['message'];
        } 
        if (responseData.containsKey('error')) {
          final error = responseData['error'];
          if (error is String) return error;
          if (error is Map && error.containsKey('message')) {
            return error['message'];
          }
        }
      }
    } catch (e) {
      debugPrint('Error extracting message: $e');
    }
    return null;
  }
  
  // Extract field-specific validation errors (email taken, password too weak, etc)
  Map<String, String>? _extractFieldErrors(DioException e) {
    try {
      final data = e.response?.data;
      if (data == null || data is! Map) return null;
      
      // Check for common validation error formats
      if (data.containsKey('errors') && data['errors'] is Map) {
        final errors = data['errors'] as Map;
        final fieldErrors = <String, String>{};
        
        errors.forEach((key, value) {
          if (value is List && value.isNotEmpty) {
            fieldErrors[key] = value.first.toString();
          } else if (value is String) {
            fieldErrors[key] = value;
          }
        });
        
        return fieldErrors.isNotEmpty ? fieldErrors : null;
      }
    } catch (e) {
      debugPrint('Error extracting field errors: $e');
    }
    return null;
  }

  Future<void> verifyEmail(String email, String otp) async {
    emit(AuthLoading());
    try {
      await _authRepository.verifyEmail(email, otp);
      emit(const AuthVerificationSuccess());
    } on DioException catch (e) {
      String errorMessage = 'Verification failed';
      
      if (e.response != null) {
        try {
          errorMessage = e.response?.data['message'] ?? errorMessage;
        } catch (_) {
          // Use default error message
        }
      }
      
      emit(AuthFailure(message: errorMessage));
    } catch (e) {
      emit(const AuthFailure(message: 'An unexpected error occurred'));
    }
  }

  Future<void> resendVerification(String email) async {
    emit(AuthLoading());
    try {
      await _authRepository.resendVerification(email);
      emit(const AuthResendVerificationSuccess());
    } on DioException catch (e) {
      String errorMessage = 'Failed to resend verification';
      
      if (e.response != null) {
        try {
          errorMessage = e.response?.data['message'] ?? errorMessage;
        } catch (_) {
          // Use default error message
        }
      }
      
      emit(AuthFailure(message: errorMessage));
    } catch (e) {
      emit(const AuthFailure(message: 'An unexpected error occurred'));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await _authRepository.logout();
      emit(AuthLogoutSuccess());
    } catch (e) {
      // Even if logout fails on server, we treat it as success on client
      emit(AuthLogoutSuccess());
    }
  }

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.getUserProfile();
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }
}