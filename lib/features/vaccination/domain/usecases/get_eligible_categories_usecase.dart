import 'package:dartz/dartz.dart';
import '../entities/vaccination_category_entity.dart';
import '../repositories/vaccination_repository.dart';

/// Get Eligible Vaccine Categories UseCase
///
/// Fetches the list of vaccine categories eligible for a specific pet
/// Maps to: GET /vaccination/eligible-categories?petId=X
class GetEligibleCategoriesUsecase {
  final VaccinationRepository repository;

  GetEligibleCategoriesUsecase(this.repository);

  /// Execute the use case
  ///
  /// [petId] The ID of the pet to get eligible vaccines for
  /// Returns Either a Failure or List of VaccinationCategoryEntity
  Future<Either<Failure, List<VaccinationCategoryEntity>>> call(String petId) {
    return repository.getEligibleVaccines(petId);
  }
}
