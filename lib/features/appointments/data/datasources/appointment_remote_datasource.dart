import 'package:dio/dio.dart';
import 'package:petapp/core/errors/exceptions.dart';
import 'package:petapp/core/services/api_client.dart';
import 'package:petapp/core/utils/api_constants.dart';

/// Remote data source for appointment operations
///
/// Handles all API calls related to appointments
/// Throws exceptions on errors (converted to failures in repository)
class AppointmentRemoteDataSource {
  final ApiClient apiClient;

  AppointmentRemoteDataSource(this.apiClient);

  /// Fetch appointments from API
  Future<Map<String, dynamic>> getAppointments({
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    try {
      final queryParams = {
        'page': page,
        'limit': limit,
        if (status != null) 'status': status,
      };

      final response = await apiClient.get(
        ApiConstants.appointmentsEndpoint,
        queryParameters: queryParams,
      );

      if (response.data['success'] == true) {
        return {
          'data': response.data['data'] ?? [],
          'hasNextPage': response.data['hasNextPage'] ?? false,
        };
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to load appointments',
        );
      }
    } catch (e) {
      if (e is ServerException || e is UnauthorizedException) rethrow;
      _throwProperException(e);
    }
  }

  /// Get specific appointment details
  Future<Map<String, dynamic>?> getAppointmentDetails(
    String appointmentId,
  ) async {
    try {
      final response = await apiClient.get(
        ApiConstants.appointmentDetailEndpoint(appointmentId),
      );

      if (response.data['success'] == true && response.data['data'] != null) {
        return response.data['data'] as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      if (e is ServerException || e is UnauthorizedException) rethrow;
      _throwProperException(e);
    }
  }

  /// Create new appointment
  Future<Map<String, dynamic>> createAppointment({
    required String slotId,
    required DateTime appointmentDate,
    String? petId,
    String? reasonForVisit,
    int? pointsToRedeem,
    String? couponCode,
  }) async {
    try {
      // Format date as YYYY-MM-DD
      final dateOnly =
          '${appointmentDate.year}-${appointmentDate.month.toString().padLeft(2, '0')}-${appointmentDate.day.toString().padLeft(2, '0')}';

      final requestBody = {
        'slotId': slotId,
        'appointmentDate': dateOnly,
        if (petId != null) 'petId': petId,
        if (reasonForVisit != null) 'reasonForVisit': reasonForVisit,
        if (pointsToRedeem != null) 'pointsToRedeem': pointsToRedeem,
        if (couponCode != null) 'couponCode': couponCode,
      };

      final response = await apiClient.post(
        ApiConstants.appointmentsEndpoint,
        data: requestBody,
      );

      if (response.data['success'] == true && response.data['data'] != null) {
        return response.data['data'] as Map<String, dynamic>;
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to create appointment',
        );
      }
    } catch (e) {
      if (e is ServerException || e is UnauthorizedException) rethrow;
      _throwProperException(e);
    }
  }

  /// Cancel an appointment
  Future<bool> cancelAppointment(String appointmentId) async {
    try {
      final response = await apiClient.patch(
        ApiConstants.appointmentCancelEndpoint(appointmentId),
      );

      if (response.data['success'] == true) {
        return true;
      } else {
        final errorMessage =
            response.data['message'] ?? 'Cannot cancel appointment';
        throw AppointmentException(errorMessage);
      }
    } catch (e) {
      if (e is AppointmentException) rethrow;
      throw AppointmentException(_extractErrorMessage(e));
    }
  }

  /// Complete an appointment
  Future<bool> completeAppointment(
    String appointmentId,
    String completionHash,
  ) async {
    try {
      final requestBody = {
        'completionHash': completionHash,
      };

      final response = await apiClient.post(
        ApiConstants.appointmentCompleteEndpoint(appointmentId),
        data: requestBody,
      );

      if (response.data['success'] == true) {
        return true;
      }
      return false;
    } catch (e) {
      throw ServerException(message: _extractErrorMessage(e));
    }
  }

  /// Complete appointment by scanning vet's QR code
  Future<void> completeAppointmentByQr({
    required String appointmentId,
    required String qrCode,
  }) async {
    try {
      final requestBody = {
        'completionHash': qrCode, // API expects 'completionHash', not 'qrCode'
      };

      final response = await apiClient.post(ApiConstants.appointmentCompleteEndpoint(appointmentId),
        data: requestBody,
      );

      if (response.data['success'] == true) {
        return;
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to complete appointment',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: _extractErrorMessage(e));
    }
  }

  /// Submit review for appointment
  Future<bool> submitReview({
    required String appointmentId,
    required int rating,
    String? comment,
  }) async {
    try {
      if (rating < 1 || rating > 5) {
        throw ValidationException(message: 'Rating must be between 1 and 5');
      }

      final requestBody = {
        'rating': rating,
        if (comment != null && comment.isNotEmpty) 'reviewComment': comment,
      };

      final response = await apiClient.patch(
        ApiConstants.appointmentReviewEndpoint(appointmentId),
        data: requestBody,
      );

      if (response.data['success'] == true) {
        return true;
      }
      return false;
    } catch (e) {
      if (e is ValidationException) rethrow;
      throw ServerException(message: _extractErrorMessage(e));
    }
  }

  /// Validate points redemption for a specific vet
  Future<Map<String, dynamic>> validatePointsRedemption({
    required String vetId,
    required int pointsToRedeem,
  }) async {
    try {
      final response = await apiClient.post(
        ApiConstants.pointsRedeemValidateEndpoint,
        data: {
          'vetId': vetId,
          'pointsToRedeem': pointsToRedeem,
        },
      );

      if (response.data['success'] == true && response.data['data'] != null) {
        return response.data['data'] as Map<String, dynamic>;
      } else {
        throw ValidationException(
          message: response.data['message'] ?? 'Failed to validate points redemption',
          errors: null,
        );
      }
    } catch (e) {
      if (e is ValidationException) rethrow;
      throw ServerException(message: _extractErrorMessage(e));
    }
  }


  /// Throw the correct exception based on the error type
  Never _throwProperException(dynamic error) {
    if (error is DioException && error.response?.statusCode == 401) {
      throw UnauthorizedException('Unauthorized');
    }
    throw ServerException(message: _extractErrorMessage(error));
  }

  /// Extract error message from DioException
  String _extractErrorMessage(dynamic error) {
    if (error is DioException) {
      final response = error.response;
      if (response?.data != null && response!.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;

        // Try to get message from API response
        String? message = data['message'];

        // Check nested errorDetails
        if (data['errorDetails'] is Map<String, dynamic>) {
          final errorDetails = data['errorDetails'] as Map<String, dynamic>;

          // Handle validation errors with array format
          if (errorDetails['message'] is List) {
            final messages = errorDetails['message'] as List;
            if (messages.isNotEmpty) {
              if (messages.first is Map) {
                final firstError = messages.first as Map;
                return firstError.values.first.toString();
              }
              return messages.first.toString();
            }
          }

          // Handle simple message
          if (errorDetails['message'] != null) {
            message = errorDetails['message'].toString();
          }
        }

        if (message != null && message.isNotEmpty) {
          return message;
        }
      }

      // Fallback to error type message
      if (error.type == DioExceptionType.connectionTimeout) {
        return 'Connection timeout. Please try again.';
      } else if (error.type == DioExceptionType.connectionError) {
        return 'No internet connection. Please check your network.';
      } else if (error.response?.statusCode != null) {
        return 'Error ${error.response!.statusCode}: ${error.response!.statusMessage ?? "Unknown error"}';
      }
    }

    return error.toString();
  }
}
