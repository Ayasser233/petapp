import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/services/auth_service.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/di/service_locator.dart';
import 'package:petapp/features/pet/controllers/pet_controller.dart';
import 'package:petapp/features/pet/models/pet_model.dart';
import 'package:petapp/features/pet/utils/pet_constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petapp/core/utils/formatters.dart';
import 'dart:io';

class UpdatePetScreen extends StatefulWidget {
  final PetModel pet;

  const UpdatePetScreen({super.key, required this.pet});

  @override
  State<UpdatePetScreen> createState() => _UpdatePetScreenState();
}

class _UpdatePetScreenState extends State<UpdatePetScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _notesController;
  late final TextEditingController _weightController;
  final _allergyController = TextEditingController();

  late String _selectedSpecies;
  late String _selectedGender;
  late int _selectedMonth;
  late int _selectedYear;
  String _imagePath = 'assets/images/pet_placeholder.jpg';
  bool _isImageFromGallery = false;
  bool _isLoading = false;
  late bool _spayNeuterStatus;
  late List<String> _allergies;

  final AuthService _authService = sl<AuthService>();
  final PetController _petController = Get.find<PetController>();

  List<String> _allowedSpecies = [];

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
    _loadAllowedSpecies();
    _initializeFields();
  }

  void _initializeFields() {
    _nameController = TextEditingController(text: widget.pet.name);
    _notesController = TextEditingController(text: widget.pet.notes ?? '');
    _weightController = TextEditingController(
        text: widget.pet.weight != null ? widget.pet.weight.toString() : '');
    _selectedSpecies = widget.pet.species.toLowerCase();
    _selectedGender = widget.pet.gender ?? 'MALE';

    // Parse month and year from dateOfBirth
    try {
      if (widget.pet.dateOfBirth.isNotEmpty) {
        final date = DateTime.parse(widget.pet.dateOfBirth);
        _selectedMonth = date.month;
        _selectedYear = date.year;
      } else {
        _selectedMonth = DateTime.now().month;
        _selectedYear = DateTime.now().year - 1;
      }
    } catch (e) {
      _selectedMonth = DateTime.now().month;
      _selectedYear = DateTime.now().year - 1;
    }

    _spayNeuterStatus = widget.pet.spayNeuterStatus ?? false;
    _allergies = List<String>.from(widget.pet.allergies ?? []);
    _imagePath = widget.pet.image;
  }

  void _loadAllowedSpecies() {
    _allowedSpecies = PetConstants.allowedSpecies;
  }

  void _checkAuthStatus() {
    // Check if user is authenticated
    if (!_authService.canAccessProtectedFeature()) {
      // Show dialog and then navigate back if not logged in
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showLoginRequiredDialog();
      });
    }
  }

  void _showLoginRequiredDialog() {
    final localizations = AppLocalizations.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(localizations.loginRequired),
        content: Text(localizations.loginRequiredToUpdatePets),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Get.back(); // Go back to previous screen
            },
            child: Text(localizations.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Get.offNamed(AppRoutes.login); // Navigate to login screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
            ),
            child: Text(localizations.login),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    _weightController.dispose();
    _allergyController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final localizations = AppLocalizations.of(context);

    // Show options dialog
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (dialogContext) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(localizations.chooseFromGallery),
              onTap: () async {
                Navigator.pop(dialogContext);
                final XFile? image =
                    await picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  setState(() {
                    _imagePath = image.path;
                    _isImageFromGallery = true;
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(localizations.takeAPhoto),
              onTap: () async {
                Navigator.pop(dialogContext);
                final XFile? image =
                    await picker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  setState(() {
                    _imagePath = image.path;
                    _isImageFromGallery = true;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatMonthYear(int month, int year) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${monthNames[month - 1]} $year';
  }

  Future<void> _selectDate(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        int tempMonth = _selectedMonth;
        int tempYear = _selectedYear;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: isDark ? Colors.grey[900] : Colors.white,
              title: Text(
                'Select Birth Month & Year',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Month picker
                  DropdownButtonFormField<int>(
                    initialValue: tempMonth,
                    decoration: InputDecoration(
                      labelText: 'Month',
                      labelStyle: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                        ),
                      ),
                    ),
                    dropdownColor: isDark ? Colors.grey[850] : Colors.white,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    items: List.generate(12, (index) {
                      final monthNum = index + 1;
                      final monthNames = [
                        'January',
                        'February',
                        'March',
                        'April',
                        'May',
                        'June',
                        'July',
                        'August',
                        'September',
                        'October',
                        'November',
                        'December'
                      ];
                      return DropdownMenuItem(
                        value: monthNum,
                        child: Text(monthNames[index]),
                      );
                    }),
                    onChanged: (value) {
                      setState(() {
                        tempMonth = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  // Year picker
                  DropdownButtonFormField<int>(
                    initialValue: tempYear,
                    decoration: InputDecoration(
                      labelText: 'Year',
                      labelStyle: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                        ),
                      ),
                    ),
                    dropdownColor: isDark ? Colors.grey[850] : Colors.white,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    items: List.generate(
                      DateTime.now().year - 2000 + 1,
                      (index) {
                        final year = 2000 + index;
                        return DropdownMenuItem(
                          value: year,
                          child: Text(year.toString()),
                        );
                      },
                    ).reversed.toList(),
                    onChanged: (value) {
                      setState(() {
                        tempYear = value!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    localizations.cancel,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    this.setState(() {
                      _selectedMonth = tempMonth;
                      _selectedYear = tempYear;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    localizations.ok,
                    style: const TextStyle(color: AppColors.orange),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _updatePet() async {
    if (!_formKey.currentState!.validate()) return;

    final localizations = AppLocalizations.of(context);
    setState(() => _isLoading = true);

    try {
      // Validate species
      if (!PetConstants.isValidSpecies(_selectedSpecies)) {
        Get.snackbar(
          localizations.invalidSpecies,
          localizations.onlyCatsAndDogsAllowed,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[800],
        );
        return;
      }

      // Create date with first day of selected month and year
      final birthDate = DateTime(_selectedYear, _selectedMonth, 1);
      final dateString = birthDate.toIso8601String().split('T')[0];

      // Build petData with ALL fields (backend requires all fields, not just changed ones)
      final petData = <String, dynamic>{
        'name': _nameController.text.trim(),
        'gender': _selectedGender, // MALE or FEMALE
        'dateOfBirth':
            dateString, // Backend expects YYYY-MM-DD format with 1st day of month
        'allergies': _allergies,
        'spayNeuterStatus': _spayNeuterStatus,
      };

      // Handle species: If pet has customSpecies, preserve both species and customSpecies
      // Otherwise, use the selected species from the form
      if (widget.pet.customSpecies != null &&
          widget.pet.customSpecies!.isNotEmpty) {
        // Pet has custom species (like parrot, bird, etc.) - preserve original species value
        // but capitalize it properly as backend might expect "Dog" not "dog"
        final originalSpecies = widget.pet.species;
        petData['species'] = originalSpecies.substring(0, 1).toUpperCase() +
            originalSpecies.substring(1).toLowerCase(); // Capitalize properly
        petData['customSpecies'] =
            widget.pet.customSpecies; // Keep custom species
      } else {
        // Normal cat/dog - use form selection
        petData['species'] = _selectedSpecies.substring(0, 1).toUpperCase() +
            _selectedSpecies.substring(1).toLowerCase(); // "Dog" or "Cat"
      }

      // Add optional fields only if they have values
      if (_weightController.text.trim().isNotEmpty) {
        petData['weight'] = double.tryParse(
            TFormatter.toEnglishNumerals(_weightController.text.trim()));
      }

      if (_notesController.text.trim().isNotEmpty) {
        petData['notes'] = _notesController.text.trim();
      }
      // Pass image path if user selected a new image
      final String? imagePathToSend = _isImageFromGallery ? _imagePath : null;

      final success = await _petController.updatePet(
        widget.pet.id,
        petData,
        imagePath: imagePathToSend,
      );

      if (success) {
        // Refresh the pets list to show updated data
        await _petController.refreshPets();
        Get.back(result: true);
        Get.snackbar(
          localizations.success,
          localizations.petUpdatedSuccessfully
              .replaceAll('{name}', _nameController.text),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green[100],
          colorText: Colors.green[800],
        );
      } else {
        // Show error when success is false
        Get.snackbar(
          localizations.error,
          localizations.failedToUpdatePet,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[800],
        );
      }
    } catch (e) {
      Get.snackbar(
        localizations.error,
        '${localizations.failedToUpdatePet}: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        duration: const Duration(seconds: 5),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final isDark = THelperFunctions.isDarkMode(context);
    final backgroundColor = isDark ? Colors.grey[900] : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final inputFillColor = isDark ? Colors.grey[800] : Colors.grey[100];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          localizations.updatePet,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: backgroundColor,
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pet image section with gradient background
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 30),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.orange.withValues(alpha: isDark ? 0.2 : 0.1),
                      backgroundColor!,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark ? Colors.grey[800]! : Colors.white,
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withValues(alpha: isDark ? 0.3 : 0.1),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: _isImageFromGallery
                                ? Image.file(
                                    File(_imagePath),
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    _imagePath,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.orange,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:
                                    isDark ? Colors.grey[800]! : Colors.white,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Form fields
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Pet name
                    Text(
                      localizations.petName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        hintText: 'Enter your pet\'s name',
                        hintStyle: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                        filled: true,
                        fillColor: inputFillColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(
                          Icons.pets,
                          color: AppColors.orange,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your pet\'s name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Pet type
                    Text(
                      localizations.petType,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        for (int i = 0; i < _allowedSpecies.length; i++)
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: i < _allowedSpecies.length - 1 ? 8 : 0,
                              ),
                              child: _buildSpeciesOption(_allowedSpecies[i], isDark),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Gender
                    Text(
                      localizations.gender,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildGenderOption(
                              'MALE', Icons.male, Colors.blue, isDark),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildGenderOption(
                              'FEMALE', Icons.female, Colors.pink, isDark),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Birthdate
                    Text(
                      localizations.birthdate,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: inputFillColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: AppColors.orange,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              _formatMonthYear(_selectedMonth, _selectedYear),
                              style: TextStyle(
                                fontSize: 16,
                                color: textColor,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.arrow_drop_down,
                              color: isDark ? Colors.grey[400] : Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Weight
                    Text(
                      localizations.weightKg,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _weightController,
                      style: TextStyle(color: textColor),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        hintText: localizations.enterPetWeight,
                        hintStyle: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                        filled: true,
                        fillColor: inputFillColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(
                          Icons.monitor_weight,
                          color: AppColors.orange,
                        ),
                        suffixText: localizations.kg,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Allergies
                    Text(
                      localizations.allergies,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: inputFillColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _allergies.map((allergy) {
                              return Chip(
                                label: Text(allergy),
                                deleteIcon: const Icon(Icons.close, size: 18),
                                onDeleted: () {
                                  setState(() {
                                    _allergies.remove(allergy);
                                  });
                                },
                                backgroundColor:
                                    AppColors.orange.withValues(alpha: 0.2),
                                labelStyle: TextStyle(color: textColor),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _allergyController,
                                  style: TextStyle(color: textColor),
                                  decoration: InputDecoration(
                                    hintText: localizations.addAllergy,
                                    hintStyle: TextStyle(
                                      color: isDark
                                          ? Colors.grey[400]
                                          : Colors.grey[600],
                                    ),
                                    border: InputBorder.none,
                                    prefixIcon: const Icon(
                                      Icons.warning_amber,
                                      color: AppColors.orange,
                                    ),
                                  ),
                                  onSubmitted: (value) {
                                    if (value.trim().isNotEmpty &&
                                        !_allergies.contains(value.trim())) {
                                      setState(() {
                                        _allergies.add(value.trim());
                                        _allergyController.clear();
                                      });
                                    }
                                  },
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle,
                                    color: AppColors.orange),
                                onPressed: () {
                                  final value = _allergyController.text.trim();
                                  if (value.isNotEmpty &&
                                      !_allergies.contains(value)) {
                                    setState(() {
                                      _allergies.add(value);
                                      _allergyController.clear();
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Spay/Neuter Status
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: inputFillColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.medical_services,
                            color: AppColors.orange,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              localizations.spayedNeuteredQuestion,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ),
                          Switch(
                            value: _spayNeuterStatus,
                            onChanged: (value) {
                              setState(() {
                                _spayNeuterStatus = value;
                              });
                            },
                            activeThumbColor: AppColors.orange,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Notes
                    Text(
                      localizations.notes,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _notesController,
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        hintText: 'Any additional information about your pet',
                        hintStyle: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                        filled: true,
                        fillColor: inputFillColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(
                          Icons.note_alt,
                          color: AppColors.orange,
                        ),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 4,
                    ),
                    const SizedBox(height: 30),

                    // Update button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _updatePet,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.orange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                localizations.updatePet,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpeciesOption(String species, bool isDark) {
    final bool isSelected = _selectedSpecies == species;

    IconData iconData;
    Color color;
    String displayName;

    switch (species) {
      case 'dog':
        iconData = Icons.pets;
        color = Colors.blue;
        displayName = 'Dog';
        break;
      case 'cat':
        iconData = Icons.pets;
        color = Colors.purple;
        displayName = 'Cat';
        break;
      default:
        iconData = Icons.pets;
        color = AppColors.orange;
        displayName = species.toUpperCase();
    }

    final backgroundColor = isDark
        ? (isSelected ? color.withValues(alpha: 0.2) : Colors.grey[800])
        : (isSelected ? color.withValues(alpha: 0.1) : Colors.grey[100]);

    final textColor = isDark
        ? (isSelected ? color : Colors.grey[400])
        : (isSelected ? color : Colors.grey[700]);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSpecies = species;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              iconData,
              color: isSelected
                  ? color
                  : (isDark ? Colors.grey[400] : Colors.grey),
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              displayName,
              style: TextStyle(
                color: textColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderOption(
      String gender, IconData icon, Color color, bool isDark) {
    final bool isSelected = _selectedGender == gender;

    final backgroundColor = isDark
        ? (isSelected ? color.withValues(alpha: 0.2) : Colors.grey[800])
        : (isSelected ? color.withValues(alpha: 0.1) : Colors.grey[100]);

    final textColor = isDark
        ? (isSelected ? color : Colors.grey[400])
        : (isSelected ? color : Colors.grey[700]);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? color
                  : (isDark ? Colors.grey[400] : Colors.grey),
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              gender == 'MALE' ? 'Male' : 'Female',
              style: TextStyle(
                color: textColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
