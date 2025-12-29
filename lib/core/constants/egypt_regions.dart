import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Egypt Governorates and Cities Data
class EgyptRegions {
  /// Check if current locale is Arabic
  static bool get isArabic {
    final locale = Get.locale ?? const Locale('en');
    return locale.languageCode == 'ar';
  }

  /// Map of Egypt's 28 governorates with their major cities/districts (Arabic)
  static const Map<String, List<String>> governorates = {
    'القاهرة': [
      'مدينة نصر',
      'المعادي',
      'مصر الجديدة',
      'وسط البلد',
      'الزمالك',
      'القاهرة الجديدة',
      'حلوان',
      'شبرا',
      'عين شمس',
      'المرج',
      'المطرية',
      'السلام',
      'الزيتون',
      'النزهة',
      'الساحل',
      'الشرابية',
      'الوايلي',
      'الدرب الأحمر',
      'الخليفة',
      'السيدة زينب',
      'مصر القديمة',
      'دار السلام',
      'البساتين',
      'مصر الجديدة',
      'الظاهر',
      'الأزبكية',
      'الجمالية',
      'الموسكي',
      'باب الشعرية',
      'الصوة',
      'منشية ناصر',
      'الموسكي',
      'الدراسة',
      'الوايلي',
      'حدائق القبة',
      'الشرابية',
    ],
    'الجيزة': [
      'السادس من أكتوبر',
      'الشيخ زايد',
      'الدقي',
      'المهندسين',
      'العجوزة',
      'إمبابة',
      'الهرم',
      'فيصل',
      'العمرانية',
      'الواحات',
      'بولاق الدكرور',
      'المنيب',
      'كرداسة',
      'أوسيم',
      'البدرشين',
      'الصف',
      'أطفيح',
      'العياط',
    ],
    'الإسكندرية': [
      'المنتزه',
      'الرمل',
      'سيدي جابر',
      'ميامي',
      'ستانلي',
      'المندرة',
      'سموحة',
      'سان ستيفانو',
      'جليم',
      'كامب شيزار',
      'سيدي بشر',
      'فيكتوريا',
      'سبورتنج',
      'لوران',
      'فلمنج',
      'محرم بك',
      'الحضرة',
      'الشاطبي',
      'باب شرق',
      'كرموز',
      'الجمرك',
      'العطارين',
      'اللبان',
      'المنشية',
      'الورديان',
      'برج العرب',
      'العجمي',
      'البيطاش',
      'المكس',
      'العامرية',
    ],
    'القليوبية': [
      'بنها',
      'شبرا الخيمة',
      'الخانكة',
      'القناطر الخيرية',
      'قليوب',
      'كفر شكر',
      'طوخ',
      'شبين القناطر',
      'العبور',
    ],
    'بورسعيد': [
      'بورسعيد',
      'بورفؤاد',
      'العرب',
      'الزهور',
      'المناخ',
      'الضواحي',
      'الشرق',
    ],
    'السويس': [
      'السويس',
      'الأربعين',
      'عتاقة',
      'فيصل',
      'الجناين',
    ],
    'الأقصر': [
      'الأقصر',
      'الكرنك',
      'الطود',
      'أرمنت',
      'إسنا',
    ],
    'أسوان': [
      'أسوان',
      'إدفو',
      'كوم أمبو',
      'نصر النوبة',
      'دراو',
    ],
    'أسيوط': [
      'أسيوط',
      'منفلوط',
      'ديروط',
      'أبنوب',
      'أبو تيج',
      'الغنايم',
      'ساحل سليم',
      'البداري',
      'القوصية',
      'أبنوب',
      'صدفا',
    ],
    'البحيرة': [
      'دمنهور',
      'كفر الدوار',
      'رشيد',
      'إدكو',
      'أبو حمص',
      'أبو المطامير',
      'دلنجات',
      'حوش عيسى',
      'شبراخيت',
      'كوم حمادة',
      'بدر',
      'وادي النطرون',
      'إيتاي البارود',
      'النوبارية',
      'الرحمانية',
    ],
    'بني سويف': [
      'بني سويف',
      'الواسطى',
      'ناصر',
      'إهناسيا',
      'ببا',
      'الفشن',
      'سمسطا',
      'الفشن',
    ],
    'الدقهلية': [
      'المنصورة',
      'طلخا',
      'ميت غمر',
      'دكرنس',
      'أجا',
      'المنزلة',
      'المطرية',
      'شربين',
      'بلقاس',
      'جمصة',
      'المحلة',
      'نبروه',
      'تمي الأمديد',
      'السنبلاوين',
      'الكردي',
      'بني عبيد',
      'منية النصر',
    ],
    'دمياط': [
      'دمياط',
      'دمياط الجديدة',
      'رأس البر',
      'فارسكور',
      'الزرقا',
      'كفر سعد',
      'كفر البطيخ',
    ],
    'الفيوم': [
      'الفيوم',
      'إبشواي',
      'إطسا',
      'سنورس',
      'طامية',
      'يوسف الصديق',
      'أطسا',
    ],
    'الغربية': [
      'طنطا',
      'المحلة الكبرى',
      'كفر الزيات',
      'زفتى',
      'سمنود',
      'السنطة',
      'قطور',
      'بسيون',
    ],
    'الإسماعيلية': [
      'الإسماعيلية',
      'فايد',
      'القنطرة شرق',
      'القنطرة غرب',
      'التل الكبير',
      'أبو صوير',
      'القصاصين',
    ],
    'كفر الشيخ': [
      'كفر الشيخ',
      'دسوق',
      'فوه',
      'مطوبس',
      'برج البرلس',
      'بلطيم',
      'سيدي سالم',
      'قلين',
      'بيلا',
      'الرياض',
    ],
    'مطروح': [
      'مرسى مطروح',
      'العلمين',
      'الحمام',
      'سيدي عبد الرحمن',
      'رأس الحكمة',
      'الضبعة',
      'سيوة',
      'براني',
      'السلوم',
      'النجيلة',
    ],
    'المنيا': [
      'المنيا',
      'ملوي',
      'سمالوط',
      'مطاي',
      'بني مزار',
      'أبو قرقاص',
      'دير مواس',
      'مغاغة',
      'أرض سلطان',
    ],
    'المنوفية': [
      'شبين الكوم',
      'منوف',
      'مدينة السادات',
      'أشمون',
      'قويسنا',
      'بركة السبع',
      'تلا',
      'الشهداء',
      'الباجور',
    ],
    'الوادي الجديد': [
      'الخارجة',
      'الداخلة',
      'الفرافرة',
      'بلاط',
      'باريس',
    ],
    'شمال سيناء': [
      'العريش',
      'الشيخ زويد',
      'رفح',
      'بئر العبد',
      'الحسنة',
      'نخل',
    ],
    'قنا': [
      'قنا',
      'نجع حمادي',
      'قوص',
      'دشنا',
      'أبو تشت',
      'نقادة',
      'الوقف',
      'فرشوط',
      'قفط',
    ],
    'البحر الأحمر': [
      'الغردقة',
      'سفاج��',
      'مرسى علم',
      'الجونة',
      'القصير',
      'رأس غارب',
      'شلاتين',
      'حلايب',
    ],
    'الشرقية': [
      'الزقازيق',
      'العاشر من رمضان',
      'بلبيس',
      'أبو حماد',
      'أبو كبير',
      'فاقوس',
      'كفر صقر',
      'ههيا',
      'ديرب نجم',
      'منيا القمح',
      'أولاد صقر',
      'الإبراهيمية',
      'مشتول السوق',
    ],
    'سوهاج': [
      'سوهاج',
      'أخميم',
      'جرجا',
      'البلينا',
      'المراغة',
      'دار السلام',
      'جهينة',
      'ساقلته',
      'طهطا',
      'طما',
      'المنشاة',
    ],
    'جنوب سيناء': [
      'شرم الشيخ',
      'دهب',
      'نويبع',
      'طابا',
      'سانت كاترين',
      'رأس سدر',
      'أبو رديس',
      'الطور',
    ],
  };

