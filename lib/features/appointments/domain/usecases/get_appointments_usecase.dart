import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:petapp/core/errors/failures.dart';
import 'package:petapp/core/usecases/usecase.dart';
import 'package:petapp/features/appointments/domain/repositories/appointment_repository.dart';

/// Use case for getting appointments with pagination and filtering
class GetAppointmentsUseCase
    implements UseCase<Map<String, dynamic>, GetAppointmentsParams> {
  final AppointmentRepository repository;

  GetAppointmentsUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(
    GetAppointmentsParams params,
  ) async {
    return await repository.getAppointments(
      page: params.page,
      limit: params.limit,
      status: params.status,
    );
  }
}

/// Parameters for GetAppointmentsUseCase
class GetAppointmentsParams extends Equatable {
  final int page;
  final int limit;
  final String? status;

  const GetAppointmentsParams({
    this.page = 1,
    this.limit = 10,
    this.status,
  });

  @override
  List<Object?> get props => [page, limit, status];
}
