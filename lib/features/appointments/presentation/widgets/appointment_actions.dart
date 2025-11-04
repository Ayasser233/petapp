import 'package:flutter/material.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/features/appointments/domain/entities/appointment_entity.dart';
import 'package:petapp/features/appointments/domain/entities/appointment_entity_extensions.dart';

class AppointmentActions extends StatelessWidget {
  final AppointmentEntity appointment;
  final Function(AppointmentEntity) onCancel;
  final Function(AppointmentEntity) onReschedule;
  final Function(AppointmentEntity) onReview;
  final Function(AppointmentEntity) onBookAgain;
  final Function(AppointmentEntity)? onScanQr;

  const AppointmentActions({
    super.key,
    required this.appointment,
    required this.onCancel,
    required this.onReschedule,
    required this.onReview,
    required this.onBookAgain,
    this.onScanQr,
  });

  @override
  Widget build(BuildContext context) {
    // Use effective status to handle expired appointments
    final effectiveStatus = appointment.effectiveStatus.toUpperCase();

    switch (effectiveStatus) {
      case 'PENDING':
        return _buildPendingActions(context);
      case 'CONFIRMED':
        return _buildConfirmedActions(context);
      case 'COMPLETED':
        return _buildCompletedActions(context);
      case 'CANCELLED':
        return _buildCancelledActions(context);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPendingActions(BuildContext context) {
    return OutlinedButton.icon(
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
    );
  }

  Widget _buildConfirmedActions(BuildContext context) {
    return Column(
      children: [
        // Scan QR button (primary action)
        if (onScanQr != null)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => onScanQr!(appointment),
              icon: const Icon(Icons.qr_code_scanner, size: 20),
              label: Text(AppLocalizations.of(context).scanQrToComplete),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        const SizedBox(height: 12),
        // Cancel button only
        OutlinedButton.icon(
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
    );
  }
}
