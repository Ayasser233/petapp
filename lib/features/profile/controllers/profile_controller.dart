import 'package:get/get.dart';
import 'package:petapp/core/services/token_service.dart';
import 'package:petapp/core/services/auth_service.dart';
import 'package:petapp/features/profile/data/repositories/profile_repository.dart';
import 'package:petapp/features/auth/data/models/user_model.dart';
import 'package:petapp/core/utils/validation_utils.dart';

class ProfileController extends GetxController {
  final ProfileRepository _profileRepository;

  ProfileController({required ProfileRepository profileRepository})
      : _profileRepository = profileRepository;

  // Observable user profile
  final Rx<UserModel?> _userProfile = Rx<UserModel?>(null);
  UserModel? get userProfile => _userProfile.value;

  // Loading states
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxBool _isUpdating = false.obs;
  bool get isUpdating => _isUpdating.value;

  final RxBool _isUploadingImage = false.obs;
  bool get isUploadingImage => _isUploadingImage.value;

  // Validation methods

  /// Validate email format
  String? _validateEmail(String? email) {
    return ValidationUtils.validateEmail(email);
  }

  /// Validate name (first name or last name)
  String? _validateName(String? name) {
    return ValidationUtils.validateName(name);
  }

  /// Validate phone number
  String? _validatePhone(String? phone) {
    return ValidationUtils.validatePhone(phone);
  }