  /// Map of Egypt's 28 governorates with their major cities/districts (English)
  static const Map<String, List<String>> governoratesEn = {
    'Cairo': [
      'Nasr City',
      'Maadi',
      'Heliopolis',
      'Downtown',
      'Zamalek',
      'New Cairo',
      'Helwan',
      'Shubra',
      'Ain Shams',
      'El Marg',
      'El Matareya',
      'El Salam',
      'El Zeitoun',
      'El Nozha',
      'El Sahel',
      'El Sharabia',
      'El Waili',
      'El Darb El Ahmar',
      'El Khalifa',
      'Sayeda Zeinab',
      'Misr El Qadima',
      'Dar El Salam',
      'El Basatin',
      'El Zaher',
      'El Azbakia',
      'El Gamaleya',
      'El Mouski',
      'Bab El Shaariya',
      'El Sawah',
      'Manshiet Nasser',
      'El Darasa',
      'Hadayek El Qobba',
    ],
    'Giza': [
      '6th of October',
      'Sheikh Zayed',
      'Dokki',
      'Mohandessin',
      'Agouza',
      'Imbaba',
      'Haram',
      'Faisal',
      'Omraneya',
      'El Wahat',
      'Bulaq El Dakrour',
      'El Moneeb',
      'Kerdasa',
      'Oseem',
      'Badrasheen',
      'El Saf',
      'Atfih',
      'El Ayat',
    ],
    'Alexandria': [
      'Montaza',
      'Raml',
      'Sidi Gaber',
      'Miami',
      'Stanley',
      'Mandara',
      'Smouha',
      'San Stefano',
      'Glim',
      'Camp Caesar',
      'Sidi Bishr',
      'Victoria',
      'Sporting',
      'Laurent',
      'Fleming',
      'Moharam Bek',
      'El Hadra',
      'El Shatby',
      'Bab Sharq',
      'Karmouz',
      'El Gomrok',
      'El Attarine',
      'El Labban',
      'El Manshia',
      'El Wardian',
      'Borg El Arab',
      'El Agami',
      'El Bitash',
      'El Max',
      'El Amreya',
    ],
    'Qalyubia': [
      'Benha',
      'Shubra El Kheima',
      'El Khanka',
      'El Qanater El Khayriya',
      'Qalyub',
      'Kafr Shukr',
      'Toukh',
      'Shibin El Qanater',
      'El Obour',
    ],
    'Port Said': [
      'Port Said',
      'Port Fouad',
      'El Arab',
      'El Zohour',
      'El Manakh',
      'El Dawahy',
      'El Sharq',
    ],
    'Suez': [
      'Suez',
      'El Arbaeen',
      'Ataqah',
      'Faisal',
      'El Ganayen',
    ],
    'Luxor': [
      'Luxor',
      'Karnak',
      'El Tod',
      'Armant',
      'Esna',
    ],
    'Aswan': [
      'Aswan',
      'Edfu',
      'Kom Ombo',
      'Nasr El Nuba',
      'Daraw',
    ],
    'Asyut': [
      'Asyut',
      'Manfalut',
      'Dairut',
      'Abnoub',
      'Abu Tig',
      'El Ghanaim',
      'Sahel Selim',
      'El Badari',
      'El Qusiya',
      'Sedfa',
    ],
    'Beheira': [
      'Damanhur',
      'Kafr El Dawar',
      'Rashid',
      'Edku',
      'Abu Homs',
      'Abu El Matamir',
      'Delengat',
      'Housh Eissa',
      'Shubrakhit',
      'Kom Hamada',
      'Badr',
      'Wadi El Natrun',
      'Itay El Baroud',
      'El Noubariya',
      'El Rahmaniya',
    ],
    'Beni Suef': [
      'Beni Suef',
      'El Wasta',
      'Nasser',
      'Ihnasya',
      'Beba',
      'El Fashn',
      'Sumusta',
    ],
    'Dakahlia': [
      'Mansoura',
      'Talkha',
      'Mit Ghamr',
      'Dekernes',
      'Aga',
      'Manzala',
      'El Matareya',
      'Sherbin',
      'Belqas',
      'Gamasa',
      'El Mahalla',
      'Nabaroh',
      'Tami El Amdid',
      'El Sinbillawein',
      'El Kurdi',
      'Bani Ebeid',
      'Minyat El Nasr',
    ],
    'Damietta': [
      'Damietta',
      'New Damietta',
      'Ras El Bar',
      'Faraskur',
      'Zarqa',
      'Kafr Saad',
      'Kafr El Battikh',
    ],
    'Faiyum': [
      'Faiyum',
      'Ibshaway',
      'Itsa',
      'Sinnuris',
      'Tamiya',
      'Yusuf El Seddik',
    ],
    'Gharbia': [
      'Tanta',
      'El Mahalla El Kubra',
      'Kafr El Zayat',
      'Zefta',
      'Samanoud',
      'El Sonta',
      'Qutur',
      'Bassioun',
    ],
    'Ismailia': [
      'Ismailia',
      'Fayed',
      'Qantara Sharq',
      'Qantara Gharb',
      'Tel El Kebir',
      'Abu Sueir',
      'El Qasasin',
    ],
    'Kafr El Sheikh': [
      'Kafr El Sheikh',
      'Desouk',
      'Fouh',
      'Motobas',
      'Borg El Burullus',
      'Baltim',
      'Sidi Salem',
      'Qellin',
      'Bella',
      'El Riyad',
    ],
    'Matrouh': [
      'Marsa Matrouh',
      'El Alamein',
      'El Hammam',
      'Sidi Abdel Rahman',
      'Ras El Hekma',
      'Dabaa',
      'Siwa',
      'Barani',
      'Sallum',
      'El Negila',
    ],
    'Minya': [
      'Minya',
      'Mallawi',
      'Samalut',
      'Matay',
      'Beni Mazar',
      'Abu Qurqas',
      'Deir Mawas',
      'Maghagha',
      'Ard Sultan',
    ],
    'Monufia': [
      'Shibin El Kom',
      'Menouf',
      'Sadat City',
      'Ashmoun',
      'Quesna',
      'Berket El Saba',
      'Tala',
      'El Shohada',
      'El Bagour',
    ],
    'New Valley': [
      'Kharga',
      'Dakhla',
      'Farafra',
      'Balat',
      'Paris',
    ],
    'North Sinai': [
      'Arish',
      'Sheikh Zuweid',
      'Rafah',
      'Bir El Abd',
      'El Hasana',
      'Nakhl',
    ],
    'Qena': [
      'Qena',
      'Nag Hammadi',
      'Qus',
      'Dishna',
      'Abu Tesht',
      'Naqada',
      'El Waqf',
      'Farshut',
      'Qift',
    ],
    'Red Sea': [
      'Hurghada',
      'Safaga',
      'Marsa Alam',
      'El Gouna',
      'El Quseir',
      'Ras Gharib',
      'Shalateen',
      'Halaib',
    ],
    'Sharqia': [
      'Zagazig',
      '10th of Ramadan',
      'Belbeis',
      'Abu Hammad',
      'Abu Kabir',
      'Faqus',
      'Kafr Saqr',
      'Hehia',
      'Deirb Negm',
      'Minya El Qamh',
      'Awlad Saqr',
      'El Ibrahimiya',
      'Mashtul El Souk',
    ],
    'Sohag': [
      'Sohag',
      'Akhmim',
      'Girga',
      'El Balyana',
      'El Maragha',
      'Dar El Salam',
      'Juhayna',
      'Saqultah',
      'Tahta',
      'Tima',
      'El Mansha',
    ],
    'South Sinai': [
      'Sharm El Sheikh',
      'Dahab',
      'Nuweiba',
      'Taba',
      'Saint Catherine',
      'Ras Sedr',
      'Abu Redis',
      'El Tor',
    ],
  };

