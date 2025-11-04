import 'package:get/get.dart';
import 'package:petapp/core/middleware/auth_middleware.dart';
import 'package:petapp/features/authentication/screens/onboarding/simple_network_splash.dart';
import 'package:petapp/features/auth/presentation/screens/login/login.dart';
import 'package:petapp/features/auth/presentation/screens/onboarding/onboarding.dart';
import 'package:petapp/features/auth/presentation/screens/password_config/createnewpass.dart';
import 'package:petapp/features/auth/presentation/screens/password_config/forgot_password.dart';
import 'package:petapp/features/auth/presentation/screens/password_config/enter_verification_code.dart';
import 'package:petapp/features/auth/presentation/screens/signup/signup.dart';
import 'package:petapp/features/auth/presentation/screens/signup/verifyemail.dart';
import 'package:petapp/features/location/screens/choose_location.dart';
import 'package:petapp/features/location/screens/set_location.dart';
import 'package:petapp/features/home/screens/home_screen.dart';
import 'package:petapp/features/vets/screens/vet_detail_screen.dart';
import 'package:petapp/features/appointments/presentation/screens/appointments_screen.dart';
import 'package:petapp/features/profile/screens/profile_screen.dart';
import 'package:petapp/features/profile/screens/account_details_screen.dart';
import 'package:petapp/features/pet/screens/pet_3d_viewer/pet_3d_viewer_screen.dart';
import 'package:petapp/features/pet/screens/pet_3d_viewer/pet_3d_model_selector.dart';
import 'package:petapp/features/vets/screens/vet_booking_screen.dart';
import 'package:petapp/features/vets/screens/vet_explorer_screen.dart';
// Add these imports for the pet-related screens
import 'package:petapp/features/pet/screens/my_pets.dart';
import 'package:petapp/features/pet/screens/add_pet.dart';
import 'package:petapp/features/pet/screens/update_pet.dart';
import 'package:petapp/features/pet/screens/pet_profile.dart';
// Add import for settings screen
import 'package:petapp/features/home/screens/settings_screen.dart';
import 'package:petapp/features/profile/screens/points_history_screen.dart';
import 'package:petapp/features/profile/screens/vouchers_screen.dart';
import 'package:petapp/features/profile/screens/favorites_screen.dart';
// Vaccination imports
import 'package:petapp/features/vaccination/presentation/screens/select_pet_for_vaccination_screen.dart';

class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String networkSplash = '/network-splash';
  static const String signUp = '/signup';
  static const String login = '/login';
  static const String verifyEmail = '/verify-email';
  static const String forgotPassword = '/forgot-password';
  static const String enterVerificationCode = '/enter-verification-code';
  static const String createNewPassword = '/create-new-password';
  static const String chooseLocation = '/choose-location';
  static const String setLocation = '/set-location';
  static const String home = '/home';
  static const String vetDetail = '/vet-detail';
  static const String serviceSelection = '/service-selection';
  static const String checkout = '/checkout';
  static const String appointments = '/appointments';
  static const String profile = '/profile';
  static const String pet3DViewer = '/pet-3d-viewer-screen';
  static const String pet3DModelSelector = '/pet-3d-model-selector';
  static const String vetBooking = '/vet-booking';
  static const String vetExplorer = '/vet-explorer';
  // Add these route constants here instead of inside the getPages list
  static const String myPets = '/my-pets';
  static const String addPet = '/add-pet';
  static const String updatePet = '/update-pet';
  static const String petProfile = '/pet-profile';
  static const String accountDetails = '/account-details';
  // Add settings route constant here
  static const String settings = '/settings';
  static const String vouchers = '/vouchers';
  static const String pointsHistory = '/points-history';
  static const String redeem = '/redeem';
  static const String favorites = '/favorites';
  // Vaccination routes
  static const String selectPetForVaccination = '/select-pet-vaccination';
  static const String petVaccinationRecord = '/pet-vaccination-record';

  static List<GetPage> get getPages => [
        GetPage(name: networkSplash, page: () => const NetworkSplashScreen()),
        GetPage(name: onboarding, page: () => const OnboardingScreen()),
        GetPage(name: signUp, page: () => const SignUpScreen()),
        GetPage(name: login, page: () => const LoginScreen()),
        GetPage(
            name: verifyEmail, page: () => const VerifyEmailScreen(email: '')),
        GetPage(name: forgotPassword, page: () => const ForgotPasswordScreen()),
        GetPage(
            name: enterVerificationCode,
            page: () => const EnterVerificationCodeScreen()),
        GetPage(
            name: createNewPassword,
            page: () => const CreateNewPasswordScreen()),
        GetPage(name: chooseLocation, page: () => const ChooseLocationScreen()),
        GetPage(name: setLocation, page: () => const SetLocationScreen()),
        GetPage(name: home, page: () => const HomeScreen()),
        GetPage(
            name: vetDetail, page: () => VetDetailScreen(vet: Get.arguments)),
        // GetPage(name: checkout, page: () => const CheckoutScreen()),
        GetPage(name: appointments, page: () => const AppointmentsScreen()),
        GetPage(name: profile, page: () => const ProfileScreen()),
        GetPage(
          name: pet3DViewer,
          page: () {
            final args = Get.arguments as Map<String, dynamic>;
            return Pet3DViewerScreen(
              petType: args['petType'],
              petName: args['petName'],
              modelPath: args['modelPath'],
            );
          },
        ),
        GetPage(
          name: pet3DModelSelector,
          page: () => const Pet3DModelSelector(),
        ),
        // Protected routes with middleware
        GetPage(
          name: vetBooking,
          page: () => const VetBookingScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(name: vetExplorer, page: () => const VetExplorerScreen()),
        // Protected pet routes
        GetPage(
          name: myPets,
          page: () => const MyPetsScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: addPet,
          page: () => const AddPetScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: updatePet,
          page: () => UpdatePetScreen(
            pet: Get.arguments,
          ),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: petProfile,
          page: () => PetProfileScreen(
            pet: Get.arguments,
          ),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(name: settings, page: () => const SettingsScreen()),
        GetPage(
          name: vouchers,
          page: () => const VouchersScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: pointsHistory,
          page: () => const PointsHistoryScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: accountDetails,
          page: () => const AccountDetailsScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 250),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: favorites,
          page: () => const FavoritesScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 250),
        ),
        // Vaccination routes
        GetPage(
          name: selectPetForVaccination,
          page: () => const SelectPetForVaccinationScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 250),
          middlewares: [AuthMiddleware()],
        ),
      ];
}
