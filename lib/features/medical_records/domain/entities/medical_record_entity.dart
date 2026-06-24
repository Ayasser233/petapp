import 'package:equatable/equatable.dart';

enum MedicalRecordSource { OWNER, VET, SYSTEM }

enum MedicalRecordEventType {
  NOTE,
  HEALTH_EVENT,
  MEDICATION,
  VISIT,
  TEST_LAB_IMAGING,
  PROCEDURE_SURGERY,
  VACCINE
}

class MedicalRecordEntity extends Equatable {
  final String id;
  final String petId;
  final MedicalRecordSource source;
  final MedicalRecordEventType eventType;
  final DateTime occurredAt;
  final Map<String, dynamic> payload;
  final String? appointmentId;
  final String? vaccinationScheduleId;
  final String? createdByUserId;
  final String? vetId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  const MedicalRecordEntity({
    required this.id,
    required this.petId,
    required this.source,
    required this.eventType,
    required this.occurredAt,
    required this.payload,
    this.appointmentId,
    this.vaccinationScheduleId,
    this.createdByUserId,
    this.vetId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  @override
  List<Object?> get props => [
        id,
        petId,
        source,
        eventType,
        occurredAt,
        payload,
        appointmentId,
        vaccinationScheduleId,
        createdByUserId,
        vetId,
        createdAt,
        updatedAt,
        deletedAt,
      ];
}
