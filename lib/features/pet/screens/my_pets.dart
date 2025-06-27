import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/features/pet/controllers/pet_controller.dart';
import 'package:petapp/features/pet/models/pet_model.dart';
import 'package:petapp/features/pet/screens/add_pet.dart';
import 'package:petapp/features/pet/screens/pet_profile.dart';

class MyPetsScreen extends StatefulWidget {
  const MyPetsScreen({super.key});

  @override
  State<MyPetsScreen> createState() => _MyPetsScreenState();
}

class _MyPetsScreenState extends State<MyPetsScreen> {
  // Using GetX controller for state management
  final PetController _petController = Get.put(PetController());

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final backgroundColor = isDark ? Colors.grey[900] : Colors.grey[50];
    final cardColor = isDark ? Colors.grey[850] : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[700];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'My Pets',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: cardColor,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: textColor),
            onPressed: () => _petController.fetchPets(),
            tooltip: 'Refresh pets',
          ),
        ],
      ),
      body: Obx(() {
        // Show loading indicator
        if (_petController.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: AppColors.orange));
        }
        
        // Show error message if any
        if (_petController.error.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 60),
                const SizedBox(height: 16),
                Text(
                  'Error loading pets',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    _petController.error.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: subTextColor),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _petController.fetchPets,
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
        
        // Show empty state if no pets
        if (_petController.pets.isEmpty) {
          return _buildEmptyState(isDark, textColor, subTextColor!);
        }
        
        // Show list of pets
        return Column(
          children: [
            // Header with count
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: cardColor,
                boxShadow: [
                  BoxShadow(
                    color: isDark 
                        ? Colors.black.withOpacity(0.2) 
                        : Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                '${_petController.pets.length} ${_petController.pets.length == 1 ? 'Pet' : 'Pets'}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: subTextColor,
                ),
              ),
            ),
            
            // Pet list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _petController.pets.length,
                itemBuilder: (context, index) {
                  final pet = _petController.pets[index];
                  return _buildPetCard(pet, isDark, cardColor!, textColor, subTextColor!);
                },
              ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Get.to(() => const AddPetScreen());
          if (result != null && result is PetModel) {
            _petController.addPet(result);
          }
        },
        backgroundColor: AppColors.orange,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Pet'),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark, Color textColor, Color subTextColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: AppColors.orange.withOpacity(isDark ? 0.2 : 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.pets,
              size: 80,
              color: AppColors.orange.withOpacity(isDark ? 0.8 : 0.7),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No pets added yet',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Add your furry friends to keep track of their health and appointments',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: subTextColor,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () async {
              final result = await Get.to(() => const AddPetScreen());
              if (result != null && result is PetModel) {
                _petController.addPet(result);
              }
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Your First Pet'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: isDark ? 4 : 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPetCard(PetModel pet, bool isDark, Color cardColor, Color textColor, Color subTextColor) {
    // Get pet age
    final age = _calculateAge(pet.dateOfBirth);
    
    // Pet species color
    Color petTypeColor = pet.species.toLowerCase() == 'dog' 
        ? Colors.blue 
        : pet.species.toLowerCase() == 'cat' 
            ? Colors.purple 
            : AppColors.orange;
            
    // Shadow color adjusted for theme
    Color shadowColor = isDark 
        ? Colors.black.withOpacity(0.3) 
        : Colors.grey.withOpacity(0.1);
        
    // Background for arrow icon
    Color arrowBgColor = isDark ? Colors.grey[800]! : Colors.grey[100]!;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () async {
          final result = await Get.to(
            () => PetProfileScreen(pet: pet),
          );
          if (result == 'delete') {
            _petController.deletePet(pet.id);
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Pet image with colored border based on pet type
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: petTypeColor,
                    width: 3,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.asset(
                    pet.image,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Pet details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          pet.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Pet species tag
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: petTypeColor.withOpacity(isDark ? 0.2 : 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            pet.customSpecies ?? pet.species,
                            style: TextStyle(
                              color: petTypeColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.cake_outlined,
                          size: 16,
                          color: subTextColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          age,
                          style: TextStyle(
                            color: subTextColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    if (pet.medicalHistory?.notes != null && pet.medicalHistory!.notes!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: subTextColor,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              pet.medicalHistory!.notes!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: subTextColor,
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    // Show breed if available
                    if (pet.breed != null && pet.breed!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.pets,
                            size: 16,
                            color: subTextColor,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Breed: ${pet.breed}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: subTextColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              // Arrow icon with circle background
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: arrowBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: isDark ? Colors.grey[400] : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _calculateAge(String dateOfBirth) {
    final birth = DateTime.parse(dateOfBirth);
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
}