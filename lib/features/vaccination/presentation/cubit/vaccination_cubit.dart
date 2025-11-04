import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_eligible_categories_usecase.dart';
import '../../domain/usecases/create_vaccination_series_usecase.dart';
import '../../domain/usecases/mark_dose_complete_usecase.dart';
import '../../domain/usecases/mark_annual_booster_complete_usecase.dart';
import '../../domain/usecases/get_medical_sheet_usecase.dart';
import 'vaccination_state.dart';

/// Vaccination Cubit
///
/// Manages the state for vaccination-related operations
/// Uses usecases to interact with the domain layer
class VaccinationCubit extends Cubit<VaccinationState> {
  final GetEligibleCategoriesUsecase getEligibleCategoriesUsecase;
  final CreateVaccinationSeriesUsecase createVaccinationSeriesUsecase;
  final MarkDoseCompleteUsecase markDoseCompleteUsecase;
  final MarkAnnualBoosterCompleteUsecase markAnnualBoosterCompleteUsecase;
  final GetMedicalSheetUsecase getMedicalSheetUsecase;

  VaccinationCubit({
    required this.getEligibleCategoriesUsecase,
    required this.createVaccinationSeriesUsecase,
    required this.markDoseCompleteUsecase,
    required this.markAnnualBoosterCompleteUsecase,
    required this.getMedicalSheetUsecase,
  }) : super(const VaccinationInitial());

  /// Get eligible vaccine categories for a pet
  Future<void> getEligibleCategories(String petId) async {
    emit(const VaccinationLoading());

    final result = await getEligibleCategoriesUsecase(petId);

    result.fold(
      (failure) => emit(VaccinationError(failure.message)),
      (categories) => emit(EligibleCategoriesLoaded(categories)),
    );
  }

  /// Create a new vaccination series
  Future<void> createVaccineSeries({
    required String petId,
    required String vaccineType,
    required List<Map<String, dynamic>> doses,
  }) async {
    emit(const VaccinationLoading());

    final result = await createVaccinationSeriesUsecase(
      petId: petId,
      vaccineType: vaccineType,
      doses: doses,
    );

    result.fold(
      (failure) => emit(VaccinationError(failure.message)),
      (series) => emit(VaccinationSeriesCreated(series)),
    );
  }

  /// Mark a dose as complete
  Future<void> markDoseComplete({
    required String seriesId,
    required int doseNumber,
    required DateTime administeredAt,
    String? administeredBy,
    String? batchNumber,
    String? notes,
  }) async {
    emit(const VaccinationLoading());

    final result = await markDoseCompleteUsecase(
      seriesId: seriesId,
      doseNumber: doseNumber,
      administeredAt: administeredAt,
      administeredBy: administeredBy,
      batchNumber: batchNumber,
      notes: notes,
    );

    result.fold(
      (failure) => emit(VaccinationError(failure.message)),
      (series) => emit(DoseMarkedComplete(series)),
    );
  }

  /// Mark an annual booster as complete
  Future<void> markAnnualBoosterComplete({
    required String seriesId,
    required DateTime completedDate,
    String? administeredBy,
    String? batchNumber,
    String? notes,
  }) async {
    emit(const VaccinationLoading());

    final result = await markAnnualBoosterCompleteUsecase(
      seriesId: seriesId,
      completedDate: completedDate,
      administeredBy: administeredBy,
      batchNumber: batchNumber,
      notes: notes,
    );

    result.fold(
      (failure) => emit(VaccinationError(failure.message)),
      (series) => emit(AnnualBoosterMarkedComplete(series)),
    );
  }

  /// Get the medical sheet for a pet
  Future<void> getMedicalSheet(String petId) async {
    emit(const VaccinationLoading());

    final result = await getMedicalSheetUsecase(petId);

    result.fold(
      (failure) => emit(VaccinationError(failure.message)),
      (medicalSheet) => emit(MedicalSheetLoaded(medicalSheet)),
    );
  }

  /// Reset to initial state
  void reset() {
    emit(const VaccinationInitial());
  }
}
