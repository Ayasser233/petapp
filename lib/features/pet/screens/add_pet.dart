import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/services/auth_service.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/di/service_locator.dart';
import 'package:petapp/features/pet/controllers/pet_controller.dart';
import 'package:petapp/features/pet/utils/pet_constants.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:petapp/core/utils/arabic_numeral_formatter.dart';
import 'package:petapp/core/utils/formatters.dart';

class AddPetScreen extends StatefulWidget {
  const AddPetScreen({super.key});

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  final _weightController = TextEditingController();
  final _allergyController = TextEditingController();
  final _ageController = TextEditingController();

  String _selectedSpecies = 'dog';
  String _selectedGender = 'MALE';
  String _selectedAgeUnit = 'years'; // days, months, years

  String? _imagePath;
  bool _isImageFromGallery = false;
  bool _isLoading = false;
  bool _spayNeuterStatus = false;
  final List<String> _allergies = [];

  final AuthService _authService = sl<AuthService>();
  final PetController _petController = sl<PetController>();

  List<String> _allowedSpecies = [];

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
    _loadAllowedSpecies();
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
        content: Text(localizations.loginRequiredToAddPets),
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
    _ageController.dispose();
    super.dispose();
  }

  /// Calculate birthdate from age
  DateTime _calculateBirthdate() {
    final now = DateTime.now();
    final ageValue = int.tryParse(TFormatter.toEnglishNumerals(_ageController.text.trim())) ?? 0;

    switch (_selectedAgeUnit) {
      case 'days':
        return now.subtract(Duration(days: ageValue));
      case 'months':
        return DateTime(now.year, now.month - ageValue, now.day);
      case 'years':
      default:
        return DateTime(now.year - ageValue, now.month, now.day);
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

    // Show options dialog
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Theme.of(context).cardColor,
      builder: (dialogContext) {
        final dialogLocalizations = AppLocalizations.of(dialogContext);
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                dialogLocalizations.choosePhoto,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(dialogContext).textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImageSourceOption(
                    icon: Icons.camera_alt,
                    label: dialogLocalizations.camera,
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
                  _buildImageSourceOption(
                    icon: Icons.photo_library,
                    label: dialogLocalizations.gallery,
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
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.orange.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.orange,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _savePet() async {
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

      // TODO: In a real app, you would save the image to storage and get a URL
      // final String imageToUse = _isImageFromGallery
      //     ? _imagePath
      //     : _selectedSpecies == 'dog'
      //         ? 'assets/images/dog_silhouette.png'
      //         : _selectedSpecies == 'cat'
      //             ? 'assets/images/cat_silhouette.png'
      //             : 'assets/images/pet_placeholder.jpg';

      // Calculate birthdate from age input
      final birthDate = _calculateBirthdate();
      final dateString = birthDate.toIso8601String().split('T')[0];

      // Create pet data
      final petData = {
        'name': _nameController.text.trim(),
        'species': _selectedSpecies.substring(0, 1).toUpperCase() +
            _selectedSpecies
                .substring(1)
                .toLowerCase(), // Backend expects "Dog" or "Cat" (capitalized)
        'gender': _selectedGender, // MALE or FEMALE
        'dateOfBirth':
            dateString, // Backend expects YYYY-MM-DD format with 1st day of month
        'allergies': _allergies,
        'spayNeuterStatus': _spayNeuterStatus,
        'weight': _weightController.text.trim().isNotEmpty
            ? double.tryParse(TFormatter.toEnglishNumerals(
                    _weightController.text.trim())) ??
                0.0
            : null,
        'notes': _notesController.text.trim().isNotEmpty
            ? _notesController.text.trim()
            : null,
      };

      // Pass image path if user selected an image
      final String? imagePathToSend = _isImageFromGallery ? _imagePath : null;

      final success = await _petController.createPet(
        petData,
        imagePath: imagePathToSend,
      );

      if (success) {
        // Refresh the pets list to show the new pet
        await _petController.refreshPets();

        // Go back to My Pets screen after successful addition
        Get.back();
        Get.snackbar(
          localizations.success,
          localizations.petAddedSuccessfully
              .replaceAll('{name}', _nameController.text),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green[100],
          colorText: Colors.green[800],
        );
      }
    } catch (e) {
      Get.snackbar(
        localizations.error,
        localizations.failedToAddPet,
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
    final localizations = AppLocalizations.of(context);
    final isDark = THelperFunctions.isDarkMode(context);
    final backgroundColor = isDark ? Colors.grey[900] : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final inputFillColor = isDark ? Colors.grey[800] : Colors.grey[100];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          localizations.addNewPet,
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
                            child: _isImageFromGallery && _imagePath != null
                                ? Image.file(
                                    File(_imagePath!),
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.orange.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(60),
                                    ),
                                    child: const Icon(
                                      Icons.pets,
                                      size: 60,
                                      color: AppColors.orange,
                                    ),
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
                        hintText: localizations.enterPetName,
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
                          return localizations.pleaseEnterPetName;
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

                    // Age
                    Text(
                      localizations.age,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Builder(
                      builder: (context) {
                        final locale = Localizations.localeOf(context);
                        final isArabic = locale.languageCode == 'ar';

                        return Row(
                          children: [
                            // Age number input
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: _ageController,
                                style: TextStyle(color: textColor),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  ArabicNumeralInputFormatter(isArabic),
                                ],
                                decoration: InputDecoration(
                                  hintText: localizations.enterPetAge,
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
                                    Icons.cake,
                                    color: AppColors.orange,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return localizations.pleaseEnterValidAge;
                                  }
                                  final age = int.tryParse(TFormatter.toEnglishNumerals(value));
                                  if (age == null || age <= 0) {
                                    return localizations.pleaseEnterValidAge;
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Age unit dropdown
                            Expanded(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: inputFillColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: DropdownButtonFormField<String>(
                                  initialValue: _selectedAgeUnit,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: inputFillColor,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 16,
                                    ),
                                  ),
                                  dropdownColor: isDark ? Colors.grey[850] : Colors.white,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 16,
                                  ),
                                  items: [
                                    DropdownMenuItem(
                                      value: 'days',
                                      child: Text(localizations.days),
                                    ),
                                    DropdownMenuItem(
                                      value: 'months',
                                      child: Text(localizations.months),
                                    ),
                                    DropdownMenuItem(
                                      value: 'years',
                                      child: Text(localizations.years),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedAgeUnit = value!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      },
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
                    Builder(
                      builder: (context) {
                        final locale = Localizations.localeOf(context);
                        final isArabic = locale.languageCode == 'ar';

                        return TextFormField(
                          controller: _weightController,
                          style: TextStyle(color: textColor),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            ArabicNumeralInputFormatter(isArabic),
                          ],
                          decoration: InputDecoration(
                            hintText: localizations.enterPetWeight,
                            hintStyle: TextStyle(
                              color:
                                  isDark ? Colors.grey[400] : Colors.grey[600],
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
                        );
                      },
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
                        hintText: localizations.addNotes,
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

                    // Save button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _savePet,
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
                                localizations.savePet,
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
