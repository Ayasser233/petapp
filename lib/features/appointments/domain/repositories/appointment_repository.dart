import 'package:dartz/dartz.dart';
import 'package:petapp/core/errors/failures.dart';
import 'package:petapp/features/appointments/domain/entities/appointment_entity.dart';

/// Abstract repository interface for appointment operations
///
/// This defines the contract for appointment data operations
/// Implementation is in the data layer
abstract class AppointmentRepository {
  /// Get appointments with optional pagination and filtering
  ///
  /// [page] - Page number (default: 1)
  /// [limit] - Items per page (default: 10)
  /// [status] - Filter by status (PENDING, CONFIRMED, COMPLETED, CANCELLED)
  ///
  /// Returns Either<Failure, Map> containing:
  /// - 'appointments': List<AppointmentEntity>
  /// - 'hasNextPage': bool
  Future<Either<Failure, Map<String, dynamic>>> getAppointments({
    int page = 1,
    int limit = 10,
    String? status,
  });

  /// Get appointments filtered by status
  ///
  /// [filter] - Filter string (all, pending, confirmed, completed, cancelled)
  /// Returns List of AppointmentEntity
  Future<Either<Failure, List<AppointmentEntity>>> getFilteredAppointments(
    String filter,
  );

  /// Get a specific appointment by ID
  ///
  /// [appointmentId] - The appointment ID
  /// Returns AppointmentEntity or null if not found
  Future<Either<Failure, AppointmentEntity?>> getAppointmentDetails(
    String appointmentId,
  );

  /// Create a new appointment
  ///
  /// [slotId] - Time slot ID
  /// [appointmentDate] - Date of appointment
  /// [petId] - Pet ID (optional)
  /// [reasonForVisit] - Reason for visit
  /// [pointsToUse] - Loyalty points to use
  /// [couponCode] - Discount coupon code
  ///
  /// Returns created AppointmentEntity
  Future<Either<Failure, AppointmentEntity>> createAppointment({
    required String slotId,
    required DateTime appointmentDate,
    String? petId,
    String? reasonForVisit,
    int? pointsToUse,
    String? couponCode,
  });

  /// Cancel an appointment
  ///
  /// [appointmentId] - The appointment ID to cancel
  /// Returns true if successful
  Future<Either<Failure, bool>> cancelAppointment(String appointmentId);

  /// Complete an appointment (admin/vet action)
  ///
  /// [appointmentId] - The appointment ID to complete
  /// [completionHash] - The completion hash from QR code
  /// Returns true if successful
  Future<Either<Failure, bool>> completeAppointment(
    String appointmentId,
    String completionHash,
  );

  /// Complete an appointment by scanning vet's QR code
  ///
  /// [appointmentId] - The appointment ID to complete
  /// [qrCode] - The QR code scanned from vet
  /// Returns true if successful
  Future<Either<Failure, void>> completeAppointmentByQr({
    required String appointmentId,
    required String qrCode,
  });

  /// Submit a review for an appointment
  ///
  /// [appointmentId] - The appointment ID
  /// [rating] - Rating (1-5)
  /// [comment] - Optional review comment
  ///
  /// Returns true if successful
  Future<Either<Failure, bool>> submitReview({
    required String appointmentId,
    required int rating,
    String? comment,
  });

  /// Validate a coupon code
  ///
  /// [couponCode] - The coupon code to validate
  ///
  /// Returns Map with validation result
  Future<Either<Failure, Map<String, dynamic>>> validateCoupon(
    String couponCode,
  );

  /// Validate points usage
  ///
  /// [points] - Number of points to validate
  ///
  /// Returns Map with validation result
  Future<Either<Failure, Map<String, dynamic>>> validatePoints(int points);
}
