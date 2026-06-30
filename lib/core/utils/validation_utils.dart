class ValidationUtils {
  // Email validation regex
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
  );

  // Phone number - Egyptian format (10-11 digits, can start with 0)
  // Accepts both English (0-9) and Arabic (٠-٩) numerals
  static final RegExp _phoneRegex = RegExp(
    r'^[0-9٠-٩]{10,11}$',
  );

  // Name validation regex (at least 2 characters, letters and spaces only, supports Arabic)
  static final RegExp _nameRegex = RegExp(
    r'^[a-zA-Z\s\u0600-\u06FF]{2,}$',
  );

  // Password validation regex (at least 6 chars, with at least one number)
  // Accepts both English and Arabic numerals
  static final RegExp _passwordRegex = RegExp(
    r'^(?=.*[0-9٠-٩]).{6,}$',
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

  // Validate phone number (Egyptian format: 10-11 digits, can start with 0)
  static String? validatePhone(String? value, {String? countryCode}) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }

    // Validate the phone number format (10-11 digits)
    if (!_phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number (10-11 digits)';
    }

    return null;
  }

  // Validate full name (at least two words)
  static String? validateFullName(String? value, String requiredMsg, String invalidMsg) {
    if (value == null || value.trim().isEmpty) {
      return requiredMsg;
    }
    
    final nameParts = value.trim().split(RegExp(r'\s+'));
    if (nameParts.length < 2 || nameParts.any((part) => part.length < 2)) {
      return invalidMsg;
    }

    if (!_nameRegex.hasMatch(value)) {
      return requiredMsg;
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

  static String? normalizePhone(String phone) {
    phone = phone.replaceAll(RegExp(r'[\s\-]'), '');

    if (phone.startsWith('+20')) {
      return phone; // ✅ صح بالفعل
    } else if (phone.startsWith('20')) {
      return '+$phone'; // 201234567890 → +201234567890
    } else if (phone.startsWith('0')) {
      return '+20${phone.substring(1)}'; // 01234567890 → +201234567890
    } else {
      return '+20$phone'; // 1234567890 → +201234567890
    }
  }
}
