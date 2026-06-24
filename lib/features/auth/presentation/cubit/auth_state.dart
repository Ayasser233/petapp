part of 'auth_cubit.dart';

// The UserProfile class is imported through auth_cubit.dart

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

// Initial state when the app starts
class AuthInitial extends AuthState {}

// Loading state during API calls
class AuthLoading extends AuthState {}

// User is authenticated
class AuthAuthenticated extends AuthState {
  final String user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

// User is not authenticated
class AuthUnauthenticated extends AuthState {}

// Registration was successful
class AuthRegistrationSuccess extends AuthState {
  final String user;
  final String email;
  final bool isMailServiceError; // Flag to indicate mail service error

  const AuthRegistrationSuccess({
    required this.user,
    required this.email,
    this.isMailServiceError = false,
  });

  @override
  List<Object?> get props => [user, email, isMailServiceError];
}

// Login was successful
class AuthLoginSuccess extends AuthState {
  final String accessToken;

  const AuthLoginSuccess(this.accessToken);

  @override
  List<Object?> get props => [accessToken];
}

// Login successful but email not verified
class AuthLoginUnverified extends AuthState {
  final String email;

  const AuthLoginUnverified({required this.email});

  @override
  List<Object?> get props => [email];
}

// Email verification was successful
class AuthVerificationSuccess extends AuthState {
  const AuthVerificationSuccess();
}

// Resending verification email was successful
class AuthResendVerificationSuccess extends AuthState {
  const AuthResendVerificationSuccess();
}

// Forgot password OTP sent successfully
class AuthForgotPasswordSuccess extends AuthState {
  final String message;

  const AuthForgotPasswordSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

// Password reset was successful
class AuthPasswordResetSuccess extends AuthState {
  final String message;

  const AuthPasswordResetSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

// Token refresh was successful
class AuthTokenRefreshSuccess extends AuthState {
  const AuthTokenRefreshSuccess();
}

// Profile update was successful
class AuthProfileUpdateSuccess extends AuthState {
  final UserModel userProfile;

  const AuthProfileUpdateSuccess({required this.userProfile});

  @override
  List<Object?> get props => [userProfile];
}

// Google login was successful
class AuthGoogleLoginSuccess extends AuthState {
  final String accessToken;
  final UserModel user;

  const AuthGoogleLoginSuccess({
    required this.accessToken,
    required this.user,
  });

  @override
  List<Object?> get props => [accessToken, user];
}

// Apple login was successful
class AuthAppleLoginSuccess extends AuthState {
  final String accessToken;
  final UserModel user;

  const AuthAppleLoginSuccess({
    required this.accessToken,
    required this.user,
  });

  @override
  List<Object?> get props => [accessToken, user];
}

// User logged in with social but needs to complete name/phone
class AuthNeedsProfileCompletion extends AuthState {
  final String accessToken;
  final UserModel user;

  const AuthNeedsProfileCompletion({
    required this.accessToken,
    required this.user,
  });

  @override
  List<Object?> get props => [accessToken, user];
}

// Logout was successful
class AuthLogoutSuccess extends AuthState {}

// An error occurred
class AuthFailure extends AuthState {
  final String message;
  final String? errorDetails;
  final int? errorCode;
  final Map<String, String>? fieldErrors;

  const AuthFailure({
    required this.message,
    this.errorDetails,
    this.errorCode,
    this.fieldErrors,
  });

  @override
  List<Object?> get props => [message, errorDetails, errorCode, fieldErrors];
}
