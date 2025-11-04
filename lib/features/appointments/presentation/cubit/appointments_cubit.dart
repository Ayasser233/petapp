import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petapp/features/appointments/domain/entities/appointment_entity.dart';
import 'package:petapp/features/appointments/domain/entities/appointment_entity_extensions.dart';
import 'package:petapp/features/appointments/domain/usecases/cancel_appointment_usecase.dart';
import 'package:petapp/features/appointments/domain/usecases/complete_appointment_by_qr_usecase.dart';
import 'package:petapp/features/appointments/domain/usecases/create_appointment_usecase.dart';
import 'package:petapp/features/appointments/domain/usecases/get_appointments_usecase.dart';
import 'package:petapp/features/appointments/domain/usecases/get_filtered_appointments_usecase.dart';
import 'package:petapp/features/appointments/domain/usecases/submit_review_usecase.dart';
import 'package:petapp/features/appointments/presentation/cubit/appointments_state.dart';

/// Cubit for managing appointments state
class AppointmentsCubit extends Cubit<AppointmentsState> {
  final GetAppointmentsUseCase getAppointmentsUseCase;
  final GetFilteredAppointmentsUseCase getFilteredAppointmentsUseCase;
  final CancelAppointmentUseCase cancelAppointmentUseCase;
  final CreateAppointmentUseCase createAppointmentUseCase;
  final SubmitReviewUseCase submitReviewUseCase;
  final CompleteAppointmentByQrUseCase completeAppointmentByQrUseCase;

  AppointmentsCubit({
    required this.getAppointmentsUseCase,
    required this.getFilteredAppointmentsUseCase,
    required this.cancelAppointmentUseCase,
    required this.createAppointmentUseCase,
    required this.submitReviewUseCase,
    required this.completeAppointmentByQrUseCase,
  }) : super(const AppointmentsInitial());

