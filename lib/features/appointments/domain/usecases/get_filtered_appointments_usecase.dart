import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:petapp/core/errors/failures.dart';
import 'package:petapp/core/usecases/usecase.dart';
import 'package:petapp/features/appointments/domain/entities/appointment_entity.dart';
import 'package:petapp/features/appointments/domain/repositories/appointment_repository.dart';

/// Use case for filtering appointments by status
class GetFilteredAppointmentsUseCase
    implements UseCase<List<AppointmentEntity>, GetFilteredAppointmentsParams> {
  final AppointmentRepository repository;

  GetFilteredAppointmentsUseCase(this.repository);

  @override
  Future<Either<Failure, List<AppointmentEntity>>> call(
    GetFilteredAppointmentsParams params,
  ) async {
    return await repository.getFilteredAppointments(params.filter);
  }
}

/// Parameters for GetFilteredAppointmentsUseCase
class GetFilteredAppointmentsParams extends Equatable {
  final String filter;

  const GetFilteredAppointmentsParams({required this.filter});

  @override
  List<Object?> get props => [filter];
}
