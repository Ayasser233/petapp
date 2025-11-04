import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petapp/core/screens/base_screen.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/di/service_locator.dart';
import 'package:petapp/features/appointments/domain/entities/appointment_entity.dart';
import 'package:petapp/features/appointments/presentation/cubit/appointments_cubit.dart';
import 'package:petapp/features/appointments/presentation/cubit/appointments_state.dart';
import 'package:petapp/features/appointments/presentation/widgets/appointment_filter_tabs.dart';
import 'package:petapp/features/appointments/presentation/widgets/appointment_card.dart';
import 'package:petapp/features/appointments/presentation/widgets/appointment_details_modal.dart';
import 'package:petapp/features/appointments/presentation/widgets/appointment_dialogs.dart';
import 'package:petapp/features/appointments/presentation/screens/qr_scanner_screen.dart';
import 'package:petapp/features/appointments/presentation/screens/submit_review_screen.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AppointmentsCubit>()..getFilteredAppointments(),
      child: const _AppointmentsScreenContent(),
    );
  }
}

class _AppointmentsScreenContent extends StatefulWidget {
  const _AppointmentsScreenContent();

  @override
  State<_AppointmentsScreenContent> createState() =>
      _AppointmentsScreenContentState();
}

class _AppointmentsScreenContentState
    extends State<_AppointmentsScreenContent> {
  String _selectedFilter = 'All';

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
    });

    final status = filter == 'All' ? null : filter.toUpperCase();
    context.read<AppointmentsCubit>().getFilteredAppointments(status: status);
  }

  void _onAppointmentTap(AppointmentEntity appointment) {
    AppointmentDetailsModal.show(context, appointment);
  }

  void _onCancelAppointment(AppointmentEntity appointment) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).cancelAppointment),
          content: Text(
            AppLocalizations.of(context).confirmCancelAppointmentMessage,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(AppLocalizations.of(context).no),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<AppointmentsCubit>().cancelAppointment(
                      appointmentId: appointment.id,
                    );
              },
              child: Text(
                AppLocalizations.of(context).yesCancelAppointment,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        );
      },
    );
  }

  void _onRescheduleAppointment(AppointmentEntity appointment) {
    AppointmentDialogs.showInfoSnackBar(
      context,
      AppLocalizations.of(context).rescheduleFeatureComingSoon,
    );
  }

  void _onReviewAppointment(AppointmentEntity appointment) async {
    // Capture the cubit reference before navigation
    final cubit = context.read<AppointmentsCubit>();

    // Navigate to review screen
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: cubit,
          child: SubmitReviewScreen(appointment: appointment),
        ),
      ),
    );

    // If review was submitted successfully, reload appointments
    if (result == true && mounted) {
      final status =
          _selectedFilter == 'All' ? null : _selectedFilter.toUpperCase();
      cubit.getFilteredAppointments(status: status);
    }
  }

  void _onBookAgainAppointment(AppointmentEntity appointment) {
    AppointmentDialogs.showInfoSnackBar(
      context,
      AppLocalizations.of(context).bookingFollowupAppointment,
    );
  }

  void _onScanQrCode(AppointmentEntity appointment) async {
    // Capture the cubit reference before navigation
    final cubit = context.read<AppointmentsCubit>();

    // Navigate to QR scanner screen
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: cubit,
          child: QrScannerScreen(appointment: appointment),
        ),
      ),
    );

    // If QR scan was successful, reload appointments
    if (result == true && mounted) {
      final status =
          _selectedFilter == 'All' ? null : _selectedFilter.toUpperCase();
      cubit.getFilteredAppointments(status: status);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppointmentsCubit, AppointmentsState>(
      listener: (context, state) {
        // Handle error states with snackbar
        if (state is AppointmentsError) {
          AppointmentDialogs.showErrorSnackBar(context, state.message);
        }
        // Handle success actions
        if (state is AppointmentActionSuccess) {
          if (state.action == 'cancel') {
            AppointmentDialogs.showSuccessSnackBar(
              context,
              AppLocalizations.of(context).appointmentCancelledSuccessfully,
            );

            // Reload the current filter immediately after successful cancellation
            final status =
                _selectedFilter == 'All' ? null : _selectedFilter.toUpperCase();
            context
                .read<AppointmentsCubit>()
                .getFilteredAppointments(status: status);
          } else if (state.action == 'complete-qr') {
            // Reload after QR completion
            final status =
                _selectedFilter == 'All' ? null : _selectedFilter.toUpperCase();
            context
                .read<AppointmentsCubit>()
                .getFilteredAppointments(status: status);
          }
        }
      },
      builder: (context, state) {
        return BaseScreen(
          navBarIndex: 1,
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).myActivity),
            centerTitle: true,
            elevation: 0,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).yourPetCareActivities,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  AppointmentFilterTabs(
                    selectedFilter: _selectedFilter,
                    onFilterChanged: _onFilterChanged,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _buildContent(state),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(AppointmentsState state) {
    if (state is AppointmentsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is AppointmentsLoaded) {
      if (state.appointments.isEmpty) {
        return _buildEmptyState();
      }

      return ListView.builder(
        itemCount: state.appointments.length,
        itemBuilder: (context, index) {
          final appointment = state.appointments[index];
          return AppointmentCard(
            appointment: appointment,
            onTap: () => _onAppointmentTap(appointment),
            onCancel: _onCancelAppointment,
            onReschedule: _onRescheduleAppointment,
            onReview: _onReviewAppointment,
            onBookAgain: _onBookAgainAppointment,
            onScanQr: _onScanQrCode,
          );
        },
      );
    }

    if (state is AppointmentActionLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Initial or unknown state
    return _buildEmptyState();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).noActivitiesFound,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).activitiesMatchingFilterWillAppearHere,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
