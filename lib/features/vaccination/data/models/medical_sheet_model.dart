import '../../domain/entities/medical_sheet_entity.dart';

/// Pet Info Model
class PetInfoModel extends PetInfoEntity {
  const PetInfoModel({
    required super.id,
    required super.name,
    required super.species,
    required super.breed,
    required super.gender,
    required super.dateOfBirth,
    required super.weight,
  });

  factory PetInfoModel.fromJson(Map<String, dynamic> json) {
    return PetInfoModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      species: json['species'] ?? '',
      breed: json['breed'] ?? '',
      gender: json['gender'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      weight: (json['weight'] ?? 0).toDouble(),
    );
  }
}

/// Dose Info Model
class DoseInfoModel extends DoseInfoEntity {
  const DoseInfoModel({
    required super.doseNumber,
    super.administeredDate,
    required super.status,
  });

  factory DoseInfoModel.fromJson(Map<String, dynamic> json) {
    return DoseInfoModel(
      doseNumber: json['doseNumber'] ?? 0,
      administeredDate: json['administeredDate'],
      status: json['status'] ?? '',
    );
  }
}

/// Vaccination Series Info Model
class VaccinationSeriesInfoModel extends VaccinationSeriesInfo {
  const VaccinationSeriesInfoModel({
    required super.seriesId,
    required super.vaccineType,
    required super.status,
    required super.isComplete,
    required super.totalDoses,
    required super.completedDoses,
    required super.doses,
    super.annualBoosterDate,
  });

  factory VaccinationSeriesInfoModel.fromJson(Map<String, dynamic> json) {
    return VaccinationSeriesInfoModel(
      seriesId: json['seriesId'] ?? '',
      vaccineType: json['vaccineType'] ?? '',
      status: json['status'] ?? '',
      isComplete: json['isComplete'] ?? false,
      totalDoses: json['totalDoses'] ?? 0,
      completedDoses: json['completedDoses'] ?? 0,
      doses: (json['doses'] as List<dynamic>?)
              ?.map((d) => DoseInfoModel.fromJson(d))
              .toList() ??
          [],
      annualBoosterDate: json['annualBoosterDate'],
    );
  }
}

/// Annual Booster Model
class AnnualBoosterModel extends AnnualBoosterEntity {
  const AnnualBoosterModel({
    required super.vaccineType,
    required super.dueDate,
    required super.isOverdue,
    required super.seriesId,
  });

  factory AnnualBoosterModel.fromJson(Map<String, dynamic> json) {
    return AnnualBoosterModel(
      vaccineType: json['vaccineType'] ?? '',
      dueDate: json['dueDate'] ?? '',
      isOverdue: json['isOverdue'] ?? false,
      seriesId: json['seriesId'] ?? '',
    );
  }
}

/// Medical Sheet Model
///
/// Data model for API serialization/deserialization
/// Backend response: GET /vaccination/schedules/pet/:id/medical-sheet
class MedicalSheetModel extends MedicalSheetEntity {
  const MedicalSheetModel({
    required super.pet,
    required super.vaccinationSeries,
    required super.upcomingDoses,
    required super.annualBoosters,
    required super.totalUpcomingDoses,
    required super.totalAnnualBoosters,
  });

  /// Create from JSON
  /// Expected backend response:
  /// {
  ///   "success": true,
  ///   "message": "...",
  ///   "data": {
  ///     "pet": {...},
  ///     "vaccinationSeries": [...],
  ///     "upcomingDoses": [],
  ///     "annualBoosters": [...],
  ///     "totalUpcomingDoses": 0,
  ///     "totalAnnualBoosters": 1
  ///   }
  /// }
  factory MedicalSheetModel.fromJson(Map<String, dynamic> json) {
    return MedicalSheetModel(
      pet: PetInfoModel.fromJson(json['pet'] ?? {}),
      vaccinationSeries: (json['vaccinationSeries'] as List<dynamic>?)
              ?.map((s) => VaccinationSeriesInfoModel.fromJson(s))
              .toList() ??
          [],
      upcomingDoses: json['upcomingDoses'] ?? [],
      annualBoosters: (json['annualBoosters'] as List<dynamic>?)
              ?.map((b) => AnnualBoosterModel.fromJson(b))
              .toList() ??
          [],
      totalUpcomingDoses: json['totalUpcomingDoses'] ?? 0,
      totalAnnualBoosters: json['totalAnnualBoosters'] ?? 0,
    );
  }

  /// Convert to Entity
  MedicalSheetEntity toEntity() {
    return MedicalSheetEntity(
      pet: pet,
      vaccinationSeries: vaccinationSeries,
      upcomingDoses: upcomingDoses,
      annualBoosters: annualBoosters,
      totalUpcomingDoses: totalUpcomingDoses,
      totalAnnualBoosters: totalAnnualBoosters,
    );
  }
}
