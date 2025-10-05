import 'package:flutter/material.dart';

/// Utility class for handling field errors from API responses
class FieldErrorHelper {
  /// Extract error message for a specific field from field errors map
  static String? getFieldError(Map<String, String>? fieldErrors, String fieldName) {
    if (fieldErrors == null || fieldErrors.isEmpty) return null;
    
    // Direct match
    if (fieldErrors.containsKey(fieldName)) {
      return fieldErrors[fieldName];
    }
    
    // Case insensitive match
    final lowerFieldName = fieldName.toLowerCase();
    for (final entry in fieldErrors.entries) {
      if (entry.key.toLowerCase() == lowerFieldName) {
        return entry.value;
      }
    }
    
    return null;
  }
  
  /// Check if a specific field has an error
  static bool hasFieldError(Map<String, String>? fieldErrors, String fieldName) {
    return getFieldError(fieldErrors, fieldName) != null;
  }
  
  /// Get all field error messages as a formatted string
  static String getAllFieldErrors(Map<String, String>? fieldErrors) {
    if (fieldErrors == null || fieldErrors.isEmpty) return '';
    
    final messages = fieldErrors.entries
        .map((entry) => '${_capitalizeFirst(entry.key)}: ${entry.value}')
        .toList();
    
    return messages.join('\n');
  }
  
  /// Get field error count
  static int getFieldErrorCount(Map<String, String>? fieldErrors) {
    return fieldErrors?.length ?? 0;
  }
  
  /// Create a validation function for TextFormField that integrates with existing validators
  static String? Function(String?)? createValidator(
    Map<String, String>? fieldErrors,
    String fieldName,
    {String? Function(String?)? existingValidator}
  ) {
    return (String? value) {
      // Run existing validation first (ValidationUtils methods)
      if (existingValidator != null) {
        final validationError = existingValidator(value);
        if (validationError != null) return validationError;
      }
      
      // Check for field-specific server error
      return getFieldError(fieldErrors, fieldName);
    };
  }
  
  /// Show field errors in a dialog
  static void showFieldErrorsDialog(
    BuildContext context, 
    Map<String, String>? fieldErrors, 
    {String title = 'Validation Errors'}
  ) {
    if (fieldErrors == null || fieldErrors.isEmpty) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: fieldErrors.entries
              .map((entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_capitalizeFirst(entry.key)}: ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Expanded(child: Text(entry.value)),
                      ],
                    ),
                  ))
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  
  /// Create a widget to display field errors as a list
  static Widget buildFieldErrorsList(
    Map<String, String>? fieldErrors, 
    {EdgeInsetsGeometry? padding, TextStyle? textStyle}
  ) {
    if (fieldErrors == null || fieldErrors.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Container(
      padding: padding ?? const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: fieldErrors.entries
            .map((entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 16,
                        color: Colors.red.shade600,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${_capitalizeFirst(entry.key)}: ${entry.value}',
                          style: textStyle ?? 
                            TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 13,
                            ),
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
  
  /// Helper method to capitalize first letter
  static String _capitalizeFirst(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }
}