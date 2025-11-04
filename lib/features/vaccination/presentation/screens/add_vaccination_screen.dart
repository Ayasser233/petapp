import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/app_colors.dart';
import '../cubit/vaccination_cubit.dart';
import '../cubit/vaccination_state.dart';

/// Add Vaccination Screen
///
/// Allows users to add a new vaccination series for a pet
class AddVaccinationScreen extends StatefulWidget {
  final String petId;
  final String petName;
  final String petSpecies;

  const AddVaccinationScreen({
    super.key,
    required this.petId,
    required this.petName,
    required this.petSpecies,
  });

  @override
  State<AddVaccinationScreen> createState() => _AddVaccinationScreenState();
}

class _AddVaccinationScreenState extends State<AddVaccinationScreen> {
  String? selectedVaccineType;
  final List<DoseEntry> doses = [];
  bool isLoading = false;
  DateTime singleDoseDate = DateTime.now(); // For Insects/Rabies vaccines

  // Vaccine types mapping - based on pet species
  Map<String, String> get virusVaccineTypes {
    final isDog = widget.petSpecies.toUpperCase() == 'DOG';
    if (isDog) {
      return {
        'DOG_MONOVALENT': 'Monovalent',
        'DOG_BIVALENT': 'Bivalent',
        'DOG_PENTAVALENT': 'Pentavalent',
        'DOG_HEPTAVALENT': 'Heptavalent',
        'DOG_OCTAVALENT': 'Octavalent',
      };
    } else {
      return {
        'CAT_TRIVALENT': 'Trivalent',
        'CAT_QUADRIVALENT': 'Quadrivalent',
      };
    }
  }

  // These will be populated based on pet species
  Map<String, String> get wormsVaccineTypes {
    final isDog = widget.petSpecies.toUpperCase() == 'DOG';
    return {
      isDog ? 'WORMS_DOG' : 'WORMS_CAT': 'Deworming',
    };
  }

  Map<String, String> get insectsVaccineTypes {
    final isDog = widget.petSpecies.toUpperCase() == 'DOG';
    return {
      isDog ? 'INSECTS_DOG' : 'INSECTS_CAT': 'Anti-Insects',
    };
  }

  Map<String, String> get rabiesVaccineTypes {
    final isDog = widget.petSpecies.toUpperCase() == 'DOG';
    return {
      isDog ? 'RABIES_DOG' : 'RABIES_CAT': 'Rabies',
    };
  }

  @override
  void initState() {
    super.initState();
    // Add first dose by default
    doses.add(DoseEntry(number: 1, date: DateTime.now()));
  }

  // Check if selected vaccine type requires dose tracking
  bool _requiresDoses() {
    if (selectedVaccineType == null) return false;
    // Only Virus and Worms vaccines require dose tracking
    return selectedVaccineType!.startsWith('DOG_') ||
        selectedVaccineType!.startsWith('CAT_') ||
        selectedVaccineType!.startsWith('WORMS_');
  }

