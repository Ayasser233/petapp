import 'package:dartz/dartz.dart';
import '../repositories/vaccination_repository.dart';

/// Use case for deleting a vaccination series
///
/// Deletes a complete vaccination series including all its doses
/// and related data from the system.
class DeleteVaccinationSeriesUsecase {
  final VaccinationRepository repository;

  DeleteVaccinationSeriesUsecase(this.repository);

  /// Execute the delete vaccination series use case
  ///
  /// [seriesId] The ID of the vaccination series to delete
  ///
  /// Returns Either:
  /// - Left(Failure) if the operation fails
  /// - Right(void) if the operation succeeds
  Future<Either<Failure, void>> call({
    required String seriesId,
  }) async {
    return repository.deleteVaccinationSeries(seriesId: seriesId);
  }
}

