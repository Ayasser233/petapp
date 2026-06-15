import '../repositories/medical_record_repository.dart';
import '../../data/models/medical_record_list_response.dart';
import '../entities/medical_record_entity.dart';

class GetMedicalRecordsUseCase {
  final MedicalRecordRepository repository;

  GetMedicalRecordsUseCase(this.repository);

  Future<MedicalRecordListResponse> call({
    required String petId,
    int page = 1,
    int limit = 10,
    MedicalRecordEventType? eventType,
    MedicalRecordSource? source,
    DateTime? from,
    DateTime? to,
  }) {
    return repository.getMedicalRecords(
      petId: petId,
      page: page,
      limit: limit,
      eventType: eventType,
      source: source,
      from: from,
      to: to,
    );
  }
}
