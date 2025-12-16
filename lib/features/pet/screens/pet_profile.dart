import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/features/pet/models/pet_model.dart';
import 'package:petapp/features/pet/controllers/pet_controller.dart';
import 'package:petapp/features/vaccination/presentation/cubit/vaccination_cubit.dart';
import 'package:petapp/features/vaccination/presentation/cubit/vaccination_state.dart';
import 'package:petapp/features/vaccination/presentation/screens/pet_vaccination_record_screen.dart';
import 'package:petapp/features/vaccination/presentation/screens/add_vaccination_screen.dart';
import 'package:petapp/di/service_locator.dart';
import 'dart:io';

class PetProfileScreen extends StatefulWidget {
  final PetModel pet;

  const PetProfileScreen({
    super.key,
    required this.pet,
  });

  @override
  State<PetProfileScreen> createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends State<PetProfileScreen> {
  late final PetController _petController;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _petController = sl<PetController>();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    // Determine if dark theme is active
    final isDark = THelperFunctions.isDarkMode(context);

    // Get pet age
    final age = _calculateAge(widget.pet.dateOfBirth);

    // Use app theme color instead of pet type-based colors
    const Color themeColor = AppColors.orange;

    // Define theme-dependent colors
    final Color backgroundColor = isDark ? Colors.grey[900]! : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.grey[800]!;
    final Color subTextColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;
    final Color cardColor = isDark ? Colors.grey[850]! : Colors.white;
    final Color cardBorderColor =
        isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final Color notesBgColor = isDark ? Colors.grey[800]! : Colors.grey[100]!;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          // App bar with pet image
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: themeColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () async {
                  final result = await Get.toNamed(
                    AppRoutes.updatePet,
                    arguments: widget.pet,
                  );
                  if (result == true) {
                    // Refresh pet data after update
                    await _petController.fetchPets();
                    Get.back(); // Go back to refresh the list
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.white),
                onPressed: () {
                  _showDeleteConfirmation(context, isDark);
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Pet image - prioritize API image URL, then local file, then asset
                  _buildPetImage(),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                  // Pet name at bottom
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.pet.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                widget.pet.species,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                age,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Pet details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pet info cards
                  Row(
                    children: [
                      _buildInfoCard(
                        context,
                        localizations.birthday,
                        _formatDate(widget.pet.dateOfBirth),
                        Icons.cake,
                        themeColor,
                        isDark,
                      ),
                      const SizedBox(width: 16),
                      _buildInfoCard(
                        context,
                        localizations.species,
                        widget.pet.species.toUpperCase(),
                        widget.pet.species.toLowerCase() == 'dog'
                            ? Icons.pets
                            : Icons.emoji_nature,
                        themeColor,
                        isDark,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Gender and Weight
                  Row(
                    children: [
                      if (widget.pet.gender != null)
                        Expanded(
                          child: _buildInfoCard(
                            context,
                            localizations.gender,
                            widget.pet.gender == 'MALE'
                                ? localizations.male
                                : localizations.female,
                            widget.pet.gender == 'MALE'
                                ? Icons.male
                                : Icons.female,
                            themeColor,
                            isDark,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Spay/Neuter Status
                  if (widget.pet.spayNeuterStatus != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: cardBorderColor),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.medical_services,
                            color: themeColor,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            widget.pet.spayNeuterStatus!
                                ? localizations.spayedNeutered
                                : localizations.notSpayedNeutered,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Allergies section
                  if (widget.pet.allergies != null &&
                      widget.pet.allergies!.isNotEmpty) ...[
                    _buildSectionHeader('Allergies', Icons.warning_amber,
                        themeColor, textColor),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.pet.allergies!.map((allergy) {
                        return Chip(
                          label: Text(allergy),
                          backgroundColor:
                              AppColors.orange.withValues(alpha: 0.2),
                          labelStyle: TextStyle(color: textColor),
                          avatar: const Icon(
                            Icons.warning_amber,
                            size: 18,
                            color: AppColors.orange,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  const SizedBox(height: 8),

                  // Notes section
                  if (widget.pet.notes != null &&
                      widget.pet.notes!.isNotEmpty) ...[
                    _buildSectionHeader(localizations.notes, Icons.note_alt,
                        themeColor, textColor),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: notesBgColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: cardBorderColor),
                      ),
                      child: Text(
                        widget.pet.notes!,
                        style: TextStyle(
                          color: textColor,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Vaccinations section
                  _buildSectionHeader('Vaccinations', Icons.medical_services,
                      themeColor, textColor),
                  const SizedBox(height: 8),

                  // Vaccination summary card with navigation
                  _buildVaccinationSummaryCard(
                    context,
                    cardColor,
                    textColor,
                    subTextColor,
                    cardBorderColor,
                    isDark,
                  ),

                  const SizedBox(height: 24),

                  // Medical details section
                  _buildSectionHeader('Medical Details',
                      Icons.health_and_safety, themeColor, textColor),
                  const SizedBox(height: 8),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: cardBorderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Show primary weight field
                        if (widget.pet.weight != null) ...[
                          _buildMedicalDetailRow(
                              localizations.weight,
                              '${widget.pet.weight} kg',
                              Icons.monitor_weight,
                              textColor,
                              subTextColor),
                          const SizedBox(height: 12),
                        ],
                        // Show gender
                        if (widget.pet.gender != null) ...[
                          _buildMedicalDetailRow(
                              localizations.gender,
                              widget.pet.gender == 'MALE'
                                  ? localizations.male
                                  : localizations.female,
                              widget.pet.gender == 'MALE'
                                  ? Icons.male
                                  : Icons.female,
                              textColor,
                              subTextColor),
                          const SizedBox(height: 12),
                        ],
                        // Show primary spay/neuter status
                        if (widget.pet.spayNeuterStatus != null) ...[
                          _buildMedicalDetailRow(
                              localizations.spayedNeuteredQuestion,
                              widget.pet.spayNeuterStatus! ? 'Yes' : 'No',
                              Icons.medical_services,
                              textColor,
                              subTextColor),
                          const SizedBox(height: 12),
                        ],
                        // Show primary allergies
                        if (widget.pet.allergies != null &&
                            widget.pet.allergies!.isNotEmpty) ...[
                          _buildMedicalDetailRow(
                              localizations.allergies,
                              widget.pet.allergies!.join(', '),
                              Icons.warning_amber,
                              textColor,
                              subTextColor),
                          const SizedBox(height: 12),
                        ],
                        // Show last vet visit from medical history if available
                        if (widget.pet.medicalHistory?.lastVetVisit !=
                            null) ...[
                          _buildMedicalDetailRow(
                              localizations.lastVetVisit,
                              _formatDate(
                                  widget.pet.medicalHistory!.lastVetVisit!),
                              Icons.event,
                              textColor,
                              subTextColor),
                        ],
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
      String title, IconData icon, Color color, Color textColor) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    final textColor = isDark ? Colors.white : Colors.grey[800];
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(
                  color: subTextColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  // Empty placeholder - all old visit-related methods have been removed

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    final now = DateTime.now();

    if (date.year == now.year) {
      return '${_getMonthName(date.month)} ${date.day}';
    } else {
      return '${_getMonthName(date.month)} ${date.day}, ${date.year}';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  String _calculateAge(String birthdate) {
    final birth = DateTime.parse(birthdate);
    final now = DateTime.now();

    int years = now.year - birth.year;
    int months = now.month - birth.month;
    int days = now.day - birth.day;

    if (days < 0) {
      months--;
      final previousMonth = DateTime(now.year, now.month, 0);
      days += previousMonth.day;
    }

    if (months < 0) {
      years--;
      months += 12;
    }

    // Build age string
    List<String> ageParts = [];

    if (years > 0) {
      ageParts.add(years == 1 ? '1 year' : '$years years');
    }

    if (months > 0 && years < 2) {
      ageParts.add(months == 1 ? '1 month' : '$months months');
    }

    if (days > 0 && years == 0 && months == 0) {
      ageParts.add(days == 1 ? '1 day' : '$days days');
    }

    // Return formatted age (show max 2 parts to avoid clutter)
    if (ageParts.isEmpty) {
      return 'Newborn';
    } else if (ageParts.length >= 2) {
      return '${ageParts[0]}, ${ageParts[1]} old';
    } else {
      return '${ageParts[0]} old';
    }
  }

  void _showDeleteConfirmation(BuildContext context, bool isDark) {
    final localizations = AppLocalizations.of(context);
    final dialogBgColor = isDark ? Colors.grey[850] : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: dialogBgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          localizations.confirmDelete,
          style: TextStyle(color: textColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.red[isDark ? 300 : 400],
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              localizations.areYouSureDeletePet.replaceAll('this pet', widget.pet.name),
              textAlign: TextAlign.center,
              style: TextStyle(color: textColor),
            ),
            const SizedBox(height: 8),
            Text(
              localizations.thisActionCannotBeUndone,
              style: TextStyle(
                color: subTextColor,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDark ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: _isDeleting
                ? null
                : () async {
                    Navigator.pop(context); // Close dialog
                    setState(() => _isDeleting = true);

                    try {
                      final success =
                          await _petController.deletePet(widget.pet.id);
                      if (success) {
                        // Navigate to My Pets screen after successful deletion
                        Get.offAllNamed('/my-pets');
                        Get.snackbar(
                          'Success',
                          '${widget.pet.name} has been deleted.',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green[100],
                          colorText: Colors.green[800],
                        );
                      }
                    } catch (e) {
                      Get.snackbar(
                        'Error',
                        'Failed to delete pet. Please try again.',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red[100],
                        colorText: Colors.red[800],
                      );
                    } finally {
                      if (mounted) {
                        setState(() => _isDeleting = false);
                      }
                    }
                  },
            icon: _isDeleting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.delete_outline, size: 16),
            label: Text(_isDeleting
                ? AppLocalizations.of(context).deleting
                : AppLocalizations.of(context).delete),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVaccinationSummaryCard(
    BuildContext context,
    Color cardColor,
    Color textColor,
    Color subTextColor,
    Color borderColor,
    bool isDark,
  ) {
    return BlocProvider(
      create: (context) => sl<VaccinationCubit>()..getMedicalSheet(widget.pet.id),
      child: BlocBuilder<VaccinationCubit, VaccinationState>(
        builder: (context, state) {
          if (state is VaccinationLoading) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.orange),
              ),
            );
          }

          if (state is MedicalSheetLoaded) {
            final medicalSheet = state.medicalSheet;
            final hasRecords = medicalSheet.vaccinationSeries.isNotEmpty ||
                medicalSheet.annualBoosters.isNotEmpty;

            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary statistics
                  if (hasRecords) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildVaccinationStat(
                          'Completed',
                          medicalSheet.completedDosesCount.toString(),
                          Icons.check_circle,
                          Colors.green,
                          textColor,
                        ),
                        _buildVaccinationStat(
                          'Upcoming',
                          medicalSheet.totalUpcomingDoses.toString(),
                          Icons.schedule,
                          Colors.blue,
                          textColor,
                        ),
                        _buildVaccinationStat(
                          'Overdue',
                          medicalSheet.totalAnnualBoosters.toString(),
                          Icons.warning,
                          Colors.red,
                          textColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 12),
                    
                    // Vaccine categories list
                    Text(
                      'Vaccines',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...medicalSheet.vaccinationSeries.map((series) {
                      final category = _getVaccineCategory(series.vaccineType);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          children: [
                            Icon(
                              series.isComplete
                                  ? Icons.check_circle
                                  : Icons.schedule,
                              size: 16,
                              color: series.isComplete
                                  ? Colors.green
                                  : AppColors.orange,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                category,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: textColor,
                                ),
                              ),
                            ),
                            Text(
                              '${series.completedDoses}/${series.totalDoses}',
                              style: TextStyle(
                                fontSize: 12,
                                color: subTextColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                  ] else ...[
                    Row(
                      children: [
                        const Icon(
                          Icons.vaccines,
                          color: AppColors.orange,
                          size: 40,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'No vaccinations yet',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Keep your pet healthy',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: subTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
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
                            if (result == true && context.mounted) {
                              cubit.getMedicalSheet(widget.pet.id);
                            }
                          },
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Add Vaccine'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      if (hasRecords) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Get.to(() => BlocProvider(
                                    create: (context) => sl<VaccinationCubit>()
                                      ..getMedicalSheet(widget.pet.id),
                                    child: PetVaccinationRecordScreen(pet: widget.pet),
                                  ));
                            },
                            icon: const Icon(Icons.medical_information, size: 18),
                            label: const Text('View All'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.orange,
                              side: const BorderSide(color: AppColors.orange),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            );
          }

          // Error or initial state - show basic card with add button
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.vaccines,
                  color: AppColors.orange,
                  size: 40,
                ),
                const SizedBox(height: 12),
                Text(
                  'Vaccination Records',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final cubit = sl<VaccinationCubit>();
                      final result = await Get.to(() => BlocProvider.value(
                            value: cubit,
                            child: AddVaccinationScreen(
                              petId: widget.pet.id,
                              petName: widget.pet.name,
                              petSpecies: widget.pet.species,
                            ),
                          ));
                      if (result == true && mounted) {
                        setState(() {});
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Vaccine'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildVaccinationStat(
    String label,
    String value,
    IconData icon,
    Color iconColor,
    Color textColor,
  ) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: iconColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: textColor.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  String _getVaccineCategory(String vaccineType) {
    final type = vaccineType.toUpperCase();
    
    // For virus vaccines, show the specific type
    if (type.contains('MONOVALENT')) {
      return 'Monovalent';
    } else if (type.contains('BIVALENT')) {
      return 'Bivalent';
    } else if (type.contains('TRIVALENT')) {
      return 'Trivalent';
    } else if (type.contains('QUADRIVALENT')) {
      return 'Quadrivalent';
    } else if (type.contains('PENTAVALENT')) {
      return 'Pentavalent';
    } else if (type.contains('HEXAVALENT')) {
      return 'Hexavalent';
    } else if (type.contains('HEPTAVALENT')) {
      return 'Heptavalent';
    } else if (type.contains('OCTAVALENT')) {
      return 'Octavalent';
    } else if (type.contains('WORMS')) {
      return 'Worms';
    } else if (type.contains('INSECTS')) {
      return 'Insects';
    } else if (type.contains('RABIES')) {
      return 'Rabies';
    }
    
    return 'Vaccine'; // fallback
  }

  Widget _buildMedicalDetailRow(
    String label,
    String value,
    IconData icon,
    Color textColor,
    Color subTextColor,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: subTextColor,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: subTextColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build pet image widget that handles API URL, local file, or asset
  Widget _buildPetImage() {

    // Determine image source
    final String primaryImage = widget.pet.imageUrl ?? widget.pet.image;

    // Check if it's a network image
    final isNetworkImage = primaryImage.startsWith('http://') ||
        primaryImage.startsWith('https://') ||
        primaryImage.startsWith('www.');

    // Check if it's a local file (not network and not asset)
    final isLocalFile = !isNetworkImage && !primaryImage.startsWith('assets/');

    if (isNetworkImage) {
      // Network image from API
      return Image.network(
        primaryImage,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return Container(
            width: double.infinity,
            color: AppColors.orange.withValues(alpha: 0.1),
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
                color: AppColors.orange,
                strokeWidth: 3,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackImage();
        },
      );
    } else if (isLocalFile) {
      // Local file from camera/gallery
      return Image.file(
        File(primaryImage),
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackImage();
        },
      );
    } else {
      // Asset image
      return Image.asset(
        primaryImage,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackImage();
        },
      );
    }
  }

  /// Build fallback image when all image loading fails
  Widget _buildFallbackImage() {
    return Container(
      width: double.infinity,
      color: AppColors.orange.withValues(alpha: 0.2),
      child: Center(
        child: Icon(
          widget.pet.species.toLowerCase() == 'dog'
              ? Icons.pets
              : Icons.pets,
          size: 100,
          color: Colors.white.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
