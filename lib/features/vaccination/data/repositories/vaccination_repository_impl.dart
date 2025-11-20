import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/vaccination_category_entity.dart';
import '../../domain/entities/vaccination_series_entity.dart';
import '../../domain/entities/medical_sheet_entity.dart';
import '../../domain/repositories/vaccination_repository.dart';
import '../services/vaccination_api_service.dart';

/// Vaccination Repository Implementation
///
/// Implements the abstract VaccinationRepository from domain layer
/// Handles data operations with error handling and type conversion
class VaccinationRepositoryImpl implements VaccinationRepository {
  final VaccinationApiService apiService;

  VaccinationRepositoryImpl({required this.apiService});

  @override
  Future<Either<Failure, List<VaccinationCategoryEntity>>> getEligibleVaccines(
    String petId,
  ) async {
    try {
      final models = await apiService.getEligibleVaccines(petId);
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, VaccinationSeriesEntity>> createVaccineSeries({
    required String petId,
    required String vaccineType,
    required List<Map<String, dynamic>> doses,
  }) async {
    try {
      final model = await apiService.createVaccineSeries(
        petId: petId,
        vaccineType: vaccineType,
        doses: doses,
      );
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, VaccinationSeriesEntity>> markDoseComplete({
    required String seriesId,
    required int doseNumber,
    required DateTime administeredAt,
    String? administeredBy,
    String? batchNumber,
    String? notes,
  }) async {
    try {
      final model = await apiService.markDoseComplete(
        seriesId: seriesId,
        doseNumber: doseNumber,
        administeredAt: administeredAt,
        administeredBy: administeredBy,
        batchNumber: batchNumber,
        notes: notes,
      );
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, VaccinationSeriesEntity>> markAnnualBoosterComplete({
    required String seriesId,
    required DateTime completedDate,
    String? administeredBy,
    String? batchNumber,
    String? notes,
  }) async {
    try {
      final model = await apiService.markAnnualBoosterComplete(
        seriesId: seriesId,
        completedDate: completedDate,
        administeredBy: administeredBy,
        batchNumber: batchNumber,
        notes: notes,
      );
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteVaccinationSeries({
    required String seriesId,
  }) async {
    try {
      await apiService.deleteVaccinationSeries(seriesId: seriesId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, MedicalSheetEntity>> getMedicalSheet(
    String petId,
  ) async {
    try {
      final model = await apiService.getMedicalSheet(petId);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  /// Handle Dio errors and convert to Failure types
  Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure('Connection timeout');

      case DioExceptionType.connectionError:
        return const NetworkFailure('No internet connection');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] ??
            error.response?.data?['error'] ??
            'Server error';

        if (statusCode != null) {
          if (statusCode >= 500) {
            return ServerFailure('Server error ($statusCode): $message');
          } else if (statusCode >= 400) {
            return ServerFailure('Client error ($statusCode): $message');
          }
        }
        return ServerFailure(message);

      case DioExceptionType.cancel:
        return const NetworkFailure('Request cancelled');

      default:
        return ServerFailure('Unexpected error: ${error.message}');
    }
  }
}
