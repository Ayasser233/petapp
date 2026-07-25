class ShippingAddressModel {
  final String? id;
  final String fullName;
  final String phone;
  final String country;
  final String governorate; // e.g., "Cairo"
  final String city;        // district / area within governorate
  final String addressLine1;
  final String? addressLine2;
  final String? postalCode;

  const ShippingAddressModel({
    this.id,
    required this.fullName,
    required this.phone,
    required this.country,
    String? governorate,
    required this.city,
    required this.addressLine1,
    this.addressLine2,
    this.postalCode,
  }) : governorate = governorate ?? '';

  ShippingAddressModel copyWith({
    String? id,
    String? fullName,
    String? phone,
    String? country,
    String? governorate,
    String? city,
    String? addressLine1,
    String? addressLine2,
    String? postalCode,
  }) {
    return ShippingAddressModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      country: country ?? this.country,
      governorate: governorate ?? this.governorate,
      city: city ?? this.city,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      postalCode: postalCode ?? this.postalCode,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShippingAddressModel && id != null && id == other.id;

  @override
  int get hashCode => id?.hashCode ?? super.hashCode;

  /// Short display label, e.g. "Nasr City, Cairo" or "Cairo"
  String get label {
    if (city.isNotEmpty) return '$city, $governorate';
    return governorate.isNotEmpty ? governorate : country;
  }

  /// Full display line
  String get fullLine {
    final parts = [
      addressLine1,
      if (addressLine2 != null) addressLine2,
      if (city.isNotEmpty) city,
      if (governorate.isNotEmpty) governorate,
      if (postalCode != null) postalCode,
      country,
    ];
    return parts.join(', ');
  }

  /// Full serialization — used for local persistence (SharedPreferences)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'fullName': fullName,
      'phone': phone,
      'country': country,
      'governorate': governorate,
      'city': city,
      'addressLine1': addressLine1,
      if (addressLine2 != null) 'addressLine2': addressLine2,
      if (postalCode != null) 'postalCode': postalCode,
    };
  }

  /// API-safe serialization — excludes local-only fields (`id`, `governorate`)
  /// that the backend /checkout/initiate endpoint does not accept.
  Map<String, dynamic> toCheckoutJson() {
    return {
      'fullName': fullName,
      'phone': phone,
      'country': country,
      'city': city.isNotEmpty ? city : governorate, // fallback to governorate if no city
      'addressLine1': addressLine1,
      if (addressLine2 != null && addressLine2!.isNotEmpty) 'addressLine2': addressLine2,
      if (postalCode != null && postalCode!.isNotEmpty) 'postalCode': postalCode,
    };
  }

  factory ShippingAddressModel.fromJson(Map<String, dynamic> json) {
    return ShippingAddressModel(
      id: json['id'] as String?,
      fullName: json['fullName'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      country: json['country'] as String? ?? 'Egypt',
      governorate: json['governorate'] as String? ?? '',
      city: json['city'] as String? ?? '',
      addressLine1: json['addressLine1'] as String? ?? '',
      addressLine2: json['addressLine2'] as String?,
      postalCode: json['postalCode'] as String?,
    );
  }
}