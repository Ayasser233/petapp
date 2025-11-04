import 'package:flutter/material.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/features/appointments/domain/entities/appointment_entity.dart';
import 'package:petapp/features/appointments/domain/entities/appointment_entity_extensions.dart';
import 'package:petapp/features/appointments/utils/appointment_utils.dart';
import 'appointment_actions.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentEntity appointment;
  final VoidCallback onTap;
  final Function(AppointmentEntity) onCancel;
  final Function(AppointmentEntity) onReschedule;
  final Function(AppointmentEntity) onReview;
  final Function(AppointmentEntity) onBookAgain;
  final Function(AppointmentEntity)? onScanQr;

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.onTap,
    required this.onCancel,
    required this.onReschedule,
    required this.onReview,
    required this.onBookAgain,
    this.onScanQr,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: isDark ? 4 : 2,
      shadowColor: isDark
          ? Colors.black.withValues(alpha: 0.5)
          : Colors.grey.withValues(alpha: 0.3),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, isDark),
              const SizedBox(height: 16),
              _buildAppointmentDetails(context, isDark),
              const SizedBox(height: 12),
              _buildServiceInfo(context, isDark),
              const SizedBox(height: 16),
              AppointmentActions(
                appointment: appointment,
                onCancel: onCancel,
                onReschedule: onReschedule,
                onReview: onReview,
                onBookAgain: onBookAgain,
                onScanQr: onScanQr,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    // Use effective status to handle expired appointments
    final effectiveStatus = appointment.effectiveStatus;

    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: AppointmentUtils.getStatusColor(effectiveStatus)
              .withValues(alpha: 0.2),
          child: Icon(
            AppointmentUtils.getAppointmentIcon(),
            color: AppointmentUtils.getStatusColor(effectiveStatus),
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appointment.vet?.branchName ?? 'Unknown Vet',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                appointment.vet?.description ?? '',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppointmentUtils.getStatusColor(effectiveStatus)
                .withValues(alpha: isDark ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppointmentUtils.getStatusColor(effectiveStatus)
                  .withValues(alpha: isDark ? 0.5 : 0.3),
            ),
          ),
          child: Text(
            appointment.isExpired
                ? 'Cancelled (Expired)'
                : _getLocalizedStatus(context, effectiveStatus),
            style: TextStyle(
              color: AppointmentUtils.getStatusColor(effectiveStatus),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppointmentDetails(BuildContext context, bool isDark) {
    return Row(
      children: [
        Icon(
          Icons.calendar_today,
          size: 16,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Text(
          appointment.formattedDate,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : Colors.black87,
              ),
        ),
        const SizedBox(width: 20),
        Icon(
          Icons.access_time,
          size: 16,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Text(
          appointment.getLocalizedTimeRange(
            Localizations.localeOf(context).languageCode,
          ),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : Colors.black87,
              ),
        ),
      ],
    );
  }

  Widget _buildServiceInfo(BuildContext context, bool isDark) {
    return Row(
      children: [
        Icon(
          Icons.payments,
          size: 16,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            AppointmentUtils.formatCurrency(appointment.finalAmount),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        if (appointment.pointsUsed > 0) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: isDark ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star,
                  size: 14,
                  color: Colors.green[700],
                ),
                const SizedBox(width: 4),
                Text(
                  '${appointment.pointsUsed}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.green[700],
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ],
        if (appointment.pet != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.orange.withValues(alpha: isDark ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              appointment.pet!.name,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.orange,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ],
    );
  }

  String _getLocalizedStatus(BuildContext context, String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return AppLocalizations.of(context).pending;
      case 'CONFIRMED':
        return AppLocalizations.of(context).confirmed;
      case 'COMPLETED':
        return AppLocalizations.of(context).completed;
      case 'CANCELLED':
        return AppLocalizations.of(context).cancelled;
      default:
        return AppointmentUtils.getStatusDisplay(status);
    }
  }
}
