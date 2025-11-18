import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class TFormatter {
  // Convert English numerals (0-9) to Arabic numerals (٠-٩)
  static String toArabicNumerals(String text) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    String result = text;
    for (int i = 0; i < english.length; i++) {
      result = result.replaceAll(english[i], arabic[i]);
    }
    return result;
  }

  // Convert Arabic numerals (٠-٩) to English numerals (0-9)
  static String toEnglishNumerals(String text) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    String result = text;
    for (int i = 0; i < english.length; i++) {
      result = result.replaceAll(arabic[i], english[i]);
    }
    return result;
  }

  // Format number based on current locale
  static String formatNumber(dynamic number, BuildContext context) {
    final locale = Localizations.localeOf(context);
    String numStr = number.toString();

    if (locale.languageCode == 'ar') {
      return toArabicNumerals(numStr);
    }
    return numStr;
  }

  static String formatCurrency(double value) {
    return NumberFormat.currency(
            locale: 'ar_EG', symbol: 'E£', decimalDigits: 2)
        .format(value);
  }

  static String formatDate(DateTime? date) {
    date ??= DateTime.now();
    return DateFormat('dd-MMM-yyyy').format(date);
  }

  static String formatPhoneNumber(String phoneNumber) {
    // Ensure we only process digits
    phoneNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');

    // Match Egyptian mobile numbers (11 digits)
    if (RegExp(r'^(01[0-9])(\d{4})(\d{4})$').hasMatch(phoneNumber)) {
      return phoneNumber.replaceFirst(
          RegExp(r'^(01[0-9])(\d{4})(\d{4})$'), r'(\1) \2-\3');
    }

    // Match Cairo & Giza (8-digit landlines)
    if (RegExp(r'^(02)(\d{4})(\d{4})$').hasMatch(phoneNumber)) {
      return phoneNumber.replaceFirst(
          RegExp(r'^(02)(\d{4})(\d{4})$'), r'(\1) \2-\3');
    }

    // Match all other governorates (7-digit landlines)
    if (RegExp(r'^(03|04|05|06|08|09)(\d{3})(\d{4})$').hasMatch(phoneNumber)) {
      return phoneNumber.replaceFirst(
          RegExp(r'^(03|04|05|06|08|09)(\d{3})(\d{4})$'), r'(\1) \2-\3');
    }

    // Return original if no match
    return phoneNumber;
  }

  /// Sanitizes data for API calls by converting all Arabic numerals to English
  /// This ensures that numbers stored in the database are always in English format
  ///
  /// Usage:
  /// ```dart
  /// final userData = {
  ///   'phone': '٠١٠٣٠٧٥٦٨٦٢',
  ///   'age': '٢٥',
  ///   'name': 'أحمد'
  /// };
  /// final sanitized = TFormatter.sanitizeForApi(userData);
  /// // Result: {'phone': '01030756862', 'age': '25', 'name': 'أحمد'}
  /// ```
  static Map<String, dynamic> sanitizeForApi(Map<String, dynamic> data) {
    final sanitized = <String, dynamic>{};

    data.forEach((key, value) {
      if (value is String) {
        // Convert any Arabic numerals in strings to English
        sanitized[key] = toEnglishNumerals(value);
      } else if (value is Map<String, dynamic>) {
        // Recursively sanitize nested maps
        sanitized[key] = sanitizeForApi(value);
      } else if (value is List) {
        // Sanitize lists
        sanitized[key] = _sanitizeList(value);
      } else {
        // Keep other types as-is (int, double, bool, null, etc.)
        sanitized[key] = value;
      }
    });

    return sanitized;
  }

  /// Helper function to sanitize lists
  static List<dynamic> _sanitizeList(List<dynamic> list) {
    return list.map((item) {
      if (item is String) {
        return toEnglishNumerals(item);
      } else if (item is Map<String, dynamic>) {
        return sanitizeForApi(item);
      } else if (item is List) {
        return _sanitizeList(item);
      } else {
        return item;
      }
    }).toList();
  }
}
