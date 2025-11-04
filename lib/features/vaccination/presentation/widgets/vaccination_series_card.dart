import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/vaccination_series_entity.dart';

/// Vaccination Series Card Widget
///
/// Displays a vaccination series with its progress
class VaccinationSeriesCard extends StatelessWidget {
  final VaccinationSeriesEntity series;
  final bool isPending;

  const VaccinationSeriesCard({
    Key? key,
    required this.series,
    required this.isPending,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    series.vaccineType,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                _buildStatusChip(context),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Series ID: ${series.id}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 12),

            // Completion Status
            Row(
              children: [
                Icon(
                  series.isComplete
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  size: 20,
                  color: series.isComplete ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  series.isComplete ? 'Series Completed' : 'Series In Progress',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Dates
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Created: ${DateFormat('MMM dd, yyyy').format(series.createdAt)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (series.completedAt != null)
                  Text(
                    'Completed: ${DateFormat('MMM dd, yyyy').format(series.completedAt!)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.green,
                        ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Pet ID: ${series.petId}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    Color color;
    String label;

    switch (series.status.toLowerCase()) {
      case 'completed':
        color = Colors.green;
        label = 'Completed';
        break;
      case 'in-progress':
        color = Colors.blue;
        label = 'In Progress';
        break;
      case 'cancelled':
        color = Colors.red;
        label = 'Cancelled';
        break;
      default:
        color = Colors.grey;
        label = 'Pending';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
