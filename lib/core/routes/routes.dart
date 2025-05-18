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
import 'package:petapp/features/clinic/screens/clinic_detail_screen.dart';
import 'package:petapp/features/home/screens/activity_screen.dart';
import 'package:petapp/features/home/screens/profile_screen.dart';
import 'package:petapp/features/pet/screens/3d_pet.dart';
import 'package:petapp/features/clinic/screens/hospital_booking_screen.dart';
import 'package:petapp/features/clinic/screens/clinic_explorer_screen.dart';
// Add these imports for the pet-related screens
import 'package:petapp/features/pet/screens/my_pets.dart';
import 'package:petapp/features/pet/screens/add_pet.dart';
import 'package:petapp/features/pet/screens/pet_profile.dart';
// Add import for settings screen
import 'package:petapp/features/home/screens/settings_screen.dart';


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
  static const String activity = '/activity';
  static const String profile = '/profile';
  static const String pet3d = '/pet-3d-representation';
  static const String hospitalBooking = '/hospital-booking';  
  static const String clinicExplorer = '/clinic-explorer';
  // Add these route constants here instead of inside the getPages list
  static const String myPets = '/my-pets';
  static const String addPet = '/add-pet';
  static const String petProfile = '/pet-profile';
  // Add settings route constant here
  static const String settings = '/settings';

  static List<GetPage> get getPages => [
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
        GetPage(name: clinicDetail, page: () => ClinicDetailScreen(clinic: Get.arguments)),
        // GetPage(name: checkout, page: () => const CheckoutScreen()),
        GetPage(name: activity, page: () => const ActivityScreen()),
        GetPage(name: profile, page: () => const ProfileScreen()),
        GetPage(name: pet3d, page: () => const Pet3DRepresentationScreen()),
        GetPage(name: hospitalBooking, page: () => const HospitalBookingScreen()),
        GetPage(name: clinicExplorer, page: () => const ClinicExplorerScreen()),
        // Add these GetPage entries properly to the list
        GetPage(
          name: myPets,
          page: () => const MyPetsScreen(),
        ),
        GetPage(
          name: addPet,
          page: () => const AddPetScreen(),
        ),
        GetPage(
          name: petProfile,
          page: () => PetProfileScreen(
            pet: Get.arguments,
          ),
        ),
        // Add settings page to the list
        GetPage(name: settings, page: () => const SettingsScreen()),
      ];
}