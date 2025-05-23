import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:petapp/features/auth/data/models/user_model.dart';
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
      String errorMessage = 'Registration failed';
      
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

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.login(email, password);
      emit(AuthLoginSuccess(user: user));
    } on DioException catch (e) {
      String errorMessage = 'Login failed';
      
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