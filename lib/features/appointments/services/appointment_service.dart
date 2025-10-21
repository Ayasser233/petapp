import 'package:get/get.dart';
import 'package:petapp/core/services/api_client.dart';
import 'package:petapp/core/utils/api_constants.dart';
import 'package:petapp/features/appointments/models/appointment_model.dart';

/// Service class for managing appointments
///
/// Handles all appointment-related API calls including:
/// - Fetching appointments list
/// - Creating new appointments
/// - Cancelling appointments
/// - Submitting reviews
/// - Validating coupons and points
class AppointmentService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  /// Get all appointments for the current user
  ///
  /// [page] - Page number for pagination (default: 1)
  /// [limit] - Number of items per page (default: 10)
  /// [status] - Optional filter by status (PENDING, CONFIRMED, COMPLETED, CANCELLED)
  ///
  /// Returns a Map containing:
  /// - 'appointments': List<AppointmentModel>
  /// - 'hasNextPage': bool
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

      final response = await _apiClient.get(
        ApiConstants.appointmentsEndpoint,
        queryParameters: queryParams,
      );

      if (response.data['success'] == true) {
        final List<dynamic> appointmentsJson = response.data['data'] ?? [];
        final appointments = appointmentsJson
            .map((json) => AppointmentModel.fromJson(json))
            .toList();

        return {
          'appointments': appointments,
          'hasNextPage': response.data['hasNextPage'] ?? false,
        };
      } else {
        throw AppointmentServiceException(
          response.data['message'] ?? 'Failed to load appointments',
        );
      }
    } catch (e) {
      print('❌ Error fetching appointments: $e');
      rethrow;
    }
  }

  /// Get appointments filtered by status
  Future<List<AppointmentModel>> getFilteredAppointments(String filter) async {
    try {
      String? statusFilter;

      switch (filter.toLowerCase()) {
        case 'pending':
          statusFilter = 'PENDING';
          break;
        case 'confirmed':
          statusFilter = 'CONFIRMED';
          break;
        case 'completed':
          statusFilter = 'COMPLETED';
          break;
        case 'cancelled':
          statusFilter = 'CANCELLED';
          break;
        default:
          statusFilter = null; // Get all
      }

      final result = await getAppointments(status: statusFilter);
      return result['appointments'] as List<AppointmentModel>;
    } catch (e) {
      print('Error filtering appointments: $e');
      return [];
    }
  }

  /// Get a specific appointment by ID
  ///
  /// [appointmentId] - The ID of the appointment to fetch
  /// Returns AppointmentModel if found, null otherwise
  Future<AppointmentModel?> getAppointmentDetails(String appointmentId) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.appointmentDetailEndpoint(appointmentId),
      );

      if (response.data['success'] == true && response.data['data'] != null) {
        return AppointmentModel.fromJson(response.data['data']);
      }
      return null;
    } catch (e) {
      print('❌ Error fetching appointment details: $e');
      rethrow;
    }
  }

  /// Create a new appointment
  ///
  /// Required parameters:
  /// - [slotId] - ID of the selected time slot
  /// - [appointmentDate] - Date of the appointment (DateTime)
  /// - [petId] - ID of the pet for the appointment
  ///
  /// Optional parameters:
  /// - [reasonForVisit] - Description of why booking the appointment
  /// - [pointsToUse] - Number of loyalty points to apply
  /// - [couponCode] - Coupon code for discount
  ///
  /// Returns the created AppointmentModel
  Future<AppointmentModel> createAppointment({
    required String slotId,
    required DateTime appointmentDate,
    required String petId,
    String? reasonForVisit,
    int? pointsToUse,
    String? couponCode,
  }) async {
    try {
      // Format date as YYYY-MM-DD (date only, no time)
      final dateOnly =
          '${appointmentDate.year}-${appointmentDate.month.toString().padLeft(2, '0')}-${appointmentDate.day.toString().padLeft(2, '0')}';

      final requestBody = {
        'slotId': slotId,
        'appointmentDate': dateOnly,
        'petId': petId,
        if (reasonForVisit != null) 'reasonForVisit': reasonForVisit,
        if (pointsToUse != null) 'pointsToUse': pointsToUse,
        if (couponCode != null) 'couponCode': couponCode,
      };

      print('📤 Creating appointment: $requestBody');

      final response = await _apiClient.post(
        ApiConstants.appointmentsEndpoint,
        data: requestBody,
      );

      if (response.data['success'] == true && response.data['data'] != null) {
        print('✅ Appointment created successfully');
        return AppointmentModel.fromJson(response.data['data']);
      } else {
        throw Exception(
            response.data['message'] ?? 'Failed to create appointment');
      }
    } catch (e) {
      print('❌ Error creating appointment: $e');
      rethrow;
    }
  }

  /// Cancel an appointment
  ///
  /// [appointmentId] - ID of the appointment to cancel
  /// Returns true if cancellation was successful
  Future<bool> cancelAppointment(String appointmentId) async {
    try {
      print('📤 Cancelling appointment: $appointmentId');

      final response = await _apiClient.patch(
        ApiConstants.appointmentCancelEndpoint(appointmentId),
      );

      final success = response.data['success'] == true;
      if (success) {
        print('✅ Appointment cancelled successfully');
      }
      return success;
    } catch (e) {
      print('❌ Error cancelling appointment: $e');
      rethrow;
    }
  }

  /// Complete an appointment (admin/vet action)
  ///
  /// [appointmentId] - ID of the appointment to mark as completed
  /// Returns true if successful
  Future<bool> completeAppointment(String appointmentId) async {
    try {
      print('📤 Completing appointment: $appointmentId');

      final response = await _apiClient.patch(
        ApiConstants.appointmentCompleteEndpoint(appointmentId),
      );

      final success = response.data['success'] == true;
      if (success) {
        print('✅ Appointment completed successfully');
      }
      return success;
    } catch (e) {
      print('❌ Error completing appointment: $e');
      rethrow;
    }
  }

  /// Submit a review for a completed appointment
  ///
  /// [appointmentId] - ID of the appointment to review
  /// [rating] - Rating from 1-5
  /// [comment] - Optional review comment
  ///
  /// Returns true if review was submitted successfully
  Future<bool> submitReview({
    required String appointmentId,
    required int rating,
    String? comment,
  }) async {
    try {
      if (rating < 1 || rating > 5) {
        throw Exception('Rating must be between 1 and 5');
      }

      final requestBody = {
        'rating': rating,
        if (comment != null && comment.isNotEmpty) 'comment': comment,
      };

      print(
          '📤 Submitting review for appointment $appointmentId: $requestBody');

      final response = await _apiClient.post(
        ApiConstants.appointmentReviewEndpoint(appointmentId),
        data: requestBody,
      );

      final success = response.data['success'] == true;
      if (success) {
        print('✅ Review submitted successfully');
      }
      return success;
    } catch (e) {
      print('❌ Error submitting review: $e');
      rethrow;
    }
  }

  /// Validate coupon code for discount
  ///
  /// [couponCode] - The coupon code to validate
  ///
  /// Returns a Map with:
  /// - 'valid': bool
  /// - 'discount': double
  /// - 'message': String
  Future<Map<String, dynamic>> validateCoupon(String couponCode) async {
    try {
      print('📤 Validating coupon: $couponCode');

      final response = await _apiClient.post(
        ApiConstants.pointsValidateEndpoint,
        data: {'couponCode': couponCode},
      );

      if (response.data['success'] == true) {
        print('✅ Coupon validated successfully');
        return {
          'valid': true,
          'discount': (response.data['data']['discount'] ?? 0).toDouble(),
          'message': response.data['message'] ?? 'Coupon is valid',
        };
      } else {
        return {
          'valid': false,
          'discount': 0.0,
          'message': response.data['message'] ?? 'Invalid coupon',
        };
      }
    } catch (e) {
      print('❌ Error validating coupon: $e');
      return {
        'valid': false,
        'discount': 0.0,
        'message': 'Error validating coupon',
      };
    }
  }

  /// Validate points usage for discount
  ///
  /// [points] - Number of points to use
  ///
  /// Returns a Map with:
  /// - 'valid': bool
  /// - 'discount': double
  /// - 'availablePoints': int
  /// - 'message': String
  Future<Map<String, dynamic>> validatePoints(int points) async {
    try {
      print('📤 Validating points: $points');

      final response = await _apiClient.post(
        ApiConstants.pointsValidateEndpoint,
        data: {'points': points},
      );

      if (response.data['success'] == true) {
        print('✅ Points validated successfully');
        return {
          'valid': true,
          'discount': (response.data['data']['discount'] ?? 0).toDouble(),
          'availablePoints': response.data['data']['availablePoints'] ?? 0,
          'message': response.data['message'] ?? 'Points are valid',
        };
      } else {
        return {
          'valid': false,
          'discount': 0.0,
          'availablePoints': 0,
          'message': response.data['message'] ?? 'Invalid points',
        };
      }
    } catch (e) {
      print('❌ Error validating points: $e');
      return {
        'valid': false,
        'discount': 0.0,
        'availablePoints': 0,
        'message': 'Error validating points',
      };
    }
  }
}

/// Custom exception for appointment service errors
class AppointmentServiceException implements Exception {
  final String message;
  AppointmentServiceException(this.message);

  @override
  String toString() => 'AppointmentServiceException: $message';
}
