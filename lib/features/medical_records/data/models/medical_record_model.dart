import '../../domain/entities/medical_record_entity.dart';

class MedicalRecordModel extends MedicalRecordEntity {
  const MedicalRecordModel({
    required super.id,
    required super.petId,
    required super.source,
    required super.eventType,
    required super.occurredAt,
    required super.payload,
    super.appointmentId,
    super.vaccinationScheduleId,
    super.createdByUserId,
    super.vetId,
    required super.createdAt,
    required super.updatedAt,
    super.deletedAt,
  });

  factory MedicalRecordModel.fromJson(Map<String, dynamic> json) {
    return MedicalRecordModel(
      id: json['id'],
      petId: json['petId'],
      source: _parseSource(json['source']),
      eventType: _parseEventType(json['eventType']),
      occurredAt: DateTime.parse(json['occurredAt']),
      payload: json['payload'] ?? {},
      appointmentId: json['appointmentId'],
      vaccinationScheduleId: json['vaccinationScheduleId'],
      createdByUserId: json['createdByUserId'],
      vetId: json['vetId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'petId': petId,
      'source': source.name,
      'eventType': eventType.name,
      'occurredAt': occurredAt.toIso8601String(),
      'payload': payload,
      'appointmentId': appointmentId,
      'vaccinationScheduleId': vaccinationScheduleId,
      'createdByUserId': createdByUserId,
      'vetId': vetId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  static MedicalRecordSource _parseSource(String source) {
    switch (source) {
      case 'OWNER':
        return MedicalRecordSource.OWNER;
      case 'VET':
        return MedicalRecordSource.VET;
      case 'SYSTEM':
        return MedicalRecordSource.SYSTEM;
      default:
        return MedicalRecordSource.SYSTEM;
    }
  }

  static MedicalRecordEventType _parseEventType(String eventType) {
    switch (eventType) {
      case 'NOTE':
        return MedicalRecordEventType.NOTE;
      case 'HEALTH_EVENT':
        return MedicalRecordEventType.HEALTH_EVENT;
      case 'MEDICATION':
        return MedicalRecordEventType.MEDICATION;
      case 'VISIT':
        return MedicalRecordEventType.VISIT;
      case 'TEST_LAB_IMAGING':
        return MedicalRecordEventType.TEST_LAB_IMAGING;
      case 'PROCEDURE_SURGERY':
        return MedicalRecordEventType.PROCEDURE_SURGERY;
      case 'VACCINE':
        return MedicalRecordEventType.VACCINE;
      default:
        throw ArgumentError('Invalid MedicalRecordEventType: $eventType');
    }
  }
}
