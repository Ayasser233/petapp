import '../../domain/entities/medical_record_entity.dart';
import '../../domain/repositories/medical_record_repository.dart';
import '../datasources/medical_record_remote_datasource.dart';
import '../models/medical_record_list_response.dart';

class MedicalRecordRepositoryImpl implements MedicalRecordRepository {
  final MedicalRecordRemoteDataSource remoteDataSource;

  MedicalRecordRepositoryImpl({required this.remoteDataSource});

  @override
  Future<MedicalRecordListResponse> getMedicalRecords({
    required String petId,
    int page = 1,
    int limit = 10,
    MedicalRecordEventType? eventType,
    MedicalRecordSource? source,
    DateTime? from,
    DateTime? to,
  }) {
    return remoteDataSource.getMedicalRecords(
      petId: petId,
      page: page,
      limit: limit,
      eventType: eventType,
      source: source,
      from: from,
      to: to,
    );
  }

  @override
  Future<MedicalRecordEntity> createMedicalRecord({
    required String petId,
    required MedicalRecordEventType eventType,
    required Map<String, dynamic> payload,
    DateTime? occurredAt,
    String? appointmentId,
    String? vaccinationScheduleId,
    List<String>? files,
  }) {
    return remoteDataSource.createMedicalRecord(
      petId: petId,
      eventType: eventType,
      payload: payload,
      occurredAt: occurredAt,
      appointmentId: appointmentId,
      vaccinationScheduleId: vaccinationScheduleId,
      files: files,
    );
  }

  @override
  Future<Map<String, dynamic>> getShareLink(String petId) {
    return remoteDataSource.getShareLink(petId);
  }
}
