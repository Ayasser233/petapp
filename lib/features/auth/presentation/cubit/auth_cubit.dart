import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:petapp/features/auth/data/repositories/auth_repository.dart';
import 'package:petapp/features/auth/data/models/user_model.dart';
import 'package:petapp/features/auth/data/models/auth_request_models.dart';
import 'package:petapp/core/services/token_service.dart';
import '../../../../core/services/facebook_event_service.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final TokenService _tokenService;

  AuthCubit({
    required AuthRepository authRepository,
    required TokenService tokenService,
  })  : _authRepository = authRepository,
        _tokenService = tokenService,
        super(AuthInitial());

  Future<void> register(Map<String, dynamic> userData) async {
    emit(AuthLoading());
    try {
      final request = RegisterRequest(
        email: userData['email'] ?? '',
        password: userData['password'] ?? '',
        firstName: userData['firstName'] ?? userData['name'] ?? '',
        lastName: userData['lastName'] ?? '',
        username: userData['username'], // Only include if provided
        mobile: userData['mobile'] ?? userData['phone'] ?? '',
        role: userData['role'], // Only include if provided
      );

      final response = await _authRepository.register(request);

      // Save tokens if available
      if (response.accessToken != null) {
        await _tokenService.saveToken(response.accessToken!);
      }
      if (response.refreshToken != null) {
        await _tokenService.saveRefreshToken(response.refreshToken!);
      }

      emit(AuthRegistrationSuccess(
          user: response.user?.name ?? 'User', email: userData['email']));
      await FacebookEventService.logCompleteRegistration(
        registrationMethod: 'email',
      );
    } on DioException catch (e) {
      // Special case: If it's a 500 error related to maildev (email service)
      // the registration might have succeeded, so proceed to verification
      if (e.response?.statusCode == 500 &&
          e.response?.data != null &&
          e.response!.data.toString().contains('maildev')) {
        debugPrint(
            'Mail service error detected, but proceeding with registration flow');
        emit(AuthRegistrationSuccess(
            user: userData['firstName'] ?? 'User',
            email: userData['email'],
            isMailServiceError: true));
        return;
      }

      emit(AuthFailure(
        message: _formatDioError(e, isSignup: true),
        errorCode: e.response?.statusCode,
        fieldErrors: _extractFieldErrors(e),
      ));
    } catch (e) {
      emit(AuthFailure(
          message: 'An unexpected error occurred. Please try again.',
          errorDetails: e.toString()));
    }
  }

  Future<void> login(String identifier, String password) async {
    emit(AuthLoading());
    try {
      final request = LoginRequest(
        identifier: identifier,
        password: password,
      );

      final response = await _authRepository.login(request);

      // Save tokens
      await _tokenService.saveToken(response.accessToken);
      await _tokenService.saveRefreshToken(response.refreshToken);

      // If login is successful (200/201), we assume email is verified
      // because backend returns 422 for unverified accounts
      debugPrint('✅ Login successful - email is verified');
      emit(AuthLoginSuccess(response.accessToken));
    } on DioException catch (e) {
      debugPrint('🔴 Login DioException: ${e.response?.statusCode}');

      // Handle 422 - Email not verified
      if (e.response?.statusCode == 422) {
        final responseData = e.response?.data;
        debugPrint('🔴 422 Response data: $responseData');

        // Check if the error is about email verification
        if (responseData != null && responseData is Map) {
          final message = responseData['message']?.toString() ?? '';

          if (message.toLowerCase().contains('not yet verified') ||
              message.toLowerCase().contains('verification code')) {
            // Extract email from identifier (it could be email or phone)
            String email = identifier;

            debugPrint('✉️ Email not verified, redirecting to verification for: $email');

            // Emit unverified state
            emit(AuthLoginUnverified(email: email));
            return;
          }
        }
      }

      emit(AuthFailure(
        message: _formatDioError(e, isSignup: false),
        errorCode: e.response?.statusCode,
      ));
    } catch (e) {
      debugPrint('🔴 Login general error: $e');
      emit(AuthFailure(
          message:
              'Unable to login. Please check your credentials and try again.',
          errorDetails: e.toString()));
    }
  }


  // Helper method to format DioException errors
  String _formatDioError(DioException e, {bool isSignup = false}) {
    // Default messages based on context
    final defaultMessage =
        isSignup ? 'Unable to create account.' : 'Login failed.';

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
        return _extractErrorMessage(e.response?.data) ??
            'An account already exists with this email or phone number.';
      case 422:
        return _extractErrorMessage(e.response?.data) ??
            'Please fix the errors in your submission.';
      case 429:
        return 'Too many attempts. Please try again later.';
      case 500:
      case 501:
      case 502:
      case 503:
        // Detect duplicate-key DB error (server returns 500 instead of 409)
        final rawMessage = _extractErrorMessage(e.response?.data) ?? '';
        if (rawMessage.toLowerCase().contains('duplicate key') ||
            rawMessage.toLowerCase().contains('unique constraint') ||
            rawMessage.toLowerCase().contains('already exists')) {
          return 'An account with this email or phone number already exists.';
        }
        return 'Server error. Please try again later.';
      default:
        return _extractErrorMessage(e.response?.data) ??
            '$defaultMessage Please try again.';
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

      // Handle new server format: errorDetails.message array
      if (data.containsKey('errorDetails') && data['errorDetails'] is Map) {
        final errorDetails = data['errorDetails'] as Map;
        if (errorDetails['message'] is List) {
          final messages = errorDetails['message'] as List;
          final fieldErrors = <String, String>{};

          for (final message in messages) {
            if (message is Map) {
              message.forEach((key, value) {
                fieldErrors[key.toString()] = value.toString();
              });
            }
          }

          return fieldErrors.isNotEmpty ? fieldErrors : null;
        }
      }
    } catch (e) {
      debugPrint('Error extracting field errors: $e');
    }
    return null;
  }

  Future<void> verifyEmail(String email, String otp) async {
    emit(AuthLoading());
    try {
      final request = ConfirmEmailRequest(email: email, otp: otp);
      await _authRepository.confirmEmail(request);
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
      final request = ResendOtpRequest(email: email);
      await _authRepository.resendOtp(request);
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
      final userProfile = await _authRepository.getUserProfile();
      emit(AuthAuthenticated(user: userProfile.name));
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> forgotPassword(String email) async {
    emit(AuthLoading());
    try {
      final request = ForgotPasswordRequest(email: email);
      final response = await _authRepository.forgotPassword(request);
      emit(AuthForgotPasswordSuccess(message: response.message));
    } on DioException catch (e) {
      emit(AuthFailure(
        message: _formatDioError(e),
        errorCode: e.response?.statusCode,
      ));
    } catch (e) {
      emit(const AuthFailure(message: 'An unexpected error occurred'));
    }
  }

  Future<void> resetPassword(String email, String otp, String password) async {
    emit(AuthLoading());
    try {
      final request = ResetPasswordRequest(
        email: email,
        otp: otp,
        password: password,
      );
      final response = await _authRepository.resetPassword(request);
      emit(AuthPasswordResetSuccess(message: response.message));
    } on DioException catch (e) {
      emit(AuthFailure(
        message: _formatDioError(e),
        errorCode: e.response?.statusCode,
      ));
    } catch (e) {
      emit(const AuthFailure(message: 'An unexpected error occurred'));
    }
  }

  Future<void> updateProfile(Map<String, dynamic> profileData) async {
    emit(AuthLoading());
    try {
      final request = UpdateProfileRequest(
        name: profileData['name'],
        firstName: profileData['firstName'],
        lastName: profileData['lastName'],
        phone: profileData['phone'],
        mobile: profileData['mobile'],
        address: profileData['address'],
        dateOfBirth: profileData['dateOfBirth'],
        username: profileData['username'],
      );
      final user = await _authRepository.updateUserProfile(request);
      emit(AuthProfileUpdateSuccess(userProfile: user));
    } on DioException catch (e) {
      emit(AuthFailure(
        message: _formatDioError(e),
        errorCode: e.response?.statusCode,
        fieldErrors: _extractFieldErrors(e),
      ));
    } catch (e) {
      emit(const AuthFailure(message: 'An unexpected error occurred'));
    }
  }

  Future<void> googleLogin(String idToken) async {
    emit(AuthLoading());
    try {
      debugPrint('🔐 Starting Google login with token...');
      debugPrint('📝 Token length: ${idToken.length} characters');

      if (idToken.isEmpty) {
        debugPrint('❌ ERROR: idToken is EMPTY!');
        emit(const AuthFailure(message: 'Invalid authentication token'));
        return;
      }

      debugPrint('✅ Token validation passed, sending to backend...');

      final response = await _authRepository.googleLogin(idToken);
      final user = response.user;

      // Save tokens
      await _tokenService.saveToken(response.accessToken);
      await _tokenService.saveRefreshToken(response.refreshToken);

      debugPrint('✅ Google login successful, tokens saved');
      debugPrint('👤 User: ${user.email}, Phone: ${user.phone}');

      // Check if profile needs completion (no name or no phone)
      if (user.phone.isEmpty || user.name.isEmpty || user.name.toLowerCase() == 'user') {
        debugPrint('⚠️ Profile incomplete, emitting AuthNeedsProfileCompletion');
        emit(AuthNeedsProfileCompletion(
          accessToken: response.accessToken,
          user: user,
        ));
      } else {
        emit(AuthGoogleLoginSuccess(
          accessToken: response.accessToken,
          user: user,
        ));
      }
    } on DioException catch (e) {
      debugPrint('❌ Google login failed: ${e.message}');
      debugPrint('📊 Status code: ${e.response?.statusCode}');
      debugPrint('📄 Response data: ${e.response?.data}');

      // Provide more context for specific errors
      String errorMessage = _formatDioError(e);
      if (e.response?.statusCode == 422) {
        final responseData = e.response?.data;
        if (responseData is Map && responseData['message'] != null) {
          errorMessage = responseData['message'].toString();
        }
        debugPrint('⚠️  Backend validation error: $errorMessage');
      }

      emit(AuthFailure(
        message: errorMessage,
        errorCode: e.response?.statusCode,
      ));
    } catch (e) {
      debugPrint('❌ Google login unexpected error: $e');
      emit(const AuthFailure(message: 'An unexpected error occurred during Google sign-in'));
    }
  }

  Future<void> appleLogin(String identityToken, {String? authorizationCode}) async {
    emit(AuthLoading());
    try {
      debugPrint('🍎 Starting Apple login with token...');
      final response = await _authRepository.appleLogin(identityToken, authorizationCode: authorizationCode);
      final user = response.user;

      // Save tokens
      await _tokenService.saveToken(response.accessToken);
      await _tokenService.saveRefreshToken(response.refreshToken);

      debugPrint('✅ Apple login successful, tokens saved');
      debugPrint('👤 User: ${user.email}, Phone: ${user.phone}');

      // Check if profile needs completion
      if (user.phone.isEmpty || user.name.isEmpty || user.name.toLowerCase() == 'user') {
        emit(AuthNeedsProfileCompletion(
          accessToken: response.accessToken,
          user: user,
        ));
      } else {
        emit(AuthAppleLoginSuccess(
          accessToken: response.accessToken,
          user: user,
        ));
      }
    } on DioException catch (e) {
      debugPrint('❌ Apple login failed: ${e.message}');
      debugPrint('📊 Status code: ${e.response?.statusCode}');
      debugPrint('📄 Response data: ${e.response?.data}');

      String errorMessage = _formatDioError(e);
      if (e.response?.statusCode == 409) {
        final responseData = e.response?.data;
        if (responseData is Map && responseData['message'] != null) {
          errorMessage = responseData['message'].toString();
        }
        debugPrint('⚠️  Account already exists: $errorMessage');
      }

      emit(AuthFailure(
        message: errorMessage,
        errorCode: e.response?.statusCode,
      ));
    } catch (e) {
      debugPrint('❌ Apple login unexpected error: $e');
      emit(const AuthFailure(message: 'An unexpected error occurred during Apple sign-in'));
    }
  }

  Future<void> completeProfile(String name, String phone) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.completeProfile(name, phone);
      emit(AuthProfileUpdateSuccess(userProfile: user));
    } on DioException catch (e) {
      emit(AuthFailure(
        message: _formatDioError(e),
        errorCode: e.response?.statusCode,
        fieldErrors: _extractFieldErrors(e),
      ));
    } catch (e) {
      emit(const AuthFailure(message: 'An unexpected error occurred during profile completion'));
    }
  }
}
