import 'package:flutter/material.dart';
import 'package:petapp/core/utils/app_colors.dart';
import '../models/vet_activity.dart';

class ActivityActions extends StatelessWidget {
  final VetActivity activity;
  final Function(VetActivity) onCancel;
  final Function(VetActivity) onReschedule;
  final Function(VetActivity) onReview;
  final Function(VetActivity) onBookAgain;

  const ActivityActions({
    super.key,
    required this.activity,
    required this.onCancel,
    required this.onReschedule,
    required this.onReview,
    required this.onBookAgain,
  });

  @override
  Widget build(BuildContext context) {
    switch (activity.status.toLowerCase()) {
      case 'upcoming':
        return _buildUpcomingActions();
      case 'completed':
        return _buildCompletedActions();
      case 'cancelled':
        return _buildCancelledActions();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildUpcomingActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => onCancel(activity),
            icon: const Icon(Icons.close, size: 18),
            label: const Text('Cancel'),
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
            onPressed: () => onReschedule(activity),
            icon: const Icon(Icons.edit_calendar, size: 18),
            label: const Text('Reschedule'),
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

  Widget _buildCompletedActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => onReview(activity),
            icon: const Icon(Icons.star_outline, size: 18),
            label: const Text('Leave Review'),
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
            onPressed: () => onBookAgain(activity),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Book Again'),
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

  Widget _buildCancelledActions() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => onBookAgain(activity),
        icon: const Icon(Icons.refresh, size: 18),
        label: const Text('Book Again'),
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