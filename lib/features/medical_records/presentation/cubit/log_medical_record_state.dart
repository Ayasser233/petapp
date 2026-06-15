import 'package:equatable/equatable.dart';

abstract class LogMedicalRecordState extends Equatable {
  const LogMedicalRecordState();

  @override
  List<Object?> get props => [];
}

class LogMedicalRecordInitial extends LogMedicalRecordState {}

class LogMedicalRecordLoading extends LogMedicalRecordState {}

class LogMedicalRecordSuccess extends LogMedicalRecordState {
  final String message;
  const LogMedicalRecordSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class LogMedicalRecordError extends LogMedicalRecordState {
  final String message;
  const LogMedicalRecordError(this.message);

  @override
  List<Object?> get props => [message];
}
