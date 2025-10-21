class ValidationUtils {
  // Email validation regex
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
  );

  // Phone number without country code - should not start with 0
  // Must be 6-14 digits, starting with 1-9
  static final RegExp _phoneWithoutCountryCodeRegex = RegExp(
    r'^[1-9][0-9]{5,13}$',
  );

  // Name validation regex (at least 2 characters, letters and spaces only)
  static final RegExp _nameRegex = RegExp(
    r'^[a-zA-Z\s]{2,}$',
  );

  // Password validation regex (at least 6 chars, with at least one number)
  static final RegExp _passwordRegex = RegExp(
    r'^(?=.*[0-9]).{6,}$',
  );

  // Validate email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!_emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Validate phone number with country code
  static String? validatePhone(String? value, {String? countryCode}) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }

    // Check if phone starts with 0
    if (value.startsWith('0')) {
      return 'Phone number cannot start with 0';
    }

    // Validate the phone number format without country code
    if (!_phoneWithoutCountryCodeRegex.hasMatch(value)) {
      return 'Please enter a valid phone number (6-14 digits)';
    }

    return null;
  }

  // Validate name
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    if (value.length < 2) {
      return 'Name is too short';
    }
    if (!_nameRegex.hasMatch(value)) {
      return 'Please enter a valid name';
    }
    return null;
  }

  // Validate password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (!_passwordRegex.hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    return null;
  }
}
