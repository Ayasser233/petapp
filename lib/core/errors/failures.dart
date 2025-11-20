import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
///
/// Failures represent errors at the domain/presentation level
/// Exceptions are converted to Failures in repositories
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Failure when there's a server-side error
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    required String message,
    this.statusCode,
  }) : super(message);

  @override
  List<Object?> get props => [message, statusCode];
}

/// Failure when there's a network connectivity issue
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

/// Failure when cached data is not available or invalid
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error']);
}

/// Failure when authentication fails
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Unauthorized access']);
}

/// Failure when requested resource is not found
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found']);
}

/// Failure when request validation fails
class ValidationFailure extends Failure {
  final Map<String, dynamic>? errors;

  const ValidationFailure({
    required String message,
    this.errors,
  }) : super(message);

  @override
  List<Object?> get props => [message, errors];
}

/// Failure when a timeout occurs
class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'Request timeout']);
}

/// Generic failure for unexpected errors
class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'An unexpected error occurred']);
}

/// Failure specific to appointment operations
class AppointmentFailure extends Failure {
  const AppointmentFailure(super.message);
}

/// Failure specific to vet operations
class VetFailure extends Failure {
  const VetFailure(super.message);
}

/// Failure specific to pet operations
class PetFailure extends Failure {
  const PetFailure(super.message);
}

/// Failure specific to profile operations
class ProfileFailure extends Failure {
  const ProfileFailure(super.message);
}
