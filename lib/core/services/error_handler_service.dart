import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

class ErrorHandlerService extends GetxService {
  static ErrorHandlerService get instance => Get.find<ErrorHandlerService>();

  /// Handle any error - server or client
  void handleError(dynamic error, {bool suppressUserNotification = false}) {
    String message = _getErrorMessage(error);
    String title = _getErrorTitle(error);
    Color color = _getErrorColor(error);

    // Check if this is a non-critical error that shouldn't be shown to users
    if (_shouldSuppressError(error, message) || suppressUserNotification) {
      // Only log the error without showing snackbar
      _logError(error, message);
      return;
    }

    _showErrorSnackbar(title, message, color);
    _logError(error, message);
  }

  /// Check if error should be suppressed from user notification
  bool _shouldSuppressError(dynamic error, String message) {
    final lowerMessage = message.toLowerCase();

    // Suppress 401 Unauthorized errors - handled by token refresh logic
    if (error is DioException && error.response?.statusCode == 401) {
      return true;
    }

    // Suppress species-related errors as they're not critical
    if (lowerMessage.contains('species') ||
        lowerMessage.contains('pet species') ||
        lowerMessage.contains('allowed species')) {
      return true;
    }

    // Suppress type conversion errors related to API data parsing
    if (lowerMessage.contains('is not a subtype of type') &&
        (lowerMessage.contains('map<string, dynamic>') ||
            lowerMessage.contains('string'))) {
      return true;
    }

    // If this is a DioException, check the request URL
    if (error is DioException) {
      final url = error.requestOptions.uri.toString().toLowerCase();

      // Suppress FCM token errors - not critical for user experience
      if (url.contains('/notifications/token') ||
          url.contains('/notification-token') ||
          url.contains('notification') && url.contains('token')) {
        return true;
      }

      // Suppress species-related errors
      if (url.contains('species') || url.contains('/pets/species')) {
        return true;
      }

      // Suppress appointment-related errors - handled by feature's BlocListener
      if (url.contains('/appointments')) {
        return true;
      }

      // Suppress auth-related errors - handled by AuthCubit's BlocListener
      if (url.contains('/auth/register') ||
          url.contains('/auth/login') ||
          url.contains('/auth/confirm') ||
          url.contains('/auth/forgot') ||
          url.contains('/auth/reset') ||
          url.contains('/auth/change-password')) {
        return true;
      }
    }

    return false;
  }

  /// Extract error message from different error types - UPDATED
  String _getErrorMessage(dynamic error) {
    // Server errors (Dio)
    if (error is DioException) {
      return _extractServerMessage(error);
    }

    // Client errors
    if (error is Exception) {
      return error.toString().replaceAll('Exception: ', '');
    }

    // Unknown errors
    return error.toString();
  }

  /// Extract message from server JSON response - UPDATED
  String _extractServerMessage(DioException error) {
    if (error.response?.data == null) {
      return _getDefaultServerMessage(error.response?.statusCode);
    }

    final data = error.response!.data;

    // Handle HTML responses (like Cloudflare error pages)
    if (data is String) {
      // Check if it's HTML content
      if (data.trim().toLowerCase().startsWith('<!doctype html') ||
          data.trim().toLowerCase().startsWith('<html')) {
        // Don't show HTML content - use default message
        return _getDefaultServerMessage(error.response?.statusCode);
      }
      // For non-HTML strings, return as is
      return data;
    }

    // Handle different JSON structures
    if (data is Map<String, dynamic>) {
      // First priority: Get the actual message from server
      String? serverMessage = data['message'] ?? // Your API returns this
          data['error'] ?? // Fallback
          data['msg'] ?? // Fallback
          data['detail'] ?? // Fallback
          data['description'] ?? // Fallback
          data['error_description'] ?? // OAuth errors
          data['errorMessage']; // Fallback

      // If we found a server message, use it directly
      if (serverMessage != null && serverMessage.isNotEmpty) {
        return serverMessage;
      }

      // Check nested errorDetails (your API structure)
      if (data['errorDetails'] is Map<String, dynamic>) {
        final errorDetails = data['errorDetails'] as Map<String, dynamic>;

        // Handle new validation format with array of field errors
        if (errorDetails['message'] is List) {
          final messages = errorDetails['message'] as List;
          if (messages.isNotEmpty) {
            // Extract first field error for display
            if (messages.first is Map) {
              final firstError = messages.first as Map;
              final message = firstError.values.first;
              return message.toString();
            }
            return messages.first.toString();
          }
        }

        // Fallback to simple message
        final nestedMessage = errorDetails['message'] ?? errorDetails['error'];
        if (nestedMessage != null &&
            nestedMessage.isNotEmpty &&
            nestedMessage is! List) {
          return nestedMessage.toString();
        }
      }

      // Handle validation errors (422 status)
      if (error.response?.statusCode == 422) {
        return _extractValidationMessage(data);
      }

      // Handle array of errors
      if (data['errors'] is List) {
        final errors = data['errors'] as List;
        if (errors.isNotEmpty) {
          return errors.first.toString();
        }
      }
    }

    // Only use default message if no server message found
    return _getDefaultServerMessage(error.response?.statusCode);
  }

