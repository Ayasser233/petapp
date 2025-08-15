class UserProfileModel {
  final String id;
  final String? name;
  final String email;
  final String? phone;
  final String? address;
  final String? dateOfBirth;
  final String? profilePictureUrl;
  final bool emailVerified;
  final bool twoFactorEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfileModel({
    required this.id,
    this.name,
    required this.email,
    this.phone,
    this.address,
    this.dateOfBirth,
    this.profilePictureUrl,
    required this.emailVerified,
    required this.twoFactorEnabled,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      address: json['address'],
      dateOfBirth: json['date_of_birth'],
      profilePictureUrl: json['profile_picture_url'],
      emailVerified: json['email_verified'] ?? false,
      twoFactorEnabled: json['two_factor_enabled'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'date_of_birth': dateOfBirth,
      'profile_picture_url': profilePictureUrl,
      'email_verified': emailVerified,
      'two_factor_enabled': twoFactorEnabled,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  UserProfileModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? dateOfBirth,
    String? profilePictureUrl,
    bool? emailVerified,
    bool? twoFactorEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      emailVerified: emailVerified ?? this.emailVerified,
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}