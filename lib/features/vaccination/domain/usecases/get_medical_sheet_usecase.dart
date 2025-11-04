import 'package:dartz/dartz.dart';
import '../entities/medical_sheet_entity.dart';
import '../repositories/vaccination_repository.dart';

/// Get Medical Sheet UseCase
///
/// Fetches the complete vaccination medical sheet for a pet
/// Maps to: GET /vaccination/schedules/pet/X/medical-sheet
class GetMedicalSheetUsecase {
  final VaccinationRepository repository;

  GetMedicalSheetUsecase(this.repository);

  /// Execute the use case
  ///
  /// [petId] The ID of the pet to get the medical sheet for
  /// Returns Either a Failure or the MedicalSheetEntity
  Future<Either<Failure, MedicalSheetEntity>> call(String petId) {
    return repository.getMedicalSheet(petId);
  }
}
