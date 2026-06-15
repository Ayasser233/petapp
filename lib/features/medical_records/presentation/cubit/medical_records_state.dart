import 'package:equatable/equatable.dart';
import '../../domain/entities/medical_record_entity.dart';

abstract class MedicalRecordsState extends Equatable {
  const MedicalRecordsState();

  @override
  List<Object?> get props => [];
}

class MedicalRecordsInitial extends MedicalRecordsState {}

class MedicalRecordsLoading extends MedicalRecordsState {
  final bool isFirstFetch;
  const MedicalRecordsLoading({this.isFirstFetch = true});
  
  @override
  List<Object?> get props => [isFirstFetch];
}

class MedicalRecordsLoaded extends MedicalRecordsState {
  final List<MedicalRecordEntity> records;
  final bool hasNextPage;
  final int currentPage;
  final MedicalRecordEventType? currentFilter;
  final DateTime? fromDate;
  final DateTime? toDate;

  const MedicalRecordsLoaded({
    required this.records,
    required this.hasNextPage,
    required this.currentPage,
    this.currentFilter,
    this.fromDate,
    this.toDate,
  });

  @override
  List<Object?> get props => [records, hasNextPage, currentPage, currentFilter, fromDate, toDate];

  MedicalRecordsLoaded copyWith({
    List<MedicalRecordEntity>? records,
    bool? hasNextPage,
    int? currentPage,
    MedicalRecordEventType? currentFilter,
    DateTime? fromDate,
    DateTime? toDate,
    bool clearFilter = false,
    bool clearDates = false,
  }) {
    return MedicalRecordsLoaded(
      records: records ?? this.records,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      currentPage: currentPage ?? this.currentPage,
      currentFilter: clearFilter ? null : (currentFilter ?? this.currentFilter),
      fromDate: clearDates ? null : (fromDate ?? this.fromDate),
      toDate: clearDates ? null : (toDate ?? this.toDate),
    );
  }
}

class MedicalRecordsError extends MedicalRecordsState {
  final String message;
  const MedicalRecordsError(this.message);

  @override
  List<Object?> get props => [message];
}
