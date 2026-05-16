import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petapp/features/appointments/domain/entities/appointment_entity.dart';
import 'package:petapp/features/appointments/domain/entities/appointment_entity_extensions.dart';
import 'package:petapp/features/appointments/domain/usecases/cancel_appointment_usecase.dart';
import 'package:petapp/features/appointments/domain/usecases/complete_appointment_by_qr_usecase.dart';
import 'package:petapp/features/appointments/domain/usecases/create_appointment_usecase.dart';
import 'package:petapp/features/appointments/domain/usecases/get_appointments_usecase.dart';
import 'package:petapp/features/appointments/domain/usecases/submit_review_usecase.dart';
import 'package:petapp/features/appointments/presentation/cubit/appointments_state.dart';

import '../../../../core/services/facebook_event_service.dart';

/// Cubit for managing appointments state
class AppointmentsCubit extends Cubit<AppointmentsState> {
  final GetAppointmentsUseCase getAppointmentsUseCase;
  final CancelAppointmentUseCase cancelAppointmentUseCase;
  final CreateAppointmentUseCase createAppointmentUseCase;
  final SubmitReviewUseCase submitReviewUseCase;
  final CompleteAppointmentByQrUseCase completeAppointmentByQrUseCase;

  // Stored filter state for pagination
  String? _storedStatus;
  String? _storedDateFilter;
  int? _storedYear;
  int _storedPage = 1;
  bool _hasNextPage = false;
  bool _isLoadingMore = false;

  static const int _pageLimit = 10;

  bool get hasNextPage => _hasNextPage;
  bool get isLoadingMore => _isLoadingMore;

  AppointmentsCubit({
    required this.getAppointmentsUseCase,
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

  /// Get filtered appointments by status and date — page 1, limit 10
  Future<void> getFilteredAppointments({
    String? status,
    String? dateFilter,
    int? year,
  }) async {
    // Store filters for subsequent pages
    _storedStatus = status;
    _storedDateFilter = dateFilter;
    _storedYear = year;
    _storedPage = 1;
    _hasNextPage = false;

    emit(const AppointmentsLoading());

    final isAll = status == null || status.toUpperCase() == 'ALL';

    if (isAll) {
      // For "All" filter, fetch each status separately and merge to ensure
      // PENDING and CONFIRMED (upcoming) appointments are always included,
      // since the default endpoint may only return past (completed/cancelled) records.
      final results = await Future.wait([
        getAppointmentsUseCase(GetAppointmentsParams(page: 1, limit: 50, status: null)),
        getAppointmentsUseCase(GetAppointmentsParams(page: 1, limit: 50, status: 'PENDING')),
        getAppointmentsUseCase(GetAppointmentsParams(page: 1, limit: 50, status: 'CONFIRMED')),
      ]);

      // Surface the first error if any call failed
      for (final r in results) {
        if (r.isLeft()) {
          r.fold((f) => emit(AppointmentsError(message: f.message)), (_) {});
          return;
        }
      }

      // Merge and deduplicate by appointment id
      final seen = <String, AppointmentEntity>{};
      for (final r in results) {
        r.fold((_) {}, (data) {
          final items = List<AppointmentEntity>.from(data['data'] as List);
          for (final a in items) {
            seen[a.id] = a;
          }
        });
      }

      List<AppointmentEntity> appointments = seen.values.toList();
      appointments = _applyClientFilters(appointments, null, dateFilter, year);
      _hasNextPage = false;

      emit(AppointmentsLoaded(
        appointments: appointments,
        hasNextPage: false,
        currentPage: 1,
      ));
    } else {
      final apiStatus = status.toUpperCase();

      final result = await getAppointmentsUseCase(
        GetAppointmentsParams(page: 1, limit: _pageLimit, status: apiStatus),
      );

      result.fold(
        (failure) => emit(AppointmentsError(message: failure.message)),
        (data) {
          List<AppointmentEntity> appointments = List<AppointmentEntity>.from(data['data']);
          appointments = _applyClientFilters(appointments, status, dateFilter, year);

          _hasNextPage = data['hasNextPage'] as bool? ?? false;

          emit(AppointmentsLoaded(
            appointments: appointments,
            hasNextPage: _hasNextPage,
            currentPage: 1,
          ));
        },
      );
    }
  }

  /// Load next page using stored filters (called on scroll to bottom)
  Future<void> loadNextPage() async {
    if (!_hasNextPage || _isLoadingMore) return;
    final currentState = state;
    if (currentState is! AppointmentsLoaded) return;

    _isLoadingMore = true;
    _storedPage++;

    // Emit loading-more state to keep current list visible
    emit(AppointmentsLoadingMore(
      currentAppointments: currentState.appointments,
      currentPage: currentState.currentPage,
    ));

    final apiStatus = (_storedStatus != null && _storedStatus!.toUpperCase() != 'ALL')
        ? _storedStatus!.toUpperCase()
        : null;

    final result = await getAppointmentsUseCase(
      GetAppointmentsParams(page: _storedPage, limit: _pageLimit, status: apiStatus),
    );

    result.fold(
      (failure) {
        _storedPage--;
        _isLoadingMore = false;
        emit(AppointmentsLoaded(
          appointments: currentState.appointments,
          hasNextPage: _hasNextPage,
          currentPage: currentState.currentPage,
        ));
      },
      (data) {
        List<AppointmentEntity> newItems = List<AppointmentEntity>.from(data['data']);
        newItems = _applyClientFilters(newItems, _storedStatus, _storedDateFilter, _storedYear);

        _hasNextPage = data['hasNextPage'] as bool? ?? false;
        _isLoadingMore = false;

        emit(AppointmentsLoaded(
          appointments: [...currentState.appointments, ...newItems],
          hasNextPage: _hasNextPage,
          currentPage: _storedPage,
        ));
      },
    );
  }

  /// Apply client-side date and expired filters
  List<AppointmentEntity> _applyClientFilters(
    List<AppointmentEntity> appointments,
    String? status,
    String? dateFilter,
    int? year,
  ) {
    List<AppointmentEntity> filtered = appointments;

    final upperStatus = status?.toUpperCase() ?? 'ALL';

    if (upperStatus == 'CANCELLED') {
      filtered = filtered.where((a) =>
          a.status.toUpperCase() == 'CANCELLED' || a.isExpired).toList();
    } else if (upperStatus != 'ALL') {
      filtered = filtered.where((a) =>
          a.status.toUpperCase() == upperStatus && !a.isExpired).toList();
    }

    if (dateFilter == 'last3Months') {
      final threeMonthsAgo = DateTime.now().subtract(const Duration(days: 90));
      filtered = filtered.where((a) => a.startTime.isAfter(threeMonthsAgo)).toList();
    } else if (dateFilter == 'byYear' && year != null) {
      filtered = filtered.where((a) => a.startTime.year == year).toList();
    }

    filtered.sort((a, b) => b.startTime.compareTo(a.startTime));
    return filtered;
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
    int pointsToRedeem = 0,
  }) async {
    emit(const AppointmentsLoading());

    final result = await createAppointmentUseCase(
      CreateAppointmentParams(
        slotId: slotId,
        petId: petId,
        appointmentDate: appointmentDate,
        reasonForVisit: reasonForVisit,
        couponCode: couponCode,
        pointsToRedeem: pointsToRedeem,
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
    await FacebookEventService.logRate(
      maxRatingValue: 5,
      contentType: 'appointment',
      valueToSum: rating.toDouble(),
    );
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
