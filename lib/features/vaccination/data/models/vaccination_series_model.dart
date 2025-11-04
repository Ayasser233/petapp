import '../../domain/entities/vaccination_series_entity.dart';

/// Vaccination Series Model
///
/// Data model for API serialization/deserialization
/// Converts between JSON and VaccinationSeriesEntity
/// Maps to: vaccination_series table
class VaccinationSeriesModel extends VaccinationSeriesEntity {
  const VaccinationSeriesModel({
    required super.id,
    required super.petId,
    required super.vaccineType,
    required super.status,
    required super.isComplete,
    super.completedAt,
    required super.createdByUserId,
    required super.createdAt,
    required super.updatedAt,
    super.deletedAt,
  });

  /// Create from JSON
  factory VaccinationSeriesModel.fromJson(Map<String, dynamic> json) {
    return VaccinationSeriesModel(
      id: json['id'] ?? '',
      petId: json['petId'] ?? json['pet_id'] ?? '',
      vaccineType: json['vaccineType'] ?? json['vaccine_type'] ?? '',
      status: json['status'] ?? '',
      isComplete: json['isComplete'] ?? json['is_complete'] ?? false,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : json['completed_at'] != null
              ? DateTime.parse(json['completed_at'])
              : null,
      createdByUserId:
          json['createdByUserId'] ?? json['created_by_user_id'] ?? '',
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
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'petId': petId,
      'vaccineType': vaccineType,
      'status': status,
      'isComplete': isComplete,
      'completedAt': completedAt?.toIso8601String(),
      'createdByUserId': createdByUserId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  /// Create from Entity
  factory VaccinationSeriesModel.fromEntity(VaccinationSeriesEntity entity) {
    return VaccinationSeriesModel(
      id: entity.id,
      petId: entity.petId,
      vaccineType: entity.vaccineType,
      status: entity.status,
      isComplete: entity.isComplete,
      completedAt: entity.completedAt,
      createdByUserId: entity.createdByUserId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      deletedAt: entity.deletedAt,
    );
  }

  /// Convert to Entity
  VaccinationSeriesEntity toEntity() {
    return VaccinationSeriesEntity(
      id: id,
      petId: petId,
      vaccineType: vaccineType,
      status: status,
      isComplete: isComplete,
      completedAt: completedAt,
      createdByUserId: createdByUserId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
    );
  }
}
