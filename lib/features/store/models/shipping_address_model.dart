class ShippingAddressModel {
  final String fullName;
  final String phone;
  final String country;
  final String city;
  final String addressLine1;
  final String? addressLine2;
  final String? postalCode;

  const ShippingAddressModel({
    required this.fullName,
    required this.phone,
    required this.country,
    required this.city,
    required this.addressLine1,
    this.addressLine2,
    this.postalCode,
  });

  /// Short display label, e.g. "Cairo, Egypt"
  String get label => '$city, $country';

  /// Full display line
  String get fullLine {
    final parts = [addressLine1, if (addressLine2 != null) addressLine2, city, if (postalCode != null) postalCode, country];
    return parts.join(', ');
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'phone': phone,
      'country': country,
      'city': city,
      'addressLine1': addressLine1,
      if (addressLine2 != null) 'addressLine2': addressLine2,
      if (postalCode != null) 'postalCode': postalCode,
    };
  }

  factory ShippingAddressModel.fromJson(Map<String, dynamic> json) {
    return ShippingAddressModel(
      fullName: json['fullName'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      country: json['country'] as String? ?? '',
      city: json['city'] as String? ?? '',
      addressLine1: json['addressLine1'] as String? ?? '',
      addressLine2: json['addressLine2'] as String?,
      postalCode: json['postalCode'] as String?,
    );
  }
}
