/// Custom exceptions for the application
///
/// These exceptions are thrown by datasources and repositories
/// to indicate specific error scenarios

/// Exception thrown when there's a server-side error
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}

/// Exception thrown when there's a network connectivity issue
class NetworkException implements Exception {
  final String message;

  NetworkException([this.message = 'No internet connection']);

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception thrown when cached data is not available
class CacheException implements Exception {
  final String message;

  CacheException([this.message = 'Cache error']);

  @override
  String toString() => 'CacheException: $message';
}

/// Exception thrown when authentication fails
class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException([this.message = 'Unauthorized access']);

  @override
  String toString() => 'UnauthorizedException: $message';
}

/// Exception thrown when requested resource is not found
class NotFoundException implements Exception {
  final String message;

  NotFoundException([this.message = 'Resource not found']);

  @override
  String toString() => 'NotFoundException: $message';
}

/// Exception thrown when request validation fails
class ValidationException implements Exception {
  final String message;
  final Map<String, dynamic>? errors;

  ValidationException({
    required this.message,
    this.errors,
  });

  @override
  String toString() => 'ValidationException: $message ${errors ?? ''}';
}

/// Exception thrown when a timeout occurs
class TimeoutException implements Exception {
  final String message;

  TimeoutException([this.message = 'Request timeout']);

  @override
  String toString() => 'TimeoutException: $message';
}

/// Generic exception for appointment-related errors
class AppointmentException implements Exception {
  final String message;

  AppointmentException(this.message);

  @override
  String toString() => 'AppointmentException: $message';
}

/// Generic exception for vet-related errors
class VetException implements Exception {
  final String message;

  VetException(this.message);

  @override
  String toString() => 'VetException: $message';
}

/// Generic exception for pet-related errors
class PetException implements Exception {
  final String message;

  PetException(this.message);

  @override
  String toString() => 'PetException: $message';
}

/// Generic exception for profile-related errors
class ProfileException implements Exception {
  final String message;

  ProfileException(this.message);

  @override
  String toString() => 'ProfileException: $message';
}
