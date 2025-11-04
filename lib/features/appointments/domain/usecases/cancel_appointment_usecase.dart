import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:petapp/core/errors/failures.dart';
import 'package:petapp/core/usecases/usecase.dart';
import 'package:petapp/features/appointments/domain/repositories/appointment_repository.dart';

/// Use case for canceling an appointment
class CancelAppointmentUseCase
    implements UseCase<bool, CancelAppointmentParams> {
  final AppointmentRepository repository;

  CancelAppointmentUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(CancelAppointmentParams params) async {
    return await repository.cancelAppointment(params.appointmentId);
  }
}

/// Parameters for CancelAppointmentUseCase
class CancelAppointmentParams extends Equatable {
  final String appointmentId;

  const CancelAppointmentParams({required this.appointmentId});

  @override
  List<Object?> get props => [appointmentId];
}
