import 'package:flutter/material.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import '../models/vet_activity.dart';
import '../utils/activity_utils.dart';
import 'activity_actions.dart';

class ActivityCard extends StatelessWidget {
  final VetActivity activity;
  final VoidCallback onTap;
  final Function(VetActivity) onCancel;
  final Function(VetActivity) onReschedule;
  final Function(VetActivity) onReview;
  final Function(VetActivity) onBookAgain;

  const ActivityCard({
    super.key,
    required this.activity,
    required this.onTap,
    required this.onCancel,
    required this.onReschedule,
    required this.onReview,
    required this.onBookAgain,
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
      shadowColor: isDark ? Colors.black.withValues(alpha: 0.5) : Colors.grey.withValues(alpha: 0.3),
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
              ActivityActions(
                activity: activity,
                onCancel: onCancel,
                onReschedule: onReschedule,
                onReview: onReview,
                onBookAgain: onBookAgain,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: ActivityUtils.getStatusColor(activity.status).withValues(alpha: 0.2),
          child: Icon(
            ActivityUtils.getActivityIcon(activity.type),
            color: ActivityUtils.getStatusColor(activity.status),
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dr. ${activity.vetName}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                activity.clinicName,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: ActivityUtils.getStatusColor(activity.status).withValues(alpha: isDark ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: ActivityUtils.getStatusColor(activity.status).withValues(alpha: isDark ? 0.5 : 0.3),
            ),
          ),
          child: Text(
            _getLocalizedStatus(context, activity.status),
            style: TextStyle(
              color: ActivityUtils.getStatusColor(activity.status),
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
          activity.appointmentDate,
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
          activity.appointmentTime,
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
          Icons.medical_services,
          size: 16,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            activity.serviceType,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark ? Colors.white : Colors.black87,
                ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.orange.withValues(alpha: isDark ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            activity.petName!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.orange,
                  fontWeight: FontWeight.bold,
                ),
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