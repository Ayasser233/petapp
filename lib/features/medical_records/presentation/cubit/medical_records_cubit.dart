import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_medical_records_usecase.dart';
import '../../domain/usecases/create_share_link_usecase.dart';
import '../../domain/entities/medical_record_entity.dart';
import 'medical_records_state.dart';

class MedicalRecordsCubit extends Cubit<MedicalRecordsState> {
  final GetMedicalRecordsUseCase getMedicalRecordsUseCase;
  final CreateShareLinkUseCase createShareLinkUseCase;

  MedicalRecordsCubit({
    required this.getMedicalRecordsUseCase,
    required this.createShareLinkUseCase,
  }) : super(MedicalRecordsInitial());

  int _currentPage = 1;
  static const int _limit = 10;
  List<MedicalRecordEntity> _allRecords = [];
  MedicalRecordEventType? _currentFilter;
  DateTime? _fromDate;
  DateTime? _toDate;

  Future<void> loadMedicalRecords(String petId, {bool refresh = false, MedicalRecordEventType? filter, DateTime? from, DateTime? to}) async {
    if (refresh) {
      _currentPage = 1;
      _allRecords = [];
      _currentFilter = filter ?? _currentFilter;
      _fromDate = from ?? _fromDate;
      _toDate = to ?? _toDate;
      emit(const MedicalRecordsLoading(isFirstFetch: true));
    } else {
      if (state is MedicalRecordsLoaded) {
        final loadedState = state as MedicalRecordsLoaded;
        if (!loadedState.hasNextPage) return;
        emit(loadedState.copyWith()); // Keep current state
      }
    }

    try {
      final response = await getMedicalRecordsUseCase(
        petId: petId,
        page: _currentPage,
        limit: _limit,
        eventType: _currentFilter,
        from: _fromDate,
        to: _toDate,
      );

      final newRecords = response.records;
      _allRecords.addAll(newRecords);
      _currentPage++;

      emit(MedicalRecordsLoaded(
        records: List.from(_allRecords),
        hasNextPage: response.hasNextPage,
        currentPage: _currentPage - 1,
        currentFilter: _currentFilter,
        fromDate: _fromDate,
        toDate: _toDate,
      ));
    } catch (e) {
      emit(MedicalRecordsError(e.toString()));
    }
  }

  Future<Map<String, dynamic>?> generateShareLink(String petId) async {
    try {
      return await createShareLinkUseCase(petId);
    } catch (e) {
      return null;
    }
  }

  void filterByEventType(String petId, MedicalRecordEventType? filter) {
    _currentFilter = filter;
    loadMedicalRecords(petId, refresh: true);
  }

  void filterByDateRange(String petId, DateTime? from, DateTime? to) {
    _fromDate = from;
    _toDate = to;
    loadMedicalRecords(petId, refresh: true);
  }

  void clearAllFilters(String petId) {
    _currentFilter = null;
    _fromDate = null;
    _toDate = null;
    loadMedicalRecords(petId, refresh: true);
  }
}