  /// Extract validation error messages
  String _extractValidationMessage(Map<String, dynamic> data) {
    // Laravel validation format: {"errors": {"email": ["Email is required"]}}
    if (data['errors'] is Map<String, dynamic>) {
      final errors = data['errors'] as Map<String, dynamic>;
      final firstError = errors.values.first;
      if (firstError is List && firstError.isNotEmpty) {
        return firstError.first.toString();
      }
      return firstError.toString();
    }

    // Simple validation format: {"email": ["Email is required"]}
    final firstEntry = data.entries.first;
    if (firstEntry.value is List) {
      final list = firstEntry.value as List;
      return list.isNotEmpty ? list.first.toString() : 'Validation error';
    }

    return 'Please check your input data.';
  }

  /// Get error title
  String _getErrorTitle(dynamic error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      switch (statusCode) {
        case 400:
          return 'Bad Request';
        case 401:
          return 'Authentication Failed';
        case 403:
          return 'Access Denied';
        case 404:
          return 'Not Found';
        case 422:
          return 'Validation Error';
        case 429:
          return 'Too Many Requests';
        case 500:
          return 'Server Error';
        case 502:
        case 503:
        case 504:
          return 'Server Unavailable';
        default:
          return statusCode != null && statusCode >= 500
              ? 'Server Error'
              : 'Network Error';
      }
    }
    return 'App Error';
  }

  /// Get error color based on error type
  Color _getErrorColor(dynamic error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      switch (statusCode) {
        case 400:
        case 422:
          return Colors.orange[700]!; // Validation/input errors
        case 401:
          return Colors.red[600]!; // Authentication
        case 403:
          return Colors.red[700]!; // Permission denied
        case 404:
          return Colors.blue[700]!; // Not found
        case 429:
          return Colors.purple[700]!; // Rate limit
        case 500:
        case 502:
        case 503:
        case 504:
          return Colors.red[900]!; // Server errors
        default:
          return Colors.red;
      }
    }
    return Colors.indigo; // Client errors
  }

  /// Get default server error message
  String _getDefaultServerMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Invalid request. Please check your input.';
      case 401:
        return 'Invalid credentials. Please check your email and password.';
      case 403:
        return 'You don\'t have permission for this action.';
      case 404:
        return 'The requested resource was not found.';
      case 422:
        return 'Please check your input data.';
      case 429:
        return 'Too many requests. Please try again later.';
      case 500:
        return 'Server error. Please try again later.';
      case 502:
        return 'Bad gateway. Server is temporarily unavailable.';
      case 503:
        return 'Service temporarily unavailable.';
      case 504:
        return 'Gateway timeout. Please try again.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  /// Show error snackbar
  void _showErrorSnackbar(String title, String message, Color color) {
    // Check if GetX context is available before showing snackbar
    if (Get.context == null) {
      debugPrint('⚠️ Cannot show snackbar: GetX context not available yet');
      return;
    }

    try {
      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM, // Changed from TOP
        backgroundColor: color,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        margin:
            const EdgeInsets.only(left: 16, right: 16, bottom: 16), // Bottom only
        borderRadius: 12,
        isDismissible: true,
        dismissDirection: DismissDirection.down,
        icon: const Icon(
          Icons.error_outline,
          color: Colors.white,
          size: 28,
        ),
      );
    } catch (e) {
      debugPrint('⚠️ Failed to show error snackbar: $e');
    }
  }

  /// Log error for debugging
  void _logError(dynamic error, String message) {
    print('=== ERROR LOG ===');
    print('Title: ${_getErrorTitle(error)}');
    print('Message: $message');
    if (error is DioException) {
      print('Status Code: ${error.response?.statusCode}');
      print('Response Data: ${error.response?.data}');
      print('Request URL: ${error.requestOptions.uri}');
    }
    print('Original Error: $error');
    print('Time: ${DateTime.now()}');
    print('================');
  }

  /// Handle validation errors with detailed dialog
  void handleValidationError(Map<String, dynamic> errors) {
    final messages = <String>[];

    errors.forEach((field, fieldErrors) {
      if (fieldErrors is List) {                                                              
        for (var error in fieldErrors) {
          messages.add('${_capitalizeField(field)}: $error');
        }
      } else {
        messages.add('${_capitalizeField(field)}: $fieldErrors');
      }
    });

    Get.dialog( 
      AlertDialog(
        title: const Text('Validation Errors'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: messages
                .map((msg) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text('• $msg'),
                    ))
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Capitalize field name for better display
  String _capitalizeField(String field) {
    if (field.isEmpty) return field;
    return field[0].toUpperCase() + field.substring(1).replaceAll('_', ' ');
  }
}
