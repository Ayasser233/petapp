import '../../domain/entities/vaccination_dose_entity.dart';

/// Vaccination Dose Model (Vaccination Schedule)
///
/// Data model for API serialization/deserialization
/// Converts between JSON and VaccinationDoseEntity
/// Maps to: vaccination_schedule table
class VaccinationDoseModel extends VaccinationDoseEntity {
  const VaccinationDoseModel({
    required super.id,
    required super.petId,
    required super.vaccineType,
    required super.doseNumber,
    super.administeredDate,
    super.nextDueDate,
    required super.status,
    required super.isCompleted,
    required super.isValidSeries,
    required super.userMarkedCompleted,
    super.completedAt,
    required super.createdByUserId,
    super.reminders,
    required super.createdAt,
    required super.updatedAt,
    super.deletedAt,
    super.seriesId,
  });

  /// Create from JSON
  factory VaccinationDoseModel.fromJson(Map<String, dynamic> json) {
    return VaccinationDoseModel(
      id: json['id'] ?? '',
      petId: json['petId'] ?? json['pet_id'] ?? '',
      vaccineType: json['vaccineType'] ?? json['vaccine_type'] ?? '',
      doseNumber: json['doseNumber'] ?? json['dose_number'] ?? 0,
      administeredDate: json['administeredDate'] != null
          ? DateTime.parse(json['administeredDate'])
          : json['administered_date'] != null
              ? DateTime.parse(json['administered_date'])
              : null,
      nextDueDate: json['nextDueDate'] != null
          ? DateTime.parse(json['nextDueDate'])
          : json['next_due_date'] != null
              ? DateTime.parse(json['next_due_date'])
              : null,
      status: json['status'] ?? '',
      isCompleted: json['isCompleted'] ?? json['is_completed'] ?? false,
      isValidSeries: json['isValidSeries'] ?? json['is_valid_series'] ?? false,
      userMarkedCompleted:
          json['userMarkedCompleted'] ?? json['user_marked_completed'] ?? false,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : json['completed_at'] != null
              ? DateTime.parse(json['completed_at'])
              : null,
      createdByUserId:
          json['createdByUserId'] ?? json['created_by_user_id'] ?? '',
      reminders: json['reminders'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : DateTime.now(),
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'])
          : json['deleted_at'] != null
              ? DateTime.parse(json['deleted_at'])
              : null,
      seriesId: json['seriesId'] ?? json['series_id'],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'petId': petId,
      'vaccineType': vaccineType,
      'doseNumber': doseNumber,
      'administeredDate': administeredDate?.toIso8601String(),
      'nextDueDate': nextDueDate?.toIso8601String(),
      'status': status,
      'isCompleted': isCompleted,
      'isValidSeries': isValidSeries,
      'userMarkedCompleted': userMarkedCompleted,
      'completedAt': completedAt?.toIso8601String(),
      'createdByUserId': createdByUserId,
      'reminders': reminders,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'seriesId': seriesId,
    };
  }

  /// Create from Entity
  factory VaccinationDoseModel.fromEntity(VaccinationDoseEntity entity) {
    return VaccinationDoseModel(
      id: entity.id,
      petId: entity.petId,
      vaccineType: entity.vaccineType,
      doseNumber: entity.doseNumber,
      administeredDate: entity.administeredDate,
      nextDueDate: entity.nextDueDate,
      status: entity.status,
      isCompleted: entity.isCompleted,
      isValidSeries: entity.isValidSeries,
      userMarkedCompleted: entity.userMarkedCompleted,
      completedAt: entity.completedAt,
      createdByUserId: entity.createdByUserId,
      reminders: entity.reminders,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      deletedAt: entity.deletedAt,
      seriesId: entity.seriesId,
    );
  }

  /// Convert to Entity
  VaccinationDoseEntity toEntity() {
    return VaccinationDoseEntity(
      id: id,
      petId: petId,
      vaccineType: vaccineType,
      doseNumber: doseNumber,
      administeredDate: administeredDate,
      nextDueDate: nextDueDate,
      status: status,
      isCompleted: isCompleted,
      isValidSeries: isValidSeries,
      userMarkedCompleted: userMarkedCompleted,
      completedAt: completedAt,
      createdByUserId: createdByUserId,
      reminders: reminders,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      seriesId: seriesId,
    );
  }
}