  /// Get appointments with pagination
  Future<void> getAppointments({
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    emit(const AppointmentsLoading());

    final result = await getAppointmentsUseCase(
      GetAppointmentsParams(
        page: page,
        limit: limit,
        status: status,
      ),
    );

    result.fold(
      (failure) => emit(AppointmentsError(message: failure.message)),
      (data) {
        emit(AppointmentsLoaded(
          appointments: data['data'],
          hasNextPage: data['hasNextPage'],
          currentPage: page,
        ));
      },
    );
  }

  /// Load more appointments (pagination)
  Future<void> loadMoreAppointments({
    required int nextPage,
    int limit = 10,
    String? status,
  }) async {
    final currentState = state;
    if (currentState is! AppointmentsLoaded) return;

    emit(AppointmentsLoadingMore(
      currentAppointments: currentState.appointments,
      currentPage: currentState.currentPage,
    ));

    final result = await getAppointmentsUseCase(
      GetAppointmentsParams(
        page: nextPage,
        limit: limit,
        status: status,
      ),
    );

    result.fold(
      (failure) => emit(AppointmentsError(message: failure.message)),
      (data) {
        final newAppointments = [
          ...currentState.appointments,
          ...(data['data'] as List<AppointmentEntity>),
        ];
        emit(AppointmentsLoaded(
          appointments: newAppointments,
          hasNextPage: data['hasNextPage'],
          currentPage: nextPage,
        ));
      },
    );
  }

  /// Get filtered appointments by status
  Future<void> getFilteredAppointments({String? status}) async {
    emit(const AppointmentsLoading());

    final filter = status ?? 'All';
    final result = await getFilteredAppointmentsUseCase(
      GetFilteredAppointmentsParams(filter: filter),
    );

    result.fold(
      (failure) => emit(AppointmentsError(message: failure.message)),
      (appointments) {
        // Apply client-side filtering to include expired appointments in Cancelled filter
        List<AppointmentEntity> filteredAppointments = appointments;

        if (filter.toUpperCase() == 'CANCELLED') {
          // Include both actually cancelled and expired appointments
          filteredAppointments = appointments.where((appointment) {
            return appointment.status.toUpperCase() == 'CANCELLED' ||
                appointment.isExpired;
          }).toList();
        } else if (filter.toUpperCase() != 'ALL') {
          // For other filters, exclude expired appointments
          filteredAppointments = appointments.where((appointment) {
            return appointment.status.toUpperCase() == filter.toUpperCase() &&
                !appointment.isExpired;
          }).toList();
        }

        // Sort appointments by date: most recent first (descending order)
        filteredAppointments.sort((a, b) {
          return b.startTime.compareTo(a.startTime);
        });

        emit(AppointmentsLoaded(
          appointments: filteredAppointments,
          hasNextPage: false,
          currentPage: 1,
        ));
      },
    );
  }

  /// Cancel an appointment
  Future<void> cancelAppointment({required String appointmentId}) async {
    emit(AppointmentActionLoading(
      appointmentId: appointmentId,
      action: 'cancel',
    ));

    final result = await cancelAppointmentUseCase(
      CancelAppointmentParams(appointmentId: appointmentId),
    );

    result.fold(
      (failure) => emit(AppointmentsError(message: failure.message)),
      (_) {
        // Emit success - UI will handle reload with current filter
        emit(const AppointmentActionSuccess(
          message: 'Appointment cancelled successfully',
          action: 'cancel',
        ));
      },
    );
  }

  /// Create a new appointment
  Future<void> createAppointment({
    required String slotId,
    String? petId,
    required DateTime appointmentDate,
    String? reasonForVisit,
    String? couponCode,
    int pointsToUse = 0,
  }) async {
    emit(const AppointmentsLoading());

    final result = await createAppointmentUseCase(
      CreateAppointmentParams(
        slotId: slotId,
        petId: petId,
        appointmentDate: appointmentDate,
        reasonForVisit: reasonForVisit,
        couponCode: couponCode,
        pointsToUse: pointsToUse,
      ),
    );

    result.fold(
      (failure) => emit(AppointmentsError(message: failure.message)),
      (appointment) {
        emit(const AppointmentActionSuccess(
          message: 'Appointment created successfully',
          action: 'create',
        ));

        // Refresh appointments
        Future.delayed(const Duration(milliseconds: 500), () {
          getAppointments();
        });
      },
    );
  }

  /// Submit a review for an appointment
  Future<void> submitReview({
    required String appointmentId,
    required int rating,
    String? comment,
  }) async {
    emit(AppointmentActionLoading(
      appointmentId: appointmentId,
      action: 'review',
    ));

    final result = await submitReviewUseCase(
      SubmitReviewParams(
        appointmentId: appointmentId,
        rating: rating,
        comment: comment,
      ),
    );

    result.fold(
      (failure) => emit(AppointmentsError(message: failure.message)),
      (_) {
        emit(const AppointmentActionSuccess(
          message: 'Review submitted successfully',
          action: 'review',
        ));

        // Refresh appointments
        Future.delayed(const Duration(milliseconds: 500), () {
          final currentState = state;
          if (currentState is AppointmentsLoaded) {
            getAppointments(page: currentState.currentPage);
          } else {
            getAppointments();
          }
        });
      },
    );
  }

  /// Complete appointment by scanning vet's QR code
  Future<void> completeAppointmentByQr({
    required String appointmentId,
    required String qrCode,
  }) async {
    emit(AppointmentActionLoading(
      appointmentId: appointmentId,
      action: 'complete-qr',
    ));

    final result = await completeAppointmentByQrUseCase(
      CompleteAppointmentByQrParams(
        appointmentId: appointmentId,
        qrCode: qrCode,
      ),
    );

    result.fold(
      (failure) => emit(AppointmentsError(message: failure.message)),
      (_) {
        // Emit success - UI will handle reload
        emit(const AppointmentActionSuccess(
          message: 'Appointment completed successfully',
          action: 'complete-qr',
        ));
      },
    );
  }

  /// Reset to initial state
  void reset() {
    emit(const AppointmentsInitial());
  }
}
