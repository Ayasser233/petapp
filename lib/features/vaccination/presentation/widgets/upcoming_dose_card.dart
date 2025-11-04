import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/vaccination_dose_entity.dart';
import '../cubit/vaccination_cubit.dart';

/// Upcoming Dose Card Widget
///
/// Displays an upcoming dose with action to mark complete
class UpcomingDoseCard extends StatelessWidget {
  final VaccinationDoseEntity dose;
  final String petId;

  const UpcomingDoseCard({
    Key? key,
    required this.dose,
    required this.petId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isOverdue = dose.nextDueDate != null &&
        dose.nextDueDate!.isBefore(DateTime.now()) &&
        !dose.isCompleted;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isOverdue ? Colors.red.shade50 : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon
            Icon(
              isOverdue ? Icons.warning : Icons.vaccines,
              color: isOverdue ? Colors.red : Colors.blue,
              size: 32,
            ),
            const SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${dose.vaccineType} - Dose ${dose.doseNumber}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (dose.administeredDate != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Administered: ${DateFormat('MMM dd, yyyy').format(dose.administeredDate!)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                  if (dose.nextDueDate != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${isOverdue ? 'Overdue' : 'Next Due'}: ${DateFormat('MMM dd, yyyy').format(dose.nextDueDate!)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isOverdue ? Colors.red : Colors.grey,
                          ),
                    ),
                  ],
                  if (dose.userMarkedCompleted) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'User Marked',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.blue.shade900,
                            ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Action Button
            if (!dose.isCompleted)
              IconButton(
                icon: const Icon(Icons.check_circle_outline),
                color: Colors.green,
                onPressed: () => _showMarkCompleteDialog(context),
              ),
          ],
        ),
      ),
    );
  }

  void _showMarkCompleteDialog(BuildContext context) {
    DateTime completedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Mark Schedule Complete'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Dose Info
              Text(
                '${dose.vaccineType} - Dose ${dose.doseNumber}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),

              // Completed Date
              ListTile(
                title: const Text('Completed Date'),
                subtitle:
                    Text(DateFormat('MMM dd, yyyy').format(completedDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: dialogContext,
                    initialDate: completedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      completedDate = picked;
                    });
                  }
                },
              ),
              const SizedBox(height: 8),

              // Info Text
              Text(
                'This will mark the vaccination schedule as completed.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: dose.seriesId == null
                  ? null
                  : () {
                      Navigator.of(dialogContext).pop();

                      // Call the cubit to mark dose complete
                      context.read<VaccinationCubit>().markDoseComplete(
                            seriesId: dose.seriesId!,
                            doseNumber: dose.doseNumber,
                            administeredAt: completedDate,
                          );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Dose marked as complete'),
                        ),
                      );

                      // Refresh medical sheet after a delay
                      Future.delayed(const Duration(milliseconds: 500), () {
                        context.read<VaccinationCubit>().getMedicalSheet(petId);
                      });
                    },
              child: const Text('Mark Complete'),
            ),
          ],
        ),
      ),
    );
  }
}
