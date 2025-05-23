import 'package:petapp/core/services/api_client.dart';
import 'package:petapp/features/auth/data/models/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<String> register(Map<String, dynamic> userData) async {
    try {
      final response = await _apiClient.register(userData);
      return response.data['access_token'];
    } catch (e) {
      rethrow; // Let the Cubit handle errors
    }
  }

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _apiClient.login(email, password);
      return UserModel.fromJson(response.data['user']);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> verifyEmail(String email, String otp) async {
    try {
      await _apiClient.verifyEmail(email, otp);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resendVerification(String email) async {
    try {
      await _apiClient.resendVerification(email);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _apiClient.forgotPassword(email);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword(String token, String password) async {
    try {
      await _apiClient.resetPassword(token, password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _apiClient.logout();
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> getUserProfile() async {
    try {
      final response = await _apiClient.getUserProfile();
      return UserModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}