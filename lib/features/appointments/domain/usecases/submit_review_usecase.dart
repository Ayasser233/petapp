import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:petapp/core/errors/failures.dart';
import 'package:petapp/core/usecases/usecase.dart';
import 'package:petapp/features/appointments/domain/repositories/appointment_repository.dart';

/// Use case for submitting a review for an appointment
class SubmitReviewUseCase implements UseCase<bool, SubmitReviewParams> {
  final AppointmentRepository repository;

  SubmitReviewUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(SubmitReviewParams params) async {
    return await repository.submitReview(
      appointmentId: params.appointmentId,
      rating: params.rating,
      comment: params.comment,
    );
  }
}

/// Parameters for SubmitReviewUseCase
class SubmitReviewParams extends Equatable {
  final String appointmentId;
  final int rating;
  final String? comment;

  const SubmitReviewParams({
    required this.appointmentId,
    required this.rating,
    this.comment,
  });

  @override
  List<Object?> get props => [appointmentId, rating, comment];
}
