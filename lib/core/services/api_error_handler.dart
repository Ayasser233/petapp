import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiErrorHandler {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  bool _isOfflineBannerShown = false;
  
  ApiErrorHandler({required this.scaffoldMessengerKey});
  
  // Main error handling method
  dynamic handleError(dynamic error) {
    // Log the error for debugging
    debugPrint('API Error: $error');

    if (error is DioException) {
      _handleOfflineState(error);
      return _handleDioError(error);
    } else if (error is SocketException) {
      _showOfflineBanner();
      return 'No internet connection. Please check your network.';
    } else if (error is TimeoutException) {
      return 'Request timed out. Please try again.';
    } else {
      return 'An unexpected error occurred. Please try again later.';
    }
  }
  
  // Check if error is due to offline state
  void _handleOfflineState(DioException error) {
    if (error.type == DioExceptionType.connectionError || 
        error.type == DioExceptionType.connectionTimeout) {
      _showOfflineBanner();
    }
  }

  // Handle Dio specific errors
  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please try again.';

      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network.';

      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);

      case DioExceptionType.cancel:
        return 'Request was cancelled.';

      case DioExceptionType.badCertificate:
        return 'There\'s a problem with the server\'s security certificate.';

      default:
        return 'An unexpected error occurred. Please try again later.';
    }
  }

  // Handle different HTTP status codes
  String _handleBadResponse(Response? response) {
    if (response == null) return 'Server error with no response data.';

    switch (response.statusCode) {
      case 400:
        return _extractErrorMessage(response.data) ?? 'Invalid request.';
      case 401:
        return 'Your session has expired. Please login again.';
      case 403:
        return 'You don\'t have permission to access this resource.';
      case 404:
        return 'The requested resource was not found.';
      case 409:
        return 'Conflict with the current state of the resource.';
      case 422:
        return _extractErrorMessage(response.data) ?? 'Validation error.';
      case 500:
      case 501:
      case 502:
      case 503:
        return 'A server error occurred. Please try again later.';
      default:
        return 'Error code: ${response.statusCode}. Please try again later.';
    }
  }

  // Extract error messages from various response formats
  String? _extractErrorMessage(dynamic responseData) {
    try {
      if (responseData is Map) {
        // Check common error message patterns
        if (responseData.containsKey('message')) {
          return responseData['message'];
        } else if (responseData.containsKey('error')) {
          final error = responseData['error'];
          if (error is String) return error;
          if (error is Map && error.containsKey('message')) {
            return error['message'];
          }
        } else if (responseData.containsKey('errors')) {
          final errors = responseData['errors'];
          // Handle array of errors
          if (errors is List && errors.isNotEmpty) {
            return errors.first.toString();
          } 
          // Handle object of errors
          else if (errors is Map && errors.isNotEmpty) {
            return errors.values.first is List 
                ? errors.values.first.first 
                : errors.values.first.toString();
          }
        }
      }
    } catch (e) {
      debugPrint('Error extracting error message: $e');
    }
    return null;
  }
  
  // Show offline banner
  void _showOfflineBanner() {
    // Prevent multiple banners
    if (_isOfflineBannerShown) return;
    _isOfflineBannerShown = true;
    
    scaffoldMessengerKey.currentState?.showMaterialBanner(
      MaterialBanner(
        backgroundColor: Colors.red,
        content: const Text(
          'No internet connection. Please check your network settings.',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              scaffoldMessengerKey.currentState?.hideCurrentMaterialBanner();
              _isOfflineBannerShown = false;
            },
            child: const Text(
              'DISMISS',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}