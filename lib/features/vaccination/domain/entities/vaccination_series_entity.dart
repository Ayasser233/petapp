import 'package:equatable/equatable.dart';

/// Vaccination Series Entity
///
/// Represents a vaccination series for a pet
/// Maps to: vaccination_series table
class VaccinationSeriesEntity extends Equatable {
  final String id;
  final String petId;
  final String vaccineType; // vaccination_series_vaccine_type_enum
  final String status; // vaccination_series_status_enum
  final bool isComplete;
  final DateTime? completedAt;
  final String createdByUserId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  const VaccinationSeriesEntity({
    required this.id,
    required this.petId,
    required this.vaccineType,
    required this.status,
    required this.isComplete,
    this.completedAt,
    required this.createdByUserId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  @override
  List<Object?> get props => [
        id,
        petId,
        vaccineType,
        status,
        isComplete,
        completedAt,
        createdByUserId,
        createdAt,
        updatedAt,
        deletedAt,
      ];
}
