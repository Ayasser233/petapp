import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/services/auth_service.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/di/service_locator.dart';
import 'package:petapp/features/pet/controllers/pet_controller.dart';
import 'package:petapp/features/pet/models/pet_model.dart';
import 'package:petapp/features/pet/utils/pet_constants.dart';
import 'package:image_picker/image_picker.dart';
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
  late DateTime _selectedDate;
  String _imagePath = 'assets/images/pet_placeholder.jpg';
  bool _isImageFromGallery = false;
  bool _isLoading = false;
  late bool _spayNeuterStatus;
  late List<String> _allergies;

  final AuthService _authService = sl<AuthService>();
  final PetController _petController = sl<PetController>();

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
    _selectedDate = DateTime.parse(widget.pet.dateOfBirth);
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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Login Required'),
        content: const Text('You need to be logged in to update pets.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Get.back(); // Go back to previous screen
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Get.offNamed(AppRoutes.login); // Navigate to login screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
            ),
            child: const Text('Login'),
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

    // Show options dialog
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(context);
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
              title: const Text('Take a Photo'),
              onTap: () async {
                Navigator.pop(context);
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.orange,
              onPrimary: Colors.white,
              onSurface: isDark ? Colors.white : Colors.black,
              surface: isDark ? Colors.grey[850]! : Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.orange,
              ),
            ),
            dialogTheme: DialogThemeData(
                backgroundColor: isDark ? Colors.grey[900] : Colors.white),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _updatePet() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Validate species
      if (!PetConstants.isValidSpecies(_selectedSpecies)) {
        Get.snackbar(
          'Invalid Species',
          'Only cats and dogs are allowed.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[800],
        );
        return;
      }

      // Create pet data
      final petData = {
        'name': _nameController.text.trim(),
        'species': _selectedSpecies.substring(0, 1).toUpperCase() +
            _selectedSpecies
                .substring(1)
                .toLowerCase(), // Backend expects "Dog" or "Cat" (capitalized)
        'gender': _selectedGender, // MALE or FEMALE
        'dateOfBirth': _selectedDate
            .toIso8601String()
            .split('T')[0], // Backend expects camelCase
        'allergies': _allergies,
        'spayNeuterStatus': _spayNeuterStatus,
        'weight': _weightController.text.trim().isNotEmpty 
            ? double.tryParse(_weightController.text.trim()) ?? 0.0
            : null,
        'notes': _notesController.text.trim().isNotEmpty 
            ? _notesController.text.trim() 
            : null,
      };

      final success = await _petController.updatePet(widget.pet.id, petData);

      if (success) {
        Get.back(result: true);
        Get.snackbar(
          'Success!',
          '${_nameController.text} has been updated successfully.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green[100],
          colorText: Colors.green[800],
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update pet. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final backgroundColor = isDark ? Colors.grey[900] : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final inputFillColor = isDark ? Colors.grey[800] : Colors.grey[100];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Update Pet',
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
                      'Pet Name',
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
                      'Pet Type',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: _allowedSpecies.map((species) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _buildSpeciesOption(species, isDark),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Gender
                    Text(
                      'Gender',
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
                          child: _buildGenderOption('MALE', Icons.male, Colors.blue, isDark),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildGenderOption('FEMALE', Icons.female, Colors.pink, isDark),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Birthdate
                    Text(
                      'Birthdate',
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
                              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
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
                      'Weight (kg)',
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
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        hintText: 'Enter pet weight',
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
                        suffixText: 'kg',
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Allergies
                    Text(
                      'Allergies',
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
                                backgroundColor: AppColors.orange.withValues(alpha: 0.2),
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
                                    hintText: 'Add allergy (e.g., chicken, dairy)',
                                    hintStyle: TextStyle(
                                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                                    ),
                                    border: InputBorder.none,
                                    prefixIcon: const Icon(
                                      Icons.warning_amber,
                                      color: AppColors.orange,
                                    ),
                                  ),
                                  onSubmitted: (value) {
                                    if (value.trim().isNotEmpty && !_allergies.contains(value.trim())) {
                                      setState(() {
                                        _allergies.add(value.trim());
                                        _allergyController.clear();
                                      });
                                    }
                                  },
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle, color: AppColors.orange),
                                onPressed: () {
                                  final value = _allergyController.text.trim();
                                  if (value.isNotEmpty && !_allergies.contains(value)) {
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
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                              'Spayed/Neutered',
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
                            activeColor: AppColors.orange,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Notes
                    Text(
                      'Notes',
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
                        hintText:
                            'Any additional information about your pet',
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
                            : const Text(
                                'Update Pet',
                                style: TextStyle(
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

  Widget _buildGenderOption(String gender, IconData icon, Color color, bool isDark) {
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