  /// Get all governorate names (uses current app locale by default)
  /// Note: Only Cairo and Giza are available as our services are limited to these areas
  static List<String> getAllGovernorates({bool? arabic}) {
    final useArabic = arabic ?? isArabic;
    // Only return Cairo and Giza as our services are limited to these governorates
    if (useArabic) {
      return ['القاهرة', 'الجيزة'];
    } else {
      return ['Cairo', 'Giza'];
    }
  }

  /// Get cities for a specific governorate (uses current app locale by default)
  static List<String> getCitiesForGovernorate(String governorate, {bool? arabic}) {
    final useArabic = arabic ?? isArabic;
    final map = useArabic ? governorates : governoratesEn;

    // Try direct lookup first
    if (map.containsKey(governorate)) {
      return map[governorate] ?? [];
    }

    // If not found, try to translate and lookup
    final translatedGov = useArabic
        ? _getArabicGovernorate(governorate)
        : _getEnglishGovernorate(governorate);

    if (translatedGov != null && map.containsKey(translatedGov)) {
      return map[translatedGov] ?? [];
    }

    return [];
  }

  /// Check if a region is a governorate
  static bool isGovernorate(String region) {
    return governorates.containsKey(region) || governoratesEn.containsKey(region);
  }

  /// Find governorate from address string (checks both Arabic and English)
  /// Returns in the current app locale by default
  static String? findGovernorateFromAddress(String address, {bool? returnArabic}) {
    final lowerAddress = address.toLowerCase();
    final useArabic = returnArabic ?? isArabic;

    // Check Arabic governorates
    for (final governorate in governorates.keys) {
      if (lowerAddress.contains(governorate.toLowerCase())) {
        return useArabic ? governorate : _getEnglishGovernorate(governorate);
      }
    }

    // Check English governorates
    for (final governorate in governoratesEn.keys) {
      if (lowerAddress.contains(governorate.toLowerCase())) {
        return useArabic ? _getArabicGovernorate(governorate) : governorate;
      }
    }

    return null;
  }

