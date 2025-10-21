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
  String get vetDetails =>
      _localizedValues[locale.languageCode]?['vetDetails'] ?? 'vet Details';
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
      _localizedValues[locale.languageCode]?['pelvis'] ?? 'Pelvis';
  String get buttocks =>
      _localizedValues[locale.languageCode]?['buttocks'] ?? 'Buttocks';
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
  String get viewSelected =>
      _localizedValues[locale.languageCode]?['viewSelected'] ?? 'View Selected';
  String get findVet =>
      _localizedValues[locale.languageCode]?['findVet'] ?? 'Find Vet';
  String get rotateInstructions =>
      _localizedValues[locale.languageCode]?['rotateInstructions'] ??
      'Touch and drag to rotate the model';
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
      'vetVisit': 'vet Visit',
      'animalView3D': '3D Animal View',
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
      'view': 'View',
      'noFavoritesYet': 'No favorites yet',
      'noFavoritesMessage':
          'When you find Vets you love, save them here for quick access.',
      'openNow': 'Open Now',
      'closed': 'Closed',
      'bookAppointment': 'Book Appointment',
      'exploreMoreVets': 'Explore More Vets',
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
      'firstName': 'First Name',
      'lastName': 'Last Name',
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
      'pending': 'Pending',
      'confirmed': 'Confirmed',
      'completed': 'Completed',
      'cancelled': 'Cancelled',
      'vetDetails': 'vet Details',
      'report': 'Report',
      'minutes': 'minutes',
      'reviews': 'Reviews',
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

      // Emergency levels
      'urgent': 'Urgent',
      'moderate': 'Moderate',
      'mild': 'Mild',

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
      'rescheduleFeatureComingSoon': 'ميزة إعادة الجدولة قادمة قريبًا!',
      'reviewFeatureComingSoon': 'ميزة المراجعة قادمة قريبًا!',
      'bookingFollowupAppointment': 'حجز موعد متابعة...',
      'upcoming': 'قادم',
      'pending': 'قيد الانتظار',
      'confirmed': 'مؤكد',
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
      'vetDetails': 'تفاصيل العيادة',
      'report': 'تبليغ',
      'minutes': 'دقائق',
      'reviews': 'التقييمات',
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
      'bookVetVisit': 'حجز زيارة العيادة',
      'resetBooking': 'إعادة تعيين الحجز',
      'bookingDetails': 'تفاصيل الحجز',
      'vet': 'العيادة',
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
      'pelvis': 'الحوض',
      'buttocks': 'المؤخرة',
      'selected': 'المحدد',
      'howToUse': 'كيفية الاستخدام',
      'step': 'خطوة',
      'rotate': 'تدوير',
      'zoom': 'تكبير',
      'selectText': 'اختيار',
      'symptoms': 'الأعراض',
      'viewSelected': 'عرض المحدد',
      'findVet': 'العثور على دكتور',
      'rotateInstructions': 'اضغط واسحب لتدوير النموذج',
      'zoomInstructions': 'اقرص لتكبير وتصغير الصورة',
      'selectInstructions': 'اضغط على جزء من الجسم لاختياره',
      'symptomsInstructions': 'اختر الأعراض لجزء الجسم المحدد',
      'viewSelectedInstructions':
          'اضغط على أيقونة الأعراض في الشريط العلوي لرؤية اختياراتك',
      'findVetInstructions': 'بعد اختيار الأعراض، اضغط على "العثور على دكتور"',
      'gotIt': 'فهمت',
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
      'anusPoopingIssues': 'مشاكل الشرج والتبرز',
      'maleGenitalProblems': 'مشاكل الأعضاء التناسلية الذكورية',
      'femaleGenitalProblems': 'مشاكل الأعضاء التناسلية الأنثوية',
      'urinationProblems': 'مشاكل التبول',

      // Eye Symptoms
      'Eye Redness': 'احمرار العين',
      'Eye Redness_description':
          'لو عين أليفك لونها أحمر، ممكن يكون بسبب حاجة بسيطة زي التراب، أو حاجة أخطر زي عدوى.',
      'Eye Redness_cause_0': 'تراب، هوا، أو حساسية',
      'Eye Redness_cause_1': 'عدوى (زي بكتيريا أو فيروس الهربس)',
      'Eye Redness_cause_2': 'ضغط عالي في العين (جلوكوما)',
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
          'ضغط عالي في العين (جلوكوما)',
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

      'Third Eyelid Showing': 'حاجة بيضا أو وردي في جنب العين',
      'Third Eyelid Showing_description':
          'شايف حاجة لونها أبيض أو وردي طالعة من جنب عين أليفك أو مغطيّة جزء منها؟ دي الغشاء التالت للعين.',
      'Third Eyelid Showing_cause_0':
          'طبيعي بعد النوم – الغشاء التالت ممكن يبان شوية لما أليفك يصحى',
      'Third Eyelid Showing_cause_1':
          'عدوى في العين أو مشاكل في الأعصاب – ممكن تخلي الغشاء يفضل ظاهر',
      'Third Eyelid Showing_cause_2':
          'في الكلاب: لو فيه كتلة وردي في الركن الداخلي، ممكن تكون غدة طالعة لبرا',
      'Third Eyelid Showing_cause_3':
          'في القطط: لو فيه غشاء أبيض بيغطي العينين، ممكن يكون علامة على مرض',
      'Third Eyelid Showing_action_0':
          'لو اختفى بسرعة وأليفك باين عليه إنه كويس ← مفيش داعي للقلق، بس تابعها كويس',
      'Third Eyelid Showing_action_1':
          'لو الغشاء التالت لسه باين أو بيغطي جزء من العين ← احجز زيارة للعيادة علشان تعرف السبب',
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
          'طفيليات (ديدان أو خيوط بيضا) حوالين أو جوا العين',
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

      'Bad Breath (Smelly Mouth)': 'نفس ريحته وحشة (بُقّه مش لطيف)',
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
          'لو لاحظت فُتافيت بيضا صغيرة في فرو أليفك، ممكن يكون عنده جفاف في الجلد أو حاجة تانية!',
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
          'نظّف المنطقة بمياه دافئة',
      'Scooting or Dragging Butt on the Floor_action_1':
          'شوف لو فيه ديدان (ممكن تلاحظ حاجت بيضا صغيرة شبه الرز حوالين فتحة الشرج)',
      'Scooting or Dragging Butt on the Floor_action_2':
          'تأكد إن أليفك واخد جرعة الديدان في معادها',
      'Scooting or Dragging Butt on the Floor_action_3':
          'لو الحكّ مستمر أو فيه ورم في المنطقة ← محتاج تروح العيادة',

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

      'Blood in Stool or Around the Anus': 'دم في البراز أو حوالين فتحة الشرج',
      'Blood in Stool or Around the Anus_description':
          'لاحظت دم في براز أليفك أو حوالين مؤخرته؟',
      'Blood in Stool or Around the Anus_cause_0':
          'جرح صغير بسبب صعوبة الإخراج – بيحصل مع البراز الناشف أو الصلب',
      'Blood in Stool or Around the Anus_cause_1': 'ديدان أو طفيليات',
      'Blood in Stool or Around the Anus_cause_2':
          'التهاب في الغدد الشرجية – لو الحالة شديدة ممكن تسبب نزيف',
      'Blood in Stool or Around the Anus_cause_3':
          'مشاكل أخطر – زي التهاب القولون، أورام، أو تسمم',
      'Blood in Stool or Around the Anus_action_0':
          'لو أثر دم بسيط وأليفك طبيعي ← تابع الحالة ووفّر له مياه نظيفة يشربها',
      'Blood in Stool or Around the Anus_action_1':
          'لو الدم بيظهر بشكل متكرر، أو لو فيه إسهال كمان← محتاج تروح العيادة قريب',
      'Blood in Stool or Around the Anus_action_2':
          'لو الدم كتير، أو أليفك باين عليه التعب، أو بيرجع، أو مش بياكل ← روح العيادة فورًا – دي حالة طارئة',

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
          'لو الإمساك مستمر أكتر من يوم أو في ألم → محتاج تروح العيادة',
      'Straining to Poop or Constipation_action_2':
          'أحيانًا صعوبة التبرز بتلخبط مع صعوبة التبول، خصوصًا في القطط الذكور — ودي حالة ممكن تكون مميتة',

      'Diarrhea': 'الإسهال',
      'Diarrhea_description': 'أليفك عنده إسهال؟ حاول متخليش الموضوع يطول.',
      'Diarrhea_cause_0': 'تغيير الأكل أو أكل حاجة مش مناسبة',
      'Diarrhea_cause_1': 'ديدان أو عدوى',
      'Diarrhea_cause_2': 'التوتر أو القلق',
      'Diarrhea_cause_3':
          'أمراض خطيرة – خصوصًا لو الإسهال فيه دم أو استمر لفترة طويلة',
      'Diarrhea_action_0':
          'لو الإسهال بسيط ← قدم أكل زي فراخ مسلوقة مع رز أبيض',
      'Diarrhea_action_1':
          'خلي أليفك يشرب كويس ← الجفاف خطر كبير وممكن يهدد حياته',
      'Diarrhea_action_2':
          'لو الإسهال استمر أكتر من يومين،أو فيه دم، أو أليفك ضعيف ← روح العيادة',

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
          'شوية إفرازات شفافة أو بيضا ممكن تكون طبيعية، لكن أي إفرازات لها ريحة أو شكل غريب ده مش طبيعي!',
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
