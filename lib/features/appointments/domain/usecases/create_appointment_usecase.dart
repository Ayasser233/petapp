import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:petapp/core/errors/failures.dart';
import 'package:petapp/core/usecases/usecase.dart';
import 'package:petapp/features/appointments/domain/entities/appointment_entity.dart';
import 'package:petapp/features/appointments/domain/repositories/appointment_repository.dart';

/// Use case for creating a new appointment
class CreateAppointmentUseCase
    implements UseCase<AppointmentEntity, CreateAppointmentParams> {
  final AppointmentRepository repository;

  CreateAppointmentUseCase(this.repository);

  @override
  Future<Either<Failure, AppointmentEntity>> call(
    CreateAppointmentParams params,
  ) async {
    return await repository.createAppointment(
      slotId: params.slotId,
      appointmentDate: params.appointmentDate,
      petId: params.petId,
      reasonForVisit: params.reasonForVisit,
      pointsToRedeem: params.pointsToRedeem,
      couponCode: params.couponCode,
    );
  }
}

/// Parameters for CreateAppointmentUseCase
class CreateAppointmentParams extends Equatable {
  final String slotId;
  final DateTime appointmentDate;
  final String? petId;
  final String? reasonForVisit;
  final int? pointsToRedeem;
  final String? couponCode;

  const CreateAppointmentParams({
    required this.slotId,
    required this.appointmentDate,
    this.petId,
    this.reasonForVisit,
    this.pointsToRedeem,
    this.couponCode,
  });

  @override
  List<Object?> get props => [
        slotId,
        appointmentDate,
        petId,
        reasonForVisit,
        pointsToRedeem,
        couponCode,
      ];
}
