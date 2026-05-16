import 'package:get/get.dart';
import 'package:petapp/core/services/api_client.dart';
import 'package:petapp/core/services/error_handler_service.dart';
import 'package:petapp/core/services/auth_service.dart';
import 'package:petapp/features/auth/data/models/user_model.dart';

class ProfileRepository {
  final ApiClient _apiClient;

  ProfileRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Helper method to handle token expiration and authentication errors
  Future<void> _handleAuthError(dynamic error) async {
    if (error.toString().contains('401') ||
        error.toString().contains('unauthorized') ||
        error.toString().contains('token') ||
        error.toString().contains('Unauthorized')) {
      final authService = Get.find<AuthService>();
      await authService.handleTokenExpiration();
    }
  }

  /// Get user profile data
  Future<UserModel> getUserProfile() async {
    // Check authentication before making API call
    final authService = Get.find<AuthService>();
    if (authService.authStatus != AuthStatus.authenticated) {
      print(
          '🚫 ProfileRepository: User not authenticated, cannot fetch profile');
      throw Exception('Authentication required to access profile data');
    }

    try {
      final response = await _apiClient.getUserProfile();
      print('✅ ProfileRepository: Get profile API response: ${response.data}');

      // API shape: { success, message, data: { id, email, mobile, … } }
      // Fall through: data → user → top-level (legacy fallback)
      final body = response.data;
      final userData = (body is Map && body['data'] is Map)
          ? body['data'] as Map<String, dynamic>
          : (body is Map && body['user'] is Map)
              ? body['user'] as Map<String, dynamic>
              : (body is Map<String, dynamic> ? body : <String, dynamic>{});
      print('📋 ProfileRepository: Extracted user data for get profile: $userData');

      return UserModel.fromJson(userData);
    } catch (error) {
      await _handleAuthError(error);
      ErrorHandlerService.instance.handleError(error);
      rethrow;
    }
  }

  /// Update user profile
  Future<UserModel> updateProfile(Map<String, dynamic> profileData) async {
    // Check authentication before updating profile
    final authService = Get.find<AuthService>();
    if (authService.authStatus != AuthStatus.authenticated) {
      print(
          '🚫 ProfileRepository: User not authenticated, cannot update profile');
      throw Exception('Authentication required to update profile');
    }

    try {
      print(
          '🔄 ProfileRepository: Sending update request with data: $profileData');
      final response = await _apiClient.updateUserProfile(profileData);
      print('✅ ProfileRepository: Received API response: ${response.data}');

      // API shape: { success, message, data: { … } }
      final body = response.data;
      final userData = (body is Map && body['data'] is Map)
          ? body['data'] as Map<String, dynamic>
          : (body is Map && body['user'] is Map)
              ? body['user'] as Map<String, dynamic>
              : (body is Map<String, dynamic> ? body : <String, dynamic>{});
      print('📋 ProfileRepository: Extracted user data: $userData');

      final userModel = UserModel.fromJson(userData);
      print('🎯 ProfileRepository: Created UserModel: ${userModel.toJson()}');

      return userModel;
    } catch (error) {
      print('❌ ProfileRepository: Update profile error: $error');
      await _handleAuthError(error);
      ErrorHandlerService.instance.handleError(error);
      rethrow;
    }
  }

  /// Update user name (firstName and lastName)
  Future<UserModel> updateUserName({
    required String firstName,
    required String lastName,
  }) async {
    return updateProfile({
      'firstName': firstName,
      'lastName': lastName,
    });
  }

  /// Update user email
  Future<UserModel> updateUserEmail(String email) async {
    return updateProfile({
      'email': email,
    });
  }

  /// Update user phone
  Future<UserModel> updateUserPhone(String phone) async {
    return updateProfile({
      'phone': phone,
    });
  }

  /// Update user address
  Future<UserModel> updateUserAddress(String address) async {
    return updateProfile({
      'address': address,
    });
  }

  /// Update multiple profile fields at once
  Future<UserModel> updateMultipleFields({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? mobile,
    String? username,
    String? address,
    String? dateOfBirth,
  }) async {
    final profileData = <String, dynamic>{};

    if (firstName != null) profileData['firstName'] = firstName;
    if (lastName != null) profileData['lastName'] = lastName;
    if (email != null) profileData['email'] = email;
    if (phone != null) profileData['phone'] = phone;
    if (mobile != null) profileData['mobile'] = mobile;
    if (username != null) profileData['username'] = username;
    if (address != null) profileData['address'] = address;
    if (dateOfBirth != null) profileData['dateOfBirth'] = dateOfBirth;

    return updateProfile(profileData);
  }

  // /// Upload profile picture
  // Future<String> uploadProfilePicture(String imagePath) async {
  //   try {
  //     final response = await _apiClient.uploadProfilePicture(imagePath);
  //     return response.data['profile_picture_url'];
  //   } catch (error) {
  //     ErrorHandlerService.instance.handleError(error);
  //     rethrow;
  //   }
  // }

  /// Change password
  // Future<void> changePassword({
  //   required String currentPassword,
  //   required String newPassword,
  // }) async {
  //   try {
  //     await _apiClient.changePassword({
  //       'current_password': currentPassword,
  //       'new_password': newPassword,
  //       'new_password_confirmation': newPassword,
  //     });
  //   } catch (error) {
  //     ErrorHandlerService.instance.handleError(error);
  //     rethrow;
  //   }
  // }

  /// Enable/Disable two-factor authentication
  // Future<Map<String, dynamic>> toggleTwoFactorAuth(bool enable) async {
  //   try {
  //     final response = await _apiClient.toggleTwoFactorAuth({
  //       'enable': enable,
  //     });
  //     return response.data;
  //   } catch (error) {
  //     ErrorHandlerService.instance.handleError(error);
  //     rethrow;
  //   }
  // }

  /// Deactivate account
  // Future<void> deactivateAccount(String password) async {
  //   try {
  //     await _apiClient.deactivateAccount({
  //       'password': password,
  //     });
  //   } catch (error) {
  //     ErrorHandlerService.instance.handleError(error);
  //     rethrow;
  //   }
  // }

  /// Delete account permanently
  // Future<void> deleteAccount(String password) async {
  //   try {
  //     await _apiClient.deleteAccount({
  //       'password': password,
  //     });
  //   } catch (error) {
  //     ErrorHandlerService.instance.handleError(error);
  //     rethrow;
  //   }
  // }

  /// Get account settings
  // Future<Map<String, dynamic>> getAccountSettings() async {
  //   try {
  //     final response = await _apiClient.getAccountSettings();
  //     return response.data;
  //   } catch (error) {
  //     ErrorHandlerService.instance.handleError(error);
  //     rethrow;
  //   }
  // }

  /// Update account settings
  // Future<void> updateAccountSettings(Map<String, dynamic> settings) async {
  //   try {
  //     await _apiClient.updateAccountSettings(settings);
  //   } catch (error) {
  //     ErrorHandlerService.instance.handleError(error);
  //     rethrow;
  //   }
  // }
}
