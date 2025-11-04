import 'package:dartz/dartz.dart';
import '../entities/vaccination_series_entity.dart';
import '../repositories/vaccination_repository.dart';

/// Mark Annual Booster Complete UseCase
///
/// Marks an annual booster as complete in a vaccination series
/// Backend endpoint: POST /vaccination/series/:id/mark-annual-booster-complete
class MarkAnnualBoosterCompleteUsecase {
  final VaccinationRepository repository;

  MarkAnnualBoosterCompleteUsecase(this.repository);

  /// Execute the use case
  ///
  /// [seriesId] The ID of the vaccination series
  /// [completedDate] When the booster was completed
  /// [administeredBy] Optional: Who administered the booster
  /// [batchNumber] Optional: The batch number of the vaccine
  /// [notes] Optional: Additional notes
  /// Returns Either a Failure or the updated VaccinationSeriesEntity
  Future<Either<Failure, VaccinationSeriesEntity>> call({
    required String seriesId,
    required DateTime completedDate,
    String? administeredBy,
    String? batchNumber,
    String? notes,
  }) {
    return repository.markAnnualBoosterComplete(
      seriesId: seriesId,
      completedDate: completedDate,
      administeredBy: administeredBy,
      batchNumber: batchNumber,
      notes: notes,
    );
  }
}
