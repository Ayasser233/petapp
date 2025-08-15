import 'package:get/get.dart';
import 'package:petapp/core/services/api_client.dart';
import 'package:petapp/core/services/error_handler_service.dart';
import 'package:petapp/core/services/token_service.dart';
import 'package:petapp/features/profile/data/models/user_profile_model.dart';

class ProfileRepository {
  final ApiClient _apiClient;

  ProfileRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Get user profile data
  Future<UserProfileModel> getUserProfile() async {
    try {
      final response = await _apiClient.getUserProfile();
      return UserProfileModel.fromJson(response.data);
      
    } catch (error) {
      
      ErrorHandlerService.instance.handleError(error);
      rethrow;
    }
  }

  /// Update user profile
  // Future<UserProfileModel> updateProfile(Map<String, dynamic> profileData) async {
  //   try {
  //     final response = await _apiClient.updateProfile(profileData);
  //     return UserProfileModel.fromJson(response.data);
  //   } catch (error) {
  //     ErrorHandlerService.instance.handleError(error);
  //     rethrow;
  //   }
  // }

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