  /// Find city from address string and return both governorate and city
  /// Returns in the current app locale by default
  static Map<String, String>? parseAddress(String address, {bool? arabic}) {
    final lowerAddress = address.toLowerCase();
    final useArabic = arabic ?? isArabic;
    final govMap = useArabic ? governorates : governoratesEn;

    // Check if governorate is in address
    for (final entry in govMap.entries) {
      final governorate = entry.key;
      final cities = entry.value;

      if (lowerAddress.contains(governorate.toLowerCase())) {
        // Try to find a specific city
        for (final city in cities) {
          if (lowerAddress.contains(city.toLowerCase())) {
            return {
              'governorate': governorate,
              'city': city,
            };
          }
        }

        // Only governorate found, no specific city
        return {
          'governorate': governorate,
        };
      }
    }

    // Check cities without governorate match
    for (final entry in govMap.entries) {
      final governorate = entry.key;
      final cities = entry.value;

      for (final city in cities) {
        if (lowerAddress.contains(city.toLowerCase())) {
          return {
            'governorate': governorate,
            'city': city,
          };
        }
      }
    }

    // Try the opposite language
    final oppositeMap = useArabic ? governoratesEn : governorates;
    for (final entry in oppositeMap.entries) {
      final governorate = entry.key;
      final cities = entry.value;

      if (lowerAddress.contains(governorate.toLowerCase())) {
        final translatedGov = useArabic ? _getArabicGovernorate(governorate) : _getEnglishGovernorate(governorate);

        for (final city in cities) {
          if (lowerAddress.contains(city.toLowerCase())) {
            final translatedCity = useArabic ? _getArabicCity(governorate, city) : _getEnglishCity(governorate, city);
            return {
              'governorate': translatedGov ?? governorate,
              'city': translatedCity ?? city,
            };
          }
        }

        return {
          'governorate': translatedGov ?? governorate,
        };
      }
    }

    return null;
  }

