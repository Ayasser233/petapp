import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/features/pet/controllers/pet_controller.dart';
import 'package:petapp/features/pet/models/pet_model.dart';
import 'package:petapp/features/pet/screens/add_pet.dart';
import 'package:petapp/features/pet/screens/pet_profile.dart';
import 'package:petapp/di/service_locator.dart';

class MyPetsScreen extends StatefulWidget {
  const MyPetsScreen({super.key});

  @override
  State<MyPetsScreen> createState() => _MyPetsScreenState();
}

class _MyPetsScreenState extends State<MyPetsScreen> {
  // Using GetX controller for state management
  final PetController _petController = Get.put(sl<PetController>());

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
          AppLocalizations.of(context).myPets,
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
            tooltip: AppLocalizations.of(context).refreshPets,
          ),
        ],
      ),
      body: Obx(() {
        // Show loading indicator
        if (_petController.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.orange));
        }

        // Show error message if any
        if (_petController.error.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 60),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context).errorLoadingPets,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor),
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
                  child: Text(AppLocalizations.of(context).retry),
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
                        ? Colors.black.withValues(alpha: 0.2)
                        : Colors.grey.withValues(alpha: 0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                '${_petController.pets.length} ${_petController.pets.length == 1 ? AppLocalizations.of(context).pet : AppLocalizations.of(context).pets}',
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
                  return _buildPetCard(
                      pet, isDark, cardColor!, textColor, subTextColor!);
                },
              ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Get.to(() => const AddPetScreen());
          if (result == true) {
            // Refresh the pets list after successful addition
            _petController.fetchPets();
          }
        },
        backgroundColor: AppColors.orange,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(AppLocalizations.of(context).addPet),
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
              color: AppColors.orange.withValues(alpha: isDark ? 0.2 : 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.pets,
              size: 80,
              color: AppColors.orange.withValues(alpha: isDark ? 0.8 : 0.7),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context).noPetsAddedYet,
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
              AppLocalizations.of(context).addYourFurryFriends,
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
              if (result == true) {
                // Refresh the pets list after successful addition
                _petController.fetchPets();
              }
            },
            icon: const Icon(Icons.add),
            label: Text(AppLocalizations.of(context).addYourFirstPet),
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

  Widget _buildPetCard(PetModel pet, bool isDark, Color cardColor,
      Color textColor, Color subTextColor) {
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
        ? Colors.black.withValues(alpha: 0.3)
        : Colors.grey.withValues(alpha: 0.1);

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
                  child: _buildPetImage(pet, 80),
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
                        Flexible(
                          child: Text(
                            pet.name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Pet species tag
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: petTypeColor.withValues(
                                alpha: isDark ? 0.2 : 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            pet.species,
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
                    if (pet.medicalHistory?.notes != null &&
                        pet.medicalHistory!.notes!.isNotEmpty) ...[
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

  /// Renders the pet avatar — network URL first, local asset as fallback
  Widget _buildPetImage(PetModel pet, double size) {
    final networkUrl = pet.imageUrl ?? '';
    final isNetwork = networkUrl.isNotEmpty &&
        (networkUrl.startsWith('http://') ||
            networkUrl.startsWith('https://'));

    if (isNetwork) {
      return CachedNetworkImage(
        imageUrl: networkUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: size,
          height: size,
          color: Colors.grey[300],
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.orange,
            ),
          ),
        ),
        errorWidget: (context, url, error) => _localAssetImage(pet, size),
      );
    }
    return _localAssetImage(pet, size);
  }

  Widget _localAssetImage(PetModel pet, double size) {
    return Image.asset(
      pet.image,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (context, _, __) => Container(
        width: size,
        height: size,
        color: Colors.grey[300],
        child: const Icon(Icons.pets, color: Colors.grey, size: 36),
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
      return years == 1
          ? '1 ${AppLocalizations.of(context).yearOld}'
          : '$years ${AppLocalizations.of(context).yearsOld}';
    } else {
      return months == 1
          ? '1 ${AppLocalizations.of(context).monthOld}'
          : '$months ${AppLocalizations.of(context).monthsOld}';
    }
  }
}
