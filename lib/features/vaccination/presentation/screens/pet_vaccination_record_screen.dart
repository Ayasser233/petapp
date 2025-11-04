import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/features/pet/models/pet_model.dart';
import '../cubit/vaccination_cubit.dart';
import '../cubit/vaccination_state.dart';
import 'add_vaccination_screen.dart';

/// Pet Vaccination Record Screen
///
/// Displays vaccination record for a specific pet
/// Shows completed doses and upcoming doses with ability to add new vaccines
class PetVaccinationRecordScreen extends StatefulWidget {
  final PetModel pet;

  const PetVaccinationRecordScreen({
    super.key,
    required this.pet,
  });

  @override
  State<PetVaccinationRecordScreen> createState() =>
      _PetVaccinationRecordScreenState();
}

class _PetVaccinationRecordScreenState
    extends State<PetVaccinationRecordScreen> {
  // Track which series cards are expanded
  final Set<String> _expandedSeriesIds = {};
  // Track which booster cards are expanded
  final Set<String> _expandedBoosterIds = {};
  // Track which category cards are expanded
  final Set<String> _expandedCategoryIds = {};

  @override
  void initState() {
    super.initState();
    // Load vaccination data for this pet
    context.read<VaccinationCubit>().getMedicalSheet(widget.pet.id);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final backgroundColor = isDark ? Colors.grey[900] : Colors.grey[50];
    final cardColor = isDark ? Colors.grey[850] : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          '${widget.pet.name} - Vaccination Record',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: cardColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<VaccinationCubit>().getMedicalSheet(widget.pet.id);
            },
          ),
        ],
      ),
      body: BlocConsumer<VaccinationCubit, VaccinationState>(
        listener: (context, state) {
          if (state is DoseMarkedComplete) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✓ Dose marked as complete!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
            // Refresh medical sheet after successful completion
            context.read<VaccinationCubit>().getMedicalSheet(widget.pet.id);
          } else if (state is VaccinationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 4),
                action: SnackBarAction(
                  label: 'Dismiss',
                  textColor: Colors.white,
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                ),
              ),
            );
            // Refresh to show current state
            context.read<VaccinationCubit>().getMedicalSheet(widget.pet.id);
          }
        },
        builder: (context, state) {
          if (state is VaccinationLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.orange),
            );
          }

          if (state is VaccinationError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  const Text(
                    'Error Loading Vaccination Record',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<VaccinationCubit>()
                          .getMedicalSheet(widget.pet.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is MedicalSheetLoaded) {
            final medicalSheet = state.medicalSheet;

            // Auto-expand all categories on first load
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && _expandedCategoryIds.isEmpty) {
                setState(() {
                  _expandedCategoryIds
                      .addAll(['VIRUS', 'WORMS', 'INSECTS', 'RABIES']);
                });
              }
            });

            return RefreshIndicator(
              color: AppColors.orange,
              onRefresh: () async {
                context.read<VaccinationCubit>().getMedicalSheet(widget.pet.id);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Pet Info Card
                      _buildPetInfoCardFromMedicalSheet(
                          medicalSheet, isDark, cardColor),

                      const SizedBox(height: 24),

                      // Add Vaccine Button
                      _buildAddVaccineButton(context, isDark),

                      const SizedBox(height: 24),

                      // Vaccination Summary
                      _buildVaccinationSummary(
                        context,
                        medicalSheet.completedDosesCount,
                        medicalSheet.totalUpcomingDoses,
                        medicalSheet.totalAnnualBoosters,
                        isDark,
                        cardColor,
                      ),

                      const SizedBox(height: 24),

                      // Virus Vaccine Protection Status
                      _buildVirusVaccineStatus(
                        context,
                        medicalSheet.vaccinationSeries,
                        isDark,
                        cardColor,
                      ),

                      const SizedBox(height: 24),

                      // Missing Vaccine Type Warnings
                      ..._buildMissingVaccineWarnings(
                        context,
                        medicalSheet.vaccinationSeries,
                        isDark,
                        cardColor,
                      ),

                      // Vaccination Records by Category
                      if (medicalSheet.vaccinationSeries.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildSectionTitle(
                            context, 'Vaccination Records', isDark),
                        const SizedBox(height: 12),
                        ..._buildCategoryCards(
                          context,
                          medicalSheet.vaccinationSeries,
                          isDark,
                          cardColor,
                        ),
                      ],

                      // Annual Boosters Section
                      if (medicalSheet.annualBoosters.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        _buildSectionTitle(context, 'Annual Boosters', isDark),
                        const SizedBox(height: 12),
                        ...medicalSheet.annualBoosters
                            .map((booster) => _buildAnnualBoosterCard(
                                  context,
                                  booster,
                                  isDark,
                                  cardColor,
                                )),
                      ],

                      // Empty State
                      if (medicalSheet.vaccinationSeries.isEmpty)
                        _buildEmptyState(context, isDark, cardColor),
                    ],
                  ),
                ),
              ),
            );
          }

          // Initial state or other states
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.vaccines_outlined,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No vaccination data',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPetInfoCardFromMedicalSheet(
    dynamic medicalSheet,
    bool isDark,
    Color? cardColor,
  ) {
    final pet = medicalSheet.pet;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.grey.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Pet Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.orange.withValues(alpha: 0.1),
            ),
            child: const Icon(Icons.pets, color: AppColors.orange, size: 30),
          ),
          const SizedBox(width: 16),
          // Pet Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pet.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${pet.species} • ${pet.breed}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '${pet.gender} • ${pet.weight}kg',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddVaccineButton(BuildContext context, bool isDark) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          final cubit = context.read<VaccinationCubit>();
          final result = await Get.to(() => BlocProvider.value(
                value: cubit,
                child: AddVaccinationScreen(
                  petId: widget.pet.id,
                  petName: widget.pet.name,
                  petSpecies: widget.pet.species,
                ),
              ));

          // Refresh medical sheet if vaccination was added
          if (result == true && mounted) {
            cubit.getMedicalSheet(widget.pet.id);
          }
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Vaccine',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.orange,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildVirusVaccineStatus(
    BuildContext context,
    List<dynamic> vaccinationSeries,
    bool isDark,
    Color? cardColor,
  ) {
    // Check for virus vaccines
    final virusVaccines = vaccinationSeries
        .where((series) => _isVirusVaccine(series.vaccineType))
        .toList();

    String? statusMessage;
    Color? statusColor;
    IconData? statusIcon;

    if (virusVaccines.isEmpty) {
      // No virus vaccines at all
      statusMessage = 'Not protected. Start the virus vaccine soon';
      statusColor = Colors.red;
      statusIcon = Icons.warning_amber;
    } else {
      // Check if any virus vaccine is complete
      final hasCompleteVirusVaccine =
          virusVaccines.any((series) => series.isComplete);

      if (hasCompleteVirusVaccine) {
        statusMessage = 'Fully protected. Follow booster schedule to stay safe';
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
      }
    }

    // Only show if we have a status message
    if (statusMessage == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor!.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              statusMessage,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVaccinationSummary(
    BuildContext context,
    int completed,
    int upcoming,
    int overdue,
    bool isDark,
    Color? cardColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.grey.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem(
              'Completed', completed, Colors.green, Icons.check_circle),
          _buildSummaryItem('Upcoming', upcoming, Colors.blue, Icons.schedule),
          _buildSummaryItem('Overdue', overdue, Colors.red, Icons.warning),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
      String label, int count, Color color, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, bool isDark) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
    );
  }

  Widget _buildVaccinationSeriesCard(
    BuildContext context,
    dynamic series,
    bool isDark,
    Color? cardColor,
  ) {
    final isExpanded = _expandedSeriesIds.contains(series.seriesId);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.grey.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with vaccine type and status (clickable)
          InkWell(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedSeriesIds.remove(series.seriesId);
                } else {
                  _expandedSeriesIds.add(series.seriesId);
                }
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: series.isComplete
                    ? Colors.green.withValues(alpha: 0.1)
                    : AppColors.orange.withValues(alpha: 0.1),
                borderRadius: isExpanded
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      )
                    : BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(
                    series.isComplete ? Icons.check_circle : Icons.vaccines,
                    color: series.isComplete ? Colors.green : AppColors.orange,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatVaccineName(series.vaccineType),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${series.completedDoses}/${series.totalDoses} doses completed',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color:
                          series.isComplete ? Colors.green : AppColors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      series.status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey[600],
                    size: 28,
                  ),
                ],
              ),
            ),
          ),

          // Prepare data for both collapsed and expanded views
          Builder(
            builder: (context) {
              // Generate virtual doses for uncompleted ones
              // Backend only returns completed doses, we need to create placeholders
              final List<int> uncompletedDoseNumbers = [];

              // Find which dose numbers are missing
              for (int i = 1; i <= series.totalDoses; i++) {
                final hasThisDose =
                    series.doses.any((dose) => dose.doseNumber == i);
                if (!hasThisDose) {
                  uncompletedDoseNumbers.add(i);
                }
              }

              // Check vaccine type
              final isVirusVaccine = _isVirusVaccine(series.vaccineType);
              final isWormsVaccine = _isWormsVaccine(series.vaccineType);
              final isInsectsVaccine = _isInsectsVaccine(series.vaccineType);
              final isRabiesVaccine = _isRabiesVaccine(series.vaccineType);

              // Determine which message to show based on completed doses
              final completedDosesCount = series.completedDoses;
              String? statusMessage;
              DateTime? nextDoseDate;

              if (isVirusVaccine && uncompletedDoseNumbers.isNotEmpty) {
                if (completedDosesCount == 0) {
                  statusMessage = 'Not protected. Start the virus vaccine soon';
                } else if (completedDosesCount == 1) {
                  statusMessage =
                      'Protection incomplete. Second dose needed to activate immunity';
                  if (series.doses.isNotEmpty) {
                    nextDoseDate =
                        DateTime.parse(series.doses.first.administeredDate!)
                            .add(const Duration(days: 21));
                  }
                } else if (completedDosesCount == 2) {
                  statusMessage =
                      'Protected. Third dose gives strongest immunity';
                  if (series.doses.length >= 2) {
                    nextDoseDate =
                        DateTime.parse(series.doses.last.administeredDate!)
                            .add(const Duration(days: 21));
                  }
                } else if (completedDosesCount >= 3) {
                  statusMessage =
                      'Fully protected. Follow booster schedule to stay safe';
                }
              } else if (isWormsVaccine && uncompletedDoseNumbers.isNotEmpty) {
                if (completedDosesCount == 0) {
                  statusMessage =
                      'Not protected from worms. Start deworming soon';
                } else if (completedDosesCount == 1) {
                  statusMessage = 'Second dose required for full deworming';
                  if (series.doses.isNotEmpty) {
                    nextDoseDate =
                        DateTime.parse(series.doses.first.administeredDate!)
                            .add(const Duration(days: 21));
                  }
                } else if (completedDosesCount >= 2) {
                  statusMessage =
                      'Treatment complete! Your pet is now protected';
                }
              } else if (isInsectsVaccine) {
                // Insects vaccines are single-dose
                if (completedDosesCount == 0) {
                  statusMessage =
                      'Not protected from fleas or ticks. Start soon';
                } else {
                  statusMessage =
                      'Protection active. Repeat on schedule to stay safe';
                }
              } else if (isRabiesVaccine) {
                // Rabies vaccines are single-dose
                if (completedDosesCount == 0) {
                  statusMessage =
                      "Your pet isn't protected from rabies. Vaccinate soon";
                } else {
                  statusMessage =
                      'Protected from rabies. Repeat yearly to stay safe';
                }
              }

              return Column(
                children: [
                  // Collapsed view - show next dose date
                  if (!isExpanded && !series.isComplete)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        children: [
                          // Show next dose date in collapsed view
                          if (nextDoseDate != null) ...[
                            Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.blue.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color: Colors.blue[700],
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Next dose: ${DateFormat('MMM dd, yyyy').format(nextDoseDate)}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          ...uncompletedDoseNumbers.map(
                            (doseNumber) => _buildCompactDoseItemForPending(
                              context,
                              series.seriesId,
                              doseNumber,
                              series.doses,
                              isDark,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Expanded view - show status warning message and doses timeline
                  if (isExpanded)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Show status warning message in expanded view
                          if (statusMessage != null) ...[
                            Builder(
                              builder: (context) {
                                // Determine if complete based on vaccine type
                                final bool isComplete;
                                if (isInsectsVaccine || isRabiesVaccine) {
                                  // Single-dose vaccines: complete if any dose taken
                                  isComplete = completedDosesCount >= 1;
                                } else if (isWormsVaccine) {
                                  // Worms: complete at 2 doses
                                  isComplete = completedDosesCount >= 2;
                                } else {
                                  // Virus: complete at 3 doses
                                  isComplete = completedDosesCount >= 3;
                                }

                                final statusColor = completedDosesCount == 0
                                    ? Colors.red
                                    : isComplete
                                        ? Colors.green
                                        : Colors.orange;

                                final statusIcon = completedDosesCount == 0
                                    ? Icons.warning_amber
                                    : isComplete
                                        ? Icons.check_circle
                                        : Icons.info_outline;

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: statusColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: statusColor.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        statusIcon,
                                        color: statusColor[700],
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          statusMessage!,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: statusColor[700],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                          ...List.generate(series.totalDoses, (index) {
                            final doseNumber = index + 1;
                            // Find if this dose exists in completed doses
                            final matchingDoses = series.doses
                                .where((d) => d.doseNumber == doseNumber);
                            final completedDose = matchingDoses.isNotEmpty
                                ? matchingDoses.first
                                : null;
                            final isLast = index == series.totalDoses - 1;

                            final isCompleted = completedDose != null;

                            return Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Timeline indicator
                                    Column(
                                      children: [
                                        Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: isCompleted
                                                ? Colors.green
                                                : Colors.grey[300],
                                            border: Border.all(
                                              color: isCompleted
                                                  ? Colors.green
                                                  : Colors.grey[400]!,
                                              width: 2,
                                            ),
                                          ),
                                          child: isCompleted
                                              ? const Icon(
                                                  Icons.check,
                                                  size: 14,
                                                  color: Colors.white,
                                                )
                                              : null,
                                        ),
                                        if (!isLast)
                                          Container(
                                            width: 2,
                                            height: 40,
                                            color: Colors.grey[300],
                                          ),
                                      ],
                                    ),
                                    const SizedBox(width: 12),

                                    // Dose info
                                    Expanded(
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 16),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: isCompleted
                                              ? Colors.green
                                                  .withValues(alpha: 0.05)
                                              : Colors.grey
                                                  .withValues(alpha: 0.05),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: isCompleted
                                                ? Colors.green
                                                    .withValues(alpha: 0.2)
                                                : Colors.grey
                                                    .withValues(alpha: 0.2),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Dose $doseNumber',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                if (isCompleted)
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: const Text(
                                                      'COMPLETED',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            if (completedDose
                                                    ?.administeredDate !=
                                                null) ...[
                                              const SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.calendar_today,
                                                    size: 14,
                                                    color: Colors.grey[600],
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    DateFormat('MMM dd, yyyy')
                                                        .format(
                                                      DateTime.parse(
                                                          completedDose!
                                                              .administeredDate!),
                                                    ),
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                            // Mark Complete Button for incomplete doses
                                            if (!isCompleted) ...[
                                              const SizedBox(height: 12),
                                              SizedBox(
                                                width: double.infinity,
                                                child: ElevatedButton.icon(
                                                  onPressed: () {
                                                    _showMarkDoseCompleteDialog(
                                                      context,
                                                      series.seriesId,
                                                      doseNumber,
                                                      series.doses,
                                                    );
                                                  },
                                                  icon: const Icon(Icons.check,
                                                      size: 16),
                                                  label: const Text(
                                                      'Mark as Complete'),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        AppColors.orange,
                                                    foregroundColor:
                                                        Colors.white,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 8,
                                                      horizontal: 12,
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // Compact dose item shown when card is collapsed
  // Compact dose item for pending doses (not yet in backend)
  Widget _buildCompactDoseItemForPending(
    BuildContext context,
    String seriesId,
    int doseNumber,
    List<dynamic> completedDoses,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.orange.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          // Dose indicator
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.orange.withValues(alpha: 0.1),
              border: Border.all(
                color: AppColors.orange.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                '$doseNumber',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.orange,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Dose info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dose $doseNumber',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Not yet administered',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Mark complete button
          ElevatedButton.icon(
            onPressed: () {
              _showMarkDoseCompleteDialog(
                context,
                seriesId,
                doseNumber,
                completedDoses,
              );
            },
            icon: const Icon(Icons.check, size: 16),
            label: const Text('Mark'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnualBoosterCard(
    BuildContext context,
    dynamic booster,
    bool isDark,
    Color? cardColor,
  ) {
    final dueDate = DateTime.parse(booster.dueDate);
    final isOverdue = booster.isOverdue;
    final isExpanded = _expandedBoosterIds.contains(booster.seriesId);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOverdue
              ? Colors.red.withValues(alpha: 0.3)
              : AppColors.orange.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          // Main header (clickable)
          InkWell(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedBoosterIds.remove(booster.seriesId);
                } else {
                  _expandedBoosterIds.add(booster.seriesId);
                }
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isOverdue
                          ? Colors.red.withValues(alpha: 0.1)
                          : AppColors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isOverdue ? Icons.warning : Icons.schedule,
                      color: isOverdue ? Colors.red : AppColors.orange,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatVaccineName(booster.vaccineType),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Due: ${DateFormat('MMM dd, yyyy').format(dueDate)}',
                              style: TextStyle(
                                fontSize: 13,
                                color:
                                    isOverdue ? Colors.red : Colors.grey[600],
                                fontWeight: isOverdue
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (isOverdue)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'OVERDUE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey[600],
                    size: 24,
                  ),
                ],
              ),
            ),
          ),

          // Expanded details
          if (isExpanded)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const SizedBox(height: 8),

                  // Series ID
                  Row(
                    children: [
                      Icon(Icons.qr_code, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text(
                        'Series ID: ${booster.seriesId}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Action button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implement mark as complete
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Mark booster complete feature coming soon'),
                            backgroundColor: AppColors.orange,
                          ),
                        );
                      },
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('Mark as Complete'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isOverdue ? Colors.red : AppColors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark, Color? cardColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.vaccines_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Vaccination Records',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your pet\'s first vaccine to get started',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  // Build category cards organizing vaccines by type
  List<Widget> _buildCategoryCards(
    BuildContext context,
    List<dynamic> allSeries,
    bool isDark,
    Color? cardColor,
  ) {
    // Group series by category
    final Map<String, List<dynamic>> categorizedSeries = {
      'VIRUS': [],
      'WORMS': [],
      'INSECTS': [],
      'RABIES': [],
    };

    for (var series in allSeries) {
      final vaccineType = series.vaccineType.toUpperCase();
      if (vaccineType.contains('MONOVALENT') ||
          vaccineType.contains('BIVALENT') ||
          vaccineType.contains('PENTAVALENT') ||
          vaccineType.contains('HEPTAVALENT') ||
          vaccineType.contains('OCTAVALENT')) {
        categorizedSeries['VIRUS']!.add(series);
      } else if (vaccineType.contains('WORMS')) {
        categorizedSeries['WORMS']!.add(series);
      } else if (vaccineType.contains('INSECTS')) {
        categorizedSeries['INSECTS']!.add(series);
      } else if (vaccineType.contains('RABIES')) {
        categorizedSeries['RABIES']!.add(series);
      } else {
        // Default to VIRUS if category unclear
        categorizedSeries['VIRUS']!.add(series);
      }
    }

    return categorizedSeries.entries
        .where((entry) => entry.value.isNotEmpty)
        .map((entry) => _buildVaccineCategorySection(
              context,
              entry.key,
              entry.value,
              isDark,
              cardColor,
            ))
        .toList();
  }

  Widget _buildVaccineCategorySection(
    BuildContext context,
    String category,
    List<dynamic> series,
    bool isDark,
    Color? cardColor,
  ) {
    final isExpanded = _expandedCategoryIds.contains(category);
    final categoryIcon = _getCategoryIcon(category);
    final categoryColor = _getCategoryColor(category);
    final categoryName = _getCategoryDisplayName(category);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: categoryColor.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.grey.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Category Header
          InkWell(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedCategoryIds.remove(category);
                } else {
                  _expandedCategoryIds.add(category);
                }
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.1),
                borderRadius: isExpanded
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      )
                    : BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: categoryColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      categoryIcon,
                      color: categoryColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          categoryName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: categoryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${series.length} vaccine${series.length > 1 ? 's' : ''}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: categoryColor,
                    size: 28,
                  ),
                ],
              ),
            ),
          ),

          // Series in this category
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: series
                    .map((s) => _buildVaccinationSeriesCard(
                          context,
                          s,
                          isDark,
                          cardColor,
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toUpperCase()) {
      case 'VIRUS':
        return Colors.purple;
      case 'WORMS':
        return Colors.orange;
      case 'INSECTS':
        return Colors.teal;
      case 'RABIES':
        return Colors.red;
      default:
        return AppColors.orange;
    }
  }

  String _getCategoryDisplayName(String category) {
    switch (category.toUpperCase()) {
      case 'VIRUS':
        return 'Virus Vaccines';
      case 'WORMS':
        return 'Worm Treatment';
      case 'INSECTS':
        return 'Insect Protection';
      case 'RABIES':
        return 'Rabies Vaccine';
      default:
        return category;
    }
  }

  void _showMarkDoseCompleteDialog(
    BuildContext context,
    String seriesId,
    int doseNumber,
    List<dynamic> completedDoses,
  ) {
    DateTime selectedDate = DateTime.now();

    // Get previous dose date for validation (if exists)
    DateTime? previousDoseDate;
    if (doseNumber > 1 && completedDoses.isNotEmpty) {
      try {
        final previousDose = completedDoses.firstWhere(
          (d) => d.doseNumber == doseNumber - 1,
        );
        if (previousDose.administeredDate != null) {
          previousDoseDate = DateTime.parse(previousDose.administeredDate);
        }
      } catch (e) {
        // Previous dose not found, that's okay
        previousDoseDate = null;
      }
    }

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (statefulContext, setState) {
          // Calculate days gap if previous dose exists
          int? daysGap;
          if (previousDoseDate != null) {
            daysGap = selectedDate.difference(previousDoseDate).inDays;
          }

          final isValidDate = previousDoseDate == null || daysGap! >= 21;

          return AlertDialog(
            title: const Text('Mark Dose Complete'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('When was dose $doseNumber administered?'),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: dialogContext,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setState(() {
                        selectedDate = date;
                      });
                    }
                  },
                  icon: const Icon(Icons.calendar_today),
                  label: Text(DateFormat('MMM dd, yyyy').format(selectedDate)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
                // Show validation warning if date is too close
                if (previousDoseDate != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isValidDate
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isValidDate
                            ? Colors.green.withValues(alpha: 0.3)
                            : Colors.red.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isValidDate ? Icons.check_circle : Icons.warning,
                          color: isValidDate ? Colors.green : Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            isValidDate
                                ? 'Valid spacing: $daysGap days after Dose ${doseNumber - 1}'
                                : 'Invalid: Only $daysGap days after Dose ${doseNumber - 1}. Need 21+ days.',
                            style: TextStyle(
                              fontSize: 12,
                              color: isValidDate
                                  ? Colors.green[800]
                                  : Colors.red[800],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: isValidDate
                    ? () {
                        Navigator.of(dialogContext).pop();
                        _markDoseComplete(
                            context, seriesId, doseNumber, selectedDate);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey,
                ),
                child: const Text('Mark Complete'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _markDoseComplete(
    BuildContext context,
    String seriesId,
    int doseNumber,
    DateTime administeredAt,
  ) {
    // Just call the cubit - BlocListener will handle success/error feedback
    context.read<VaccinationCubit>().markDoseComplete(
          seriesId: seriesId,
          doseNumber: doseNumber,
          administeredAt: administeredAt,
        );
  }

  // Old dialog-based add vaccine methods removed - now using AddVaccinationScreen

  bool _isVirusVaccine(String vaccineType) {
    final type = vaccineType.toUpperCase();
    return type.contains('MONOVALENT') ||
        type.contains('BIVALENT') ||
        type.contains('TRIVALENT') ||
        type.contains('QUADRIVALENT') ||
        type.contains('PENTAVALENT') ||
        type.contains('HEXAVALENT') ||
        type.contains('HEPTAVALENT') ||
        type.contains('OCTAVALENT');
  }

  bool _isWormsVaccine(String vaccineType) {
    final type = vaccineType.toUpperCase();
    return type.contains('WORMS');
  }

  bool _isInsectsVaccine(String vaccineType) {
    final type = vaccineType.toUpperCase();
    return type.contains('INSECTS');
  }

  bool _isRabiesVaccine(String vaccineType) {
    final type = vaccineType.toUpperCase();
    return type.contains('RABIES');
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toUpperCase()) {
      case 'VIRUS':
        return Icons.coronavirus;
      case 'WORMS':
        return Icons.pest_control;
      case 'INSECTS':
        return Icons.bug_report;
      case 'RABIES':
        return Icons.warning;
      default:
        return Icons.vaccines;
    }
  }

  String _formatVaccineName(String vaccine) {
    // Convert from "DOG_MONOVALENT" to "Monovalent"
    return vaccine
        .replaceAll('DOG_', '')
        .replaceAll('CAT_', '')
        .replaceAll('WORMS_', '')
        .replaceAll('INSECTS_', '')
        .replaceAll('RABIES_', '')
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }
}
