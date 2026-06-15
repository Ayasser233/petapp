import '../entities/medical_record_entity.dart';
import '../../data/models/medical_record_list_response.dart';

abstract class MedicalRecordRepository {
  Future<MedicalRecordListResponse> getMedicalRecords({
    required String petId,
    int page = 1,
    int limit = 10,
    MedicalRecordEventType? eventType,
    MedicalRecordSource? source,
    DateTime? from,
    DateTime? to,
  });

  Future<MedicalRecordEntity> createMedicalRecord({
    required String petId,
    required MedicalRecordEventType eventType,
    required Map<String, dynamic> payload,
    DateTime? occurredAt,
    String? appointmentId,
    String? vaccinationScheduleId,
    List<String>? files,
  });

  Future<Map<String, dynamic>> getShareLink(String petId);
}
