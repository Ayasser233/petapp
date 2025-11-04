import 'package:dartz/dartz.dart';
import '../entities/vaccination_series_entity.dart';
import '../repositories/vaccination_repository.dart';

/// Mark Dose Complete UseCase
///
/// Marks a dose in a vaccination series as complete
/// Backend endpoint: POST /vaccination/series/:id/mark-dose-complete
class MarkDoseCompleteUsecase {
  final VaccinationRepository repository;

  MarkDoseCompleteUsecase(this.repository);

  /// Execute the use case
  ///
  /// [seriesId] The ID of the vaccination series
  /// [doseNumber] The dose number to mark complete (1, 2, 3, etc.)
  /// [administeredAt] When the dose was administered
  /// [administeredBy] Optional: Who administered the dose
  /// [batchNumber] Optional: The batch number of the vaccine
  /// [notes] Optional: Additional notes
  /// Returns Either a Failure or the updated VaccinationSeriesEntity
  Future<Either<Failure, VaccinationSeriesEntity>> call({
    required String seriesId,
    required int doseNumber,
    required DateTime administeredAt,
    String? administeredBy,
    String? batchNumber,
    String? notes,
  }) {
    return repository.markDoseComplete(
      seriesId: seriesId,
      doseNumber: doseNumber,
      administeredAt: administeredAt,
      administeredBy: administeredBy,
      batchNumber: batchNumber,
      notes: notes,
    );
  }
}
