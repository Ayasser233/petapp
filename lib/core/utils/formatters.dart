import 'package:intl/intl.dart';

class TFormatter{
  static String formatCurrency(double value) {
    return NumberFormat.currency(locale: 'ar_EG', symbol: 'E£', decimalDigits: 2).format(value);
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
    return phoneNumber.replaceFirst(RegExp(r'^(01[0-9])(\d{4})(\d{4})$'), r'(\1) \2-\3');
  }

  // Match Cairo & Giza (8-digit landlines)
  if (RegExp(r'^(02)(\d{4})(\d{4})$').hasMatch(phoneNumber)) {
    return phoneNumber.replaceFirst(RegExp(r'^(02)(\d{4})(\d{4})$'), r'(\1) \2-\3');
  }

  // Match all other governorates (7-digit landlines)
  if (RegExp(r'^(03|04|05|06|08|09)(\d{3})(\d{4})$').hasMatch(phoneNumber)) {
    return phoneNumber.replaceFirst(RegExp(r'^(03|04|05|06|08|09)(\d{3})(\d{4})$'), r'(\1) \2-\3');
  }

  // Return original if no match
  return phoneNumber;
  }
}