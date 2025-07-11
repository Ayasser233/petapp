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
      _localizedValues[locale.languageCode]?['appTitle'] ?? 'Pet App';
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
  String get clinicVisit =>
      _localizedValues[locale.languageCode]?['clinicVisit'] ?? 'Clinic Visit';
  String get animalView3D =>
      _localizedValues[locale.languageCode]?['animalView3D'] ??
      'Symptom Checker';
  String get virtualVet =>
      _localizedValues[locale.languageCode]?['virtualVet'] ?? 'Virtual Vet';
  String get searchPlaceholder =>
      _localizedValues[locale.languageCode]?['searchPlaceholder'] ??
      'Search clinics, services...';
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
      'When you find clinics you love, save them here for quick access.';
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
  String get exploreMoreClinics =>
      _localizedValues[locale.languageCode]?['exploreMoreClinics'] ??
      'Explore More Clinics';

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
  String get dontHaveAccount =>
      _localizedValues[locale.languageCode]?['dontHaveAccount'] ??
      'Don\'t have an account?';
  String get wrongCredentials =>
      _localizedValues[locale.languageCode]?['wrongCredentials'] ??
      'Wrong email or password';

  // Signup screen getters
  String get createAccount =>
      _localizedValues[locale.languageCode]?['createAccount'] ??
      'Create Your Account';
  String get accountCreationSubtitle =>
      _localizedValues[locale.languageCode]?['accountCreationSubtitle'] ??
      'Fill in your details to create your account';
  String get fullName =>
      _localizedValues[locale.languageCode]?['fullName'] ?? 'Full Name';
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
  String get clinicDetails =>
      _localizedValues[locale.languageCode]?['clinicDetails'] ??
      'Clinic Details';
  String get report =>
      _localizedValues[locale.languageCode]?['report'] ?? 'Report';
  String get minutes =>
      _localizedValues[locale.languageCode]?['minutes'] ?? 'minutes';
  String get reviews =>
      _localizedValues[locale.languageCode]?['reviews'] ?? 'Reviews';
  String get patients =>
      _localizedValues[locale.languageCode]?['patients'] ?? 'Patients';
  String get yearsExp =>
      _localizedValues[locale.languageCode]?['yearsExp'] ?? 'Years exp.';
  String get description =>
      _localizedValues[locale.languageCode]?['description'] ?? 'Description';
  String get defaultClinicDescription =>
      _localizedValues[locale.languageCode]?['defaultClinicDescription'] ??
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
  String get initialExaminationFee =>
      _localizedValues[locale.languageCode]?['initialExaminationFee'] ??
      'Initial examination fee';
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
  String get findClinics =>
      _localizedValues[locale.languageCode]?['findClinics'] ?? 'Find Clinics';
  String get refreshLocation =>
      _localizedValues[locale.languageCode]?['refreshLocation'] ??
      'Refresh Location';
  String get enableLocation =>
      _localizedValues[locale.languageCode]?['enableLocation'] ??
      'Enable Location';
  String get searchClinicsHint =>
      _localizedValues[locale.languageCode]?['searchClinicsHint'] ??
      'Search clinics, services, locations...';
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
  String get noClinicsFound =>
      _localizedValues[locale.languageCode]?['noClinicsFound'] ??
      'No clinics found';
  String get tryAdjustingFilters =>
      _localizedValues[locale.languageCode]?['tryAdjustingFilters'] ??
      'Try adjusting your search or filters';
  String get clearFilters =>
      _localizedValues[locale.languageCode]?['clearFilters'] ?? 'Clear Filters';
  String get viewDetails =>
      _localizedValues[locale.languageCode]?['viewDetails'] ?? 'View Details';
  String get callClinic =>
      _localizedValues[locale.languageCode]?['callClinic'] ?? 'Call Clinic';
  String get failedToLoadClinics =>
      _localizedValues[locale.languageCode]?['failedToLoadClinics'] ??
      'Failed to load clinics. Please try again.';
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
  // Add these getters to your AppLocalizations class
  String get bookHospitalVisit =>
      _localizedValues[locale.languageCode]?['bookHospitalVisit'] ??
      'Book Hospital Visit';
  String get resetBooking =>
      _localizedValues[locale.languageCode]?['resetBooking'] ?? 'Reset Booking';
  String get bookingDetails =>
      _localizedValues[locale.languageCode]?['bookingDetails'] ??
      'Booking Details';
  String get clinic =>
      _localizedValues[locale.languageCode]?['clinic'] ?? 'Clinic';
  String get price =>
      _localizedValues[locale.languageCode]?['price'] ?? 'Price';
  String get selectTimeSlot =>
      _localizedValues[locale.languageCode]?['selectTimeSlot'] ??
      'Select Time Slot';
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
  String get showQRCodeAtHospital =>
      _localizedValues[locale.languageCode]?['showQRCodeAtHospital'] ??
      'Show this QR code at the hospital';
  String get qrCodeError =>
      _localizedValues[locale.languageCode]?['qrCodeError'] ??
      'Something went wrong!';
  String get pleaseSelectTimeSlot =>
      _localizedValues[locale.languageCode]?['pleaseSelectTimeSlot'] ??
      'Please select a time slot';
  String get bookingFailed =>
      _localizedValues[locale.languageCode]?['bookingFailed'] ??
      'Booking failed. Please try again.';
  String get noSlotsAvailable =>
      _localizedValues[locale.languageCode]?['noSlotsAvailable'] ??
      'No slots available';
  String get booked =>
      _localizedValues[locale.languageCode]?['booked'] ?? 'Booked';

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

  String clinicsFound(int count) {
    return _localizedValues[locale.languageCode]?['clinicsFound']
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

  // Define all localized values
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'Pet App',
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
      'clinicVisit': 'Clinic Visit',
      'animalView3D': 'Symptom Checker',
      'virtualVet': 'Virtual Vet',
      'searchPlaceholder': 'Search clinics, services...',
      'redeemAndSave': 'Redeem & Save',
      'viewHistory': 'View History',
      'pointsAvailable': 'Points Available',
      'redeemNow': 'Redeem Now',
      'vouchers': 'Vouchers',
      'nearYou': 'Near You',
      'seeAll': 'See All',
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
      'myVouchers': 'My Vouchers',
      'available': 'Available',
      'used': 'Used',
      'expired': 'Expired',
      'gotAVoucher': 'Got a voucher?',
      'addVoucher': 'Add Voucher',
      'enterVoucherCode': 'Enter voucher code',
      'enterYourVoucherCode': 'Enter your voucher code',
      'pleaseEnterVoucherCode': 'Please enter a voucher code',
      // Auth screen translations
      'welcomeBack': 'Welcome Back',
      'loginToAccount': 'Login to your account',
      'rememberMe': 'Remember me',
      'forgotPassword': 'Forgot Password?',
      'orContinueWith': 'Or continue with',
      'signInWithGoogle': 'Sign in with Google',
      'signInWithApple': 'Sign in with Apple',
      'dontHaveAccount': 'Don\'t have an account?',
      'wrongCredentials': 'Wrong email or password',
      'validatingVoucherCode': 'Validating voucher code: {code}',
      'voucherAddedSuccessfully': 'Voucher "{code}" added successfully!',
      'invalidVoucherCode': 'Invalid voucher code: "{code}"',
      'voucherHelpText':
          'Enter the voucher code you received from Aleefy or our partners',
      'errorOpeningAccountDetails': 'Error opening account details',
      'aleefyPoints': 'Aleefy Points',
      'retry': 'Retry',
      'view': 'View',
      'noFavoritesYet': 'No favorites yet',
      'noFavoritesMessage':
          'When you find clinics you love, save them here for quick access.',
      'openNow': 'Open Now',
      'closed': 'Closed',
      'bookAppointment': 'Book Appointment',
      'exploreMoreClinics': 'Explore More Clinics',
      'removedFromFavorites': 'removed from favorites',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
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
      'rescheduleFeatureComingSoon': 'Reschedule feature coming soon!',
      'reviewFeatureComingSoon': 'Review feature coming soon!',
      'bookingFollowupAppointment': 'Booking follow-up appointment...',
      'upcoming': 'Upcoming',
      'completed': 'Completed',
      'cancelled': 'Cancelled',
      'clinicDetails': 'Clinic Details',
      'report': 'Report',
      'minutes': 'minutes',
      'reviews': 'Reviews',
      'patients': 'Patients',
      'yearsExp': 'Years exp.',
      'description': 'Description',
      'defaultClinicDescription':
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
      'workingHours': 'Working Hours',
      'mondayFriday': 'Monday - Friday',
      'saturday': 'Saturday',
      'sunday': 'Sunday',
      'bookConsultation': 'Book Consultation',
      'consultation': 'Consultation',
      'findClinics': 'Find Clinics',
      'refreshLocation': 'Refresh Location',
      'enableLocation': 'Enable Location',
      'searchClinicsHint': 'Search clinics, services, locations...',
      'filters': 'Filters',
      'allCategory': 'All Category',
      'popular': 'Popular',
      'recommended': 'Recommended',
      'latest': 'Latest',
      'currentLocation': 'Current Location',
      'gettingLocation': 'Getting location...',
      'enableLocationForResults': 'Enable location for distance-based results',
      'enable': 'Enable',
      'searchResult': 'Search Result',
      'noClinicsFound': 'No clinics found',
      'tryAdjustingFilters': 'Try adjusting your search or filters',
      'clearFilters': 'Clear Filters',
      'viewDetails': 'View Details',
      'callClinic': 'Call Clinic',
      'failedToLoadClinics': 'Failed to load clinics. Please try again.',
      'errorApplyingFilters': 'Error applying filters. Please try again.',
      'withinDistance': 'Within {distance}km',
      'clinicsFound': '{count} found',
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
      'bookHospitalVisit': 'Book Hospital Visit',
      'resetBooking': 'Reset Booking',
      'bookingDetails': 'Booking Details',
      'clinic': 'Clinic',
      'price': 'Price',
      'selectTimeSlot': 'Select Time Slot',
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
      'showQRCodeAtHospital': 'Show this QR code at the hospital',
      'qrCodeError': 'Something went wrong!',
      'pleaseSelectTimeSlot': 'Please select a time slot',
      'bookingFailed': 'Booking failed. Please try again.',
      'availableSlotsFor': 'Available slots for {date}',
      'confirmPets': 'Confirm ({count} pets)',
      'noSlotsAvailable': 'No slots available',
      'booked': 'Booked',
      'availableSlots': '({count} available)',
    },
    'ar': {
      'appTitle': 'تطبيق الحيوانات الأليفة',
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
      // Auth screen translations
      'welcomeBack': 'مرحبًا بعودتك',
      'loginToAccount': 'تسجيل الدخول إلى حسابك',
      'rememberMe': 'تذكرني',
      'forgotPassword': 'نسيت كلمة المرور؟',
      'orContinueWith': 'أو متابعة باستخدام',
      'signInWithGoogle': 'تسجيل الدخول باستخدام Google',
      'signInWithApple': 'تسجيل الدخول باستخدام Apple',
      'dontHaveAccount': 'ليس لديك حساب؟',
      'wrongCredentials': 'بريد إلكتروني أو كلمة مرور خاطئة',
      // Signup screen translations
      'createAccount': 'إنشاء حسابك',
      'accountCreationSubtitle': 'املأ بياناتك لإنشاء حسابك',
      'fullName': 'الاسم الكامل',
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
      'clinicVisit': 'زيارة العيادة',
      'animalView3D': 'مشخص الأعراض',
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
      'noFavoritesYet': 'لا توجد مفضلات بعد',
      'noFavoritesMessage':
          'عندما تجد عيادات تحبها، احفظها هنا للوصول إليها بسرعة.',
      'openNow': 'مفتوح الآن',
      'closed': 'مغلق',
      'bookAppointment': 'حجز موعد',
      'exploreMoreClinics': 'استكشف المزيد من العيادات',
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
      'rescheduleFeatureComingSoon': 'ميزة إعادة الجدولة قادمة قريبًا!',
      'reviewFeatureComingSoon': 'ميزة المراجعة قادمة قريبًا!',
      'bookingFollowupAppointment': 'حجز موعد متابعة...',
      'upcoming': 'قادم',
      'completed': 'مكتمل',
      'cancelled': 'ملغي',
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
      'clinicDetails': 'تفاصيل العيادة',
      'report': 'تبليغ',
      'minutes': 'دقائق',
      'reviews': 'التقييمات',
      'patients': 'المرضى',
      'yearsExp': 'سنوات الخبرة',
      'description': 'الوصف',
      'defaultClinicDescription':
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
      'workingHours': 'ساعات العمل',
      'mondayFriday': 'الاثنين - الجمعة',
      'saturday': 'السبت',
      'sunday': 'الأحد',
      'bookConsultation': 'احجز استشارة',
      'consultation': 'استشارة',
      'findClinics': 'البحث عن العيادات',
      'refreshLocation': 'تحديث الموقع',
      'enableLocation': 'تفعيل الموقع',
      'searchClinicsHint': 'البحث عن العيادات، الخدمات، المواقع...',
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
      'noClinicsFound': 'لم يتم العثور على عيادات',
      'tryAdjustingFilters': 'حاول تعديل البحث أو المرشحات',
      'clearFilters': 'مسح المرشحات',
      'viewDetails': 'عرض التفاصيل',
      'callClinic': 'اتصال بالعيادة',
      'failedToLoadClinics': 'فشل في تحميل العيادات. يرجى المحاولة مرة أخرى.',
      'errorApplyingFilters': 'خطأ في تطبيق المرشحات. يرجى المحاولة مرة أخرى.',
      'withinDistance': 'ضمن {distance}كم',
      'clinicsFound': 'تم العثور على {count}',
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
      'bookHospitalVisit': 'حجز زيارة المستشفى',
      'resetBooking': 'إعادة تعيين الحجز',
      'bookingDetails': 'تفاصيل الحجز',
      'clinic': 'العيادة',
      'price': 'السعر',
      'selectTimeSlot': 'اختر الوقت',
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
      'showQRCodeAtHospital': 'اعرض رمز الاستجابة السريعة هذا في المستشفى',
      'qrCodeError': 'حدث خطأ ما!',
      'pleaseSelectTimeSlot': 'يرجى اختيار وقت',
      'bookingFailed': 'فشل الحجز. يرجى المحاولة مرة أخرى.',
      'availableSlotsFor': 'الأوقات المتاحة لـ {date}',
      'confirmPets': 'تأكيد ({count} حيوانات أليفة)',
      'noSlotsAvailable': 'لا توجد مواعيد متاحة',
      'booked': 'محجوز',
      'availableSlots': '({count} متاح)',
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
