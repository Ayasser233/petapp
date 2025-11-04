import 'package:equatable/equatable.dart';
import 'package:petapp/features/appointments/domain/entities/appointment_entity.dart';

/// Base state for appointments feature
abstract class AppointmentsState extends Equatable {
  const AppointmentsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class AppointmentsInitial extends AppointmentsState {
  const AppointmentsInitial();
}

/// Loading state
class AppointmentsLoading extends AppointmentsState {
  const AppointmentsLoading();
}

/// Success state with appointments data
class AppointmentsLoaded extends AppointmentsState {
  final List<AppointmentEntity> appointments;
  final bool hasNextPage;
  final int currentPage;

  const AppointmentsLoaded({
    required this.appointments,
    required this.hasNextPage,
    this.currentPage = 1,
  });

  @override
  List<Object?> get props => [appointments, hasNextPage, currentPage];

  AppointmentsLoaded copyWith({
    List<AppointmentEntity>? appointments,
    bool? hasNextPage,
    int? currentPage,
  }) {
    return AppointmentsLoaded(
      appointments: appointments ?? this.appointments,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

/// Error state
class AppointmentsError extends AppointmentsState {
  final String message;

  const AppointmentsError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Loading more appointments (pagination)
class AppointmentsLoadingMore extends AppointmentsState {
  final List<AppointmentEntity> currentAppointments;
  final int currentPage;

  const AppointmentsLoadingMore({
    required this.currentAppointments,
    required this.currentPage,
  });

  @override
  List<Object?> get props => [currentAppointments, currentPage];
}

/// Appointment details loading state
class AppointmentDetailsLoading extends AppointmentsState {
  const AppointmentDetailsLoading();
}

/// Appointment details loaded state
class AppointmentDetailsLoaded extends AppointmentsState {
  final AppointmentEntity appointment;

  const AppointmentDetailsLoaded({required this.appointment});

  @override
  List<Object?> get props => [appointment];
}

/// Appointment action loading (cancel, complete, review)
class AppointmentActionLoading extends AppointmentsState {
  final String appointmentId;
  final String action; // 'cancel', 'complete', 'review'

  const AppointmentActionLoading({
    required this.appointmentId,
    required this.action,
  });

  @override
  List<Object?> get props => [appointmentId, action];
}

/// Appointment action success
class AppointmentActionSuccess extends AppointmentsState {
  final String message;
  final String action;

  const AppointmentActionSuccess({
    required this.message,
    required this.action,
  });

  @override
  List<Object?> get props => [message, action];
}

/// Coupon validation states
class CouponValidating extends AppointmentsState {
  const CouponValidating();
}

class CouponValidated extends AppointmentsState {
  final double discount;
  final String message;

  const CouponValidated({
    required this.discount,
    required this.message,
  });

  @override
  List<Object?> get props => [discount, message];
}

/// Points validation states
class PointsValidating extends AppointmentsState {
  const PointsValidating();
}

class PointsValidated extends AppointmentsState {
  final double discount;
  final String message;

  const PointsValidated({
    required this.discount,
    required this.message,
  });

  @override
  List<Object?> get props => [discount, message];
}
