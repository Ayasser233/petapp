import 'package:dartz/dartz.dart';
import '../entities/vaccination_category_entity.dart';
import '../entities/vaccination_series_entity.dart';
import '../entities/medical_sheet_entity.dart';

/// Abstract Vaccination Repository
/// Defines the contract for vaccination data operations
abstract class VaccinationRepository {
  /// Get eligible vaccine categories/types for a pet
  /// Backend endpoint: GET /vaccination/eligible-categories?petId=X
  ///
  /// [petId] The ID of the pet
  /// Returns Either a Failure or List of VaccinationCategoryEntity
  Future<Either<Failure, List<VaccinationCategoryEntity>>> getEligibleVaccines(
    String petId,
  );

  /// Create a new vaccination series
  /// Backend endpoint: POST /vaccination/series
  ///
  /// [petId] The ID of the pet
  /// [vaccineType] The vaccine type (e.g., DOG_PENTAVALENT, WORMS_DOG, etc.)
  /// [doses] List of administered doses with number and administeredAt date
  /// Returns Either a Failure or the created VaccinationSeriesEntity
  Future<Either<Failure, VaccinationSeriesEntity>> createVaccineSeries({
    required String petId,
    required String vaccineType,
    required List<Map<String, dynamic>> doses,
  });

  /// Mark a dose in a series as complete
  /// Backend endpoint: POST /vaccination/series/:id/mark-dose-complete
  ///
  /// [seriesId] The ID of the vaccination series
  /// [doseNumber] The dose number to mark complete (1, 2, 3, etc.)
  /// [administeredAt] When the dose was administered (YYYY-MM-DD)
  /// [administeredBy] Optional: Who administered the dose
  /// [batchNumber] Optional: The batch number of the vaccine
  /// [notes] Optional: Additional notes
  /// Returns Either a Failure or the updated VaccinationSeriesEntity
  Future<Either<Failure, VaccinationSeriesEntity>> markDoseComplete({
    required String seriesId,
    required int doseNumber,
    required DateTime administeredAt,
    String? administeredBy,
    String? batchNumber,
    String? notes,
  });

  /// Mark an annual booster as complete
  /// Backend endpoint: POST /vaccination/series/:id/mark-annual-booster-complete
  ///
  /// [seriesId] The ID of the vaccination series
  /// [completedDate] When the booster was completed
  /// [administeredBy] Optional: Who administered the booster
  /// [batchNumber] Optional: The batch number of the vaccine
  /// [notes] Optional: Additional notes
  /// Returns Either a Failure or the updated VaccinationSeriesEntity
  Future<Either<Failure, VaccinationSeriesEntity>> markAnnualBoosterComplete({
    required String seriesId,
    required DateTime completedDate,
    String? administeredBy,
    String? batchNumber,
    String? notes,
  });

  /// Get the complete medical sheet for a pet
  /// Backend endpoint: GET /vaccination/schedules/pet/:id/medical-sheet
  /// Aggregates all vaccination series and schedules for the pet
  ///
  /// [petId] The ID of the pet
  /// Returns Either a Failure or the MedicalSheetEntity
  Future<Either<Failure, MedicalSheetEntity>> getMedicalSheet(
    String petId,
  );
}

/// Base Failure class
abstract class Failure {
  final String message;
  const Failure(this.message);
}

/// Server Failure
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Network Failure
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Cache Failure
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}
