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
  const NetworkFailure([String message = 'No internet connection'])
      : super(message);
}

/// Failure when cached data is not available or invalid
class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache error']) : super(message);
}

/// Failure when authentication fails
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([String message = 'Unauthorized access'])
      : super(message);
}

/// Failure when requested resource is not found
class NotFoundFailure extends Failure {
  const NotFoundFailure([String message = 'Resource not found'])
      : super(message);
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
  const TimeoutFailure([String message = 'Request timeout']) : super(message);
}

/// Generic failure for unexpected errors
class UnexpectedFailure extends Failure {
  const UnexpectedFailure([String message = 'An unexpected error occurred'])
      : super(message);
}

/// Failure specific to appointment operations
class AppointmentFailure extends Failure {
  const AppointmentFailure(String message) : super(message);
}

/// Failure specific to vet operations
class VetFailure extends Failure {
  const VetFailure(String message) : super(message);
}

/// Failure specific to pet operations
class PetFailure extends Failure {
  const PetFailure(String message) : super(message);
}

/// Failure specific to profile operations
class ProfileFailure extends Failure {
  const ProfileFailure(String message) : super(message);
}
