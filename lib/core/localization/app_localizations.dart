import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  // Helper method to keep the code in the widgets concise
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  // Static member to have a simple access to the delegate from the MaterialApp
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  // List of supported locales
  static const List<Locale> supportedLocales = [
    Locale('en', ''),
    Locale('ar', ''),
  ];

  // Retrieve localized strings
  String get appTitle => _localizedValues[locale.languageCode]?['appTitle'] ?? 'Pet App';
  String get home => _localizedValues[locale.languageCode]?['home'] ?? 'Home';
  String get myActivity => _localizedValues[locale.languageCode]?['myActivity'] ?? 'My Activity';
  String get profile => _localizedValues[locale.languageCode]?['profile'] ?? 'Profile';
  String get settings => _localizedValues[locale.languageCode]?['settings'] ?? 'Settings';
  String get appearance => _localizedValues[locale.languageCode]?['appearance'] ?? 'Appearance';
  String get language => _localizedValues[locale.languageCode]?['language'] ?? 'Language';
  String get notifications => _localizedValues[locale.languageCode]?['notifications'] ?? 'Notifications';
  String get privacySecurity => _localizedValues[locale.languageCode]?['privacySecurity'] ?? 'Privacy & Security';
  String get about => _localizedValues[locale.languageCode]?['about'] ?? 'About';
  String get lightMode => _localizedValues[locale.languageCode]?['lightMode'] ?? 'Light Mode';
  String get darkMode => _localizedValues[locale.languageCode]?['darkMode'] ?? 'Dark Mode';
  String get systemDefault => _localizedValues[locale.languageCode]?['systemDefault'] ?? 'System Default';
  String get useLightTheme => _localizedValues[locale.languageCode]?['useLightTheme'] ?? 'Use light theme';
  String get useDarkTheme => _localizedValues[locale.languageCode]?['useDarkTheme'] ?? 'Use dark theme';
  String get useSystemTheme => _localizedValues[locale.languageCode]?['useSystemTheme'] ?? 'Follow system theme';
  String get english => _localizedValues[locale.languageCode]?['english'] ?? 'English';
  String get arabic => _localizedValues[locale.languageCode]?['arabic'] ?? 'العربية';
  String get useEnglish => _localizedValues[locale.languageCode]?['useEnglish'] ?? 'Use English language';
  String get useArabic => _localizedValues[locale.languageCode]?['useArabic'] ?? 'استخدم اللغة العربية';
  String get pushNotifications => _localizedValues[locale.languageCode]?['pushNotifications'] ?? 'Push Notifications';
  String get emailNotifications => _localizedValues[locale.languageCode]?['emailNotifications'] ?? 'Email Notifications';
  String get sound => _localizedValues[locale.languageCode]?['sound'] ?? 'Sound';
  String get privacyPolicy => _localizedValues[locale.languageCode]?['privacyPolicy'] ?? 'Privacy Policy';
  String get termsOfService => _localizedValues[locale.languageCode]?['termsOfService'] ?? 'Terms of Service';
  String get deleteAccount => _localizedValues[locale.languageCode]?['deleteAccount'] ?? 'Delete Account';
  String get appVersion => _localizedValues[locale.languageCode]?['appVersion'] ?? 'App Version';
  String get contactSupport => _localizedValues[locale.languageCode]?['contactSupport'] ?? 'Contact Support';
  String get rateApp => _localizedValues[locale.languageCode]?['rateApp'] ?? 'Rate the App';
  String get myProfile => _localizedValues[locale.languageCode]?['myProfile'] ?? 'My Profile';
  String get myPets => _localizedValues[locale.languageCode]?['myPets'] ?? 'My Pets';
  String get appointments => _localizedValues[locale.languageCode]?['appointments'] ?? 'Appointments';
  String get favorites => _localizedValues[locale.languageCode]?['favorites'] ?? 'Favorites';
  String get support => _localizedValues[locale.languageCode]?['support'] ?? 'Support';
  String get logout => _localizedValues[locale.languageCode]?['logout'] ?? 'Logout';
  String get confirmLogout => _localizedValues[locale.languageCode]?['confirmLogout'] ?? 'Are you sure you want to logout?';
  String get yes => _localizedValues[locale.languageCode]?['yes'] ?? 'Yes';
  String get no => _localizedValues[locale.languageCode]?['no'] ?? 'No';
  String get cancel => _localizedValues[locale.languageCode]?['cancel'] ?? 'Cancel';
  String get confirm => _localizedValues[locale.languageCode]?['confirm'] ?? 'Confirm';
  String get confirmDeleteAccount => _localizedValues[locale.languageCode]?['confirmDeleteAccount'] ?? 'Are you sure you want to delete your account? This action cannot be undone.';

  // Add more strings as needed

  // Add new getters for home screen
  String get clinicVisit => _localizedValues[locale.languageCode]?['clinicVisit'] ?? 'Clinic Visit';
  String get animalView3D => _localizedValues[locale.languageCode]?['animalView3D'] ?? 'Symptom Checker';
  String get virtualVet => _localizedValues[locale.languageCode]?['virtualVet'] ?? 'Virtual Vet';
  String get searchPlaceholder => _localizedValues[locale.languageCode]?['searchPlaceholder'] ?? 'Search clinics, services...';
  String get redeemAndSave => _localizedValues[locale.languageCode]?['redeemAndSave'] ?? 'Redeem & Save';
  String get viewHistory => _localizedValues[locale.languageCode]?['viewHistory'] ?? 'View History';
  String get pointsAvailable => _localizedValues[locale.languageCode]?['pointsAvailable'] ?? 'Points Available';
  String get redeemNow => _localizedValues[locale.languageCode]?['redeemNow'] ?? 'Redeem Now';
  String get vouchers => _localizedValues[locale.languageCode]?['vouchers'] ?? 'Vouchers';
  String get nearYou => _localizedValues[locale.languageCode]?['nearYou'] ?? 'Near You';
  String get seeAll => _localizedValues[locale.languageCode]?['seeAll'] ?? 'See All';

  // Add new getters for profile screen
  String get myAccount => _localizedValues[locale.languageCode]?['myAccount']?? 'My Account';
  String get followUs => _localizedValues[locale.languageCode]?['followUs']?? 'Follow Us';
  String get welcome => _localizedValues[locale.languageCode]?['welcome']?? 'Welcome';
  String get signIn => _localizedValues[locale.languageCode]?['signIn']?? 'Sign In';
  String get signUp => _localizedValues[locale.languageCode]?['signUp']?? 'Sign Up';
  String get receivePushNotifications => _localizedValues[locale.languageCode]?['receivePushNotifications']?? 'Receive Push Notifications';
  String get receiveEmailUpdates => _localizedValues[locale.languageCode]?['receiveEmailUpdates']?? 'Receive Email Updates';
  String get playSoundForNotifications => _localizedValues[locale.languageCode]?['playSoundForNotifications']?? 'Play Sound for Notifications';
  String get readOurPrivacyPolicy => _localizedValues[locale.languageCode]?['readOurPrivacyPolicy']?? 'Read Our Privacy Policy';
  String get readOurTermsOfService => _localizedValues[locale.languageCode]?['readOurTermsOfService']?? 'Read Our Terms of Service';
  String get deleteYourAccountPermanently => _localizedValues[locale.languageCode]?['deleteYourAccountPermanently']?? 'Delete Your Account Permanently';
  
  // New translations for Vouchers Screen
  String get myVouchers => _localizedValues[locale.languageCode]?['myVouchers']?? 'My Vouchers';
  String get available => _localizedValues[locale.languageCode]?['available']?? 'Available';
  String get used => _localizedValues[locale.languageCode]?['used']?? 'Used';
  String get expired => _localizedValues[locale.languageCode]?['expired']?? 'Expired';
  String get gotAVoucher => _localizedValues[locale.languageCode]?['gotAVoucher']?? 'Got a voucher?';
  String get addVoucher => _localizedValues[locale.languageCode]?['addVoucher']?? 'Add Voucher';
  String get enterVoucherCode => _localizedValues[locale.languageCode]?['enterVoucherCode']?? 'Enter voucher code';
  String get enterYourVoucherCode => _localizedValues[locale.languageCode]?['enterYourVoucherCode']?? 'Enter your voucher code';
  String get pleaseEnterVoucherCode => _localizedValues[locale.languageCode]?['pleaseEnterVoucherCode']?? 'Please enter a voucher code';
  String get validatingVoucherCode => _localizedValues[locale.languageCode]?['validatingVoucherCode']?? 'Validating voucher code: {code}';
  String get voucherAddedSuccessfully => _localizedValues[locale.languageCode]?['voucherAddedSuccessfully']?? 'Voucher "{code}" added successfully!';
  String get invalidVoucherCode => _localizedValues[locale.languageCode]?['invalidVoucherCode']?? 'Invalid voucher code: "{code}"';
  String get voucherHelpText => _localizedValues[locale.languageCode]?['voucherHelpText']?? 'Enter the voucher code you received from Aleefy or our partners';
  String get errorOpeningAccountDetails => _localizedValues[locale.languageCode]?['errorOpeningAccountDetails']?? 'Error opening account details';
  String get aleefyPoints => _localizedValues[locale.languageCode]?['aleefyPoints']?? 'Aleefy Points';
  String get retry => _localizedValues[locale.languageCode]?['retry']?? 'Retry';
  String get view => _localizedValues[locale.languageCode]?['view']?? 'View';
  String get pointsHistory => _localizedValues[locale.languageCode]?['pointsHistory'] ?? 'Points History';

  // New translations for Favorites Screen
  String get noFavoritesYet => _localizedValues[locale.languageCode]?['noFavoritesYet'] ?? 'No favorites yet';
  String get noFavoritesMessage => _localizedValues[locale.languageCode]?['noFavoritesMessage'] ?? 'When you find clinics you love, save them here for quick access.';
  String get openNow => _localizedValues[locale.languageCode]?['openNow'] ?? 'Open Now';
  String get closed => _localizedValues[locale.languageCode]?['closed'] ?? 'Closed';
  String get removedFromFavorites => _localizedValues[locale.languageCode]?['removedFromFavorites'] ?? 'removed from favorites';
  String get bookAppointment => _localizedValues[locale.languageCode]?['bookAppointment'] ?? 'Book Appointment';
  String get exploreMoreClinics => _localizedValues[locale.languageCode]?['exploreMoreClinics'] ?? 'Explore More Clinics';
  
  // Auth screen getters
  String get welcomeBack => _localizedValues[locale.languageCode]?['welcomeBack'] ?? 'Welcome Back';
  String get loginToAccount => _localizedValues[locale.languageCode]?['loginToAccount'] ?? 'Login to your account';
  String get rememberMe => _localizedValues[locale.languageCode]?['rememberMe'] ?? 'Remember me';
  String get forgotPassword => _localizedValues[locale.languageCode]?['forgotPassword'] ?? 'Forgot Password?';
  String get orContinueWith => _localizedValues[locale.languageCode]?['orContinueWith'] ?? 'Or continue with';
  String get password => _localizedValues[locale.languageCode]?['password'] ?? 'Password';
  String get signInWithGoogle => _localizedValues[locale.languageCode]?['signInWithGoogle'] ?? 'Sign in with Google';
  String get signInWithApple => _localizedValues[locale.languageCode]?['signInWithApple'] ?? 'Sign in with Apple';
  String get dontHaveAccount => _localizedValues[locale.languageCode]?['dontHaveAccount'] ?? 'Don\'t have an account?';
  String get wrongCredentials => _localizedValues[locale.languageCode]?['wrongCredentials'] ?? 'Wrong email or password';
  
  // Signup screen getters
  String get createAccount => _localizedValues[locale.languageCode]?['createAccount'] ?? 'Create Your Account';
  String get accountCreationSubtitle => _localizedValues[locale.languageCode]?['accountCreationSubtitle'] ?? 'Fill in your details to create your account';
  String get fullName => _localizedValues[locale.languageCode]?['fullName'] ?? 'Full Name';
  String get phoneNumber => _localizedValues[locale.languageCode]?['phoneNumber'] ?? 'Phone Number';
  String get alreadyHaveAccount => _localizedValues[locale.languageCode]?['alreadyHaveAccount'] ?? 'Already have an account?';
  String get termsAndConditionsAgreement => _localizedValues[locale.languageCode]?['termsAndConditionsAgreement'] ?? 'By registering you agree to';
  String get termsAndConditions => _localizedValues[locale.languageCode]?['termsAndConditions'] ?? 'Terms & Conditions';
  String get and => _localizedValues[locale.languageCode]?['and'] ?? 'and';
  String get registrationSuccessful => _localizedValues[locale.languageCode]?['registrationSuccessful'] ?? 'Registration Successful';
  String get pleaseVerifyEmail => _localizedValues[locale.languageCode]?['pleaseVerifyEmail'] ?? 'Please verify your email to continue';
  String get registrationFailed => _localizedValues[locale.languageCode]?['registrationFailed'] ?? 'Registration Failed';

  // Common widget translations
  String get loading => _localizedValues[locale.languageCode]?['loading'] ?? 'Loading...';
  String get error => _localizedValues[locale.languageCode]?['error'] ?? 'Error';
  String get success => _localizedValues[locale.languageCode]?['success'] ?? 'Success';
  String get save => _localizedValues[locale.languageCode]?['save'] ?? 'Save';
  String get delete => _localizedValues[locale.languageCode]?['delete'] ?? 'Delete';
  String get edit => _localizedValues[locale.languageCode]?['edit'] ?? 'Edit';
  String get ok => _localizedValues[locale.languageCode]?['ok'] ?? 'OK';
  String get next => _localizedValues[locale.languageCode]?['next'] ?? 'Next';
  String get previous => _localizedValues[locale.languageCode]?['previous'] ?? 'Previous';
  String get search => _localizedValues[locale.languageCode]?['search'] ?? 'Search';
  String get clear => _localizedValues[locale.languageCode]?['clear'] ?? 'Clear';
  String get apply => _localizedValues[locale.languageCode]?['apply'] ?? 'Apply';
  String get filter => _localizedValues[locale.languageCode]?['filter'] ?? 'Filter';
  String get sort => _localizedValues[locale.languageCode]?['sort'] ?? 'Sort';
  String get share => _localizedValues[locale.languageCode]?['share'] ?? 'Share';
  String get noResultsFound => _localizedValues[locale.languageCode]?['noResultsFound'] ?? 'No results found';
  String get tryAgain => _localizedValues[locale.languageCode]?['tryAgain'] ?? 'Try Again';
  String get refresh => _localizedValues[locale.languageCode]?['refresh'] ?? 'Refresh';
  String get addToFavorites => _localizedValues[locale.languageCode]?['addToFavorites'] ?? 'Add to favorites';
  String get removeFromFavorites => _localizedValues[locale.languageCode]?['removeFromFavorites'] ?? 'Remove from favorites';
  String get today => _localizedValues[locale.languageCode]?['today'] ?? 'Today';
  String get tomorrow => _localizedValues[locale.languageCode]?['tomorrow'] ?? 'Tomorrow';
  String get selectDate => _localizedValues[locale.languageCode]?['selectDate'] ?? 'Select Date';
  String get selectTime => _localizedValues[locale.languageCode]?['selectTime'] ?? 'Select Time';
  String get done => _localizedValues[locale.languageCode]?['done'] ?? 'Done';
  String get noVouchersFound => _localizedValues[locale.languageCode]?['noVouchersFound'] ?? 'No vouchers found';
  String get checkBackLater => _localizedValues[locale.languageCode]?['checkBackLater'] ?? 'Check back later for new offers';

  // Account details fields
  String get name => _localizedValues[locale.languageCode]?['name'] ?? 'Name';
  String get email => _localizedValues[locale.languageCode]?['email'] ?? 'Email';
  String get phone => _localizedValues[locale.languageCode]?['phone'] ?? 'Phone';
  String get dateOfBirth => _localizedValues[locale.languageCode]?['dateOfBirth'] ?? 'Date of Birth';
  String get address => _localizedValues[locale.languageCode]?['address'] ?? 'Address';
  String get pointsValue => _localizedValues[locale.languageCode]?['pointsValue'] ?? '{points} Points';
  String get pointsSummary => _localizedValues[locale.languageCode]?['pointsSummary'] ?? 'Total earned: {earned} • Total redeemed: {redeemed}';
  String get dateToday => _localizedValues[locale.languageCode]?['dateToday'] ?? 'Today';
  String get dateYesterday => _localizedValues[locale.languageCode]?['dateYesterday'] ?? 'Yesterday';
  String get dateDaysAgo => _localizedValues[locale.languageCode]?['dateDaysAgo'] ?? '{days} days ago';

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
      'confirmDeleteAccount': 'Are you sure you want to delete your account? This action cannot be undone.',
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
      'playSoundForNotifications' : 'Play Sound for Notifications',
      'readOurPrivacyPolicy' : 'Read Our Privacy Policy',
      'readOurTermsOfService' : 'Read Our Terms of Service',
      'deleteYourAccountPermanently' : 'Delete Your Account Permanently',
      'myVouchers' : 'My Vouchers',
      'available' : 'Available',
      'used' : 'Used',
      'expired' : 'Expired',
      'gotAVoucher' : 'Got a voucher?',
      'addVoucher' : 'Add Voucher',
      'enterVoucherCode' : 'Enter voucher code',
      'enterYourVoucherCode' : 'Enter your voucher code',
      'pleaseEnterVoucherCode' : 'Please enter a voucher code',
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
      'validatingVoucherCode' : 'Validating voucher code: {code}',
      'voucherAddedSuccessfully' : 'Voucher "{code}" added successfully!',
      'invalidVoucherCode' : 'Invalid voucher code: "{code}"',
      'voucherHelpText' : 'Enter the voucher code you received from Aleefy or our partners',
      'errorOpeningAccountDetails' : 'Error opening account details',
      'aleefyPoints' : 'Aleefy Points',
      'retry' : 'Retry',
      'view' : 'View',
      'noFavoritesYet' : 'No favorites yet',
      'noFavoritesMessage' : 'When you find clinics you love, save them here for quick access.',
      'openNow' : 'Open Now',
      'closed' : 'Closed',
      'bookAppointment' : 'Book Appointment',
      'exploreMoreClinics' : 'Explore More Clinics',
      'removedFromFavorites' : 'removed from favorites',
      'loading' : 'Loading...',
      'error' : 'Error',
      'success' : 'Success',
      'save' : 'Save',
      'delete' : 'Delete',
      'edit' : 'Edit',
      'ok' : 'OK',
      'next' : 'Next',
      'previous' : 'Previous',
      'search' : 'Search',
      'clear' : 'Clear',
      'apply' : 'Apply',
      'filter' : 'Filter',
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
      'sort' : 'Sort',
      'share' : 'Share',
      'noResultsFound' : 'No results found',
      'tryAgain' : 'Try Again',
      'refresh' : 'Refresh',
      'addToFavorites' : 'Add to favorites',
      'removeFromFavorites' : 'Remove from favorites',
      'today' : 'Today',
      'tomorrow' : 'Tomorrow',
      'selectDate' : 'Select Date',
      'selectTime' : 'Select Time',
      'done' : 'Done',
      'noVouchersFound' : 'No vouchers found',
      'checkBackLater' : 'Check back later for new offers',
      'name' : 'Name',
      'email' : 'Email',
      'phone' : 'Phone',
      'dateOfBirth' : 'Date of Birth',
      'address' : 'Address',
      'pointsValue' : '{points} Points',
      'pointsSummary' : 'Total earned: {earned} • Total redeemed: {redeemed}',
      'dateToday' : 'Today',
      'dateYesterday' : 'Yesterday',
      'dateDaysAgo' : '{days} days ago',
      'password': 'Password',
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
      'confirmDeleteAccount': 'هل أنت متأكد أنك تريد حذف حسابك؟ لا يمكن التراجع عن هذا الإجراء.',
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
      'playSoundForNotifications' : 'تشغيل صوت الإشعار',
      'readOurPrivacyPolicy' : 'اقرأ سياسة الخصوصية',
      'readOurTermsOfService' : 'اقرأ شروط الخدمة',
      'deleteYourAccountPermanently' : 'حذف حسابك نهائيا',
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
      'noFavoritesMessage': 'عندما تجد عيادات تحبها، احفظها هنا للوصول إليها بسرعة.',
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
    },
  };
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
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