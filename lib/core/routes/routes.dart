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
import 'package:petapp/features/home/screens/home_screen.dart';
import 'package:petapp/features/home/screens/clinic_detail_screen.dart';
import 'package:petapp/features/home/screens/service_selection_screen.dart';

class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String signUp = '/signup';
  static const String login = '/login';
  static const String verifyEmail = '/verify-email';
  static const String forgotPassword = '/forgot-password';
  static const String enterVerificationCode = '/enter-verification-code';
  static const String createNewPassword = '/create-new-password';
  static const String chooseLocation = '/choose-location';
  static const String setLocation = '/set-location';
  static const String home = '/home';
  static const String clinicDetail = '/clinic-detail';
  static const String serviceSelection = '/service-selection';
  static const String checkout = '/checkout';

  static List<GetPage> getPages = [
    GetPage(name: onboarding, page: () => const OnboardingScreen()),
    GetPage(name: signUp, page: () => const SignUpScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: verifyEmail, page: () => const VerifyEmailScreen(email: '')),
    GetPage(name: forgotPassword, page: () => const ForgotPasswordScreen()),
    GetPage(name: enterVerificationCode, page: () => const EnterVerificationCodeScreen()),
    GetPage(name: createNewPassword, page: () => const CreateNewPasswordScreen()),
    GetPage(name: chooseLocation, page: () => const ChooseLocationScreen()),
    GetPage(name: setLocation, page: () => const SetLocationScreen()),
    GetPage(name: home, page: () => const HomeScreen()),
    GetPage(
      name: clinicDetail, 
      page: () => ClinicDetailScreen(clinic: Get.arguments),
    ),
    GetPage(
      name: serviceSelection, 
      page: () => ServiceSelectionScreen(arguments: Get.arguments),
    ),
  ];
}