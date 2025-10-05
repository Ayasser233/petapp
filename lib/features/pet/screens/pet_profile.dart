import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/features/pet/models/pet_model.dart';
import 'package:petapp/features/pet/controllers/pet_controller.dart';
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
    final Color emptyStateBgColor =
        isDark ? Colors.grey[800]! : Colors.grey[100]!;

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
              onPressed: () => Get.back(),
            ),
            actions: [
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
                  // Pet image
                  widget.pet.image.startsWith('assets/')
                      ? Image.asset(
                          widget.pet.image,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(widget.pet.image),
                          fit: BoxFit.cover,
                        ),
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
                                widget.pet.customSpecies ?? widget.pet.species,
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
                        'Birthday',
                        _formatDate(widget.pet.dateOfBirth),
                        Icons.cake,
                        themeColor,
                        isDark,
                      ),
                      const SizedBox(width: 16),
                      _buildInfoCard(
                        context,
                        'Species',
                        widget.pet.customSpecies ??
                            widget.pet.species.toUpperCase(),
                        widget.pet.species.toLowerCase() == 'dog'
                            ? Icons.pets
                            : Icons.emoji_nature,
                        themeColor,
                        isDark,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Notes section
                  if (widget.pet.medicalHistory?.notes != null &&
                      widget.pet.medicalHistory!.notes!.isNotEmpty) ...[
                    _buildSectionHeader(
                        'Notes', Icons.note_alt, themeColor, textColor),
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
                        widget.pet.medicalHistory!.notes!,
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

                  if (widget.pet.medicalHistory?.vaccinations == null ||
                      widget.pet.medicalHistory!.vaccinations!.isEmpty)
                    _buildEmptyVaccinationsCard(
                        emptyStateBgColor, subTextColor, cardBorderColor)
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount:
                          widget.pet.medicalHistory!.vaccinations!.length,
                      itemBuilder: (context, index) {
                        return _buildVaccinationCard(
                          widget.pet.medicalHistory!.vaccinations![index],
                          themeColor,
                          cardColor,
                          textColor,
                          subTextColor,
                          isDark,
                        );
                      },
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
                        if (widget.pet.medicalHistory?.weight != null) ...[
                          _buildMedicalDetailRow(
                              'Weight',
                              '${widget.pet.medicalHistory!.weight} kg',
                              Icons.monitor_weight,
                              textColor,
                              subTextColor),
                          const SizedBox(height: 12),
                        ],
                        if (widget.pet.medicalHistory?.lastVetVisit !=
                            null) ...[
                          _buildMedicalDetailRow(
                              'Last Vet Visit',
                              _formatDate(
                                  widget.pet.medicalHistory!.lastVetVisit!),
                              Icons.event,
                              textColor,
                              subTextColor),
                          const SizedBox(height: 12),
                        ],
                        if (widget.pet.medicalHistory?.spayNeuterStatus !=
                            null) ...[
                          _buildMedicalDetailRow(
                              'Spayed/Neutered',
                              widget.pet.medicalHistory!.spayNeuterStatus!
                                  ? 'Yes'
                                  : 'No',
                              Icons.pets,
                              textColor,
                              subTextColor),
                          const SizedBox(height: 12),
                        ],
                        if (widget.pet.medicalHistory?.allergies != null &&
                            widget
                                .pet.medicalHistory!.allergies!.isNotEmpty) ...[
                          _buildMedicalDetailRow(
                              'Allergies',
                              widget.pet.medicalHistory!.allergies!.join(', '),
                              Icons.warning_amber,
                              textColor,
                              subTextColor),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Add vaccination button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Implement add vaccination functionality
                      },
                      icon: const Icon(Icons.add, color: themeColor),
                      label: const Text(
                        'Add Vaccination',
                        style: TextStyle(color: themeColor),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: themeColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
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

    return Expanded(
      child: Container(
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

    if (now.day < birth.day) {
      months--;
    }

    if (months < 0) {
      years--;
      months += 12;
    }

    if (years > 0) {
      return years == 1 ? '1 year old' : '$years years old';
    } else {
      return months == 1 ? '1 month old' : '$months months old';
    }
  }

  void _showDeleteConfirmation(BuildContext context, bool isDark) {
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
          'Delete Pet',
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
              'Are you sure you want to delete ${widget.pet.name}?',
              textAlign: TextAlign.center,
              style: TextStyle(color: textColor),
            ),
            const SizedBox(height: 8),
            Text(
              'This action cannot be undone.',
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
                        Get.back(result: 'deleted');
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
            label: Text(_isDeleting ? 'Deleting...' : 'Delete'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyVaccinationsCard(
      Color backgroundColor, Color textColor, Color borderColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.vaccines,
            color: AppColors.orange,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'No vaccinations recorded yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your pet\'s vaccinations to keep track of their health',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVaccinationCard(
    VaccinationModel vaccination,
    Color themeColor,
    Color backgroundColor,
    Color textColor,
    Color subTextColor,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vaccination header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: themeColor.withValues(alpha: isDark ? 0.2 : 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    vaccination.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
                Text(
                  _formatDate(vaccination.date),
                  style: TextStyle(
                    color: subTextColor,
                  ),
                ),
              ],
            ),
          ),
          // Vaccination details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (vaccination.expiresAt != null) ...[
                  _buildMedicalDetailRow(
                      'Expires',
                      _formatDate(vaccination.expiresAt!),
                      Icons.event_busy,
                      textColor,
                      subTextColor),
                ],
              ],
            ),
          ),
        ],
      ),
    );
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
}
