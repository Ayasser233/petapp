import 'package:flutter/material.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/features/appointments/models/appointment_model.dart';

class AppointmentActions extends StatelessWidget {
  final AppointmentModel appointment;
  final Function(AppointmentModel) onCancel;
  final Function(AppointmentModel) onReschedule;
  final Function(AppointmentModel) onReview;
  final Function(AppointmentModel) onBookAgain;

  const AppointmentActions({
    super.key,
    required this.appointment,
    required this.onCancel,
    required this.onReschedule,
    required this.onReview,
    required this.onBookAgain,
  });

  @override
  Widget build(BuildContext context) {
    switch (appointment.status.toUpperCase()) {
      case 'PENDING':
      case 'CONFIRMED':
        return _buildUpcomingActions(context);
      case 'COMPLETED':
        return _buildCompletedActions(context);
      case 'CANCELLED':
        return _buildCancelledActions(context);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildUpcomingActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => onCancel(appointment),
            icon: const Icon(Icons.close, size: 18),
            label: Text(AppLocalizations.of(context).cancel),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => onReschedule(appointment),
            icon: const Icon(Icons.edit_calendar, size: 18),
            label: Text(AppLocalizations.of(context).reschedule),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompletedActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => onReview(appointment),
            icon: const Icon(Icons.star_outline, size: 18),
            label: Text(AppLocalizations.of(context).leaveReview),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.orange,
              side: const BorderSide(color: AppColors.orange),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => onBookAgain(appointment),
            icon: const Icon(Icons.add, size: 18),
            label: Text(AppLocalizations.of(context).bookAgain),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCancelledActions(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => onBookAgain(appointment),
        icon: const Icon(Icons.refresh, size: 18),
        label: Text(AppLocalizations.of(context).bookAgain),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.orange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}