  /// Validate username (alphanumeric and underscore only, 3-20 chars)
  String? _validateUsername(String? username) {
    if (username == null || username.isEmpty) {
      return null; // Username is optional
    }

    if (username.length < 3) {
      return 'Username must be at least 3 characters';
    }

    if (username.length > 20) {
      return 'Username must be less than 20 characters';
    }

    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username)) {
      return 'Username can only contain letters, numbers, and underscores';
    }

    return null;
  }

  /// Validate all profile data at once
  Map<String, String> _validateProfileData({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? mobile,
    String? username,
  }) {
    final errors = <String, String>{};

    // Validate first name
    if (firstName != null) {
      final error = _validateName(firstName);
      if (error != null) errors['firstName'] = error;
    }

    // Validate last name
    if (lastName != null) {
      final error = _validateName(lastName);
      if (error != null) errors['lastName'] = error;
    }

    // Validate email
    if (email != null) {
      final error = _validateEmail(email);
      if (error != null) errors['email'] = error;
    }

    // Validate phone
    if (phone != null) {
      final error = _validatePhone(phone);
      if (error != null) errors['phone'] = error;
    }

    // Validate mobile (if different from phone)
    if (mobile != null && mobile != phone) {
      final error = _validatePhone(mobile);
      if (error != null) errors['mobile'] = error;
    }

    // Validate username
    final usernameError = _validateUsername(username);
    if (usernameError != null) errors['username'] = usernameError;

    return errors;
  }

  /// Show validation errors to user
  void _showValidationErrors(Map<String, String> errors) {
    if (errors.isEmpty) return;

    final errorMessages =
        errors.entries.map((e) => '${e.key}: ${e.value}').join('\n');

    Get.snackbar(
      'Validation Error',
      errorMessages,
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
      duration: const Duration(seconds: 4),
    );
  }

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
        _userProfile.value = UserModel(
          id: 'guest',
          name: 'Guest User',
          email: 'guest@example.com',
          phone: '',
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
        _userProfile.value = UserModel(
          id: 'unknown',
          name: '',
          email: '',
          phone: '',
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
      if (e.toString().contains('401') ||
          e.toString().contains('unauthorized') ||
          e.toString().contains('token') ||
          e.toString().contains('Unauthorized')) {
        final authService = Get.find<AuthService>();
        await authService.handleTokenExpiration();
      }

      // Create fallback profile on error
      _userProfile.value = UserModel(
        id: 'error',
        name: 'Default User',
        email: 'user@example.com',
        phone: '',
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
  Future<bool> updateProfile({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? mobile,
    String? username,
  }) async {
    try {
      _isUpdating.value = true;

      // Validate all input data first
      final validationErrors = _validateProfileData(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        mobile: mobile,
        username: username,
      );

      // If there are validation errors, show them and return false
      if (validationErrors.isNotEmpty) {
        _showValidationErrors(validationErrors);
        return false;
      }

      // Build profile data with only non-null and non-empty values
      final profileData = <String, dynamic>{};

      if (firstName != null && firstName.trim().isNotEmpty) {
        profileData['firstName'] = firstName.trim();
      }
      if (lastName != null && lastName.trim().isNotEmpty) {
        profileData['lastName'] = lastName.trim();
      }
      if (email != null && email.trim().isNotEmpty) {
        profileData['email'] = email.trim().toLowerCase();
      }
      if (phone != null && phone.trim().isNotEmpty) {
        String phoneNumber = phone.trim();

        // Add +20 country code if not already present
        if (!phoneNumber.startsWith('+')) {
          // DO NOT remove leading 0 - backend expects it
          phoneNumber = '+20$phoneNumber';
        }
        profileData['mobile'] = phoneNumber; // API expects 'mobile' not 'phone'
      }
      if (mobile != null && mobile.trim().isNotEmpty) {
        String mobileNumber = mobile.trim();
        // Add +20 country code if not already present
        if (!mobileNumber.startsWith('+')) {
          // DO NOT remove leading 0 - backend expects it
          mobileNumber = '+20$mobileNumber';
        }
        profileData['mobile'] = mobileNumber;
      }
      // if (username != null) profileData['username'] = username.trim().toLowerCase();



      final updatedProfile =
          await _profileRepository.updateProfile(profileData);

      _userProfile.value = updatedProfile;

      Get.snackbar(
        'Success',
        'Profile updated successfully',
        backgroundColor: Get.theme.primaryColor,
        colorText: Get.theme.colorScheme.onPrimary,
      );

      return true;
    } catch (e) {

      // Error already handled by ErrorHandlerService
      return false;
    } finally {
      _isUpdating.value = false;
    }
  }

  /// Update profile with name (convenience method for backward compatibility)
  Future<bool> updateProfileWithName({
    required String name,
    String? email,
    String? phone,
    String? address,
    String? dateOfBirth,
  }) async {
    // Split name into firstName and lastName
    final nameParts = name.trim().split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    return updateProfile(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
    );
  }

  /// Quick update methods for specific fields

  /// Update only user name
  Future<bool> updateUserName({
    required String firstName,
    required String lastName,
  }) async {
    return updateProfile(
      firstName: firstName,
      lastName: lastName,
    );
  }

  /// Update only email
  Future<bool> updateUserEmail(String email) async {
    return updateProfile(email: email);
  }

  /// Update only phone number
  Future<bool> updateUserPhone(String phone) async {
    return updateProfile(phone: phone);
  }

  /// Update only username
  Future<bool> updateUsername(String username) async {
    return updateProfile(username: username);
  }

  /// Update contact information (email and phone)
  Future<bool> updateContactInfo({
    required String email,
    required String phone,
  }) async {
    return updateProfile(
      email: email,
      phone: phone,
    );
  }

  /// Update personal information (name)
  Future<bool> updatePersonalInfo({
    required String firstName,
    required String lastName,
  }) async {
    return updateProfile(
      firstName: firstName,
      lastName: lastName,
    );
  }

  /// Change user data (fullName, photo) using /users/profile
  Future<bool> changeMyData({
    required String fullName,
    String? photoPath,
  }) async {
    try {
      _isUpdating.value = true;

      // Validate name
      if (fullName.trim().isEmpty) {
        _showValidationErrors({'name': 'Name is required'});
        return false;
      }

      // Split fullName into firstName and lastName for the API
      final nameParts = fullName.trim().split(' ');
      final firstName = nameParts.isNotEmpty ? nameParts.first : '';
      final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      final updatedProfile = await _profileRepository.changeMyData(
        firstName: firstName,
        lastName: lastName,
        photoPath: photoPath,
      );

      _userProfile.value = updatedProfile;

      Get.snackbar(
        'Success',
        'Profile updated successfully',
        backgroundColor: Get.theme.primaryColor,
        colorText: Get.theme.colorScheme.onPrimary,
      );

      return true;
    } catch (e) {
      return false;
    } finally {
      _isUpdating.value = false;
    }
  }

  /// Validate profile data without updating (for form validation)
  Map<String, String> validateProfileFields({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? mobile,
    String? username,
  }) {
    return _validateProfileData(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      mobile: mobile,
      username: username,
    );
  }

  /// Check if a specific field is valid
  bool isFieldValid(String fieldName, String? value) {
    switch (fieldName.toLowerCase()) {
      case 'firstname':
        return _validateName(value) == null;
      case 'lastname':
        return _validateName(value) == null;
      case 'email':
        return _validateEmail(value) == null;
      case 'phone':
        return _validatePhone(value) == null;
      case 'mobile':
        return _validatePhone(value) == null;
      case 'username':
        return _validateUsername(value) == null;
      default:
        return true; // Unknown fields are considered valid
    }
  }

  /// Get validation error message for a specific field
  String? getFieldError(String fieldName, String? value) {
    switch (fieldName.toLowerCase()) {
      case 'firstname':
        return _validateName(value);
      case 'lastname':
        return _validateName(value);
      case 'email':
        return _validateEmail(value);
      case 'phone':
        return _validatePhone(value);
      case 'mobile':
        return _validatePhone(value);
      case 'username':
        return _validateUsername(value);
      default:
        return null;
    }
  }

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
