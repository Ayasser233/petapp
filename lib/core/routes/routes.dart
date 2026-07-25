import 'package:get/get.dart';
import 'package:petapp/core/middleware/auth_middleware.dart';
import 'package:petapp/features/authentication/screens/onboarding/simple_network_splash.dart';
import 'package:petapp/features/auth/presentation/screens/login/login.dart';
import 'package:petapp/features/auth/presentation/screens/onboarding/onboarding.dart';
import 'package:petapp/features/auth/presentation/screens/password_config/createnewpass.dart';
import 'package:petapp/features/auth/presentation/screens/password_config/forgot_password.dart';
import 'package:petapp/features/auth/presentation/screens/password_config/enter_verification_code.dart';
import 'package:petapp/features/auth/presentation/screens/password_config/change_password.dart';
import 'package:petapp/features/auth/presentation/screens/signup/signup.dart';
import 'package:petapp/features/auth/presentation/screens/signup/verifyemail.dart';
import 'package:petapp/features/auth/presentation/screens/complete_profile/complete_profile_screen.dart';
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
import 'package:petapp/features/pet/models/pet_model.dart';
// Add import for settings screen
import 'package:petapp/features/home/screens/settings_screen.dart';
import 'package:petapp/features/profile/screens/points_history_screen.dart';
import 'package:petapp/features/profile/screens/vouchers_screen.dart';
import 'package:petapp/features/profile/screens/favorites_screen.dart';
// Vaccination imports
import 'package:petapp/features/vaccination/presentation/screens/select_pet_for_vaccination_screen.dart';
// Notifications import
import 'package:petapp/features/notifications/screens/notifications_screen.dart';
// Privacy Policy import
import 'package:petapp/features/settings/screens/privacy_policy_screen.dart';
// Store imports
import 'package:petapp/features/store/screens/store_screen.dart';
import 'package:petapp/features/store/screens/cart_screen.dart';
import 'package:petapp/features/store/screens/delivery_screen.dart';
import 'package:petapp/features/store/screens/checkout_screen.dart';
import 'package:petapp/features/store/screens/product_detail_screen.dart';
import 'package:petapp/features/store/screens/schedule_order_screen.dart';
import 'package:petapp/features/store/screens/add_address_screen.dart';
import 'package:petapp/features/store/screens/order_confirmation_screen.dart';
import 'package:petapp/features/store/screens/orders_screen.dart';
import 'package:petapp/features/store/screens/order_detail_screen.dart';
import 'package:petapp/features/store/screens/order_tracking_screen.dart';
import 'package:petapp/features/store/screens/payment_proof_screen.dart';
import 'package:petapp/features/store/screens/review_form_screen.dart';
import 'package:petapp/features/store/screens/my_addresses_screen.dart';
import 'package:petapp/features/store/controllers/address_controller.dart';
import 'package:petapp/features/store/controllers/cart_controller.dart';
import 'package:petapp/features/store/controllers/store_controller.dart';
import 'package:petapp/features/store/controllers/checkout_controller.dart';
import 'package:petapp/features/store/controllers/order_controller.dart';
import 'package:petapp/features/store/controllers/review_controller.dart';
class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String networkSplash = '/network-splash';
  static const String signUp = '/signup';
  static const String login = '/login';
  static const String verifyEmail = '/verify-email';
  static const String completeProfile = '/complete-profile';
  static const String forgotPassword = '/forgot-password';
  static const String enterVerificationCode = '/enter-verification-code';
  static const String createNewPassword = '/create-new-password';
  static const String changePassword = '/change-password';
  static const String chooseLocation = '/choose-location';
  static const String setLocation = '/set-location';
  static const String home = '/home';
  static const String vetDetail = '/vet-detail';
  static const String serviceSelection = '/service-selection';
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
  // Notifications route
  static const String notifications = '/notifications';
  // Privacy Policy route
  static const String privacyPolicy = '/privacy-policy';
  // Store routes
  static const String store = '/store';
  static const String cart = '/cart';
  static const String delivery = '/delivery';
  static const String checkout = '/checkout';
  static const String productDetail = '/product-detail';
  static const String scheduleOrder = '/schedule-order';
  static const String addAddress = '/add-address';
  static const String orderConfirmation = '/order-confirmation';
  static const String orders = '/orders';
  static const String orderDetail = '/order-detail';
  static const String orderTracking = '/order-tracking';
  static const String paymentProof = '/payment-proof';
  static const String reviewForm = '/review-form';
  static const String myAddresses = '/my-addresses';

  static List<GetPage> get getPages => [
        GetPage(name: networkSplash, page: () => const NetworkSplashScreen()),
        GetPage(name: onboarding, page: () => const OnboardingScreen()),
        GetPage(name: signUp, page: () => const SignUpScreen()),
        GetPage(name: login, page: () => const LoginScreen()),
        GetPage(
            name: verifyEmail, page: () => const VerifyEmailScreen(email: '')),
        GetPage(name: completeProfile, page: () => const CompleteProfileScreen()),
        GetPage(name: forgotPassword, page: () => const ForgotPasswordScreen()),
        GetPage(
            name: enterVerificationCode,
            page: () => const EnterVerificationCodeScreen()),
        GetPage(
            name: createNewPassword,
            page: () => const CreateNewPasswordScreen()),
        GetPage(name: changePassword, page: () => const ChangePasswordScreen()),
        GetPage(name: chooseLocation, page: () => const ChooseLocationScreen()),
        GetPage(name: setLocation, page: () => const SetLocationScreen()),
        GetPage(name: home, page: () => const HomeScreen()),
        GetPage(
            name: vetDetail, page: () => VetDetailScreen(vet: Get.arguments as Map<String, dynamic>)),
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
            pet: Get.arguments as PetModel,
          ),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: petProfile,
          page: () => PetProfileScreen(
            pet: Get.arguments as PetModel,
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
        // Notifications route
        GetPage(
          name: notifications,
          page: () => const NotificationsScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 250),
        ),
        // Privacy Policy route
        GetPage(
          name: privacyPolicy,
          page: () => const PrivacyPolicyScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 250),
        ),
        // Store routes
        GetPage(
          name: store,
          page: () => const StoreScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 250),
          binding: BindingsBuilder(() {
            Get.lazyPut<StoreController>(() => StoreController(), fenix: true);
            Get.lazyPut<CartController>(() => CartController(), fenix: true);
            Get.lazyPut<CheckoutController>(() => CheckoutController(), fenix: true);
          }),
        ),
        GetPage(
          name: cart,
          page: () => const CartScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 250),
          binding: BindingsBuilder(() {
            Get.lazyPut<CartController>(() => CartController(), fenix: true);
          }),
        ),
        GetPage(
          name: delivery,
          page: () => const DeliveryScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 250),
          binding: BindingsBuilder(() {
            Get.lazyPut<CheckoutController>(() => CheckoutController(), fenix: true);
            Get.lazyPut<AddressController>(() => AddressController(), fenix: true);
          }),
        ),
        GetPage(
          name: scheduleOrder,
          page: () => const ScheduleOrderScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 250),
          binding: BindingsBuilder(() {
            Get.lazyPut<CheckoutController>(() => CheckoutController(), fenix: true);
          }),
        ),
        GetPage(
          name: addAddress,
          page: () => const AddAddressScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 250),
          binding: BindingsBuilder(() {
            Get.lazyPut<AddressController>(() => AddressController(), fenix: true);
            Get.lazyPut<CheckoutController>(() => CheckoutController(), fenix: true);
          }),
        ),
        GetPage(
          name: checkout,
          page: () => const CheckoutScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 250),
          binding: BindingsBuilder(() {
            Get.lazyPut<CartController>(() => CartController(), fenix: true);
            Get.lazyPut<CheckoutController>(() => CheckoutController(), fenix: true);
          }),
        ),
        GetPage(
          name: productDetail,
          page: () => const ProductDetailScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 250),
          binding: BindingsBuilder(() {
            Get.lazyPut<CartController>(() => CartController(), fenix: true);
            Get.lazyPut<ReviewController>(() => ReviewController(), fenix: true);
          }),
        ),
        GetPage(
          name: orderConfirmation,
          page: () => const OrderConfirmationScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 250),
        ),
        GetPage(
          name: orders,
          page: () => const OrdersScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 250),
          binding: BindingsBuilder(() {
            Get.lazyPut<OrderController>(() => OrderController(), fenix: true);
          }),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: orderDetail,
          page: () => const OrderDetailScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 250),
          binding: BindingsBuilder(() {
            Get.lazyPut<OrderController>(() => OrderController(), fenix: true);
          }),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: orderTracking,
          page: () => const OrderTrackingScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 250),
          binding: BindingsBuilder(() {
            Get.lazyPut<OrderController>(() => OrderController(), fenix: true);
          }),
        ),
        GetPage(
          name: paymentProof,
          page: () => const PaymentProofScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 250),
          binding: BindingsBuilder(() {
            Get.lazyPut<OrderController>(() => OrderController(), fenix: true);
          }),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: reviewForm,
          page: () => const ReviewFormScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 250),
          binding: BindingsBuilder(() {
            Get.lazyPut<ReviewController>(() => ReviewController(), fenix: true);
          }),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: myAddresses,
          page: () => const MyAddressesScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 250),
          binding: BindingsBuilder(() {
            Get.lazyPut<AddressController>(() => AddressController(), fenix: true);
          }),
          middlewares: [AuthMiddleware()],
        ),
      ];
}
