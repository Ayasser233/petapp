import 'package:get/get.dart';
import 'package:petapp/core/services/token_service.dart';
import 'package:petapp/core/services/auth_service.dart';
import 'package:petapp/features/profile/data/repositories/profile_repository.dart';
import 'package:petapp/features/profile/data/models/user_profile_model.dart';

class ProfileController extends GetxController {
  final ProfileRepository _profileRepository;

  ProfileController({required ProfileRepository profileRepository})
      : _profileRepository = profileRepository;

  // Observable user profile
  final Rx<UserProfileModel?> _userProfile = Rx<UserProfileModel?>(null);
  UserProfileModel? get userProfile => _userProfile.value;

  // Loading states
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxBool _isUpdating = false.obs;
  bool get isUpdating => _isUpdating.value;

  final RxBool _isUploadingImage = false.obs;
  bool get isUploadingImage => _isUploadingImage.value;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
    
    // Listen to auth status changes and reload profile
    final authService = Get.find<AuthService>();
    authService.authStateChanges.listen((authStatus) {
      loadUserProfile();
    });
  }

  /// Load user profile from API
  Future<void> loadUserProfile() async {
    try {
      _isLoading.value = true;
      
      // Check authentication status
      final authService = Get.find<AuthService>();
      
      if (authService.authStatus == AuthStatus.guest) {
        // Create a default guest profile
        _userProfile.value = UserProfileModel(
          id: 'guest',
          name: 'Guest User',
          email: 'guest@example.com',
          phone: '',
          address: '',
          dateOfBirth: '1990-01-01',
          profilePictureUrl: null,
          emailVerified: false,
          twoFactorEnabled: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        return;
      }
      
      final token = await Get.find<TokenService>().getToken();
    
      if (token == null || token.isEmpty) {
        // Create empty profile for unauthenticated users
        _userProfile.value = UserProfileModel(
          id: 'unknown',
          name: '',
          email: '',
          phone: '',
          address: '',
          dateOfBirth: '1990-01-01',
          profilePictureUrl: null,
          emailVerified: false,
          twoFactorEnabled: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        return;
      }
      
      final profile = await _profileRepository.getUserProfile();
      _userProfile.value = profile;
     
    } catch (e) {
      // Error already handled by ErrorHandlerService
      if(e.toString().contains('401') || e.toString().contains('unauthorized')) {
       final tokenService = Get.find<TokenService>();
        await tokenService.clearToken();
      }
      
      // Create fallback profile on error
      _userProfile.value = UserProfileModel(
        id: 'error',
        name: 'Default User',
        email: 'user@example.com',
        phone: '',
        address: '',
        dateOfBirth: '1990-01-01',
        profilePictureUrl: null,
        emailVerified: false,
        twoFactorEnabled: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Update user profile
  // Future<bool> updateProfile({
  //   required String name,
  //   required String email,
  //   String? phone,
  //   String? address,
  //   String? dateOfBirth,
  // }) async {
  //   try {
  //     _isUpdating.value = true;
      
  //     final profileData = {
  //       'name': name,
  //       'email': email,
  //       'phone': phone,
  //       'address': address,
  //       'date_of_birth': dateOfBirth,
  //     };

  //     final updatedProfile = await _profileRepository.updateProfile(profileData);
  //     _userProfile.value = updatedProfile;
      
  //     Get.snackbar(
  //       'Success',
  //       'Profile updated successfully',
  //       backgroundColor: Get.theme.primaryColor,
  //       colorText: Get.theme.colorScheme.onPrimary,
  //     );
      
  //     return true;
  //   } catch (e) {
  //     // Error already handled by ErrorHandlerService
  //     return false;
  //   } finally {
  //     _isUpdating.value = false;
  //   }
  // }

  // /// Upload profile picture
  // Future<bool> uploadProfilePicture(String imagePath) async {
  //   try {
  //     _isUploadingImage.value = true;
      
  //     final imageUrl = await _profileRepository.uploadProfilePicture(imagePath);
      
  //     // Update local profile data
  //     if (_userProfile.value != null) {
  //       _userProfile.value = _userProfile.value!.copyWith(
  //         profilePictureUrl: imageUrl,
  //       );
  //     }
      
  //     Get.snackbar(
  //       'Success',
  //       'Profile picture updated successfully',
  //       backgroundColor: Get.theme.primaryColor,
  //       colorText: Get.theme.colorScheme.onPrimary,
  //     );
      
  //     return true;
  //   } catch (e) {
  //     // Error already handled by ErrorHandlerService
  //     return false;
  //   } finally {
  //     _isUploadingImage.value = false;
  //   }
  // }

  // /// Change password
  // Future<bool> changePassword({
  //   required String currentPassword,
  //   required String newPassword,
  // }) async {
  //   try {
  //     await _profileRepository.changePassword(
  //       currentPassword: currentPassword,
  //       newPassword: newPassword,
  //     );
      
  //     Get.snackbar(
  //       'Success',
  //       'Password changed successfully',
  //       backgroundColor: Get.theme.primaryColor,
  //       colorText: Get.theme.colorScheme.onPrimary,
  //     );
      
  //     return true;
  //   } catch (e) {
  //     // Error already handled by ErrorHandlerService
  //     return false;
  //   }
  // }

  // /// Toggle two-factor authentication
  // Future<bool> toggleTwoFactorAuth(bool enable) async {
  //   try {
  //     final result = await _profileRepository.toggleTwoFactorAuth(enable);
      
  //     // Update local profile data
  //     if (_userProfile.value != null) {
  //       _userProfile.value = _userProfile.value!.copyWith(
  //         twoFactorEnabled: enable,
  //       );
  //     }
      
  //     Get.snackbar(
  //       'Success',
  //       enable ? 'Two-factor authentication enabled' : 'Two-factor authentication disabled',
  //       backgroundColor: Get.theme.primaryColor,
  //       colorText: Get.theme.colorScheme.onPrimary,
  //     );
      
  //     return true;
  //   } catch (e) {
  //     // Error already handled by ErrorHandlerService
  //     return false;
  //   }
  // }

  // /// Deactivate account
  // Future<bool> deactivateAccount(String password) async {
  //   try {
  //     await _profileRepository.deactivateAccount(password);
      
  //     Get.snackbar(
  //       'Account Deactivated',
  //       'Your account has been deactivated successfully',
  //       backgroundColor: Get.theme.primaryColor,
  //       colorText: Get.theme.colorScheme.onPrimary,
  //     );
      
  //     // Navigate to login or onboarding
  //     Get.offAllNamed('/login');
      
  //     return true;
  //   } catch (e) {
  //     // Error already handled by ErrorHandlerService
  //     return false;
  //   }
  // }

  // /// Delete account permanently
  // Future<bool> deleteAccount(String password) async {
  //   try {
  //     await _profileRepository.deleteAccount(password);
      
  //     Get.snackbar(
  //       'Account Deleted',
  //       'Your account has been deleted permanently',
  //       backgroundColor: Get.theme.primaryColor,
  //       colorText: Get.theme.colorScheme.onPrimary,
  //     );
      
  //     // Navigate to login or onboarding
  //     Get.offAllNamed('/login');
      
  //     return true;
  //   } catch (e) {
  //     // Error already handled by ErrorHandlerService
  //     return false;
  //   }
  // }

  /// Refresh profile data
  Future<void> refreshProfile() async {
    await loadUserProfile();
  }
}