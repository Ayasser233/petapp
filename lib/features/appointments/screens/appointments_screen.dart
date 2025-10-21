import 'package:flutter/material.dart';
import 'package:petapp/core/screens/base_screen.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/features/appointments/models/appointment_model.dart';
import 'package:petapp/features/appointments/services/appointment_service.dart';
import 'package:petapp/features/appointments/widgets/appointment_filter_tabs.dart';
import 'package:petapp/features/appointments/widgets/appointment_card.dart';
import 'package:petapp/features/appointments/widgets/appointment_details_modal.dart';
import 'package:petapp/features/appointments/widgets/appointment_dialogs.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final AppointmentService _appointmentService = AppointmentService();
  String _selectedFilter = 'All';
  List<AppointmentModel> _filteredAppointments = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final appointments =
          await _appointmentService.getFilteredAppointments(_selectedFilter);
      if (mounted) {
        setState(() {
          _filteredAppointments = appointments;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading appointments: $e');
      if (mounted) {
        setState(() {
          _filteredAppointments = [];
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _onFilterChanged(String filter) async {
    if (!mounted) return;

    setState(() {
      _selectedFilter = filter;
      _isLoading = true;
    });

    try {
      final appointments =
          await _appointmentService.getFilteredAppointments(filter);
      if (mounted) {
        setState(() {
          _filteredAppointments = appointments;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error filtering appointments: $e');
      if (mounted) {
        setState(() {
          _filteredAppointments = [];
          _isLoading = false;
        });
      }
    }
  }

  void _onAppointmentTap(AppointmentModel appointment) {
    AppointmentDetailsModal.show(context, appointment);
  }

  void _onCancelAppointment(AppointmentModel appointment) {
    AppointmentDialogs.showCancelDialog(
      context,
      appointment.vet?.branchName ?? 'Unknown Vet',
      () async {
        try {
          final success =
              await _appointmentService.cancelAppointment(appointment.id);
          if (success) {
            await _loadAppointments();
            if (mounted) {
              AppointmentDialogs.showSuccessSnackBar(
                context,
                AppLocalizations.of(context).appointmentCancelledSuccessfully,
              );
            }
          }
        } catch (e) {
          if (mounted) {
            AppointmentDialogs.showErrorSnackBar(
              context,
              AppLocalizations.of(context).failedToCancelAppointment,
            );
          }
        }
      },
    );
  }

  void _onRescheduleAppointment(AppointmentModel appointment) {
    AppointmentDialogs.showInfoSnackBar(
      context,
      AppLocalizations.of(context).rescheduleFeatureComingSoon,
    );
  }

  void _onReviewAppointment(AppointmentModel appointment) {
    AppointmentDialogs.showInfoSnackBar(
      context,
      AppLocalizations.of(context).reviewFeatureComingSoon,
    );
  }

  void _onBookAgainAppointment(AppointmentModel appointment) {
    AppointmentDialogs.showInfoSnackBar(
      context,
      AppLocalizations.of(context).bookingFollowupAppointment,
    );
  }

  @override
  Widget build(BuildContext context) {
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
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredAppointments.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            itemCount: _filteredAppointments.length,
                            itemBuilder: (context, index) {
                              final appointment = _filteredAppointments[index];
                              return AppointmentCard(
                                appointment: appointment,
                                onTap: () => _onAppointmentTap(appointment),
                                onCancel: _onCancelAppointment,
                                onReschedule: _onRescheduleAppointment,
                                onReview: _onReviewAppointment,
                                onBookAgain: _onBookAgainAppointment,
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
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
