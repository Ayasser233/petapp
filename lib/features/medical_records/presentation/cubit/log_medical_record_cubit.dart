import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_medical_record_usecase.dart';
import '../../domain/entities/medical_record_entity.dart';
import 'log_medical_record_state.dart';

class LogMedicalRecordCubit extends Cubit<LogMedicalRecordState> {
  final CreateMedicalRecordUseCase createMedicalRecordUseCase;

  LogMedicalRecordCubit({
    required this.createMedicalRecordUseCase,
  }) : super(LogMedicalRecordInitial());

  Future<void> createRecord({
    required String petId,
    required MedicalRecordEventType eventType,
    required Map<String, dynamic> payload,
    DateTime? occurredAt,
    List<String>? files,
  }) async {
    emit(LogMedicalRecordLoading());

    try {
      await createMedicalRecordUseCase(
        petId: petId,
        eventType: eventType,
        payload: payload,
        occurredAt: occurredAt,
        files: files,
      );

      emit(const LogMedicalRecordSuccess('Medical record created successfully'));
    } catch (e) {
      emit(LogMedicalRecordError(e.toString()));
    }
  }
}
