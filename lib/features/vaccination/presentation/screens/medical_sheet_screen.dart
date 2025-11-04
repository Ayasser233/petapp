import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/medical_sheet_entity.dart';
import '../cubit/vaccination_cubit.dart';
import '../cubit/vaccination_state.dart';
import '../widgets/upcoming_dose_card.dart';

/// Medical Sheet Screen
///
/// Displays the complete vaccination medical sheet for a pet
class MedicalSheetScreen extends StatefulWidget {
  final String petId;
  final String petName;

  const MedicalSheetScreen({
    Key? key,
    required this.petId,
    required this.petName,
  }) : super(key: key);

  @override
  State<MedicalSheetScreen> createState() => _MedicalSheetScreenState();
}

class _MedicalSheetScreenState extends State<MedicalSheetScreen> {
  @override
  void initState() {
    super.initState();
    // Load medical sheet on screen init
    context.read<VaccinationCubit>().getMedicalSheet(widget.petId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.petName}\'s Medical Sheet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<VaccinationCubit>().getMedicalSheet(widget.petId);
            },
          ),
        ],
      ),
      body: BlocBuilder<VaccinationCubit, VaccinationState>(
        builder: (context, state) {
          if (state is VaccinationLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is VaccinationError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 60,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<VaccinationCubit>()
                          .getMedicalSheet(widget.petId);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is MedicalSheetLoaded) {
            return _buildMedicalSheet(state.medicalSheet);
          }

          return const Center(
            child: Text('No data available'),
          );
        },
      ),
    );
  }

  Widget _buildMedicalSheet(MedicalSheetEntity medicalSheet) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<VaccinationCubit>().getMedicalSheet(widget.petId);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pet Info Summary
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medicalSheet.pet.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${medicalSheet.pet.species} • ${medicalSheet.pet.breed}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Summary Stats
            if (medicalSheet.totalUpcomingDoses > 0 ||
                medicalSheet.totalAnnualBoosters > 0) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        context,
                        'Upcoming',
                        medicalSheet.totalUpcomingDoses.toString(),
                        Icons.schedule,
                        Colors.orange,
                      ),
                      _buildStatItem(
                        context,
                        'Boosters',
                        medicalSheet.totalAnnualBoosters.toString(),
                        Icons.vaccines,
                        Colors.blue,
                      ),
                      _buildStatItem(
                        context,
                        'Completed',
                        medicalSheet.completedSeries.length.toString(),
                        Icons.check_circle,
                        Colors.green,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Upcoming Doses
            if (medicalSheet.upcomingDoses.isNotEmpty) ...[
              Text(
                'Upcoming Doses',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              ...medicalSheet.upcomingDoses.map(
                (dose) => UpcomingDoseCard(
                  dose: dose,
                  petId: widget.petId,
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Annual Boosters
            if (medicalSheet.annualBoosters.isNotEmpty) ...[
              Text(
                'Annual Boosters',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              ...medicalSheet.annualBoosters.map(
                (booster) => _buildAnnualBoosterCard(context, booster),
              ),
              const SizedBox(height: 24),
            ],

            // In Progress Series
            if (medicalSheet.inProgressSeries.isNotEmpty) ...[
              Text(
                'In Progress Vaccinations',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              ...medicalSheet.inProgressSeries.map(
                (series) => _buildSeriesInfoCard(context, series),
              ),
              const SizedBox(height: 24),
            ],

            // Completed Series
            if (medicalSheet.completedSeries.isNotEmpty) ...[
              Text(
                'Completed Vaccinations',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              ...medicalSheet.completedSeries.map(
                (series) => _buildSeriesInfoCard(context, series),
              ),
            ],

            // Empty state
            if (medicalSheet.upcomingDoses.isEmpty &&
                medicalSheet.inProgressSeries.isEmpty &&
                medicalSheet.completedSeries.isEmpty &&
                medicalSheet.annualBoosters.isEmpty) ...[
              const SizedBox(height: 100),
              Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons.vaccines_outlined,
                      size: 80,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No vaccination records yet',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Start by adding a vaccination series',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildSeriesInfoCard(
      BuildContext context, VaccinationSeriesInfo series) {
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
                _buildSeriesStatusChip(context, series.status),
              ],
            ),
            const SizedBox(height: 12),

            // Progress
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: series.completedDoses / series.totalDoses,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      series.isComplete ? Colors.green : Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${series.completedDoses}/${series.totalDoses}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Doses
            ...series.doses.map((dose) => _buildDoseItem(context, dose)),

            // Annual Booster Date
            if (series.annualBoosterDate != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.event, size: 16, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      'Annual Booster: ${DateFormat('MMM dd, yyyy').format(DateTime.parse(series.annualBoosterDate!))}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDoseItem(BuildContext context, DoseInfoEntity dose) {
    Color statusColor;
    IconData statusIcon;

    switch (dose.status.toUpperCase()) {
      case 'COMPLETED':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'PENDING':
        statusColor = Colors.orange;
        statusIcon = Icons.schedule;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.radio_button_unchecked;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 20),
          const SizedBox(width: 8),
          Text(
            'Dose ${dose.doseNumber}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Spacer(),
          if (dose.administeredDate != null)
            Text(
              DateFormat('MMM dd, yyyy')
                  .format(DateTime.parse(dose.administeredDate!)),
              style: Theme.of(context).textTheme.bodySmall,
            )
          else
            Text(
              'Not yet administered',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
            ),
        ],
      ),
    );
  }

  Widget _buildAnnualBoosterCard(
      BuildContext context, AnnualBoosterEntity booster) {
    final dueDate = DateTime.parse(booster.dueDate);
    final isOverdue = booster.isOverdue;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isOverdue ? Colors.red.withOpacity(0.1) : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.vaccines,
              color: isOverdue ? Colors.red : Colors.blue,
              size: 32,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booster.vaccineType,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Due: ${DateFormat('MMM dd, yyyy').format(dueDate)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (isOverdue)
                    const Text(
                      'OVERDUE',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeriesStatusChip(BuildContext context, String status) {
    Color color;
    String label;

    switch (status.toUpperCase()) {
      case 'COMPLETED':
        color = Colors.green;
        label = 'Completed';
        break;
      case 'IN-PROGRESS':
        color = Colors.blue;
        label = 'In Progress';
        break;
      case 'CANCELLED':
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
