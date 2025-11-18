import 'package:flutter/services.dart';
import 'package:petapp/core/utils/formatters.dart';

/// TextInputFormatter that allows only digits (both English and Arabic numerals)
class ArabicAwareDigitsOnlyFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Allow only English digits (0-9) and Arabic digits (٠-٩)
    final RegExp digitsRegex = RegExp(r'[0-9٠-٩]');
    final String filtered = newValue.text
        .split('')
        .where((char) => digitsRegex.hasMatch(char))
        .join();

    // Preserve cursor position
    int selectionIndex = newValue.selection.end;
    final int removedChars = newValue.text.length - filtered.length;
    selectionIndex = (selectionIndex - removedChars).clamp(0, filtered.length);

    return TextEditingValue(
      text: filtered,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

/// TextInputFormatter that displays numbers in Arabic numerals for Arabic locale
/// but stores them as English numerals for processing
class ArabicNumeralInputFormatter extends TextInputFormatter {
  final bool isArabic;

  ArabicNumeralInputFormatter(this.isArabic);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (!isArabic) {
      return newValue;
    }

    // Convert any English numerals to Arabic for display
    String displayText = TFormatter.toArabicNumerals(newValue.text);

    // Preserve the cursor position
    int selectionIndex = newValue.selection.end;

    // Make sure selection is within bounds
    if (selectionIndex > displayText.length) {
      selectionIndex = displayText.length;
    }

    return TextEditingValue(
      text: displayText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

/// TextInputFormatter that accepts Arabic numerals but converts them to English for storage
class ArabicNumeralOutputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Convert Arabic numerals to English for processing
    String processedText = TFormatter.toEnglishNumerals(newValue.text);

    // Preserve the cursor position
    int selectionIndex = newValue.selection.end;

    // Make sure selection is within bounds
    if (selectionIndex > processedText.length) {
      selectionIndex = processedText.length;
    }

    return TextEditingValue(
      text: processedText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
