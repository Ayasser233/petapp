import 'package:equatable/equatable.dart';

/// Vaccination Schedule Entity (Individual Dose)
///
/// Represents an individual vaccination schedule/dose
/// Maps to: vaccination_schedule table
class VaccinationDoseEntity extends Equatable {
  final String id;
  final String petId;
  final String vaccineType; // vaccination_schedule_vaccine_type_enum
  final int doseNumber; // int4(32,0)
  final DateTime? administeredDate;
  final DateTime? nextDueDate;
  final String status; // vaccination_schedule_status_enum
  final bool isCompleted;
  final bool isValidSeries;
  final bool userMarkedCompleted;
  final DateTime? completedAt;
  final String createdByUserId;
  final dynamic reminders; // jsonb
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? seriesId; // Links to vaccination_series

  const VaccinationDoseEntity({
    required this.id,
    required this.petId,
    required this.vaccineType,
    required this.doseNumber,
    this.administeredDate,
    this.nextDueDate,
    required this.status,
    required this.isCompleted,
    required this.isValidSeries,
    required this.userMarkedCompleted,
    this.completedAt,
    required this.createdByUserId,
    this.reminders,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.seriesId,
  });

  @override
  List<Object?> get props => [
        id,
        petId,
        vaccineType,
        doseNumber,
        administeredDate,
        nextDueDate,
        status,
        isCompleted,
        isValidSeries,
        userMarkedCompleted,
        completedAt,
        createdByUserId,
        reminders,
        createdAt,
        updatedAt,
        deletedAt,
        seriesId,
      ];
}
