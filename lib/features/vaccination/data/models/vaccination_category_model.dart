import '../../domain/entities/vaccination_category_entity.dart';

/// Vaccination Category Model
///
/// Data model for API serialization/deserialization
/// Converts between JSON and VaccinationCategoryEntity
/// Parses response from: GET /vaccination/eligible-categories?petId=X
class VaccinationCategoryModel extends VaccinationCategoryEntity {
  const VaccinationCategoryModel({
    required super.category,
    required super.minAgeDays,
    required super.vaccines,
    required super.isEligible,
  });

  /// Create from JSON
  /// Expected format from backend:
  /// {
  ///   "category": "VIRUS",
  ///   "minAgeDays": 28,
  ///   "vaccines": ["DOG_MONOVALENT", "DOG_BIVALENT", ...],
  ///   "isEligible": true
  /// }
  factory VaccinationCategoryModel.fromJson(Map<String, dynamic> json) {
    return VaccinationCategoryModel(
      category: json['category'] ?? '',
      minAgeDays: json['minAgeDays'] ?? 0,
      vaccines: (json['vaccines'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      isEligible: json['isEligible'] ?? false,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'minAgeDays': minAgeDays,
      'vaccines': vaccines,
      'isEligible': isEligible,
    };
  }

  /// Create from Entity
  factory VaccinationCategoryModel.fromEntity(
      VaccinationCategoryEntity entity) {
    return VaccinationCategoryModel(
      category: entity.category,
      minAgeDays: entity.minAgeDays,
      vaccines: entity.vaccines,
      isEligible: entity.isEligible,
    );
  }

  /// Convert to Entity
  VaccinationCategoryEntity toEntity() {
    return VaccinationCategoryEntity(
      category: category,
      minAgeDays: minAgeDays,
      vaccines: vaccines,
      isEligible: isEligible,
    );
  }
}
