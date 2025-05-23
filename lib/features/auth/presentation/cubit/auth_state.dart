part of 'auth_cubit.dart';

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
  final UserModel user;

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

  const AuthRegistrationSuccess({required this.user, required this.email});
  
  @override
  List<Object?> get props => [user, email];
}

// Login was successful
class AuthLoginSuccess extends AuthState {
  final UserModel user;

  const AuthLoginSuccess({required this.user});
  
  @override
  List<Object?> get props => [user];
}

// Email verification was successful
class AuthVerificationSuccess extends AuthState {
  const AuthVerificationSuccess();
}

// Resending verification email was successful
class AuthResendVerificationSuccess extends AuthState {
  const AuthResendVerificationSuccess();
}

// Logout was successful
class AuthLogoutSuccess extends AuthState {}

// An error occurred
class AuthFailure extends AuthState {
  final String message;

  const AuthFailure({required this.message});
  
  @override
  List<Object?> get props => [message];
}