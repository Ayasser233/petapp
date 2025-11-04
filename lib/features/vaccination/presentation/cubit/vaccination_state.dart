import 'package:equatable/equatable.dart';
import '../../domain/entities/vaccination_category_entity.dart';
import '../../domain/entities/vaccination_series_entity.dart';
import '../../domain/entities/medical_sheet_entity.dart';

/// Base Vaccination State
abstract class VaccinationState extends Equatable {
  const VaccinationState();

  @override
  List<Object?> get props => [];
}

/// Initial State
class VaccinationInitial extends VaccinationState {
  const VaccinationInitial();
}

/// Loading State
class VaccinationLoading extends VaccinationState {
  const VaccinationLoading();
}

/// Eligible Categories Loaded
class EligibleCategoriesLoaded extends VaccinationState {
  final List<VaccinationCategoryEntity> categories;

  const EligibleCategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

/// Vaccination Series Created
class VaccinationSeriesCreated extends VaccinationState {
  final VaccinationSeriesEntity series;

  const VaccinationSeriesCreated(this.series);

  @override
  List<Object?> get props => [series];
}

/// Dose Marked Complete
class DoseMarkedComplete extends VaccinationState {
  final VaccinationSeriesEntity series;

  const DoseMarkedComplete(this.series);

  @override
  List<Object?> get props => [series];
}

/// Annual Booster Marked Complete
class AnnualBoosterMarkedComplete extends VaccinationState {
  final VaccinationSeriesEntity series;

  const AnnualBoosterMarkedComplete(this.series);

  @override
  List<Object?> get props => [series];
}

/// Medical Sheet Loaded
class MedicalSheetLoaded extends VaccinationState {
  final MedicalSheetEntity medicalSheet;

  const MedicalSheetLoaded(this.medicalSheet);

  @override
  List<Object?> get props => [medicalSheet];
}

/// Error State
class VaccinationError extends VaccinationState {
  final String message;

  const VaccinationError(this.message);

  @override
  List<Object?> get props => [message];
}