  void _addDose() {
    if (doses.length >= 3) {
      Get.snackbar(
        'Maximum Reached',
        'You can only add up to 3 doses',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }
    setState(() {
      doses.add(DoseEntry(number: doses.length + 1, date: DateTime.now()));
    });
  }

  void _removeDose(int index) {
    if (doses.length > 1) {
      setState(() {
        doses.removeAt(index);
        // Renumber remaining doses
        for (int i = 0; i < doses.length; i++) {
          doses[i].number = i + 1;
        }
      });
    }
  }

  Future<void> _selectDate(BuildContext context, int index) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: doses[index].date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.orange,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != doses[index].date) {
      setState(() {
        doses[index].date = picked;
      });
    }
  }

  Future<void> _selectSingleDoseDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: singleDoseDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.orange,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        singleDoseDate = picked;
      });
    }
  }

  void _submitVaccination() {
    if (selectedVaccineType == null) {
      Get.snackbar(
        'Error',
        'Please select a vaccine type',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Only check for doses if the vaccine type requires them
    if (_requiresDoses() && doses.isEmpty) {
      Get.snackbar(
        'Error',
        'Please add at least one dose',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Create the doses list
    final dosesList = _requiresDoses()
        ? doses
            .map((dose) => {
                  'number': dose.number,
                  'administeredAt': DateFormat('yyyy-MM-dd').format(dose.date),
                })
            .toList()
        : [
            // For Insects/Rabies vaccines, add one dose with selected date
            {
              'number': 1,
              'administeredAt': DateFormat('yyyy-MM-dd').format(singleDoseDate),
            }
          ];

    // Call the cubit to create vaccination series
    context.read<VaccinationCubit>().createVaccineSeries(
          petId: widget.petId,
          vaccineType: selectedVaccineType!,
          doses: dosesList,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? Colors.grey[900] : Colors.grey[50];
    final cardColor = isDark ? Colors.grey[850] : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Add Vaccination - ${widget.petName}'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: cardColor,
      ),
      body: BlocListener<VaccinationCubit, VaccinationState>(
        listener: (context, state) {
          if (state is VaccinationSeriesCreated) {
            setState(() {
              isLoading = false;
            });
            Get.back(result: true);
            Get.snackbar(
              'Success',
              'Vaccination added successfully',
              backgroundColor: AppColors.orange,
              colorText: Colors.white,
            );
          } else if (state is VaccinationError) {
            setState(() {
              isLoading = false;
            });
            Get.snackbar(
              'Error',
              state.message,
              backgroundColor: Colors.red,
              colorText: Colors.white,
              duration: const Duration(seconds: 4),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vaccine Type Selection
              _buildSectionTitle('Vaccine Type', isDark),
              const SizedBox(height: 12),
              _buildVaccineTypeCard(
                  'Virus Vaccines', virusVaccineTypes, cardColor, isDark),
              const SizedBox(height: 12),
              _buildVaccineTypeCard(
                  'Worms', wormsVaccineTypes, cardColor, isDark),
              const SizedBox(height: 12),
              _buildVaccineTypeCard(
                  'Insects', insectsVaccineTypes, cardColor, isDark),
              const SizedBox(height: 12),
              _buildVaccineTypeCard(
                  'Rabies', rabiesVaccineTypes, cardColor, isDark),

              const SizedBox(height: 32),

              // Date Selection for Insects/Rabies vaccines
              if (!_requiresDoses() && selectedVaccineType != null) ...[
                _buildSectionTitle('Vaccination Date', isDark),
                const SizedBox(height: 12),
                _buildSingleDoseDateCard(cardColor, isDark),
                const SizedBox(height: 32),
              ],

              // Doses Section - Only show for Virus and Worms vaccines
              if (_requiresDoses()) ...[
                _buildSectionTitle('Administered Doses', isDark),
                const SizedBox(height: 12),
                ...doses.asMap().entries.expand((entry) {
                  final index = entry.key;
                  final dose = entry.value;
                  return [
                    // Show warning before dose 2
                    if (index == 1 && doses.length >= 2)
                      _buildDoseSpacingWarning(doses[0].date, isDark),
                    _buildDoseCard(index, dose, cardColor, isDark),
                  ];
                }),

                const SizedBox(height: 12),

                // Add Dose Button (max 3 doses)
                OutlinedButton.icon(
                  onPressed: doses.length < 3 ? _addDose : null,
                  icon: Icon(
                    Icons.add,
                    color: doses.length < 3 ? AppColors.orange : Colors.grey,
                  ),
                  label: Text(
                    doses.length < 3
                        ? 'Add Another Dose (${doses.length}/3)'
                        : 'Maximum 3 Doses Reached',
                    style: TextStyle(
                      color: doses.length < 3 ? AppColors.orange : Colors.grey,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: doses.length < 3 ? AppColors.orange : Colors.grey,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),

                const SizedBox(height: 32),
              ],

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _submitVaccination,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Add Vaccination',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : Colors.black87,
      ),
    );
  }

  Widget _buildVaccineTypeCard(
    String category,
    Map<String, String> types,
    Color? cardColor,
    bool isDark,
  ) {
    return Container(
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
        children: [
          // Category Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.orange.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getCategoryIcon(category),
                  color: AppColors.orange,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.orange,
                  ),
                ),
              ],
            ),
          ),

          // Vaccine Type Options
          ...types.entries.map((entry) {
            final isSelected = selectedVaccineType == entry.key;
            return InkWell(
              onTap: () {
                setState(() {
                  selectedVaccineType = entry.key;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.orange.withValues(alpha: 0.1)
                      : Colors.transparent,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: isSelected ? AppColors.orange : Colors.grey,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? AppColors.orange : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDoseSpacingWarning(DateTime firstDoseDate, bool isDark) {
    // Calculate recommended date for dose 2 (typically 3-4 weeks after dose 1)
    final recommendedDate = firstDoseDate.add(const Duration(days: 21));

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.orange.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.orange[700],
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Next Dose date: ${DateFormat('MMM dd, yyyy').format(recommendedDate)}',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.grey[300] : Colors.grey[800],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleDoseDateCard(Color? cardColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.orange.withValues(alpha: 0.3),
        ),
      ),
      child: InkWell(
        onTap: () => _selectSingleDoseDate(context),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.orange.withValues(alpha: 0.1),
              ),
              child: const Icon(
                Icons.calendar_today,
                color: AppColors.orange,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date Administered',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMMM dd, yyyy').format(singleDoseDate),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoseCard(
      int index, DoseEntry dose, Color? cardColor, bool isDark) {
    return Container(
      key: ValueKey('dose_$index'),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.orange.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          // Dose Number
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.orange.withValues(alpha: 0.1),
              border: Border.all(
                color: AppColors.orange,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                '${dose.number}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.orange,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Date Picker
          Expanded(
            child: InkWell(
              onTap: () => _selectDate(context, index),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 18, color: AppColors.orange),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('MMM dd, yyyy').format(dose.date),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Remove Button
          if (doses.length > 1) ...[
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => _removeDose(index),
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              tooltip: 'Remove Dose',
            ),
          ],
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Virus Vaccines':
        return Icons.coronavirus;
      case 'Worms':
        return Icons.bug_report;
      case 'Insects':
        return Icons.pest_control;
      case 'Rabies':
        return Icons.warning;
      default:
        return Icons.vaccines;
    }
  }
}

/// Dose Entry Model
class DoseEntry {
  int number;
  DateTime date;

  DoseEntry({
    required this.number,
    required this.date,
  });
}
