import 'package:dartz/dartz.dart';
import '../entities/vaccination_series_entity.dart';
import '../repositories/vaccination_repository.dart';

/// Create Vaccination Series UseCase
///
/// Creates a new vaccination series for a pet
/// Backend endpoint: POST /vaccination/series
class CreateVaccinationSeriesUsecase {
  final VaccinationRepository repository;

  CreateVaccinationSeriesUsecase(this.repository);

  /// Execute the use case
  ///
  /// [petId] The ID of the pet
  /// [vaccineType] The vaccine type (e.g., DOG_PENTAVALENT, WORMS_DOG, etc.)
  /// [doses] List of administered doses with number and administeredAt date
  /// Returns Either a Failure or the created VaccinationSeriesEntity
  Future<Either<Failure, VaccinationSeriesEntity>> call({
    required String petId,
    required String vaccineType,
    required List<Map<String, dynamic>> doses,
  }) {
    return repository.createVaccineSeries(
      petId: petId,
      vaccineType: vaccineType,
      doses: doses,
    );
  }
}
