import '../repositories/medical_record_repository.dart';
import '../entities/medical_record_entity.dart';

class CreateMedicalRecordUseCase {
  final MedicalRecordRepository repository;

  CreateMedicalRecordUseCase(this.repository);

  Future<MedicalRecordEntity> call({
    required String petId,
    required MedicalRecordEventType eventType,
    required Map<String, dynamic> payload,
    DateTime? occurredAt,
    String? appointmentId,
    String? vaccinationScheduleId,
    List<String>? files,
  }) {
    return repository.createMedicalRecord(
      petId: petId,
      eventType: eventType,
      payload: payload,
      occurredAt: occurredAt,
      appointmentId: appointmentId,
      vaccinationScheduleId: vaccinationScheduleId,
      files: files,
    );
  }
}
