import 'package:petapp/core/utils/api_constants.dart';

class UserModel {
  final String id;
  final String? firstName;
  final String? lastName;
  final String name; // Full name for backward compatibility
  final String email;
  final String phone;
  final String? mobile;
  final String? username;
  final String? profilePictureUrl;
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
    this.profilePictureUrl,
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
      profilePictureUrl: _convertImagePath(json['profilePictureUrl'] ?? json['photo'] ?? json['image']),
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
      'profilePictureUrl': profilePictureUrl,
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
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      emailVerified: emailVerified ?? this.emailVerified,
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Add getter for backward compatibility
  bool get isVerified => emailVerified;

  /// Helper method to convert relative image paths to full URLs
  static String? _convertImagePath(dynamic path) {
    if (path == null) return null;
    String imagePath = path.toString();
    if (imagePath.isEmpty) return null;

    // If already a full URL or asset path, return as is
    if (imagePath.startsWith('http://') ||
        imagePath.startsWith('https://') ||
        imagePath.startsWith('assets/')) {
      return imagePath;
    }

    // If it's a relative API path, convert to full URL
    if (imagePath.startsWith('/api/')) {
      final baseUrl = ApiConstants.apiBaseUrl;
      // Remove /api/v1 from baseUrl and the path since path already has it
      final cleanBaseUrl = baseUrl.replaceAll('/api/v1', '');
      return '$cleanBaseUrl$imagePath';
    }

    // If it starts with just /, assume it's relative to base URL
    if (imagePath.startsWith('/')) {
      return '${ApiConstants.apiBaseUrl}$imagePath';
    }

    // For paths like "users/abc.jpg" or "pets/abc.jpg" or "d5997f53104ccfa3b55e4.png"
    // Images are served from MinIO storage
    const minioBaseUrl = 'https://minio-api.aleefy-app.com/uploads';
    String cleanPath = imagePath;

    // Remove "uploads/" prefix if present (since we'll add it back)
    if (cleanPath.startsWith('uploads/')) {
      cleanPath = cleanPath.replaceFirst('uploads/', '');
    }

    // Build the URL with MinIO base URL
    return '$minioBaseUrl/$cleanPath';
  }
}
