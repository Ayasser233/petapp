import 'package:petapp/core/services/api_client.dart';

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

  Future<String> login(String email, String password) async {
    try {
      final response = await _apiClient.login(email, password);
      return response.data['access_token'];
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

  Future<String> getUserProfile() async {
    try {
      final response = await _apiClient.getUserProfile();
      return response.data['access_token'];
    } catch (e) {
      rethrow;
    }
  }
}