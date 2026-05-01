import 'package:flutter/material.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/features/appointments/domain/entities/appointment_entity.dart';
import 'package:petapp/features/appointments/domain/entities/appointment_entity_extensions.dart';
import 'package:petapp/features/appointments/utils/appointment_utils.dart';

class AppointmentDetailsModal extends StatelessWidget {
  final AppointmentEntity appointment;

  const AppointmentDetailsModal({
    super.key,
    required this.appointment,
  });

  static void show(BuildContext context, AppointmentEntity appointment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AppointmentDetailsModal(appointment: appointment),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[900] : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHandle(isDark),
              const SizedBox(height: 20),
              _buildHeader(context, isDark),
              const SizedBox(height: 24),
              Expanded(
                child: _buildDetails(context, scrollController, isDark),
              ),
              _buildActionButtons(context, isDark),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHandle(bool isDark) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[600] : Colors.grey[300],
          borderRadius: BorderRadius.circular(2),
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
          radius: 30,
          backgroundColor: AppointmentUtils.getStatusColor(effectiveStatus)
              .withValues(alpha: 0.2),
          child: Icon(
            AppointmentUtils.getAppointmentIcon(),
            color: AppointmentUtils.getStatusColor(effectiveStatus),
            size: 30,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appointment.vet?.branchName ?? 'Unknown Vet',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
              ),
              if (appointment.vet?.description != null)
                Text(
                  appointment.vet!.description!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetails(
      BuildContext context, ScrollController scrollController, bool isDark) {
    // Use effective status to handle expired appointments
    final effectiveStatus = appointment.effectiveStatus;
    final statusText = appointment.isExpired
        ? 'Cancelled (Expired)'
        : _getLocalizedStatus(context, effectiveStatus);

    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(
            context,
            AppLocalizations.of(context).status,
            statusText,
            isDark,
          ),
          _buildDetailRow(
            context,
            AppLocalizations.of(context).date,
            appointment.formattedDate,
            isDark,
          ),
          _buildDetailRow(
            context,
            AppLocalizations.of(context).time,
            appointment.getLocalizedTimeRange(
              Localizations.localeOf(context).languageCode,
            ),
            isDark,
          ),
          _buildDetailRow(
            context,
            AppLocalizations.of(context).service,
            appointment.reasonForVisit ?? 'N/A',
            isDark,
          ),
          _buildDetailRow(
            context,
            AppLocalizations.of(context).pet,
            appointment.pet?.name ?? 'N/A',
            isDark,
          ),
          _buildDetailRow(
            context,
            'Duration',
            '${(appointment.endTime.difference(appointment.startTime).inMinutes / 2).round()} mins',
            isDark,
          ),

          // Show pricing breakdown if there are discounts
          if (appointment.discount > 0 ||
              appointment.couponDiscount > 0 ||
              appointment.pointsDiscount > 0) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            _buildDetailRow(
              context,
              'Original Fee',
              AppointmentUtils.formatCurrency(appointment.consultationFee),
              isDark,
            ),
            if (appointment.discount > 0)
              _buildDetailRow(
                context,
                'Discount',
                '- ${AppointmentUtils.formatCurrency(appointment.discount)}',
                isDark,
                valueColor: Colors.green,
              ),
            if (appointment.couponDiscount > 0)
              _buildDetailRow(
                context,
                'Coupon Discount',
                '- ${AppointmentUtils.formatCurrency(appointment.couponDiscount)}',
                isDark,
                valueColor: Colors.green,
              ),
            if (appointment.pointsDiscount > 0)
              _buildDetailRow(
                context,
                'Points Discount',
                '- ${AppointmentUtils.formatCurrency(appointment.pointsDiscount)}',
                isDark,
                valueColor: Colors.green,
              ),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            _buildDetailRow(
              context,
              AppLocalizations.of(context).fee,
              AppointmentUtils.formatCurrency(appointment.finalAmount),
              isDark,
              valueColor: AppColors.orange,
              isBold: true,
            ),
          ] else
            _buildDetailRow(
              context,
              AppLocalizations.of(context).fee,
              AppointmentUtils.formatCurrency(appointment.finalAmount),
              isDark,
            ),

          if (appointment.pointsUsed > 0)
            _buildDetailRow(
              context,
              'Points Redeemed',
              '${appointment.pointsUsed} points',
              isDark,
            ),
          if (appointment.pointsEarned > 0)
            _buildDetailRow(
              context,
              'Points Earned',
              '${appointment.pointsEarned} points',
              isDark,
            ),
          if (appointment.reasonForVisit != null &&
              appointment.reasonForVisit!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context).notes,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                appointment.reasonForVisit!,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    bool isDark, {
    Color? valueColor,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                color: valueColor ?? (isDark ? Colors.white : Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: isDark ? Colors.white : Colors.black,
              side: BorderSide(
                color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
              ),
            ),
            child: Text(AppLocalizations.of(context).close),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to vet profile or contact
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              foregroundColor: Colors.white,
            ),
            child: Text(AppLocalizations.of(context).contactVet),
          ),
        ),
      ],
    );
  }

  String _getLocalizedStatus(BuildContext context, String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppLocalizations.of(context).pending;
      case 'confirmed':
        return AppLocalizations.of(context).confirmed;
      case 'upcoming':
        return AppLocalizations.of(context).upcoming;
      case 'completed':
        return AppLocalizations.of(context).completed;
      case 'cancelled':
        return AppLocalizations.of(context).cancelled;
      case 'rescheduled':
        return AppLocalizations.of(context).rescheduled;
      default:
        return status;
    }
  }
}
