import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:petapp/core/localization/app_localizations.dart';
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

  /// Generate annual boosters from vaccination series with annualBoosterDate
  /// This is a workaround in case the backend doesn't populate annualBoosters array
  List<dynamic> _generateAnnualBoosters(dynamic medicalSheet) {
    final List<dynamic> boosters = [];

    // Add backend-provided boosters first
    boosters.addAll(medicalSheet.annualBoosters);

    // Also check vaccination series for annualBoosterDate
    for (var series in medicalSheet.vaccinationSeries) {
      // Check if series has annual booster date (means it's ready for boosters)
      if (series.annualBoosterDate != null) {
        // For single-dose vaccines (insects, rabies), they should show booster after dose 1
        // For worms, they should show booster after dose 2
        final isInsectsOrRabies = _isInsectsVaccine(series.vaccineType) ||
            _isRabiesVaccine(series.vaccineType);
        final isWorms = _isWormsVaccine(series.vaccineType);

        final shouldShowBooster =
            (isInsectsOrRabies && series.completedDoses >= 1) ||
                (isWorms && series.completedDoses >= 2) ||
                series.isComplete;

        if (shouldShowBooster) {
          // Check if this booster is already in the list
          final alreadyExists =
              boosters.any((b) => b.seriesId == series.seriesId);

          if (!alreadyExists) {
            // Create a synthetic booster from series data
            final dueDate = DateTime.parse(series.annualBoosterDate!);
            final now = DateTime.now();
            final isOverdue = dueDate.isBefore(now);

            boosters.add(_SyntheticBooster(
              vaccineType: series.vaccineType,
              dueDate: series.annualBoosterDate!,
              isOverdue: isOverdue,
              seriesId: series.seriesId,
            ));
          }
        }
      }
    }

    // Sort by due date
    boosters.sort((a, b) {
      final dateA = DateTime.parse(a.dueDate);
      final dateB = DateTime.parse(b.dueDate);
      return dateA.compareTo(dateB);
    });

    return boosters;
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
          '${widget.pet.name} - ${AppLocalizations.of(context).vaccinationRecord}',
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
              SnackBar(
                content: Text(AppLocalizations.of(context).doseMarkedComplete),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
            // Refresh medical sheet after successful completion
            context.read<VaccinationCubit>().getMedicalSheet(widget.pet.id);
          } else if (state is AnnualBoosterMarkedComplete) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text(AppLocalizations.of(context).boosterMarkedComplete),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
            // Refresh medical sheet after successful completion
            context.read<VaccinationCubit>().getMedicalSheet(widget.pet.id);
          } else if (state is VaccinationError) {
            final loc = AppLocalizations.of(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 4),
                action: SnackBarAction(
                  label: loc.dismiss,
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
            final loc = AppLocalizations.of(context);
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  Text(
                    loc.errorLoadingVaccinationRecord,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
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
                    child: Text(loc.retry),
                  ),
                ],
              ),
            );
          }

          if (state is MedicalSheetLoaded) {
            final medicalSheet = state.medicalSheet;

            // Generate annual boosters from series with annualBoosterDate
            final allBoosters = _generateAnnualBoosters(medicalSheet);

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
                        allBoosters.length,
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
                            context,
                            AppLocalizations.of(context).vaccinationRecords,
                            isDark),
                        const SizedBox(height: 12),
                        ..._buildCategoryCards(
                          context,
                          medicalSheet.vaccinationSeries,
                          isDark,
                          cardColor,
                        ),
                      ],

                      // Annual Boosters Section
                      if (allBoosters.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        _buildSectionTitle(
                            context,
                            AppLocalizations.of(context).annualBoosters,
                            isDark),
                        const SizedBox(height: 12),
                        ...allBoosters.map((booster) => _buildAnnualBoosterCard(
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
          final loc = AppLocalizations.of(context);
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
                  loc.noVaccinationData,
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
        label: Text(
          AppLocalizations.of(context).addVaccine,
          style: const TextStyle(
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

  List<Widget> _buildMissingVaccineWarnings(
    BuildContext context,
    List<dynamic> vaccinationSeries,
    bool isDark,
    Color? cardColor,
  ) {
    final List<Widget> warnings = [];

    // Check for each vaccine type
    final hasVirusVaccine =
        vaccinationSeries.any((series) => _isVirusVaccine(series.vaccineType));
    final hasWormsVaccine =
        vaccinationSeries.any((series) => _isWormsVaccine(series.vaccineType));
    final hasInsectsVaccine = vaccinationSeries
        .any((series) => _isInsectsVaccine(series.vaccineType));
    final hasRabiesVaccine =
        vaccinationSeries.any((series) => _isRabiesVaccine(series.vaccineType));

    final loc = AppLocalizations.of(context);

    // Virus vaccine warning
    if (!hasVirusVaccine) {
      warnings.add(_buildMissingVaccineCard(
        loc.virusVaccineMissing,
        loc.virusVaccineMissingMessage,
        Icons.coronavirus,
        Colors.purple,
        isDark,
        cardColor,
      ));
      warnings.add(const SizedBox(height: 12));
    }

    // Worms vaccine warning
    if (!hasWormsVaccine) {
      warnings.add(_buildMissingVaccineCard(
        loc.wormTreatmentMissing,
        loc.wormTreatmentMissingMessage,
        Icons.pest_control,
        Colors.orange,
        isDark,
        cardColor,
      ));
      warnings.add(const SizedBox(height: 12));
    }

    // Insects vaccine warning
    if (!hasInsectsVaccine) {
      warnings.add(_buildMissingVaccineCard(
        loc.insectProtectionMissing,
        loc.insectProtectionMissingMessage,
        Icons.bug_report,
        Colors.teal,
        isDark,
        cardColor,
      ));
      warnings.add(const SizedBox(height: 12));
    }

    // Rabies vaccine warning
    if (!hasRabiesVaccine) {
      warnings.add(_buildMissingVaccineCard(
        loc.rabiesVaccineMissing,
        loc.rabiesVaccineMissingMessage,
        Icons.warning,
        Colors.red,
        isDark,
        cardColor,
      ));
      warnings.add(const SizedBox(height: 12));
    }

    return warnings;
  }

  Widget _buildMissingVaccineCard(
    String title,
    String message,
    IconData icon,
    Color color,
    bool isDark,
    Color? cardColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.grey[300] : Colors.grey[700],
                    height: 1.3,
                  ),
                ),
              ],
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
          _buildSummaryItem(AppLocalizations.of(context).completed, completed,
              Colors.green, Icons.check_circle),
          _buildSummaryItem(AppLocalizations.of(context).upcoming, upcoming,
              Colors.blue, Icons.schedule),
          _buildSummaryItem(AppLocalizations.of(context).overdue, overdue,
              Colors.red, Icons.warning),
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

    // Determine correct total doses based on vaccine type
    final int correctTotalDoses;
    if (_isInsectsVaccine(series.vaccineType) ||
        _isRabiesVaccine(series.vaccineType)) {
      correctTotalDoses = 1; // Single dose
    } else if (_isWormsVaccine(series.vaccineType)) {
      correctTotalDoses = 2; // Two doses
    } else {
      correctTotalDoses =
          series.totalDoses; // Use backend value for virus (3 doses)
    }

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
                          _formatVaccineName(context, series.vaccineType),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${series.completedDoses}/$correctTotalDoses ${AppLocalizations.of(context).dosesCompleted}',
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
                      series.isComplete
                          ? AppLocalizations.of(context).completedStatus
                          : AppLocalizations.of(context).active,
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
              // Check vaccine type first
              final isVirusVaccine = _isVirusVaccine(series.vaccineType);
              final isWormsVaccine = _isWormsVaccine(series.vaccineType);
              final isInsectsVaccine = _isInsectsVaccine(series.vaccineType);
              final isRabiesVaccine = _isRabiesVaccine(series.vaccineType);

              // Determine correct total doses based on vaccine type
              final int correctTotalDoses;
              if (isInsectsVaccine || isRabiesVaccine) {
                correctTotalDoses = 1; // Single dose
              } else if (isWormsVaccine) {
                correctTotalDoses = 2; // Two doses
              } else {
                correctTotalDoses =
                    series.totalDoses; // Use backend value for virus (3 doses)
              }

              // Generate virtual doses for uncompleted ones
              // Backend only returns completed doses, we need to create placeholders
              final List<int> uncompletedDoseNumbers = [];

              // Find which dose numbers are missing (up to correct total)
              for (int i = 1; i <= correctTotalDoses; i++) {
                final hasThisDose =
                    series.doses.any((dose) => dose.doseNumber == i);
                if (!hasThisDose) {
                  uncompletedDoseNumbers.add(i);
                }
              }

              // Determine which message to show based on completed doses
              final completedDosesCount = series.completedDoses;
              final loc = AppLocalizations.of(context);
              String? statusMessage;
              DateTime? nextDoseDate;

              if (isVirusVaccine && uncompletedDoseNumbers.isNotEmpty) {
                if (completedDosesCount == 0) {
                  statusMessage = loc.notProtectedStartVirusVaccineSoon;
                } else if (completedDosesCount == 1) {
                  statusMessage = loc.protectionIncomplete;
                  if (series.doses.isNotEmpty) {
                    nextDoseDate =
                        DateTime.parse(series.doses.first.administeredDate!)
                            .add(const Duration(days: 21));
                  }
                } else if (completedDosesCount == 2) {
                  statusMessage = loc.protectedThirdDoseGivesStrongestImmunity;
                  if (series.doses.length >= 2) {
                    nextDoseDate =
                        DateTime.parse(series.doses.last.administeredDate!)
                            .add(const Duration(days: 21));
                  }
                } else if (completedDosesCount >= 3) {
                  statusMessage = loc.fullyProtected;
                }
              } else if (isWormsVaccine && uncompletedDoseNumbers.isNotEmpty) {
                if (completedDosesCount == 0) {
                  statusMessage = loc.notProtectedFromWorms;
                } else if (completedDosesCount == 1) {
                  statusMessage = loc.secondDoseRequiredForFullDeworming;
                  if (series.doses.isNotEmpty) {
                    nextDoseDate =
                        DateTime.parse(series.doses.first.administeredDate!)
                            .add(const Duration(days: 21));
                  }
                } else if (completedDosesCount >= 2) {
                  statusMessage = loc.treatmentComplete;
                }
              } else if (isInsectsVaccine) {
                // Insects vaccines are single-dose
                if (completedDosesCount == 0) {
                  statusMessage = loc.notProtectedFromFleasOrTicks;
                } else {
                  statusMessage = loc.protectionActive;
                }
              } else if (isRabiesVaccine) {
                // Rabies vaccines are single-dose
                if (completedDosesCount == 0) {
                  statusMessage = loc.yourPetIsntProtectedFromRabies;
                } else {
                  statusMessage = loc.protectedFromRabies;
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
                                    '${AppLocalizations.of(context).nextDose}: ${DateFormat('MMM dd, yyyy').format(nextDoseDate)}',
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
                          ...List.generate(correctTotalDoses, (index) {
                            final doseNumber = index + 1;
                            // Find if this dose exists in completed doses
                            final matchingDoses = series.doses
                                .where((d) => d.doseNumber == doseNumber);
                            final completedDose = matchingDoses.isNotEmpty
                                ? matchingDoses.first
                                : null;
                            final isLast = index == correctTotalDoses - 1;

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
                                                  '${AppLocalizations.of(context).dose} $doseNumber',
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
                                                    child: Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .completedStatus,
                                                      style: const TextStyle(
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
                                                  label: Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .markAsComplete),
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
                  '${AppLocalizations.of(context).dose} $doseNumber',
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
                      AppLocalizations.of(context).notYetAdministered,
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
            label: Text(AppLocalizations.of(context).markComplete),
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
                          _formatVaccineName(context, booster.vaccineType),
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
                        _showMarkBoosterCompleteDialog(
                          context,
                          booster.seriesId,
                        );
                      },
                      icon: const Icon(Icons.check, size: 18),
                      label: Text(AppLocalizations.of(context).markAsComplete),
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
            AppLocalizations.of(context).noVaccinationRecords,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).addYourPetsFirstVaccine,
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
    final categoryName = _getCategoryDisplayName(context, category);

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
                          '${series.length} ${series.length > 1 ? AppLocalizations.of(context).vaccines : AppLocalizations.of(context).vaccine}',
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

  String _getCategoryDisplayName(BuildContext context, String category) {
    final loc = AppLocalizations.of(context);
    switch (category.toUpperCase()) {
      case 'VIRUS':
        return loc.virusVaccines;
      case 'WORMS':
        return loc.wormTreatment;
      case 'INSECTS':
        return loc.insectProtection;
      case 'RABIES':
        return loc.rabiesVaccine;
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

          final loc = AppLocalizations.of(statefulContext);

          return AlertDialog(
            title: Text(loc.markDoseComplete),
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
                child: Text(loc.cancel),
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
                child: Text(loc.markComplete),
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

  void _showMarkBoosterCompleteDialog(
    BuildContext context,
    String seriesId,
  ) {
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (statefulContext, setState) {
          final loc = AppLocalizations.of(statefulContext);

          return AlertDialog(
            title: Text(loc.markAsComplete),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('When was the annual booster administered?'),
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
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(loc.cancel),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  _markBoosterComplete(context, seriesId, selectedDate);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                  foregroundColor: Colors.white,
                ),
                child: Text(loc.markComplete),
              ),
            ],
          );
        },
      ),
    );
  }

  void _markBoosterComplete(
    BuildContext context,
    String seriesId,
    DateTime completedDate,
  ) {
    // Just call the cubit - BlocListener will handle success/error feedback
    context.read<VaccinationCubit>().markAnnualBoosterComplete(
          seriesId: seriesId,
          completedDate: completedDate,
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

  String _formatVaccineName(BuildContext context, String vaccine) {
    final loc = AppLocalizations.of(context);

    // Map vaccine types to localized names
    if (vaccine.contains('MONOVALENT')) return loc.monovalent;
    if (vaccine.contains('BIVALENT')) return loc.bivalent;
    if (vaccine.contains('TRIVALENT')) return loc.trivalent;
    if (vaccine.contains('QUADRIVALENT')) return loc.quadrivalent;
    if (vaccine.contains('PENTAVALENT')) return loc.pentavalent;
    if (vaccine.contains('HEXAVALENT')) return loc.hexavalent;
    if (vaccine.contains('HEPTAVALENT')) return loc.heptavalent;
    if (vaccine.contains('OCTAVALENT')) return loc.octavalent;
    if (vaccine.contains('WORMS')) return loc.deworming;
    if (vaccine.contains('INSECTS')) return loc.antiInsects;
    if (vaccine.contains('RABIES')) return loc.rabies;

    // Fallback: Convert from "DOG_MONOVALENT" to "Monovalent"
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

/// Synthetic booster class for creating boosters from series data
/// Used when backend doesn't populate annualBoosters array
class _SyntheticBooster {
  final String vaccineType;
  final String dueDate;
  final bool isOverdue;
  final String seriesId;

  _SyntheticBooster({
    required this.vaccineType,
    required this.dueDate,
    required this.isOverdue,
    required this.seriesId,
  });
}
