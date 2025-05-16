class CountryCode {
  final String name;
  final String dialCode;
  final String code;
  final String flag;

  CountryCode({
    required this.name,
    required this.dialCode,
    required this.code,
    required this.flag,
  });

  factory CountryCode.fromMap(Map<String, dynamic> map) {
    return CountryCode(
      name: map['name'] as String,
      dialCode: map['dial_code'] as String,
      code: map['code'] as String,
      flag: map['flag'] as String,
    );
  }
}

// Common country codes
class CountryCodes {
  static final List<CountryCode> commonCodes = [
    CountryCode(
      name: "Egypt",
      dialCode: "+20",
      code: "EG",
      flag: "🇪🇬",
    ),
  ];
}