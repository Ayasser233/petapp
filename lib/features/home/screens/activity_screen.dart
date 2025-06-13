import 'package:flutter/material.dart';
import 'package:petapp/core/screens/base_screen.dart';
import '../models/vet_activity.dart';
import '../services/activity_service.dart';
import '../widgets/activity_filter_tabs.dart';
import '../widgets/activity_card.dart';
import '../widgets/activity_details_modal.dart';
import '../widgets/activity_dialogs.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  final ActivityService _activityService = ActivityService();
  String _selectedFilter = 'All';
  List<VetActivity> _filteredActivities = [];

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  void _loadActivities() {
    setState(() {
      _filteredActivities = _activityService.getFilteredActivities(_selectedFilter);
    });
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
      _filteredActivities = _activityService.getFilteredActivities(filter);
    });
  }

  void _onActivityTap(VetActivity activity) {
    ActivityDetailsModal.show(context, activity);
  }

  void _onCancelActivity(VetActivity activity) {
    ActivityDialogs.showCancelDialog(
      context,
      activity.vetName,
      () async {
        try {
          await _activityService.cancelActivity(activity.id);
          _loadActivities();
          if (mounted) {
            ActivityDialogs.showSuccessSnackBar(
              context,
              'Appointment cancelled successfully',
            );
          }
        } catch (e) {
          if (mounted) {
            ActivityDialogs.showErrorSnackBar(
              context,
              'Failed to cancel appointment',
            );
          }
        }
      },
    );
  }

  void _onRescheduleActivity(VetActivity activity) {
    ActivityDialogs.showInfoSnackBar(context, 'Reschedule feature coming soon!');
  }

  void _onReviewActivity(VetActivity activity) {
    ActivityDialogs.showInfoSnackBar(context, 'Review feature coming soon!');
  }

  void _onBookAgainActivity(VetActivity activity) {
    ActivityDialogs.showInfoSnackBar(context, 'Booking follow-up appointment...');
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      navBarIndex: 1,
      appBar: AppBar(
        title: const Text('My Activity'),
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
                'Your Pet Care Activities',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              ActivityFilterTabs(
                selectedFilter: _selectedFilter,
                onFilterChanged: _onFilterChanged,
              ),
              const SizedBox(height: 16),
              
              Expanded(
                child: _filteredActivities.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        itemCount: _filteredActivities.length,
                        itemBuilder: (context, index) {
                          final activity = _filteredActivities[index];
                          return ActivityCard(
                            activity: activity,
                            onTap: () => _onActivityTap(activity),
                            onCancel: _onCancelActivity,
                            onReschedule: _onRescheduleActivity,
                            onReview: _onReviewActivity,
                            onBookAgain: _onBookAgainActivity,
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
            'No activities found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Activities matching your filter will appear here',
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