// Auth Request Models for API v1 endpoints
class LoginRequest {
  final String identifier; // Can be email, phone, or username
  final String password;
  final String? turnstileToken;

  LoginRequest({
    required this.identifier,
    required this.password,
    this.turnstileToken,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'identifier': identifier,
      'password': password,
    };
    
    if (turnstileToken != null && turnstileToken!.isNotEmpty) {
      data['turnstileToken'] = turnstileToken;
    }
    
    return data;
  }

  @override
  String toString() {
    return 'LoginRequest(identifier: $identifier, turnstileToken: ${turnstileToken != null ? "[PRESENT]" : "[ABSENT]"})';
  }
}

class RegisterRequest {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String username;
  final String mobile;
  final String role;
  final String? turnstileToken;

  RegisterRequest({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.mobile,
    this.role = 'user',
    this.turnstileToken,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'mobile': mobile,
      'role': role,
    };
    
    if (turnstileToken != null && turnstileToken!.isNotEmpty) {
      data['turnstileToken'] = turnstileToken;
    }
    
    return data;
  }

  @override
  String toString() {
    return 'RegisterRequest(email: $email, firstName: $firstName, lastName: $lastName, username: $username, mobile: $mobile, role: $role)';
  }
}

class ConfirmEmailRequest {
  final String email;
  final String otp;

  ConfirmEmailRequest({
    required this.email,
    required this.otp,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
    };
  }

  @override
  String toString() {
    return 'ConfirmEmailRequest(email: $email, otp: [HIDDEN])';
  }
}

class ResendOtpRequest {
  final String email;

  ResendOtpRequest({
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }

  @override
  String toString() {
    return 'ResendOtpRequest(email: $email)';
  }
}

class ForgotPasswordRequest {
  final String email;

  ForgotPasswordRequest({
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }

  @override
  String toString() {
    return 'ForgotPasswordRequest(email: $email)';
  }
}

class ResetPasswordRequest {
  final String email;
  final String otp;
  final String password;

  ResetPasswordRequest({
    required this.email,
    required this.otp,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
      'password': password,
    };
  }

  @override
  String toString() {
    return 'ResetPasswordRequest(email: $email, otp: [HIDDEN])';
  }
}

class RefreshTokenRequest {
  final String refreshToken;

  RefreshTokenRequest({
    required this.refreshToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'refreshToken': refreshToken,
    };
  }

  @override
  String toString() {
    return 'RefreshTokenRequest(refreshToken: [HIDDEN])';
  }
}

class UpdateProfileRequest {
  final String? name;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? mobile;
  final String? address;
  final String? dateOfBirth;
  final String? username;

  UpdateProfileRequest({
    this.name,
    this.firstName,
    this.lastName,
    this.phone,
    this.mobile,
    this.address,
    this.dateOfBirth,
    this.username,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    
    if (name != null) data['name'] = name;
    if (firstName != null) data['firstName'] = firstName;
    if (lastName != null) data['lastName'] = lastName;
    if (phone != null) data['phone'] = phone;
    if (mobile != null) data['mobile'] = mobile;
    if (address != null) data['address'] = address;
    if (dateOfBirth != null) data['dateOfBirth'] = dateOfBirth;
    if (username != null) data['username'] = username;
    
    return data;
  }

  @override
  String toString() {
    return 'UpdateProfileRequest(name: $name, firstName: $firstName, lastName: $lastName, phone: $phone, mobile: $mobile)';
  }
}

class ConfirmNewEmailRequest {
  final String email;
  final String otp;

  ConfirmNewEmailRequest({
    required this.email,
    required this.otp,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
    };
  }

  @override
  String toString() {
    return 'ConfirmNewEmailRequest(email: $email, otp: [HIDDEN])';
  }
}