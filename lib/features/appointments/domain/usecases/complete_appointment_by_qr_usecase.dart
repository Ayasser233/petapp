import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:petapp/core/errors/failures.dart';
import 'package:petapp/core/usecases/usecase.dart';
import 'package:petapp/features/appointments/domain/repositories/appointment_repository.dart';

/// Use case for completing an appointment by scanning QR code
class CompleteAppointmentByQrUseCase
    implements UseCase<void, CompleteAppointmentByQrParams> {
  final AppointmentRepository repository;

  CompleteAppointmentByQrUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(
    CompleteAppointmentByQrParams params,
  ) async {
    return await repository.completeAppointmentByQr(
      appointmentId: params.appointmentId,
      qrCode: params.qrCode,
    );
  }
}

/// Parameters for CompleteAppointmentByQrUseCase
class CompleteAppointmentByQrParams extends Equatable {
  final String appointmentId;
  final String qrCode;

  const CompleteAppointmentByQrParams({
    required this.appointmentId,
    required this.qrCode,
  });

  @override
  List<Object?> get props => [appointmentId, qrCode];
}
