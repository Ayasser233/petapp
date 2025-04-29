import 'package:get/get.dart';
import 'package:petapp/features/auth/screens/login/login.dart';
import 'package:petapp/features/auth/screens/onboarding/onboarding.dart';
import 'package:petapp/features/auth/screens/password_config/createnewpass.dart';
import 'package:petapp/features/auth/screens/password_config/forgot_password.dart';
import 'package:petapp/features/auth/screens/password_config/enter_verification_code.dart';
import 'package:petapp/features/auth/screens/signup/signup.dart';
import 'package:petapp/features/auth/screens/signup/verifyemail.dart';
import 'package:petapp/features/location/screens/choose_location.dart';
import 'package:petapp/features/location/screens/set_location.dart';

class AppRoutes {
  static const String signUp = '/signup';
  static const String login = '/login'; // Assuming you have a login screen
  static const String verifyEmail = '/verify-email';
  static const String forgotPassword = '/forgot-password';
  static const String enterVerificationCode = '/enter-verification-code';
  static const String createNewPassword = '/create-new-password';
  static const String chooseLocation = '/choose-location';
  static const String setLocation = '/set-location';
  static const String onboarding = '/onboarding'; // Assuming you have an onboarding screen

  static List<GetPage> getPages = [
    GetPage(
      name: login,
      page: () => const LoginScreen(), // Replace with your actual login screen
    ),
    GetPage(
      name: signUp,
      page: () => const SignUpScreen(),
    ),
    GetPage(
      name: verifyEmail,
      page: () => const VerifyEmailScreen(email: ''),
    ),
    GetPage(
      name: forgotPassword,
      page: () => const ForgotPasswordScreen(),
    ),
    GetPage(
      name: enterVerificationCode,
      page: () => const EnterVerificationCodeScreen(),
    ),
    GetPage(
      name: createNewPassword,
      page: () => const CreateNewPasswordScreen(),
    ),
    GetPage(
      name: chooseLocation,
      page: () => const ChooseLocationScreen(),
    ),
    GetPage(
      name: setLocation,
      page: () => const SetLocationScreen(),
    ),
    GetPage(
      name: onboarding,
      page: () => const OnboardingScreen(),
    ),
  ];
}