import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:petapp/core/errors/failures.dart';
import 'package:petapp/core/usecases/usecase.dart';
import 'package:petapp/features/appointments/domain/repositories/appointment_repository.dart';

/// Use case for validating points redemption for vet bookings
class ValidatePointsRedemptionUseCase
    implements UseCase<Map<String, dynamic>, ValidatePointsRedemptionParams> {
  final AppointmentRepository repository;

  ValidatePointsRedemptionUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(
    ValidatePointsRedemptionParams params,
  ) async {
    return await repository.validatePointsRedemption(
      vetId: params.vetId,
      pointsToRedeem: params.pointsToRedeem,
    );
  }
}

/// Parameters for ValidatePointsRedemptionUseCase
class ValidatePointsRedemptionParams extends Equatable {
  final String vetId;
  final int pointsToRedeem;

  const ValidatePointsRedemptionParams({
    required this.vetId,
    required this.pointsToRedeem,
  });

  @override
  List<Object?> get props => [vetId, pointsToRedeem];
}

