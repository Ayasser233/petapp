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
  String get getHelpWithTheApp => _localizedValues[locale.languageCode]?['getHelpWithTheApp'] ?? 'Get Help with the App';
  String get rateApp => _localizedValues[locale.languageCode]?['rateApp'] ?? 'Rate the App';
  String get leaveAReviewOnTheStore => _localizedValues[locale.languageCode]?['leaveAReviewOOnTheStore'] ?? 'Leave a review on the store';
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
  String get currentLocation => _localizedValues[locale.languageCode]?['currentLocation'] ?? 'Current Location';
  String get available => _localizedValues[locale.languageCode]?['Available'] ?? 'Available';
  String get tapToView => _localizedValues[locale.languageCode]?['tapToView'] ?? 'Tap to View';
  String get aleefyPoints => _localizedValues[locale.languageCode]?['aleefyPoints'] ?? 'Aleefy Points';
  String get gotAVoucher => _localizedValues[locale.languageCode]?['gotAVoucher'] ?? 'Got a Voucher?';

  String get pet => _localizedValues[locale.languageCode]?['pet'] ?? 'Pet';
  String get pets => _localizedValues[locale.languageCode]?['pets'] ?? 'Pets';
  String get addPet => _localizedValues[locale.languageCode]?['addPet'] ?? 'Add Pet';
  String get savePet => _localizedValues[locale.languageCode]?['savePet'] ?? 'Save Pet';
  String get addNewPet => _localizedValues[locale.languageCode]?['addNewPet'] ?? 'Add New Pet';
  String get petName => _localizedValues[locale.languageCode]?['petName'] ?? 'Pet Name';
  String get petType => _localizedValues[locale.languageCode]?['petType'] ?? 'Pet Type';
  String get dog => _localizedValues[locale.languageCode]?['dog'] ?? 'Dog';
  String get cat => _localizedValues[locale.languageCode]?['cat'] ?? 'Cat';
  String get other => _localizedValues[locale.languageCode]?['other'] ?? 'Other';
  String get birthdate => _localizedValues[locale.languageCode]?['birthdate'] ?? 'Birthdate';
  String get specialNeedsOrNotes => _localizedValues[locale.languageCode]?['specialNeedsOrNotes'] ?? 'Special Needs or Notes';
  String get noPetsAddedYet => _localizedValues[locale.languageCode]?['noPetsAddedYet'] ?? 'No pets added yet';
  String get addYourFirstPet => _localizedValues[locale.languageCode]?['addYourFirstPet'] ?? 'Add your first pet';
  String get addYourFurryFriends => _localizedValues[locale.languageCode]?['addYourFurryFriends'] ?? 'Add your furry friends to keep track of their health and appointments';
  String get enterYourPetName => _localizedValues[locale.languageCode]?['enterYourPetName'] ?? 'Enter your pet\'s name';
  

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
      'getHelpWithTheApp': 'Get Help with the App',
      'rateApp': 'Rate the App',
      'leaveAReviewOOnTheStore': 'Leave a review on the store',
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
      'currentLocation': 'Current Location',
      'Available': 'Available',
      'tapToView': 'Tap to View',
      'aleefyPoints': 'Aleefy Points',
      'gotAVoucher': 'Got a Voucher?',
      'pet': 'Pet',
      'pets': 'Pets',
      'addPet': 'Add Pet',
      'savePet': 'Save Pet',
      'addNewPet': 'Add New Pet',
      'petName': 'Pet Name',
      'petType': 'Pet Type',
      'dog': 'Dog',
      'cat': 'Cat',
      'other': 'Other',
      'birthdate': 'Birthdate',
      'specialNeedsOrNotes': 'Special Needs or Notes',
      'noPetsAddedYet': 'No pets added yet',
      'addYourFirstPet': 'Add your first pet',
      'addYourFurryFriends': 'Add your furry friends to keep track of their health and appointments',
      'enterYourPetName': 'Enter your pet\'s name',
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
      'getHelpWithTheApp': 'احصل على مساعدة في التطبيق',
      'rateApp': 'قيم التطبيق',
      'leaveAReviewOOnTheStore': 'اترك مراجعة في المتجر',
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
      'currentLocation': 'الموقع الحالي',
      'Available': 'متاح',
      'tapToView': 'اضغط للعرض',
      'aleefyPoints': 'نقاط أليفي',
      'gotAVoucher': 'هل لديك قسيمة؟',
      'pet': 'حيوان أليف',
      'pets': 'حيوانات أليفة',
      'addPet': 'إضافة حيوان أليف',
      'savePet': 'حفظ الحيوان الأليف',
      'addNewPet': 'إضافة حيوان أليف جديد',
      'petName': 'اسم الحيوان الأليف',
      'petType': 'نوع الحيوان الأليف',
      'dog': 'كلب',
      'cat': 'قط',
      'other': 'آخر',
      'birthdate': 'تاريخ الميلاد',
      'specialNeedsOrNotes': 'احتياجات خاصة أو ملاحظات',
      'noPetsAddedYet': 'لم يتم إضافة حيوانات أليفة بعد',
      'addYourFirstPet': 'أضف حيوانك الأليف الأول',
      'addYourFurryFriends': 'أضف حيواناتك الأليفة لتتبع صحتهم ومواعيدهم',
      'enterYourPetName': 'أدخل اسم حيوانك الأليف',
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