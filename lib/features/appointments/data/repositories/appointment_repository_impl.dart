import 'package:dartz/dartz.dart';
import 'package:petapp/core/errors/exceptions.dart';
import 'package:petapp/core/errors/failures.dart';
import 'package:petapp/features/appointments/data/datasources/appointment_remote_datasource.dart';
import 'package:petapp/features/appointments/data/models/appointment_model.dart';
import 'package:petapp/features/appointments/domain/entities/appointment_entity.dart';
import 'package:petapp/features/appointments/domain/repositories/appointment_repository.dart';

/// Implementation of AppointmentRepository
///
/// Handles data operations and converts between data layer (models) and domain layer (entities)
/// Catches exceptions from datasource and converts them to failures
class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentRemoteDataSource remoteDataSource;

  AppointmentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Map<String, dynamic>>> getAppointments({
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    try {
      final result = await remoteDataSource.getAppointments(
        page: page,
        limit: limit,
        status: status,
      );

      final appointmentsData = result['data'] as List;
      final appointments = appointmentsData
          .map((json) => AppointmentModel.fromJson(json as Map<String, dynamic>)
              .toEntity())
          .toList();

      return Right({
        'data': appointments,
        'hasNextPage': result['hasNextPage'],
      });
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on AppointmentException catch (e) {
      return Left(AppointmentFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<AppointmentEntity>>> getFilteredAppointments(
    String filter,
  ) async {
    try {
      // Convert filter to status
      String? status;
      if (filter.toLowerCase() != 'all') {
        status = filter.toUpperCase();
      }

      final result = await remoteDataSource.getAppointments(
        page: 1,
        limit: 50,
        status: status,
      );

      final appointmentsData = result['data'] as List;
      final appointments = appointmentsData
          .map((json) => AppointmentModel.fromJson(json as Map<String, dynamic>)
              .toEntity())
          .toList();

      return Right(appointments);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on AppointmentException catch (e) {
      return Left(AppointmentFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, AppointmentEntity?>> getAppointmentDetails(
    String appointmentId,
  ) async {
    try {
      final model = await remoteDataSource.getAppointmentDetails(appointmentId);
      if (model == null) {
        return const Right(null);
      }
      final appointmentModel = AppointmentModel.fromJson(model);
      return Right(appointmentModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on AppointmentException catch (e) {
      return Left(AppointmentFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, AppointmentEntity>> createAppointment({
    required String slotId,
    required DateTime appointmentDate,
    String? petId,
    String? reasonForVisit,
    int? pointsToUse,
    String? couponCode,
  }) async {
    try {
      final result = await remoteDataSource.createAppointment(
        slotId: slotId,
        appointmentDate: appointmentDate,
        petId: petId,
        reasonForVisit: reasonForVisit,
        pointsToUse: pointsToUse,
        couponCode: couponCode,
      );

      final appointmentModel = AppointmentModel.fromJson(result);
      return Right(appointmentModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, errors: e.errors));
    } on AppointmentException catch (e) {
      return Left(AppointmentFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> cancelAppointment(String appointmentId) async {
    try {
      final result = await remoteDataSource.cancelAppointment(appointmentId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on AppointmentException catch (e) {
      return Left(AppointmentFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> completeAppointment(
    String appointmentId,
    String completionHash,
  ) async {
    try {
      final result = await remoteDataSource.completeAppointment(
        appointmentId,
        completionHash,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on AppointmentException catch (e) {
      return Left(AppointmentFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> completeAppointmentByQr({
    required String appointmentId,
    required String qrCode,
  }) async {
    try {
      await remoteDataSource.completeAppointmentByQr(
        appointmentId: appointmentId,
        qrCode: qrCode,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, errors: e.errors));
    } on AppointmentException catch (e) {
      return Left(AppointmentFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> submitReview({
    required String appointmentId,
    required int rating,
    String? comment,
  }) async {
    try {
      await remoteDataSource.submitReview(
        appointmentId: appointmentId,
        rating: rating,
        comment: comment,
      );
      return const Right(true);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, errors: e.errors));
    } on AppointmentException catch (e) {
      return Left(AppointmentFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> validateCoupon(
    String couponCode,
  ) async {
    try {
      final result = await remoteDataSource.validateCoupon(couponCode);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, errors: e.errors));
    } catch (e) {
      return Left(UnexpectedFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> validatePoints(
      int points) async {
    try {
      final result = await remoteDataSource.validatePoints(points);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, errors: e.errors));
    } catch (e) {
      return Left(UnexpectedFailure('Unexpected error: ${e.toString()}'));
    }
  }
}
