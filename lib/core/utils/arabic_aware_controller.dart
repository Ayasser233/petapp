import 'package:flutter/material.dart';
import 'package:petapp/core/utils/formatters.dart';

/// Extended TextEditingController that handles Arabic numerals automatically
class ArabicAwareTextController extends TextEditingController {
  final bool isArabic;

  ArabicAwareTextController({this.isArabic = false, super.text});

  @override
  set text(String newText) {
    // Convert to Arabic numerals for display if needed
    if (isArabic && newText.isNotEmpty) {
      super.text = TFormatter.toArabicNumerals(newText);
    } else {
      super.text = newText;
    }
  }

  /// Get the text with English numerals (for API calls)
  String get englishText {
    return TFormatter.toEnglishNumerals(text);
  }

  /// Set text with automatic conversion based on locale
  void setTextWithLocale(String newText, bool shouldConvertToArabic) {
    if (shouldConvertToArabic) {
      super.text = TFormatter.toArabicNumerals(newText);
    } else {
      super.text = newText;
    }
  }
}

/// Helper extension to easily convert TextEditingController values
extension TextControllerArabicExtension on TextEditingController {
  /// Get text with English numerals
  String get englishText {
    return TFormatter.toEnglishNumerals(text);
  }

  /// Set text and convert to Arabic if needed
  void setArabicAwareText(String newText, bool isArabic) {
    if (isArabic) {
      text = TFormatter.toArabicNumerals(newText);
    } else {
      text = newText;
    }
  }
}
