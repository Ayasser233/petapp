import 'package:equatable/equatable.dart';

/// Pet Info Entity (nested in Medical Sheet)
class PetInfoEntity extends Equatable {
  final String id;
  final String name;
  final String species;
  final String breed;
  final String gender;
  final String dateOfBirth;
  final double weight;

  const PetInfoEntity({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.gender,
    required this.dateOfBirth,
    required this.weight,
  });

  @override
  List<Object?> get props =>
      [id, name, species, breed, gender, dateOfBirth, weight];
}

/// Dose Info Entity (nested in Vaccination Series)
class DoseInfoEntity extends Equatable {
  final int doseNumber;
  final String? administeredDate;
  final String status;

  const DoseInfoEntity({
    required this.doseNumber,
    this.administeredDate,
    required this.status,
  });

  bool get isCompleted => status == 'COMPLETED';

  @override
  List<Object?> get props => [doseNumber, administeredDate, status];
}

/// Vaccination Series Entity (from medical sheet)
class VaccinationSeriesInfo extends Equatable {
  final String seriesId;
  final String vaccineType;
  final String status;
  final bool isComplete;
  final int totalDoses;
  final int completedDoses;
  final List<DoseInfoEntity> doses;
  final String? annualBoosterDate;

  const VaccinationSeriesInfo({
    required this.seriesId,
    required this.vaccineType,
    required this.status,
    required this.isComplete,
    required this.totalDoses,
    required this.completedDoses,
    required this.doses,
    this.annualBoosterDate,
  });

  @override
  List<Object?> get props => [
        seriesId,
        vaccineType,
        status,
        isComplete,
        totalDoses,
        completedDoses,
        doses,
        annualBoosterDate,
      ];
}

/// Annual Booster Entity
class AnnualBoosterEntity extends Equatable {
  final String vaccineType;
  final String dueDate;
  final bool isOverdue;
  final String seriesId;

  const AnnualBoosterEntity({
    required this.vaccineType,
    required this.dueDate,
    required this.isOverdue,
    required this.seriesId,
  });

  @override
  List<Object?> get props => [vaccineType, dueDate, isOverdue, seriesId];
}

/// Medical Sheet Entity
///
/// Represents the complete vaccination medical sheet for a pet
/// Backend endpoint: GET /vaccination/schedules/pet/:id/medical-sheet
class MedicalSheetEntity extends Equatable {
  final PetInfoEntity pet;
  final List<VaccinationSeriesInfo> vaccinationSeries;
  final List<dynamic> upcomingDoses; // Currently empty in backend
  final List<AnnualBoosterEntity> annualBoosters;
  final int totalUpcomingDoses;
  final int totalAnnualBoosters;

  const MedicalSheetEntity({
    required this.pet,
    required this.vaccinationSeries,
    required this.upcomingDoses,
    required this.annualBoosters,
    required this.totalUpcomingDoses,
    required this.totalAnnualBoosters,
  });

  // Computed properties for UI
  int get completedDosesCount {
    return vaccinationSeries.fold<int>(
      0,
      (sum, series) => sum + series.completedDoses,
    );
  }

  int get totalDosesCount {
    return vaccinationSeries.fold<int>(
      0,
      (sum, series) => sum + series.totalDoses,
    );
  }

  int get pendingDosesCount {
    return totalDosesCount - completedDosesCount;
  }

  List<VaccinationSeriesInfo> get completedSeries =>
      vaccinationSeries.where((s) => s.isComplete).toList();

  List<VaccinationSeriesInfo> get inProgressSeries =>
      vaccinationSeries.where((s) => !s.isComplete).toList();

  @override
  List<Object?> get props => [
        pet,
        vaccinationSeries,
        upcomingDoses,
        annualBoosters,
        totalUpcomingDoses,
        totalAnnualBoosters,
      ];
}
