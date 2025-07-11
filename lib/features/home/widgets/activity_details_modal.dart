import 'package:flutter/material.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import '../models/vet_activity.dart';
import '../utils/activity_utils.dart';

class ActivityDetailsModal extends StatelessWidget {
  final VetActivity activity;

  const ActivityDetailsModal({
    super.key,
    required this.activity,
  });

  static void show(BuildContext context, VetActivity activity) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ActivityDetailsModal(activity: activity),
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
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: ActivityUtils.getStatusColor(activity.status).withOpacity(0.2),
          child: Icon(
            ActivityUtils.getActivityIcon(activity.type),
            color: ActivityUtils.getStatusColor(activity.status),
            size: 30,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dr. ${activity.vetName}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
              ),
              Text(
                activity.clinicName,
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

  Widget _buildDetails(BuildContext context, ScrollController scrollController, bool isDark) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(
            context, 
            AppLocalizations.of(context).status, 
            _getLocalizedStatus(context, activity.status),
            isDark,
          ),
          _buildDetailRow(
            context,
            AppLocalizations.of(context).date,
            activity.appointmentDate,
            isDark,
          ),
          _buildDetailRow(
            context,
            AppLocalizations.of(context).time,
            activity.appointmentTime,
            isDark,
          ),
          _buildDetailRow(
            context,
            AppLocalizations.of(context).service,
             activity.serviceType,
            isDark,
          ),
          _buildDetailRow(
            context,
            AppLocalizations.of(context).pet,
            activity.petName!,
            isDark,
          ),
          _buildDetailRow(
            context,
            AppLocalizations.of(context).duration,
            activity.duration,
            isDark,
          ),
          _buildDetailRow(
            context,
            AppLocalizations.of(context).fee,
            ActivityUtils.formatCurrency(activity.fee),
            isDark,
          ),

          if (activity.notes.isNotEmpty) ...[
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
                activity.notes,
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

  Widget _buildDetailRow(BuildContext context, String label, String value, bool isDark) {
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
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : Colors.black,
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