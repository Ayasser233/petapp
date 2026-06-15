import 'package:petapp/core/services/api_client.dart';
import 'package:petapp/core/utils/api_constants.dart';
import 'package:petapp/features/auth/data/models/user_model.dart';
import 'package:petapp/features/auth/data/models/auth_request_models.dart';
import 'package:petapp/features/auth/data/models/auth_response_models.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      final response = await _apiClient.register(request.toJson());
      return RegisterResponse.fromJson(response.data);
    } catch (e) {
      rethrow; // Let the Cubit handle errors
    }
  }

  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _apiClient.login(
        request.identifier,
        request.password,
      );
      return AuthResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<ConfirmEmailResponse> confirmEmail(ConfirmEmailRequest request) async {
    try {
      final response = await _apiClient.confirmEmail(request.email, request.otp);
      return ConfirmEmailResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<ResendOtpResponse> resendOtp(ResendOtpRequest request) async {
    try {
      final response = await _apiClient.resendOtp(request.email);
      return ResendOtpResponse.fromJson(response.data ?? {'message': 'OTP sent successfully'});
    } catch (e) {
      rethrow;
    }
  }

  Future<ForgotPasswordResponse> forgotPassword(ForgotPasswordRequest request) async {
    try {
      final response = await _apiClient.forgotPassword(request.email);
      return ForgotPasswordResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<ResetPasswordResponse> resetPassword(ResetPasswordRequest request) async {
    try {
      final response = await _apiClient.resetPassword(request.email, request.otp, request.password);
      return ResetPasswordResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<ConfirmEmailResponse> confirmNewEmail(ConfirmNewEmailRequest request) async {
    try {
      final response = await _apiClient.confirmNewEmail(request.email, request.otp);
      return ConfirmEmailResponse.fromJson(response.data ?? {'message': 'Email confirmed successfully'});
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

  Future<UserModel> updateUserProfile(UpdateProfileRequest request) async {
    try {
      final response = await _apiClient.updateUserProfile(request.toJson());
      return UserModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<RefreshTokenResponse> refreshToken(RefreshTokenRequest request) async {
    try {
      final response = await _apiClient.refreshToken(request.refreshToken);
      return RefreshTokenResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<AuthResponse> googleLogin(String idToken) async {
    try {
      final response = await _apiClient.googleLogin(idToken);
      return AuthResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<AuthResponse> appleLogin(String identityToken, {String? authorizationCode}) async {
    try {
      final response = await _apiClient.appleLogin(identityToken, authorizationCode: authorizationCode);
      return AuthResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> completeProfile(String name, String phone) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.completeProfileEndpoint,
        data: {
          'name': name,
          'phone': phone,
        },
      );
      // Backend might return the user in a 'data' object or directly
      final userData = response.data['data'] ?? response.data;
      return UserModel.fromJson(userData);
    } catch (e) {
      rethrow;
    }
  }
}
