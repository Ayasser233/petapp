import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  // Helper method to keep the code in the widgets concise
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  // Static member to have a simple access to the delegate from the MaterialApp
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // List of supported locales
  static const List<Locale> supportedLocales = [
    Locale('en', ''),
    Locale('ar', ''),
  ];

  // Retrieve localized strings
  String get appTitle =>
      _localizedValues[locale.languageCode]?['appTitle'] ?? 'Aleefy';
  String get home => _localizedValues[locale.languageCode]?['home'] ?? 'Home';
  String get myActivity =>
      _localizedValues[locale.languageCode]?['myActivity'] ?? 'My Activity';
  String get profile =>
      _localizedValues[locale.languageCode]?['profile'] ?? 'Profile';
  String get settings =>
      _localizedValues[locale.languageCode]?['settings'] ?? 'Settings';
  String get appearance =>
      _localizedValues[locale.languageCode]?['appearance'] ?? 'Appearance';
  String get language =>
      _localizedValues[locale.languageCode]?['language'] ?? 'Language';
  String get notifications =>
      _localizedValues[locale.languageCode]?['notifications'] ??
      'Notifications';
  String get privacySecurity =>
      _localizedValues[locale.languageCode]?['privacySecurity'] ??
      'Privacy & Security';
  String get about =>
      _localizedValues[locale.languageCode]?['about'] ?? 'About';
  String get lightMode =>
      _localizedValues[locale.languageCode]?['lightMode'] ?? 'Light Mode';
  String get darkMode =>
      _localizedValues[locale.languageCode]?['darkMode'] ?? 'Dark Mode';
  String get systemDefault =>
      _localizedValues[locale.languageCode]?['systemDefault'] ??
      'System Default';
  String get useLightTheme =>
      _localizedValues[locale.languageCode]?['useLightTheme'] ??
      'Use light theme';
  String get useDarkTheme =>
      _localizedValues[locale.languageCode]?['useDarkTheme'] ??
      'Use dark theme';
  String get useSystemTheme =>
      _localizedValues[locale.languageCode]?['useSystemTheme'] ??
      'Follow system theme';
  String get english =>
      _localizedValues[locale.languageCode]?['english'] ?? 'English';
  String get arabic =>
      _localizedValues[locale.languageCode]?['arabic'] ?? 'العربية';
  String get useEnglish =>
      _localizedValues[locale.languageCode]?['useEnglish'] ??
      'Use English language';
  String get useArabic =>
      _localizedValues[locale.languageCode]?['useArabic'] ??
      'استخدم اللغة العربية';
  String get pushNotifications =>
      _localizedValues[locale.languageCode]?['pushNotifications'] ??
      'Push Notifications';
  String get emailNotifications =>
      _localizedValues[locale.languageCode]?['emailNotifications'] ??
      'Email Notifications';
  String get sound =>
      _localizedValues[locale.languageCode]?['sound'] ?? 'Sound';
  String get privacyPolicy =>
      _localizedValues[locale.languageCode]?['privacyPolicy'] ??
      'Privacy Policy';
  String get termsOfService =>
      _localizedValues[locale.languageCode]?['termsOfService'] ??
      'Terms of Service';
  String get deleteAccount =>
      _localizedValues[locale.languageCode]?['deleteAccount'] ??
      'Delete Account';
  String get appVersion =>
      _localizedValues[locale.languageCode]?['appVersion'] ?? 'App Version';
  String get contactSupport =>
      _localizedValues[locale.languageCode]?['contactSupport'] ??
      'Contact Support';
  String get rateApp =>
      _localizedValues[locale.languageCode]?['rateApp'] ?? 'Rate the App';
  String get myProfile =>
      _localizedValues[locale.languageCode]?['myProfile'] ?? 'My Profile';
  String get myPets =>
      _localizedValues[locale.languageCode]?['myPets'] ?? 'My Pets';
  String get appointments =>
      _localizedValues[locale.languageCode]?['appointments'] ?? 'Appointments';
  String get favorites =>
      _localizedValues[locale.languageCode]?['favorites'] ?? 'Favorites';
  String get support =>
      _localizedValues[locale.languageCode]?['support'] ?? 'Support';
  String get logout =>
      _localizedValues[locale.languageCode]?['logout'] ?? 'Logout';
  String get confirmLogout =>
      _localizedValues[locale.languageCode]?['confirmLogout'] ??
      'Are you sure you want to logout?';
  String get yes => _localizedValues[locale.languageCode]?['yes'] ?? 'Yes';
  String get no => _localizedValues[locale.languageCode]?['no'] ?? 'No';
  String get cancel =>
      _localizedValues[locale.languageCode]?['cancel'] ?? 'Cancel';
  String get confirm =>
      _localizedValues[locale.languageCode]?['confirm'] ?? 'Confirm';
  String get confirmDeleteAccount =>
      _localizedValues[locale.languageCode]?['confirmDeleteAccount'] ??
      'Are you sure you want to delete your account? This action cannot be undone.';

  // Add more strings as needed

  // Add new getters for home screen
  String get vetVisit =>
      _localizedValues[locale.languageCode]?['vetVisit'] ?? 'vet Visit';
  String get animalView3D =>
      _localizedValues[locale.languageCode]?['animalView3D'] ??
      'Symptom Checker';
  String get virtualVet =>
      _localizedValues[locale.languageCode]?['virtualVet'] ?? 'Virtual Vet';
  String get searchPlaceholder =>
      _localizedValues[locale.languageCode]?['searchPlaceholder'] ??
      'Search Vets, services...';
  String get redeemAndSave =>
      _localizedValues[locale.languageCode]?['redeemAndSave'] ??
      'Redeem & Save';
  String get viewHistory =>
      _localizedValues[locale.languageCode]?['viewHistory'] ?? 'View History';
  String get pointsAvailable =>
      _localizedValues[locale.languageCode]?['pointsAvailable'] ??
      'Points Available';
  String get redeemNow =>
      _localizedValues[locale.languageCode]?['redeemNow'] ?? 'Redeem Now';
  String get vouchers =>
      _localizedValues[locale.languageCode]?['vouchers'] ?? 'Vouchers';
  String get nearYou =>
      _localizedValues[locale.languageCode]?['nearYou'] ?? 'Near You';
  String get seeAll =>
      _localizedValues[locale.languageCode]?['seeAll'] ?? 'See All';

  // Add new getters for profile screen
  String get myAccount =>
      _localizedValues[locale.languageCode]?['myAccount'] ?? 'My Account';
  String get followUs =>
      _localizedValues[locale.languageCode]?['followUs'] ?? 'Follow Us';
  String get welcome =>
      _localizedValues[locale.languageCode]?['welcome'] ?? 'Welcome';
  String get signIn =>
      _localizedValues[locale.languageCode]?['signIn'] ?? 'Sign In';
  String get signUp =>
      _localizedValues[locale.languageCode]?['signUp'] ?? 'Sign Up';
  String get receivePushNotifications =>
      _localizedValues[locale.languageCode]?['receivePushNotifications'] ??
      'Receive Push Notifications';
  String get receiveEmailUpdates =>
      _localizedValues[locale.languageCode]?['receiveEmailUpdates'] ??
      'Receive Email Updates';
  String get playSoundForNotifications =>
      _localizedValues[locale.languageCode]?['playSoundForNotifications'] ??
      'Play Sound for Notifications';
  String get readOurPrivacyPolicy =>
      _localizedValues[locale.languageCode]?['readOurPrivacyPolicy'] ??
      'Read Our Privacy Policy';
  String get readOurTermsOfService =>
      _localizedValues[locale.languageCode]?['readOurTermsOfService'] ??
      'Read Our Terms of Service';
  String get deleteYourAccountPermanently =>
      _localizedValues[locale.languageCode]?['deleteYourAccountPermanently'] ??
      'Delete Your Account Permanently';
  String get deleteAccountRecoveryNote =>
      _localizedValues[locale.languageCode]?['deleteAccountRecoveryNote'] ??
      'This action can be reversed within 30 days by contacting support.';
  String get deletingAccount =>
      _localizedValues[locale.languageCode]?['deletingAccount'] ??
      'Deleting your account...';
  String get accountDeletedSuccessfully =>
      _localizedValues[locale.languageCode]?['accountDeletedSuccessfully'] ??
      'Your account has been deleted successfully';
  String get failedToDeleteAccount =>
      _localizedValues[locale.languageCode]?['failedToDeleteAccount'] ??
      'Failed to delete account. Please try again.';

  // New translations for Vouchers Screen
  String get myVouchers =>
      _localizedValues[locale.languageCode]?['myVouchers'] ?? 'My Vouchers';
  String get available =>
      _localizedValues[locale.languageCode]?['available'] ?? 'Available';
  String get used => _localizedValues[locale.languageCode]?['used'] ?? 'Used';
  String get expired =>
      _localizedValues[locale.languageCode]?['expired'] ?? 'Expired';
  String get gotAVoucher =>
      _localizedValues[locale.languageCode]?['gotAVoucher'] ?? 'Got a voucher?';
  String get addVoucher =>
      _localizedValues[locale.languageCode]?['addVoucher'] ?? 'Add Voucher';
  String get enterVoucherCode =>
      _localizedValues[locale.languageCode]?['enterVoucherCode'] ??
      'Enter voucher code';
  String get enterYourVoucherCode =>
      _localizedValues[locale.languageCode]?['enterYourVoucherCode'] ??
      'Enter your voucher code';
  String get pleaseEnterVoucherCode =>
      _localizedValues[locale.languageCode]?['pleaseEnterVoucherCode'] ??
      'Please enter a voucher code';
  String get validatingVoucherCode =>
      _localizedValues[locale.languageCode]?['validatingVoucherCode'] ??
      'Validating voucher code: {code}';
  String get voucherAddedSuccessfully =>
      _localizedValues[locale.languageCode]?['voucherAddedSuccessfully'] ??
      'Voucher "{code}" added successfully!';
  String get invalidVoucherCode =>
      _localizedValues[locale.languageCode]?['invalidVoucherCode'] ??
      'Invalid voucher code: "{code}"';
  String get voucherHelpText =>
      _localizedValues[locale.languageCode]?['voucherHelpText'] ??
      'Enter the voucher code you received from Aleefy or our partners';
  String get errorOpeningAccountDetails =>
      _localizedValues[locale.languageCode]?['errorOpeningAccountDetails'] ??
      'Error opening account details';
  String get aleefyPoints =>
      _localizedValues[locale.languageCode]?['aleefyPoints'] ?? 'Aleefy Points';
  String get retry =>
      _localizedValues[locale.languageCode]?['retry'] ?? 'Retry';
  String get view => _localizedValues[locale.languageCode]?['view'] ?? 'View';
  String get pointsHistory =>
      _localizedValues[locale.languageCode]?['pointsHistory'] ??
      'Points History';

  // New translations for Favorites Screen
  String get noFavoritesYet =>
      _localizedValues[locale.languageCode]?['noFavoritesYet'] ??
      'No favorites yet';
  String get noFavoritesMessage =>
      _localizedValues[locale.languageCode]?['noFavoritesMessage'] ??
      'When you find Vets you love, save them here for quick access.';
  String get openNow =>
      _localizedValues[locale.languageCode]?['openNow'] ?? 'Open Now';
  String get closed =>
      _localizedValues[locale.languageCode]?['closed'] ?? 'Closed';
  String get removedFromFavorites =>
      _localizedValues[locale.languageCode]?['removedFromFavorites'] ??
      'removed from favorites';
  String get bookAppointment =>
      _localizedValues[locale.languageCode]?['bookAppointment'] ??
      'Book Appointment';
  String get exploreMoreVets =>
      _localizedValues[locale.languageCode]?['exploreMoreVets'] ??
      'Explore More Vets';
  String get booked =>
      _localizedValues[locale.languageCode]?['booked'] ?? 'Booked';
  String get noSlotsAvailable =>
      _localizedValues[locale.languageCode]?['noSlotsAvailable'] ??
      'No slots available';

  // Onboarding screen getters
  String get skip =>
      _localizedValues[locale.languageCode]?['skip'] ?? 'Skip';
  String get skipLogin =>
      _localizedValues[locale.languageCode]?['skipLogin'] ?? 'Skip Login';
  String get skipSignup =>
      _localizedValues[locale.languageCode]?['skipSignup'] ?? 'Skip Signup';
  String get welcomeToAleefy =>
      _localizedValues[locale.languageCode]?['welcomeToAleefy'] ??
      'Welcome to Aleefy';
  String get onboardingSubtitle1 =>
      _localizedValues[locale.languageCode]?['onboardingSubtitle1'] ??
      'The simplest way to care for your pet, every day.';
  String get checkAndBookInSeconds =>
      _localizedValues[locale.languageCode]?['checkAndBookInSeconds'] ??
      'Check & Book in Seconds';
  String get onboardingSubtitle2 =>
      _localizedValues[locale.languageCode]?['onboardingSubtitle2'] ??
      'Review common symptoms, find nearby clinics, and reserve a spot instantly — no waiting rooms, no hassle.';
  String get exclusiveBenefits =>
      _localizedValues[locale.languageCode]?['exclusiveBenefits'] ??
      'Exclusive Benefits for Your Pet';
  String get onboardingSubtitle3 =>
      _localizedValues[locale.languageCode]?['onboardingSubtitle3'] ??
      'Unlock free checkups, grooming offers, and special clinic discounts — only on Aleefy.';

  // Auth screen getters
  String get welcomeBack =>
      _localizedValues[locale.languageCode]?['welcomeBack'] ?? 'Welcome Back';
  String get loginToAccount =>
      _localizedValues[locale.languageCode]?['loginToAccount'] ??
      'Login to your account';
  String get rememberMe =>
      _localizedValues[locale.languageCode]?['rememberMe'] ?? 'Remember me';
  String get forgotPassword =>
      _localizedValues[locale.languageCode]?['forgotPassword'] ??
      'Forgot Password?';
  String get orContinueWith =>
      _localizedValues[locale.languageCode]?['orContinueWith'] ??
      'Or continue with';
  String get password =>
      _localizedValues[locale.languageCode]?['password'] ?? 'Password';
  String get signInWithGoogle =>
      _localizedValues[locale.languageCode]?['signInWithGoogle'] ??
      'Sign in with Google';
  String get signInWithApple =>
      _localizedValues[locale.languageCode]?['signInWithApple'] ??
      'Sign in with Apple';
  String get signUpWithGoogle =>
      _localizedValues[locale.languageCode]?['signUpWithGoogle'] ??
      'Sign up with Google';
  String get signUpWithApple =>
      _localizedValues[locale.languageCode]?['signUpWithApple'] ??
      'Sign up with Apple';
  String get dontHaveAccount =>
      _localizedValues[locale.languageCode]?['dontHaveAccount'] ??
      'Don\'t have an account?';
  String get wrongCredentials =>
      _localizedValues[locale.languageCode]?['wrongCredentials'] ??
      'Wrong email or password';
  String get emailNotVerified =>
      _localizedValues[locale.languageCode]?['emailNotVerified'] ??
      'Email Not Verified';
  String get pleaseVerifyYourEmail =>
      _localizedValues[locale.languageCode]?['pleaseVerifyYourEmail'] ??
      'Please verify your email to continue';

  // Forgot Password screen getters
  String get resetYourPassword =>
      _localizedValues[locale.languageCode]?['resetYourPassword'] ??
      'Reset Your Password';
  String get enterRegisteredEmail =>
      _localizedValues[locale.languageCode]?['enterRegisteredEmail'] ??
      'Enter your registered email to receive a verification code';
  String get sendVerificationCode =>
      _localizedValues[locale.languageCode]?['sendVerificationCode'] ??
      'Send Verification Code';
  String get codeSent =>
      _localizedValues[locale.languageCode]?['codeSent'] ?? 'Code Sent';
  String verificationCodeSentTo(String email) =>
      _localizedValues[locale.languageCode]?['verificationCodeSentTo']
          ?.replaceAll('{email}', email) ??
      'Verification code has been sent to $email';
  String get failedToSendCode =>
      _localizedValues[locale.languageCode]?['failedToSendCode'] ??
      'Failed to send verification code';
  String get noAccountFoundWithEmail =>
      _localizedValues[locale.languageCode]?['noAccountFoundWithEmail'] ??
      'No account found with this email address. Please check your email or create a new account.';
  String get pleaseEnterEmail =>
      _localizedValues[locale.languageCode]?['pleaseEnterEmail'] ??
      'Please enter your email';
  String get pleaseEnterValidEmail =>
      _localizedValues[locale.languageCode]?['pleaseEnterValidEmail'] ??
      'Please enter a valid email';

  // Enter Verification Code screen getters
  String get enterVerificationCode =>
      _localizedValues[locale.languageCode]?['enterVerificationCode'] ??
      'Enter Verification Code';
  String verificationCodeSentToEmail(String email) =>
      _localizedValues[locale.languageCode]?['verificationCodeSentToEmail']
          ?.replaceAll('{email}', email) ??
      'We have sent a verification code to $email';
  String get pleaseEnterAll6Digits =>
      _localizedValues[locale.languageCode]?['pleaseEnterAll6Digits'] ??
      'Please enter all 6 digits of the code';
  String get verificationCodeExpired =>
      _localizedValues[locale.languageCode]?['verificationCodeExpired'] ??
      'Verification code has expired. Please request a new one.';
  String get invalidVerificationCode =>
      _localizedValues[locale.languageCode]?['invalidVerificationCode'] ??
      'Invalid verification code. Please try again.';
  String get errorVerifyingCode =>
      _localizedValues[locale.languageCode]?['errorVerifyingCode'] ??
      'Error verifying code';
  String get newCodeSent =>
      _localizedValues[locale.languageCode]?['newCodeSent'] ?? 'Code Sent';
  String newVerificationCodeSentTo(String email) =>
      _localizedValues[locale.languageCode]?['newVerificationCodeSentTo']
          ?.replaceAll('{email}', email) ??
      'A new verification code has been sent to $email';
  String get failedToResendCode =>
      _localizedValues[locale.languageCode]?['failedToResendCode'] ??
      'Failed to resend code. Please try again.';
  String get verifyCode =>
      _localizedValues[locale.languageCode]?['verifyCode'] ?? 'Verify Code';
  String get resendCode =>
      _localizedValues[locale.languageCode]?['resendCode'] ?? 'Resend Code';
  String get didntReceiveCode =>
      _localizedValues[locale.languageCode]?['didntReceiveCode'] ??
      'Didn\'t receive the code?';

  // Email Verification screen getters
  String get verifyYourEmail =>
      _localizedValues[locale.languageCode]?['verifyYourEmail'] ??
      'Verify Your Email';
  String enterThe6DigitCodeSentTo(String email) =>
      _localizedValues[locale.languageCode]?['enterThe6DigitCodeSentTo']
          ?.replaceAll('{email}', email) ??
      'Enter the 6-digit code sent to $email';
  String get emailVerifiedSuccessfully =>
      _localizedValues[locale.languageCode]?['emailVerifiedSuccessfully'] ??
      'Email Verified Successfully!';
  String get youCanNowContinueToTheApp =>
      _localizedValues[locale.languageCode]?['youCanNowContinueToTheApp'] ??
      'You can now continue to the app';
  String get continueText =>
      _localizedValues[locale.languageCode]?['continueText'] ?? 'Continue';
  String get verify =>
      _localizedValues[locale.languageCode]?['verify'] ?? 'Verify';
  String get verificationFailed =>
      _localizedValues[locale.languageCode]?['verificationFailed'] ??
      'Verification Failed';
  String get invalidOrExpiredCode =>
      _localizedValues[locale.languageCode]?['invalidOrExpiredCode'] ??
      'Invalid or expired code. Please try again.';
  String get seconds =>
      _localizedValues[locale.languageCode]?['seconds'] ?? 's';

  // Create New Password screen getters
  String get createNewPassword =>
      _localizedValues[locale.languageCode]?['createNewPassword'] ??
      'Create New Password';
  String get newPasswordMustBeDifferent =>
      _localizedValues[locale.languageCode]?['newPasswordMustBeDifferent'] ??
      'Your new password must be different from previously used passwords';
  String get atLeast6Characters =>
      _localizedValues[locale.languageCode]?['atLeast6Characters'] ??
      'At least 6 characters';
  String get containsANumber =>
      _localizedValues[locale.languageCode]?['containsANumber'] ??
      'Contains a number';
  String get containsAnUppercaseLetter =>
      _localizedValues[locale.languageCode]?['containsAnUppercaseLetter'] ??
      'Contains an uppercase letter';
  String get newPassword =>
      _localizedValues[locale.languageCode]?['newPassword'] ?? 'New Password';
  String get confirmPassword =>
      _localizedValues[locale.languageCode]?['confirmPassword'] ??
      'Confirm Password';
  String get pleaseEnterPassword =>
      _localizedValues[locale.languageCode]?['pleaseEnterPassword'] ??
      'Please enter a password';
  String get passwordMustBeAtLeast6Characters =>
      _localizedValues[locale.languageCode]
          ?['passwordMustBeAtLeast6Characters'] ??
      'Password must be at least 6 characters';
  String get passwordMustContainUppercase =>
      _localizedValues[locale.languageCode]?['passwordMustContainUppercase'] ??
      'Password must contain at least one uppercase letter';
  String get passwordMustContainNumber =>
      _localizedValues[locale.languageCode]?['passwordMustContainNumber'] ??
      'Password must contain at least one number';
  String get pleaseConfirmPassword =>
      _localizedValues[locale.languageCode]?['pleaseConfirmPassword'] ??
      'Please confirm your password';
  String get passwordsDoNotMatch =>
      _localizedValues[locale.languageCode]?['passwordsDoNotMatch'] ??
      'Passwords do not match';
  String get resetPassword =>
      _localizedValues[locale.languageCode]?['resetPassword'] ??
      'Reset Password';
  String get passwordResetSuccessfully =>
      _localizedValues[locale.languageCode]?['passwordResetSuccessfully'] ??
      'Password Reset Successfully!';
  String get passwordChangedMessage =>
      _localizedValues[locale.languageCode]?['passwordChangedMessage'] ??
      'Your password has been changed. Please use your new password to login.';
  String get loginNow =>
      _localizedValues[locale.languageCode]?['loginNow'] ?? 'Login Now';
  String get failedToResetPassword =>
      _localizedValues[locale.languageCode]?['failedToResetPassword'] ??
      'Failed to reset password. Please try again.';

  // Account Details screen getters
  String get personalInformation =>
      _localizedValues[locale.languageCode]?['personalInformation'] ??
      'Personal Information';
  String get security =>
      _localizedValues[locale.languageCode]?['security'] ?? 'Security';
  String get changePassword =>
      _localizedValues[locale.languageCode]?['changePassword'] ??
      'Change Password';
  String get currentPassword =>
      _localizedValues[locale.languageCode]?['currentPassword'] ??
      'Current Password';
  String get enterCurrentPasswordPrompt =>
      _localizedValues[locale.languageCode]?['enterCurrentPasswordPrompt'] ??
      'Enter your current password and choose a new password';

  // Signup screen getters
  String get createAccount =>
      _localizedValues[locale.languageCode]?['createAccount'] ??
      'Create Your Account';
  String get accountCreationSubtitle =>
      _localizedValues[locale.languageCode]?['accountCreationSubtitle'] ??
      'Fill in your details to create your account';
  String get fullName =>
      _localizedValues[locale.languageCode]?['fullName'] ?? 'Full Name';
  String get firstName =>
      _localizedValues[locale.languageCode]?['firstName'] ?? 'First Name';
  String get lastName =>
      _localizedValues[locale.languageCode]?['lastName'] ?? 'Last Name';
  String get phoneNumber =>
      _localizedValues[locale.languageCode]?['phoneNumber'] ?? 'Phone Number';
  String get alreadyHaveAccount =>
      _localizedValues[locale.languageCode]?['alreadyHaveAccount'] ??
      'Already have an account?';
  String get termsAndConditionsAgreement =>
      _localizedValues[locale.languageCode]?['termsAndConditionsAgreement'] ??
      'By registering you agree to';
  String get termsAndConditions =>
      _localizedValues[locale.languageCode]?['termsAndConditions'] ??
      'Terms & Conditions';
  String get and => _localizedValues[locale.languageCode]?['and'] ?? 'and';
  String get registrationSuccessful =>
      _localizedValues[locale.languageCode]?['registrationSuccessful'] ??
      'Registration Successful';
  String get pleaseVerifyEmail =>
      _localizedValues[locale.languageCode]?['pleaseVerifyEmail'] ??
      'Please verify your email to continue';
  String get registrationFailed =>
      _localizedValues[locale.languageCode]?['registrationFailed'] ??
      'Registration Failed';

  // Common widget translations
  String get loading =>
      _localizedValues[locale.languageCode]?['loading'] ?? 'Loading...';
  String get error =>
      _localizedValues[locale.languageCode]?['error'] ?? 'Error';
  String get success =>
      _localizedValues[locale.languageCode]?['success'] ?? 'Success';
  String get save => _localizedValues[locale.languageCode]?['save'] ?? 'Save';
  String get delete =>
      _localizedValues[locale.languageCode]?['delete'] ?? 'Delete';
  String get edit => _localizedValues[locale.languageCode]?['edit'] ?? 'Edit';
  String get ok => _localizedValues[locale.languageCode]?['ok'] ?? 'OK';
  String get next => _localizedValues[locale.languageCode]?['next'] ?? 'Next';
  String get previous =>
      _localizedValues[locale.languageCode]?['previous'] ?? 'Previous';
  String get search =>
      _localizedValues[locale.languageCode]?['search'] ?? 'Search';
  String get clear =>
      _localizedValues[locale.languageCode]?['clear'] ?? 'Clear';
  String get apply =>
      _localizedValues[locale.languageCode]?['apply'] ?? 'Apply';
  String get filter =>
      _localizedValues[locale.languageCode]?['filter'] ?? 'Filter';
  String get sort => _localizedValues[locale.languageCode]?['sort'] ?? 'Sort';
  String get share =>
      _localizedValues[locale.languageCode]?['share'] ?? 'Share';
  String get noResultsFound =>
      _localizedValues[locale.languageCode]?['noResultsFound'] ??
      'No results found';
  String get tryAgain =>
      _localizedValues[locale.languageCode]?['tryAgain'] ?? 'Try Again';
  String get refresh =>
      _localizedValues[locale.languageCode]?['refresh'] ?? 'Refresh';
  String get addToFavorites =>
      _localizedValues[locale.languageCode]?['addToFavorites'] ??
      'Add to favorites';
  String get removeFromFavorites =>
      _localizedValues[locale.languageCode]?['removeFromFavorites'] ??
      'Remove from favorites';
  String get today =>
      _localizedValues[locale.languageCode]?['today'] ?? 'Today';
  String get tomorrow =>
      _localizedValues[locale.languageCode]?['tomorrow'] ?? 'Tomorrow';
  String get selectDate =>
      _localizedValues[locale.languageCode]?['selectDate'] ?? 'Select Date';
  String get selectTime =>
      _localizedValues[locale.languageCode]?['selectTime'] ?? 'Select Time';
  String get done => _localizedValues[locale.languageCode]?['done'] ?? 'Done';
  String get noVouchersFound =>
      _localizedValues[locale.languageCode]?['noVouchersFound'] ??
      'No vouchers found';
  String get checkBackLater =>
      _localizedValues[locale.languageCode]?['checkBackLater'] ??
      'Check back later for new offers';

  // Account details fields
  String get name => _localizedValues[locale.languageCode]?['name'] ?? 'Name';
  String get email =>
      _localizedValues[locale.languageCode]?['email'] ?? 'Email';
  String get phone =>
      _localizedValues[locale.languageCode]?['phone'] ?? 'Phone';
  String get dateOfBirth =>
      _localizedValues[locale.languageCode]?['dateOfBirth'] ?? 'Date of Birth';
  String get address =>
      _localizedValues[locale.languageCode]?['address'] ?? 'Address';
  String get pointsValue =>
      _localizedValues[locale.languageCode]?['pointsValue'] ??
      '{points} Points';
  String get pointsSummary =>
      _localizedValues[locale.languageCode]?['pointsSummary'] ??
      'Total earned: {earned} • Total redeemed: {redeemed}';

  // Additional Points Screen Translations
  String get errorLoadingPoints =>
      _localizedValues[locale.languageCode]?['errorLoadingPoints'] ??
      'Error loading points';
  String get errorLoadingMore =>
      _localizedValues[locale.languageCode]?['errorLoadingMore'] ??
      'Error loading more transactions';
  String get currentBalance =>
      _localizedValues[locale.languageCode]?['currentBalance'] ??
      'Current Balance';
  String get totalEarned =>
      _localizedValues[locale.languageCode]?['totalEarned'] ?? 'Total Earned';
  String get totalSpent =>
      _localizedValues[locale.languageCode]?['totalSpent'] ?? 'Total Spent';
  String get transactionHistory =>
      _localizedValues[locale.languageCode]?['transactionHistory'] ??
      'Transaction History';
  String get noTransactions =>
      _localizedValues[locale.languageCode]?['noTransactions'] ??
      'No transactions yet';
  String get noPointsAvailable =>
      _localizedValues[locale.languageCode]?['noPointsAvailable'] ??
      'No Points Available';
  String get noPointsMessage =>
      _localizedValues[locale.languageCode]?['noPointsMessage'] ??
      'You don\'t have any points to redeem yet. Start using our services to earn points!';
  String get failedToLoadTimeSlots =>
      _localizedValues[locale.languageCode]?['failedToLoadTimeSlots'] ??
      'Failed to load available time slots';
  String get failedToValidatePoints =>
      _localizedValues[locale.languageCode]?['failedToValidatePoints'] ??
      'Failed to validate points';
  String get pointsValidatedSuccessfully =>
      _localizedValues[locale.languageCode]?['pointsValidatedSuccessfully'] ??
      'Points validated successfully';
  String get invalidPointsAmount =>
      _localizedValues[locale.languageCode]?['invalidPointsAmount'] ??
      'Invalid points amount';

  String get loginRequired =>
      _localizedValues[locale.languageCode]?['loginRequired'] ??
      'Login Required';
  String get loginRequiredMessage =>
      _localizedValues[locale.languageCode]?['loginRequiredMessage'] ??
      'You need to be logged in to access this feature.';
  String get leaveAReview =>
      _localizedValues[locale.languageCode]?['leaveAReview'] ??
      'Leave a Review';
  String get howWasYourExperience =>
      _localizedValues[locale.languageCode]?['howWasYourExperience'] ??
      'How was your experience?';
  String get shareYourExperience =>
      _localizedValues[locale.languageCode]?['shareYourExperience'] ??
      'Share your experience';
  String get tellUsAboutExperience =>
      _localizedValues[locale.languageCode]?['tellUsAboutExperience'] ??
      'Tell us about your experience with the vet and the service provided...';
  String get submitReview =>
      _localizedValues[locale.languageCode]?['submitReview'] ??
      'Submit Review';
  String get pleaseSelectRating =>
      _localizedValues[locale.languageCode]?['pleaseSelectRating'] ??
      'Please select a rating';
  String get pleaseEnterReviewComment =>
      _localizedValues[locale.languageCode]?['pleaseEnterReviewComment'] ??
      'Please enter a review comment';
  String get reviewSubmittedSuccessfully =>
      _localizedValues[locale.languageCode]?['reviewSubmittedSuccessfully'] ??
      'Review submitted successfully!';
  String get veterinaryClinic =>
      _localizedValues[locale.languageCode]?['veterinaryClinic'] ??
      'Veterinary Clinic';
  String get rating =>
      _localizedValues[locale.languageCode]?['rating'] ?? 'Rating';
  String get ratingPoor =>
      _localizedValues[locale.languageCode]?['ratingPoor'] ?? 'Poor';
  String get ratingFair =>
      _localizedValues[locale.languageCode]?['ratingFair'] ?? 'Fair';
  String get ratingGood =>
      _localizedValues[locale.languageCode]?['ratingGood'] ?? 'Good';
  String get ratingVeryGood =>
      _localizedValues[locale.languageCode]?['ratingVeryGood'] ?? 'Very Good';
  String get ratingExcellent =>
      _localizedValues[locale.languageCode]?['ratingExcellent'] ?? 'Excellent';
  String get appointment =>
      _localizedValues[locale.languageCode]?['appointment'] ?? 'Appointment';
  String get deleteAccountConfirmation =>
      _localizedValues[locale.languageCode]?['deleteAccountConfirmation'] ??
      'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently lost.';
  String get accountDetailsUpdatedSuccessfully =>
      _localizedValues[locale.languageCode]
          ?['accountDetailsUpdatedSuccessfully'] ??
      'Account details updated successfully!';
  String failedToUpdateProfile(String error) =>
      _localizedValues[locale.languageCode]?['failedToUpdateProfile']
          ?.replaceAll('{error}', error) ??
      'Failed to update profile: $error';
  String voucherCodeCopied(String code) =>
      _localizedValues[locale.languageCode]?['voucherCodeCopied']
          ?.replaceAll('{code}', code) ??
      'Voucher code "$code" copied to clipboard';

  // Pet-related translations
  String get loginRequiredToAddPets =>
      _localizedValues[locale.languageCode]?['loginRequiredToAddPets'] ??
      'You need to be logged in to add pets.';
  String get loginRequiredToUpdatePets =>
      _localizedValues[locale.languageCode]?['loginRequiredToUpdatePets'] ??
      'You need to be logged in to update pets.';
  String get chooseFromGallery =>
      _localizedValues[locale.languageCode]?['chooseFromGallery'] ??
      'Choose from Gallery';
  String get takeAPhoto =>
      _localizedValues[locale.languageCode]?['takeAPhoto'] ?? 'Take a Photo';
  String get addYourFirstPet =>
      _localizedValues[locale.languageCode]?['addYourFirstPet'] ??
      'Add Your First Pet';
  String get deleting =>
      _localizedValues[locale.languageCode]?['deleting'] ?? 'Deleting...';
  String get refreshPets =>
      _localizedValues[locale.languageCode]?['refreshPets'] ?? 'Refresh pets';
  String get errorLoadingPets =>
      _localizedValues[locale.languageCode]?['errorLoadingPets'] ??
      'Error loading pets';
  String get noPetsAddedYet =>
      _localizedValues[locale.languageCode]?['noPetsAddedYet'] ??
      'No pets added yet';
  String get addYourFurryFriends =>
      _localizedValues[locale.languageCode]?['addYourFurryFriends'] ??
      'Add your furry friends to keep track of their health and appointments';
  String get yearOld =>
      _localizedValues[locale.languageCode]?['yearOld'] ?? 'year old';
  String get yearsOld =>
      _localizedValues[locale.languageCode]?['yearsOld'] ?? 'years old';
  String get monthOld =>
      _localizedValues[locale.languageCode]?['monthOld'] ?? 'month old';
  String get monthsOld =>
      _localizedValues[locale.languageCode]?['monthsOld'] ?? 'months old';

  // Additional pet screen translations
  String get choosePhoto =>
      _localizedValues[locale.languageCode]?['choosePhoto'] ?? 'Choose Photo';
  String get camera =>
      _localizedValues[locale.languageCode]?['camera'] ?? 'Camera';
  String get gallery =>
      _localizedValues[locale.languageCode]?['gallery'] ?? 'Gallery';
  String get invalidSpecies =>
      _localizedValues[locale.languageCode]?['invalidSpecies'] ??
      'Invalid Species';
  String get onlyCatsAndDogsAllowed =>
      _localizedValues[locale.languageCode]?['onlyCatsAndDogsAllowed'] ??
      'Only cats and dogs are allowed.';
  String get failedToUpdatePet =>
      _localizedValues[locale.languageCode]?['failedToUpdatePet'] ??
      'Failed to update pet. Please try again.';

  String get birthday =>
      _localizedValues[locale.languageCode]?['birthday'] ?? 'Birthday';
  String get species =>
      _localizedValues[locale.languageCode]?['species'] ?? 'Species';
  String get gender =>
      _localizedValues[locale.languageCode]?['gender'] ?? 'Gender';
  String get notSpayedNeutered =>
      _localizedValues[locale.languageCode]?['notSpayedNeutered'] ??
      'Not Spayed/Neutered';

  // Add Pet screen strings
  String get addNewPet =>
      _localizedValues[locale.languageCode]?['addNewPet'] ?? 'Add New Pet';
  String get petName =>
      _localizedValues[locale.languageCode]?['petName'] ?? 'Pet Name';
  String get enterPetName =>
      _localizedValues[locale.languageCode]?['enterPetName'] ??
      'Enter your pet\'s name';
  String get pleaseEnterPetName =>
      _localizedValues[locale.languageCode]?['pleaseEnterPetName'] ??
      'Please enter your pet\'s name';
  String get petType =>
      _localizedValues[locale.languageCode]?['petType'] ?? 'Pet Type';
  String get birthdate =>
      _localizedValues[locale.languageCode]?['birthdate'] ?? 'Birthdate';
  String get age =>
      _localizedValues[locale.languageCode]?['age'] ?? 'Age';
  String get enterPetAge =>
      _localizedValues[locale.languageCode]?['enterPetAge'] ?? 'Enter your pet\'s age';
  String get days =>
      _localizedValues[locale.languageCode]?['days'] ?? 'days';
  String get months =>
      _localizedValues[locale.languageCode]?['months'] ?? 'months';
  String get years =>
      _localizedValues[locale.languageCode]?['years'] ?? 'years';
  String get pleaseEnterValidAge =>
      _localizedValues[locale.languageCode]?['pleaseEnterValidAge'] ?? 'Please enter a valid age';
  String get weightKg =>
      _localizedValues[locale.languageCode]?['weightKg'] ?? 'Weight (kg)';
  String get kg => _localizedValues[locale.languageCode]?['kg'] ?? 'kg';
  String get allergies =>
      _localizedValues[locale.languageCode]?['allergies'] ?? 'Allergies';
  String get addNotes =>
      _localizedValues[locale.languageCode]?['addNotes'] ??
      'Any additional information about your pet';
  String get spayedNeuteredQuestion =>
      _localizedValues[locale.languageCode]?['spayedNeuteredQuestion'] ??
      'Spayed/Neutered?';
  String get savePet =>
      _localizedValues[locale.languageCode]?['savePet'] ?? 'Save Pet';
  String get saveChanges =>
      _localizedValues[locale.languageCode]?['saveChanges'] ?? 'Save Changes';

  String get petAddedSuccessfully =>
      _localizedValues[locale.languageCode]?['petAddedSuccessfully'] ??
      '{name} has been added successfully.';
  String get failedToAddPet =>
      _localizedValues[locale.languageCode]?['failedToAddPet'] ??
      'Failed to add pet. Please try again.';

  // Pet Profile screen strings
  String get petProfile =>
      _localizedValues[locale.languageCode]?['petProfile'] ?? 'Pet Profile';
  String get submit =>
      _localizedValues[locale.languageCode]?['submit'] ?? 'Submit';
  String get completeProfile =>
      _localizedValues[locale.languageCode]?['completeProfile'] ?? 'Complete Your Profile';
  String get completeProfileSubtitle =>
      _localizedValues[locale.languageCode]?['completeProfileSubtitle'] ?? 'We need a few more details to set up your account.';
  String get justAFewMoreDetails =>
      _localizedValues[locale.languageCode]?['justAFewMoreDetails'] ?? 'Just a few more details';
  String get enterFullName =>
      _localizedValues[locale.languageCode]?['enterFullName'] ?? 'Enter your full name';
  String get nameRequired =>
      _localizedValues[locale.languageCode]?['nameRequired'] ?? 'Name is required';
  String get fullNameRequired =>
      _localizedValues[locale.languageCode]?['fullNameRequired'] ?? 'Please enter your full name (first and last name)';
  String get profileUpdatedSuccessfully =>
      _localizedValues[locale.languageCode]?['profileUpdatedSuccessfully'] ?? 'Profile updated successfully!';
  String get editPet =>
      _localizedValues[locale.languageCode]?['editPet'] ?? 'Edit Pet';
  String get confirmDelete =>
      _localizedValues[locale.languageCode]?['confirmDelete'] ??
      'Confirm Delete';
  String get areYouSureDeletePet =>
      _localizedValues[locale.languageCode]?['areYouSureDeletePet'] ??
      'Are you sure you want to delete this pet?';
  String get thisActionCannotBeUndone =>
      _localizedValues[locale.languageCode]?['thisActionCannotBeUndone'] ??
      'This action cannot be undone.';

  String get updatePet =>
      _localizedValues[locale.languageCode]?['updatePet'] ?? 'Update Pet';
  String get weight =>
      _localizedValues[locale.languageCode]?['weight'] ?? 'Weight';
  String get lastVetVisit =>
      _localizedValues[locale.languageCode]?['lastVetVisit'] ??
      'Last Vet Visit';
  String get addVaccination =>
      _localizedValues[locale.languageCode]?['addVaccination'] ??
      'Add Vaccination';
  String get petUpdatedSuccessfully =>
      _localizedValues[locale.languageCode]?['petUpdatedSuccessfully'] ??
      '{name} has been updated successfully.';
  String get info => _localizedValues[locale.languageCode]?['info'] ?? 'Info';
  String get noChangesToUpdate =>
      _localizedValues[locale.languageCode]?['noChangesToUpdate'] ??
      'No changes to update';

  String get dateToday =>
      _localizedValues[locale.languageCode]?['dateToday'] ?? 'Today';
  String get dateYesterday =>
      _localizedValues[locale.languageCode]?['dateYesterday'] ?? 'Yesterday';
  String get dateDaysAgo =>
      _localizedValues[locale.languageCode]?['dateDaysAgo'] ??
      '{days} days ago';

  // Add these new getters to the AppLocalizations class
  String get yourPetCareActivities =>
      _localizedValues[locale.languageCode]?['yourPetCareActivities'] ??
      'Your Pet Care Activities';
  String get noActivitiesFound =>
      _localizedValues[locale.languageCode]?['noActivitiesFound'] ??
      'No activities found';
  String get activitiesMatchingFilterWillAppearHere =>
      _localizedValues[locale.languageCode]
          ?['activitiesMatchingFilterWillAppearHere'] ??
      'Activities matching filter will appear here';
  String get appointmentCancelledSuccessfully =>
      _localizedValues[locale.languageCode]
          ?['appointmentCancelledSuccessfully'] ??
      'Appointment cancelled successfully';
  String get failedToCancelAppointment =>
      _localizedValues[locale.languageCode]?['failedToCancelAppointment'] ??
      'Failed to cancel appointment';
  String get rescheduleFeatureComingSoon =>
      _localizedValues[locale.languageCode]?['rescheduleFeatureComingSoon'] ??
      'Reschedule feature coming soon!';
  String get reviewFeatureComingSoon =>
      _localizedValues[locale.languageCode]?['reviewFeatureComingSoon'] ??
      'Review feature coming soon!';
  String get bookingFollowupAppointment =>
      _localizedValues[locale.languageCode]?['bookingFollowupAppointment'] ??
      'Booking follow-up appointment...';

  // Add these getters to your AppLocalizations class
  String get upcoming =>
      _localizedValues[locale.languageCode]?['upcoming'] ?? 'Upcoming';
  String get pending =>
      _localizedValues[locale.languageCode]?['pending'] ?? 'Pending';
  String get confirmed =>
      _localizedValues[locale.languageCode]?['confirmed'] ?? 'Confirmed';
  String get completed =>
      _localizedValues[locale.languageCode]?['completed'] ?? 'Completed';
  String get cancelled =>
      _localizedValues[locale.languageCode]?['cancelled'] ?? 'Cancelled';
  String get rescheduled =>
      _localizedValues[locale.languageCode]?['rescheduled'] ?? 'Rescheduled';
  String get reschedule =>
      _localizedValues[locale.languageCode]?['reschedule'] ?? 'Reschedule';
  String get writeReview =>
      _localizedValues[locale.languageCode]?['writeReview'] ?? 'Write Review';
  String get bookAgain =>
      _localizedValues[locale.languageCode]?['bookAgain'] ?? 'Book Again';
  String get all => _localizedValues[locale.languageCode]?['all'] ?? 'All';
  String get cancelAppointment =>
      _localizedValues[locale.languageCode]?['cancelAppointment'] ??
      'Cancel Appointment';
  String get keepAppointment =>
      _localizedValues[locale.languageCode]?['keepAppointment'] ??
      'Keep Appointment';
  String get confirmCancelAppointmentMessage =>
      _localizedValues[locale.languageCode]
          ?['confirmCancelAppointmentMessage'] ??
      'Are you sure you want to cancel this appointment?';
  String get yesCancelAppointment =>
      _localizedValues[locale.languageCode]?['yesCancelAppointment'] ??
      'Yes, Cancel';
  String get appointmentDetails =>
      _localizedValues[locale.languageCode]?['appointmentDetails'] ??
      'Appointment Details';
  String get vetName =>
      _localizedValues[locale.languageCode]?['vetName'] ?? 'Vet Name';
  String get appointmentType =>
      _localizedValues[locale.languageCode]?['appointmentType'] ??
      'Appointment Type';
  String get dateAndTime =>
      _localizedValues[locale.languageCode]?['dateAndTime'] ?? 'Date & Time';
  String get status =>
      _localizedValues[locale.languageCode]?['status'] ?? 'Status';
  String get notes =>
      _localizedValues[locale.languageCode]?['notes'] ?? 'Notes';
  String get close =>
      _localizedValues[locale.languageCode]?['close'] ?? 'Close';
  String get leaveReview =>
      _localizedValues[locale.languageCode]?['leaveReview'] ?? 'Leave Review';
  String get scanQrCode =>
      _localizedValues[locale.languageCode]?['scanQrCode'] ?? 'Scan QR Code';
  String get scanVetQrCodeToComplete =>
      _localizedValues[locale.languageCode]?['scanVetQrCodeToComplete'] ??
      'Scan Vet QR Code to Complete';
  String get pointCameraAtQrCode =>
      _localizedValues[locale.languageCode]?['pointCameraAtQrCode'] ??
      'Point your camera at the QR code';
  String get appointmentCompletedSuccessfully =>
      _localizedValues[locale.languageCode]
          ?['appointmentCompletedSuccessfully'] ??
      'Appointment completed successfully';
  String get scanQrToComplete =>
      _localizedValues[locale.languageCode]?['scanQrToComplete'] ??
      'Scan QR to Complete';

  // Medical Records Screen
  String get medicalRecords =>
      _localizedValues[locale.languageCode]?['medicalRecords'] ?? 'Medical Records';
  String get medicalDetails =>
      _localizedValues[locale.languageCode]?['medicalDetails'] ?? 'Medical Details';
  String get latestRecord =>
      _localizedValues[locale.languageCode]?['latestRecord'] ?? 'Latest Record';
  String get viewAllRecords =>
      _localizedValues[locale.languageCode]?['viewAllRecords'] ?? 'View All Records';
  String get noMedicalRecordsYet =>
      _localizedValues[locale.languageCode]?['noMedicalRecordsYet'] ?? 'No medical records yet';
  String get logHealthEvent =>
      _localizedValues[locale.languageCode]?['logHealthEvent'] ?? 'Add Medical Record';
  String get selectRecordType =>
      _localizedValues[locale.languageCode]?['selectRecordType'] ?? 'SELECT RECORD TYPE';
  String get commonSymptoms =>
      _localizedValues[locale.languageCode]?['commonSymptoms'] ?? 'COMMON SYMPTOMS';
  String get customSymptom =>
      _localizedValues[locale.languageCode]?['customSymptom'] ?? 'CUSTOM SYMPTOM';
  String get nameType =>
      _localizedValues[locale.languageCode]?['nameType'] ?? 'NAME / TYPE';
  String get dateOfEvent =>
      _localizedValues[locale.languageCode]?['dateOfEvent'] ?? 'DATE OF EVENT';
  String get locationProvider =>
      _localizedValues[locale.languageCode]?['locationProvider'] ?? 'LOCATION / PROVIDER';
  String get eventDetails =>
      _localizedValues[locale.languageCode]?['eventDetails'] ?? 'EVENT DETAILS';
  String get attachments =>
      _localizedValues[locale.languageCode]?['attachments'] ?? 'ATTACHMENTS';
  String get saveRecord =>
      _localizedValues[locale.languageCode]?['saveRecord'] ?? 'Save Record';
  String get medicationName =>
      _localizedValues[locale.languageCode]?['medicationName'] ?? 'MEDICATION NAME';
  String get dosage =>
      _localizedValues[locale.languageCode]?['dosage'] ?? 'DOSAGE';
  String get vaccineTypeLabel =>
      _localizedValues[locale.languageCode]?['vaccineTypeLabel'] ?? 'VACCINE TYPE';
  String get category =>
      _localizedValues[locale.languageCode]?['category'] ?? 'CATEGORY';
  String get visitType =>
      _localizedValues[locale.languageCode]?['visitType'] ?? 'VISIT TYPE';
  String get testType =>
      _localizedValues[locale.languageCode]?['testType'] ?? 'TEST TYPE';
  String get procedureName =>
      _localizedValues[locale.languageCode]?['procedureName'] ?? 'PROCEDURE NAME';
  String get title =>
      _localizedValues[locale.languageCode]?['title'] ?? 'TITLE';
  String get uploadImages =>
      _localizedValues[locale.languageCode]?['uploadImages'] ?? 'Upload images';
  String get recordCreatedSuccessfully =>
      _localizedValues[locale.languageCode]?['recordCreatedSuccessfully'] ?? 'Medical record created successfully';
  String get inputRequired =>
      _localizedValues[locale.languageCode]?['inputRequired'] ?? 'Input Required';
  String get selectSymptomPrompt =>
      _localizedValues[locale.languageCode]?['selectSymptomPrompt'] ?? 'Please select at least one symptom or enter a custom one.';
  String get limitReached =>
      _localizedValues[locale.languageCode]?['limitReached'] ?? 'Limit Reached';
  String get attachLimitMsg =>
      _localizedValues[locale.languageCode]?['attachLimitMsg'] ?? 'You can only attach up to 10 files.';
  String get medication =>
      _localizedValues[locale.languageCode]?['medication'] ?? 'Medication';
  String get visit =>
      _localizedValues[locale.languageCode]?['visit'] ?? 'Visit';
  String get lab =>
      _localizedValues[locale.languageCode]?['lab'] ?? 'Lab';
  String get surgeryLabel =>
      _localizedValues[locale.languageCode]?['surgeryLabel'] ?? 'Surgery';
  String get event =>
      _localizedValues[locale.languageCode]?['event'] ?? 'Event';
  String get note =>
      _localizedValues[locale.languageCode]?['note'] ?? 'Note';

  // Notification getters
  String get notificationsTitle =>
      _localizedValues[locale.languageCode]?['Notifications'] ?? 'Notifications';
  String get markAllAsRead =>
      _localizedValues[locale.languageCode]?['Mark all as read'] ?? 'Mark all as read';
  String get notificationNew =>
      _localizedValues[locale.languageCode]?['new'] ?? 'new';
  String get noNotificationsYet =>
      _localizedValues[locale.languageCode]?['No notifications yet'] ?? 'No notifications yet';
  String get weWillNotifyYou =>
      _localizedValues[locale.languageCode]?['We\'ll notify you when something arrives'] ??
      'We\'ll notify you when something arrives';
  String get notificationDeleted =>
      _localizedValues[locale.languageCode]?['Notification deleted'] ?? 'Notification deleted';
  String get justNow =>
      _localizedValues[locale.languageCode]?['Just now'] ?? 'Just now';

  // Time ago formatters
  String minutesAgo(int count) {
    final template = _localizedValues[locale.languageCode]?['m ago'] ?? '@count min ago';
    return template.replaceAll('@count', count.toString());
  }

  String hoursAgo(int count) {
    final template = _localizedValues[locale.languageCode]?['h ago'] ?? '@count hr ago';
    return template.replaceAll('@count', count.toString());
  }

  String daysAgo(int count) {
    final template = _localizedValues[locale.languageCode]?['d ago'] ?? '@count day ago';
    return template.replaceAll('@count', count.toString());
  }

  // Add these getters to your AppLocalizations class
  String get date => _localizedValues[locale.languageCode]?['date'] ?? 'Date';
  String get time => _localizedValues[locale.languageCode]?['time'] ?? 'Time';
  String get service =>
      _localizedValues[locale.languageCode]?['service'] ?? 'Service';
  String get pet => _localizedValues[locale.languageCode]?['pet'] ?? 'Pet';
  String get duration =>
      _localizedValues[locale.languageCode]?['duration'] ?? 'Duration';
  String get fee => _localizedValues[locale.languageCode]?['fee'] ?? 'Fee';
  String get contactVet =>
      _localizedValues[locale.languageCode]?['contactVet'] ?? 'Contact Vet';
  // Add these getters to your AppLocalizations class
  String get vetDetails =>
      _localizedValues[locale.languageCode]?['vetDetails'] ?? 'vet Details';
  String get report =>
      _localizedValues[locale.languageCode]?['report'] ?? 'Report';
  String get minutes =>
      _localizedValues[locale.languageCode]?['minutes'] ?? 'minutes';
  String get reviews =>
      _localizedValues[locale.languageCode]?['reviews'] ?? 'Reviews';
  String get review =>
      _localizedValues[locale.languageCode]?['review'] ?? 'Review';
  String get reviewDetails =>
      _localizedValues[locale.languageCode]?['reviewDetails'] ?? 'Review Details';
  String get tapToViewDetails =>
      _localizedValues[locale.languageCode]?['tapToViewDetails'] ?? 'Tap to view details';
  String get noComment =>
      _localizedValues[locale.languageCode]?['noComment'] ?? 'No comment provided';
  String get noReviewsYet =>
      _localizedValues[locale.languageCode]?['noReviewsYet'] ??
      'No reviews yet';
  String get patients =>
      _localizedValues[locale.languageCode]?['patients'] ?? 'Patients';
  String get yearsExp =>
      _localizedValues[locale.languageCode]?['yearsExp'] ?? 'Years exp.';
  String get description =>
      _localizedValues[locale.languageCode]?['description'] ?? 'Description';
  String get defaultvetDescription =>
      _localizedValues[locale.languageCode]?['defaultvetDescription'] ??
      'BluePearl Pet Hospital is a network of specialized animal hospitals that offer emergency and specialist services. They focus on the care of pets that require specialized medical attention.';
  String get services =>
      _localizedValues[locale.languageCode]?['services'] ?? 'Services';
  String get generalWellnessExam =>
      _localizedValues[locale.languageCode]?['generalWellnessExam'] ??
      'General wellness exam';
  String get vaccinations =>
      _localizedValues[locale.languageCode]?['vaccinations'] ?? 'Vaccinations';
  String get microchipping =>
      _localizedValues[locale.languageCode]?['microchipping'] ??
      'Microchipping';
  String get nutritionalCounseling =>
      _localizedValues[locale.languageCode]?['nutritionalCounseling'] ??
      'Nutritional counseling';
  String get laboratoryServices =>
      _localizedValues[locale.languageCode]?['laboratoryServices'] ??
      'Laboratory services';
  String get surgery =>
      _localizedValues[locale.languageCode]?['surgery'] ?? 'Surgery';
  String get dentalCare =>
      _localizedValues[locale.languageCode]?['dentalCare'] ?? 'Dental care';
  String get emergencyCare =>
      _localizedValues[locale.languageCode]?['emergencyCare'] ??
      'Emergency care';
  String get consultationFee =>
      _localizedValues[locale.languageCode]?['consultationFee'] ??
      'Consultation Fee';
  String get emergencyFee =>
      _localizedValues[locale.languageCode]?['emergencyFee'] ??
      'Emergency Fee';
  String get initialExaminationFee =>
      _localizedValues[locale.languageCode]?['initialExaminationFee'] ??
      'Initial examination fee';
  String get earnPoints =>
      _localizedValues[locale.languageCode]?['earnPoints'] ??
      'Earn';
  String get pointsAfterCompletion =>
      _localizedValues[locale.languageCode]?['pointsAfterCompletion'] ??
      'points after completing your visit!';
  String get workingHours =>
      _localizedValues[locale.languageCode]?['workingHours'] ?? 'Working Hours';
  String get mondayFriday =>
      _localizedValues[locale.languageCode]?['mondayFriday'] ??
      'Monday - Friday';
  String get saturday =>
      _localizedValues[locale.languageCode]?['saturday'] ?? 'Saturday';
  String get sunday =>
      _localizedValues[locale.languageCode]?['sunday'] ?? 'Sunday';
  String get bookConsultation =>
      _localizedValues[locale.languageCode]?['bookConsultation'] ??
      'Book Consultation';
  String get consultation =>
      _localizedValues[locale.languageCode]?['consultation'] ?? 'Consultation';
  // Add these getters to your AppLocalizations class
  String get findVets =>
      _localizedValues[locale.languageCode]?['findVets'] ?? 'Find Vets';
  String get refreshLocation =>
      _localizedValues[locale.languageCode]?['refreshLocation'] ??
      'Refresh Location';
  String get enableLocation =>
      _localizedValues[locale.languageCode]?['enableLocation'] ??
      'Enable Location';
  String get searchVetsHint =>
      _localizedValues[locale.languageCode]?['searchVetsHint'] ??
      'Search Vets, services, locations...';
  String get filters =>
      _localizedValues[locale.languageCode]?['filters'] ?? 'Filters';
  String get allCategory =>
      _localizedValues[locale.languageCode]?['allCategory'] ?? 'All Category';
  String get popular =>
      _localizedValues[locale.languageCode]?['popular'] ?? 'Popular';
  String get recommended =>
      _localizedValues[locale.languageCode]?['recommended'] ?? 'Recommended';
  String get latest =>
      _localizedValues[locale.languageCode]?['latest'] ?? 'Latest';
  String get currentLocation =>
      _localizedValues[locale.languageCode]?['currentLocation'] ??
      'Current Location';
  String get gettingLocation =>
      _localizedValues[locale.languageCode]?['gettingLocation'] ??
      'Getting location...';
  String get enableLocationForResults =>
      _localizedValues[locale.languageCode]?['enableLocationForResults'] ??
      'Enable location for distance-based results';
  String get enable =>
      _localizedValues[locale.languageCode]?['enable'] ?? 'Enable';
  String get searchResult =>
      _localizedValues[locale.languageCode]?['searchResult'] ?? 'Search Result';
  String get noVetsFound =>
      _localizedValues[locale.languageCode]?['noVetsFound'] ?? 'No vets found';
  String get tryAdjustingFilters =>
      _localizedValues[locale.languageCode]?['tryAdjustingFilters'] ??
      'Try adjusting your search or filters';
  String get clearFilters =>
      _localizedValues[locale.languageCode]?['clearFilters'] ?? 'Clear Filters';
  String get viewDetails =>
      _localizedValues[locale.languageCode]?['viewDetails'] ?? 'View Details';
  String get callVet =>
      _localizedValues[locale.languageCode]?['callVet'] ?? 'Call Vet';
  String get failedToLoadVets =>
      _localizedValues[locale.languageCode]?['failedToLoadVets'] ??
      'Failed to load vets. Please try again.';
  String get errorApplyingFilters =>
      _localizedValues[locale.languageCode]?['errorApplyingFilters'] ??
      'Error applying filters. Please try again.';
  // Add these getters to your AppLocalizations class
  String get region =>
      _localizedValues[locale.languageCode]?['region'] ?? 'Region';
  String get allRegions =>
      _localizedValues[locale.languageCode]?['allRegions'] ?? 'All Regions';
  String get nearbyAutoDetect =>
      _localizedValues[locale.languageCode]?['nearbyAutoDetect'] ??
      'Nearby (Auto-detect)';
  String get allServices =>
      _localizedValues[locale.languageCode]?['allServices'] ?? 'All Services';
  String get sortBy =>
      _localizedValues[locale.languageCode]?['sortBy'] ?? 'Sort By';
  String get sortDefault =>
      _localizedValues[locale.languageCode]?['sortDefault'] ?? 'Default';
  String get sortNearby =>
      _localizedValues[locale.languageCode]?['sortNearby'] ?? 'Nearby';
  String get sortRating =>
      _localizedValues[locale.languageCode]?['sortRating'] ?? 'Highest Rating';
  String get sortReviews =>
      _localizedValues[locale.languageCode]?['sortReviews'] ?? 'Most Reviews';
  String get sortName =>
      _localizedValues[locale.languageCode]?['sortName'] ?? 'Name (A-Z)';
  String get maxDistance =>
      _localizedValues[locale.languageCode]?['maxDistance'] ??
      'Maximum Distance';
  String get anyDistance =>
      _localizedValues[locale.languageCode]?['anyDistance'] ?? 'Any Distance';
  String get clearAll =>
      _localizedValues[locale.languageCode]?['clearAll'] ?? 'Clear All';
  String get applyFilters =>
      _localizedValues[locale.languageCode]?['applyFilters'] ?? 'Apply Filters';
  String get vaccination =>
      _localizedValues[locale.languageCode]?['vaccination'] ?? 'Vaccination';
  String get checkup =>
      _localizedValues[locale.languageCode]?['checkup'] ?? 'Checkup';
  String get grooming =>
      _localizedValues[locale.languageCode]?['grooming'] ?? 'Grooming';
  String get emergency =>
      _localizedValues[locale.languageCode]?['emergency'] ?? 'Emergency';
  String get selectLocation =>
      _localizedValues[locale.languageCode]?['selectLocation'] ?? 'Select Location';
  String get selectGovernorateOrCity =>
      _localizedValues[locale.languageCode]?['selectGovernorateOrCity'] ?? 'Select Governorate or City';
  String get searchGovernorate =>
      _localizedValues[locale.languageCode]?['searchGovernorate'] ?? 'Search governorate...';
  String get selectCity =>
      _localizedValues[locale.languageCode]?['selectCity'] ?? 'Select City';
  String get searchCity =>
      _localizedValues[locale.languageCode]?['searchCity'] ?? 'Search city...';
  String get selectEntireGovernorate =>
      _localizedValues[locale.languageCode]?['selectEntireGovernorate'] ?? 'Select entire governorate';
  // Add these getters to your AppLocalizations class
  String get bookVetVisit =>
      _localizedValues[locale.languageCode]?['bookVetVisit'] ??
      'Book Vet Visit';
  String get resetBooking =>
      _localizedValues[locale.languageCode]?['resetBooking'] ?? 'Reset Booking';
  String get bookingDetails =>
      _localizedValues[locale.languageCode]?['bookingDetails'] ??
      'Booking Details';
  String get vet => _localizedValues[locale.languageCode]?['vet'] ?? 'vet';
  String get price =>
      _localizedValues[locale.languageCode]?['price'] ?? 'Price';
  String get selectTimeSlot =>
      _localizedValues[locale.languageCode]?['selectTimeSlot'] ??
      'Select Time Slot';

  // Points Redemption getters
  String get redeemPoints =>
      _localizedValues[locale.languageCode]?['redeemPoints'] ?? 'Redeem Points';
  String get availablePoints =>
      _localizedValues[locale.languageCode]?['availablePoints'] ?? 'Available Points';
  String get pointsToRedeem =>
      _localizedValues[locale.languageCode]?['pointsToRedeem'] ?? 'Points to Redeem';
  String get enterPointsAmount =>
      _localizedValues[locale.languageCode]?['enterPointsAmount'] ?? 'Enter points amount';
  String get pointsDiscount =>
      _localizedValues[locale.languageCode]?['pointsDiscount'] ?? 'Points Discount';
  String get remainingBalance =>
      _localizedValues[locale.languageCode]?['remainingBalance'] ?? 'Remaining Balance';
  String get originalPrice =>
      _localizedValues[locale.languageCode]?['originalPrice'] ?? 'Original Price';
  String get discount =>
      _localizedValues[locale.languageCode]?['discount'] ?? 'Discount';
  String get finalPrice =>
      _localizedValues[locale.languageCode]?['finalPrice'] ?? 'Final Price';
  String get totalPrice =>
      _localizedValues[locale.languageCode]?['totalPrice'] ?? 'Total Price';
  String get pts =>
      _localizedValues[locale.languageCode]?['pts'] ?? 'pts';
  String get totalSavings =>
      _localizedValues[locale.languageCode]?['totalSavings'] ?? 'Total Savings';
  String get vetDiscount =>
      _localizedValues[locale.languageCode]?['vetDiscount'] ?? 'Vet Discount';
  String get coupon =>
      _localizedValues[locale.languageCode]?['coupon'] ?? 'Coupon';
  String get points =>
      _localizedValues[locale.languageCode]?['points'] ?? 'Points';

  String get morning =>
      _localizedValues[locale.languageCode]?['morning'] ?? 'Morning';
  String get afternoon =>
      _localizedValues[locale.languageCode]?['afternoon'] ?? 'Afternoon';
  String get evening =>
      _localizedValues[locale.languageCode]?['evening'] ?? 'Evening';
  String get petsForVisitOptional =>
      _localizedValues[locale.languageCode]?['petsForVisitOptional'] ??
      'Pets for Visit (Optional)';
  String get tapToSelectPets =>
      _localizedValues[locale.languageCode]?['tapToSelectPets'] ??
      'Tap to select pets for this visit';

  // Vaccination Screen Strings
  String get vaccinationRecord =>
      _localizedValues[locale.languageCode]?['vaccinationRecord'] ??
      'Vaccination Record';
  String get addVaccine =>
      _localizedValues[locale.languageCode]?['addVaccine'] ?? 'Add Vaccine';
  String get viewAll =>
      _localizedValues[locale.languageCode]?['viewAll'] ?? 'View All';
  String get virusVaccines =>
      _localizedValues[locale.languageCode]?['virusVaccines'] ??
      'Virus Vaccines';
  String get wormsVaccines =>
      _localizedValues[locale.languageCode]?['wormsVaccines'] ?? 'Worms';
  String get insectsVaccines =>
      _localizedValues[locale.languageCode]?['insectsVaccines'] ?? 'Insects';
  String get rabiesVaccines =>
      _localizedValues[locale.languageCode]?['rabiesVaccines'] ?? 'Rabies';
  String get monovalent =>
      _localizedValues[locale.languageCode]?['monovalent'] ?? 'Monovalent';
  String get bivalent =>
      _localizedValues[locale.languageCode]?['bivalent'] ?? 'Bivalent';
  String get trivalent =>
      _localizedValues[locale.languageCode]?['trivalent'] ?? 'Trivalent';
  String get quadrivalent =>
      _localizedValues[locale.languageCode]?['quadrivalent'] ?? 'Quadrivalent';
  String get pentavalent =>
      _localizedValues[locale.languageCode]?['pentavalent'] ?? 'Pentavalent';
  String get hexavalent =>
      _localizedValues[locale.languageCode]?['hexavalent'] ?? 'Hexavalent';
  String get heptavalent =>
      _localizedValues[locale.languageCode]?['heptavalent'] ?? 'Heptavalent';
  String get octavalent =>
      _localizedValues[locale.languageCode]?['octavalent'] ?? 'Octavalent';
  String get deworming =>
      _localizedValues[locale.languageCode]?['deworming'] ?? 'Deworming';
  String get antiInsects =>
      _localizedValues[locale.languageCode]?['antiInsects'] ?? 'Anti-Insects';
  String get rabies =>
      _localizedValues[locale.languageCode]?['rabies'] ?? 'Rabies';
  String get vaccineType =>
      _localizedValues[locale.languageCode]?['vaccineType'] ?? 'Vaccine Type';
  String get vaccinationDate =>
      _localizedValues[locale.languageCode]?['vaccinationDate'] ??
      'Vaccination Date';
  String get administeredDoses =>
      _localizedValues[locale.languageCode]?['administeredDoses'] ??
      'Administered Doses';
  String get addAnotherDose =>
      _localizedValues[locale.languageCode]?['addAnotherDose'] ??
      'Add Another Dose';
  String get maximumDosesReached =>
      _localizedValues[locale.languageCode]?['maximumDosesReached'] ??
      'Maximum Doses Reached';
  String get maximumReached =>
      _localizedValues[locale.languageCode]?['maximumReached'] ??
      'Maximum Reached';
  String get thisVaccineRequiresOnly1Dose =>
      _localizedValues[locale.languageCode]?['thisVaccineRequiresOnly1Dose'] ??
      'This vaccine requires only 1 dose';
  String get thisVaccineRequiresOnly2Doses =>
      _localizedValues[locale.languageCode]?['thisVaccineRequiresOnly2Doses'] ??
      'This vaccine requires only 2 doses';
  String get youCanOnlyAddUpTo3Doses =>
      _localizedValues[locale.languageCode]?['youCanOnlyAddUpTo3Doses'] ??
      'You can only add up to 3 doses';
  String get pleaseSelectVaccineType =>
      _localizedValues[locale.languageCode]?['pleaseSelectVaccineType'] ??
      'Please select a vaccine type';
  String get pleaseAddAtLeastOneDose =>
      _localizedValues[locale.languageCode]?['pleaseAddAtLeastOneDose'] ??
      'Please add at least one dose';
  String get vaccinationAddedSuccessfully =>
      _localizedValues[locale.languageCode]?['vaccinationAddedSuccessfully'] ??
      'Vaccination added successfully';
  String get dateAdministered =>
      _localizedValues[locale.languageCode]?['dateAdministered'] ??
      'Date Administered';
  String get removeDose =>
      _localizedValues[locale.languageCode]?['removeDose'] ?? 'Remove Dose';
  String get dose => _localizedValues[locale.languageCode]?['dose'] ?? 'Dose';
  String get completedDoses =>
      _localizedValues[locale.languageCode]?['completedDoses'] ??
      'doses completed';
  String get vaccine =>
      _localizedValues[locale.languageCode]?['vaccine'] ?? 'vaccine';
  String get vaccines =>
      _localizedValues[locale.languageCode]?['vaccines'] ?? 'vaccines';
  String get noPetsFound =>
      _localizedValues[locale.languageCode]?['noPetsFound'] ?? 'No Pets Found';
  String get addPetToViewVaccination =>
      _localizedValues[locale.languageCode]?['addPetToViewVaccination'] ??
      'Add a pet to view vaccination records';
  String get selectPetToViewVaccination =>
      _localizedValues[locale.languageCode]?['selectPetToViewVaccination'] ??
      'Select a pet to view vaccination records';
  String get viewRecord =>
      _localizedValues[locale.languageCode]?['viewRecord'] ?? 'View Record';
  String get failedToLoadRewardsData =>
      _localizedValues[locale.languageCode]?['failedToLoadRewardsData'] ??
      'Failed to load rewards data';
  String get areYouSureYouWantToLogout =>
      _localizedValues[locale.languageCode]?['areYouSureYouWantToLogout'] ??
      'Are you sure you want to logout?';
  String get loggedOutSuccessfully =>
      _localizedValues[locale.languageCode]?['loggedOutSuccessfully'] ??
      'Logged out successfully';
  String get logoutFailed =>
      _localizedValues[locale.languageCode]?['logoutFailed'] ??
      'Logout failed. Please try again.';
  String get virusVaccineMissing =>
      _localizedValues[locale.languageCode]?['virusVaccineMissing'] ??
      'Virus Vaccine Missing';
  String get virusVaccineMissingMessage =>
      _localizedValues[locale.languageCode]?['virusVaccineMissingMessage'] ??
      'Your pet needs virus protection. Start the vaccine series soon to protect against diseases.';
  String get wormTreatmentMissing =>
      _localizedValues[locale.languageCode]?['wormTreatmentMissing'] ??
      'Worm Treatment Missing';
  String get wormTreatmentMissingMessage =>
      _localizedValues[locale.languageCode]?['wormTreatmentMissingMessage'] ??
      'Your pet needs deworming treatment. Only 2 doses required to prevent parasites.';
  String get insectProtectionMissing =>
      _localizedValues[locale.languageCode]?['insectProtectionMissing'] ??
      'Insect Protection Missing';
  String get insectProtectionMissingMessage =>
      _localizedValues[locale.languageCode]
          ?['insectProtectionMissingMessage'] ??
      'Your pet needs flea and tick protection. Only 1 dose required to prevent infestations.';
  String get rabiesVaccineMissing =>
      _localizedValues[locale.languageCode]?['rabiesVaccineMissing'] ??
      'Rabies Vaccine Missing';
  String get rabiesVaccineMissingMessage =>
      _localizedValues[locale.languageCode]?['rabiesVaccineMissingMessage'] ??
      'Your pet needs rabies protection. Only 1 dose required. This vaccine is critical for your pet\'s safety.';
  String get noVaccinationRecords =>
      _localizedValues[locale.languageCode]?['noVaccinationRecords'] ??
      'No Vaccination Records';
  String get addYourPetsFirstVaccine =>
      _localizedValues[locale.languageCode]?['addYourPetsFirstVaccine'] ??
      'Add your pet\'s first vaccine to get started';
  String get vaccinationRecords =>
      _localizedValues[locale.languageCode]?['vaccinationRecords'] ??
      'Vaccination Records';
  String get annualBoosters =>
      _localizedValues[locale.languageCode]?['annualBoosters'] ??
      'Annual Boosters';
  String get markAsComplete =>
      _localizedValues[locale.languageCode]?['markAsComplete'] ??
      'Mark as Complete';
  String get markComplete =>
      _localizedValues[locale.languageCode]?['markComplete'] ?? 'Mark';
  String get notYetAdministered =>
      _localizedValues[locale.languageCode]?['notYetAdministered'] ??
      'Not yet administered';
  String get doseMarkedComplete =>
      _localizedValues[locale.languageCode]?['doseMarkedComplete'] ??
      '✓ Dose marked as complete!';
  String get boosterMarkedComplete =>
      _localizedValues[locale.languageCode]?['boosterMarkedComplete'] ??
      '✓ Annual booster marked as complete!';
  String get boosterMarkedCompleteWithNextScheduled =>
      _localizedValues[locale.languageCode]?['boosterMarkedCompleteWithNextScheduled'] ??
      '✓ Booster complete! Next booster has been scheduled automatically.';
  String get viewSchedule =>
      _localizedValues[locale.languageCode]?['viewSchedule'] ??
      'View';
  String get nextDose =>
      _localizedValues[locale.languageCode]?['nextDose'] ?? 'Next dose';
  String get protectionActive =>
      _localizedValues[locale.languageCode]?['protectionActive'] ??
      'Protection active. Repeat on schedule to stay safe';
  String get protectedFromRabies =>
      _localizedValues[locale.languageCode]?['protectedFromRabies'] ??
      'Protected from rabies. Repeat yearly to stay safe';
  String get notProtectedFromFleasOrTicks =>
      _localizedValues[locale.languageCode]?['notProtectedFromFleasOrTicks'] ??
      'Not protected from fleas or ticks. Start soon';
  String get yourPetIsntProtectedFromRabies =>
      _localizedValues[locale.languageCode]
          ?['yourPetIsntProtectedFromRabies'] ??
      'Your pet isn\'t protected from rabies. Vaccinate soon';
  String get treatmentComplete =>
      _localizedValues[locale.languageCode]?['treatmentComplete'] ??
      'Treatment complete! Your pet is now protected';
  String get secondDoseRequiredForFullDeworming =>
      _localizedValues[locale.languageCode]
          ?['secondDoseRequiredForFullDeworming'] ??
      'Second dose required for full deworming';
  String get notProtectedFromWorms =>
      _localizedValues[locale.languageCode]?['notProtectedFromWorms'] ??
      'Not protected from worms. Start deworming soon';
  String get whatToDoNow =>
      _localizedValues[locale.languageCode]?['whatToDoNow'] ??
      'What to do now?';
  String get wormsWindowExpiredExplanation =>
      _localizedValues[locale.languageCode]?['wormsWindowExpiredExplanation'] ??
      'Unfortunately, the valid window for the 2nd dose has ended (Day 14-20). You must restart the vaccination series with a new 1st dose to ensure your pet is protected.';
  String get tipCancelAndRestart =>
      _localizedValues[locale.languageCode]?['tipCancelAndRestart'] ??
      '💡 Tip: Press "Cancel" and start a new vaccination series.';
  String get wormsSecondDoseExpired =>
      _localizedValues[locale.languageCode]?['wormsSecondDoseExpired'] ??
      'Unfortunately, the second dose window has passed. Your pet is not protected. We must restart the vaccination for best protection.';

  // Worms vaccine warning messages
  String get warningTooEarlyFor2ndDose =>
      _localizedValues[locale.languageCode]?['warningTooEarlyFor2ndDose'] ??
      'Warning: Too Early for 2nd Dose';
  String get warning2ndDoseWindowExpired =>
      _localizedValues[locale.languageCode]?['warning2ndDoseWindowExpired'] ??
      'Warning: 2nd Dose Window Expired';
  String get wormingVaccineProtocol =>
      _localizedValues[locale.languageCode]?['wormingVaccineProtocol'] ??
      'Worming Vaccine Protocol:';
  String get wormingVaccineInfo =>
      _localizedValues[locale.languageCode]?['wormingVaccineInfo'] ??
      'Worming Vaccine Info';
  String get firstDose =>
      _localizedValues[locale.languageCode]?['firstDose'] ??
      '1st Dose';
  String get vaccinesNeverTakenAndOverdue =>
      _localizedValues[locale.languageCode]?['vaccinesNeverTakenAndOverdue'] ??
      'Vaccines that were never taken and are now overdue';
  String get dueWithinNext30Days =>
      _localizedValues[locale.languageCode]?['dueWithinNext30Days'] ??
      'Due within the next 30 days';
  String get inProgressVaccinesNeedingNextDose =>
      _localizedValues[locale.languageCode]?['inProgressVaccinesNeedingNextDose'] ??
      'Vaccines in progress that need the next dose';
  String get notAdded =>
      _localizedValues[locale.languageCode]?['notAdded'] ?? 'Not Added';
  String get windowOpensDay14 =>
      _localizedValues[locale.languageCode]?['windowOpensDay14'] ??
      'Window Opens (Day 14)';
  String get windowClosedDay20 =>
      _localizedValues[locale.languageCode]?['windowClosedDay20'] ??
      'Window Closed (Day 20)';
  String get dosesRequired2 =>
      _localizedValues[locale.languageCode]?['dosesRequired2'] ??
      '2 doses required';
  String get secondDoseDay14to20Only =>
      _localizedValues[locale.languageCode]?['secondDoseDay14to20Only'] ??
      '2nd dose: Day 14-20 only';
  String get beforeDay14TooEarly =>
      _localizedValues[locale.languageCode]?['beforeDay14TooEarly'] ??
      'Before Day 14: Too early';
  String get afterDay20MustRestart =>
      _localizedValues[locale.languageCode]?['afterDay20MustRestart'] ??
      'After Day 20: Must restart';
  String get doses2Between14to20Days =>
      _localizedValues[locale.languageCode]?['doses2Between14to20Days'] ??
      '2 doses, 14-20 days apart';
  String get validWindowDay14to20 =>
      _localizedValues[locale.languageCode]?['validWindowDay14to20'] ??
      'Valid window: Day 14-20';
  String get afterDay20MustRestartFromBeginning =>
      _localizedValues[locale.languageCode]?['afterDay20MustRestartFromBeginning'] ??
      'After day 20: Must restart';
  String get restartVaccinationSeries =>
      _localizedValues[locale.languageCode]?['restartVaccinationSeries'] ??
      'Restart Vaccination Series';
  String get daysRemaining =>
      _localizedValues[locale.languageCode]?['daysRemaining'] ??
      'Days Remaining:';

  // Dynamic messages with parameters
  String waitMoreDaysBeforeSecondDose(int days) {
    final template = _localizedValues[locale.languageCode]?['waitMoreDaysBeforeSecondDose'] ??
        'You must wait {days} more day(s) before giving the 2nd dose. The 2nd dose must be given at least 14 days after the 1st dose.';
    return template.replaceAll('{days}', days.toString());
  }

  // Missed dose warnings (Day 35)
  String get warningMissedDose =>
      _localizedValues[locale.languageCode]?['warningMissedDose'] ??
      'Warning: Missed Dose';
  String get missed2ndDoseVirusMessage =>
      _localizedValues[locale.languageCode]?['missed2ndDoseVirusMessage'] ??
      'Unfortunately, since the second dose was missed, your pet is no longer protected. You\'ll need to restart the vaccination series.';
  String get missed3rdDoseVirusMessage =>
      _localizedValues[locale.languageCode]?['missed3rdDoseVirusMessage'] ??
      'Your pet is still protected because it received the first two doses, but please give the third as soon as possible for full protection.';
  String get missedInsectsMessage =>
      _localizedValues[locale.languageCode]?['missedInsectsMessage'] ??
      'Please administer the dose as soon as possible to protect your pet.';
  String get missedRabiesMessage =>
      _localizedValues[locale.languageCode]?['missedRabiesMessage'] ??
      'Please administer the rabies vaccine as soon as possible. This vaccine is critical for your pet\'s safety.';
  String get deadlineDay35 =>
      _localizedValues[locale.languageCode]?['deadlineDay35'] ??
      'Deadline (Day 35)';
  String get lastDoseGiven =>
      _localizedValues[locale.languageCode]?['lastDoseGiven'] ??
      'Last Dose Given';
  String get daysSinceLastDose =>
      _localizedValues[locale.languageCode]?['daysSinceLastDose'] ??
      'Days Since Last Dose:';
  String get scheduleNextDose =>
      _localizedValues[locale.languageCode]?['scheduleNextDose'] ??
      'Schedule Next Dose';

  // Delete vaccination strings
  String get deleteVaccination =>
      _localizedValues[locale.languageCode]?['deleteVaccination'] ??
      'Delete Vaccination';
  String get areYouSureDeleteVaccination =>
      _localizedValues[locale.languageCode]?['areYouSureDeleteVaccination'] ??
      'Are you sure you want to delete this vaccination series?';

  String get deleteVaccinationFeatureComingSoon =>
      _localizedValues[locale.languageCode]?['deleteVaccinationFeatureComingSoon'] ??
      'Delete vaccination feature coming soon. API will be integrated later.';
  String get vaccinationDeleted =>
      _localizedValues[locale.languageCode]?['vaccinationDeleted'] ??
      'Vaccination deleted successfully';
  String get cannotDeleteVaccination =>
      _localizedValues[locale.languageCode]?['cannotDeleteVaccination'] ??
      'Cannot Delete Vaccination';
  String get cannotDeleteCompletedVaccination =>
      _localizedValues[locale.languageCode]?['cannotDeleteCompletedVaccination'] ??
      'Completed vaccinations cannot be deleted. They are part of your pet\'s permanent medical record.';
  String get completedVaccinationsAreProtected =>
      _localizedValues[locale.languageCode]?['completedVaccinationsAreProtected'] ??
      'Completed vaccinations are protected and kept for medical history.';
  String get understood =>
      _localizedValues[locale.languageCode]?['understood'] ??
      'Understood';
  String get nextAnnualBoosterWillBeScheduled =>
      _localizedValues[locale.languageCode]?['nextAnnualBoosterWillBeScheduled'] ??
      'Next annual booster will be automatically scheduled for 1 year from this date.';

  String get fullyProtected =>
      _localizedValues[locale.languageCode]?['fullyProtected'] ??
      'Fully protected. Follow booster schedule to stay safe';
  String get protectedThirdDoseGivesStrongestImmunity =>
      _localizedValues[locale.languageCode]
          ?['protectedThirdDoseGivesStrongestImmunity'] ??
      'Protected. Third dose gives strongest immunity';
  String get protectionIncomplete =>
      _localizedValues[locale.languageCode]?['protectionIncomplete'] ??
      'Protection incomplete. Second dose needed to activate immunity';
  String get notProtectedStartVirusVaccineSoon =>
      _localizedValues[locale.languageCode]
          ?['notProtectedStartVirusVaccineSoon'] ??
      'Not protected. Start the virus vaccine soon';
  String get dismiss =>
      _localizedValues[locale.languageCode]?['dismiss'] ?? 'Dismiss';
  String get errorLoadingVaccinationRecord =>
      _localizedValues[locale.languageCode]?['errorLoadingVaccinationRecord'] ??
      'Error Loading Vaccination Record';
  String get noVaccinationData =>
      _localizedValues[locale.languageCode]?['noVaccinationData'] ??
      'No vaccination data';
  String get overdue =>
      _localizedValues[locale.languageCode]?['overdue'] ?? 'Overdue';
  String get markDoseComplete =>
      _localizedValues[locale.languageCode]?['markDoseComplete'] ??
      'Mark Dose Complete';
  String get selectPet =>
      _localizedValues[locale.languageCode]?['selectPet'] ?? 'Select Pet';
  String get addVaccinationTitle =>
      _localizedValues[locale.languageCode]?['addVaccinationTitle'] ??
      'Add Vaccination';
  String get active =>
      _localizedValues[locale.languageCode]?['active'] ?? 'ACTIVE';
  String get completedStatus =>
      _localizedValues[locale.languageCode]?['completedStatus'] ?? 'COMPLETED';
  String get dosesCompleted =>
      _localizedValues[locale.languageCode]?['dosesCompleted'] ??
      'doses completed';
  String get wormTreatment =>
      _localizedValues[locale.languageCode]?['wormTreatment'] ??
      'Worm Treatment';
  String get insectProtection =>
      _localizedValues[locale.languageCode]?['insectProtection'] ??
      'Insect Protection';
  String get rabiesVaccine =>
      _localizedValues[locale.languageCode]?['rabiesVaccine'] ??
      'Rabies Vaccine';
  String get markBoosterCompleteFeatureComingSoon =>
      _localizedValues[locale.languageCode]
          ?['markBoosterCompleteFeatureComingSoon'] ??
      'Mark booster complete feature coming soon';
  String get addingPetsOptional =>
      _localizedValues[locale.languageCode]?['addingPetsOptional'] ??
      'Adding pets is optional';
  String get selectPetsForVisit =>
      _localizedValues[locale.languageCode]?['selectPetsForVisit'] ??
      'Select Pets for Visit';
  String get failedToLoadPets =>
      _localizedValues[locale.languageCode]?['failedToLoadPets'] ??
      'Failed to load pets';
  String get noPetsYet =>
      _localizedValues[locale.languageCode]?['noPetsYet'] ??
      'You don\'t have any pets yet';
  String get addPet =>
      _localizedValues[locale.languageCode]?['addPet'] ?? 'Add a Pet';
  String get confirmBooking =>
      _localizedValues[locale.languageCode]?['confirmBooking'] ??
      'Confirm Booking';
  String get bookingConfirmed =>
      _localizedValues[locale.languageCode]?['bookingConfirmed'] ??
      'Booking Confirmed!';
  String get reference =>
      _localizedValues[locale.languageCode]?['reference'] ?? 'Reference';
  String get pets => _localizedValues[locale.languageCode]?['pets'] ?? 'Pets';
  String get petsForThisVisit =>
      _localizedValues[locale.languageCode]?['petsForThisVisit'] ??
      'Pets for this visit:';
  String get showQRCodeAtVet =>
      _localizedValues[locale.languageCode]?['showQRCodeAtVet'] ??
      'Show this QR code at the vet';
  String get qrCodeError =>
      _localizedValues[locale.languageCode]?['qrCodeError'] ??
      'Something went wrong!';
  String get pleaseSelectTimeSlot =>
      _localizedValues[locale.languageCode]?['pleaseSelectTimeSlot'] ??
      'Please select a time slot';
  String get bookingFailed =>
      _localizedValues[locale.languageCode]?['bookingFailed'] ??
      'Booking failed. Please try again.';
  // Appointment date filter options
  String get last3Months =>
      _localizedValues[locale.languageCode]?['last3Months'] ?? 'Last 3 Months';
  String get byYear =>
      _localizedValues[locale.languageCode]?['byYear'] ?? 'By Year';
  String get selectYear =>
      _localizedValues[locale.languageCode]?['selectYear'] ?? 'Select Year';
  String get timeFilter =>
      _localizedValues[locale.languageCode]?['timeFilter'] ?? 'Time Filter';

  // Add these getters to your AppLocalizations class
  String get favorite =>
      _localizedValues[locale.languageCode]?['favorite'] ?? 'Favorite';
  String get addedToFavorites =>
      _localizedValues[locale.languageCode]?['addedToFavorites'] ??
      'Added to favorites';
  String get cannotOpenMaps =>
      _localizedValues[locale.languageCode]?['cannotOpenMaps'] ??
      'Cannot open maps. Please check if Google Maps is installed.';
  // Add these getters to your AppLocalizations class
  String get viewLocation =>
      _localizedValues[locale.languageCode]?['viewLocation'] ?? 'View Location';
  String get chooseMapApp =>
      _localizedValues[locale.languageCode]?['chooseMapApp'] ??
      'Choose how to view the location';
  String get coordinates =>
      _localizedValues[locale.languageCode]?['coordinates'] ?? 'Coordinates';
  String get copyLocation =>
      _localizedValues[locale.languageCode]?['copyLocation'] ?? 'Copy Location';
  String get openInBrowser =>
      _localizedValues[locale.languageCode]?['openInBrowser'] ??
      'Open in Browser';
  String get locationCopiedToClipboard =>
      _localizedValues[locale.languageCode]?['locationCopiedToClipboard'] ??
      'Location copied to clipboard';
// 3D Viewer Screen translations
  String get head => _localizedValues[locale.languageCode]?['head'] ?? 'Head';
  String get legs => _localizedValues[locale.languageCode]?['legs'] ?? 'Legs';
  String get skinAndCoat =>
      _localizedValues[locale.languageCode]?['skinAndCoat'] ?? 'Skin & Coat';
  String get pelvis =>
      _localizedValues[locale.languageCode]?['pelvis'] ??
      'Urinary & Reproductive';
  String get buttocks =>
      _localizedValues[locale.languageCode]?['buttocks'] ?? 'Anus & Pooping';
  String get selected =>
      _localizedValues[locale.languageCode]?['selected'] ?? 'Selected';
  String get howToUse =>
      _localizedValues[locale.languageCode]?['howToUse'] ?? 'How to Use';
  String get step => _localizedValues[locale.languageCode]?['step'] ?? 'Step';
  String get rotate =>
      _localizedValues[locale.languageCode]?['rotate'] ?? 'Rotate';
  String get zoom => _localizedValues[locale.languageCode]?['zoom'] ?? 'Zoom';
  String get selectText =>
      _localizedValues[locale.languageCode]?['selectText'] ?? 'Select';
  String get symptoms =>
      _localizedValues[locale.languageCode]?['symptoms'] ?? 'Symptoms';
  String get searchSymptoms =>
      _localizedValues[locale.languageCode]?['searchSymptoms'] ?? 'Search symptoms...';
  String get viewSelected =>
      _localizedValues[locale.languageCode]?['viewSelected'] ?? 'View Selected';
  String get findVet =>
      _localizedValues[locale.languageCode]?['findVet'] ?? 'Find Vet';
  String get rotateInstructions =>
      _localizedValues[locale.languageCode]?['rotateInstructions'] ??
      'Touch and drag to rotate the model';
  String get rotate90Instructions =>
      _localizedValues[locale.languageCode]?['rotate90Instructions'] ??
      'Tap the rotate button to turn the model 90 degrees';
  String get zoomInstructions =>
      _localizedValues[locale.languageCode]?['zoomInstructions'] ??
      'Pinch to zoom in and out';
  String get selectInstructions =>
      _localizedValues[locale.languageCode]?['selectInstructions'] ??
      'Tap on a body part to select it';
  String get symptomsInstructions =>
      _localizedValues[locale.languageCode]?['symptomsInstructions'] ??
      'Choose symptoms for the selected body part';
  String get viewSelectedInstructions =>
      _localizedValues[locale.languageCode]?['viewSelectedInstructions'] ??
      'Tap the symptoms icon in the top bar to see your selections';
  String get findVetInstructions =>
      _localizedValues[locale.languageCode]?['findVetInstructions'] ??
      'After selecting symptoms, tap "Find Vet"';
  String get gotIt =>
      _localizedValues[locale.languageCode]?['gotIt'] ?? 'Got it';
  String get swipeToRotate =>
      _localizedValues[locale.languageCode]?['swipeToRotate'] ??
      'Swipe to Rotate';
  String get tapBodyPartToExplore =>
      _localizedValues[locale.languageCode]?['tapBodyPartToExplore'] ??
      'Tap on body parts to explore symptoms';
  String get noDataAvailable =>
      _localizedValues[locale.languageCode]?['noDataAvailable'] ??
      'No Data Available';
  String get noSymptomDataFound =>
      _localizedValues[locale.languageCode]?['noSymptomDataFound'] ??
      'No symptom data found for';
  String get noSymptomsFound =>
      _localizedValues[locale.languageCode]?['noSymptomsFound'] ??
      'No symptoms found for';
  String get symptomCategories =>
      _localizedValues[locale.languageCode]?['symptomCategories'] ??
      'Symptom Categories';
  String get replaceSelectedSymptom =>
      _localizedValues[locale.languageCode]?['replaceSelectedSymptom'] ??
      'Replace Selected Symptom';
  String get selectThisSymptom =>
      _localizedValues[locale.languageCode]?['selectThisSymptom'] ??
      'Select This Symptom';
  String get findEmergencyVet =>
      _localizedValues[locale.languageCode]?['findEmergencyVet'] ??
      'Find Emergency Vet';
  String get whatWouldYouLikeToDo =>
      _localizedValues[locale.languageCode]?['whatWouldYouLikeToDo'] ??
      'What would you like to do?';
  String get youHaveSelected =>
      _localizedValues[locale.languageCode]?['youHaveSelected'] ??
      'You have selected';
  String get findVetNearby =>
      _localizedValues[locale.languageCode]?['findVetNearby'] ??
      'Find a Vet Nearby';
  String get seeExamplesAndPictures =>
      _localizedValues[locale.languageCode]?['seeExamplesAndPictures'] ??
      'See Examples & Pictures';
  String get examples =>
      _localizedValues[locale.languageCode]?['examples'] ?? 'Examples';
  String get visualExamples =>
      _localizedValues[locale.languageCode]?['visualExamples'] ??
      'Visual Examples';
  String get importantNote =>
      _localizedValues[locale.languageCode]?['importantNote'] ??
      'Important Note';
  String get disclaimerText =>
      _localizedValues[locale.languageCode]?['disclaimerText'] ??
      'This information is for educational purposes only. Always consult with a qualified veterinarian for proper diagnosis and treatment.';
  String get exampleImagesDisclaimer =>
      _localizedValues[locale.languageCode]?['exampleImagesDisclaimer'] ??
      'These are example images for reference only. Every pet is different, and symptoms may vary in severity and appearance. If you\'re unsure or concerned, please consult with a veterinarian.';
  String get back => _localizedValues[locale.languageCode]?['back'] ?? 'Back';
  String get imageNotAvailable =>
      _localizedValues[locale.languageCode]?['imageNotAvailable'] ??
      'Image not available';
  // Pet Symptom Categories
  String get eyeSymptoms =>
      _localizedValues[locale.languageCode]?['eyeSymptoms'] ?? 'Eye Symptoms';
  String get earSymptoms =>
      _localizedValues[locale.languageCode]?['earSymptoms'] ?? 'Ear Symptoms';
  String get mouthTeethSymptoms =>
      _localizedValues[locale.languageCode]?['mouthTeethSymptoms'] ??
      'Mouth & Teeth Symptoms';
  String get skinCoatSymptoms =>
      _localizedValues[locale.languageCode]?['skinCoatSymptoms'] ??
      'Skin & Coat Symptoms';
  String get movementLimbsIssues =>
      _localizedValues[locale.languageCode]?['movementLimbsIssues'] ??
      'Movement & Limbs Issues';
  String get anusPoopingIssues =>
      _localizedValues[locale.languageCode]?['anusPoopingIssues'] ??
      'Anus & Pooping Issues';
  String get maleGenitalProblems =>
      _localizedValues[locale.languageCode]?['maleGenitalProblems'] ??
      'Male Genital Problems';
  String get femaleGenitalProblems =>
      _localizedValues[locale.languageCode]?['femaleGenitalProblems'] ??
      'Female Genital Problems';
  String get urinationProblems =>
      _localizedValues[locale.languageCode]?['urinationProblems'] ??
      'Urination Problems';
  String get neurologicalIssues =>
      _localizedValues[locale.languageCode]?['neurologicalIssues'] ??
      'Neurological Issues';
  String get behavioralIssues =>
      _localizedValues[locale.languageCode]?['behavioralIssues'] ??
      'Behavioral Issues';
  String get generalIssues =>
      _localizedValues[locale.languageCode]?['generalIssues'] ??
      'General Issues';
  String get breathingProblems =>
      _localizedValues[locale.languageCode]?['breathingProblems'] ??
      'Breathing Problems';

// Eye Symptoms
  String get eyeRedness =>
      _localizedValues[locale.languageCode]?['eyeRedness'] ?? 'Eye Redness';
  String get eyeRednessDescription =>
      _localizedValues[locale.languageCode]?['eyeRednessDescription'] ??
      'Noticed your pet\'s eye looking red? It could be something small like dust or something serious like an infection.';

  String get eyeDischarge =>
      _localizedValues[locale.languageCode]?['eyeDischarge'] ??
      'Eye Discharge (Goopy Stuff)';
  String get eyeDischargeDescription =>
      _localizedValues[locale.languageCode]?['eyeDischargeDescription'] ??
      'A little eye goop can be normal, but if it\'s thick, yellow, or green, it might mean an infection.';

  String get cloudyEye =>
      _localizedValues[locale.languageCode]?['cloudyEye'] ??
      'Cloudy Eye (Looks Foggy or Bluish)';
  String get cloudyEyeDescription =>
      _localizedValues[locale.languageCode]?['cloudyEyeDescription'] ??
      'If your pet\'s eye looks cloudy or milky, it could be a normal age change or something serious.';

  String get wateryEyes =>
      _localizedValues[locale.languageCode]?['wateryEyes'] ??
      'Watery Eyes (Excessive Tearing)';
  String get wateryEyesDescription =>
      _localizedValues[locale.languageCode]?['wateryEyesDescription'] ??
      'Some tearing is normal, but too much can mean an issue.';

  String get thirdEyelidShowing =>
      _localizedValues[locale.languageCode]?['thirdEyelidShowing'] ??
      'Something White or Pink in the Corner of the Eye';
  String get thirdEyelidShowingDescription =>
      _localizedValues[locale.languageCode]?['thirdEyelidShowingDescription'] ??
      'Is there a white or pink piece of tissue covering part of your pet\'s eye, or sticking out from the corner? That\'s the third eyelid.';

  String get squintingEye =>
      _localizedValues[locale.languageCode]?['squintingEye'] ??
      'Squinting or Keeping Eye Closed';
  String get squintingEyeDescription =>
      _localizedValues[locale.languageCode]?['squintingEyeDescription'] ??
      'If your pet keeps one eye closed or blinks a lot, they might be in pain.';

  String get eyeSwelling =>
      _localizedValues[locale.languageCode]?['eyeSwelling'] ??
      'Swelling Around the Eye';
  String get eyeSwellingDescription =>
      _localizedValues[locale.languageCode]?['eyeSwellingDescription'] ??
      'If your pet\'s eye looks puffy or swollen, something is irritating it.';

  String get wormsInEye =>
      _localizedValues[locale.languageCode]?['wormsInEye'] ??
      'Worms in the Eye';
  String get wormsInEyeDescription =>
      _localizedValues[locale.languageCode]?['wormsInEyeDescription'] ??
      'Seeing something moving in your pet\'s eye? It might be a worm — and it needs quick attention.';

// Ear Symptoms
  String get itchyEars =>
      _localizedValues[locale.languageCode]?['itchyEars'] ??
      'Itchy Ears (Scratching or Head Shaking)';
  String get itchyEarsDescription =>
      _localizedValues[locale.languageCode]?['itchyEarsDescription'] ??
      'If your pet is shaking their head like a mini rockstar or scratching their ears a lot, something is bugging them!';

  String get blackStuffInEar =>
      _localizedValues[locale.languageCode]?['blackStuffInEar'] ??
      'Black Stuff in the Ear (Dark Wax or Debris)';
  String get blackStuffInEarDescription =>
      _localizedValues[locale.languageCode]?['blackStuffInEarDescription'] ??
      'Noticed dark gunk in your pet\'s ears? It could be harmless wax or a sign of mites or infection!';

  String get redSwollenEar =>
      _localizedValues[locale.languageCode]?['redSwollenEar'] ??
      'Red or Swollen Ear';
  String get redSwollenEarDescription =>
      _localizedValues[locale.languageCode]?['redSwollenEarDescription'] ??
      'Is your pet\'s ear red, puffy, or warm to the touch? It could be an infection, allergy, or swelling from too much head shaking.';

  String get earSmell =>
      _localizedValues[locale.languageCode]?['earSmell'] ??
      'Bad Smell from the Ear';
  String get earSmellDescription =>
      _localizedValues[locale.languageCode]?['earSmellDescription'] ??
      'If your pet\'s ears smell like stinky cheese or moldy socks, it\'s usually an infection.';

  String get earDischarge =>
      _localizedValues[locale.languageCode]?['earDischarge'] ??
      'Ear Discharge (Pus or Liquid Coming Out)';
  String get earDischargeDescription =>
      _localizedValues[locale.languageCode]?['earDischargeDescription'] ??
      'If there\'s liquid or pus coming from the ear, it\'s usually an infection or something stuck inside.';

  String get headTilt =>
      _localizedValues[locale.languageCode]?['headTilt'] ??
      'Tilting Head to One Side';
  String get headTiltDescription =>
      _localizedValues[locale.languageCode]?['headTiltDescription'] ??
      'Is your pet holding their head to one side, like they\'re trying to listen or think? It could be a sign of an ear problem or balance issue.';

  String get hearingLoss =>
      _localizedValues[locale.languageCode]?['hearingLoss'] ??
      'Loss of Hearing or Not Responding to Sounds';
  String get hearingLossDescription =>
      _localizedValues[locale.languageCode]?['hearingLossDescription'] ??
      'If your pet doesn\'t react to noises like they used to, their hearing might be affected.';

// Mouth & Teeth Symptoms
  String get badBreath =>
      _localizedValues[locale.languageCode]?['badBreath'] ??
      'Bad Breath (Smelly Mouth)';
  String get badBreathDescription =>
      _localizedValues[locale.languageCode]?['badBreathDescription'] ??
      'If your pet\'s kisses smell like a garbage can, something\'s up!';

  String get excessiveDrooling =>
      _localizedValues[locale.languageCode]?['excessiveDrooling'] ??
      'Excessive Drooling';
  String get excessiveDroolingDescription =>
      _localizedValues[locale.languageCode]?['excessiveDroolingDescription'] ??
      'Some drooling is normal, but if your pet is suddenly dripping like a leaky faucet, it\'s a sign of a problem!';

  String get redSwollenGums =>
      _localizedValues[locale.languageCode]?['redSwollenGums'] ??
      'Red, Swollen Gums';
  String get redSwollenGumsDescription =>
      _localizedValues[locale.languageCode]?['redSwollenGumsDescription'] ??
      'Healthy gums should be pink, not red or puffy!';

  String get looseMissingTeeth =>
      _localizedValues[locale.languageCode]?['looseMissingTeeth'] ??
      'Loose or Missing Teeth';
  String get looseMissingTeethDescription =>
      _localizedValues[locale.languageCode]?['looseMissingTeethDescription'] ??
      'Puppies lose baby teeth, but adults shouldn\'t lose teeth!';

  String get troubleEating =>
      _localizedValues[locale.languageCode]?['troubleEating'] ??
      'Trouble Eating or Dropping Food';
  String get troubleEatingDescription =>
      _localizedValues[locale.languageCode]?['troubleEatingDescription'] ??
      'If your pet loves food but suddenly struggles to eat, check their mouth!';

  String get mouthBleeding =>
      _localizedValues[locale.languageCode]?['mouthBleeding'] ??
      'Bleeding from the Mouth';
  String get mouthBleedingDescription =>
      _localizedValues[locale.languageCode]?['mouthBleedingDescription'] ??
      'Seeing blood in your pet\'s mouth? It could be from the gums, teeth, or tongue — and it\'s important to find out why.';

  String get tongueSwelling =>
      _localizedValues[locale.languageCode]?['tongueSwelling'] ??
      'Tongue or Lip Swelling';
  String get tongueSwellingDescription =>
      _localizedValues[locale.languageCode]?['tongueSwellingDescription'] ??
      'A swollen tongue or lips can mean an allergic reaction or something stuck!';

  String get paleGums =>
      _localizedValues[locale.languageCode]?['paleGums'] ??
      'White or Pale Gums';
  String get paleGumsDescription =>
      _localizedValues[locale.languageCode]?['paleGumsDescription'] ??
      'Gums should be pink, not white or pale. This could mean serious illness!';

  String get lockedJaw =>
      _localizedValues[locale.languageCode]?['lockedJaw'] ??
      'Locked Jaw (Mouth Won\'t Open or Close)';
  String get lockedJawDescription =>
      _localizedValues[locale.languageCode]?['lockedJawDescription'] ??
      'If your pet can\'t open or close their mouth properly, something is seriously wrong!';

  String get oralUlcers =>
      _localizedValues[locale.languageCode]?['oralUlcers'] ??
      'Oral Ulcers (Sores in the Mouth)';
  String get oralUlcersDescription =>
      _localizedValues[locale.languageCode]?['oralUlcersDescription'] ??
      'Painful sores in the mouth can make eating difficult and may signal an infection!';

// Common symptom terms
  String get possibleCauses =>
      _localizedValues[locale.languageCode]?['possibleCauses'] ??
      'Possible Causes';
  String get whatToDo =>
      _localizedValues[locale.languageCode]?['whatToDo'] ?? 'What to Do';
  String get vetVisitASAP =>
      _localizedValues[locale.languageCode]?['vetVisitASAP'] ??
      'Vet visit ASAP';
  String get monitor =>
      _localizedValues[locale.languageCode]?['monitor'] ?? 'Monitor';
  String get rinseWithSaline =>
      _localizedValues[locale.languageCode]?['rinseWithSaline'] ??
      'Rinse with saline';
  String get cleanGently =>
      _localizedValues[locale.languageCode]?['cleanGently'] ?? 'Clean gently';
  String get doNotTouch =>
      _localizedValues[locale.languageCode]?['doNotTouch'] ?? 'Do not touch';
  String get keepCalm =>
      _localizedValues[locale.languageCode]?['keepCalm'] ?? 'Keep calm';

  String get selectPetType =>
      _localizedValues[locale.languageCode]?['selectPetType'] ??
      'Select Pet Type';
  String get choosePetModelToViewAnatomy =>
      _localizedValues[locale.languageCode]?['choosePetModelToViewAnatomy'] ??
      'Choose a pet model to view anatomy';
  String get dog => _localizedValues[locale.languageCode]?['dog'] ?? 'Dog';
  String get cat => _localizedValues[locale.languageCode]?['cat'] ?? 'Cat';
  String get dogModel =>
      _localizedValues[locale.languageCode]?['dogModel'] ?? 'Dog Model';
  String get catModel =>
      _localizedValues[locale.languageCode]?['catModel'] ?? 'Cat Model';
  String get viewDogAnatomy =>
      _localizedValues[locale.languageCode]?['viewDogAnatomy'] ??
      'View Dog Anatomy';
  String get viewCatAnatomy =>
      _localizedValues[locale.languageCode]?['viewCatAnatomy'] ??
      'View Cat Anatomy';
  String get openModel =>
      _localizedValues[locale.languageCode]?['openModel'] ?? 'Open Model';
  String get use3DModelToIdentifySymptoms =>
      _localizedValues[locale.languageCode]?['use3DModelToIdentifySymptoms'] ??
      'Use the 3D model to identify symptoms and explore pet anatomy. Tap on different body parts to learn more.';
  String get locationAccessDisabled =>
      _localizedValues[locale.languageCode]?['locationAccessDisabled'] ??
      'Location Access Disabled';
  String get enableLocationToFindVets =>
      _localizedValues[locale.languageCode]?['enableLocationToFindVets'] ??
      'Enable location to find nearby Vets';

  String get loadingVets =>
      _localizedValues[locale.languageCode]?['loadingVets'] ??
      'Loading Vets...';
  String get noVetsNearby =>
      _localizedValues[locale.languageCode]?['noVetsNearby'] ??
      'No Vets found nearby';
  String get tryEnablingLocation =>
      _localizedValues[locale.languageCode]?['tryEnablingLocation'] ??
      'Try enabling location or check back later';

  String get guestBrowsingMessage =>
      _localizedValues[locale.languageCode]?['guestBrowsingMessage'] ??
      'You\'re browsing as a guest. Some features require login.';
  String get login =>
      _localizedValues[locale.languageCode]?['login'] ?? 'Login';

  // Method for dynamic anatomy text
  String viewPetAnatomy(String petType) {
    return _localizedValues[locale.languageCode]?['viewPetAnatomy']
            ?.replaceAll('{petType}', petType) ??
        'View $petType Anatomy';
  }

// Method for dynamic text
  String availableSlots(int count) {
    return _localizedValues[locale.languageCode]?['availableSlots']
            ?.replaceAll('{count}', count.toString()) ??
        '($count available)';
  }

  // Methods for dynamic text
  String availableSlotsFor(String date) {
    return _localizedValues[locale.languageCode]?['availableSlotsFor']
            ?.replaceAll('{date}', date) ??
        'Available slots for $date';
  }

  String confirmPets(int count) {
    return _localizedValues[locale.languageCode]?['confirmPets']
            ?.replaceAll('{count}', count.toString()) ??
        'Confirm ($count pets)';
  }

  // Method for dynamic distance text
  String distanceKm(int distance) {
    return _localizedValues[locale.languageCode]?['distanceKm']
            ?.replaceAll('{distance}', distance.toString()) ??
        '${distance}km';
  }

  // Methods for dynamic text
  String withinDistance(int distance) {
    return _localizedValues[locale.languageCode]?['withinDistance']
            ?.replaceAll('{distance}', distance.toString()) ??
        'Within ${distance}km';
  }

  String vetsFound(int count) {
    return _localizedValues[locale.languageCode]?['vetsFound']
            ?.replaceAll('{count}', count.toString()) ??
        '$count found';
  }

  String ratingWithReviews(double rating, int reviews) {
    return _localizedValues[locale.languageCode]?['ratingWithReviews']
            ?.replaceAll('{rating}', rating.toString())
            .replaceAll('{reviews}', reviews.toString()) ??
        '$rating ($reviews)';
  }

  String yearsExperience(int years) {
    return _localizedValues[locale.languageCode]?['yearsExperience']
            ?.replaceAll('{years}', years.toString()) ??
        '$years years';
  }

  String citiesCount(int count) {
    return _localizedValues[locale.languageCode]?['citiesCount']
            ?.replaceAll('{count}', count.toString()) ??
        '$count cities';
  }

  String allCitiesIn(String governorate) {
    return _localizedValues[locale.languageCode]?['allCitiesIn']
            ?.replaceAll('{governorate}', governorate) ??
        'All $governorate';
  }

  String callingNumber(String phone) {
    return _localizedValues[locale.languageCode]?['callingNumber']
            ?.replaceAll('{phone}', phone) ??
        'Calling $phone';
  }

// Method for dynamic text
  String confirmCancelAppointment(String vetName) {
    return _localizedValues[locale.languageCode]?['confirmCancelAppointment']
            ?.replaceAll('{vetName}', vetName) ??
        'Are you sure you want to cancel your appointment with $vetName?';
  }

  // Add these getters to your AppLocalizations class
  String get rescheduleAppointment =>
      _localizedValues[locale.languageCode]?['rescheduleAppointment'] ??
      'Reschedule Appointment';

  // Methods for dynamic text
  String confirmCancelAppointmentWithDoctor(String vetName) {
    return _localizedValues[locale.languageCode]
                ?['confirmCancelAppointmentWithDoctor']
            ?.replaceAll('{vetName}', vetName) ??
        'Are you sure you want to cancel your appointment with Dr. $vetName?';
  }

  String rescheduleAppointmentMessage(String vetName) {
    return _localizedValues[locale.languageCode]
                ?['rescheduleAppointmentMessage']
            ?.replaceAll('{vetName}', vetName) ??
        'Would you like to reschedule your appointment with Dr. $vetName?';
  }

  // Pet form field translations
  String get petGender =>
      _localizedValues[locale.languageCode]?['petGender'] ?? 'Gender';
  String get male => _localizedValues[locale.languageCode]?['male'] ?? 'Male';
  String get female =>
      _localizedValues[locale.languageCode]?['female'] ?? 'Female';
  String get petWeight =>
      _localizedValues[locale.languageCode]?['petWeight'] ?? 'Weight (kg)';
  String get enterPetWeight =>
      _localizedValues[locale.languageCode]?['enterPetWeight'] ??
      'Enter pet weight';
  String get petAllergies =>
      _localizedValues[locale.languageCode]?['petAllergies'] ?? 'Allergies';
  String get addAllergy =>
      _localizedValues[locale.languageCode]?['addAllergy'] ??
      'Add allergy (e.g., chicken, dairy)';
  String get spayedNeutered =>
      _localizedValues[locale.languageCode]?['spayedNeutered'] ??
      'Spayed/Neutered';
  String get petNotes =>
      _localizedValues[locale.languageCode]?['petNotes'] ?? 'Notes';
  String get additionalPetInfo =>
      _localizedValues[locale.languageCode]?['additionalPetInfo'] ??
      'Any additional information about your pet';

  // ── Store feature strings ────────────────────────────────────────────────
  String get aleefyStore =>
      _localizedValues[locale.languageCode]?['aleefyStore'] ?? 'Aleefy Store';
  String get noProductsFound =>
      _localizedValues[locale.languageCode]?['noProductsFound'] ?? 'No products found';
  String get failedToLoadProducts =>
      _localizedValues[locale.languageCode]?['failedToLoadProducts'] ?? 'Failed to load products';
  String get myCart =>
      _localizedValues[locale.languageCode]?['myCart'] ?? 'My Cart';
  String get cartEmpty =>
      _localizedValues[locale.languageCode]?['cartEmpty'] ?? 'Cart empty ...';
  String get cartEmptyMessage =>
      _localizedValues[locale.languageCode]?['cartEmptyMessage'] ?? 'Add products from the store to get started';
  String get browseStore =>
      _localizedValues[locale.languageCode]?['browseStore'] ?? 'Browse Store';
  String get delivery =>
      _localizedValues[locale.languageCode]?['delivery'] ?? 'Delivery';
  String get selectDeliveryMethod =>
      _localizedValues[locale.languageCode]?['selectDeliveryMethod'] ?? 'Select delivery method';
  String get shipping =>
      _localizedValues[locale.languageCode]?['shipping'] ?? 'Shipping';
  String get deliveredToAddress =>
      _localizedValues[locale.languageCode]?['deliveredToAddress'] ?? 'Delivered to your address';
  String get pickUp =>
      _localizedValues[locale.languageCode]?['pickUp'] ?? 'Pick Up';
  String get pickUpFromStore =>
      _localizedValues[locale.languageCode]?['pickUpFromStore'] ?? 'Pick up your order from the store';
  String get noDeliveryAddress =>
      _localizedValues[locale.languageCode]?['noDeliveryAddress'] ?? 'No delivery address yet';
  String get addFirstAddressMessage =>
      _localizedValues[locale.languageCode]?['addFirstAddressMessage'] ?? "Add your first address so we know where to deliver your pet's goodies";
  String get addAddress =>
      _localizedValues[locale.languageCode]?['addAddress'] ?? 'Add Address';
  String get addAnotherAddress =>
      _localizedValues[locale.languageCode]?['addAnotherAddress'] ?? 'Add another address?';
  String get saveAddress =>
      _localizedValues[locale.languageCode]?['saveAddress'] ?? 'Save Address';
  String get country =>
      _localizedValues[locale.languageCode]?['country'] ?? 'Country';
  String get city =>
      _localizedValues[locale.languageCode]?['city'] ?? 'City';
  String get addressLine1 =>
      _localizedValues[locale.languageCode]?['addressLine1'] ?? 'Address Line 1';
  String get addressLine2Optional =>
      _localizedValues[locale.languageCode]?['addressLine2Optional'] ?? 'Address Line 2 (optional)';
  String get postalCodeOptional =>
      _localizedValues[locale.languageCode]?['postalCodeOptional'] ?? 'Postal Code (optional)';
  String get fieldRequired =>
      _localizedValues[locale.languageCode]?['fieldRequired'] ?? 'This field is required';
  String get scheduleOrder =>
      _localizedValues[locale.languageCode]?['scheduleOrder'] ?? 'Schedule Order';
  String get whenDelivered =>
      _localizedValues[locale.languageCode]?['whenDelivered'] ?? 'When would you like your order delivered?';
  String get schedule =>
      _localizedValues[locale.languageCode]?['schedule'] ?? 'Schedule';
  String get availableHours =>
      _localizedValues[locale.languageCode]?['availableHours'] ?? 'Available Hours';
  String get availableDate =>
      _localizedValues[locale.languageCode]?['availableDate'] ?? 'Available Date';
  String get noSlotsToday =>
      _localizedValues[locale.languageCode]?['noSlotsToday'] ?? 'No slots available for today.';
  String get checkout =>
      _localizedValues[locale.languageCode]?['checkout'] ?? 'Checkout';
  String get deliverTo =>
      _localizedValues[locale.languageCode]?['deliverTo'] ?? 'Deliver to';
  String get deliveryTime =>
      _localizedValues[locale.languageCode]?['deliveryTime'] ?? 'Delivery time';
  String get cashOnDelivery =>
      _localizedValues[locale.languageCode]?['cashOnDelivery'] ?? 'Cash On Delivery';
  String get vodafoneCash =>
      _localizedValues[locale.languageCode]?['vodafoneCash'] ?? 'Vodafone Cash';
  String get instaPay =>
      _localizedValues[locale.languageCode]?['instaPay'] ?? 'InstaPay';
  String get subtotal =>
      _localizedValues[locale.languageCode]?['subtotal'] ?? 'Subtotal';
  String get shippingFee =>
      _localizedValues[locale.languageCode]?['shippingFee'] ?? 'Shipping Fee';
  String get totalAmount =>
      _localizedValues[locale.languageCode]?['totalAmount'] ?? 'Total Amount';
  String get inclusiveOfVat =>
      _localizedValues[locale.languageCode]?['inclusiveOfVat'] ?? 'Inclusive Of VAT';
  String get promoCodeHint =>
      _localizedValues[locale.languageCode]?['promoCodeHint'] ?? 'Do you have a promo code?';
  String get orderNotes =>
      _localizedValues[locale.languageCode]?['orderNotes'] ?? 'Order Notes';
  String get payNow =>
      _localizedValues[locale.languageCode]?['payNow'] ?? 'Pay Now';
  String get orderPlaced =>
      _localizedValues[locale.languageCode]?['orderPlaced'] ?? 'Order Placed!';
  String get pricesChanged =>
      _localizedValues[locale.languageCode]?['pricesChanged'] ?? 'Some prices changed since you added items to cart.';
  String get uploadPaymentProof =>
      _localizedValues[locale.languageCode]?['uploadPaymentProof'] ?? 'Upload Payment Proof';
  String get trackOrder =>
      _localizedValues[locale.languageCode]?['trackOrder'] ?? 'Track Order';
  String get backToHome =>
      _localizedValues[locale.languageCode]?['backToHome'] ?? 'Back to Home';
  String get myOrders =>
      _localizedValues[locale.languageCode]?['myOrders'] ?? 'My Orders';
  String get noOrdersYet =>
      _localizedValues[locale.languageCode]?['noOrdersYet'] ?? 'No orders yet';
  String get orderDetail =>
      _localizedValues[locale.languageCode]?['orderDetail'] ?? 'Order Detail';
  String get shippingAddress =>
      _localizedValues[locale.languageCode]?['shippingAddress'] ?? 'Shipping Address';
  String get track =>
      _localizedValues[locale.languageCode]?['track'] ?? 'Track';
  String get uploadProof =>
      _localizedValues[locale.languageCode]?['uploadProof'] ?? 'Upload Proof';
  String get confirmDelivery =>
      _localizedValues[locale.languageCode]?['confirmDelivery'] ?? 'Confirm Delivery';
  String get orderNotFound =>
      _localizedValues[locale.languageCode]?['orderNotFound'] ?? 'Order not found';
  String get orderTracking =>
      _localizedValues[locale.languageCode]?['orderTracking'] ?? 'Order Tracking';
  String get noTrackingInfo =>
      _localizedValues[locale.languageCode]?['noTrackingInfo'] ?? 'No tracking information yet.';
  String get paymentProof =>
      _localizedValues[locale.languageCode]?['paymentProof'] ?? 'Payment Proof';
  String get uploadPaymentScreenshots =>
      _localizedValues[locale.languageCode]?['uploadPaymentScreenshots'] ?? 'Upload your payment screenshot(s)';
  String get oneToFiveImages =>
      _localizedValues[locale.languageCode]?['oneToFiveImages'] ?? '1 to 5 images';
  String get maxFiveImages =>
      _localizedValues[locale.languageCode]?['maxFiveImages'] ?? 'You can upload up to 5 images.';
  String get submitProof =>
      _localizedValues[locale.languageCode]?['submitProof'] ?? 'Submit Proof';
  String get options =>
      _localizedValues[locale.languageCode]?['options'] ?? 'Options';
  String get relatedProducts =>
      _localizedValues[locale.languageCode]?['relatedProducts'] ?? 'Related Products';
  String get inStock =>
      _localizedValues[locale.languageCode]?['inStock'] ?? 'In Stock';
  String get outOfStock =>
      _localizedValues[locale.languageCode]?['outOfStock'] ?? 'Out of Stock';
  String get addToCart =>
      _localizedValues[locale.languageCode]?['addToCart'] ?? 'Add to Cart';
  String get addedToCart =>
      _localizedValues[locale.languageCode]?['addedToCart'] ?? 'Added to Cart ✓';
  String get readMore =>
      _localizedValues[locale.languageCode]?['readMore'] ?? 'Read more';
  String get showLess =>
      _localizedValues[locale.languageCode]?['showLess'] ?? 'Show less';
  String get productNotFound =>
      _localizedValues[locale.languageCode]?['productNotFound'] ?? 'Product not found';
  String get yourRating =>
      _localizedValues[locale.languageCode]?['yourRating'] ?? 'Your Rating';
  String get reviewTitle =>
      _localizedValues[locale.languageCode]?['reviewTitle'] ?? 'Review Title';
  String get reviewTitleHint =>
      _localizedValues[locale.languageCode]?['reviewTitleHint'] ?? 'e.g. Great product!';
  String get reviewBodyOptional =>
      _localizedValues[locale.languageCode]?['reviewBodyOptional'] ?? 'Review Body (optional)';
  String get orderStatusPending =>
      _localizedValues[locale.languageCode]?['orderStatusPending'] ?? 'Pending';
  String get orderStatusConfirmed =>
      _localizedValues[locale.languageCode]?['orderStatusConfirmed'] ?? 'Confirmed';
  String get orderStatusProcessing =>
      _localizedValues[locale.languageCode]?['orderStatusProcessing'] ?? 'Processing';
  String get orderStatusShipped =>
      _localizedValues[locale.languageCode]?['orderStatusShipped'] ?? 'Shipped';
  String get orderStatusDelivered =>
      _localizedValues[locale.languageCode]?['orderStatusDelivered'] ?? 'Delivered';
  String get orderStatusCancelled =>
      _localizedValues[locale.languageCode]?['orderStatusCancelled'] ?? 'Cancelled';
  String get paymentStatusPaid =>
      _localizedValues[locale.languageCode]?['paymentStatusPaid'] ?? 'Paid';
  String get paymentStatusFailed =>
      _localizedValues[locale.languageCode]?['paymentStatusFailed'] ?? 'Failed';
  String get paymentStatusRefunded =>
      _localizedValues[locale.languageCode]?['paymentStatusRefunded'] ?? 'Refunded';
  String subtotalItems(int count) =>
      (_localizedValues[locale.languageCode]?['subtotalItems'] ?? 'Subtotal ({count} Items)')
          .replaceAll('{count}', count.toString());
  String get writeAReview =>
      _localizedValues[locale.languageCode]?['writeAReview'] ?? 'Write a Review';
  String get shareExperienceHint =>
      _localizedValues[locale.languageCode]?['shareExperienceHint'] ?? 'Share your experience...';
  String get qty =>
      _localizedValues[locale.languageCode]?['qty'] ?? 'Qty';
  String get total =>
      _localizedValues[locale.languageCode]?['total'] ?? 'Total';
  String get notesHint =>
      _localizedValues[locale.languageCode]?['notesHint'] ?? 'Notes';
  String get myFavorites =>
      _localizedValues[locale.languageCode]?['myFavorites'] ?? 'My Favorites';
  String get myAddresses =>
      _localizedValues[locale.languageCode]?['myAddresses'] ?? 'My Addresses';
  String get noSavedAddresses =>
      _localizedValues[locale.languageCode]?['noSavedAddresses'] ?? 'No saved addresses';
  String get deleteAddress =>
      _localizedValues[locale.languageCode]?['deleteAddress'] ?? 'Delete Address';
  String get setAsDefault =>
      _localizedValues[locale.languageCode]?['setAsDefault'] ?? 'Set as Default';
  String get defaultLabel =>
      _localizedValues[locale.languageCode]?['defaultLabel'] ?? 'Default';
  String get noFavoriteProducts =>
      _localizedValues[locale.languageCode]?['noFavoriteProducts'] ?? 'No favorite products yet';
  String get favoriteProductsDesc =>
      _localizedValues[locale.languageCode]?['favoriteProductsDesc'] ??
      'Tap the heart icon on any product to save it here';
  // ── End store strings ─────────────────────────────────────────────────────

  String? getSymptomName(String symptomName) {
    try {
      return _localizedValues[locale.languageCode]?[symptomName];
    } catch (e) {
      return null;
    }
  }

  String? getSymptomDescription(String symptomName) {
    try {
      return _localizedValues[locale.languageCode]
          ?['${symptomName}_description'];
    } catch (e) {
      return null;
    }
  }

  String? getSymptomCause(String symptomName, int index) {
    try {
      return _localizedValues[locale.languageCode]
          ?['${symptomName}_cause_$index'];
    } catch (e) {
      return null;
    }
  }

  String? getSymptomAction(String symptomName, int index) {
    try {
      return _localizedValues[locale.languageCode]
          ?['${symptomName}_action_$index'];
    } catch (e) {
      return null;
    }
  }

  // Define all localized values
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'Aleefy',
      'home': 'Home',
      'myActivity': 'My Activity',
      'profile': 'Profile',
      'settings': 'Settings',
      'appearance': 'Appearance',
      'language': 'Language',
      'notifications': 'Notifications',
      'privacySecurity': 'Privacy & Security',
      'about': 'About',
      'lightMode': 'Light Mode',
      'darkMode': 'Dark Mode',
      'systemDefault': 'System Default',
      'useLightTheme': 'Use light theme',
      'useDarkTheme': 'Use dark theme',
      'useSystemTheme': 'Follow system theme',
      'english': 'English',
      'arabic': 'العربية',
      'useEnglish': 'Use English language',
      'useArabic': 'استخدم اللغة العربية',
      'pushNotifications': 'Push Notifications',
      'emailNotifications': 'Email Notifications',
      'sound': 'Sound',
      'privacyPolicy': 'Privacy Policy',
      'termsOfService': 'Terms of Service',
      'deleteAccount': 'Delete Account',
      'appVersion': 'App Version',
      'contactSupport': 'Contact Support',
      'rateApp': 'Rate the App',
      'myProfile': 'My Profile',
      'myPets': 'My Pets',
      'appointments': 'Appointments',
      'favorites': 'Favorites',
      'support': 'Support',
      'logout': 'Logout',
      'confirmLogout': 'Are you sure you want to logout?',
      'yes': 'Yes',
      'no': 'No',
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'confirmDeleteAccount':
          'Are you sure you want to delete your account? This action cannot be undone.',
      'refreshLocation': 'Refresh location',
      'enableLocation': 'Enable location',
      'locationAccessDisabled': 'Location Access Disabled',
      'enableLocationToFindVets': 'Enable location to find nearby Vets',
      'enable': 'Enable',
      'currentLocation': 'Current Location',
      'gettingLocation': 'Getting location...',
      'loadingVets': 'Loading Vets...',
      'noVetsNearby': 'No Vets found nearby',
      'tryEnablingLocation': 'Try enabling location or check back later',
      'retry': 'Retry',
      'guestBrowsingMessage':
          'You\'re browsing as a guest. Some features require login.',
      'login': 'Login',
      'vetVisit': 'Vet Visit',
      'animalView3D': 'Symptom Checker',
      'searchPlaceholder': 'Search for Vets, doctors...',
      'nearYou': 'Near You',
      'seeAll': 'See All',
      'virtualVet': 'Virtual Vet',
      'redeemAndSave': 'Redeem & Save',
      'viewHistory': 'View History',
      'pointsAvailable': 'Points Available',
      'redeemNow': 'Redeem Now',
      'vouchers': 'Vouchers',
      'myAccount': 'My Account',
      'followUs': 'Follow Us',
      'welcome': 'Welcome',
      'signIn': 'Sign In',
      'signUp': 'Sign Up',
      'receivePushNotifications': 'Receive Push Notifications',
      'receiveEmailUpdates': 'Receive Email Updates',
      'playSoundForNotifications': 'Play Sound for Notifications',
      'readOurPrivacyPolicy': 'Read Our Privacy Policy',
      'readOurTermsOfService': 'Read Our Terms of Service',
      'deleteYourAccountPermanently': 'Delete Your Account Permanently',
      'deleteAccountRecoveryNote': 'This action can be reversed within 30 days by contacting support.',
      'deletingAccount': 'Deleting your account...',
      'accountDeletedSuccessfully': 'Your account has been deleted successfully',
      'failedToDeleteAccount': 'Failed to delete account. Please try again.',
      'success': 'Success',
      'error': 'Error',
      'myVouchers': 'My Vouchers',
      'available': 'Available',
      'used': 'Used',
      'expired': 'Expired',
      'gotAVoucher': 'Got a voucher?',
      'addVoucher': 'Add Voucher',
      'enterVoucherCode': 'Enter voucher code',
      'enterYourVoucherCode': 'Enter your voucher code',
      'pleaseEnterVoucherCode': 'Please enter a voucher code',

      // Onboarding screen translations
      'skip': 'Skip',
      'skipLogin': 'Skip Login',
      'skipSignup': 'Skip Signup',
      'welcomeToAleefy': 'Welcome to Aleefy',
      'onboardingSubtitle1': 'The simplest way to care for your pet, every day.',
      'checkAndBookInSeconds': 'Check & Book in Seconds',
      'onboardingSubtitle2': 'Review common symptoms, find nearby clinics, and reserve a spot instantly — no waiting rooms, no hassle.',
      'exclusiveBenefits': 'Exclusive Benefits for Your Pet',
      'onboardingSubtitle3': 'Unlock free checkups, grooming offers, and special clinic discounts — only on Aleefy.',

      // Auth screen translations
      'welcomeBack': 'Welcome Back',
      'loginToAccount': 'Login to your account',
      'rememberMe': 'Remember me',
      'forgotPassword': 'Forgot Password?',
      'orContinueWith': 'Or continue with',

      // Forgot Password screen translations
      'resetYourPassword': 'Reset Your Password',
      'enterRegisteredEmail':
          'Enter your registered email to receive a verification code',
      'sendVerificationCode': 'Send Verification Code',
      'codeSent': 'Code Sent',
      'verificationCodeSentTo': 'Verification code has been sent to {email}',
      'failedToSendCode': 'Failed to send verification code',
      'noAccountFoundWithEmail':
          'No account found with this email address. Please check your email or create a new account.',
      'pleaseEnterEmail': 'Please enter your email',
      'pleaseEnterValidEmail': 'Please enter a valid email',

      // Enter Verification Code screen translations
      'enterVerificationCode': 'Enter Verification Code',
      'verificationCodeSentToEmail':
          'We have sent a verification code to {email}',
      'pleaseEnterAll6Digits': 'Please enter all 6 digits of the code',
      'verificationCodeExpired':
          'Verification code has expired. Please request a new one.',
      'invalidVerificationCode': 'Invalid verification code. Please try again.',
      'errorVerifyingCode': 'Error verifying code',
      'newCodeSent': 'Code Sent',
      'newVerificationCodeSentTo':
          'A new verification code has been sent to {email}',
      'failedToResendCode': 'Failed to resend code. Please try again.',
      'verifyCode': 'Verify Code',
      'resendCode': 'Resend Code',
      'didntReceiveCode': 'Didn\'t receive the code?',

      // Email Verification screen translations
      'verifyYourEmail': 'Verify Your Email',
      'enterThe6DigitCodeSentTo': 'Enter the 6-digit code sent to {email}',
      'emailVerifiedSuccessfully': 'Email Verified Successfully!',
      'youCanNowContinueToTheApp': 'You can now continue to the app',
      'continueText': 'Continue',
      'verify': 'Verify',
      'verificationFailed': 'Verification Failed',
      'invalidOrExpiredCode': 'Invalid or expired code. Please try again.',
      'seconds': 's',

      // Create New Password screen translations
      'createNewPassword': 'Create New Password',
      'newPasswordMustBeDifferent':
          'Your new password must be different from previously used passwords',
      'atLeast6Characters': 'At least 6 characters',
      'containsANumber': 'Contains a number',
      'containsAnUppercaseLetter': 'Contains an uppercase letter',
      'newPassword': 'New Password',
      'confirmPassword': 'Confirm Password',
      'pleaseEnterPassword': 'Please enter a password',
      'passwordMustBeAtLeast6Characters':
          'Password must be at least 6 characters',
      'passwordMustContainUppercase':
          'Password must contain at least one uppercase letter',
      'passwordMustContainNumber': 'Password must contain at least one number',
      'pleaseConfirmPassword': 'Please confirm your password',
      'passwordsDoNotMatch': 'Passwords do not match',
      'resetPassword': 'Reset Password',
      'passwordResetSuccessfully': 'Password Reset Successfully!',
      'passwordChangedMessage':
          'Your password has been changed. Please use your new password to login.',
      'loginNow': 'Login Now',
      'failedToResetPassword': 'Failed to reset password. Please try again.',

      // Account Details screen translations
      'personalInformation': 'Personal Information',
      'security': 'Security',
      'changePassword': 'Change Password',
      'currentPassword': 'Current Password',
      'enterCurrentPasswordPrompt':
          'Enter your current password and choose a new password',

      'signInWithGoogle': 'Sign in with Google',
      'signInWithApple': 'Sign in with Apple',
      'signUpWithGoogle': 'Sign up with Google',
      'signUpWithApple': 'Sign up with Apple',
      'dontHaveAccount': 'Don\'t have an account?',
      'wrongCredentials': 'Wrong email or password',
      'emailNotVerified': 'Email Not Verified',
      'pleaseVerifyYourEmail': 'Please verify your email to continue',
      'validatingVoucherCode': 'Validating voucher code: {code}',
      'voucherAddedSuccessfully': 'Voucher "{code}" added successfully!',
      'invalidVoucherCode': 'Invalid voucher code: "{code}"',
      'voucherHelpText':
          'Enter the voucher code you received from Aleefy or our partners',
      'errorOpeningAccountDetails': 'Error opening account details',
      'aleefyPoints': 'Aleefy Points',
      'view': 'View',
      'pointsHistory': 'Points History',

      // Additional Points Translations
      'errorLoadingPoints': 'Error loading points',
      'errorLoadingMore': 'Error loading more transactions',
      'currentBalance': 'Current Balance',
      'totalEarned': 'Total Earned',
      'totalSpent': 'Total Spent',
      'transactionHistory': 'Transaction History',
      'noTransactions': 'No transactions yet',
      'noPointsAvailable': 'No Points Available',
      'noPointsMessage':
          'You don\'t have any points to redeem yet. Start using our services to earn points!',
      'failedToLoadTimeSlots': 'Failed to load available time slots',
      'failedToValidatePoints': 'Failed to validate points',
      'pointsValidatedSuccessfully': 'Points validated successfully',
      'invalidPointsAmount': 'Invalid points amount',

      'loginRequired': 'Login Required',
      'loginRequiredMessage':
          'You need to be logged in to access this feature.',
      'leaveAReview': 'Leave a Review',
      'howWasYourExperience': 'How was your experience?',
      'shareYourExperience': 'Share your experience',
      'tellUsAboutExperience':
          'Tell us about your experience with the vet and the service provided...',
      'submitReview': 'Submit Review',
      'pleaseSelectRating': 'Please select a rating',
      'pleaseEnterReviewComment': 'Please enter a review comment',
      'reviewSubmittedSuccessfully': 'Review submitted successfully!',
      'veterinaryClinic': 'Veterinary Clinic',
      'rating': 'Rating',
      'ratingPoor': 'Poor',
      'ratingFair': 'Fair',
      'ratingGood': 'Good',
      'ratingVeryGood': 'Very Good',
      'ratingExcellent': 'Excellent',
      'appointment': 'Appointment',
      'deleteAccountConfirmation':
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently lost.',
      'accountDetailsUpdatedSuccessfully':
          'Account details updated successfully!',
      'failedToUpdateProfile': 'Failed to update profile: {error}',
      'voucherCodeCopied': 'Voucher code "{code}" copied to clipboard',

      // Pet-related translations
      'loginRequiredToAddPets': 'You need to be logged in to add pets.',
      'loginRequiredToUpdatePets': 'You need to be logged in to update pets.',
      'chooseFromGallery': 'Choose from Gallery',
      'takeAPhoto': 'Take a Photo',
      'addYourFirstPet': 'Add Your First Pet',
      'deleting': 'Deleting...',
      'refreshPets': 'Refresh pets',
      'errorLoadingPets': 'Error loading pets',
      'noPetsAddedYet': 'No pets added yet',
      'addYourFurryFriends':
          'Add your furry friends to keep track of their health and appointments',
      'yearOld': 'year old',
      'yearsOld': 'years old',
      'monthOld': 'month old',
      'monthsOld': 'months old',
      'choosePhoto': 'Choose Photo',
      'camera': 'Camera',
      'gallery': 'Gallery',
      'invalidSpecies': 'Invalid Species',
      'onlyCatsAndDogsAllowed': 'Only cats and dogs are allowed.',
      'failedToUpdatePet': 'Failed to update pet. Please try again.',
      'birthday': 'Birthday',
      'species': 'Species',
      'gender': 'Gender',
      'notSpayedNeutered': 'Not Spayed/Neutered',
      'addNewPet': 'Add New Pet',
      'petName': 'Pet Name',
      'enterPetName': 'Enter your pet\'s name',
      'pleaseEnterPetName': 'Please enter your pet\'s name',
      'petType': 'Pet Type',
      'birthdate': 'Birthdate',
      'age': 'Age',
      'enterPetAge': 'Enter your pet\'s age',
      'days': 'days',
      'months': 'months',
      'years': 'years',
      'pleaseEnterValidAge': 'Please enter a valid age',
      'weightKg': 'Weight (kg)',
      'kg': 'kg',
      'allergies': 'Allergies',
      'addNotes': 'Any additional information about your pet',
      'spayedNeuteredQuestion': 'Spayed/Neutered?',
      'savePet': 'Save Pet',
      'saveChanges': 'Save Changes',
      'firstName': 'First Name',
      'lastName': 'Last Name',
      'petAddedSuccessfully': '{name} has been added successfully.',
      'failedToAddPet': 'Failed to add pet. Please try again.',
      'petProfile': 'Pet Profile',
      'submit': 'Submit',
      'completeProfile': 'Complete Your Profile',
      'completeProfileSubtitle': 'We need a few more details to set up your account.',
      'justAFewMoreDetails': 'Just a few more details',
      'enterFullName': 'Enter your full name',
      'nameRequired': 'Name is required',
      'fullNameRequired': 'Please enter your full name (first and last name)',
      'profileUpdatedSuccessfully': 'Profile updated successfully!',
      'editPet': 'Edit Pet',
      'confirmDelete': 'Confirm Delete',
      'areYouSureDeletePet': 'Are you sure you want to delete this pet?',
      'thisActionCannotBeUndone': 'This action cannot be undone.',
      'updatePet': 'Update Pet',
      'weight': 'Weight',
      'lastVetVisit': 'Last Vet Visit',
      'addVaccination': 'Add Vaccination',
      'petUpdatedSuccessfully': '{name} has been updated successfully.',
      'info': 'Info',
      'noChangesToUpdate': 'No changes to update',

      // Vaccination Strings
      'vaccinationRecord': 'Vaccination Record',
      'addVaccine': 'Add Vaccine',
      'viewAll': 'View All',
      'virusVaccines': 'Virus Vaccines',
      'wormsVaccines': 'Worms',
      'insectsVaccines': 'Insects',
      'rabiesVaccines': 'Rabies',
      'monovalent': 'Monovalent',
      'bivalent': 'Bivalent',
      'trivalent': 'Trivalent',
      'quadrivalent': 'Quadrivalent',
      'pentavalent': 'Pentavalent',
      'hexavalent': 'Hexavalent',
      'heptavalent': 'Heptavalent',
      'octavalent': 'Octavalent',
      'deworming': 'Deworming',
      'antiInsects': 'Anti-Insects',
      'rabies': 'Rabies',
      'vaccineType': 'Vaccine Type',
      'vaccinationDate': 'Vaccination Date',
      'administeredDoses': 'Administered Doses',
      'addAnotherDose': 'Add Another Dose',
      'maximumDosesReached': 'Maximum Doses Reached',
      'maximumReached': 'Maximum Reached',
      'thisVaccineRequiresOnly1Dose': 'This vaccine requires only 1 dose',
      'thisVaccineRequiresOnly2Doses': 'This vaccine requires only 2 doses',
      'youCanOnlyAddUpTo3Doses': 'You can only add up to 3 doses',
      'pleaseSelectVaccineType': 'Please select a vaccine type',
      'pleaseAddAtLeastOneDose': 'Please add at least one dose',
      'vaccinationAddedSuccessfully': 'Vaccination added successfully',
      'dateAdministered': 'Date Administered',
      'removeDose': 'Remove Dose',
      'dose': 'Dose',
      'completedDoses': 'doses completed',
      'vaccine': 'vaccine',
      'vaccines': 'vaccines',
      'noPetsFound': 'No Pets Found',
      'addPetToViewVaccination': 'Add a pet to view vaccination records',
      'selectPetToViewVaccination': 'Select a pet to view vaccination records',
      'viewRecord': 'View Record',
      'failedToLoadRewardsData': 'Failed to load rewards data',
      'areYouSureYouWantToLogout': 'Are you sure you want to logout?',
      'loggedOutSuccessfully': 'Logged out successfully',
      'logoutFailed': 'Logout failed. Please try again.',
      'virusVaccineMissing': 'Virus Vaccine Missing',
      'virusVaccineMissingMessage':
          'Your pet needs virus protection. Start the vaccine series soon to protect against diseases.',
      'wormTreatmentMissing': 'Worm Treatment Missing',
      'wormTreatmentMissingMessage':
          'Your pet needs deworming treatment. Only 2 doses required to prevent parasites.',
      'insectProtectionMissing': 'Insect Protection Missing',
      'insectProtectionMissingMessage':
          'Your pet needs flea and tick protection. Only 1 dose required to prevent infestations.',
      'rabiesVaccineMissing': 'Rabies Vaccine Missing',
      'rabiesVaccineMissingMessage':
          'Your pet needs rabies protection. Only 1 dose required. This vaccine is critical for your pet\'s safety.',
      'noVaccinationRecords': 'No Vaccination Records',
      'addYourPetsFirstVaccine': 'Add your pet\'s first vaccine to get started',
      'vaccinationRecords': 'Vaccination Records',
      'annualBoosters': 'Annual Boosters',
      'markAsComplete': 'Mark as Complete',
      'markComplete': 'Mark',
      'notYetAdministered': 'Not yet administered',
      'doseMarkedComplete': '✓ Dose marked as complete!',
      'boosterMarkedComplete': '✓ Annual booster marked as complete!',
      'boosterMarkedCompleteWithNextScheduled':
          '✓ Booster complete! Next booster has been scheduled automatically.',
      'viewSchedule': 'View',
      'nextDose': 'Next dose',
      'protectionActive': 'Protection active. Repeat on schedule to stay safe',
      'protectedFromRabies':
          'Protected from rabies. Repeat yearly to stay safe',
      'notProtectedFromFleasOrTicks':
          'Not protected from fleas or ticks. Start soon',
      'yourPetIsntProtectedFromRabies':
          'Your pet isn\'t protected from rabies. Vaccinate soon',
      'treatmentComplete': 'Treatment complete! Your pet is now protected',
      'secondDoseRequiredForFullDeworming':
          'Second dose required for full deworming',
      'wormsSecondDoseExpired':
          'Unfortunately, the second dose window has passed. Your pet is not protected. We must restart the vaccination for best protection.',
      'notProtectedFromWorms': 'Not protected from worms. Start deworming soon',
      'whatToDoNow': 'What to do now?',
      'wormsWindowExpiredExplanation':
          'Unfortunately, the valid window for the 2nd dose has ended (Day 14-20). You must restart the vaccination series with a new 1st dose to ensure your pet is protected.',
      'tipCancelAndRestart':
          '💡 Tip: Press "Cancel" and start a new vaccination series.',
      'warningTooEarlyFor2ndDose': 'Warning: Too Early for 2nd Dose',
      'warning2ndDoseWindowExpired': 'Warning: 2nd Dose Window Expired',
      'wormingVaccineProtocol': 'Worming Vaccine Protocol:',
      'wormingVaccineInfo': 'Worming Vaccine Info',
      'firstDose': '1st Dose',
      'vaccinesNeverTakenAndOverdue': 'Vaccines that were never taken and are now overdue',
      'dueWithinNext30Days': 'Due within the next 30 days',
      'inProgressVaccinesNeedingNextDose': 'Vaccines in progress that need the next dose',
      'notAdded': 'Not Added',
      'windowOpensDay14': 'Window Opens (Day 14)',
      'windowClosedDay20': 'Window Closed (Day 20)',
      'dosesRequired2': '2 doses required',
      'secondDoseDay14to20Only': '2nd dose: Day 14-20 only',
      'beforeDay14TooEarly': 'Before Day 14: Too early',
      'afterDay20MustRestart': 'After Day 20: Must restart',
      'doses2Between14to20Days': '2 doses, 14-20 days apart',
      'validWindowDay14to20': 'Valid window: Day 14-20',
      'afterDay20MustRestartFromBeginning': 'After day 20: Must restart',
      'restartVaccinationSeries': 'Restart Vaccination Series',
      'daysRemaining': 'Days Remaining:',
      'waitMoreDaysBeforeSecondDose':
          'You must wait {days} more day(s) before giving the 2nd dose. The 2nd dose must be given at least 14 days after the 1st dose.',
      'warningMissedDose': 'Warning: Missed Dose',
      'missed2ndDoseVirusMessage':
          'Unfortunately, since the second dose was missed, your pet is no longer protected. You\'ll need to restart the vaccination series.',
      'missed3rdDoseVirusMessage':
          'Your pet is still protected because it received the first two doses, but please give the third as soon as possible for full protection.',
      'missedInsectsMessage':
          'Please administer the dose as soon as possible to protect your pet.',
      'missedRabiesMessage':
          'Please administer the rabies vaccine as soon as possible. This vaccine is critical for your pet\'s safety.',
      'deadlineDay35': 'Deadline (Day 35)',
      'lastDoseGiven': 'Last Dose Given',
      'daysSinceLastDose': 'Days Since Last Dose:',
      'scheduleNextDose': 'Schedule Next Dose',
      'deleteVaccination': 'Delete Vaccination',
      'areYouSureDeleteVaccination':
          'Are you sure you want to delete this vaccination series?',
      'deleteVaccinationFeatureComingSoon':
          'Delete vaccination feature coming soon. API will be integrated later.',
      'vaccinationDeleted': 'Vaccination deleted successfully',
      'cannotDeleteVaccination': 'Cannot Delete Vaccination',
      'cannotDeleteCompletedVaccination':
          'Completed vaccinations cannot be deleted. They are part of your pet\'s permanent medical record.',
      'completedVaccinationsAreProtected':
          'Completed vaccinations are protected and kept for medical history.',
      'understood': 'Understood',
      'nextAnnualBoosterWillBeScheduled':
          'Next annual booster will be automatically scheduled for 1 year from this date.',
      'fullyProtected': 'Fully protected. Follow booster schedule to stay safe',
      'protectedThirdDoseGivesStrongestImmunity':
          'Protected. Third dose gives strongest immunity',
      'protectionIncomplete':
          'Protection incomplete. Second dose needed to activate immunity',
      'notProtectedStartVirusVaccineSoon':
          'Not protected. Start the virus vaccine soon',
      'dismiss': 'Dismiss',
      'errorLoadingVaccinationRecord': 'Error Loading Vaccination Record',
      'noVaccinationData': 'No vaccination data',
      'overdue': 'Overdue',
      'markDoseComplete': 'Mark Dose Complete',
      'selectPet': 'Select Pet',
      'addVaccinationTitle': 'Add Vaccination',
      'active': 'ACTIVE',
      'completedStatus': 'COMPLETED',
      'dosesCompleted': 'doses completed',
      'wormTreatment': 'Worm Treatment',
      'insectProtection': 'Insect Protection',
      'rabiesVaccine': 'Rabies Vaccine',
      'markBoosterCompleteFeatureComingSoon':
          'Mark booster complete feature coming soon',

      'noFavoritesYet': 'No favorites yet',
      'noFavoritesMessage':
          'When you find Vets you love, save them here for quick access.',
      'openNow': 'Open Now',
      'closed': 'Closed',
      'bookAppointment': 'Book Appointment',
      'exploreMoreVets': 'Explore More Vets',
      'removedFromFavorites': 'removed from favorites',
      'loading': 'Loading...',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'ok': 'OK',
      'next': 'Next',
      'previous': 'Previous',
      'search': 'Search',
      'clear': 'Clear',
      'apply': 'Apply',
      'filter': 'Filter',
      // Signup screen translations
      'createAccount': 'Create Your Account',
      'accountCreationSubtitle': 'Fill in your details to create your account',
      'fullName': 'Full Name',
      'phoneNumber': 'Phone Number',
      'alreadyHaveAccount': 'Already have an account?',
      'termsAndConditionsAgreement': 'By registering you agree to',
      'termsAndConditions': 'Terms & Conditions',
      'and': 'and',
      'registrationSuccessful': 'Registration Successful',
      'pleaseVerifyEmail': 'Please verify your email to continue',
      'registrationFailed': 'Registration Failed',
      'sort': 'Sort',
      'share': 'Share',
      'noResultsFound': 'No results found',
      'tryAgain': 'Try Again',
      'refresh': 'Refresh',
      'addToFavorites': 'Add to favorites',
      'removeFromFavorites': 'Remove from favorites',
      'today': 'Today',
      'tomorrow': 'Tomorrow',
      'selectDate': 'Select Date',
      'selectTime': 'Select Time',
      'done': 'Done',
      'noVouchersFound': 'No vouchers found',
      'checkBackLater': 'Check back later for new offers',
      'name': 'Name',
      'email': 'Email',
      'phone': 'Phone',
      'dateOfBirth': 'Date of Birth',
      'address': 'Address',
      'pointsValue': '{points} Points',
      'pointsSummary': 'Total earned: {earned} • Total redeemed: {redeemed}',
      'dateToday': 'Today',
      'dateYesterday': 'Yesterday',
      'dateDaysAgo': '{days} days ago',
      'password': 'Password',
      'yourPetCareActivities': 'Your Pet Care Activities',
      'noActivitiesFound': 'No activities found',
      'activitiesMatchingFilterWillAppearHere':
          'Activities matching filter will appear here',
      'appointmentCancelledSuccessfully': 'Appointment cancelled successfully',
      'failedToCancelAppointment': 'Failed to cancel appointment',
      'confirmCancelAppointmentMessage':
          'Are you sure you want to cancel this appointment?',
      'yesCancelAppointment': 'Yes, Cancel',
      'rescheduleFeatureComingSoon': 'Reschedule feature coming soon!',
      'reviewFeatureComingSoon': 'Review feature coming soon!',
      'bookingFollowupAppointment': 'Booking follow-up appointment...',
      'upcoming': 'Upcoming',
      'pending': 'Pending',
      'confirmed': 'Confirmed',
      'completed': 'Completed',
      'cancelled': 'Cancelled',
      'last3Months': 'Last 3 Months',
      'byYear': 'By Year',
      'selectYear': 'Select Year',
      'timeFilter': 'Time Filter',
      'vetDetails': 'vet Details',
      'report': 'Report',
      'minutes': 'minutes',
      'reviews': 'Reviews',
      'review': 'Review',
      'reviewDetails': 'Review Details',
      'tapToViewDetails': 'Tap to view details',
      'noComment': 'No comment provided',
      'noReviewsYet': 'No reviews yet',
      'patients': 'Patients',
      'yearsExp': 'Years exp.',
      'description': 'Description',
      'defaultvetDescription':
          'BluePearl Pet Hospital is a network of specialized animal hospitals that offer emergency and specialist services. They focus on the care of pets that require specialized medical attention.',
      'services': 'Services',
      'generalWellnessExam': 'General wellness exam',
      'vaccinations': 'Vaccinations',
      'microchipping': 'Microchipping',
      'nutritionalCounseling': 'Nutritional counseling',
      'laboratoryServices': 'Laboratory services',
      'surgery': 'Surgery',
      'dentalCare': 'Dental care',
      'emergencyCare': 'Emergency care',
      'consultationFee': 'Consultation Fee',
      'initialExaminationFee': 'Initial examination fee',
      'earnPoints': 'Earn',
      'pointsAfterCompletion': 'points after completing your visit!',
      'workingHours': 'Working Hours',
      'mondayFriday': 'Monday - Friday',
      'saturday': 'Saturday',
      'sunday': 'Sunday',
      'bookConsultation': 'Book Consultation',
      'consultation': 'Consultation',
      'findVets': 'Find Vets',
      'searchVetsHint': 'Search Vets, services, locations...',
      'filters': 'Filters',
      'allCategory': 'All Category',
      'popular': 'Popular',
      'recommended': 'Recommended',
      'latest': 'Latest',
      'enableLocationForResults': 'Enable location for distance-based results',
      'searchResult': 'Search Result',
      'noVetsFound': 'No Vets found',
      'tryAdjustingFilters': 'Try adjusting your search or filters',
      'clearFilters': 'Clear Filters',
      'viewDetails': 'View Details',
      'callvet': 'Call vet',
      'failedToLoadVets': 'Failed to load Vets. Please try again.',
      'errorApplyingFilters': 'Error applying filters. Please try again.',
      'withinDistance': 'Within {distance}km',
      'VetsFound': '{count} found',
      'ratingWithReviews': '{rating} ({reviews})',
      'yearsExperience': '{years} years',
      'callingNumber': 'Calling {phone}',
      'region': 'Region',
      'allRegions': 'All Regions',
      'nearbyAutoDetect': 'Nearby (Auto-detect)',
      'allServices': 'All Services',
      'sortBy': 'Sort By',
      'sortDefault': 'Default',
      'sortNearby': 'Nearby',
      'sortRating': 'Highest Rating',
      'sortReviews': 'Most Reviews',
      'sortName': 'Name (A-Z)',
      'maxDistance': 'Maximum Distance',
      'anyDistance': 'Any Distance',
      'clearAll': 'Clear All',
      'applyFilters': 'Apply Filters',
      'distanceKm': '{distance}km',
      'vaccination': 'Vaccination',
      'checkup': 'Checkup',
      'grooming': 'Grooming',
      'emergency': 'Emergency',
      'bookVetVisit': 'Book Vet Visit',
      'resetBooking': 'Reset Booking',
      'bookingDetails': 'Booking Details',
      'vet': 'Vet',
      'price': 'Price',
      'selectTimeSlot': 'Select Time Slot',

      // Points Redemption
      'redeemPoints': 'Redeem Points',
      'availablePoints': 'Available Points',
      'pointsToRedeem': 'Points to Redeem',
      'enterPointsAmount': 'Enter points amount',
      'pointsDiscount': 'Points Discount',
      'remainingBalance': 'Remaining Balance',
      'originalPrice': 'Original Price',
      'discount': 'Discount',
      'finalPrice': 'Final Price',
      'totalPrice': 'Total Price',
      'pts': 'pts',
      'totalSavings': 'Total Savings',
      'vetDiscount': 'Vet Discount',
      'coupon': 'Coupon',
      'points': 'Points',
      'morning': 'Morning',
      'afternoon': 'Afternoon',
      'evening': 'Evening',
      'petsForVisitOptional': 'Pets for Visit (Optional)',
      'tapToSelectPets': 'Tap to select pets for this visit',
      'addingPetsOptional': 'Adding pets is optional',
      'selectPetsForVisit': 'Select Pets for Visit',
      'failedToLoadPets': 'Failed to load pets',
      'noPetsYet': 'You don\'t have any pets yet',
      'addPet': 'Add a Pet',
      'confirmBooking': 'Confirm Booking',
      'bookingConfirmed': 'Booking Confirmed!',
      'reference': 'Reference',
      'pets': 'Pets',
      'petsForThisVisit': 'Pets for this visit:',
      'showQRCodeAtVet': 'Show this QR code at the vet',
      'qrCodeError': 'Something went wrong!',
      'pleaseSelectTimeSlot': 'Please select a time slot',
      'bookingFailed': 'Booking failed. Please try again.',
      'availableSlotsFor': 'Available slots for {date}',
      'confirmPets': 'Confirm ({count} pets)',
      'noSlotsAvailable': 'No slots available',
      'booked': 'Booked',
      'availableSlots': '({count} available)',
      'favorite': 'Favorite',
      'addedToFavorites': 'Added to favorites',
      'selectLocation': 'Select Location',
      'selectGovernorateOrCity': 'Select Governorate or City',
      'searchGovernorate': 'Search governorate...',
      'citiesCount': '{count} cities',
      'selectCity': 'Select City',
      'searchCity': 'Search city...',
      'allCitiesIn': 'All {governorate}',
      'selectEntireGovernorate': 'Select entire governorate',
      'cannotOpenMaps':
          'Cannot open maps. Please check if Google Maps is installed.',
      'viewLocation': 'View Location',
      'chooseMapApp': 'Choose how to view the location',
      'coordinates': 'Coordinates',
      'copyLocation': 'Copy Location',
      'openInBrowser': 'Open in Browser',
      'locationCopiedToClipboard': 'Location copied to clipboard',
      // Pet Symptom Categories
      'eyeSymptoms': 'Eye Symptoms',
      'earSymptoms': 'Ear Symptoms',
      'mouthTeethSymptoms': 'Mouth & Teeth Symptoms',
      'skinCoatSymptoms': 'Skin & Coat Symptoms',
      'movementLimbsIssues': 'Movement & Limbs Issues',
      'anusPoopingIssues': 'Anus & Pooping Issues',
      'maleGenitalProblems': 'Male Genital Problems',
      'femaleGenitalProblems': 'Female Genital Problems',
      'urinationProblems': 'Urination Problems',
      'neurologicalIssues': 'Neurological Issues',

      // Eye Symptoms
      'eyeRedness': 'Eye Redness',
      'eyeRednessDescription':
          'Noticed your pet\'s eye looking red? It could be something small like dust or something serious like an infection.',

      'eyeDischarge': 'Eye Discharge (Goopy Stuff)',
      'eyeDischargeDescription':
          'A little eye goop can be normal, but if it\'s thick, yellow, or green, it might mean an infection.',

      'cloudyEye': 'Cloudy Eye (Looks Foggy or Bluish)',
      'cloudyEyeDescription':
          'If your pet\'s eye looks cloudy or milky, it could be a normal age change or something serious.',

      'wateryEyes': 'Watery Eyes (Excessive Tearing)',
      'wateryEyesDescription':
          'Some tearing is normal, but too much can mean an issue.',

      'thirdEyelidShowing': 'Third Eyelid Showing',
      'thirdEyelidShowingDescription':
          'Is there a white or pink piece of tissue covering part of your pet\'s eye, or sticking out from the corner? That\'s the third eyelid.',

      'squintingEye': 'Squinting or Keeping Eye Closed',
      'squintingEyeDescription':
          'If your pet keeps one eye closed or blinks a lot, they might be in pain.',

      'eyeSwelling': 'Swelling Around the Eye',
      'eyeSwellingDescription':
          'If your pet\'s eye looks puffy or swollen, something is irritating it.',

      'wormsInEye': 'Worms in the Eye',
      'wormsInEyeDescription':
          'Seeing something moving in your pet\'s eye? It might be a worm — and it needs quick attention.',

      // Ear Symptoms
      'itchyEars': 'Itchy Ears (Scratching or Head Shaking)',
      'itchyEarsDescription':
          'If your pet is shaking their head like a mini rockstar or scratching their ears a lot, something is bugging them!',

      'blackStuffInEar': 'Black Stuff in the Ear (Dark Wax or Debris)',
      'blackStuffInEarDescription':
          'Noticed dark gunk in your pet\'s ears? It could be harmless wax or a sign of mites or infection!',

      'redSwollenEar': 'Red or Swollen Ear',
      'redSwollenEarDescription':
          'Is your pet\'s ear red, puffy, or warm to the touch? It could be an infection, allergy, or swelling from too much head shaking.',

      'earSmell': 'Bad Smell from the Ear',
      'earSmellDescription':
          'If your pet\'s ears smell like stinky cheese or moldy socks, it\'s usually an infection.',

      'earDischarge': 'Ear Discharge (Pus or Liquid Coming Out)',
      'earDischargeDescription':
          'If there\'s liquid or pus coming from the ear, it\'s usually an infection or something stuck inside.',

      'headTilt': 'Tilting Head to One Side',
      'headTiltDescription':
          'Is your pet holding their head to one side, like they\'re trying to listen or think? It could be a sign of an ear problem or balance issue.',

      'hearingLoss': 'Loss of Hearing or Not Responding to Sounds',
      'hearingLossDescription':
          'If your pet doesn\'t react to noises like they used to, their hearing might be affected.',

      // Mouth & Teeth Symptoms
      'badBreath': 'Bad Breath (Smelly Mouth)',
      'badBreathDescription':
          'If your pet\'s kisses smell like a garbage can, something\'s up!',

      'excessiveDrooling': 'Excessive Drooling',
      'excessiveDroolingDescription':
          'Some drooling is normal, but if your pet is suddenly dripping like a leaky faucet, it\'s a sign of a problem!',

      'redSwollenGums': 'Red, Swollen Gums',
      'redSwollenGumsDescription':
          'Healthy gums should be pink, not red or puffy!',

      'looseMissingTeeth': 'Loose or Missing Teeth',
      'looseMissingTeethDescription':
          'Puppies lose baby teeth, but adults shouldn\'t lose teeth!',

      'troubleEating': 'Trouble Eating or Dropping Food',
      'troubleEatingDescription':
          'If your pet loves food but suddenly struggles to eat, check their mouth!',

      'mouthBleeding': 'Bleeding from the Mouth',
      'mouthBleedingDescription':
          'Seeing blood in your pet\'s mouth? It could be from the gums, teeth, or tongue — and it\'s important to find out why.',

      'tongueSwelling': 'Swelling of Tongue or Lips',
      'tongueSwellingDescription':
          'If your pet\'s tongue or lips look swollen, it might be an allergic reaction or something stuck!',

      'paleGums': 'White or Pale Gums',
      'paleGumsDescription':
          'Gums should be pink, not white or pale. This could mean serious illness!',

      'lockedJaw': 'Locked Jaw (Mouth Won\'t Open or Close)',
      'lockedJawDescription':
          'If your pet can\'t open or close their mouth properly, something is seriously wrong!',

      'oralUlcers': 'Oral Ulcers (Sores in the Mouth)',
      'oralUlcersDescription':
          'Painful sores in the mouth can make eating difficult and may signal an infection!',

      // Common symptom terms
      'possibleCauses': 'Possible Causes',
      'whatToDo': 'What to Do',
      'vetVisitASAP': 'Vet visit ASAP',
      'monitor': 'Monitor',
      'rinseWithSaline': 'Rinse with saline',
      'cleanGently': 'Clean gently',
      'doNotTouch': 'Do not touch',
      'keepCalm': 'Keep calm',

      // Skin & Coat Symptoms
      'hairLoss': 'Hair Loss',
      'hairLossDescription':
          'Noticing more hair on the floor, couch, or your clothes?',

      'baldSpots': 'Bald Spots (Patches of Missing Hair)',
      'baldSpotsDescription':
          'Do you see one or more spots where your pet\'s fur is completely gone?',

      'itchySkin': 'Itchy Skin (Scratching a Lot)',
      'itchySkinDescription':
          'A little scratching is normal, but too much means something\'s wrong!',

      'constantLicking': 'Constant Licking in One Spot',
      'constantLickingDescription':
          'Your pet keeps licking or biting the same area over and over?',

      'redInflamedSkin': 'Red or Inflamed Skin',
      'redInflamedSkinDescription':
          'Is your pet\'s skin looking red, warm, or sore in some areas?',

      'dandruff': 'Dandruff (Flaky Skin)',
      'dandruffDescription':
          'If your pet\'s fur has little white flakes, it might be dry skin or something more!',

      'scabs': 'Scabs or Crusty Skin',
      'scabsDescription':
          'Is your pet\'s skin rough in spots? Those might be scabs from too much scratching.',

      'lumps': 'Lumps or Bumps',
      'lumpsDescription':
          'Not all lumps are bad, but it\'s always best to check!',

      'darkSkin': 'Skin Turning Darker (Hyperpigmentation)',
      'darkSkinDescription':
          'Noticing your pet\'s skin turning dark or black in some areas?',

      // Movement & Limbs Issues
      'limping': 'Limping or Favoring One Leg',
      'limpingDescription':
          'If your pet avoids putting weight on one leg, they might be in pain!',

      'stiffness': 'Stiffness or Trouble Standing Up',
      'stiffnessDescription':
          'If your pet struggles to get up or moves stiffly, their joints or muscles might be sore.',

      'collapsing': 'Sudden Weakness or Collapsing',
      'collapsingDescription':
          'If your pet suddenly can\'t stand or falls over, it\'s an emergency!',

      'trembling': 'Trembling or Shaking',
      'tremblingDescription':
          'Shaking can mean pain, cold, or something more serious!',

      'swollenJoints': 'Swollen or Painful Joints',
      'swollenJointsDescription':
          'If your pet\'s leg or joint looks swollen, something\'s not right!',

      // Anus & Pooping Issues
      'scooting': 'Scooting or Dragging Butt on the Floor',
      'scootingDescription':
          'If your pet keeps sliding their butt on the floor, they might be itchy or uncomfortable!',

      'analSwelling': 'Swelling or Redness Around the Anus',
      'analSwellingDescription':
          'Noticed your pet\'s butt looks red, swollen, or something\'s sticking out? It could be irritation — or a sign something more serious is going on.',

      'bloodStool': 'Blood in Stool or Around the Anus',
      'bloodStoolDescription':
          'Noticed blood when your pet poops or around their butt?',

      'strainingPoop': 'Straining to Poop or Constipation',
      'strainingPoopDescription':
          'If your pet keeps trying to poop but nothing comes out?',

      'diarrhea': 'Diarrhea',
      'diarrheaDescription':
          'Loose, watery poop? It might be something simple or more serious!',

      // Male Genital Problems
      'swollenTesticles': 'Swollen Testicles',
      'swollenTesticlesDescription':
          'If your pet\'s testicles look bigger than usual, something\'s up!',

      'penisDischarge': 'Discharge from the Penis',
      'penisDischargeDescription':
          'A small amount of pale yellow or clear fluid can be normal, but heavy or smelly discharge is not.',

      'exposedPenis': 'Red, Swollen, or Hanging Out Penis',
      'exposedPenisDescription':
          'If your pet\'s penis won\'t go back inside, it\'s an emergency!',

      'genitalLumps': 'Lumps or Bleeding from the Genitals',
      'genitalLumpsDescription':
          'If you notice a lump, sore, or bleeding around your pet\'s genitals, don\'t ignore it!',

      // Female Genital Problems
      'swollenVulva': 'Swollen Vulva',
      'swollenVulvaDescription':
          'If your pet\'s vulva looks swollen, it might be a natural part of her cycle—or a health issue!',

      'vulvaDischarge': 'Discharge from the Vulva',
      'vulvaDischargeDescription':
          'A little clear or whitish discharge is normal, but anything smelly or unusual isn\'t normal!',

      'vulvaProlapse': 'Something Sticking Out from the Vulva',
      'vulvaProlapseDescription':
          'If you see a pink, red, or dark lump/tissue coming out of your pet\'s vulva, it\'s serious!',

      // Urination Problems
      'frequentUrination': 'Peeing Too Much (Frequent Urination)',
      'frequentUrinationDescription':
          'If your pet is peeing much more than usual, even in small amounts, it could be a sign of illness.',

      'strainingUrination': 'Straining to Pee (Difficulty Urinating)',
      'strainingUrinationDescription':
          'If your pet squats for a long time but only a few drops—or nothing—comes out, it\'s a red flag!',

      'bloodyUrine': 'Bloody Urine (Red or Pink Pee)',
      'bloodyUrineDescription':
          'If your pet\'s pee looks red or pink, don\'t ignore it!',

      'noUrination': 'Not Peeing at All (Emergency!)',
      'noUrinationDescription':
          'If your pet hasn\'t peed in over 24 hours, it\'s a life-threatening emergency!',

      // Neurological Issues
      'Seizures':
          'Seizures (Twitching, Shaking, Collapsing, Uncontrollable Movements)',
      'Seizures_description':
          'If your pet suddenly starts shaking, drooling, or falling over, they might be having a seizure!',
      'Seizures_cause_0': 'Epilepsy (some pets are born with it)',
      'Seizures_cause_1': 'Poisoning (chocolate, human meds)',
      'Seizures_cause_2': 'Head injury',
      'Seizures_cause_3': 'Liver or kidney problems',
      'Seizures_cause_4': 'Low blood sugar',
      'Seizures_cause_5': 'Brain tumors (rare)',
      'Seizures_action_0': 'Stay calm – Don\'t try to hold them down',
      'Seizures_action_1':
          'Keep them safe – Move objects away so they don\'t get hurt',
      'Seizures_action_2':
          'Don\'t feed or give water until your pet is fully back to normal',
      'Seizures_action_3': 'Time the seizure – If over 2 minutes → Emergency',
      'Seizures_action_4':
          'Record a video if safe – Helps the vet with diagnosis',
      'Seizures_action_5':
          'After the seizure – Keep your pet quiet and comfortable; once they\'re alert, offer water',
      'Seizures_action_6':
          'Go to the vet if: The seizure lasts more than 2 minutes, They have more than one seizure in 24 hours, They don\'t recover quickly or seem very weak',
      'Seizures_action_7':
          'Only go to the vet once the seizure has stopped (never try to move them mid-seizure)',

      'Head Tilt or Walking in Circles': 'Head Tilt or Walking in Circles',
      'Head Tilt or Walking in Circles_description':
          'If your pet keeps tilting their head to one side or walks in circles, something might be wrong with their brain or inner ear!',
      'Head Tilt or Walking in Circles_cause_0':
          'Ear infection – A common cause, especially if there\'s scratching or a bad smell',
      'Head Tilt or Walking in Circles_cause_1':
          'Balance problems in older pets',
      'Head Tilt or Walking in Circles_cause_2':
          'Toxins or certain medications',
      'Head Tilt or Walking in Circles_cause_3':
          'Brain issues (tumor or injury) – Less common',
      'Head Tilt or Walking in Circles_action_0':
          'If it just started and your pet seems normal otherwise → Monitor closely for the next 24 hours',
      'Head Tilt or Walking in Circles_action_1':
          'Check the ears – If there\'s redness, swelling, or a bad smell, it could be an ear infection → Vet visit needed',
      'Head Tilt or Walking in Circles_action_2':
          'If no signs of an ear infection but symptoms continue → Could be neurological, see a vet',
      'Head Tilt or Walking in Circles_action_3':
          'If the tilt continues or gets worse → Book a vet visit',
      'Head Tilt or Walking in Circles_action_4':
          'If your pet is falling, walking in circles, or has trouble standing → Go to the vet immediately',

      'Loss of Balance':
          'Loss of Balance (Stumbling, Falling Over, Weakness in Legs)',
      'Loss of Balance_description':
          'If your pet suddenly stumbles, wobbles, or falls, it could be a sign of something serious!',
      'Loss of Balance_cause_0':
          'Poisoning – Chocolate, onions, human medicine',
      'Loss of Balance_cause_1':
          'Ear Infection – Can affect balance and coordination',
      'Loss of Balance_cause_2':
          'Balance Problems in Older Pets – Age-related changes',
      'Loss of Balance_cause_3':
          'Spinal Injury – Trauma affecting nerves or movement',
      'Loss of Balance_cause_4': 'Stroke – Sudden loss of balance or weakness',
      'Loss of Balance_cause_5': 'Neurological Disease – Brain or nerve issues',
      'Loss of Balance_action_0':
          'If your pet is a little wobbly but still alert and walking → Monitor closely for a few hours',
      'Loss of Balance_action_1':
          'If your pet can\'t stand at all or keeps falling → Emergency vet visit immediately',
      'Loss of Balance_action_2':
          'If balance issues come with vomiting or head tilt → Vet check ASAP',
      'Loss of Balance_action_3':
          'If you suspect poisoning → Emergency vet immediately!',

      'Sudden Blindness':
          'Sudden Blindness (Bumping Into Things, Wide Pupils, Confusion)',
      'Sudden Blindness_description':
          'If your pet suddenly starts bumping into walls, seems lost in familiar places, or their pupils stay very wide, they may have lost vision suddenly.',
      'Sudden Blindness_cause_0':
          'High blood pressure – Very common in older cats',
      'Sudden Blindness_cause_1':
          'Retinal detachment – Can happen suddenly and cause blindness',
      'Sudden Blindness_cause_2':
          'Diabetes complications – May damage the eyes over time',
      'Sudden Blindness_cause_3':
          'Brain problems – Stroke or tumor (less common)',
      'Sudden Blindness_cause_4':
          'Eye disease – Glaucoma (painful pressure) or cataracts (cloudy lens)',
      'Sudden Blindness_action_0':
          'If vision loss is gradual → Book a vet visit soon for an eye exam',
      'Sudden Blindness_action_1':
          'If vision loss is sudden (bumping into walls, not recognizing people/objects) → Vet visit ASAP! Quick treatment (especially for high blood pressure) can sometimes save vision',
      'Sudden Blindness_action_2':
          'If pupils are stuck wide open and don\'t react to light → Emergency vet visit immediately',

      'Sudden Collapse or Fainting': 'Sudden Collapse or Fainting',
      'Sudden Collapse or Fainting_description':
          'If your pet suddenly falls down and seems unconscious, even if just for a moment, it\'s always a red flag.',
      'Sudden Collapse or Fainting_cause_0':
          'Heart disease – Can cause sudden fainting or collapse',
      'Sudden Collapse or Fainting_cause_1':
          'Anemia – Low blood levels make pets weak and collapse easily',
      'Sudden Collapse or Fainting_cause_2':
          'Low blood sugar – Common in small or diabetic pets',
      'Sudden Collapse or Fainting_cause_3':
          'Heatstroke – Especially after being outside in hot weather',
      'Sudden Collapse or Fainting_cause_4':
          'Poisoning – From toxic food, medications, or chemicals',
      'Sudden Collapse or Fainting_action_0':
          'If collapse happened but your pet got up quickly → Still see a vet soon to find the cause',
      'Sudden Collapse or Fainting_action_1':
          'If collapse + pale gums, weak pulse, or trouble breathing → Emergency vet immediately!',
      'Sudden Collapse or Fainting_action_2':
          'If they were outside in heat before collapsing → Move to a cool area, offer small sips of water, and get to the vet right away',
      'Sudden Collapse or Fainting_action_3':
          'If collapse happens more than once, or your pet doesn\'t recover quickly → Emergency vet ASAP',

      'Tremors': 'Tremors (Shaking or Shivering While Awake, Not a Seizure)',
      'Tremors_description':
          'If your pet is shaking or shivering while awake (not a seizure), there could be several reasons.',
      'Tremors_cause_0':
          'Cold or fear – Cold weather, fear or stress can cause shaking',
      'Tremors_cause_1': 'Pain – From injuries, arthritis, or discomfort',
      'Tremors_cause_2':
          'Low blood sugar – More likely in small dogs or sick pets',
      'Tremors_cause_3': 'Poisoning – Chocolate, meds, or toxic products',
      'Tremors_cause_4': 'Brain or nerve problems',
      'Tremors_action_0':
          'If your pet is just cold or scared but otherwise normal → Warm them up and keep them calm',
      'Tremors_action_1':
          'If shaking comes with vomiting, drooling, or weakness → Could be poisoning → Vet immediately',
      'Tremors_action_2':
          'If shaking continues for no clear reason, or comes with pain → Vet visit recommended to check the cause',

      // Behavioral Issues
      'behavioralIssues': 'Behavioral Issues',

      'Aggression (Growling, Biting, Hissing, Snapping)':
          'Aggression (Growling, Biting, Hissing, Snapping)',
      'Aggression (Growling, Biting, Hissing, Snapping)_description':
          'If your pet suddenly becomes aggressive, they might be in pain, scared, or feeling unwell!',
      'Aggression (Growling, Biting, Hissing, Snapping)_cause_0':
          'Pain or illness (arthritis, injury, infections)',
      'Aggression (Growling, Biting, Hissing, Snapping)_cause_1':
          'Fear or past trauma (especially in rescue pets)',
      'Aggression (Growling, Biting, Hissing, Snapping)_cause_2':
          'Territorial behavior (protecting food, toys, or space)',
      'Aggression (Growling, Biting, Hissing, Snapping)_cause_3':
          'Lack of socialization (not used to people or other animals)',
      'Aggression (Growling, Biting, Hissing, Snapping)_cause_4':
          'Hormones (common in unneutered males)',
      'Aggression (Growling, Biting, Hissing, Snapping)_cause_5':
          'Rabies or neurological issues (rare, but possible — especially if unvaccinated or bit by a stray)',
      'Aggression (Growling, Biting, Hissing, Snapping)_action_0':
          'Rule out pain – If aggression is new, check for injuries and see a vet',
      'Aggression (Growling, Biting, Hissing, Snapping)_action_1':
          'Avoid punishment – This can make it worse; use calm, positive reinforcement instead',
      'Aggression (Growling, Biting, Hissing, Snapping)_action_2':
          'Give space – Don\'t force interaction if your pet seems scared or anxious',
      'Aggression (Growling, Biting, Hissing, Snapping)_action_3':
          'Consider spaying/neutering – Can help reduce hormone-related aggression',
      'Aggression (Growling, Biting, Hissing, Snapping)_action_4':
          'If aggression is sudden and extreme, and your pet is unvaccinated, or has been bitten by a stray/wild animal → See a vet immediately to rule out serious causes like rabies',

      'Excessive Meowing / Barking / Howling':
          'Excessive Meowing / Barking / Howling',
      'Excessive Meowing / Barking / Howling_description':
          'If your pet is being unusually noisy, they may be hungry, stressed, or even unwell.',
      'Excessive Meowing / Barking / Howling_cause_0':
          'Hunger or attention-seeking – Some breeds are naturally more vocal',
      'Excessive Meowing / Barking / Howling_cause_1':
          'Pain or discomfort – Crying out if something hurts',
      'Excessive Meowing / Barking / Howling_cause_2':
          'Anxiety or stress – Separation anxiety or changes at home',
      'Excessive Meowing / Barking / Howling_cause_3':
          'Mating behavior – Common in unneutered pets',
      'Excessive Meowing / Barking / Howling_action_0':
          'Check the basics → Food, water, bathroom, or playtime',
      'Excessive Meowing / Barking / Howling_action_1':
          'If the noise is new or unusual → Rule out pain with a vet check',
      'Excessive Meowing / Barking / Howling_action_2':
          'If stress-related → Create a calm, stable environment',
      'Excessive Meowing / Barking / Howling_action_3':
          'If linked to mating behavior → Talk to your vet about spaying/neutering',

      'Hiding or Avoiding People': 'Hiding or Avoiding People',
      'Hiding or Avoiding People_description':
          'If your pet suddenly hides, it\'s their way of showing something isn\'t right.',
      'Hiding or Avoiding People_cause_0':
          'Illness or pain – A very common reason for sudden hiding',
      'Hiding or Avoiding People_cause_1':
          'Fear or stress – New home, loud noises, visitors, or other pets',
      'Hiding or Avoiding People_cause_2':
          'Past trauma – Especially in rescue or abused animals',
      'Hiding or Avoiding People_cause_3':
          'Pregnancy (females) – Cats and dogs often hide before giving birth',
      'Hiding or Avoiding People_action_0':
          'If it\'s just occasional hiding → Give them space, don\'t force them out',
      'Hiding or Avoiding People_action_1':
          'If it happens with loud noises, visitors, or new changes → Likely stress; create a quiet, safe spot',
      'Hiding or Avoiding People_action_2':
          'If hiding is new and comes with less eating, grooming, or play → Vet check needed to rule out illness',
      'Hiding or Avoiding People_action_3':
          'If your female pet is unspayed and hiding with a swollen belly or nesting behavior → Could be pregnancy, monitor and prepare for birth, vet visit if unsure',

      'Eating Non-Food Items (Chewing Plastic, Cloth, Paper, or Dirt)':
          'Eating Non-Food Items (Chewing Plastic, Cloth, Paper, or Dirt)',
      'Eating Non-Food Items (Chewing Plastic, Cloth, Paper, or Dirt)_description':
          'If your pet keeps chewing or swallowing things that aren\'t food, it may point to an underlying problem.',
      'Eating Non-Food Items (Chewing Plastic, Cloth, Paper, or Dirt)_cause_0':
          'Nutritional deficiencies – Missing important vitamins or minerals',
      'Eating Non-Food Items (Chewing Plastic, Cloth, Paper, or Dirt)_cause_1':
          'Boredom or stress – Pets may chew when frustrated or anxious',
      'Eating Non-Food Items (Chewing Plastic, Cloth, Paper, or Dirt)_cause_2':
          'Teething – Puppies and kittens chew to ease gum discomfort',
      'Eating Non-Food Items (Chewing Plastic, Cloth, Paper, or Dirt)_action_0':
          'Check diet → Make sure your pet is getting balanced nutrition',
      'Eating Non-Food Items (Chewing Plastic, Cloth, Paper, or Dirt)_action_1':
          'Provide safe chew toys → Give them proper chew sticks or toys instead of random objects',
      'Eating Non-Food Items (Chewing Plastic, Cloth, Paper, or Dirt)_action_2':
          'Redirect gently → If you catch them chewing something unsafe, calmly replace it with a safe option',
      'Eating Non-Food Items (Chewing Plastic, Cloth, Paper, or Dirt)_action_3':
          'If they often eat non-food items, or swallow dangerous things → Vet check needed to rule out deficiencies or health problems',

      'Excessive Licking or Tail-Chasing': 'Excessive Licking or Tail-Chasing',
      'Excessive Licking or Tail-Chasing_description':
          'If your pet is constantly licking their paws or chasing their tail, it\'s usually more than just play.',
      'Excessive Licking or Tail-Chasing_cause_0':
          'Allergies or skin irritation – A very common reason for nonstop licking',
      'Excessive Licking or Tail-Chasing_cause_1':
          'Pain – Arthritis or joint issues can make pets lick sore spots',
      'Excessive Licking or Tail-Chasing_cause_2':
          'Anxiety or compulsive habits – Especially in high-energy or bored pets',
      'Excessive Licking or Tail-Chasing_cause_3':
          'Parasites – Fleas, ticks, or skin mites can cause nonstop itching',
      'Excessive Licking or Tail-Chasing_action_0':
          'Check for redness, sores, or swelling → Could be infection or allergy',
      'Excessive Licking or Tail-Chasing_action_1':
          'Look for fleas or ticks in the fur → Treat if found',
      'Excessive Licking or Tail-Chasing_action_2':
          'Increase play and exercise → Helps with boredom or stress',
      'Excessive Licking or Tail-Chasing_action_3':
          'If licking or tail-chasing is nonstop to the point it causes skin wounds → Vet visit needed',

      'Loss of Interest in Playing or Interacting':
          'Loss of Interest in Playing or Interacting',
      'Loss of Interest in Playing or Interacting_description':
          'If your usually playful pet suddenly isn\'t interested in play or people, it could be a sign something\'s wrong.',
      'Loss of Interest in Playing or Interacting_cause_0':
          'Pain or illness – Arthritis, dental problems, fever, or other hidden issues',
      'Loss of Interest in Playing or Interacting_cause_1':
          'Stress or depression – Big changes at home, loss of a companion',
      'Loss of Interest in Playing or Interacting_cause_2':
          'Aging – Pets often become less active and playful as they get older',
      'Loss of Interest in Playing or Interacting_action_0':
          'Watch for illness signs → Weight loss, not eating, limping, or fever → Vet visit needed',
      'Loss of Interest in Playing or Interacting_action_1':
          'Try new toys or gentle activities → Sometimes boredom or stress plays a role',
      'Loss of Interest in Playing or Interacting_action_2':
          'For senior pets → Gentle exercise, easy play, and more rest help keep them comfortable',

      // General Issues
      'generalIssues': 'General Issues',

      'Vomiting': 'Vomiting',
      'Vomiting_description':
          'A single vomit isn\'t always bad, but frequent vomiting is a warning sign!',
      'Vomiting_cause_0': 'Eating too fast or too much',
      'Vomiting_cause_1': 'Sudden diet change or spoiled food',
      'Vomiting_cause_2': 'Hairballs (especially in cats)',
      'Vomiting_cause_3': 'Parasites or stomach infections',
      'Vomiting_cause_4':
          'Poisoning (From toxic food, medications, or chemicals)',
      'Vomiting_cause_5': 'Organ disease (liver, kidneys, stomach issues)',
      'Vomiting_cause_6': 'Infection (virus or bacteria)',
      'Vomiting_action_0':
          'One-time vomit & pet seems normal → Monitor closely, offer small portions of food and water later',
      'Vomiting_action_1':
          'Repeated vomiting (more than 2–3 times in 24 hrs) → Vet visit needed',
      'Vomiting_action_2':
          'Vomiting + diarrhea in a young pet → Emergency vet immediately',
      'Vomiting_action_3':
          'Vomiting + blood, weakness, or pale gums → Emergency vet immediately (possible poisoning or serious illness)',
      'Vomiting_action_4':
          'If caused by eating too fast → Offer smaller meals in portions instead of one big meal',
      'Vomiting_action_5':
          'If vomiting once daily but persists for several days → Book a vet check to rule out chronic issues',

      'Regurgitation (Throwing Up Undigested Food)':
          'Regurgitation (Throwing Up Undigested Food)',
      'Regurgitation (Throwing Up Undigested Food)_description':
          'Vomiting and regurgitation aren\'t the same—regurgitation happens shortly after eating',
      'Regurgitation (Throwing Up Undigested Food)_cause_0':
          'Eating too fast (common in greedy eaters)',
      'Regurgitation (Throwing Up Undigested Food)_cause_1': 'Esophagus issues',
      'Regurgitation (Throwing Up Undigested Food)_cause_2':
          'Foreign object stuck',
      'Regurgitation (Throwing Up Undigested Food)_action_0':
          'If it happens rarely → Try feeding smaller portions or raising the bowl slightly',
      'Regurgitation (Throwing Up Undigested Food)_action_1':
          'If frequent or weight loss → Vet check-up needed',
      'Regurgitation (Throwing Up Undigested Food)_action_2':
          'If choking or difficulty swallowing → Emergency vet visit!',

      'Loss of Appetite': 'Loss of Appetite',
      'Loss of Appetite_description':
          'Skipping one meal isn\'t alarming, but not eating at all for 24+ hours? That\'s serious!',
      'Loss of Appetite_cause_0':
          'Stress or anxiety (new environment, new pet, loud noises)',
      'Loss of Appetite_cause_1': 'Dental pain (bad teeth, infections)',
      'Loss of Appetite_cause_2':
          'Fever, illness, or pain anywhere in the body',
      'Loss of Appetite_cause_3':
          'Serious conditions (liver/kidney failure, cancer, infections)',
      'Loss of Appetite_action_0':
          'If your pet skips one meal but eats later → Monitor, could be stress or minor stomach upset',
      'Loss of Appetite_action_1':
          'Try offering warmed food, wet food, or their favorite treat → Sometimes this encourages eating',
      'Loss of Appetite_action_2':
          'Check their mouth for broken teeth, red gums, or bad smell → Painful mouths make pets stop eating',
      'Loss of Appetite_action_3':
          'If appetite loss continues for more than 24 hours, or comes with vomiting, weakness, or weight loss → Vet visit needed',
      'Loss of Appetite_action_4':
          'If your pet refuses all food + water, or also has fever, collapse, or bloated belly → Emergency vet immediately',

      'Sudden Weight Loss or Weight Gain': 'Sudden Weight Loss or Weight Gain',
      'Sudden Weight Loss or Weight Gain_description':
          'If your pet\'s weight changes quickly without a change in diet or exercise, there may be an underlying reason.',
      'Sudden Weight Loss or Weight Gain_cause_0':
          'Weight Loss: Worms or parasites',
      'Sudden Weight Loss or Weight Gain_cause_1':
          'Weight Loss: Diabetes or thyroid problems',
      'Sudden Weight Loss or Weight Gain_cause_2':
          'Weight Loss: Chronic illness (kidney, liver, or cancer)',
      'Sudden Weight Loss or Weight Gain_cause_3':
          'Weight Loss: Poor appetite or food not being absorbed properly',
      'Sudden Weight Loss or Weight Gain_cause_4':
          'Weight Gain: Overfeeding or not enough exercise',
      'Sudden Weight Loss or Weight Gain_cause_5':
          'Weight Gain: Hormonal disorders',
      'Sudden Weight Loss or Weight Gain_cause_6':
          'Weight Gain: Fluid buildup (can be a sign of heart or liver disease)',
      'Sudden Weight Loss or Weight Gain_action_0':
          'If eating normally but losing weight → Book a routine vet check to rule out parasites, diabetes, or other illness',
      'Sudden Weight Loss or Weight Gain_action_1':
          'If appetite is poor and weight is dropping quickly → Vet visit soon, especially if it continues for more than a couple of days',
      'Sudden Weight Loss or Weight Gain_action_2':
          'If gradual weight gain with no other issues → Review food portions & exercise. Adjust diet if needed',
      'Sudden Weight Loss or Weight Gain_action_3':
          'If sudden weight gain or swollen belly → Vet check recommended (could be fluid or hormone-related)',
      'Sudden Weight Loss or Weight Gain_action_4':
          'Always check your pet\'s deworming and insect prevention dates — overdue treatments can cause weight and health changes',

      'Fever (Hot Ears, Nose, or Body)': 'Fever (Hot Ears, Nose, or Body)',
      'Fever (Hot Ears, Nose, or Body)_description':
          'If your pet feels unusually hot, it could mean fever.',
      'Fever (Hot Ears, Nose, or Body)_cause_0':
          'Infections (bacterial, viral, or fungal)',
      'Fever (Hot Ears, Nose, or Body)_cause_1':
          'Inflammation from injury or illness',
      'Fever (Hot Ears, Nose, or Body)_cause_2':
          'Serious conditions (immune diseases, poisoning, cancer)',
      'Fever (Hot Ears, Nose, or Body)_action_0':
          'Look for other signs: low energy, loss of appetite, shivering, or warm ears',
      'Fever (Hot Ears, Nose, or Body)_action_1':
          'If mild warmth but your pet is eating, drinking, and active → Monitor closely',
      'Fever (Hot Ears, Nose, or Body)_action_2':
          'If very warm + tired, not eating, or shivering → Vet check needed',
      'Fever (Hot Ears, Nose, or Body)_action_3':
          'If your pet seems weak, vomiting, or breathing fast → Vet visit ASAP',
      'Fever (Hot Ears, Nose, or Body)_action_4':
          'Never give human fever meds — they are deadly for pets!',

      'Lethargy (Weakness, Sleeping Too Much)':
          'Lethargy (Weakness, Sleeping Too Much)',
      'Lethargy (Weakness, Sleeping Too Much)_description':
          'If your normally active pet suddenly seems tired or weak, it could be anything from a lazy day to something more serious.',
      'Lethargy (Weakness, Sleeping Too Much)_cause_0':
          'Just having a lazy day (especially after lots of play or hot weather)',
      'Lethargy (Weakness, Sleeping Too Much)_cause_1':
          'Pain or discomfort (arthritis, injuries, tummy upset)',
      'Lethargy (Weakness, Sleeping Too Much)_cause_2': 'Infections or fever',
      'Lethargy (Weakness, Sleeping Too Much)_cause_3':
          'Serious conditions: poisoning, organ disease, or internal bleeding',
      'Lethargy (Weakness, Sleeping Too Much)_action_0':
          'If your pet is simply resting more than usual but still eats, drinks, and plays a bit → Probably just a lazy day, no need to worry',
      'Lethargy (Weakness, Sleeping Too Much)_action_1':
          'If lethargy comes with vomiting, diarrhea, limping, or not eating → Book a vet visit soon',
      'Lethargy (Weakness, Sleeping Too Much)_action_2':
          'If your pet is very weak, collapses, or refuses food & water → Emergency vet immediately',

      // Breathing Problems
      'breathingProblems': 'Breathing Problems',

      'Heavy Panting': 'Heavy Panting',
      'Heavy Panting_description':
          'Panting after play or heat is normal — but panting while resting, or for no reason, can be a red flag.',
      'Heavy Panting_cause_0':
          'Overheating / Heatstroke – Can happen in hot weather, inside cars, or after too much activity',
      'Heavy Panting_cause_1':
          'Flat-Faced Breeds (Bulldogs, Pugs, Frenchies, etc.) – These dogs have narrow airways, making it harder to breathe and cool down, so they pant heavily even without heat',
      'Heavy Panting_cause_2':
          'Pain or Stress – Pets may pant when they\'re uncomfortable or anxious',
      'Heavy Panting_cause_3':
          'Heart or Lung Disease – Fluid or illness can make breathing difficult',
      'Heavy Panting_cause_4':
          'Obesity – Extra weight makes it harder to cool down',
      'Heavy Panting_action_0':
          'If panting is from heat → Move them to a cool place and offer small amounts of water',
      'Heavy Panting_action_1':
          'If your dog is a flat-faced breed → Be extra cautious. Avoid hot weather, overexertion, and stressful play. If panting seems extreme, noisy, or happens even at rest → Book a vet visit',
      'Heavy Panting_action_2':
          'If your pet is panting at rest, or it comes with coughing, weakness, or restlessness → Vet visit needed',
      'Heavy Panting_action_3':
          'If panting + collapse, very pale/blue gums, or severe distress → Emergency vet immediately!',

      'Coughing': 'Coughing',
      'Coughing_description':
          'A little cough now and then is usually nothing, but frequent or harsh coughing can mean trouble!',
      'Coughing_cause_0':
          'Mild throat irritation – From dust, pulling on the leash, or excitement',
      'Coughing_cause_1':
          'Infectious cough (kennel cough) – A contagious condition that spreads easily between dogs',
      'Coughing_cause_2':
          'Heart problems – Can cause nighttime coughing or coughing after exercise',
      'Coughing_cause_3': 'Lung infection – often with fever or weakness',
      'Coughing_cause_4':
          'Allergies or asthma – Can cause ongoing coughing or wheezing',
      'Coughing_cause_5': 'Collapsed airway – causes a honking cough',
      'Coughing_action_0':
          'If the cough is rare and mild (like after running or pulling on leash) → Normal',
      'Coughing_action_1':
          'If the cough keeps coming back for more than 2 days or gets worse → Vet visit needed',
      'Coughing_action_2':
          'If coughing comes with fever, not eating, or low energy → Book a vet check soon',
      'Coughing_action_3':
          'If your pet struggles to breathe, has blue gums, or collapses → Emergency vet immediately',
      'Coughing_action_4':
          'If coughing happens right after eating or drinking → Could be a swallowing or airway issue → Vet check recommended',

      'Wheezing or Noisy Breathing': 'Wheezing or Noisy Breathing',
      'Wheezing or Noisy Breathing_description':
          'If your pet sounds like they\'re struggling for air, it could be from a blocked or narrowed airway.',
      'Wheezing or Noisy Breathing_cause_0':
          'Mild respiratory infection (like cat flu or infectious cough in dogs)',
      'Wheezing or Noisy Breathing_cause_1': 'Asthma (more common in cats)',
      'Wheezing or Noisy Breathing_cause_2':
          'Allergic reaction (swelling in the throat/airway)',
      'Wheezing or Noisy Breathing_cause_3':
          'Collapsed trachea (common in small dogs)',
      'Wheezing or Noisy Breathing_cause_4':
          'Something stuck in the throat (bone, toy, etc.)',
      'Wheezing or Noisy Breathing_cause_5':
          'Flat-faced breeds (pugs, bulldogs, etc.) → Some snorting is "normal," but sudden worsening is dangerous',
      'Wheezing or Noisy Breathing_action_0':
          'If mild and pet otherwise acts normal → Likely an infection or breed-related noise; mention it to your vet',
      'Wheezing or Noisy Breathing_action_1':
          'If noise suddenly worsens, especially with exercise or warm weather → Vet ASAP',
      'Wheezing or Noisy Breathing_action_2':
          'If struggling to breathe, gums turning blue, or pet collapses → Emergency vet immediately',
      'Wheezing or Noisy Breathing_action_3':
          'If choking on an object → Only try removing it if safe, otherwise rush to a vet',

      'Sneezing & Nasal Discharge': 'Sneezing & Nasal Discharge',
      'Sneezing & Nasal Discharge_description':
          'An occasional sneeze is normal, but constant sneezing or unusual nose discharge needs attention.',
      'Sneezing & Nasal Discharge_cause_0':
          'Allergies – Dust, pollen, smoke, perfumes, or cleaning sprays',
      'Sneezing & Nasal Discharge_cause_1': 'Respiratory infection',
      'Sneezing & Nasal Discharge_cause_2':
          'Foreign object in the nose – Grass, seeds, or dirt',
      'Sneezing & Nasal Discharge_cause_3':
          'Dental disease – Infections in the upper teeth can spread to the nose',
      'Sneezing & Nasal Discharge_action_0':
          'A few sneezes, no discharge → Likely dust or irritation, nothing to worry about',
      'Sneezing & Nasal Discharge_action_1':
          'Clear watery discharge that keeps happening → Could be allergies; try removing smoke, perfume, or sprays',
      'Sneezing & Nasal Discharge_action_2':
          'Thick yellow/green discharge → Likely infection → Vet check needed',
      'Sneezing & Nasal Discharge_action_3':
          'Sneezing fits + pawing at nose → Something stuck → Vet ASAP',

      'Open-Mouth Breathing in Cats': 'Open-Mouth Breathing in Cats',
      'Open-Mouth Breathing in Cats_description':
          'Mouth breathing in cats can happen from stress or heat, but it can also mean breathing trouble.',
      'Open-Mouth Breathing in Cats_cause_0':
          'Heat or stress (after play, travel, or car rides)',
      'Open-Mouth Breathing in Cats_cause_1': 'Heart or lung problems',
      'Open-Mouth Breathing in Cats_cause_2': 'Asthma or airway issues',
      'Open-Mouth Breathing in Cats_cause_3': 'Fluid buildup in the chest',
      'Open-Mouth Breathing in Cats_action_0':
          'If it happens after play, heat, or travel → Let your cat rest in a cool, quiet spot and monitor',
      'Open-Mouth Breathing in Cats_action_1':
          'If it continues while resting, or your cat seems tired, drools, or breathes with effort → Vet check as soon as possible',
      'Open-Mouth Breathing in Cats_action_2':
          'If mouth breathing starts suddenly and doesn\'t stop → Emergency vet visit',

      'Gasping for Air / Struggling to Breathe':
          'Gasping for Air / Struggling to Breathe',
      'Gasping for Air / Struggling to Breathe_description':
          'If your pet can\'t breathe properly, it\'s an emergency. Don\'t wait!',
      'Gasping for Air / Struggling to Breathe_cause_0':
          'Severe allergic reaction (swollen throat!)',
      'Gasping for Air / Struggling to Breathe_cause_1':
          'Choking on food or a foreign object',
      'Gasping for Air / Struggling to Breathe_cause_2':
          'Collapsed lung or fluid in the chest',
      'Gasping for Air / Struggling to Breathe_cause_3': 'Heart diseases',
      'Gasping for Air / Struggling to Breathe_action_0':
          'Check their gums or tongue → if they look blue or pale → Emergency vet immediately!',
      'Gasping for Air / Struggling to Breathe_action_1':
          'If your pet is drooling, breathing heavily, or clearly struggling to get air → RUSH to the vet!',

      'Choking': 'Choking',
      'Choking_description':
          'If your pet suddenly starts gagging, coughing, or pawing at their mouth, something might be stuck.',
      'Choking_cause_0': 'Food or treats swallowed too fast',
      'Choking_cause_1': 'Toys, bones, or foreign objects',
      'Choking_cause_2': 'Hair or string stuck in the throat',
      'Choking_action_0':
          'If your pet is coughing or gagging but still breathing → Stay calm and observe — many pets clear it on their own',
      'Choking_action_1':
          'If your pet can\'t breathe or collapses → Emergency! Go to the vet immediately',

      // Emergency levels
      'urgent': 'Urgent',
      'moderate': 'Moderate',
      'mild': 'Mild',

      // 3D Viewer gesture hints
      'swipeToRotate': 'Swipe to Rotate',
      'tapBodyPartToExplore': 'Tap on body parts to explore symptoms',
      'searchSymptoms': 'Search symptoms...',

      // Actions and causes (add more specific ones as needed)
      'dustWindAllergies': 'Dust, wind, or allergies',
      'infectionBacteriaHerpes': 'Infection (like bacteria or herpes virus)',
      'highEyePressure': 'High eye pressure (glaucoma)',
      'injuryIrritation': 'Injury or irritation',
      'mildRinseSalineMonitor': 'If mild → Rinse with saline & monitor',
      'swellingSquintingDischargeVet':
          'If the eye is swollen, squinting, has discharge, or your pet is pawing at it → Vet visit ASAP',
      'normalInSomeBreeds': 'Normal in some breeds (like Persians)',
      'allergiesMildIrritation': 'Allergies or mild irritation',
      'infectionYellowGreen': 'Infection (yellow/green goop)',
      'linkedToWormsInSomeCases': 'Could be linked to worms in some cases',
      'clearLightGoopWipeMonitor':
          'If clear or light goop, and your pet seems fine → Wipe it away & monitor',
      'thickYellowGreenVetCheck':
          'If thick, yellow, or green → Vet check recommended',
      'selectPetType': 'Select Pet Type',
      'choosePetModelToViewAnatomy': 'Choose a pet model to view anatomy',
      'dog': 'Dog',
      'cat': 'Cat',
      'dogModel': 'Dog Model',
      'catModel': 'Cat Model',
      'viewDogAnatomy': 'View Dog Anatomy',
      'viewCatAnatomy': 'View Cat Anatomy',
      'openModel': 'Open Model',
      'use3DModelToIdentifySymptoms':
          'Use the 3D model to identify symptoms and explore pet anatomy. Tap on different body parts to learn more.',
      'viewPetAnatomy': 'View {petType} Anatomy',

      // Pet form fields
      'petGender': 'Gender',
      'male': 'Male',
      'female': 'Female',
      'petWeight': 'Weight (kg)',
      'enterPetWeight': 'Enter pet weight',
      'petAllergies': 'Allergies',
      'addAllergy': 'Add allergy (e.g., chicken, dairy)',
      'spayedNeutered': 'Spayed/Neutered',
      'petNotes': 'Notes',
      'additionalPetInfo': 'Any additional information about your pet',

      // QR Code scanning
      'scanQrCode': 'Scan QR Code',
      'scanVetQrCodeToComplete': 'Scan Vet QR Code to Complete',
      'pointCameraAtQrCode': 'Point your camera at the QR code',
      'appointmentCompletedSuccessfully': 'Appointment completed successfully',
      'scanQrToComplete': 'Scan QR to Complete',

      // Notifications
      'Notifications': 'Notifications',
      'Mark all as read': 'Mark all as read',
      'new': 'new',
      'No notifications yet': 'No notifications yet',
      'We\'ll notify you when something arrives': 'We\'ll notify you when something arrives',
      'Notification deleted': 'Notification deleted',
      'Just now': 'Just now',
      'm ago': '@count min ago',
      'h ago': '@count hr ago',
      'd ago': '@count day ago',

      // Medical Records
      'medicalRecords': 'Medical Records',
      'medicalDetails': 'Medical Details',
      'latestRecord': 'Latest Record',
      'viewAllRecords': 'View All Records',
      'noMedicalRecordsYet': 'No medical records yet',
      'logHealthEvent': 'Add Medical Record',
      'selectRecordType': 'SELECT RECORD TYPE',
      'commonSymptoms': 'COMMON SYMPTOMS',
      'customSymptom': 'CUSTOM SYMPTOM',
      'nameType': 'NAME / TYPE',
      'dateOfEvent': 'DATE OF EVENT',
      'locationProvider': 'LOCATION / PROVIDER',
      'eventDetails': 'EVENT DETAILS',
      'attachments': 'ATTACHMENTS',
      'saveRecord': 'Save Record',
      'medicationName': 'MEDICATION NAME',
      'dosage': 'DOSAGE',
      'vaccineTypeLabel': 'VACCINE TYPE',
      'category': 'CATEGORY',
      'visitType': 'VISIT TYPE',
      'testType': 'TEST TYPE',
      'procedureName': 'PROCEDURE NAME',
      'title': 'TITLE',
      'uploadImages': 'Upload images',
      'recordCreatedSuccessfully': 'Medical record created successfully',
      'inputRequired': 'Input Required',
      'selectSymptomPrompt': 'Please select at least one symptom or enter a custom one.',
      'limitReached': 'Limit Reached',
      'attachLimitMsg': 'You can only attach up to 10 files.',
      'medication': 'Medication',
      'visit': 'Visit',
      'lab': 'Lab',
      'surgeryLabel': 'Surgery',
      'event': 'Event',
      'note': 'Note',
      // Store
      'aleefyStore': 'Aleefy Store',
      'noProductsFound': 'No products found',
      'failedToLoadProducts': 'Failed to load products',
      'myCart': 'My Cart',
      'cartEmpty': 'Cart empty ...',
      'cartEmptyMessage': 'Add products from the store to get started',
      'browseStore': 'Browse Store',
      'selectDeliveryMethod': 'Select delivery method',
      'delivery': 'Delivery',
      'shipping': 'Shipping',
      'deliveredToAddress': 'Delivered to your address',
      'pickUp': 'Pick Up',
      'pickUpFromStore': 'Pick up your order from the store',
      'noDeliveryAddress': 'No delivery address yet',
      'addFirstAddressMessage': "Add your first address so we know where to deliver your pet's goodies",
      'addAddress': 'Add Address',
      'addAnotherAddress': 'Add another address?',
      'saveAddress': 'Save Address',
      'country': 'Country',
      'city': 'City',
      'addressLine1': 'Address Line 1',
      'addressLine2Optional': 'Address Line 2 (optional)',
      'postalCodeOptional': 'Postal Code (optional)',
      'fieldRequired': 'This field is required',
      'scheduleOrder': 'Schedule Order',
      'whenDelivered': 'When would you like your order delivered?',
      'schedule': 'Schedule',
      'availableHours': 'Available Hours',
      'availableDate': 'Available Date',
      'noSlotsToday': 'No slots available for today.',
      'checkout': 'Checkout',
      'deliverTo': 'Deliver to',
      'deliveryTime': 'Delivery time',
      'cashOnDelivery': 'Cash On Delivery',
      'vodafoneCash': 'Vodafone Cash',
      'instaPay': 'InstaPay',
      'subtotal': 'Subtotal',
      'shippingFee': 'Shipping Fee',
      'totalAmount': 'Total Amount',
      'inclusiveOfVat': 'Inclusive Of VAT',
      'promoCodeHint': 'Do you have a promo code?',
      'orderNotes': 'Order Notes',
      'payNow': 'Pay Now',
      'orderPlaced': 'Order Placed!',
      'pricesChanged': 'Some prices changed since you added items to cart.',
      'uploadPaymentProof': 'Upload Payment Proof',
      'trackOrder': 'Track Order',
      'backToHome': 'Back to Home',
      'myOrders': 'My Orders',
      'noOrdersYet': 'No orders yet',
      'orderDetail': 'Order Detail',
      'shippingAddress': 'Shipping Address',
      'track': 'Track',
      'uploadProof': 'Upload Proof',
      'confirmDelivery': 'Confirm Delivery',
      'orderNotFound': 'Order not found',
      'orderTracking': 'Order Tracking',
      'noTrackingInfo': 'No tracking information yet.',
      'paymentProof': 'Payment Proof',
      'uploadPaymentScreenshots': 'Upload your payment screenshot(s)',
      'oneToFiveImages': '1 to 5 images',
      'maxFiveImages': 'You can upload up to 5 images.',
      'submitProof': 'Submit Proof',
      'options': 'Options',
      'relatedProducts': 'Related Products',
      'inStock': 'In Stock',
      'outOfStock': 'Out of Stock',
      'addToCart': 'Add to Cart',
      'addedToCart': 'Added to Cart ✓',
      'readMore': 'Read more',
      'showLess': 'Show less',
      'productNotFound': 'Product not found',
      'yourRating': 'Your Rating',
      'reviewTitle': 'Review Title',
      'reviewTitleHint': 'e.g. Great product!',
      'reviewBodyOptional': 'Review Body (optional)',
      'orderStatusPending': 'Pending',
      'orderStatusConfirmed': 'Confirmed',
      'orderStatusProcessing': 'Processing',
      'orderStatusShipped': 'Shipped',
      'orderStatusDelivered': 'Delivered',
      'orderStatusCancelled': 'Cancelled',
      'paymentStatusPaid': 'Paid',
      'paymentStatusFailed': 'Failed',
      'paymentStatusRefunded': 'Refunded',
      'subtotalItems': 'Subtotal ({count} Items)',
      'writeAReview': 'Write a Review',
      'shareExperienceHint': 'Share your experience...',
      'qty': 'Qty',
      'total': 'Total',
      'all': 'All',
      'notesHint': 'Notes',
      'myFavorites': 'My Favorites',
      'myAddresses': 'My Addresses',
      'noSavedAddresses': 'No saved addresses',
      'deleteAddress': 'Delete Address',
      'setAsDefault': 'Set as Default',
      'defaultLabel': 'Default',
      'noFavoriteProducts': 'No favorite products yet',
      'favoriteProductsDesc': 'Tap the heart icon on any product to save it here',
    },
    'ar': {
      'appTitle': 'أليفي',
      'home': 'الرئيسية',
      'myActivity': 'نشاطي',
      'profile': 'الملف الشخصي',
      'settings': 'الإعدادات',
      'appearance': 'المظهر',
      'language': 'اللغة',
      'notifications': 'الإشعارات',
      'privacySecurity': 'الخصوصية والأمان',
      'about': 'حول',
      'lightMode': 'الوضع الفاتح',
      'darkMode': 'الوضع الداكن',
      'systemDefault': 'إعدادات النظام',
      'useLightTheme': 'استخدم المظهر الفاتح',
      'useDarkTheme': 'استخدم المظهر الداكن',
      'useSystemTheme': 'اتبع إعدادات النظام',
      'english': 'English',
      'arabic': 'العربية',
      'useEnglish': 'Use English language',
      'useArabic': 'استخدم اللغة العربية',
      'pushNotifications': 'إشعارات فورية',
      'emailNotifications': 'إشعارات البريد الإلكتروني',
      'sound': 'الصوت',
      'privacyPolicy': 'سياسة الخصوصية',
      'termsOfService': 'شروط الخدمة',
      'deleteAccount': 'حذف الحساب',
      'appVersion': 'إصدار التطبيق',
      'contactSupport': 'اتصل بالدعم',
      'rateApp': 'قيم التطبيق',
      'myProfile': 'ملفي الشخصي',
      'myPets': 'حيواناتي الأليفة',
      'appointments': 'المواعيد',
      'favorites': 'المفضلة',
      'support': 'الدعم',
      'logout': 'تسجيل الخروج',
      'confirmLogout': 'هل أنت متأكد أنك تريد تسجيل الخروج؟',
      'yes': 'نعم',
      'no': 'لا',
      'cancel': 'إلغاء',
      'confirm': 'تأكيد',

      // Onboarding screen translations
      'skip': 'تخطي',
      'skipLogin': 'تخطي تسجيل الدخول',
      'skipSignup': 'تخطي التسجيل',
      'welcomeToAleefy': 'مرحبًا بك في أليفي',
      'onboardingSubtitle1': 'أبسط طريقة للعناية بحيوانك الأليف، كل يوم.',
      'checkAndBookInSeconds': 'تحقق واحجز في ثوانٍ',
      'onboardingSubtitle2': 'راجع الأعراض الشائعة، وابحث عن العيادات القريبة، واحجز مكانًا على الفور — بدون غرف انتظار، بدون متاعب.',
      'exclusiveBenefits': 'مزايا حصرية لحيوانك الأليف',
      'onboardingSubtitle3': 'احصل على فحوصات مجانية، وعروض العناية، وخصومات خاصة للعيادات — فقط على أليفي.',

      // Auth screen translations
      'welcomeBack': 'مرحبًا بعودتك',
      'loginToAccount': 'تسجيل الدخول إلى حسابك',
      'rememberMe': 'تذكرني',
      'forgotPassword': 'نسيت كلمة المرور؟',
      'orContinueWith': 'أو متابعة باستخدام',

      // Forgot Password screen translations
      'resetYourPassword': 'إعادة تعيين كلمة المرور',
      'enterRegisteredEmail': 'أدخل بريدك الإلكتروني المسجل لتلقي رمز التحقق',
      'sendVerificationCode': 'إرسال رمز التحقق',
      'codeSent': 'تم إرسال الرمز',
      'verificationCodeSentTo': 'تم إرسال رمز التحقق إلى {email}',
      'failedToSendCode': 'فشل في إرسال رمز التحقق',
      'noAccountFoundWithEmail':
          'لم يتم العثور على حساب بهذا البريد الإلكتروني. يرجى التحقق من بريدك الإلكتروني أو إنشاء حساب جديد.',
      'pleaseEnterEmail': 'الرجاء إدخال بريدك الإلكتروني',
      'pleaseEnterValidEmail': 'الرجاء إدخال بريد إلكتروني صحيح',

      // Enter Verification Code screen translations
      'enterVerificationCode': 'أدخل رمز التحقق',
      'verificationCodeSentToEmail': 'لقد أرسلنا رمز التحقق إلى {email}',
      'pleaseEnterAll6Digits': 'الرجاء إدخال جميع الأرقام الستة للرمز',
      'verificationCodeExpired': 'انتهت صلاحية رمز التحقق. يرجى طلب رمز جديد.',
      'invalidVerificationCode': 'رمز تحقق غير صالح. يرجى المحاولة مرة أخرى.',
      'errorVerifyingCode': 'خطأ في التحقق من الرمز',
      'newCodeSent': 'تم إرسال الرمز',
      'newVerificationCodeSentTo': 'تم إرسال رمز تحقق جديد إلى {email}',
      'failedToResendCode': 'فشل في إعادة إرسال الرمز. يرجى المحاولة مرة أخرى.',
      'verifyCode': 'تحقق من الرمز',
      'resendCode': 'إعادة إرسال الرمز',
      'didntReceiveCode': 'لم تتلق الرمز؟',

      // Email Verification screen translations
      'verifyYourEmail': 'تحقق من بريدك الإلكتروني',
      'enterThe6DigitCodeSentTo':
          'أدخل الرمز المكون من ٦ أرقام المرسل إلى {email}',
      'emailVerifiedSuccessfully': 'تم التحقق من البريد الإلكتروني بنجاح!',
      'youCanNowContinueToTheApp': 'يمكنك الآن المتابعة إلى التطبيق',
      'continueText': 'متابعة',
      'verify': 'تحقق',
      'verificationFailed': 'فشل التحقق',
      'invalidOrExpiredCode':
          'رمز غير صالح أو منتهي الصلاحية. يرجى المحاولة مرة أخرى.',
      'seconds': 'ث',

      // Create New Password screen translations
      'createNewPassword': 'إنشاء كلمة مرور جديدة',
      'newPasswordMustBeDifferent':
          'يجب أن تكون كلمة المرور الجديدة مختلفة عن كلمات المرور المستخدمة سابقًا',
      'atLeast6Characters': 'على الأقل 6 أحرف',
      'containsANumber': 'يحتوي على رقم',
      'containsAnUppercaseLetter': 'يحتوي على حرف كبير',
      'newPassword': 'كلمة المرور الجديدة',
      'confirmPassword': 'تأكيد كلمة المرور',
      'pleaseEnterPassword': 'الرجاء إدخال كلمة المرور',
      'passwordMustBeAtLeast6Characters':
          'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل',
      'passwordMustContainUppercase':
          'يجب أن تحتوي كلمة المرور على حرف كبير واحد على الأقل',
      'passwordMustContainNumber':
          'يجب أن تحتوي كلمة المرور على رقم واحد على الأقل',
      'pleaseConfirmPassword': 'الرجاء تأكيد كلمة المرور',
      'passwordsDoNotMatch': 'كلمتا المرور غير متطابقتين',
      'resetPassword': 'إعادة تعيين كلمة المرور',
      'passwordResetSuccessfully': 'تم إعادة تعيين كلمة المرور بنجاح!',
      'passwordChangedMessage':
          'تم تغيير كلمة المرور الخاصة بك. يرجى استخدام كلمة المرور الجديدة لتسجيل الدخول.',
      'loginNow': 'تسجيل الدخول الآن',
      'failedToResetPassword':
          'فشل في إعادة تعيين كلمة المرور. يرجى المحاولة مرة أخرى.',

      // Account Details screen translations
      'personalInformation': 'المعلومات الشخصية',
      'security': 'الأمان',
      'changePassword': 'تغيير كلمة المرور',
      'currentPassword': 'كلمة المرور الحالية',
      'enterCurrentPasswordPrompt':
          'أدخل كلمة المرور الحالية واختر كلمة مرور جديدة',

      'signInWithGoogle': 'تسجيل الدخول باستخدام Google',
      'signInWithApple': 'تسجيل الدخول باستخدام Apple',
      'signUpWithGoogle': 'التسجيل باستخدام Google',
      'signUpWithApple': 'التسجيل باستخدام Apple',
      'dontHaveAccount': 'ليس لديك حساب؟',
      'wrongCredentials': 'بريد إلكتروني أو كلمة مرور خاطئة',
      'emailNotVerified': 'البريد الإلكتروني غير مؤكد',
      'pleaseVerifyYourEmail': 'يرجى تأكيد بريدك الإلكتروني للمتابعة',
      // Signup screen translations
      'createAccount': 'إنشاء حسابك',
      'accountCreationSubtitle': 'املأ بياناتك لإنشاء حسابك',
      'fullName': 'الاسم الكامل',
      'firstName': 'الاسم الأول',
      'lastName': 'اسم العائلة',
      'phoneNumber': 'رقم الهاتف',
      'alreadyHaveAccount': 'هل لديك حساب بالفعل؟',
      'termsAndConditionsAgreement': 'بالتسجيل فإنك توافق على',
      'termsAndConditions': 'الشروط والأحكام',
      'and': 'و',
      'registrationSuccessful': 'تم التسجيل بنجاح',
      'pleaseVerifyEmail': 'يرجى التحقق من بريدك الإلكتروني للمتابعة',
      'registrationFailed': 'فشل التسجيل',
      'confirmDeleteAccount':
          'هل أنت متأكد أنك تريد حذف حسابك؟ لا يمكن التراجع عن هذا الإجراء.',
      'vetVisit': 'زيارة العيادة',
      'animalView3D': 'كاشف الأعراض',
      'virtualVet': 'طبيب بيطري افتراضي',
      'searchPlaceholder': 'البحث عن عيادات، خدمات...',
      'redeemAndSave': 'استبدال ووفر',
      'viewHistory': 'عرض السجل',
      'pointsAvailable': 'النقاط المتاحة',
      'redeemNow': 'استبدل الآن',
      'vouchers': 'القسائم',
      'nearYou': 'بالقرب منك',
      'seeAll': 'عرض الكل',
      'myAccount': 'حسابي',
      'followUs': 'تابعنا',
      'welcome': 'مرحبًا',
      'signIn': 'تسجيل الدخول',
      'signUp': 'اشتراك',
      'receivePushNotifications': 'استقبال إشعارات فورية',
      'receiveEmailUpdates': 'استقبال إشعارات البريد الإلكتروني',
      'playSoundForNotifications': 'تشغيل صوت الإشعار',
      'readOurPrivacyPolicy': 'اقرأ سياسة الخصوصية',
      'readOurTermsOfService': 'اقرأ شروط الخدمة',
      'deleteYourAccountPermanently': 'حذف حسابك نهائيا',
      'deleteAccountRecoveryNote': 'يمكن التراجع عن هذا الإجراء خلال 30 يوماً عن طريق التواصل مع الدعم.',
      'deletingAccount': 'جاري حذف حسابك...',
      'accountDeletedSuccessfully': 'تم حذف حسابك بنجاح',
      'failedToDeleteAccount': 'فشل حذف الحساب. يرجى المحاولة مرة أخرى.',
      'myVouchers': 'قسائمي',
      'available': 'متاحة',
      'used': 'مستخدمة',
      'expired': 'منتهية الصلاحية',
      'gotAVoucher': 'هل لديك قسيمة؟',
      'addVoucher': 'إضافة قسيمة',
      'enterVoucherCode': 'أدخل رمز القسيمة',
      'enterYourVoucherCode': 'أدخل رمز القسيمة الخاص بك',
      'pleaseEnterVoucherCode': 'يرجى إدخال رمز القسيمة',
      'validatingVoucherCode': 'التحقق من رمز القسيمة: {code}',
      'voucherAddedSuccessfully': 'تمت إضافة القسيمة "{code}" بنجاح!',
      'invalidVoucherCode': 'رمز القسيمة غير صالح: "{code}"',
      'voucherHelpText': 'أدخل رمز القسيمة الذي تلقيته من عليفي أو شركائنا',
      'errorOpeningAccountDetails': 'خطأ في فتح تفاصيل الحساب',
      'aleefyPoints': 'نقاط أليفي',
      'retry': 'إعادة المحاولة',
      'view': 'عرض',
      'pointsHistory': 'سجل النقاط',

      // Additional Points Translations
      'errorLoadingPoints': 'خطأ في تحميل النقاط',
      'errorLoadingMore': 'خطأ في تحميل المزيد من المعاملات',
      'currentBalance': 'الرصيد الحالي',
      'totalEarned': 'إجمالي المكتسب',
      'totalSpent': 'إجمالي المصروف',
      'transactionHistory': 'سجل المعاملات',
      'noTransactions': 'لا توجد معاملات بعد',
      'noPointsAvailable': 'لا توجد نقاط متاحة',
      'noPointsMessage':
          'ليس لديك أي نقاط للاستخدام حتى الآن. ابدأ باستخدام خدماتنا لكسب النقاط!',
      'failedToLoadTimeSlots': 'فشل تحميل الأوقات المتاحة',
      'failedToValidatePoints': 'فشل التحقق من النقاط',
      'pointsValidatedSuccessfully': 'تم التحقق من النقاط بنجاح',
      'invalidPointsAmount': 'عدد النقاط غير صالح',

      'loginRequired': 'تسجيل الدخول مطلوب',
      'loginRequiredMessage': 'يجب تسجيل الدخول للوصول إلى هذه الميزة.',
      'leaveAReview': 'اترك تقييماً',
      'howWasYourExperience': 'كيف كانت تجربتك؟',
      'shareYourExperience': 'شارك تجربتك',
      'tellUsAboutExperience':
          'أخبرنا عن تجربتك مع الطبيب البيطري والخدمة المقدمة...',
      'submitReview': 'إرسال التقييم',
      'pleaseSelectRating': 'يرجى اختيار التقييم',
      'pleaseEnterReviewComment': 'يرجى إدخال تعليق التقييم',
      'reviewSubmittedSuccessfully': 'تم إرسال التقييم بنجاح!',
      'veterinaryClinic': 'عيادة بيطرية',
      'rating': 'التقييم',
      'ratingPoor': 'ضعيف',
      'ratingFair': 'مقبول',
      'ratingGood': 'جيد',
      'ratingVeryGood': 'جيد جداً',
      'ratingExcellent': 'ممتاز',
      'appointment': 'موعد',
      'deleteAccountConfirmation':
          'هل أنت متأكد من حذف حسابك؟ لا يمكن التراجع عن هذا الإجراء وسيتم فقدان جميع بياناتك بشكل دائم.',
      'accountDetailsUpdatedSuccessfully': 'تم تحديث تفاصيل الحساب بنجاح!',
      'failedToUpdateProfile': 'فشل تحديث الملف الشخصي: {error}',
      'voucherCodeCopied': 'تم نسخ رمز القسيمة "{code}" إلى الحافظة',

      // Pet-related translations
      'loginRequiredToAddPets': 'يجب تسجيل الدخول لإضافة الحيوانات الأليفة.',
      'loginRequiredToUpdatePets': 'يجب تسجيل الدخول لتحديث الحيوانات الأليفة.',
      'chooseFromGallery': 'اختر من المعرض',
      'takeAPhoto': 'التقط صورة',
      'addYourFirstPet': 'أضف حيوانك الأليف الأول',
      'deleting': 'جاري الحذف...',
      'refreshPets': 'تحديث الحيوانات الأليفة',
      'errorLoadingPets': 'خطأ في تحميل الحيوانات الأليفة',
      'noPetsAddedYet': 'لم تتم إضافة حيوانات أليفة بعد',
      'addYourFurryFriends':
          'أضف أصدقاءك من الحيوانات الأليفة لتتبع صحتهم ومواعيدهم',
      'yearOld': 'سنة',
      'yearsOld': 'سنوات',
      'monthOld': 'شهر',
      'monthsOld': 'أشهر',
      'choosePhoto': 'اختر صورة',
      'camera': 'الكاميرا',
      'gallery': 'المعرض',
      'invalidSpecies': 'نوع غير صالح',
      'onlyCatsAndDogsAllowed': 'يُسمح فقط بالقطط والكلاب.',
      'failedToUpdatePet': 'فشل تحديث الحيوان الأليف. يرجى المحاولة مرة أخرى.',
      'birthday': 'تاريخ الميلاد',
      'species': 'النوع',
      'gender': 'الجنس',
      'notSpayedNeutered': 'غير مخصي/معقم',
      'addNewPet': 'إضافة حيوان أليف جديد',
      'petName': 'اسم الحيوان الأليف',
      'enterPetName': 'أدخل اسم حيوانك الأليف',
      'pleaseEnterPetName': 'يرجى إدخال اسم حيوانك الأليف',
      'petType': 'نوع الحيوان الأليف',
      'birthdate': 'تاريخ الميلاد',
      'age': 'العمر',
      'enterPetAge': 'أدخل عمر حيوانك الأليف',
      'days': 'أيام',
      'months': 'أشهر',
      'years': 'سنوات',
      'pleaseEnterValidAge': 'يرجى إدخال عمر صالح',
      'weightKg': 'الوزن (كجم)',
      'kg': 'كجم',
      'allergies': 'الحساسية',
      'addNotes': 'أي معلومات إضافية عن حيوانك الأليف',
      'spayedNeuteredQuestion': 'مخصي/معقم؟',
      'savePet': 'حفظ الحيوان الأليف',
      'saveChanges': 'حفظ التغييرات',
      'petAddedSuccessfully': 'تمت إضافة {name} بنجاح.',
      'failedToAddPet': 'فشل إضافة الحيوان الأليف. يرجى المحاولة مرة أخرى.',
      'petProfile': 'ملف الحيوان الأليف',
      'submit': 'إرسال',
      'completeProfile': 'إكمال الملف الشخصي',
      'completeProfileSubtitle': 'نحتاج إلى بعض التفاصيل الإضافية لإعداد حسابك.',
      'justAFewMoreDetails': 'فقط بضع تفاصيل أخرى',
      'enterFullName': 'أدخل اسمك الكامل',
      'nameRequired': 'الاسم مطلوب',
      'fullNameRequired': 'يرجى إدخال اسمك الكامل (الاسم الأول واسم العائلة)',
      'profileUpdatedSuccessfully': 'تم تحديث الملف الشخصي بنجاح!',
      'editPet': 'تعديل الحيوان الأليف',
      'confirmDelete': 'تأكيد الحذف',
      'areYouSureDeletePet': 'هل أنت متأكد أنك تريد حذف هذا الحيوان الأليف؟',
      'thisActionCannotBeUndone': 'لا يمكن التراجع عن هذا الإجراء.',
      'updatePet': 'تحديث الحيوان الأليف',
      'weight': 'الوزن',
      'lastVetVisit': 'آخر زيارة للطبيب البيطري',
      'addVaccination': 'إضافة تطعيم',
      'petUpdatedSuccessfully': 'تم تحديث {name} بنجاح.',
      'info': 'معلومات',
      'noChangesToUpdate': 'لا توجد تغييرات للتحديث',

      // Vaccination Strings (Arabic)
      'vaccinationRecord': 'سجل التطعيمات',
      'addVaccine': 'إضافة تطعيم',
      'viewAll': 'عرض الكل',
      'virusVaccines': 'لقاحات الفيروسات',
      'wormsVaccines': 'الديدان',
      'insectsVaccines': 'الحشرات',
      'rabiesVaccines': 'السعار',
      'monovalent': 'أحادي',
      'bivalent': 'ثنائي',
      'trivalent': 'ثلاثي',
      'quadrivalent': 'رباعي',
      'pentavalent': 'خماسي',
      'hexavalent': 'سداسي',
      'heptavalent': 'سباعي',
      'octavalent': 'ثماني',
      'deworming': 'علاج الديدان',
      'antiInsects': 'مضاد الحشرات',
      'rabies': 'السعار',
      'vaccineType': 'نوع اللقاح',
      'vaccinationDate': 'تاريخ التطعيم',
      'administeredDoses': 'الجرعات المعطاة',
      'addAnotherDose': 'إضافة جرعة أخرى',
      'maximumDosesReached': 'تم الوصول إلى الحد الأقصى للجرعات',
      'maximumReached': 'تم الوصول للحد الأقصى',
      'thisVaccineRequiresOnly1Dose': 'هذا اللقاح يتطلب جرعة واحدة فقط',
      'thisVaccineRequiresOnly2Doses': 'هذا اللقاح يتطلب جرعتين فقط',
      'youCanOnlyAddUpTo3Doses': 'يمكنك إضافة 3 جرعات كحد أقصى',
      'pleaseSelectVaccineType': 'يرجى اختيار نوع اللقاح',
      'pleaseAddAtLeastOneDose': 'يرجى إضافة جرعة واحدة على الأقل',
      'vaccinationAddedSuccessfully': 'تمت إضافة التطعيم بنجاح',
      'dateAdministered': 'تاريخ الإعطاء',
      'removeDose': 'إزالة الجرعة',
      'dose': 'جرعة',
      'completedDoses': 'جرعات مكتملة',
      'vaccine': 'لقاح',
      'vaccines': 'لقاحات',
      'noPetsFound': 'لا توجد حيوانات أليفة',
      'addPetToViewVaccination': 'أضف حيوان أليف لعرض سجلات التطعيم',
      'selectPetToViewVaccination': 'اختر حيوان أليف لعرض سجلات التطعيم',
      'viewRecord': 'عرض السجل',
      'failedToLoadRewardsData': 'فشل تحميل بيانات المكافآت',
      'areYouSureYouWantToLogout': 'هل أنت متأكد أنك تريد تسجيل الخروج؟',
      'loggedOutSuccessfully': 'تم تسجيل الخروج بنجاح',
      'logoutFailed': 'فشل تسجيل الخروج. يرجى المحاولة مرة أخرى.',
      'virusVaccineMissing': 'لقاح الفيروسات مفقود',
      'virusVaccineMissingMessage':
          'حيوانك الأليف يحتاج إلى حماية من الفيروسات. ابدأ سلسلة اللقاحات قريباً للحماية من الأمراض.',
      'wormTreatmentMissing': 'علاج الديدان مفقود',
      'wormTreatmentMissingMessage':
          'حيوانك الأليف يحتاج إلى علاج طارد للديدان. جرعتان فقط مطلوبتان للوقاية من الطفيليات.',
      'insectProtectionMissing': 'الحماية من الحشرات مفقودة',
      'insectProtectionMissingMessage':
          'حيوانك الأليف يحتاج إلى حماية من البراغيث والقراد. جرعة واحدة فقط مطلوبة لمنع الإصابة.',
      'rabiesVaccineMissing': 'لقاح السعار مفقود',
      'rabiesVaccineMissingMessage':
          'حيوانك الأليف يحتاج إلى الحماية من السعار. جرعة واحدة فقط مطلوبة. هذا اللقاح ضروري لسلامة حيوانك الأليف.',
      'noVaccinationRecords': 'لا توجد سجلات تطعيم',
      'addYourPetsFirstVaccine': 'أضف أول لقاح لحيوانك الأليف للبدء',
      'vaccinationRecords': 'سجلات التطعيم',
      'annualBoosters': 'الجرعات التنشيطية',
      'markAsComplete': 'تحديد كمكتمل',
      'markComplete': 'تحديد',
      'notYetAdministered': 'لم يتم إعطاؤها بعد',
      'doseMarkedComplete': '✓ تم تحديد الجرعة كمكتملة!',
      'boosterMarkedComplete': '✓ تم تحديد الجرعة التنشيطية كمكتملة!',
      'boosterMarkedCompleteWithNextScheduled':
          '✓ اكتملت الجرعة التنشيطية! تم جدولة الجرعة التنشيطية التالية تلقائياً.',
      'viewSchedule': 'عرض',
      'nextDose': 'الجرعة التالية',
      'protectionActive': 'أليفك محمي، كرّر العلاج في معاده',
      'protectedFromRabies': 'أليفك في أمان، طعّمه مرة كل سنة',
      'notProtectedFromFleasOrTicks':
          'أليفك مش محمي من البراغيث و القراد، اديلو الدواء قريب',
      'yourPetIsntProtectedFromRabies': 'أليفك مش محمي من السعار، طعّمه قريب',
      'treatmentComplete': 'العلاج خلص، أليفك دلوقتي محمي',
      'secondDoseRequiredForFullDeworming':
          'الجرعة التانية ضرورية عشان العلاج يكمل',
      'wormsSecondDoseExpired':
          'لألسف بما إن الجرعة التانية فاتت، كده أليفك مش محمي، والزم نعيد التطعيم من األول علشان نوصل لأفضل حماية',
      'notProtectedFromWorms': 'أليفك مش محمي من الديدان، ابدأ العلاج قريب',
      'whatToDoNow': 'ماذا تفعل الآن؟',
      'wormsWindowExpiredExplanation':
          'لألسف، الفترة الصحيحة للجرعة التانية انتهت (يوم 14-20). لازم تبدأ سلسلة التطعيم من جديد بجرعة أولى جديدة عشان أليفك يكون محمي.',
      'tipCancelAndRestart':
          '💡 نصيحة: اضغط "Cancel" وابدأ سلسلة تطعيم جديدة.',
      'warningTooEarlyFor2ndDose': 'تنبيه: الجرعة التانية بدري',
      'warning2ndDoseWindowExpired': 'تحذير: الجرعة التانية فاتت',
      'wormingVaccineProtocol': 'بروتوكول تطعيم الديدان:',
      'wormingVaccineInfo': 'معلومات تطعيم الديدان',
      'firstDose': 'الجرعة األولى',
      'vaccinesNeverTakenAndOverdue': 'اللقاحات التي لم يتم أخذها أبدًا ومتأخرة الآن',
      'dueWithinNext30Days': 'مستحقة خلال الـ 30 يومًا القادمة',
      'inProgressVaccinesNeedingNextDose': 'اللقاحات قيد التقدم التي تحتاج الجرعة التالية',
      'notAdded': 'لم تتم الإضافة',
      'windowOpensDay14': 'بداية الفترة الصحيحة (يوم 14)',
      'windowClosedDay20': 'آخر موعد (يوم 20)',
      'dosesRequired2': 'جرعتين مطلوبة',
      'secondDoseDay14to20Only': 'الجرعة التانية: يوم 14-20 فقط',
      'beforeDay14TooEarly': 'قبل يوم 14: بدري',
      'afterDay20MustRestart': 'بعد يوم 20: لازم نعيد',
      'doses2Between14to20Days': 'جرعتين، 14-20 يوم بينهم',
      'validWindowDay14to20': 'الفترة الصحيحة: يوم 14-20',
      'afterDay20MustRestartFromBeginning': 'بعد يوم 20: لازم نعيد من األول',
      'restartVaccinationSeries': 'إعادة التطعيم من البداية',
      'daysRemaining': 'الوقت المتبقي:',
      'waitMoreDaysBeforeSecondDose':
          'لازم تستنى {days} يوم كمان قبل ما تدي الجرعة التانية. الجرعة التانية لازم تكون بعد 14 يوم على األقل من الجرعة األولى.',
      'warningMissedDose': 'تحذير: جرعة فائتة',
      'missed2ndDoseVirusMessage':
          'لألسف بما إن الجرعة التانية فاتت، كده أليفك مش محمي، والزم تعيد التطعيم من األول.',
      'missed3rdDoseVirusMessage':
          'أليفك لسه محمي عشان أخذ أول جرعتين، بس لازم تديله الجرعة التالتة بسرعة عشان يكون محمي بالكامل.',
      'missedInsectsMessage':
          'من فضلك ادي الجرعة بسرعة عشان تحمي أليفك.',
      'missedRabiesMessage':
          'من فضلك ادي تطعيم السعار بسرعة. التطعيم ده مهم جداً لسلامة أليفك.',
      'deadlineDay35': 'آخر موعد (يوم 35)',
      'lastDoseGiven': 'آخر جرعة تم إعطاؤها',
      'daysSinceLastDose': 'الأيام منذ آخر جرعة:',
      'scheduleNextDose': 'حدد موعد الجرعة التالية',
      'deleteVaccination': 'حذف التطعيم',
      'areYouSureDeleteVaccination': 'هل أنت متأكد من حذف سلسلة التطعيم هذه؟',
      'deleteVaccinationFeatureComingSoon':
          'ميزة حذف التطعيم قريباً. سيتم دمج الـ API لاحقاً.',
      'vaccinationDeleted': 'تم حذف التطعيم بنجاح',
      'cannotDeleteVaccination': 'لا يمكن حذف التطعيم',
      'cannotDeleteCompletedVaccination':
          'لا يمكن حذف التطعيمات المكتملة. هي جزء من السجل الطبي الدائم لأليفك.',
      'completedVaccinationsAreProtected':
          'التطعيمات المكتملة محمية ومحفوظة للتاريخ الطبي.',
      'understood': 'مفهوم',
      'nextAnnualBoosterWillBeScheduled':
          'سيتم جدولة الجرعة التنشيطية السنوية التالية تلقائياً بعد سنة من هذا التاريخ.',
      'fullyProtected': 'أليفك محمي بأفضل شكل، تابع التطعيم السنوي',
      'protectedThirdDoseGivesStrongestImmunity':
          'أليفك محمي، الجرعة التالتة بتقوّي المناعة أكتر',
      'protectionIncomplete': 'أليفك لسه مش محمي، لازم الجرعة التانية',
      'notProtectedStartVirusVaccineSoon': 'أليفك مش محمي، طعّمه قريب',
      'dismiss': 'إغلاق',
      'errorLoadingVaccinationRecord': 'خطأ في تحميل سجل التطعيمات',
      'noVaccinationData': 'لا توجد بيانات تطعيم',
      'overdue': 'متأخر',
      'markDoseComplete': 'تحديد الجرعة كمكتملة',
      'selectPet': 'اختر أليفك',
      'addVaccinationTitle': 'إضافة تطعيم',
      'active': 'نشط',
      'completedStatus': 'مكتمل',
      'dosesCompleted': 'جرعة مكتملة',
      'wormTreatment': 'علاج الديدان',
      'insectProtection': 'الحماية من الحشرات',
      'rabiesVaccine': 'لقاح السعار',
      'markBoosterCompleteFeatureComingSoon':
          'ميزة تحديد الجرعة التنشيطية كمكتملة قريباً',

      'noFavoritesYet': 'لا توجد مفضلات بعد',
      'noFavoritesMessage':
          'عندما تجد عيادات تحبها، احفظها هنا للوصول إليها بسرعة.',
      'openNow': 'مفتوح الآن',
      'closed': 'مغلق',
      'bookAppointment': 'حجز موعد',
      'exploreMoreVets': 'استكشف المزيد من العيادات',
      'removedFromFavorites': 'تمت إزالته من المفضلات',
      'loading': 'جاري التحميل...',
      'error': 'خطأ',
      'success': 'نجاح',
      'save': 'حفظ',
      'delete': 'حذف',
      'edit': 'تعديل',
      'ok': 'موافق',
      'next': 'التالي',
      'previous': 'السابق',
      'search': 'بحث',
      'clear': 'مسح',
      'apply': 'تطبيق',
      'filter': 'تصفية',

      'sort': 'ترتيب',
      'share': 'مشاركة',
      'noResultsFound': 'لم يتم العثور على نتائج',
      'tryAgain': 'حاول مرة أخرى',
      'refresh': 'تحديث',
      'addToFavorites': 'إضافة إلى المفضلة',
      'removeFromFavorites': 'إزالة من المفضلة',
      'today': 'اليوم',
      'tomorrow': 'غدًا',
      'selectDate': 'اختر التاريخ',
      'selectTime': 'اختر الوقت',
      'done': 'تم',
      'noVouchersFound': 'لا توجد قسائم',
      'checkBackLater': 'تحقق مرة أخرى لاحقًا للحصول على عروض جديدة',
      'name': 'الاسم',
      'email': 'البريد الإلكتروني',
      'phone': 'الهاتف',
      'dateOfBirth': 'تاريخ الميلاد',
      'address': 'العنوان',
      'pointsValue': '{points} نقاط',
      'pointsSummary': 'إجمالي المكتسب: {earned} • إجمالي المسترد: {redeemed}',
      'dateToday': 'اليوم',
      'dateYesterday': 'الأمس',
      'dateDaysAgo': 'منذ {days} أيام',
      'password': 'كلمة المرور',
      'yourPetCareActivities': 'أنشطة رعاية حيواناتك الأليفة',
      'noActivitiesFound': 'لم يتم العثور على أنشطة',
      'activitiesMatchingFilterWillAppearHere':
          'الأنشطة المطابقة للتصفية ستظهر هنا',
      'appointmentCancelledSuccessfully': 'تم إلغاء الموعد بنجاح',
      'failedToCancelAppointment': 'فشل في إلغاء الموعد',
      'confirmCancelAppointmentMessage':
          'هل أنت متأكد من أنك تريد إلغاء هذا الموعد؟',
      'yesCancelAppointment': 'نعم، إلغاء',
      'rescheduleFeatureComingSoon': 'ميزة إعادة الجدولة قادمة قريبًا!',
      'reviewFeatureComingSoon': 'ميزة المراجعة قادمة قريبًا!',
      'bookingFollowupAppointment': 'حجز موعد متابعة...',
      'upcoming': 'قادم',
      'pending': 'قيد الانتظار',
      'confirmed': 'مؤكد',
      'completed': 'مكتمل',
      'cancelled': 'ملغى',
      'last3Months': 'آخر 3 أشهر',
      'byYear': 'حسب السنة',
      'selectYear': 'اختر السنة',
      'timeFilter': 'تصفية الوقت',
      'rescheduled': 'مُعاد جدولته',
      'reschedule': 'إعادة جدولة',
      'writeReview': 'كتابة تقييم',
      'bookAgain': 'احجز مرة أخرى',
      'all': 'الكل',
      'cancelAppointment': 'إلغاء الموعد',
      'keepAppointment': 'الاحتفاظ بالموعد',
      'appointmentDetails': 'تفاصيل الموعد',
      'vetName': 'اسم الطبيب البيطري',
      'appointmentType': 'نوع الموعد',
      'dateAndTime': 'التاريخ والوقت',
      'status': 'الحالة',
      'notes': 'الملاحظات',
      'close': 'إغلاق',
      'confirmCancelAppointment':
          'هل أنت متأكد من أنك تريد إلغاء موعدك مع {vetName}؟',
      'leaveReview': 'اترك تقييمًا',
      'date': 'التاريخ',
      'time': 'الوقت',
      'service': 'الخدمة',
      'pet': 'الحيوان الأليف',
      'duration': 'المدة',
      'fee': 'الرسوم',
      'contactVet': 'تواصل مع الطبيب',
      'vetDetails': 'تفاصيل العيادة',
      'report': 'تبليغ',
      'minutes': 'دقائق',
      'reviews': 'التقييمات',
      'review': 'تقييم',
      'reviewDetails': 'تفاصيل التقييم',
      'tapToViewDetails': 'اضغط لعرض التفاصيل',
      'noComment': 'لا يوجد تعليق',
      'noReviewsYet': 'لا توجد تقييمات بعد',
      'patients': 'المرضى',
      'yearsExp': 'سنوات الخبرة',
      'description': 'الوصف',
      'defaultvetDescription':
          'مستشفى BluePearl للحيوانات الأليفة هو شبكة من المستشفيات المتخصصة التي تقدم خدمات الطوارئ والخدمات المتخصصة. يركزون على رعاية الحيوانات الأليفة التي تتطلب عناية طبية متخصصة.',
      'services': 'الخدمات',
      'generalWellnessExam': 'فحص الصحة العامة',
      'vaccinations': 'التطعيمات',
      'microchipping': 'زراعة الشريحة',
      'nutritionalCounseling': 'الاستشارة الغذائية',
      'laboratoryServices': 'خدمات المختبر',
      'surgery': 'الجراحة',
      'dentalCare': 'العناية بالأسنان',
      'emergencyCare': 'العناية الطارئة',
      'consultationFee': 'رسوم الاستشارة',
      'initialExaminationFee': 'رسوم الفحص الأولي',
      'earnPoints': 'احصل على',
      'pointsAfterCompletion': 'نقطة بعد إتمام زيارتك!',
      'workingHours': 'ساعات العمل',
      'mondayFriday': 'الاثنين - الجمعة',
      'saturday': 'السبت',
      'sunday': 'الأحد',
      'bookConsultation': 'احجز كشف',
      'consultation': 'استشارة',
      'findVets': 'البحث عن العيادات',
      'refreshLocation': 'تحديث الموقع',
      'enableLocation': 'تفعيل الموقع',
      'searchVetsHint': 'البحث عن العيادات، الخدمات، المواقع...',
      'filters': 'المرشحات',
      'allCategory': 'جميع الفئات',
      'popular': 'الأكثر شعبية',
      'recommended': 'الموصى بها',
      'latest': 'الأحدث',
      'currentLocation': 'الموقع الحالي',
      'gettingLocation': 'جاري الحصول على الموقع...',
      'enableLocationForResults':
          'فعل الموقع للحصول على نتائج بناءً على المسافة',
      'enable': 'تفعيل',
      'searchResult': 'نتائج البحث',
      'noVetsFound': 'لم يتم العثور على عيادات',
      'tryAdjustingFilters': 'حاول تعديل البحث أو المرشحات',
      'clearFilters': 'مسح المرشحات',
      'viewDetails': 'عرض التفاصيل',
      'callvet': 'اتصال بالعيادة',
      'failedToLoadVets': 'فشل في تحميل العيادات. يرجى المحاولة مرة أخرى.',
      'errorApplyingFilters': 'خطأ في تطبيق المرشحات. يرجى المحاولة مرة أخرى.',
      'withinDistance': 'ضمن {distance}كم',
      'VetsFound': 'تم العثور على {count}',
      'ratingWithReviews': '{rating} ({reviews})',
      'yearsExperience': '{years} سنة',
      'callingNumber': 'الاتصال بـ {phone}',
      'region': 'المنطقة',
      'allRegions': 'جميع المناطق',
      'nearbyAutoDetect': 'القريبة (تلقائي)',
      'allServices': 'جميع الخدمات',
      'sortBy': 'ترتيب حسب',
      'sortDefault': 'افتراضي',
      'sortNearby': 'الأقرب',
      'sortRating': 'أعلى تقييم',
      'sortReviews': 'أكثر تقييماً',
      'sortName': 'الاسم (أ-ي)',
      'maxDistance': 'أقصى مسافة',
      'anyDistance': 'أي مسافة',
      'clearAll': 'مسح الكل',
      'applyFilters': 'تطبيق المرشحات',
      'distanceKm': '{distance}كم',
      'vaccination': 'التطعيم',
      'checkup': 'فحص',
      'grooming': 'تنظيف',
      'emergency': 'طوارئ',
      'selectLocation': 'اختر الموقع',
      'selectGovernorateOrCity': 'اختر المحافظة أو المدينة',
      'searchGovernorate': 'البحث عن المحافظة...',
      'citiesCount': '{count} مدن',
      'selectCity': 'اختر المدينة',
      'searchCity': 'البحث عن المدينة...',
      'allCitiesIn': 'كل {governorate}',
      'selectEntireGovernorate': 'اختر المحافظة بأكملها',
      'bookVetVisit': 'حجز زيارة العيادة',
      'resetBooking': 'إعادة تعيين الحجز',
      'bookingDetails': 'تفاصيل الحجز',
      'vet': 'العيادة',
      'price': 'السعر',
      'selectTimeSlot': 'اختر الوقت',

      // Points Redemption
      'redeemPoints': 'استبدال النقاط',
      'availablePoints': 'النقاط المتاحة',
      'pointsToRedeem': 'النقاط للاستبدال',
      'enterPointsAmount': 'أدخل عدد النقاط',
      'pointsDiscount': 'خصم النقاط',
      'remainingBalance': 'الرصيد المتبقي',
      'originalPrice': 'السعر الأصلي',
      'discount': 'الخصم',
      'finalPrice': 'السعر النهائي',
      'totalPrice': 'إجمالي السعر',
      'pts': 'نقطة',
      'totalSavings': 'إجمالي التوفير',
      'vetDiscount': 'خصم العيادة',
      'coupon': 'كوبون',
      'points': 'نقاط',
      'morning': 'الصباح',
      'afternoon': 'بعد الظهر',
      'evening': 'المساء',
      'petsForVisitOptional': 'الحيوانات الأليفة للزيارة (اختياري)',
      'tapToSelectPets': 'اضغط لاختيار الحيوانات الأليفة لهذه الزيارة',
      'addingPetsOptional': 'إضافة الحيوانات الأليفة اختياري',
      'selectPetsForVisit': 'اختر الحيوانات الأليفة للزيارة',
      'failedToLoadPets': 'فشل في تحميل الحيوانات الأليفة',
      'noPetsYet': 'ليس لديك أي حيوانات أليفة بعد',
      'addPet': 'أضف حيوان أليف',
      'confirmBooking': 'تأكيد الحجز',
      'bookingConfirmed': 'تم تأكيد الحجز!',
      'reference': 'المرجع',
      'pets': 'الحيوانات الأليفة',
      'petsForThisVisit': 'الحيوانات الأليفة لهذه الزيارة:',
      'showQRCodeAtVet': 'اعرض رمز الاستجابة السريعة هذا في العيادة',
      'qrCodeError': 'حدث خطأ ما!',
      'pleaseSelectTimeSlot': 'يرجى اختيار وقت',
      'bookingFailed': 'فشل الحجز. يرجى المحاولة مرة أخرى.',
      'availableSlotsFor': 'الأوقات المتاحة لـ {date}',
      'confirmPets': 'تأكيد ({count} حيوانات أليفة)',
      'noSlotsAvailable': 'لا توجد مواعيد متاحة',
      'booked': 'محجوز',
      'availableSlots': '({count} متاح)',
      'favorite': 'مفضل',
      'addedToFavorites': 'تم إضافته للمفضلة',
      'cannotOpenMaps': 'لا يمكن فتح الخرائط. يرجى التحقق من تثبيت خرائط جوجل.',
      'viewLocation': 'عرض الموقع',
      'chooseMapApp': 'اختر كيفية عرض الموقع',
      'coordinates': 'الإحداثيات',
      'copyLocation': 'نسخ الموقع',
      'openInBrowser': 'فتح في المتصفح',
      'locationCopiedToClipboard': 'تم نسخ الموقع إلى الحافظة',
      // 3D Viewer Screen translations
      'head': 'الرأس',
      'legs': 'الأرجل',
      'skinAndCoat': 'الجلد والشعر',
      'pelvis': 'الجهاز البولي والتناسلي',
      'buttocks': 'فتحة الشرج والتبرز',
      'selected': 'المحدد',
      'howToUse': 'كيفية الاستخدام',
      'step': 'خطوة',
      'rotate': 'تدوير',
      'zoom': 'تكبير',
      'selectText': 'اختيار',
      'symptoms': 'الأعراض',
      'searchSymptoms': 'ابحث عن الأعراض...',
      'viewSelected': 'عرض المحدد',
      'findVet': 'العثور على دكتور',
      'rotateInstructions': 'اضغط واسحب لتدوير النموذج',
      'rotate90Instructions': 'اضغط على زر التدوير لتدوير النموذج 90 درجة',
      'zoomInstructions': 'اقرص لتكبير وتصغير الصورة',
      'selectInstructions': 'اضغط على جزء من الجسم لاختياره',
      'symptomsInstructions': 'اختر الأعراض لجزء الجسم المحدد',
      'viewSelectedInstructions':
          'اضغط على أيقونة الأعراض في الشريط العلوي لرؤية اختياراتك',
      'findVetInstructions': 'بعد اختيار الأعراض، اضغط على "العثور على دكتور"',
      'gotIt': 'فهمت',
      'swipeToRotate': 'اسحب للتدوير',
      'tapBodyPartToExplore': 'اضغط على أجزاء الجسم لاستكشاف الأعراض',
      'noDataAvailable': 'لا توجد بيانات متاحة',
      'noSymptomDataFound': 'لم يتم العثور على بيانات أعراض لـ',
      'noSymptomsFound': 'لم يتم العثور على أعراض لـ',
      'symptomCategories': 'فئات الأعراض',
      'replaceSelectedSymptom': 'استبدال العرض المحدد',
      'selectThisSymptom': 'اختيار هذا العرض',
      'findEmergencyVet': 'العثور على دكتور طوارئ',
      'whatWouldYouLikeToDo': 'ماذا تريد أن تفعل؟',
      'youHaveSelected': 'لقد اخترت',
      'findVetNearby': 'العثور على دكتور قريب',
      'seeExamplesAndPictures': 'مشاهدة الأمثلة والصور',
      'examples': 'أمثلة',
      'visualExamples': 'أمثلة بصرية',
      'importantNote': 'ملاحظة مهمة',
      'disclaimerText':
          'هذه المعلومات لأغراض تعليمية فقط. استشر دائماً طبيب بيطري مؤهل للتشخيص والعلاج المناسب.',
      'exampleImagesDisclaimer':
          'هذه صور مرجعية فقط. كل حيوان أليف مختلف، وقد تختلف الأعراض في الشدة والمظهر. إذا كنت غير متأكد أو قلق، يرجى استشارة طبيب بيطري.',
      'back': 'رجوع',
      'imageNotAvailable': 'الصورة غير متاحة',

      // Pet Symptom Categories
      'eyeSymptoms': 'أعراض العين',
      'earSymptoms': 'أعراض الأذن',
      'mouthTeethSymptoms': 'أعراض الفم والأسنان',
      'skinCoatSymptoms': 'أعراض الجلد والشعر',
      'movementLimbsIssues': 'مشاكل الحركة والأطراف',
      'anusPoopingIssues': 'الشرج والتبرز',
      'maleGenitalProblems': 'مشاكل الأعضاء التناسلية الذكورية',
      'femaleGenitalProblems': 'مشاكل الأعضاء التناسلية الأنثوية',
      'urinationProblems': 'مشاكل التبول',
      'neurologicalIssues': 'مشاكل عصبية',

      // Eye Symptoms
      'Eye Redness': 'احمرار العين',
      'Eye Redness_description':
          'لو عين أليفك لونها أحمر، ممكن يكون بسبب حاجة بسيطة زي التراب، أو حاجة أخطر زي عدوى.',
      'Eye Redness_cause_0': 'تراب، هوا، أو حساسية',
      'Eye Redness_cause_1': 'عدوى (زي بكتيريا أو فيروس الهربس)',
      'Eye Redness_cause_2': 'ضغط عالي في العين (المياة الزرقاء)',
      'Eye Redness_cause_3': 'خبطة أو تهيّج',
      'Eye Redness_action_0':
          'لو الاحمرار بسيط ← اغسل العين بمحلول ملحي وتابعها كويس',
      'Eye Redness_action_1':
          'لو العين وارمة، أو أليفك بيغمّضها، أو فيها إفرازات، أو بيهرش فيها ← روح العيادة فورًا',

      'Eye Discharge (Goopy Stuff)': 'الإفرازات من العين',
      'Eye Discharge (Goopy Stuff)_description':
          'شوية إفرازات بسيطة من العين ممكن تكون عادي، لكن لو كانت تقيلة أو لونها أصفر أو أخضر، ممكن يبقى فيه عدوى.',
      'Eye Discharge (Goopy Stuff)_cause_0':
          'عادي في بعض السلالات (زي قطط البيرشن)',
      'Eye Discharge (Goopy Stuff)_cause_1': 'حساسية أو تهيّج بسيط',
      'Eye Discharge (Goopy Stuff)_cause_2': 'عدوى (إفرازات صفراء/خضراء)',
      'Eye Discharge (Goopy Stuff)_cause_3':
          'ممكن يكون ليها علاقة بالديدان في بعض الحالات',
      'Eye Discharge (Goopy Stuff)_action_0':
          'لو الإفرازات شفافة أو خفيفة، وأليفك باين عليه إنه كويس ← امسحها وتابعها كويس',
      'Eye Discharge (Goopy Stuff)_action_1':
          'لو تقيلة أو لونها أصفر أو أخضر ← يُفضل تروح للدكتور',

      'Cloudy Eye (Looks Foggy or Bluish)':
          'العين المُعتمة (شكلها ضبابي أو مزرقة شوية)',
      'Cloudy Eye (Looks Foggy or Bluish)_description':
          'لو عين أليفك شكلها معتم أو لونها بقى كأنه لَبني، ممكن تكون حاجة طبيعية مع التقدم في السن، أو حاجة أخطر.',
      'Cloudy Eye (Looks Foggy or Bluish)_cause_0':
          'في الحيوانات الكبيرة في السن: تغيير طبيعي مع العمر',
      'Cloudy Eye (Looks Foggy or Bluish)_cause_1':
          'المياه البيضاء (ممكن تسبب فقدان النظر)',
      'Cloudy Eye (Looks Foggy or Bluish)_cause_2':
          'خدش في القرنية (بعد خبطة أو عدوى)',
      'Cloudy Eye (Looks Foggy or Bluish)_cause_3':
          'ضغط عالي في العين (المياة الزرقاء)',
      'Cloudy Eye (Looks Foggy or Bluish)_action_0':
          'لو التغيير حصل تدريجي و أليفك كبير في السن ← قول للدكتور في الزيارة الجاية',
      'Cloudy Eye (Looks Foggy or Bluish)_action_1':
          'لو حصل تعتيم فجأة، أو فيه وجع أو أليفك بيغمّض ← روح العيادة فورًا، التأخير ممكن يسبب فقدان البصر',

      'Watery Eyes (Excessive Tearing)': 'العين بتدمّع كتير',
      'Watery Eyes (Excessive Tearing)_description':
          'شوية دموع من العين ممكن يكون عادي، لكن لو الزيادة ملحوظة، ممكن يكون فيه مشكلة.',
      'Watery Eyes (Excessive Tearing)_cause_0': 'حساسية أو تهيّج بسيط',
      'Watery Eyes (Excessive Tearing)_cause_1':
          'انسداد في قنوات الدموع (شائع في الكلاب الصغيرة)',
      'Watery Eyes (Excessive Tearing)_cause_2':
          'عدوى (زي فيروس الكاليسي في القطط)',
      'Watery Eyes (Excessive Tearing)_cause_3':
          'عدوى أو خدش في القرنية (لو فيه احمرار وتغميض)',
      'Watery Eyes (Excessive Tearing)_action_0':
          'لو الدموع بسيطة ومفيش علامات تانية ← امسحها وتابعها كويس',
      'Watery Eyes (Excessive Tearing)_action_1':
          'لو الدموع كتير ومعاها احمرار أو حكّة ← روح العيادة',

      'Third Eyelid Showing': 'حاجة بيضاء أو وردي في جنب العين',
      'Third Eyelid Showing_description':
          'شايف حاجة لونها أبيض أو وردي طالعة من جنب عين أليفك أو مغطيّة جزء منها؟ دي الجفن التالت للعين.',
      'Third Eyelid Showing_cause_0':
          'طبيعي بعد النوم – الجفن التالت ممكن يبان شوية لما أليفك يصحى',
      'Third Eyelid Showing_cause_1':
          'عدوى في العين أو مشاكل في الأعصاب – ممكن تخلي الجفن يفضل ظاهر',
      'Third Eyelid Showing_cause_2':
          'في الكلاب: لو فيه كتلة وردي في الركن الداخلي، ممكن تكون غدة طالعة لبرا',
      'Third Eyelid Showing_cause_3':
          'في القطط: لو فيه جفن أبيض بيغطي العينين، ممكن يكون علامة على مرض',
      'Third Eyelid Showing_action_0':
          'لو اختفى بسرعة وأليفك باين عليه إنه كويس ← مفيش داعي للقلق، بس تابعها كويس',
      'Third Eyelid Showing_action_1':
          'لو الجفن التالت لسه باين أو بيغطي جزء من العين ← احجز زيارة للعيادة علشان تعرف السبب',
      'Third Eyelid Showing_action_2':
          'لو فيه ورم أو احمرار أو أليفك مش قادر يفتح عينه كويس ← روح العيادة فورًا',
      'Third Eyelid Showing_action_3':
          'متحاولش تلمس أو ترجع النسيج ده مكانه – ده ممكن يسبب ضرر أكتر',

      'Squinting or Keeping Eye Closed': 'أليفك بيغمّض عين واحدة أو بيضيقها',
      'Squinting or Keeping Eye Closed_description':
          'لو أليفك مغمّض عين ومش بيفتحها أو بيغمز كتير، ممكن يكون حاسس بألم.',
      'Squinting or Keeping Eye Closed_cause_0': 'تهيّج من تراب أو شعر',
      'Squinting or Keeping Eye Closed_cause_1': 'خدش في القرنية',
      'Squinting or Keeping Eye Closed_cause_2': 'عدوى أو ضغط عالي في العين',
      'Squinting or Keeping Eye Closed_action_0':
          'لو خفيف وبيتحسن بسرعة ← اغسل العين بمحلول ملحي و تابعها كويس',
      'Squinting or Keeping Eye Closed_action_1':
          'لو أليفك لسه بيغمّض أو بيهرش في عينه ← روح العيادة فورًا',

      'Swelling Around the Eye': 'تورم حوالين العين',
      'Swelling Around the Eye_description':
          'لو عين أليفك شكلها منفوخ أو فيها ورم، يبقى فيه حاجة مسبباله تهيّج.',
      'Swelling Around the Eye_cause_0': 'حساسية أو تهيّج بسيط',
      'Swelling Around the Eye_cause_1': 'عدوى أو خبطة',
      'Swelling Around the Eye_cause_2': 'خُراج أو ورم (نادر، بس ممكن يحصل)',
      'Swelling Around the Eye_action_0':
          'لو التورم بسيط ومفيش أعراض تانية ← حط كمّادات باردة وتابعها كويس',
      'Swelling Around the Eye_action_1':
          'لو فيه تورم شديد، وجع، أو احمرار ← روح العيادة فورًا',

      'Worms in the Eye': 'ديدان في العين',
      'Worms in the Eye_description':
          'شايف حاجة بتتحرك في عين أليفك؟ ممكن تكون دودة – وده محتاج تدخل سريع.',
      'Worms in the Eye_cause_0':
          'طفيليات (ديدان أو خيوط بيضاء) حوالين أو جوا العين',
      'Worms in the Eye_cause_1':
          'الطفيليات دي ممكن تضر العين وتسبب وجع، احمرار، أو حتى فقدان في النظر لو متمش علاجها بسرعة',
      'Worms in the Eye_action_0':
          'متحاولش تلمس أو تشيل الدودة بنفسك – ده ممكن يضر العين',
      'Worms in the Eye_action_1': 'حاول تهدّي أليفك وماتخلهوش يحك في عينه',
      'Worms in the Eye_action_2':
          'روح العيادة فورًا – العلاج محتاج دكتور وأدوية مخصوصة',
      // Ear Symptoms
      'Itchy Ears (Scratching or Head Shaking)':
          'أليفك بيهرش ودانه أو بيهز دماغه كتير',
      'Itchy Ears (Scratching or Head Shaking)_description':
          'لو أليفك بيهز راسه كتير أو بيهرش ودانه طول الوقت، يبقى في حاجة مضايقاه!',
      'Itchy Ears (Scratching or Head Shaking)_cause_0':
          'عدوى في الودان (بكتيريا أو فطريات)',
      'Itchy Ears (Scratching or Head Shaking)_cause_1':
          'حشرات ودان (زي العتة – شائعة في القطط)',
      'Itchy Ears (Scratching or Head Shaking)_cause_2':
          'حساسية (من أكل أو حاجة في البيئة)',
      'Itchy Ears (Scratching or Head Shaking)_cause_3':
          'حاجة دخلت جوه الودن (زي حتة عشبة أو تراب)',
      'Itchy Ears (Scratching or Head Shaking)_action_0':
          'لو بسيطة والودن شكلها طبيعي ← امسحها بلُطف وتابعها كويس',
      'Itchy Ears (Scratching or Head Shaking)_action_1':
          'لو فيه احمرار، ورم، أو ريحة مش حلوة ← روح العيادة',
      'Itchy Ears (Scratching or Head Shaking)_action_2':
          'لو بيهز راسه كتير ← تصرّف بسرعة! الهز الزايد ممكن يسبب ورم دموي مؤلم في الودن',

      'Black Stuff in the Ear (Dark Wax or Debris)':
          'حاجة سودا جوه الودن (شمع غامق)',
      'Black Stuff in the Ear (Dark Wax or Debris)_description':
          'لو لاحظت وساخة سودا أو شمع غامق في ودن أليفك، ممكن تكون حاجة بسيطة، أو علامة على حشرات أو عدوى!',
      'Black Stuff in the Ear (Dark Wax or Debris)_cause_0':
          'شمع طبيعي (لو بسيط ومفيهوش ريحة)',
      'Black Stuff in the Ear (Dark Wax or Debris)_cause_1':
          'حشرات ودان (شكلها زي رواسب القهوة، وبتسبب هرش شديد)',
      'Black Stuff in the Ear (Dark Wax or Debris)_cause_2':
          'عدوى فطرية أو بكتيرية (بيكون ليها ريحة مش لطيفة، والودن بتبقى مبلولة شوية)',
      'Black Stuff in the Ear (Dark Wax or Debris)_action_0':
          'لو الكمية بسيطة ومفيش هرش ← نظّف بلُطف',
      'Black Stuff in the Ear (Dark Wax or Debris)_action_1':
          'لو فيه هرش أو ريحة وحشة أو شمع اسود كتير ← روح العيادة',

      'Red or Swollen Ear': 'ودن أليفك حمرا أو وارمة',
      'Red or Swollen Ear_description':
          'لو ودن أليفك لونها أحمر، منفوخة، أو دافية لما تلمسها، ممكن تكون عدوى، حساسية، أو تورم من كتر الهز.',
      'Red or Swollen Ear_cause_0':
          'حساسية – من الأكل أو البراغيت أو حاجة في البيئة',
      'Red or Swollen Ear_cause_1':
          'تورم بسبب هز الرأس – لو الودن طرية ومنفوخة زي بلونة، ممكن يكون فيه أوعية دموية انفجرت جوه',
      'Red or Swollen Ear_cause_2':
          'لدغة حشرة أو خبطة – ممكن تسبب احمرار أو تورم مفاجئ',
      'Red or Swollen Ear_action_0':
          'لو الودن بس لونها أحمر وأليفك باين عليه إنه كويس ← ممكن تنظف برّة الودن بلُطف وتابعها كويس',
      'Red or Swollen Ear_action_1':
          'لو الودن منفوخة، دافية، بتوجع، أو فيها ريحة وحشة ← روح العيادة علشان تتعالج صح',
      'Red or Swollen Ear_action_2':
          'لو شكل الودن شبه مخدة طرية أو بلونة ← أليفك ممكن يحتاج تدخل بسيط لتصريفها – ماتستناش',
      'Red or Swollen Ear_action_3':
          'لو أليفك بيهز راسه أو بيهرش كتير ← لازم تروح العيادة علشان توقف السبب قبل ما الحالة تسوء',

      'Bad Smell from the Ear': 'ريحة وحشة من الودن',
      'Bad Smell from the Ear_description':
          'لو ودن أليفك ريحتها مش حلوة، غالباً ده يدل على عدوى.',
      'Bad Smell from the Ear_cause_0': 'عدوى بكتيرية في الودن',
      'Bad Smell from the Ear_cause_1': 'عدوى فطرية (خاصة في البيئة الرطبة)',
      'Bad Smell from the Ear_cause_2': 'تراكم شمع أو حطام مختلط بالعدوى',
      'Bad Smell from the Ear_action_0':
          'لو الريحة خفيفة ومفيش أعراض تانية ← نظّف برّة الودن بلُطف وتابع الحالة',
      'Bad Smell from the Ear_action_1':
          'لو الريحة قوية أو معاها احمرار وهرش ← روح العيادة فورًا',

      'Ear Discharge (Pus or Liquid Coming Out)':
          'إفرازات من الودن (صديد أو سائل)',
      'Ear Discharge (Pus or Liquid Coming Out)_description':
          'لو فيه سائل أو صديد طالع من الودن، غالباً ده عدوى أو حاجة علقت جوا.',
      'Ear Discharge (Pus or Liquid Coming Out)_cause_0':
          'عدوى بكتيرية أو فطرية شديدة',
      'Ear Discharge (Pus or Liquid Coming Out)_cause_1':
          'جسم غريب علق في الودن',
      'Ear Discharge (Pus or Liquid Coming Out)_cause_2':
          'ثقب في طبلة الودن (نادر لكن خطير)',
      'Ear Discharge (Pus or Liquid Coming Out)_action_0':
          'متحاولش تنظف جوه الودن بنفسك',
      'Ear Discharge (Pus or Liquid Coming Out)_action_1':
          'روح العيادة فورًا – الحالة دي محتاجة علاج متخصص',

      'Tilting Head to One Side': 'أليفك مايل راسه على جنب',
      'Tilting Head to One Side_description':
          'لو أليفك مايل راسه ناحية واحدة كأنه بيسمع حاجة أو بيفكّر، ممكن تكون علامة على مشكلة في ودنه أو في التوازن.',
      'Tilting Head to One Side_cause_0':
          'عدوى في الودن – خصوصًا في الودن الوسطى أو الداخلية',
      'Tilting Head to One Side_cause_1':
          'حشرات ودان – خاصة لو فيه هرش كتير كمان',
      'Tilting Head to One Side_cause_2':
          'مشكلة في التوازن – شائع أكتر في الكلاب الكبيرة في السن',
      'Tilting Head to One Side_action_0':
          'لو لسه بدأت وأليفك باين عليه إنه كويس ← تابع الحالة كويس لمدة 24 ساعة',
      'Tilting Head to One Side_action_1':
          'لو الميل استمر أو زاد ← احجز زيارة للعيادة علشان تفحص الودان',
      'Tilting Head to One Side_action_2':
          'لو أليفك بيقع، بيمشي في دواير، أو مش قادر يقف كويس ← روح العيادة فورًا',

      'Loss of Hearing or Not Responding to Sounds':
          'أليفك مش بيسمع كويس أو مش بيرد على الأصوات',
      'Loss of Hearing or Not Responding to Sounds_description':
          'لو أليفك مبقاش يتفاعل مع الأصوات زي زمان، ممكن يكون سمعه اتأثر.',
      'Loss of Hearing or Not Responding to Sounds_cause_0':
          'عدوى في الودن أو تراكم شمع (ممكن تسبب ضعف سمع مؤقت)',
      'Loss of Hearing or Not Responding to Sounds_cause_1':
          'التقدم في السن (فقدان السمع تدريجي)',
      'Loss of Hearing or Not Responding to Sounds_cause_2':
          'إصابة في الودن أو تلف في الأعصاب',
      'Loss of Hearing or Not Responding to Sounds_cause_3':
          'أسباب وراثية (بعض الحيوانات الأليفة – خصوصًا اللي لونها أبيض بالكامل – ممكن تتولد عندها ضعف سمع)',
      'Loss of Hearing or Not Responding to Sounds_action_0':
          'لو فقدان السمع حصل فجأة ← روح العيادة فورًا',
      'Loss of Hearing or Not Responding to Sounds_action_1':
          'لو بيحصل تدريجي وأليفك كبير في السن أو السبب وراثي ← تابع الحالة وحاول تغيّر طريقة التواصل معاه (الإشارات بالإيد بتساعد!)',

      // Mouth & Teeth Symptoms

      'Bad Breath (Smelly Mouth)': 'نفس ريحته وحشة',
      'Bad Breath (Smelly Mouth)_description':
          'لو كل ما يقرب منك تحس بريحة مش لطيفة من بُقه، يبقى كده في مشكلة',
      'Bad Breath (Smelly Mouth)_cause_0':
          'مشاكل في الأسنان (جِير، التهاب لثة، أو سنان مسوسة)',
      'Bad Breath (Smelly Mouth)_cause_1':
          'حاجة داخلة في بُقّه (أكل، شعر، أو جسم غريب)',
      'Bad Breath (Smelly Mouth)_cause_2':
          'مشاكل في الكُلى أو الكبد (خصوصًا لو النفس ريحته شبه البول أو سيئة جدًا)',
      'Bad Breath (Smelly Mouth)_action_0':
          'لو الريحة بسيطة ← جرّب تنظف له سنانه بـ معجون مخصوص للأليفة',
      'Bad Breath (Smelly Mouth)_action_1':
          'لو الريحة قوية، اللثة حمرا، أو فيه ريالة كتير ← روح العيادة',
      'Bad Breath (Smelly Mouth)_action_2':
          'لو النفس ريحته شبه البول ← احتمال يكون فيه مشكلة في الكلى أو الكبد – روح العيادة فورًا',

      'Excessive Drooling': 'ريالة أكتر من الطبيعي',
      'Excessive Drooling_description':
          'شوية ريالة ممكن يبقوا عاديين، لكن لو لقيت أليفك بيريل بطريقة مش طبيعية، يبقى في مشكلة.',
      'Excessive Drooling_cause_0':
          'مشكلة في الأسنان (سنة بايظة أو التهاب في اللثة)',
      'Excessive Drooling_cause_1': 'إصابة في الفم (حاجة حادة داخلة جوا)',
      'Excessive Drooling_cause_2':
          'غثيان أو تسمم (لو فيه ريالة ومعاها علامات تعب)',
      'Excessive Drooling_cause_3': 'ضربة شمس (لو فيه نهجان وسخونة)',
      'Excessive Drooling_action_0':
          'لو الريالة بسيطة ومفيش أعراض تانية ← تابع الحالة وقدم له مية نظيفة',
      'Excessive Drooling_action_1':
          'لو فيه ريحة وحشة، صعوبة في الأكل، أو فيه دم ← روح العيادة',
      'Excessive Drooling_action_2':
          'لو فيه ريالة مع ضعف أو رعشة ←حالة طوارئ! ممكن يكون تسمم أو ضربة شمس',

      'Red, Swollen Gums': 'لثة حمرا أو وارمة',
      'Red, Swollen Gums_description':
          'اللثة السليمة لونها وردي، مش أحمر أو منفوخ!',
      'Red, Swollen Gums_cause_0': 'التهاب لثة بسيط (بداية مرض في اللثة)',
      'Red, Swollen Gums_cause_1': 'عدوى في الأسنان (بسبب تراكم الجير)',
      'Red, Swollen Gums_cause_2': 'حاجة داخلة في اللثة (زي شظايا عضم)',
      'Red, Swollen Gums_action_0':
          'لو فيه احمرار بسيط ← نظف الأسنان بمعجون مخصص للحيوانات الأليفة وتابع الحالة كويس',
      'Red, Swollen Gums_action_1':
          'لو فيه ورم جامد، نزيف، أو ألم ← روح العيادة',

      'Loose or Missing Teeth': 'سنان مخلوعة أو ناقصة',
      'Loose or Missing Teeth_description':
          'الجراء والقطط الصغيرة طبيعي يبدّلوا سنانهم، لكن الأليفة البالغة مش المفروض تفقد سنانها!',
      'Loose or Missing Teeth_cause_0':
          'تبديل السنان في الجراء أو القطط الصغيرة (عادي لحد سن 6 شهور)',
      'Loose or Missing Teeth_cause_1': 'مرض في الأسنان أو اللثة',
      'Loose or Missing Teeth_cause_2':
          'خبطة في الفم أو مضغ حاجة ناشفة أو حادة',
      'Loose or Missing Teeth_action_0':
          'لو جرو أو قطة صغيرة ← ده طبيعي، بس تابع الحالة',
      'Loose or Missing Teeth_action_1':
          'لو أليفك بالغ و فقد سنّة ← روح العيادة علشان يفحص لثته وسنانه',
      'Loose or Missing Teeth_action_2':
          'لو فيه نزيف أو وجع واضح ← روح العيادة فورًا',

      'Trouble Eating or Dropping Food': 'صعوبة في المضغ أو الأكل بيقع من بُقه',
      'Trouble Eating or Dropping Food_description':
          'لو أليفك بيحب الأكل، لكن الأكل بقى بيقع من بُقه أو مش قادر يمضغه كويس، ممكن يكون فيه مشكلة في الفم.',
      'Trouble Eating or Dropping Food_cause_0':
          'ألم أو عدوى في الأسنان (بيصعّب عليه المضغ)',
      'Trouble Eating or Dropping Food_cause_1':
          'إصابة في الفم (زي جرح، قرحة، أو حاجة داخلة ومضايقاه)',
      'Trouble Eating or Dropping Food_cause_2': 'لثة وارمة أو ملتهبة',
      'Trouble Eating or Dropping Food_action_0':
          'بص في بُقه يمكن تلاقي حاجة علقت (زي شعر، عضم، أو خشب)',
      'Trouble Eating or Dropping Food_action_1':
          'لو بياكل بصعوبة أو بيبعد عن الأكل الناشف ← يُفضّل تروح العيادة علشان تتأكد من الفم',
      'Trouble Eating or Dropping Food_action_2':
          'لو فيه نزيف أو أليفك بيتوجع وهو بياكل ← روح العيادة فورًا',

      'Yellow or Brown Teeth (Tartar Buildup)':
          'سنان صفره أو بنيّة (تراكم الجير)',
      'Yellow or Brown Teeth (Tartar Buildup)_description':
          'لو سنان أليفك شكلها محتاجة تنظيف عميق، ممكن يكون فيه جير متراكم!',
      'Yellow or Brown Teeth (Tartar Buildup)_cause_0': 'تراكم الجير',
      'Yellow or Brown Teeth (Tartar Buildup)_cause_1':
          'التهاب لثة (بيكون فيه احمرار مع وجود جير)',
      'Yellow or Brown Teeth (Tartar Buildup)_cause_2':
          'تسوس في الأسنان (لو الحالة متقدمة)',
      'Yellow or Brown Teeth (Tartar Buildup)_action_0':
          'لو الاصفرار بسيط ← ابدأ تنظف له سنانه بشكل منتظم',
      'Yellow or Brown Teeth (Tartar Buildup)_action_1':
          'لو فيه جير كتير وريحته مش حلوة ← محتاج تنظيف أسنان في العيادة',

      'Bleeding from the Mouth': 'نزيف من الفم',
      'Bleeding from the Mouth_description':
          'لو لاحظت دم في بُقّ أليفك، ممكن يكون جاي من اللثة، السنان، أو اللسان — ولازم تعرف السبب.',
      'Bleeding from the Mouth_cause_0':
          'مرض في اللثة (من أكتر الأسباب شيوعًا)',
      'Bleeding from the Mouth_cause_1':
          'إصابة في الفم (زي إنه عض لسانه أو فيه جسم حاد)',
      'Bleeding from the Mouth_cause_2': 'عدوى أو خُراج في السنان',
      'Bleeding from the Mouth_action_0':
          'لو النزيف خفيف وأليفك بيأكل عادي ← قدم له أكل طري وتابع الحالة كويس',
      'Bleeding from the Mouth_action_1':
          'لو النزيف شديد، بيتكرر، أو أليفك واضح عليه الألم ← روح العيادة في أسرع وقت',

      'Swelling of Tongue or Lips': 'تورم في اللسان أو الشفايف',
      'Swelling of Tongue or Lips_description':
          'لو لسان أو شفايف أليفك منفوخين، ممكن يكون رد فعل تحسسي أو حاجة معلّقة!',
      'Swelling of Tongue or Lips_cause_0':
          'حساسية (من لسعة حشرة، أكل، أو دواء)',
      'Swelling of Tongue or Lips_cause_1':
          'إصابة في الفم (زي جرح أو حاجة دخلة ومضايقاه)',
      'Swelling of Tongue or Lips_cause_2':
          'عدوى أو ورم (لو التورم مستمر لفترة)',
      'Swelling of Tongue or Lips_action_0':
          'لو التورم حصل فجأة ← روح العيادة فورًا (ممكن يكون تحسس خطير!)',
      'Swelling of Tongue or Lips_action_1':
          'لو التورم بسيط ومفيش مشاكل في التنفس ← تابع الحالة وشوف لو في حاجة علقت',

      'White or Pale Gums': 'اللثة لونها أبيض أو باهت',
      'White or Pale Gums_description':
          'اللثة السليمة لونها وردي، مش أبيض أو باهت — اللون ده ممكن يدل على حالة خطيرة!',
      'White or Pale Gums_cause_0': 'أنيميا (بسبب مرض أو طفيليات)',
      'White or Pale Gums_cause_1': 'نزيف داخلي',
      'White or Pale Gums_cause_2':
          'مرض خطير (زي مشاكل في الكلى أو الكبد، أو تسمم)',
      'White or Pale Gums_action_0':
          'روح العيادة فورًا (دي حالة طارئة ومينفعش تتأخر!)',

      'Locked Jaw (Mouth Won\'t Open or Close)': 'الفك مش بيفتح أو يقفل',
      'Locked Jaw (Mouth Won\'t Open or Close)_description':
          'لو أليفك مش قادر يفتح أو يقفل بُقه بشكل طبيعي، يبقى في مشكلة خطيرة لازم تتلحق!',
      'Locked Jaw (Mouth Won\'t Open or Close)_cause_0':
          'خبطة أو سقوط – خبطة قوية أو وقعة ممكن تضر الفك (شائعة في القطط)',
      'Locked Jaw (Mouth Won\'t Open or Close)_cause_1':
          'مشكلة في مفصل الفك – زي الخلع أو التيبّس',
      'Locked Jaw (Mouth Won\'t Open or Close)_cause_2':
          'مشكلة في العضلات أو الأعصاب – بعض الحالات بتأثر على حركة عضلات الفك',
      'Locked Jaw (Mouth Won\'t Open or Close)_cause_3':
          'عدوى أو تورم شديد – زي خُراج في سن ممكن يسبب ألم وصعوبة في الحركة',
      'Locked Jaw (Mouth Won\'t Open or Close)_cause_4':
          'التيتانوس (تشنج الفك) – عدوى بكتيرية بتسبب تيبّس في العضلات',
      'Locked Jaw (Mouth Won\'t Open or Close)_action_0':
          'روح العيادة فورًا! الحالة دي طارئة ومينفعش تستنى',

      'Oral Ulcers (Sores in the Mouth)': 'تقرّحات في الفم',
      'Oral Ulcers (Sores in the Mouth)_description':
          'الجروح المؤلمة جوه الفم ممكن تخلّي الأكل صعب، ومرّات بتكون علامة على عدوى!',
      'Oral Ulcers (Sores in the Mouth)_cause_0':
          'فيروس الكاليسي في القطط – شائع في القطط وبيسبب تقرّحات في الفم وأعراض شبه البرد',
      'Oral Ulcers (Sores in the Mouth)_cause_1':
          'أمراض الأسنان الشديدة – التهابات اللثة المتقدمة ممكن تؤدي لتقرّحات',
      'Oral Ulcers (Sores in the Mouth)_cause_2':
          'ابتلاع أو لعق مواد سامة – زي مواد تنظيف، نباتات سامة، أو أدوية',
      'Oral Ulcers (Sores in the Mouth)_cause_3':
          'أمراض مناعية – بعض اضطرابات المناعة بتسبب تقرّحات في الفم',
      'Oral Ulcers (Sores in the Mouth)_action_0':
          'لو الجرح صغير وأليفك بياكل عادي ← قدّم له أكل طري وتابع الحالة كويس',
      'Oral Ulcers (Sores in the Mouth)_action_1':
          'لو في قرح كتير، ريالة، سخونية، أو عطس (خصوصًا في القطط) ←روح العيادة',
      'Oral Ulcers (Sores in the Mouth)_action_2':
          'لو فيه نزيف، ريحة البُق مش كويسة، أو أليفك مش عايز ياكل ← روح العيادة فورًا',

      // Skin & Coat Symptoms
      'Hair Loss': 'تساقط الشعر',
      'Hair Loss_description':
          'لاحظت شعر أليفك بقى في الأرض أو على هدومك أكتر من العادي؟',
      'Hair Loss_cause_0':
          'براغيث أو ديدان – الطفيليات ممكن تأثر على صحة الجلد والفرو عمومًا',
      'Hair Loss_cause_1':
          'تساقط طبيعي – بعض الحيوانات الأليفة بتبدّل شعرها في الصيف أو في مواسم معينة',
      'Hair Loss_cause_2':
          'تغذية ضعيفة – نقص العناصر الغذائية بيضعف الشعر وبيزود التساقط',
      'Hair Loss_cause_3':
          'التوتر – أليفك ممكن يسقط شعره أكتر لو كان قلقان أو خايف',
      'Hair Loss_cause_4': 'اضطرابات هرمونية',
      'Hair Loss_action_0':
          'لو التساقط بسيط وأليفك باين عليه إنه كويس ← مشّطه بانتظام واهتم بنظامه الغذائي',
      'Hair Loss_action_1':
          'لو أليفك ماخدش وقاية من البراغيث أو الديدان قريب ← روح العيادة علشان تطمّن وتجدّد الوقاية',
      'Hair Loss_action_2':
          'لو التساقط بدأ فجأة وبشكل كبير ← اعمل كشف علشان تستبعد أي مشكلة صحية',
      'Hair Loss_action_3':
          'لو الشعر بيقع في مناطق أو الفرو بقى خفيف ← محتاج تروح العيادة علشان تشوف السبب',
      'Hair Loss_action_4':
          'لو الجلد لونه أحمر أو فيه جروح أو قشور ← روح العيادة فورًا',

      'Bald Spots (Patches of Missing Hair)': 'مناطق فيها فراغات أو صلع',
      'Bald Spots (Patches of Missing Hair)_description':
          'شايف بقعة أو أكتر في جسم أليفك مفيهاش شعر خالص؟',
      'Bald Spots (Patches of Missing Hair)_cause_0':
          'عدوى فطرية – زي القوباء الحلقية (Ringworm)، بتسبب بقع دائرية فاضية من الشعر',
      'Bald Spots (Patches of Missing Hair)_cause_1':
          'حساسية – من أكل، تراب، نجيلة، أو حاجة لمسها أليفك',
      'Bald Spots (Patches of Missing Hair)_cause_2':
          'عدوى جلدية – بكتيريا أو فطريات ممكن تهيّج الجلد وتسبب تساقط الشعر',
      'Bald Spots (Patches of Missing Hair)_cause_3':
          'لعق أو هرش زيادة – بسبب وجع، حكة، أو توتر',
      'Bald Spots (Patches of Missing Hair)_cause_4':
          'تهيّج أو إصابة – من طوق ضيّق، حزام، أو احتكاك مستمر',
      'Bald Spots (Patches of Missing Hair)_action_0':
          'لو البقعة صغيرة وأليفك مش بيلحسها أو بيهرشها ← تابعها يومين تلاتة',
      'Bald Spots (Patches of Missing Hair)_action_1':
          'لو أليفك بيلحس أو بيعضّ أو بيهرش في المكان ← روح العيادة علشان تشوف السبب',
      'Bald Spots (Patches of Missing Hair)_action_2':
          'لو شكل البقعة دائرية وفيها قشور ← ممكن تكون عدوى فطرية –روح العيادة',
      'Bald Spots (Patches of Missing Hair)_action_3':
          'لو الجلد أحمر، فيه التهابات، أو قشور وجروح ← روح العيادة فورًا',

      'Itchy Skin (Scratching a Lot)': 'حكة في الجلد (أليفك بيهرش كتير)',
      'Itchy Skin (Scratching a Lot)_description':
          'لو أليفك مش بيبطل يهرش، يبقى في حاجة غلط!',
      'Itchy Skin (Scratching a Lot)_cause_0':
          'براغيث أو قراد – طفيليات صغيرة بتسبب حكة شديدة',
      'Itchy Skin (Scratching a Lot)_cause_1':
          'عدوى جلدية – بكتيريا أو فطريات ممكن تهيّج الجلد',
      'Itchy Skin (Scratching a Lot)_cause_2':
          'حساسية – من أكل، تراب، أو حتى شامبو',
      'Itchy Skin (Scratching a Lot)_action_0':
          'لو الهرش بيحصل كل فترة والجلد شكله طبيعي ← مشّط أليفك كل يوم وراقب الحالة',
      'Itchy Skin (Scratching a Lot)_action_1':
          'لو الهرش بيحصل كل يوم أو بشكل مستمر ← محتاج تروح العيادة علشان تعرف السبب',
      'Itchy Skin (Scratching a Lot)_action_2':
          'لو أليفك ماخدش وقاية من البراغيث أو القراد بقاله فترة ← روح العيادة علشان ترجع الحماية',
      'Itchy Skin (Scratching a Lot)_action_3':
          'لو أليفك بيعضّ، بيلحس، أو باين عليه انه موجوع وهو بيهرش ← ده معناه إنه متضايق – روح العيادة',
      'Itchy Skin (Scratching a Lot)_action_4':
          'لو الجلد لونه أحمر، فيه قشور، أو الشعر بيقع ← محتاج كشف في العيادة',

      'Constant Licking in One Spot': 'لحس مستمر في نفس المكان',
      'Constant Licking in One Spot_description':
          'أليفك بيفضل يلحس أو يعضّ نفس المنطقة طول الوقت؟',
      'Constant Licking in One Spot_cause_0':
          'حساسية – من أكل، براغيث، نجيلة، أو تراب',
      'Constant Licking in One Spot_cause_1': 'عدوى جلدية أو لدغة حشرة',
      'Constant Licking in One Spot_cause_2':
          'وجع أو تهيّج – زي جرح صغير أو حاجة علقت في الفرو',
      'Constant Licking in One Spot_cause_3':
          'توتر أو زهق – بعض الحيوانات الأليفة بتلحس نفسها لما تكون قلقانة',
      'Constant Licking in One Spot_action_0':
          'لو المنطقة لونها وردي بسيط ← حافظ عليها نظيفة وجافة وراقبها كويس',
      'Constant Licking in One Spot_action_1':
          'لو المكان أحمر، مبلول، أو أليفك مش سايبه في حاله ← روح العيادة قبل ما الحالة تسوء',
      'Constant Licking in One Spot_action_2':
          'لو فيه ريحة قوية، صديد، أو المكان بيكبر بسرعة ← روح العيادة فورًا',

      'Red or Inflamed Skin': 'الجلد لونه أحمر أو ملتهب',
      'Red or Inflamed Skin_description':
          'شايف منطقة في جلد أليفك شكلها أحمر، دافية، أو باين عليها إنها بتوجعه؟',
      'Red or Inflamed Skin_cause_0':
          'حساسية – من أكل، شامبو، تراب، أو حاجة لمسها',
      'Red or Inflamed Skin_cause_1': 'التهاب جلدي ناتج عن لحس أو هرش كتير',
      'Red or Inflamed Skin_cause_2': 'عدوى جلدية – من بكتيريا أو فطريات',
      'Red or Inflamed Skin_cause_3':
          'حروق شمس – الحيوانات الأليفة اللي جلدها فاتح أو شعرها خفيف ممكن تتأثر بالشمس بسهولة',
      'Red or Inflamed Skin_action_0':
          'لو الاحمرار بسيط وأليفك مش بيلحسه ← حافظ على المكان نظيف وجاف وتابع أي تغييرات',
      'Red or Inflamed Skin_action_1':
          'لو أليفك بيلحس أو بيهرش أو المكان باين عليه التهيّج ← محتاج تروح العيادة علشان تعرف السبب وتريّح أليفك',
      'Red or Inflamed Skin_action_2':
          'لو الجلد أحمر جدًا، مبلول، أو لزج ← روح العيادة',
      'Red or Inflamed Skin_action_3':
          'لو الاحمرار ظهر بعد التعرّض للشمس ← ابعد أليفك عن الشمس وروح العيادة',
      'Red or Inflamed Skin_action_4':
          'لو الاحمرار بيزيد، بيكوّن قشور، أو فيه ريحة مش حلوة ← روح العيادة فورًا',

      'Dandruff (Flaky Skin)': 'قشرة في الجلد',
      'Dandruff (Flaky Skin)_description':
          'لو لاحظت فُتافيت بيضاء صغيرة في فرو أليفك، ممكن يكون عنده جفاف في الجلد أو حاجة تانية!',
      'Dandruff (Flaky Skin)_cause_0': 'الهواء الجاف – شائع في الشتاء',
      'Dandruff (Flaky Skin)_cause_1':
          'نظام غذائي ضعيف – نقص الدهون المفيدة بيخلي الجلد ينشف',
      'Dandruff (Flaky Skin)_cause_2':
          'طفيليات – زي القراد أو البراغيث، ممكن تسبب تقشير في الجلد',
      'Dandruff (Flaky Skin)_cause_3':
          'عدوى جلدية – خاصة لو القشور معاها احمرار أو حكة',
      'Dandruff (Flaky Skin)_action_0': 'مشّط أليفك يوميًا علشان تشيل القشور',
      'Dandruff (Flaky Skin)_action_1':
          'لو القشرة معاها هرش أو تساقط شعر ← محتاج تروح العيادة',

      'Scabs or Crusty Skin': 'قشور سميكة أو طبقة ناشفة على الجلد',
      'Scabs or Crusty Skin_description':
          'لو حسيت إن جلد أليفك خشن أو فيه مناطق ناشفة و عالمة قشور، يبقى محتاج تتابع الحالة كويس.',
      'Scabs or Crusty Skin_cause_0':
          'جرب – طفيليات صغيرة بتسبب تهيّج في الجلد، تساقط شعر، وقشور خشنة',
      'Scabs or Crusty Skin_cause_1': 'هرش أو عض متكرر – بسبب براغيث أو حساسية',
      'Scabs or Crusty Skin_cause_2':
          'عدوى جلدية – بكتيريا بتسبب التهابات وقشور سميكة',
      'Scabs or Crusty Skin_action_0':
          'لو شُفت حشرات أو تساقط شعر في المكان ← روح العيادة علشان تبدأ علاج للطفيليات',
      'Scabs or Crusty Skin_action_1':
          'لو القشور بتنتشر، لون الجلد أحمر، أو فيه ريحة مش حلوة ← روح العيادة فورًا',
      'Scabs or Crusty Skin_action_2':
          'متحاولش تشيل القشور أو تحط أي كريمات من نفسك – اسأل الدكتور الأول',

      'Lumps or Bumps': 'تكتلات أو مناطق بارزة تحت الجلد',
      'Lumps or Bumps_description':
          'لو لاحظت كتلة أو ورم صغير في جسم أليفك، الأفضل إنك تتابعه وتفحصه.',
      'Lumps or Bumps_cause_0':
          'ورم دهني حميد – بتكون طرية وبتكبر ببطء وعادة مش خطيرة',
      'Lumps or Bumps_cause_1': 'خُراج – كتلة فيها صديد نتيجة عدوى أو عضة',
      'Lumps or Bumps_cause_2': 'ورم سرطاني',
      'Lumps or Bumps_cause_3': 'رد فعل تحسسي',
      'Lumps or Bumps_action_0':
          'لو الكتلة طرية، صغيرة، ومابتتغيرش ← راقبها وبلغ الدكتور عنها في الزيارة الجاية',
      'Lumps or Bumps_action_1':
          'لو بتكبر، صلبة، أو بتوجع ← روح العيادة علشان تتفحص كويس',

      'Skin Turning Darker (Hyperpigmentation)':
          'الجلد لونه بيغمق (اسمرار أو تصبغات)',
      'Skin Turning Darker (Hyperpigmentation)_description':
          'لاحظت إن فيه أماكن في جلد أليفك بدأت تغمق أو تتحوّل للون غامق أو أسود؟',
      'Skin Turning Darker (Hyperpigmentation)_cause_0':
          'تهيّج مستمر – زي الهرش أو اللحس أو الاحتكاك بشكل متكرر',
      'Skin Turning Darker (Hyperpigmentation)_cause_1':
          'حساسية جلدية أو عدوى مزمنة – ممكن تسبب بقع غامقة مع الوقت',
      'Skin Turning Darker (Hyperpigmentation)_cause_2':
          'تغيّرات هرمونية – أحيانًا بتأثر على لون الجلد',
      'Skin Turning Darker (Hyperpigmentation)_cause_3':
          'التقدم في السن – بعض الحيوانات الأليفة لون جلدها بيغمق طبيعي مع العمر',
      'Skin Turning Darker (Hyperpigmentation)_action_0':
          'لو الجلد غمق وأليفك طبيعي في تصرفه ← ممكن تكون حاجة بسيطة – تابعها وخلي عينك عليها',
      'Skin Turning Darker (Hyperpigmentation)_action_1':
          'لو فيه كمان هرش، تساقط شعر، أو تغير في الشهية أو الوزن ← محتاج تروح العيادة',
      'Skin Turning Darker (Hyperpigmentation)_action_2':
          'لو الجلد الغامق شكله خشن، سميك، أو بيزيد مع الوقت ← روح العيادة',
      'Skin Turning Darker (Hyperpigmentation)_action_3':
          'لو أليفك بيلحس أو بيهرش نفس المكان كتير ← روح العيادة',

      // Movement & Limbs Issues
      'Limping or Not Putting Weight on One Leg':
          'العرج أو عدم تحميل الوزن على رجل معينة',
      'Limping or Not Putting Weight on One Leg_description':
          'لو أليفك بيبعد عن استخدام رجل معيّنة أو بيعرج، غالبًا فيه ألم أو إصابة!',
      'Limping or Not Putting Weight on One Leg_cause_0':
          'إصابة – زي التواء، شد عضلي، أو حتى جرح صغير في الكف',
      'Limping or Not Putting Weight on One Leg_cause_1':
          'كسر أو خلع – خاصة لو الرجل شكلها وارمة أو مش في وضعها الطبيعي',
      'Limping or Not Putting Weight on One Leg_cause_2':
          'ألم في المفاصل (خشونة أو التهاب) – شائع في الحيوانات الأليفة الكبيرة في السن',
      'Limping or Not Putting Weight on One Leg_cause_3':
          'مشكلة في الأعصاب – لو الرجل بتجرّ أو مش بتتحرك طبيعي',
      'Limping or Not Putting Weight on One Leg_cause_4':
          'إصابة من وقعة – ممكن تأثر على العمود الفقري، الحوض، أو الأعصاب',
      'Limping or Not Putting Weight on One Leg_action_0':
          'بص على الكف وشوف لو فيه جرح، ورم، أو حاجة داخلة فيه',
      'Limping or Not Putting Weight on One Leg_action_1':
          'لو الحالة خفيفة وبتتحسن خلال 24 ساعة ← راقب أليفك وخليه يرتاح',
      'Limping or Not Putting Weight on One Leg_action_2':
          'لو فيه ورم، ألم، أو العرج استمر أكتر من يوم ← محتاج تروح العيادة',

      'Slowness or Trouble Standing Up': 'بطء أو صعوبة في الوقوف',
      'Slowness or Trouble Standing Up_description':
          'لو أليفك بيواجه صعوبة في إنه يقوم أو بيقوم بحركة ناشفة؟',
      'Slowness or Trouble Standing Up_cause_0':
          'خشونة أو التهاب في المفاصل – خصوصًا في الحيوانات الأليفة الكبيرة في السن',
      'Slowness or Trouble Standing Up_cause_1':
          'إجهاد عضلي – بعد لعب كتير أو جري',
      'Slowness or Trouble Standing Up_cause_2':
          'مشاكل في الحوض أو العمود الفقري – شائعة في الكلاب الكبيرة في الحجم',
      'Slowness or Trouble Standing Up_cause_3':
          'مشكلة في الأعصاب – لو الرجلين الخلفيتين باين عليهم الضعف أو عدم التوازن',
      'Slowness or Trouble Standing Up_cause_4':
          'إصابة من وقعة – ممكن تأثر على العمود الفقري أو الأعصاب',
      'Slowness or Trouble Standing Up_action_0':
          'خليه يرتاح على سطح ناعم وابعده عن النط أو السلالم',
      'Slowness or Trouble Standing Up_action_1':
          'لو حصلت مرة وتحسّنت بسرعة ← راقب الحالة يوم',
      'Slowness or Trouble Standing Up_action_2':
          'لو بتتكرر، بتزيد، أو باين عليه وجع ← روح العيادة علشان يتفحص',

      'Sudden Weakness or Collapsing': 'ضعف مفاجئ أو وقوع',
      'Sudden Weakness or Collapsing_description':
          'لو أليفك فجأة مبقاش قادر يقف أو بيقع على الأرض، دي حالة طارئة!',
      'Sudden Weakness or Collapsing_cause_0':
          'مشكلة في القلب – ممكن تسبب فقدان مؤقت للوعي',
      'Sudden Weakness or Collapsing_cause_1':
          'ألم شديد أو إصابة داخلية – بتسبب ضعف مفاجئ',
      'Sudden Weakness or Collapsing_cause_2':
          'انخفاض في سكر الدم – شائع أكتر في السلالات الصغيرة',
      'Sudden Weakness or Collapsing_cause_3':
          'مشكلة في الأعصاب أو المخ – بتأثر على التوازن والحركة',
      'Sudden Weakness or Collapsing_cause_4':
          'تسمم – نتيجة أكل، دواء، أو مادة سامة',
      'Sudden Weakness or Collapsing_action_0':
          'روح العيادة فورًا! الحالة دي طارئة ومينفعش تتأخر',

      'Trembling or Shaking': 'بيرجف أو بيرعش',
      'Trembling or Shaking_description':
          'الرجفة ممكن تكون بسبب برد، وجع، أو حاجة أخطر!',
      'Trembling or Shaking_cause_0':
          'ألم أو توتر – خصوصًا لو الرجفة معاها نحيب أو أليفك بيستخبى',
      'Trembling or Shaking_cause_1':
          'البرد (انخفاض حرارة الجسم) – شائع في الحيوانات الأليفة الصغيرة أو لو مبلولة',
      'Trembling or Shaking_cause_2':
          'تسمم – لو الرجفة حصلت فجأة ومعاها ترجيع أو ريالة',
      'Trembling or Shaking_cause_3':
          'مشكلة في الأعصاب – لو الرجل بترعش بشكل خارج عن السيطرة',
      'Trembling or Shaking_action_0': 'لو أليفك بردان ← دفّيه ببطانية',
      'Trembling or Shaking_action_1':
          'لو الرجفة حصلت بعد توتر أو خوف ← حاول تهديه وراقب الحالة',
      'Trembling or Shaking_action_2':
          'لو الرجفة معاها ترجيع، دوخة، أو ضعف ← روح العيادة فورًا',
      'Trembling or Shaking_action_3':
          'لو الرجفة بتتكرر أو بتزيد ← محتاج كشف في العيادة',

      'Swollen or Painful Joints': 'تورم أو ألم في المفاصل',
      'Swollen or Painful Joints_description':
          'لو رجل أليفك أو مفصله شكله وارم، يبقى أكيد في حاجة مش طبيعية!',
      'Swollen or Painful Joints_cause_0':
          'إصابة أو التواء – بسبب نط أو لعب عنيف',
      'Swollen or Painful Joints_cause_1':
          'عدوى – خاصة لو التورم معاه سخونة واحمرار',
      'Swollen or Painful Joints_cause_2':
          'خشونة أو التهاب مفاصل – شائعة في الحيوانت الكبيرة في السن وبتزيد مع الوقت',
      'Swollen or Painful Joints_cause_3':
          'أمراض بينقلها القراد – بعض العدوى بتسبب تورم في المفاصل',
      'Swollen or Painful Joints_cause_4':
          'إصابة من وقعة – ممكن تسبب كدمة أو ضرر في المفصل يؤدي لتورم وألم',
      'Swollen or Painful Joints_action_0':
          'لو التورم بسيط ومفيش وجع ← خليه يرتاح وتابع الحالة',
      'Swollen or Painful Joints_action_1':
          'لو فيه وجع، سخونة، أو الحالة بتسوء ← محتاج تروح العيادة',

      // Anus & Defecation Issues
      'Scooting or Dragging Butt on the Floor': 'جرّ أو حكّ المؤخرة في الأرض',
      'Scooting or Dragging Butt on the Floor_description':
          'لو أليفك بيزحف أو بيجرّ مؤخرته على الأرض كتير،كده فيه حاجة مضايقاه!',
      'Scooting or Dragging Butt on the Floor_cause_0':
          'غدد شرجية مليانة أو ملتهبة – أكياس صغيرة جنب فتحة الشرج ممكن تتسد (شائعة في الكلاب)',
      'Scooting or Dragging Butt on the Floor_cause_1': 'ديدان',
      'Scooting or Dragging Butt on the Floor_cause_2':
          'حساسية أو تهيّج في الجلد – من أكل، نجيلة، أو منتجات تنظيف',
      'Scooting or Dragging Butt on the Floor_cause_3':
          'براز لازق في الشعر – شائع في الأليفة اللي شعرها طويل',
      'Scooting or Dragging Butt on the Floor_action_0':
          'افحص المنطقة الأول — لو في حاجة لازقة، نظّفها بلطف وشوف هل التصرّف ده هيقف ولا لأ',
      'Scooting or Dragging Butt on the Floor_action_1':
          'لو الجرّ مع لعق المنطقة ← ممكن يكون الغدد الشرجية ممتلئة، الدكتور البيطري يقدر يفضيها',
      'Scooting or Dragging Butt on the Floor_action_2':
          'شوف لو فيه ديدان (ممكن تلاحظ حاجات بيضاء صغيرة شبه الرز حوالين فتحة الشرج)',
      'Scooting or Dragging Butt on the Floor_action_3':
          'اتأكد إن أليفك واخد جرعة الديدان في معادها',
      'Scooting or Dragging Butt on the Floor_action_4':
          'لو الجرّ مستمر أو في تورّم ← محتاج كشف في العيادة',

      'Swelling or Redness Around the Anus': 'تورم أو احمرار في فتحة الشرج',
      'Swelling or Redness Around the Anus_description':
          'لاحظت إن شكل مؤخرة أليفك فيها احمرار، ورم، أو حاجة طالعة لبرا؟ ممكن يكون تهيّج بسيط – أو علامة على حاجة أخطر.',
      'Swelling or Redness Around the Anus_cause_0':
          'مشكلة في الغدد الشرجية – غدد قريبة من فتحة الشرج ممكن تتورم أو تلتهب',
      'Swelling or Redness Around the Anus_cause_1':
          'حساسية – من أكل، براغيث، أو منتجات تنظيف',
      'Swelling or Redness Around the Anus_cause_2':
          'صعوبة في الإخراج أو إمساك – ممكن يسبب ورم أو حتى شوية دم',
      'Swelling or Redness Around the Anus_cause_3':
          'تدلي المستقيم – لما جزء من المستقيم يخرج لبرا، وبيكون شكله أنبوبة حمرا أو وردي ودي حالة طارئة',
      'Swelling or Redness Around the Anus_action_0':
          'لو فيه احمرار بسيط وأليفك طبيعي ← نظّف المنطقة بلُطف وتابعها',
      'Swelling or Redness Around the Anus_action_1':
          'لو فيه ورم، وجع، أو أليفك بيلحس أو بيجرّ نفسه ← محتاج تروح العيادة قريب',
      'Swelling or Redness Around the Anus_action_2':
          'لو شايف جزء لونه أحمر أو وردي طالع من فتحة الشرج ← روح العيادة فورًا',
      'Swelling or Redness Around the Anus_action_3':
          'متحاولش تدخّل أي حاجة مكانها أو تستخدم كريمات من نفسك – ده ممكن يزود المشكلة',

      'Bloody Poop (Red or Black Stools)': 'دم في البراز (براز أحمر أو أسود)',
      'Bloody Poop (Red or Black Stools)_description':
          'لو لاحظت دم في براز أليفك، ما تتجاهلش الموضوع!',
      'Bloody Poop (Red or Black Stools)_cause_0':
          'دم أحمر فاتح ← ممكن يكون من الحزق أثناء التبرز، تهيّج في المعدة، أو إصابة بسيطة قريبة من فتحة الشرج',
      'Bloody Poop (Red or Black Stools)_cause_1':
          'براز أسود ولزج زي الدم القديم ← احتمال نزيف داخلي (في المعدة أو الأمعاء)',
      'Bloody Poop (Red or Black Stools)_cause_2':
          'ديدان، عدوى، أو أمراض خطيرة',
      'Bloody Poop (Red or Black Stools)_action_0':
          'لو خطوط دم بسيطة في البراز وأليفك طبيعي ← راقب كويس لمدة ٢٤ ساعة',
      'Bloody Poop (Red or Black Stools)_action_1':
          'لو الدم كتير، بيتكرر، أو أليفك ضعيف ← روح العيادة فورًا!',
      'Bloody Poop (Red or Black Stools)_action_2':
          'لو البراز أسود ولزج زي الدم القديم ← حالة طارئة! لازم تروح العيادة فورًا علشان نستبعد نزيف داخلي',

      'Straining to Poop or Constipation': 'صعوبة في التبرز أو إمساك',
      'Straining to Poop or Constipation_description':
          'لو أليفك بيحاول يعمل حمّام لكن مفيش حاجة بتطلع؟',
      'Straining to Poop or Constipation_cause_0':
          'قلة شرب المية – بيؤدي لبراز ناشف وصعب الخروج',
      'Straining to Poop or Constipation_cause_1':
          'كرات الشعر (في القطط) – ممكن تبطّأ أو تسد الأمعاء',
      'Straining to Poop or Constipation_cause_2':
          'أكل عظام أو أجسام غريبة – ممكن يسبب انسداد',
      'Straining to Poop or Constipation_cause_3':
          'مشكلة في الغدد الشرجية – الألم بيخلي التبرز صعب',
      'Straining to Poop or Constipation_cause_4': 'مشاكل تانية خطيرة',
      'Straining to Poop or Constipation_action_0':
          'وفّر مية أكتر وأضف ألياف للأكل (بطاطس مسلوقة مهروسة أو جزر مسلوق ممكن يساعدوا)',
      'Straining to Poop or Constipation_action_1':
          'لو الإمساك استمر أكتر من ٤٨ ساعة ← محتاج كشف في العيادة علشان نتجنب انسداد في الأمعاء',
      'Straining to Poop or Constipation_action_2':
          'لو في محاولات للتبرز لكن مفيش براز بيطلع خالص ← احتمال يكون انسداد، وده محتاج زيارة طارئة للعيادة',
      'Straining to Poop or Constipation_action_3':
          '⚠️ مهم: أحيانًا صعوبة التبرز بتلخبط مع صعوبة التبول، خصوصًا في القطط الذكور — ودي حالة ممكن تكون مميتة. شوف قسم "صعوبة التبول" تحت مشاكل التبول علشان تعرف الخطوات الضرورية',

      'Diarrhea': 'الإسهال',
      'Diarrhea_description': 'أليفك عنده إسهال؟ حاول متخليش الموضوع يطول.',
      'Diarrhea_cause_0': 'أكل حاجة وحشة (زبالة، أكل بايظ)',
      'Diarrhea_cause_1': 'ديدان أو طفيليات',
      'Diarrhea_cause_2': 'عدوى بكتيرية أو فيروسية',
      'Diarrhea_cause_3': 'حساسية أكل أو تغيير مفاجئ في نوع الأكل',
      'Diarrhea_cause_4': 'توتر أو قلق',
      'Diarrhea_cause_5': 'مشاكل خطيرة زي أمراض البنكرياس أو الكبد',
      'Diarrhea_action_0':
          'لو الإسهال حصل مرة أو اتنين وأليفك طبيعي ← جرب أكل بسيط زي فراخ مسلوقة مع رز أبيض، وراقب لمدة ٢٤ ساعة',
      'Diarrhea_action_1':
          'لو الإسهال استمر أكتر من يومين، أو فيه دم، أو معاه ترجيع/خمول ← لازم كشف عند دكتور، ممكن يكون خطير',
      'Diarrhea_action_2':
          'لو أليفك لسه صغير في السن أو من سلالة صغيرة ← متستناش! الإسهال ممكن يسبب جفاف بسرعة',

      'No Pooping at All (Emergency!)': 'مفيش تبرز خالص (طوارئ)',
      'No Pooping at All (Emergency!)_description':
          'لو أليفك معملش براز لأكتر من 3 ايام، ممكن يكون عنده انسداد!',
      'No Pooping at All (Emergency!)_cause_0':
          'إمساك شديد أو انسداد في الأمعاء',
      'No Pooping at All (Emergency!)_cause_1':
          'ابتلاع جسم غريب (ألعاب، عظام، شعر، خيط)',
      'No Pooping at All (Emergency!)_cause_2':
          'مشاكل في الأعصاب بتأثر على حركة الأمعاء (زي إصابات العمود الفقري)',
      'No Pooping at All (Emergency!)_action_0':
          'لو مفيش براز لأكتر من 3 ايام ← روح العيادة فورًا! متستناش، ممكن يكون خطير',
      'No Pooping at All (Emergency!)_action_1':
          'لو أليفك بيحاول يتبرز لكن مفيش حاجة خارجة ومعاه ألم ← حالة طارئة! احتمال انسداد',
      'No Pooping at All (Emergency!)_action_2':
          'لو شاكك إن أليفك بلع حاجة (زي خيط، قماشة، عظام) ← لازم تروح العيادة فورًا',

      // Male Genital Problems
      'Swollen Testicles': 'تورم الخصيتين',
      'Swollen Testicles_description':
          'لو خصيتين أليفك شكلهم أكبر من المعتاد، يبقى في حاجة مش طبيعية.',
      'Swollen Testicles_cause_0': 'التهاب أو عدوى',
      'Swollen Testicles_cause_1': 'إصابة (زي خبطة أو وقعة)',
      'Swollen Testicles_cause_2':
          'أورام سرطانية في الخصية (خصوصًا في الكلاب الكبيرة اللي متعقمّتش)',
      'Swollen Testicles_cause_3': 'التواء الخصية',
      'Swollen Testicles_action_0':
          'لو التورم بسيط ومفيش ألم ← راقب الحالة وروح العيادة قريب',
      'Swollen Testicles_action_1':
          'لو فيه تورم مع احمرار أو ألم ← روح العيادة',
      'Swollen Testicles_action_2':
          'لو خصية واحدة أكبر من التانية بوضوح ← روح العيادة فورًا',

      'Discharge from the Penis': 'إفرازات من القضيب',
      'Discharge from the Penis_description':
          'كمية صغيرة من سائل أصفر فاتح أو شفاف ممكن تكون طبيعية، لكن الإفرازات الكتيرة أو اللي ريحتها وحشة مش طبيعية.',
      'Discharge from the Penis_cause_0':
          'سائل طبيعي – كمية صغيرة من إفراز أصفر فاتح أو شفاف بيظهر أحيانًا',
      'Discharge from the Penis_cause_1':
          'عدوى – إفراز سميك، ريحته وحشة، أو لونه أخضر ممكن يكون بسبب بكتيريا',
      'Discharge from the Penis_cause_2':
          'إصابة أو تهيج – نتيجة لعق، احتكاك، أو خبطة بسيطة',
      'Discharge from the Penis_cause_3':
          'مشاكل في البروستاتا – شائعة أكتر في الكلاب الكبيرة اللي متعقمّتش',
      'Discharge from the Penis_action_0':
          'لو إفراز بسيط، لونه أصفر فاتح أو شفاف، وأليفك طبيعي ← ده عادي، امسحه بلطف',
      'Discharge from the Penis_action_1':
          'لو الإفراز سميك، ريحته وحشة، لونه أخضر، أو كميته كبيرة ← روح العيادة',
      'Discharge from the Penis_action_2':
          'لو أليفك بيلعق المنطقة طول الوقت أو بيعاني وهو بيعمل حمام ← محتاج كشف في العيادة',

      'Red, Swollen, or Hanging Out Penis':
          'القضيب متورّم أو بارز ومبيرجعش مكانه',
      'Red, Swollen, or Hanging Out Penis_description':
          'لو قضيب أليفك ما بيرجعش مكانه، دي حالة طارئ محتاجة تدخل فوري!',
      'Red, Swollen, or Hanging Out Penis_cause_0':
          'شعر أو وساخة عالقين مانعين رجوع القضيب',
      'Red, Swollen, or Hanging Out Penis_cause_1': 'إصابة أو تلف في الأعصاب',
      'Red, Swollen, or Hanging Out Penis_cause_2': 'عدوى أو التهاب',
      'Red, Swollen, or Hanging Out Penis_action_0':
          'لو التورم بسيط والقضيب بيرجع مكانه ←حاول تروح العيادة قريب',
      'Red, Swollen, or Hanging Out Penis_action_1':
          'لو القضيب بره و مبيرجعش، لونه أحمر أو متورم ← حالة طارئة! لفه بقطعة قماش نظيفة ومبلولة بمياه فاترة ← وروح العيادة فورًا',

      'Missing or Undescended Testicles': 'خصية أو خصيتين مش موجودين',
      'Missing or Undescended Testicles_description':
          'لو في خصية أو أكتر ما نزلتش مكانها الطبيعي، الموضوع مش مجرد شكل — ممكن يسبب مشاكل صحية خطيرة.',
      'Missing or Undescended Testicles_cause_0':
          'مشكلة وراثية — حالة بتخلي خصية أو الاتنين يفضلوا جوه الجسم، وده ممكن يزود خطر الإصابة بالسرطان بعدين',
      'Missing or Undescended Testicles_action_0':
          'لو جرو أو قطة أقل من 6 شهور ← استنى شوية، ممكن تنزل طبيعي',
      'Missing or Undescended Testicles_action_1':
          'لو أكبر من 6 شهور ولسه في خصية مش موجودة ← روح العيادة، غالبًا هتحتاج عملية',
      'Missing or Undescended Testicles_action_2':
          'متجوزش حيوانات بالصفة دي — لأنها بتتنقل للجيل الجديد',

      'Sudden Shrinking or Hardening of Testicles':
          'انكماش أو تصلب الخصيتين فجأة',
      'Sudden Shrinking or Hardening of Testicles_description':
          'لو خصيتين أليفك صغروا فجأة أو بقوا ناشفين، ممكن يكون الموضوع خطير!',
      'Sudden Shrinking or Hardening of Testicles_cause_0': 'مشاكل هرمونية',
      'Sudden Shrinking or Hardening of Testicles_cause_1':
          'انكماش طبيعي مع التقدم في العمر',
      'Sudden Shrinking or Hardening of Testicles_cause_2': 'سرطان الخصية',
      'Sudden Shrinking or Hardening of Testicles_action_0':
          'لو الانكماش تدريجي ومفيش أي أعراض تانية ← احجز كشف عند العيادة عشان تطمن',
      'Sudden Shrinking or Hardening of Testicles_action_1':
          'لو الانكماش مفاجئ أو في خصية واحدة بقت ناشفة ← روح العيادة فورًا',

      'Lumps or Bleeding from the Genitals':
          'كتل أو أورام على الأعضاء التناسلية',
      'Lumps or Bleeding from the Genitals_description':
          'لو لاحظت كتلة، ورم، أو نزيف حوالين الأعضاء التناسلية لأليفك، ما تتجاهلش الموضوع!',
      'Lumps or Bleeding from the Genitals_cause_0': 'عدوى – بكتيرية أو فطرية',
      'Lumps or Bleeding from the Genitals_cause_1':
          'إصابة أو تهيّج – من أسطح خشنة، لعق مفرط، أو إصابة مباشرة',
      'Lumps or Bleeding from the Genitals_cause_2':
          'ورم أو نمو – بعض الكتل حميدة، لكن بعضها محتاج علاج',
      'Lumps or Bleeding from the Genitals_cause_3':
          'ورم سرطاني معدي (TVT) – سرطان معدي بين الكلاب، شائع في الكلاب الضالة أو غير المُعقمة',
      'Lumps or Bleeding from the Genitals_action_0':
          'لو الكتلة صغيرة، طرية، مش بتكبر، وأليفك مرتاح ← امنع اللعق وراقب لمدة 24 ساعة',
      'Lumps or Bleeding from the Genitals_action_1':
          'لو الكتلة حمراء، بتكبر، أو فيها نزيف ← روح العيادة فورًا',
      'Lumps or Bleeding from the Genitals_action_2':
          'لو أليفك اختلط بكلاب ضالة ← اعمله فحص، ممكن يكون مصاب بـ TVT',

      // Female Genital Problems
      'Swollen Vulva': 'تورم الفرج',
      'Swollen Vulva_description':
          'لو لاحظت إن فرج أليفتك متورم، ممكن يكون جزء طبيعي من دورتها، أو علامة على مشكلة صحية!',
      'Swollen Vulva_cause_0':
          'الدورة الطبيعية (فترة التزاوج) – الكلاب الإناث بيكون عندها تورم وتغيرات في السلوك في فترة التزاوج (الكلاب الي متعقمتش بس)',
      'Swollen Vulva_cause_1':
          'عدوى (التهاب الفرج) – خاصة لو التورم مع إفرازات أو لحس مفرط للمنطقة',
      'Swollen Vulva_cause_2': 'حساسية – من أكل، عشب، أو منتجات تنظيف',
      'Swollen Vulva_cause_3': 'إصابة أو تهيج – من لحس مفرط أو احتكاك قوي',
      'Swollen Vulva_action_0':
          'لو اليفتك متعقمتش افحص علامات فترة التزاوج ← لو التورم مع تغيرات سلوكية (قلق، جذب الكلاب الذكور، أو نقط دم)، غالبًا طبيعي',
      'Swollen Vulva_action_1':
          'لو مش متأكد ← راقبها من يومين ل3 أيام؛ لو التورم زاد أو ظهر إفرازات، روح العيادة',
      'Swollen Vulva_action_2':
          'لو التورم مفاجئ، شديد، أو مؤلم ← روح العيادة فورًا',

      'Discharge from the Vulva': 'إفرازات من الفرج',
      'Discharge from the Vulva_description':
          'شوية إفرازات شفافة أو بيضاء ممكن تكون طبيعية، لكن أي إفرازات لها ريحة أو شكل غريب ده مش طبيعي!',
      'Discharge from the Vulva_cause_0':
          'فترة التزاوج – لو أليفتك متعقمتش، طبيعي يكون في شوية إفرازات شفافة وقتها',
      'Discharge from the Vulva_cause_1':
          'عدوى – البكتيريا ممكن تسبب تهيّج وإفرازات غير طبيعية',
      'Discharge from the Vulva_cause_2':
          'التهاب الرحم الصديدي (Pyometra) – بيحصل في الإناث اللي متعقمّتش، ودي حالة طارئة و خطيرة جدًا. ممكن يحصل كمان بعد التعقيم بفترة قصيرة و اسمه (stump pyometra)',
      'Discharge from the Vulva_cause_3':
          'أورام – أقل شيوعًا، لكن ممكن تحصل خصوصًا في الحيوانات الكبيرة في السن',
      'Discharge from the Vulva_action_0':
          'لو الإفرازات شفافة، مفيهاش ريحة، وأليفك طبيعي وبيأكل كويس ← طبيعي، خصوصًا لو في فترة التزاوج',
      'Discharge from the Vulva_action_1':
          'لو الإفرازات سميكة أو لونها أصفر/أخضر أو ريحتها وحشة، أو شبه الطحينة ← محتاج كشف فورًا',
      'Discharge from the Vulva_action_2':
          'لو أليفك ضعيف، مش بيأكل، بطنه منفوخة أو بيشرب مياه كتير ← طوارئ!',

      'Excessive Licking of Genital Area': 'اللحس المفرط للمنطقة التناسلية',
      'Excessive Licking of Genital Area_description':
          'شوية لحس طبيعي، لكن لو أليفك بيلحس طول الوقت يبقى في مشكلة!',
      'Excessive Licking of Genital Area_cause_0':
          'عدوى – زي التهاب المسالك البولية أو التهاب الفرج، والبكتيريا ممكن تسبب تهيّج وعدم راحة',
      'Excessive Licking of Genital Area_cause_1':
          'تهيّج من حساسية أو لدغة حشرة – بتعمل حكة في المنطقة',
      'Excessive Licking of Genital Area_cause_2':
          'التهاب الرحم – حالة خطيرة في الرحم بتحتاج تدخل عاجل',
      'Excessive Licking of Genital Area_cause_3':
          'جسم غريب في المنطقة – زي تراب، شعر، أو جسم صغير',
      'Excessive Licking of Genital Area_action_0':
          'لو اللحس بيحصل أحيانًا ومفيش أي أعراض تانية ← طبيعي، بس تابع الوضع',
      'Excessive Licking of Genital Area_action_1':
          'لو اللحس مستمر ومعاه احمرار أو تورم ← روح العيادة',
      'Excessive Licking of Genital Area_action_2':
          'لو اللحس مع إفرازات أو ريحة وحشة ← احتمال عدوى أو التهاب رحم، روح العيادة فورًا!',

      'Something Sticking Out from the Vulva': 'خروج شيء من الفرج',
      'Something Sticking Out from the Vulva_description':
          'لو لاحظت أن في نسيج أو كتلة لونها وردي، أحمر، أو أسود طالع من فرج أليفك — الموضوع خطير!',
      'Something Sticking Out from the Vulva_cause_0':
          'دفع شديد أثناء الولادة – ممكن يسبب خروج أنسجة',
      'Something Sticking Out from the Vulva_cause_1':
          'ضعف عضلات الحوض – بيحصل أكتر في الحيوانات الكبيرة في السن',
      'Something Sticking Out from the Vulva_cause_2':
          'إصابة أو مشاكل هرمونية – ممكن تخلي الأنسجة تنزلق للخارج',
      'Something Sticking Out from the Vulva_cause_3':
          'بعد الولادة – ممكن يكون بقايا مشيمة أو أغشية جنينية',
      'Something Sticking Out from the Vulva_action_0':
          'متحاولش ترجع أي حاجة لجوا بنفسك',
      'Something Sticking Out from the Vulva_action_1':
          'حافظ على نظافة المنطقة ورطوبتها (استخدم قماشة نظيفة مبلولة)',
      'Something Sticking Out from the Vulva_action_2':
          'لو حصل بعد الولادة مباشرة ← بردو حالة طارئة؛ المشيمة المحتجزة ممكن تسبب عدوى قاتلة',
      'Something Sticking Out from the Vulva_action_3': 'روح العيادة فورًا!',

      'Bleeding from the Genital Area': 'نزيف من المنطقة التناسلية',
      'Bleeding from the Genital Area_description':
          'لاحظت دم؟ ممكن يكون طبيعي أو علامة على مشكلة خطيرة!',
      'Bleeding from the Genital Area_cause_0':
          'دورة التزاوج الطبيعية (في الإناث غير المُعقمة) – نزيف خفيف ممكن يحصل أثناء فترة التزاوج',
      'Bleeding from the Genital Area_cause_1':
          'التهاب الرحم الصديدي (Pyometra) – عدوى خطيرة وبتحتاج تدخل فوري',
      'Bleeding from the Genital Area_cause_2':
          'إصابة – خدوش، عضات، أو لعب عنيف ممكن يسبب نزيف',
      'Bleeding from the Genital Area_cause_3':
          'أورام – نموات في الجهاز التناسلي ممكن تنزف',
      'Bleeding from the Genital Area_cause_4': 'مشاكل تجلط الدم',
      'Bleeding from the Genital Area_action_0':
          'لو بقع دم بسيطة وأليفك أنثى مش مُعقمة ← غالبا دي دورة التزاوج، راقب العلامات التانية',
      'Bleeding from the Genital Area_action_1':
          'لو النزيف شديد أو أليفك ضعيف، مش بياكل، أو بطنه منتفخة ← حالة طارئة! ← روح العيادة فورًا!',

      // Urination Problems
      'Peeing Too Much (Frequent Urination)': 'كثرة التبول (أكثر من المعتاد)',
      'Peeing Too Much (Frequent Urination)_description':
          'لو أليفك بيعمل حمام أكتر من الطبيعي، حتى لو بكميات صغيرة، ممكن يكون فيه مشكلة صحية.',
      'Peeing Too Much (Frequent Urination)_cause_0':
          'عدوى بالمثانة (UTI) – بتسبب التبول كتير وأحيانًا بألم',
      'Peeing Too Much (Frequent Urination)_cause_1':
          'مرض السكري أو مشاكل الكلى – بيجي معاهم شرب مياه أكتر من المعتاد',
      'Peeing Too Much (Frequent Urination)_cause_2':
          'مشاكل هرمونية – ممكن تأثر على التحكم في التبول',
      'Peeing Too Much (Frequent Urination)_action_0':
          'لو بيتبول كتير + بيشرب مياه أكتر من المعتاد ← روح العيادة علشان نستبعد السكر أو مشاكل الكُلى',
      'Peeing Too Much (Frequent Urination)_action_1':
          'لو بيتبول كتير + فيه صعوبة أو دم أو بيعمل في أماكن غلط ← ممكن تكون عدوى أو مشكلة في المثانة، لازم عيادة',
      'Peeing Too Much (Frequent Urination)_action_2':
          'لو مفيش أعراض تانية وأليفك طبيعي في سلوكه ← راقبه ٢٤ ساعة، ولو استمر روح العيادة',
      'Peeing Too Much (Frequent Urination)_action_3':
          '⚠ مهم: في القطط الذكور، لو بيروح الليتر بوكس كتير وبيعمل نقط بسيطة ، ممكن يكون انسداد في مجرى البول — وده خطر على حياته. روح العيادة فورًا',

      'Straining to Pee (Difficulty Urinating)': 'صعوبة في التبول',
      'Straining to Pee (Difficulty Urinating)_description':
          'لو أليفك بيقعد يحاول يعمل حمام فترة طويلة وما بيطلعش غير نقط بسيطة أو مفيش بول خالص، ده إنذار خطر!',
      'Straining to Pee (Difficulty Urinating)_cause_0':
          'عدوى بالمثانة (UTI) – بتخلي التبول مؤلم وصعب',
      'Straining to Pee (Difficulty Urinating)_cause_1':
          'حصوات المثانة – ممكن تسد مجرى البول أو تسبب تهيّج',
      'Straining to Pee (Difficulty Urinating)_cause_2':
          'انسداد في مجرى البول – حالة طارئة تهدد الحياة',
      'Straining to Pee (Difficulty Urinating)_cause_3':
          'مشاكل في البروستاتا – بتضغط على المثانة وتمنع خروج البول',
      'Straining to Pee (Difficulty Urinating)_action_0':
          'لو في محاولة للتبول بس بيطلع نقط بسيطة ← محتاج عيادة (ممكن عدوى أو حصوات)',
      'Straining to Pee (Difficulty Urinating)_action_1':
          'لو بيحاول يتبول ومفيش حاجة بتنزل ← 🚨 حالة طارئة! الانسداد ممكن يقتل القط الذكر في خلال يوم او يومين. روح العيادة فورًا',
      'Straining to Pee (Difficulty Urinating)_action_2':
          'لو في صعوبة + دم في البول ← لازم عيادة',

      'Peeing in Wrong Places': 'التبول في أماكن غلط',
      'Peeing in Wrong Places_description':
          'لو أليفك فجأة بدأ يعمل حمام في أماكن مش المفروض يعمل فيها، في سبب ورا الموضوع!',
      'Peeing in Wrong Places_cause_0':
          'تحديد منطقة أو سلوك تزاوج – بيحصل أكتر في الحيوانات اللي مش مُعقمة',
      'Peeing in Wrong Places_cause_1':
          'عدوى بالمثانة (UTI) – بتسبب رغبة ملحة للتبول',
      'Peeing in Wrong Places_cause_2':
          'التوتر أو القلق – التغييرات في البيت ممكن تسبب الموضوع ده',
      'Peeing in Wrong Places_cause_3':
          'مشاكل في التحكم بالمثانة – شائعة أكتر في الحيوانات الكبيرة في السن',
      'Peeing in Wrong Places_cause_4':
          'مرض السكري أو مشاكل الكلى – ممكن بسبب كثرة التبول',
      'Peeing in Wrong Places_action_0':
          'لو بيتبول على الأثاث أو الحيطان ← ممكن يكون تحديد منطقة. التعقيم ممكن يساعد',
      'Peeing in Wrong Places_action_1':
          'لو أليفك متدرب كويس وفجأة بدأ يتبول في أماكن غلط ← دور على علامات عدوى المثانة: تبول متكرر، صعوبة، أو دم في البول. لو لاحظت ده، روح العيادة',
      'Peeing in Wrong Places_action_2':
          'لوالموضوع ده بيحصل بس لما بيكون خايف أو متوتر ← حاول توفّر جو هادئ',
      'Peeing in Wrong Places_action_3':
          'لو بتحصل في حيوان كبير في السن ← ممكن تكون مشكلة في التحكم بالمثانة، محتاج تروح العيادة علشان الدكتور يحدد السبب ويكتب العلاج المناسب',

      'Bloody Urine (Red or Pink Pee)': 'دم في البول (لونه أحمر أو وردي)',
      'Bloody Urine (Red or Pink Pee)_description':
          'لو بول أليفك لونه أحمر أو وردي، ما تتجاهلش الموضوع!',
      'Bloody Urine (Red or Pink Pee)_cause_0':
          'عدوى في المسالك البولية (UTI) – ممكن تسبب تهيّج ونزيف',
      'Bloody Urine (Red or Pink Pee)_cause_1':
          'حصوات في المثانة – ترسّبات معدنية صلبة تسبب تهيّج ونزيف',
      'Bloody Urine (Red or Pink Pee)_cause_2':
          'أورام في المثانة أو المسالك البولية – بتحصل أكتر في الحيوانات الكبيرة في السن',
      'Bloody Urine (Red or Pink Pee)_cause_3':
          'إصابة أو حادث – الوقوع أوخبطة قوية ممكن تسبب نزيف داخلي',
      'Bloody Urine (Red or Pink Pee)_action_0':
          'لو دم في البول + بيتبول كتير أو بصعوبة ← روح العيادة فورًا! ممكن تكون عدوى أو حصوات',
      'Bloody Urine (Red or Pink Pee)_action_1':
          'لو الدم ظهر مرة واحدة وأليفك طبيعي ← تابع كويس، ولو اتكرر روح العيادة',
      'Bloody Urine (Red or Pink Pee)_action_2':
          'لو أليفك اتصاب أو وقع من مكان عالي ← لازم كشف في العيادة علشان نستبعد أي إصابة داخلية',

      'Leaking Urine (Dripping or Wet Spots While Resting)':
          'تسريب بول (تنقيط أو بقع مبلولة أثناء الراحة)',
      'Leaking Urine (Dripping or Wet Spots While Resting)_description':
          'لو أليفك بيترك بقع مبلولة في المكان اللي قاعد فيه، ممكن يكون عنده مشكلة في التحكم بالمثانة.',
      'Leaking Urine (Dripping or Wet Spots While Resting)_cause_0':
          'ضعف عضلات المثانة – شائع في الكلاب الكبيرة في السن',
      'Leaking Urine (Dripping or Wet Spots While Resting)_cause_1':
          'عدوى في المسالك البولية (UTI) – ممكن تسبب تهيّج وتسريب',
      'Leaking Urine (Dripping or Wet Spots While Resting)_cause_2':
          'تلف في الأعصاب – ممكن يأثر على التحكم في المثانة، خصوصًا بعد إصابة',
      'Leaking Urine (Dripping or Wet Spots While Resting)_cause_3':
          'مشاكل في البروستاتا (في الذكور) – ممكن تسبب تنقيط البول',
      'Leaking Urine (Dripping or Wet Spots While Resting)_action_0':
          'لو التسريب بيحصل أثناء النوم أو الراحة ← احجز كشف بيطري لمعرفة السبب',
      'Leaking Urine (Dripping or Wet Spots While Resting)_action_1':
          'لو التسريب مع ريحة قوية، بول عكر، أو لعق المنطقة ← غالبًا عدوى وتحتاج علاج',
      'Leaking Urine (Dripping or Wet Spots While Resting)_action_2':
          'لو التسريب مع صعوبة في المشي أو ضعف في الرجلين الخلفيتين ← ممكن يكون سببه الأعصاب، ضروري كشف عاجل',
      'Leaking Urine (Dripping or Wet Spots While Resting)_action_3':
          'حافظ على المنطقة نظيفة وجافة لحد ما يبدأ العلاج علشان تمنع تهيّج الجلد',

      'Not Peeing at All (Emergency!)': 'انقطاع التبول تمامًا (حالة طارئة!)',
      'Not Peeing at All (Emergency!)_description':
          'لو أليفك متبولش نهائي لمدة أكتر من 24 ساعة، دي حالة تهدد حياته!',
      'Not Peeing at All (Emergency!)_cause_0':
          'انسداد في المسالك البولية – شائع في القطط الذكور وممكن يكون قاتل لو متعالجش بسرعة',
      'Not Peeing at All (Emergency!)_cause_1':
          'فشل كلوي – الكلى بتتوقف عن تصفية السموم، فبتتراكم في الجسم',
      'Not Peeing at All (Emergency!)_cause_2':
          'جفاف شديد – ممكن يحصل بعد ترجيع، إسهال، أو التعرض لحرارة عالية',
      'Not Peeing at All (Emergency!)_action_0':
          'لو أليفك بيحاول يتبول لكن مش بيطلع حاجة ←  طوارئ! روح العيادة فورًا',
      'Not Peeing at All (Emergency!)_action_1':
          'لو مش بيتبول + ضعيف أو مرهق ← ممكن يكون فشل كلوي، محتاج علاج عاجل',
      'Not Peeing at All (Emergency!)_action_2':
          'لو مفيش تبول + مرض أو جفاف مؤخّرًا ← محتاج محاليل وكشف بيطري فورًا',

      // Neurological Issues
      'Seizures': 'نوبات تشنج (ارتعاش، سقوط، حركات لا إرادية)',
      'Seizures_description':
          'لو أليفك فجأة بدأ يهتز، يسيل لعابه، أو وقع على الأرض، ممكن تكون نوبة تشنج!',
      'Seizures_cause_0': 'الصرع – بعض الحيوانات بتتولد بيه',
      'Seizures_cause_1': 'تسمم – زي الشوكولاتة، أدوية البشر، أو مواد سامة',
      'Seizures_cause_2': 'إصابة في الرأس',
      'Seizures_cause_3': 'مشاكل في الكبد أو الكلى',
      'Seizures_cause_4': 'انخفاض مستوى السكر في الدم',
      'Seizures_cause_5': 'أورام في المخ (نادرة)',
      'Seizures_action_0': 'حافظ على هدوئك ← ما تحاولش تمسكه أو تثبّته بالقوة',
      'Seizures_action_1': 'ابعد أي حاجة حواليه ← علشان ما يتخبطش و ميتأذيش',
      'Seizures_action_2': 'متديش أكل أو مياه غير لما يرجع طبيعي تمامًا',
      'Seizures_action_3':
          'راقب الوقت ← لو النوبة عدّت دقيقتين ← 🚨 حالة طارئة',
      'Seizures_action_4':
          'لو تقدر، صوّر فيديو للنوبة ← بيساعد الدكتور البيطري في التشخيص',
      'Seizures_action_5':
          'بعد انتهاء النوبة ← خلّي أليفك هادي ومرتاح؛ لما يصحى قدّمله مياه',
      'Seizures_action_6':
          'لازم تروح العيادة لو: النوبة استمرت أكتر من دقيقتين، حصل أكتر من نوبة في ٢٤ ساعة، ما رجعش لطبيعته بسرعة أو باين عليه ضعف شديد',
      'Seizures_action_7':
          'روح العيادة بعد انتهاء النوبة (ممنوع تحاول تنقله وهو لسه بيتشنج)',

      'Head Tilt or Walking in Circles': 'ميلان الرأس أو المشي في دوائر',
      'Head Tilt or Walking in Circles_description':
          'لو أليفك بيميل راسه ناحية واحدة أو بيلف في دواير، ممكن يكون فيه مشكلة في المخ أو الأذن الداخلية!',
      'Head Tilt or Walking in Circles_cause_0':
          'التهاب في الأذن – من أكتر الأسباب شيوعًا، خصوصًا لو فيه هرش أو ريحة وحشة',
      'Head Tilt or Walking in Circles_cause_1':
          'مشاكل توازن – بتحصل أكتر في الحيوانات الكبيرة في السن',
      'Head Tilt or Walking in Circles_cause_2': 'سموم أو أدوية معينة',
      'Head Tilt or Walking in Circles_cause_3':
          'مشاكل في المخ (ورم أو إصابة) – أقل شيوعًا',
      'Head Tilt or Walking in Circles_action_0':
          'لو الموضوع بدأ قريب وأليفك طبيعي في باقي تصرفاته ← تابع الحالة كويس لمدة 24 ساعة',
      'Head Tilt or Walking in Circles_action_1':
          'افحص ودانه ← لو فيه احمرار، ورم، أو ريحة وحشة ممكن يكون التهاب أذن ← محتاج عيادة',
      'Head Tilt or Walking in Circles_action_2':
          'لو مفيش علامات التهاب أذن لكن الأعراض مستمرة ← ممكن تكون مشكلة عصبية، لازم كشف بيطري',
      'Head Tilt or Walking in Circles_action_3':
          'لو الميلان مستمر أو بيزيد ← احجز زيارة للعيادة',
      'Head Tilt or Walking in Circles_action_4':
          'لو أليفك بيقع، بيلف في دواير، أو مش قادر يقف كويس ← روح العيادة فورًا',

      'Loss of Balance': 'فقدان التوازن (تَعَثّر، وقوع، ضعف في الرجلين)',
      'Loss of Balance_description':
          'لو أليفك فجأة بدأ يتعثر، يترنح، أو يقع، ده ممكن يكون علامة على حاجة خطيرة!',
      'Loss of Balance_cause_0': 'تسمم – زي الشوكولاتة، البصل، أو أدوية بشرية',
      'Loss of Balance_cause_1':
          'التهاب في الأذن – ممكن يأثر على التوازن والتنسيق',
      'Loss of Balance_cause_2':
          'مشاكل توازن مرتبطة بالعُمر – بتحصل أكتر مع الحيوانات الكبيرة في السن',
      'Loss of Balance_cause_3':
          'إصابة في العمود الفقري – نتيجة خبطة أو سقوط ممكن تأثر على الأعصاب أو الحركة',
      'Loss of Balance_cause_4':
          'جلطة دماغية – فقدان مفاجئ للتوازن أو ضعف في الأطراف',
      'Loss of Balance_cause_5': 'أمراض عصبية – مشاكل في المخ أو الأعصاب',
      'Loss of Balance_action_0':
          'لو أليفك بيترنح شوية لكن صاحي وماشي كويس و بياكل كويس ← تابع الحالة كويس كام ساعة ولو متحسنش روح العيادة',
      'Loss of Balance_action_1':
          'لو مش قادر يقف خالص أو بيقع على طول ← حالة طارئة، لازم تروح العيادة فورًا',
      'Loss of Balance_action_2':
          'لو فقدان التوازن جاي مع ترجيع أو ميلان في الرأس ← محتاج كشف في العيادة بسرعة',
      'Loss of Balance_action_3':
          'لو شاكك في تسمم ← طوارئ، لازم تروح العيادة فورًا!',

      'Sudden Blindness':
          'فقدان البصر المفاجئ (بيخبط في الحيطان، توسع نني العين، ارتباك)',
      'Sudden Blindness_description':
          'لو أليفك فجأة بدأ يخبط في الحيطان، حاسس انو تايه، أو نني عينه واسع على الآخر ومش بيتأثر بالضوء — ده ممكن يكون فقدان بصر مفاجئ.',
      'Sudden Blindness_cause_0':
          'ارتفاع ضغط الدم – شائع جدًا خصوصًا في القطط الكبيرة في السن',
      'Sudden Blindness_cause_1':
          'انفصال الشبكية – ممكن يحصل فجأة ويسبب عمى كامل',
      'Sudden Blindness_cause_2':
          'مضاعفات مرض السكري – ممكن تأثر على العين مع الوقت',
      'Sudden Blindness_cause_3': 'مشاكل في المخ – زي جلطة أو ورم (أقل شيوعًا)',
      'Sudden Blindness_cause_4':
          'أمراض العين – زي المياه الزرقاء أو المياه البيضاء',
      'Sudden Blindness_action_0':
          'لو فقدان البصر تدريجي ← روح العيادة عشان تكشف على العيون',
      'Sudden Blindness_action_1':
          'لو فقدان البصر حصل فجأة (خبط في الحيطان، مش مميز الأشخاص/الأماكن) ← لازم تروح العيادة فورًا! العلاج السريع (خصوصًا في حالات ارتفاع ضغط الدم) ممكن ينقذ النظر',
      'Sudden Blindness_action_2':
          'لو النني واسع جدًا ومش بيتأثر بالضوء ← حالة طارئة، لازم تروح العيادة فورًا',

      'Sudden Collapse or Fainting': 'سقوط أو إغماء مفاجئ',
      'Sudden Collapse or Fainting_description':
          'لو أليفك وقع فجأة وبان عليه كأنه فاقد الوعي — حتى لو للحظة قصيرة — ده إنذار خطر.',
      'Sudden Collapse or Fainting_cause_0':
          'مرض في القلب – ممكن يسبب إغماء أو سقوط مفاجئ',
      'Sudden Collapse or Fainting_cause_1':
          'أنيميا – نقص الدم بيخلّي الحيوان ضعيف وسهل يدوخ أو يقع',
      'Sudden Collapse or Fainting_cause_2':
          'انخفاض السكر في الدم – شائع في الحيوانات الأليفة الصغيرة أو المصابة بالسكري',
      'Sudden Collapse or Fainting_cause_3':
          'ضربة شمس – خصوصًا بعد التعرض للشمس كتير',
      'Sudden Collapse or Fainting_cause_4':
          'تسمم – من أكل سام، أدوية بشر، أو مواد كيميائية',
      'Sudden Collapse or Fainting_action_0':
          'لو أليفك وقع بس فاق بسرعة ← قول للدكتور على الموضوع في الزيارة الجاية عشان تطمن',
      'Sudden Collapse or Fainting_action_1':
          'لو السقوط مع لثة باهتة، نبض ضعيف، أو صعوبة في التنفس ← طوارئ! روح العيادة فورًا',
      'Sudden Collapse or Fainting_action_2':
          'لو حصل بعد التعرض للشمس ← انقله لمكان بارد او ضل، قدّملو مياه وروح العيادة فورًا',
      'Sudden Collapse or Fainting_action_3':
          'لو السقوط اتكرر أو أليفك مرجعش طبيعي بسرعة ← طوارئ فورًا',

      'Tremors': 'الرعشة أو الاهتزاز (وأليفك صاحي، مش نوبة تشنج)',
      'Tremors_description':
          'لو أليفك بيهتز أو بيرعش وهو صاحي (مش نوبة تشنج)، ممكن يكون فيه أسباب كتير.',
      'Tremors_cause_0':
          'البرد أو الخوف – الجو البارد، القلق أو التوتر ممكن يسببو رعشة',
      'Tremors_cause_1': 'الألم – نتيجة إصابة مثلا أو التهاب مفاصل',
      'Tremors_cause_2':
          'انخفاض السكر في الدم – شائع أكتر في الكلاب الصغيرة أو الحيوانات المريضة',
      'Tremors_cause_3':
          'التسمم – زي الشوكولاتة، الأدوية البشرية، أو منتجات سامة',
      'Tremors_cause_4': 'مشاكل في المخ أو الأعصاب',
      'Tremors_action_0':
          'لو أليفك بردان أو خايف وباقي تصرّفاته طبيعية ← دفّيه وحاول تهديه',
      'Tremors_action_1':
          'لو الرعشة معاها ترجيع، ريالة، أو ضعف ← ممكن يكون تسمم ← روح العيادة فورًا',
      'Tremors_action_2':
          'لو الرعشة مستمرة من غير سبب واضح، أو معاها ألم ← محتاج كشف عند الدكتور البيطري علشان نعرف السبب',

      // Behavioral Issues
      'behavioralIssues': 'مشاكل سلوكية',

      'Aggression (Growling, Biting, Hissing, Snapping)':
          'العدوانية (عَض، هجوم مفاجئ، بيزوم عليك)',
      'Aggression (Growling, Biting, Hissing, Snapping)_description':
          'لو أليفك فجأة بقى عدواني، ممكن يكون عنده ألم، خايف، أو حاسس بتعب!',
      'Aggression (Growling, Biting, Hissing, Snapping)_cause_0':
          'ألم أو مرض – زي التهاب المفاصل، إصابة، أو عدوى',
      'Aggression (Growling, Biting, Hissing, Snapping)_cause_1':
          'خوف أو تروما سابقة – خصوصًا في حيوانات التبني أو الإنقاذ',
      'Aggression (Growling, Biting, Hissing, Snapping)_cause_2':
          'سلوك دفاعي عن المكان أو الأكل أو اللعب',
      'Aggression (Growling, Biting, Hissing, Snapping)_cause_3':
          'قلة الاختلاط – مش متعوّد على الناس أو الحيوانات التانية',
      'Aggression (Growling, Biting, Hissing, Snapping)_cause_4':
          'الهرمونات – شائعة في الذكور الغير مُعقّمين',
      'Aggression (Growling, Biting, Hissing, Snapping)_cause_5':
          'السعار – خصوصًا لو الحيوان مش مُطعَّم أو اتعض من حيوان ضال',
      'Aggression (Growling, Biting, Hissing, Snapping)_action_0':
          'استبعد وجود ألم – لو العدوانية جديدة، شوف لو في إصابة أو مشكلة صحية وروح العيادة',
      'Aggression (Growling, Biting, Hissing, Snapping)_action_1':
          'تجنّب العقاب – العقاب ممكن يخلي العدوانية أسوأ، استخدم الهدوء والتعزيز الإيجابي',
      'Aggression (Growling, Biting, Hissing, Snapping)_action_2':
          'إدّيه مساحته – متجبرهوش يتعامل معاك أو مع حد وهو قلقان أو خايف منه',
      'Aggression (Growling, Biting, Hissing, Snapping)_action_3':
          'فكّر في التعقيم – ممكن يقلل من السلوك المرتبط بالهرمونات',
      'Aggression (Growling, Biting, Hissing, Snapping)_action_4':
          'لو العدوانية فجأة و شديدة، وأليفك مش مُطعّم أو اتعض من حيوان ضال ← لازم تروح العيادة فورًا علشان نستبعد أمراض خطيرة زي السعار',

      'Excessive Meowing / Barking / Howling': 'مواء/نباح/عواء مُفرط',
      'Excessive Meowing / Barking / Howling_description':
          'لو أليفك بقى صوته عالي بشكل غير معتاد، ده معناه انو بيحاول يفهمك حاجه.',
      'Excessive Meowing / Barking / Howling_cause_0':
          'الجوع أو طلب اهتمام – بعض السلالات بطبيعتها صوتها أعلى من غيرها',
      'Excessive Meowing / Barking / Howling_cause_1':
          'ألم أو عدم راحة – ممكن يعبر عن الوجع بالصوت',
      'Excessive Meowing / Barking / Howling_cause_2':
          'القلق أو التوتر – زي لما تسيبو في مكان لوحدو أو تغييرات في البيئة',
      'Excessive Meowing / Barking / Howling_cause_3':
          'سلوك تزاوج – شائع في الحيوانات اللي مش مُعقمة',
      'Excessive Meowing / Barking / Howling_action_0':
          'راجع الأساسيات ← أكل، مياه، حمام، أو لعب',
      'Excessive Meowing / Barking / Howling_action_1':
          'لو الصوت جديد أو غير معتاد ← استبعد الألم بكشف عند العيادة',
      'Excessive Meowing / Barking / Howling_action_2':
          'لو السبب توتر أو قلق ← وفر بيئة هادية ومستقرة',
      'Excessive Meowing / Barking / Howling_action_3':
          'لو ليه علاقة بسلوك التزاوج ← اسأل دكتورك البيطري عن خيار التعقيم',

      'Hiding or Avoiding People': 'الاختباء أو تجنّب الناس',
      'Hiding or Avoiding People_description':
          'لو أليفك فجأة بدأ يستخبى، ده طريقته يقولك إن في حاجة مش مظبوطة.',
      'Hiding or Avoiding People_cause_0':
          'مرض أو ألم – من أكتر الأسباب شيوعًا للاختباء المفاجئ',
      'Hiding or Avoiding People_cause_1':
          'خوف أو توتر – زي البيت الجديد، أصوات عالية، ضيوف، أو وجود حيوانات تانية',
      'Hiding or Avoiding People_cause_2':
          'تروما سابقة – خصوصًا في حيوانات الإنقاذ أو الي اتعرضت لسوء معاملة',
      'Hiding or Avoiding People_cause_3':
          'الحمل (في الإناث) – القطط والكلاب ساعات بيستخبوا قبل الولادة',
      'Hiding or Avoiding People_action_0':
          'لو الاختباء بيحصل أحيانًا بس ← سيبه في حاله، ماتجبرهوش يخرج',
      'Hiding or Avoiding People_action_1':
          'لو بيحصل مع أصوات عالية أو وجود ضيوف أو تغييرات جديدة ← غالبًا توتر؛ وفرله مكان هادي وآمن',
      'Hiding or Avoiding People_action_2':
          'لو الاختباء جديد ومعاه قلة أكل أو قلة لعب أو تعب ← محتاج كشف في العيادة علشان نستبعد المرض',
      'Hiding or Avoiding People_action_3':
          'لو أليفتك أنثى مش مُعقمة وبتستخبى مع بطن كبيرة أو سلوكيات تحضير للولادة ← ممكن يكون حمل؛ تابعها وجهّز للولادة، ولو مش متأكد روح العيادة',

      'Eating Non-Food Items (Chewing Plastic, Cloth, Paper, or Dirt)':
          'أكل حاجات مينفعش تتاكل (زي البلاستيك، القماش، الورق أو التراب)',
      'Eating Non-Food Items (Chewing Plastic, Cloth, Paper, or Dirt)_description':
          'لو أليفك بيعض أو بيبلع حاجات مش أكل، ده ممكن يكون وراه مشكلة.',
      'Eating Non-Food Items (Chewing Plastic, Cloth, Paper, or Dirt)_cause_0':
          'نقص في التغذية – نقص فيتامينات أو معادن مهمة',
      'Eating Non-Food Items (Chewing Plastic, Cloth, Paper, or Dirt)_cause_1':
          'الملل أو التوتر – الحيوانات ممكن تعض لما تكون زهقانة أو قلقانة',
      'Eating Non-Food Items (Chewing Plastic, Cloth, Paper, or Dirt)_cause_2':
          'التسنين – الجراوي والقطط الصغيرة بيعضوا علشان يخففوا وجع اللثة',
      'Eating Non-Food Items (Chewing Plastic, Cloth, Paper, or Dirt)_action_0':
          'راجع أكله ← اتأكد إن نظامه الغذائي متوازن ومغذي',
      'Eating Non-Food Items (Chewing Plastic, Cloth, Paper, or Dirt)_action_1':
          'وفّر ألعاب للعض ← ألعاب مناسبة بدل أي حاجة خطر',
      'Eating Non-Food Items (Chewing Plastic, Cloth, Paper, or Dirt)_action_2':
          'حوّل انتباهه بلطف ← لو مسكته بيعض حاجة خطر، بدّلها بهدوء بحاجة آمنة',
      'Eating Non-Food Items (Chewing Plastic, Cloth, Paper, or Dirt)_action_3':
          'لو معرفتش تحل المشكلة و دايما بيبلع حاجات مش أكل أو حاجات خطيرة ← محتاج كشف في العيادة علشان نستبعد مشاكل صحية أو نقص غذائي',

      'Excessive Licking or Tail-Chasing': 'اللحس المفرط أو مطاردة الديل',
      'Excessive Licking or Tail-Chasing_description':
          'لو أليفك طول الوقت بيلحس رجليه أو بيجري ورا ديله، غالبًا فيه سبب أكبر من مجرد لعب.',
      'Excessive Licking or Tail-Chasing_cause_0':
          'حساسية أو تهيّج جلدي – من أكتر الأسباب اللي بتخلي الحيوان يلحس باستمرار',
      'Excessive Licking or Tail-Chasing_cause_1':
          'ألم – زي التهاب المفاصل أو مشاكل في المفاصل بتخليه يركّز على المكان الموجوع',
      'Excessive Licking or Tail-Chasing_cause_2':
          'قلق أو زهق - خصوصًا في الحيوانات اللي طاقتها عالية أو زهقانة',
      'Excessive Licking or Tail-Chasing_cause_3':
          'طفيليات – زي البراغيت، القراد أو جرب الجلد اللي يسبب هرش مستمر',
      'Excessive Licking or Tail-Chasing_action_0':
          'بص على المكان كويس ← لو فيه احمرار، جروح أو تورّم ممكن يكون التهاب أو حساسية',
      'Excessive Licking or Tail-Chasing_action_1':
          'فتّش على البراغيت أو القراد في الفرو ← ولو لقيت اديلو التطعيم في العيادة',
      'Excessive Licking or Tail-Chasing_action_2':
          'زوّد اللعب والتمارين ← بيساعد يقلل الملل والضغط النفسي',
      'Excessive Licking or Tail-Chasing_action_3':
          'لو اللحس أو مطاردة الديل مستمرة لدرجة إنها بتعمل جروح في الجلد ← محتاج كشف في العيادة',

      'Loss of Interest in Playing or Interacting':
          'فقدان الاهتمام باللعب أو التفاعل',
      'Loss of Interest in Playing or Interacting_description':
          'لو أليفك كان بيلعب وبقى فجأة مش مهتم، ممكن يكون في حاجة غلط.',
      'Loss of Interest in Playing or Interacting_cause_0':
          'ألم أو مرض – زي التهاب المفاصل، مشاكل الأسنان، سخونية، أو أمراض داخلية',
      'Loss of Interest in Playing or Interacting_cause_1':
          'الوحدة أو قلة التفاعل – لما الأليف يقعد كتير من غير لعب أو اهتمام',
      'Loss of Interest in Playing or Interacting_cause_2':
          'التقدم في العمر – الحيوانات الكبيرة في السن بتكون أقل نشاط وحب للّعب',
      'Loss of Interest in Playing or Interacting_action_0':
          'راقب علامات المرض ← زي فقدان وزن، ضعف في الأكل، عرج، أو حرارة عالية ← محتاج كشف بيطري',
      'Loss of Interest in Playing or Interacting_action_1':
          'جرّب ألعاب أو نشاطات بسيطة وهادية ← الملل أو التوتر ساعات بيقلل الحماس',
      'Loss of Interest in Playing or Interacting_action_2':
          'لو أليفك كبير في السن ← العب معاه بهدوء، وفرله تمارين خفيفة، واديله راحة أكتر',

      // General Issues
      'generalIssues': 'مشاكل عامة',

      'Vomiting': 'الترجيع',
      'Vomiting_description':
          'لو رجع مرة واحدة مش دايمًا خطر، لكن التكرار علامة إن في مشكلة!',
      'Vomiting_cause_0': 'أكل بسرعة أو بكميات كبيرة',
      'Vomiting_cause_1': 'تغيير مفاجئ في الأكل أو أكل فاسد',
      'Vomiting_cause_2': 'كرات شعر (خصوصًا في القطط)',
      'Vomiting_cause_3': 'ديدان أو عدوى في المعدة',
      'Vomiting_cause_4':
          'تسمم – من الشوكولاتة، الأدوية البشرية، أو منتجات سامة',
      'Vomiting_cause_5': 'أمراض في الكبد أو الكلى أو المعدة',
      'Vomiting_cause_6': 'عدوى فيروسية أو بكتيرية',
      'Vomiting_action_0':
          'لو حصل ترجيع مرة واحدة وأليفك طبيعي ← راقب كويس، وقدم أكل ومية بكميات صغيرة بعد شوية',
      'Vomiting_action_1':
          'لو الترجيع متكرر (أكتر من 2-3 مرات في 24 ساعة) ← محتاج عيادة',
      'Vomiting_action_2':
          'لو في ترجيع + إسهال في حيوان صغير في السن ← طوارئ، لازم عيادة فورًا',
      'Vomiting_action_3':
          'لو في ترجيع + دم، ضعف، أو لون اللثة باهت ← طوارئ، ممكن يكون تسمم أو مرض خطير',
      'Vomiting_action_4':
          'لو السبب إن الأكل بسرعة ← قسم الأكل لوجبات صغيرة بدل وجبة كبيرة',
      'Vomiting_action_5':
          'لو الترجيع بيحصل مرة يوميًا ولسه مستمر أيام متتالية ← اعمل كشف في العيادة علشان نستبعد مشاكل مزمنة',

      'Regurgitation (Throwing Up Undigested Food)':
          'الارتجاع (رجوع الأكل بدون هضم)',
      'Regurgitation (Throwing Up Undigested Food)_description':
          'الارتجاع غير الترجيع — الارتجاع بيحصل بعد الأكل مباشرة، والأكل بيرجع زي ما هو مش مهضوم.',
      'Regurgitation (Throwing Up Undigested Food)_cause_0':
          'أكل بسرعة جدًا (شائع في الحيوانات النهمة)',
      'Regurgitation (Throwing Up Undigested Food)_cause_1': 'مشاكل في المريء',
      'Regurgitation (Throwing Up Undigested Food)_cause_2':
          'جسم غريب واقف في الطريق',
      'Regurgitation (Throwing Up Undigested Food)_action_0':
          'لو بيحصل نادرًا ← جرّب تقسيم الأكل لكميات أصغر أو ارفع الطبق شوية',
      'Regurgitation (Throwing Up Undigested Food)_action_1':
          'لو متكرر أو فيه فقدان وزن ← محتاج كشف عند دكتور',
      'Regurgitation (Throwing Up Undigested Food)_action_2':
          'لو فيه كتمة نفس أو صعوبة بلع ← طوارئ، لازم عيادة فورًا',

      'Loss of Appetite': 'فقدان الشهية',
      'Loss of Appetite_description':
          'إن أليفك يفوّت وجبة واحدة مش دايمًا حاجة تقلق، لكن لو مبياكلش خالص لأكتر من 24 ساعة ← كده في مشكلة!',
      'Loss of Appetite_cause_0':
          'توتر أو قلق – زي تغيير المكان، وجود حيوان جديد، أو أصوات عالية',
      'Loss of Appetite_cause_1':
          'ألم في الأسنان أو الفم – تسوّس، خراج، أو التهاب لثة',
      'Loss of Appetite_cause_2': 'حرارة، مرض، أو أي ألم في الجسم',
      'Loss of Appetite_cause_3':
          'مشاكل خطيرة – زي فشل الكبد/الكلى، السرطان، أو عدوى قوية',
      'Loss of Appetite_action_0':
          'لو فوت وجبة واحدة وبعدين رجع أكل ← غالبًا توتر أو مشكلة بسيطة في المعدة، تابع بس',
      'Loss of Appetite_action_1':
          'جرّب تقدّم الأكل دافي أو حاجة بيحبها ← ساعات ده بيشجعه ياكل',
      'Loss of Appetite_action_2':
          'بص جوه بقو – لو فيه أسنان مكسورة، لثة حمرا، أو ريحة وحشة جدا← ممكن يكون الألم مانعه من الأكل',
      'Loss of Appetite_action_3':
          'لو فقدان الشهية استمر أكتر من 24 ساعة، أو جاي مع ترجيع، ضعف، أو نزول وزن ← محتاج دكتور',
      'Loss of Appetite_action_4':
          'لو أليفك رافض الأكل والمية مع بعض، أو عنده سخونية، انتفاخ بطن، أو وقع فجأة ← طوارئ، لازم عيادة فورًا',

      'Sudden Weight Loss or Weight Gain': 'فقدان أو زيادة الوزن المفاجئة',
      'Sudden Weight Loss or Weight Gain_description':
          'لو وزن أليفك اتغير بسرعة من غير ما يكون فيه تغيير في الأكل أو النشاط، ده ممكن يكون وراه سبب مهم.',
      'Sudden Weight Loss or Weight Gain_cause_0':
          'فقدان الوزن: ديدان أو حشرات',
      'Sudden Weight Loss or Weight Gain_cause_1':
          'فقدان الوزن: مرض السكر أو مشاكل الغدة الدرقية',
      'Sudden Weight Loss or Weight Gain_cause_2':
          'فقدان الوزن: أمراض مزمنة (زي الكبد أو الكلى)',
      'Sudden Weight Loss or Weight Gain_cause_3':
          'فقدان الوزن: ضعف الشهية أو الأكل مش بيتهضم كويس',
      'Sudden Weight Loss or Weight Gain_cause_4':
          'زيادة الوزن: أكل كتير أو قلة حركة',
      'Sudden Weight Loss or Weight Gain_cause_5':
          'زيادة الوزن: اضطرابات هرمونية',
      'Sudden Weight Loss or Weight Gain_cause_6':
          'زيادة الوزن: تجمع سوائل (ممكن يكون علامة على مشاكل في القلب أو الكبد)',
      'Sudden Weight Loss or Weight Gain_action_0':
          'لو أليفك بيأكل عادي بس وزنه بينزل ← اعمل كشف روتيني عند الدكتور علشان نستبعد ديدان، سكر، أو أمراض تانية',
      'Sudden Weight Loss or Weight Gain_action_1':
          'لو شهيته ضعيفة والوزن بينزل بسرعة ← محتاج دكتور قريب، خصوصًا لو استمر أكتر من يومين',
      'Sudden Weight Loss or Weight Gain_action_2':
          'لو زيادة الوزن تدريجية ومفيش أعراض تانية ← راجع كميات الأكل ونسبة التمارين، وحاول تعدل في النظام الغذائي',
      'Sudden Weight Loss or Weight Gain_action_3':
          'لو زيادة الوزن مفاجئة أو فيه بطن منفوخة ← محتاج كشف دكتور (ممكن يكون تجمع سوائل أو مشكلة هرمونية)',
      'Sudden Weight Loss or Weight Gain_action_4':
          'دايمًا راجع مواعيد تطعيمات الديدان والوقاية من الحشرات — التأخير فيها ممكن يسبب تغييرات في الوزن والصحة',

      'Fever (Hot Ears, Nose, or Body)':
          'حرارة أو سخونية (سخونة الأذن، الأنف، أو الجسم)',
      'Fever (Hot Ears, Nose, or Body)_description':
          'لو حاسس إن جسم أليفك أسخن من الطبيعي، ممكن يكون عنده حرارة.',
      'Fever (Hot Ears, Nose, or Body)_cause_0':
          'عدوى (بكتيرية، فيروسية، أو فطرية)',
      'Fever (Hot Ears, Nose, or Body)_cause_1': 'التهابات بسبب إصابة أو مرض',
      'Fever (Hot Ears, Nose, or Body)_cause_2':
          'مشاكل خطيرة (زي أمراض المناعة، تسمم، أو سرطان)',
      'Fever (Hot Ears, Nose, or Body)_action_0':
          'راقب العلامات التانية: خمول، فقدان شهية، رعشة، أو سخونة في الأذن',
      'Fever (Hot Ears, Nose, or Body)_action_1':
          'لو السخونة بسيطة وأليفك بياكل، بيشرب، وبيتحرك طبيعي ← تابع كويس',
      'Fever (Hot Ears, Nose, or Body)_action_2':
          'لو جسمه سخن جدًا + تعبان، مش بياكل، أو بيرتجف ← محتاج دكتور يكشف عليه',
      'Fever (Hot Ears, Nose, or Body)_action_3':
          'لو في ضعف شديد، ترجيع، أو تنفّس سريع ← روح العيادة فورًا',
      'Fever (Hot Ears, Nose, or Body)_action_4':
          'مهم: متديش أبدًا أدوية حرارة بتاعة البشر — سامة جدًا للحيوانات!',

      'Lethargy (Weakness, Sleeping Too Much)': 'الخمول (ضعف، نوم كتير)',
      'Lethargy (Weakness, Sleeping Too Much)_description':
          'لو أليفك النشيط فجأة بقى تعبان أو نايم طول الوقت، ممكن يكون يوم كسل عادي أو علامة على مشكلة.',
      'Lethargy (Weakness, Sleeping Too Much)_cause_0':
          'يوم كسل عادي (خصوصًا بعد لعب كتير أو في الجو الحر)',
      'Lethargy (Weakness, Sleeping Too Much)_cause_1':
          'ألم أو عدم راحة (زي التهاب المفاصل، إصابة، أو تعب في البطن)',
      'Lethargy (Weakness, Sleeping Too Much)_cause_2': 'عدوى أو حرارة',
      'Lethargy (Weakness, Sleeping Too Much)_cause_3':
          'مشاكل خطيرة: تسمم، أمراض في الأعضاء، أو نزيف داخلي',
      'Lethargy (Weakness, Sleeping Too Much)_action_0':
          'لو أليفك بس بيرتاح أكتر من المعتاد ولسه بياكل وبيشرب وبيلعب شوية ← غالبًا يوم كسل، مفيش قلق',
      'Lethargy (Weakness, Sleeping Too Much)_action_1':
          'لو الخمول معاه ترجيع، إسهال، عرج، أو مش بياكل ← احجز كشف قريب عند العيادة',
      'Lethargy (Weakness, Sleeping Too Much)_action_2':
          'لو أليفك ضعيف جدًا، وقع فجأة، أو رافض الأكل والشرب ← حالة طارئة، لازم كشف فورًا',

      // Breathing Problems
      'breathingProblems': 'مشاكل تنفسية',

      'Heavy Panting': 'اللهث الشديد',
      'Heavy Panting_description':
          'اللهث بعد اللّعب أو في الحر شيء طبيعي — لكن اللهث الشديد من غير سبب أو أثناء الراحة ممكن يكون علامة خطيرة',
      'Heavy Panting_cause_0':
          'ارتفاع الحرارة أو ضربة شمس – بيحصل في جو حار جدًا، أو لما الأليف يفضل فترة في عربية، أو بعد نشاط مبالغ فيه',
      'Heavy Panting_cause_1':
          'الأليف وشّه مسطّح (بولدوج، باج، فرنش بولدوج، إلخ...) – الكلاب دي شعبها الهوائية ضيقة أصلًا، فبيلهثوا كتير حتى في جو عادي أو وهم مرتاحين',
      'Heavy Panting_cause_2':
          'ألم أو توتر – الحيوانات ساعات بتلهث أكتر لما تكون مش مرتاحة أو قلقانة',
      'Heavy Panting_cause_3':
          'مشاكل في القلب أو الرئة – السوائل أو الالتهاب بيخلّي التنفس صعب',
      'Heavy Panting_cause_4':
          'زيادة الوزن (السمنة) – زيادة الوزن بتخلّي الجسم يتعب أسرع وأصعب يبرّد نفسه',
      'Heavy Panting_action_0':
          'لو اللهث من الحر ← نقّله لمكان بارد وظليل، وادّيله كمية ميّه قليلة على فترات',
      'Heavy Panting_action_1':
          'لو كلبك من الفصيلة المسطحة الوش ← خد بالك زيادة: متسبهوش في الشمس أو يجري كتير، وابعد عن الجهد الزايد أو اللعب بعنف. لو شفت لهث قوي أو صوت نفس عالي حتى وهو قاعد ← لازم كشف بيطري قريب',
      'Heavy Panting_action_2':
          'لو أليفك بيلهث وهو قاعد أو مرتاح (من غير لعب أو حر)، أو اللهث معاه كحة أو ضعف عام أو قلق زيادة ← لازم كشف بيطري',
      'Heavy Panting_action_3':
          'لو اللهث جه فجأة وقوي، أو معاه انهيار، أو لثة شاحبة/زرقاء، أو صعوبة تنفس واضحة ← دي حالة طارئة، لازم دكتور فورًا!',

      'Coughing': 'الكحة',
      'Coughing_description':
          'كحة واحدة أو اتنين مرة مرة عادي، لكن الكحة المتكررة أو الشديدة ممكن تدل على مشكلة خطيرة',
      'Coughing_cause_0':
          'تهيّج خفيف في الزور – بسبب غبار، أو سحب على المقود (الكولر)، أو من الحماس',
      'Coughing_cause_1':
          'كحة معدية (زي kennel cough عند الكلاب) – مرض بيتنقل بين الكلاب بسرعة',
      'Coughing_cause_2':
          'مشاكل في القلب – ممكن تسبب كحة بالليل أو بعد التمرين',
      'Coughing_cause_3': 'التهاب في الرئة – غالبًا معاها حرارة أو ضعف عام',
      'Coughing_cause_4':
          'حساسية أو ربو (asthma) – ممكن يسبب كحة مستمرة أو صوت نفس عالي',
      'Coughing_cause_5':
          'ضيق أو انهيار في الشعب الهوائية – بيعمل كحة صوتها زي الهورن',
      'Coughing_action_0':
          'لو الكحة خفيفة وجت بعد الجري أو السحب على المقود ← عادي، غالبًا شيء مؤقت',
      'Coughing_action_1':
          'لو الكحة استمرت أكتر من يومين أو زادت ← لازم كشف بيطري',
      'Cougking_action_2':
          'لو الكحة معاها حرارة، أو الأليف مش بياكل أو طاقته قليلة ← كشف بيطري سريع',
      'Coughing_action_3':
          'لو أليفك عنده صعوبة في التنفس، لثة زرقاء، أو وقع أو انهار ← حالة طارئة، لازم دكتور فورًا',
      'Coughing_action_4':
          'لو الكحة بتحصل بعد الأكل أو الشرب مباشرة ← ممكن يكون عنده مشكلة في البلع أو مجرى التنفس ← استشر طبيب بيطري',

      'Wheezing or Noisy Breathing': 'صوت نفس عالي',
      'Wheezing or Noisy Breathing_description':
          'لو أليفك بيطلع صوت غريب أو صعب في التنفس، ممكن يكون عنده انسداد أو ضيق في مجرى الهوا',
      'Wheezing or Noisy Breathing_cause_0':
          'التهاب خفيف في الجهاز التنفسي (زي إنفلونزا القطط أو kennel cough عند الكلاب)',
      'Wheezing or Noisy Breathing_cause_1':
          'ربو (asthma) – منتشر أكتر عند القطط',
      'Wheezing or Noisy Breathing_cause_2':
          'رد فعل تحسسي (تورم في الحلق أو الممر الهوائي)',
      'Wheezing or Noisy Breathing_cause_3':
          'ضيق أو انهيار في القصبة الهوائية (منتشر عند الكلاب الصغيرة)',
      'Wheezing or Noisy Breathing_cause_4':
          'حاجة عالقة في الحلق – زي عظمة أو جزء من لعبة',
      'Wheezing or Noisy Breathing_cause_5':
          'سلالات الوش المسطح (باج، بولدوج، فرنش بولدوج، إلخ...) – عندهم صوت نفس عالي "عادي" بس أي زيادة مفاجئة تبقى خطيرة',
      'Wheezing or Noisy Breathing_action_0':
          'لو الصوت خفيف والأليف طبيعي في باقي تصرفاته ← غالبًا التهاب بسيط أو شيء عادي بسبب فصيلة معينة، اذكره للطبيب في الزيارة الجاية',
      'Wheezing or Noisy Breathing_action_1':
          'لو الصوت زاد فجأة، خصوصًا بعد مجهود أو في جو حار ← دكتور فورًا',
      'Wheezing or Noisy Breathing_action_2':
          'لو أليفك بيتنفس بصعوبة، لثته زرقاء، أو وقع فجأة ← طوارئ، لازم دكتور فورًا',
      'Wheezing or Noisy Breathing_action_3':
          'لو شاكك إن في حاجة علقت في زوره ← لو تقدر تطلعها بسهولة وأمان اعملها، لو لأ ← اجري على الطبيب فورًا',

      'Sneezing & Nasal Discharge': 'العطس وسيلان الأنف',
      'Sneezing & Nasal Discharge_description':
          'العطاس من وقت للتاني عادي، لكن لو كتير أو معاه إفرازات غريبة من الأنف ← يبقى محتاج انتباه',
      'Sneezing & Nasal Discharge_cause_0':
          'حساسية – من الغبار، حبوب اللقاح، دخان، عطور، أو منتجات تنظيف',
      'Sneezing & Nasal Discharge_cause_1': 'التهاب في الجهاز التنفسي',
      'Sneezing & Nasal Discharge_cause_2':
          'جسم غريب عالق في الأنف – زي حشيش أو بذور أو تراب',
      'Sneezing & Nasal Discharge_cause_3':
          'مشاكل في الأسنان – الالتهاب في الأسنان العلوية ممكن ينتقل للأنف',
      'Sneezing & Nasal Discharge_action_0':
          'لو عطاس مرة أو مرتين، ومفيش إفرازات ← غالبًا بسبب غبار أو شيء بسيط، مفيش قلق',
      'Sneezing & Nasal Discharge_action_1':
          'لو فيه سيلان شفاف من الأنف ومستمر ← ممكن تكون حساسية، حاول تبعّد الدخان والعطور ومنتجات التنظيف',
      'Sneezing & Nasal Discharge_action_2':
          'لو الإفرازات من الأنف سميكة أو صفراء/خضراء ← غالبًا التهاب ← لازم كشف بيطري',
      'Sneezing & Nasal Discharge_action_3':
          'لو أليفك بيعطس كتير ومش بيوقف أو بيحك مناخيره بإيده/مخلبه ← ممكن يكون في حاجة علقت ← دكتور بيطري فورًا',

      'Open-Mouth Breathing in Cats': 'التنفس من الفم عند القطط',
      'Open-Mouth Breathing in Cats_description':
          'لو شفت قطتك بتتنفس وفمها مفتوح – ممكن يكون توتر أو حر، لكن ساعات بيكون علامة على مشكلة تنفسية خطيرة',
      'Open-Mouth Breathing in Cats_cause_0':
          'حر أو توتر (بعد اللعب، أو السفر، أو ركوب العربية)',
      'Open-Mouth Breathing in Cats_cause_1': 'مشاكل في القلب أو الرئة',
      'Open-Mouth Breathing in Cats_cause_2': 'ربو أو مشاكل في الشعب الهوائية',
      'Open-Mouth Breathing in Cats_cause_3': 'تجمع سوائل في الصدر',
      'Open-Mouth Breathing in Cats_action_0':
          'لو حصل بعد اللعب أو الحر أو السفر ← خلّي قطتك ترتاح في مكان هادي وبارد وراقبها',
      'Open-Mouth Breathing in Cats_action_1':
          'لو استمرت وهي مرتاحة، أو معاها تعب، أو سيلان لعاب، أو صعوبة في التنفس ← كشف بيطري في أقرب وقت',
      'Open-Mouth Breathing in Cats_action_2':
          'لو التنفس من الفم بدأ فجأة ومش بيوقف ← حالة طارئة، لازم دكتور فورًا',

      'Gasping for Air / Struggling to Breathe':
          'صعوبة في التنفس أو نهجان شديد',
      'Gasping for Air / Struggling to Breathe_description':
          'لو أليفك مش قادر يتنفس صح – دي حالة طارئة ومتستناش!',
      'Gasping for Air / Struggling to Breathe_cause_0':
          'رد فعل تحسسي شديد (تورم في الحلق)',
      'Gasping for Air / Struggling to Breathe_cause_1':
          'شرقة أو اختناق بسبب أكل أو جسم غريب',
      'Gasping for Air / Struggling to Breathe_cause_2':
          'انهيار في الرئة أو تجمع سوائل في الصدر',
      'Gasping for Air / Struggling to Breathe_cause_3': 'أمراض القلب',
      'Gasping for Air / Struggling to Breathe_action_0':
          'افحص لثة أليفك أو لسانه ← لو لقيتهم زرقا أو شاحبين ← حالة طارئة، لازم دكتور فورًا!',
      'Gasping for Air / Struggling to Breathe_action_1':
          'لو أليفك بيسيّل لعاب، أو تنفسه تقيل جدًا، أو واضح إنه مش قادر يتنفس ← اجري عالطبيب فورًا!',

      'Choking': 'أليفك شرقان',
      'Choking_description':
          'لو أليفك بدأ فجأة يتقيأ/يكح أو يحك فمه بإيده أو بالأرض – ممكن يكون في حاجة علقت في زوره',
      'Choking_cause_0': 'أكل أو مكافآت (treats) اتبلعت بسرعة',
      'Choking_cause_1': 'ألعاب، عظام، أو أجسام غريبة',
      'Choking_cause_2': 'شعر أو خيط علق في الحلق',
      'Choking_action_0':
          'لو أليفك بيكح أو بيحاول يبلع بس لسه قادر يتنفس ← اهدى وراقبه، كتير من الحيوانات بتعرف تتخلص من الشيء الغلط لوحدها',
      'Choking_action_1':
          'لو أليفك مش قادر يتنفس خالص أو وقع أو انهار ← حالة طوارئ! اجري على الدكتور فورًا',

      'selectPetType': 'اختر نوع الحيوان الأليف',
      'choosePetModelToViewAnatomy': 'اختر نموذج حيوان أليف لعرض التشريح',
      'dog': 'كلب',
      'cat': 'قطة',
      'dogModel': 'نموذج الكلب',
      'catModel': 'نموذج القطة',
      'viewDogAnatomy': 'عرض تشريح الكلب',
      'viewCatAnatomy': 'عرض تشريح القطة',
      'openModel': 'فتح النموذج',
      'use3DModelToIdentifySymptoms':
          'استخدم النموذج ثلاثي الأبعاد لتحديد الأعراض واستكشاف تشريح الحيوانات الأليفة. اضغط على أجزاء الجسم المختلفة لمعرفة المزيد.',
      'viewPetAnatomy': 'عرض تشريح {petType}',

      'locationAccessDisabled': 'تم إلغاء الوصول للموقع',
      'enableLocationToFindVets': 'فعل الموقع للعثور على العيادات القريبة',
      'loadingVets': 'جاري تحميل العيادات...',
      'noVetsNearby': 'لا توجد عيادات قريبة',
      'tryEnablingLocation': 'جرب تفعيل الموقع أو تحقق لاحقاً',
      'guestBrowsingMessage': 'أنت تتصفح كضيف. بعض الميزات تتطلب تسجيل الدخول.',
      'login': 'تسجيل الدخول',

      // Common symptom terms
      'possibleCauses': 'الأسباب الممكنة',
      'whatToDo': 'تتصرف إزاي؟',
      'vetVisitASAP': 'روح العيادة فورًا',
      'monitor': 'تابعها كويس',
      'rinseWithSaline': 'اغسل بمحلول ملحي',
      'cleanGently': 'نظّف بلُطف',
      'doNotTouch': 'متحاولش تلمس',
      'keepCalm': 'حاول تهدّي أليفك',

      // Pet form fields
      'petGender': 'الجنس',
      'male': 'ذكر',
      'female': 'أنثى',
      'petWeight': 'الوزن (كجم)',
      'enterPetWeight': 'أدخل وزن الحيوان الأليف',
      'petAllergies': 'الحساسية',
      'addAllergy': 'إضافة حساسية (مثل: دجاج، ألبان)',
      'spayedNeutered': 'معقم/مخصي',
      'petNotes': 'ملاحظات',
      'additionalPetInfo': 'أي معلومات إضافية عن حيوانك الأليف',

      // QR Code scanning
      'scanQrCode': 'مسح رمز الاستجابة السريعة',
      'scanVetQrCodeToComplete':
          'امسح رمز QR الخاص بالطبيب البيطري لإتمام الموعد',
      'pointCameraAtQrCode': 'وجّه الكاميرا نحو رمز QR',
      'appointmentCompletedSuccessfully': 'تم إتمام الموعد بنجاح',
      'scanQrToComplete': 'امسح QR للإتمام',

      // Notifications
      'Notifications': 'الإشعارات',
      'Mark all as read': 'وضع علامة مقروء للكل',
      'new': 'جديد',
      'No notifications yet': 'لا توجد إشعارات حتى الآن',
      'We\'ll notify you when something arrives': 'سنرسل لك إشعارًا عندما يصل شيء ما',
      'Notification deleted': 'تم حذف الإشعار',
      'Just now': 'الآن',
      'm ago': 'منذ @count د',
      'h ago': 'منذ @count س',
      'd ago': 'منذ @count يوم',

      // Medical Records
      'medicalRecords': 'السجلات الطبية',
      'medicalDetails': 'التفاصيل الطبية',
      'latestRecord': 'آخر سجل',
      'viewAllRecords': 'عرض جميع السجلات',
      'noMedicalRecordsYet': 'لا توجد سجلات طبية بعد',
      'logHealthEvent': 'إضافة سجل طبي',
      'selectRecordType': 'اختر نوع السجل',
      'commonSymptoms': 'الأعراض الشائعة',
      'customSymptom': 'عرض مخصص',
      'nameType': 'الاسم / النوع',
      'dateOfEvent': 'تاريخ الحالة',
      'locationProvider': 'الموقع / مقدم الخدمة',
      'eventDetails': 'تفاصيل الحالة',
      'attachments': 'المرفقات',
      'saveRecord': 'حفظ السجل',
      'medicationName': 'اسم الدواء',
      'dosage': 'الجرعة',
      'vaccineTypeLabel': 'نوع اللقاح',
      'category': 'الفئة',
      'visitType': 'نوع الزيارة',
      'testType': 'نوع الفحص',
      'procedureName': 'اسم الإجراء',
      'title': 'العنوان',
      'uploadImages': 'تحميل الصور',
      'recordCreatedSuccessfully': 'تم إنشاء السجل الطبي بنجاح',
      'inputRequired': 'مطلوب إدخال',
      'selectSymptomPrompt': 'يرجى اختيار عرض واحد على الأقل أو إدخال عرض مخصص.',
      'limitReached': 'تم الوصول للحد الأقصى',
      'attachLimitMsg': 'يمكنك إرفاق ما يصل إلى 10 ملفات فقط.',
      'medication': 'دواء',
      'visit': 'زيارة',
      'lab': 'مختبر',
      'surgeryLabel': 'جراحة',
      'event': 'حالة',
      'note': 'ملاحظة',
      // Store
      'aleefyStore': 'متجر أليفي',
      'noProductsFound': 'لم يتم العثور على منتجات',
      'failedToLoadProducts': 'فشل تحميل المنتجات',
      'myCart': 'سلتي',
      'cartEmpty': 'السلة فارغة ...',
      'cartEmptyMessage': 'أضف منتجات من المتجر للبدء',
      'browseStore': 'تصفح المتجر',
      'selectDeliveryMethod': 'اختر طريقة التوصيل',
      'delivery': 'التوصيل',
      'shipping': 'شحن',
      'deliveredToAddress': 'سيتم التوصيل إلى عنوانك',
      'pickUp': 'استلام',
      'pickUpFromStore': 'استلم طلبك من المتجر',
      'noDeliveryAddress': 'لا يوجد عنوان توصيل بعد',
      'addFirstAddressMessage': 'أضف عنوانك الأول حتى نعرف أين نوصل طلبك',
      'addAddress': 'إضافة عنوان',
      'addAnotherAddress': 'إضافة عنوان آخر؟',
      'saveAddress': 'حفظ العنوان',
      'country': 'الدولة',
      'city': 'المدينة',
      'addressLine1': 'العنوان السطر الأول',
      'addressLine2Optional': 'العنوان السطر الثاني (اختياري)',
      'postalCodeOptional': 'الرمز البريدي (اختياري)',
      'fieldRequired': 'هذا الحقل مطلوب',
      'scheduleOrder': 'جدولة الطلب',
      'whenDelivered': 'متى تريد توصيل طلبك؟',
      'schedule': 'جدولة',
      'availableHours': 'الأوقات المتاحة',
      'availableDate': 'التاريخ المتاح',
      'noSlotsToday': 'لا توجد أوقات متاحة اليوم.',
      'checkout': 'الدفع',
      'deliverTo': 'التوصيل إلى',
      'deliveryTime': 'وقت التوصيل',
      'cashOnDelivery': 'الدفع عند الاستلام',
      'vodafoneCash': 'فودافون كاش',
      'instaPay': 'إنستاباي',
      'subtotal': 'المجموع الفرعي',
      'shippingFee': 'رسوم الشحن',
      'totalAmount': 'المبلغ الإجمالي',
      'inclusiveOfVat': 'شامل ضريبة القيمة المضافة',
      'promoCodeHint': 'هل لديك كود خصم؟',
      'orderNotes': 'ملاحظات الطلب',
      'payNow': 'ادفع الآن',
      'orderPlaced': 'تم تقديم الطلب!',
      'pricesChanged': 'تغيرت بعض الأسعار منذ إضافتها إلى السلة.',
      'uploadPaymentProof': 'رفع إثبات الدفع',
      'trackOrder': 'تتبع الطلب',
      'backToHome': 'العودة للرئيسية',
      'myOrders': 'طلباتي',
      'noOrdersYet': 'لا توجد طلبات بعد',
      'orderDetail': 'تفاصيل الطلب',
      'shippingAddress': 'عنوان الشحن',
      'track': 'تتبع',
      'uploadProof': 'رفع الإثبات',
      'confirmDelivery': 'تأكيد الاستلام',
      'orderNotFound': 'الطلب غير موجود',
      'orderTracking': 'تتبع الطلب',
      'noTrackingInfo': 'لا تتوفر معلومات تتبع حتى الآن.',
      'paymentProof': 'إثبات الدفع',
      'uploadPaymentScreenshots': 'ارفع صورة/صور الدفع',
      'oneToFiveImages': 'من 1 إلى 5 صور',
      'maxFiveImages': 'يمكنك رفع ما يصل إلى 5 صور.',
      'submitProof': 'إرسال الإثبات',
      'options': 'الخيارات',
      'relatedProducts': 'منتجات مشابهة',
      'inStock': 'متوفر',
      'outOfStock': 'غير متوفر',
      'addToCart': 'أضف للسلة',
      'addedToCart': 'تمت الإضافة ✓',
      'readMore': 'اقرأ المزيد',
      'showLess': 'عرض أقل',
      'productNotFound': 'المنتج غير موجود',
      'yourRating': 'تقييمك',
      'reviewTitle': 'عنوان المراجعة',
      'reviewTitleHint': 'مثال: منتج رائع!',
      'reviewBodyOptional': 'تفاصيل المراجعة (اختياري)',
      'orderStatusPending': 'قيد الانتظار',
      'orderStatusConfirmed': 'مؤكد',
      'orderStatusProcessing': 'جاري المعالجة',
      'orderStatusShipped': 'تم الشحن',
      'orderStatusDelivered': 'تم التوصيل',
      'orderStatusCancelled': 'ملغي',
      'paymentStatusPaid': 'مدفوع',
      'paymentStatusFailed': 'فشل',
      'paymentStatusRefunded': 'مسترد',
      'subtotalItems': 'المجموع الفرعي ({count} عناصر)',
      'writeAReview': 'كتابة مراجعة',
      'shareExperienceHint': 'شاركنا تجربتك...',
      'qty': 'الكمية',
      'total': 'المجموع',
      'notesHint': 'ملاحظات',
      'myFavorites': 'المفضلة',
      'myAddresses': 'عناويني',
      'noSavedAddresses': 'لا توجد عناوين محفوظة',
      'deleteAddress': 'حذف العنوان',
      'setAsDefault': 'تعيين كافتراضي',
      'defaultLabel': 'افتراضي',
      'noFavoriteProducts': 'لا توجد منتجات مفضلة بعد',
      'favoriteProductsDesc': 'اضغط على أيقونة القلب في أي منتج لحفظه هنا',
    },
  };
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

// Add these getters after your existing ones (around line 400+)
