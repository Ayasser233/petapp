import '../repositories/medical_record_repository.dart';

class CreateShareLinkUseCase {
  final MedicalRecordRepository repository;

  CreateShareLinkUseCase(this.repository);

  Future<Map<String, dynamic>> call(String petId) {
    return repository.getShareLink(petId);
  }
}