  /// Get English governorate name from Arabic
  static String? _getEnglishGovernorate(String arabicGov) {
    final index = governorates.keys.toList().indexOf(arabicGov);
    if (index >= 0) {
      return governoratesEn.keys.toList()[index];
    }
    return null;
  }

  /// Get Arabic governorate name from English
  static String? _getArabicGovernorate(String englishGov) {
    final index = governoratesEn.keys.toList().indexOf(englishGov);
    if (index >= 0) {
      return governorates.keys.toList()[index];
    }
    return null;
  }

  /// Get English city name from Arabic
  static String? _getEnglishCity(String governorate, String arabicCity) {
    final arabicGov = governorates.containsKey(governorate) ? governorate : _getArabicGovernorate(governorate);
    if (arabicGov == null) return null;

    final arabicCities = governorates[arabicGov];
    if (arabicCities == null) return null;

    final cityIndex = arabicCities.indexOf(arabicCity);
    if (cityIndex >= 0) {
      final englishGov = _getEnglishGovernorate(arabicGov);
      if (englishGov != null) {
        final englishCities = governoratesEn[englishGov];
        if (englishCities != null && cityIndex < englishCities.length) {
          return englishCities[cityIndex];
        }
      }
    }
    return null;
  }

  /// Get Arabic city name from English
  static String? _getArabicCity(String governorate, String englishCity) {
    final englishGov = governoratesEn.containsKey(governorate) ? governorate : _getEnglishGovernorate(governorate);
    if (englishGov == null) return null;

    final englishCities = governoratesEn[englishGov];
    if (englishCities == null) return null;

    final cityIndex = englishCities.indexOf(englishCity);
    if (cityIndex >= 0) {
      final arabicGov = _getArabicGovernorate(englishGov);
      if (arabicGov != null) {
        final arabicCities = governorates[arabicGov];
        if (arabicCities != null && cityIndex < arabicCities.length) {
          return arabicCities[cityIndex];
        }
      }
    }
    return null;
  }
}

