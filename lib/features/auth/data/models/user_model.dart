class UserModel {
  final String id;
  final String? firstName;
  final String? lastName;
  final String name; // Full name for backward compatibility
  final String email;
  final String phone;
  final String? mobile;
  final String? username;
  final String? address;
  final String? dateOfBirth;
  final bool emailVerified;
  final bool twoFactorEnabled;
  final String? role;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    this.firstName,
    this.lastName,
    required this.name,
    required this.email,
    required this.phone,
    this.mobile,
    this.username,
    this.address,
    this.dateOfBirth,
    required this.emailVerified,
    required this.twoFactorEnabled,
    this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle both firstName/lastName and name formats
    String fullName = json['name'] ?? '';
    if (fullName.isEmpty && json['firstName'] != null) {
      fullName = '${json['firstName']} ${json['lastName'] ?? ''}'.trim();
    }

    // If fullName is still empty, create a default
    if (fullName.isEmpty) {
      fullName = json['email']?.split('@').first ?? 'User';
    }

    return UserModel(
      id: json['id']?.toString() ?? '',
      firstName: json['firstName'],
      lastName: json['lastName'],
      name: fullName,
      email: json['email'] ?? '',
      phone: json['mobile']?.toString() ?? json['phone']?.toString() ?? '',
      mobile: json['mobile']?.toString(),
      username: json['username'],
      address: json['address'],
      dateOfBirth: json['dateOfBirth'] ?? json['date_of_birth'],
      emailVerified: json['emailVerified'] ??
          json['email_verified'] ??
          json['isVerified'] ??
          false,
      twoFactorEnabled:
          json['twoFactorEnabled'] ?? json['two_factor_enabled'] ?? false,
      role: json['role'] ?? 'user',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : (json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : DateTime.now()),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : (json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : DateTime.now()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'name': name,
      'email': email,
      'phone': phone,
      'mobile': mobile,
      'username': username,
      'address': address,
      'dateOfBirth': dateOfBirth,
      'emailVerified': emailVerified,
      'twoFactorEnabled': twoFactorEnabled,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? name,
    String? email,
    String? phone,
    String? mobile,
    String? username,
    String? address,
    String? dateOfBirth,
    bool? emailVerified,
    bool? twoFactorEnabled,
    String? profilePictureUrl,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      mobile: mobile ?? this.mobile,
      username: username ?? this.username,
      address: address ?? this.address,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      emailVerified: emailVerified ?? this.emailVerified,
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Add getter for backward compatibility
  bool get isVerified => emailVerified;
}
