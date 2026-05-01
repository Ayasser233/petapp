import 'package:petapp/features/auth/data/models/user_model.dart';

// Auth Response Models for API v1 endpoints
class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final UserModel user;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    // Unwrap nested 'data' key if present (e.g. {"success":true,"data":{...}})
    final d = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;
    return AuthResponse(
      accessToken: d['accessToken'] ?? d['access_token'] ?? '',
      refreshToken: d['refreshToken'] ?? d['refresh_token'] ?? '',
      user: UserModel.fromJson(d['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'user': user.toJson(),
    };
  }

  @override
  String toString() {
    return 'AuthResponse(accessToken: [HIDDEN], refreshToken: [HIDDEN], user: ${user.name})';
  }
}

class RegisterResponse {
  final String message;
  final UserModel? user;
  final String? accessToken;
  final String? refreshToken;

  RegisterResponse({
    required this.message,
    this.user,
    this.accessToken,
    this.refreshToken,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    final d = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;
    return RegisterResponse(
      message: json['message'] ?? d['message'] ?? 'Registration successful',
      user: d['user'] != null ? UserModel.fromJson(d['user']) : null,
      accessToken: d['accessToken'] ?? d['access_token'],
      refreshToken: d['refreshToken'] ?? d['refresh_token'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'message': message,
    };
    
    if (user != null) data['user'] = user!.toJson();
    if (accessToken != null) data['accessToken'] = accessToken;
    if (refreshToken != null) data['refreshToken'] = refreshToken;
    
    return data;
  }

  @override
  String toString() {
    return 'RegisterResponse(message: $message, user: ${user?.name})';
  }
}

class ConfirmEmailResponse {
  final String message;
  final bool success;
  final UserModel? user;

  ConfirmEmailResponse({
    required this.message,
    this.success = true,
    this.user,
  });

  factory ConfirmEmailResponse.fromJson(Map<String, dynamic> json) {
    return ConfirmEmailResponse(
      message: json['message'] ?? 'Email confirmed successfully',
      success: json['success'] ?? true,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'message': message,
      'success': success,
    };
    
    if (user != null) data['user'] = user!.toJson();
    
    return data;
  }

  @override
  String toString() {
    return 'ConfirmEmailResponse(message: $message, success: $success)';
  }
}

class ForgotPasswordResponse {
  final String message;
  final bool success;

  ForgotPasswordResponse({
    required this.message,
    this.success = true,
  });

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponse(
      message: json['message'] ?? 'Password reset instructions sent',
      success: json['success'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'success': success,
    };
  }

  @override
  String toString() {
    return 'ForgotPasswordResponse(message: $message, success: $success)';
  }
}

class ResetPasswordResponse {
  final String message;
  final bool success;

  ResetPasswordResponse({
    required this.message,
    this.success = true,
  });

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponse(
      message: json['message'] ?? 'Password reset successfully',
      success: json['success'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'success': success,
    };
  }

  @override
  String toString() {
    return 'ResetPasswordResponse(message: $message, success: $success)';
  }
}

class RefreshTokenResponse {
  final String accessToken;
  final String refreshToken;

  RefreshTokenResponse({
    required this.accessToken,
    required this.refreshToken,
  });

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    final d = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;
    return RefreshTokenResponse(
      accessToken: d['accessToken'] ?? d['access_token'] ?? '',
      refreshToken: d['refreshToken'] ?? d['refresh_token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }

  @override
  String toString() {
    return 'RefreshTokenResponse(accessToken: [HIDDEN], refreshToken: [HIDDEN])';
  }
}

class ResendOtpResponse {
  final String message;
  final bool success;

  ResendOtpResponse({
    required this.message,
    this.success = true,
  });

  factory ResendOtpResponse.fromJson(Map<String, dynamic> json) {
    return ResendOtpResponse(
      message: json['message'] ?? 'OTP sent successfully',
      success: json['success'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'success': success,
    };
  }

  @override
  String toString() {
    return 'ResendOtpResponse(message: $message, success: $success)';
  }
}

class LogoutResponse {
  final String message;
  final bool success;

  LogoutResponse({
    required this.message,
    this.success = true,
  });

  factory LogoutResponse.fromJson(Map<String, dynamic> json) {
    return LogoutResponse(
      message: json['message'] ?? 'Logged out successfully',
      success: json['success'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'success': success,
    };
  }

  @override
  String toString() {
    return 'LogoutResponse(message: $message, success: $success)';
  }
}