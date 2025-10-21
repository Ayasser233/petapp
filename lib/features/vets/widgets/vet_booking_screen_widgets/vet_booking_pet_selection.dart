import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/features/pet/models/pet_model.dart';
import '../../screens/vet_booking_screen.dart';

class VetBookingPetSelection extends StatelessWidget {
  final VetBookingController controller;

  const VetBookingPetSelection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[700];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).petsForVisitOptional,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showPetSelectionModal(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
            child: Obx(() => controller.selectedPets.isEmpty
                ? _buildEmptyPetSelection(context, subTextColor)
                : _buildSelectedPets(context)),
          ),
        ),
      ],
    );
  }

  /// Build empty pet selection state
  Widget _buildEmptyPetSelection(BuildContext context, Color? subTextColor) {
    return Column(
      children: [
        Icon(
          Icons.pets,
          size: 48,
          color: subTextColor,
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context).tapToSelectPets,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: subTextColor,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          AppLocalizations.of(context).addingPetsOptional,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: subTextColor,
              ),
        ),
      ],
    );
  }

  /// Build selected pets display
  Widget _buildSelectedPets(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.selectedPets.length,
        itemBuilder: (context, index) {
          final pet = controller.selectedPets[index];
          return _buildPetAvatar(context, pet);
        },
      ),
    );
  }

  /// Build pet avatar
  Widget _buildPetAvatar(BuildContext context, PetModel pet) {
    final isDark = THelperFunctions.isDarkMode(context);
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[700];

    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: pet.image.startsWith('assets/')
                    ? AssetImage(pet.image) as ImageProvider
                    : FileImage(File(pet.image)),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: GestureDetector(
                  onTap: () => controller.removePetFromSelection(pet),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            pet.name,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            pet.species.capitalize!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: subTextColor,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Show pet selection modal
  void _showPetSelectionModal(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final backgroundColor = isDark ? Colors.grey[900] : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    
    controller.petController.fetchPets();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                _buildModalHeader(context, textColor),
                Expanded(
                  child: _buildPetList(context, setModalState),
                ),
                _buildModalFooter(context, setModalState),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Build modal header
  Widget _buildModalHeader(BuildContext context, Color textColor) {
    final isDark = THelperFunctions.isDarkMode(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).selectPetsForVisit,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
          ),
        ],
      ),
    );
  }

  /// Build pet list
  Widget _buildPetList(BuildContext context, StateSetter setModalState) {
    final isDark = THelperFunctions.isDarkMode(context);
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[700];

    return Obx(() {
      if (controller.petController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.petController.error.value.isNotEmpty) {
        return _buildErrorState(context, textColor);
      }

      if (controller.petController.pets.isEmpty) {
        return _buildEmptyState(context, textColor);
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.petController.pets.length,
        itemBuilder: (context, index) {
          final pet = controller.petController.pets[index];
          return _buildPetCard(context, pet, setModalState, textColor, subTextColor);
        },
      );
    });
  }

  /// Build error state
  Widget _buildErrorState(BuildContext context, Color textColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).failedToLoadPets,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
          ),
          TextButton(
            onPressed: () => controller.petController.fetchPets(),
            child: Text(AppLocalizations.of(context).retry),
          ),
        ],
      ),
    );
  }

  /// Build empty state
  Widget _buildEmptyState(BuildContext context, Color textColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.pets, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).noPetsYet,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
          ),
          TextButton(
            onPressed: () => Get.toNamed('/add-pet'),
            child: Text(AppLocalizations.of(context).addPet),
          ),
        ],
      ),
    );
  }

  /// Build pet card
  Widget _buildPetCard(
    BuildContext context,
    PetModel pet,
    StateSetter setModalState,
    Color textColor,
    Color? subTextColor,
  ) {
    final isDark = THelperFunctions.isDarkMode(context);
    
    return Obx(() {
      final isSelected = controller.isPetSelected(pet);
      
      return Card(
        margin: const EdgeInsets.only(bottom: 12),
        color: isDark ? Colors.grey[850] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? AppColors.orange : Colors.transparent,
            width: 2,
          ),
        ),
        child: InkWell(
          onTap: () {
            controller.togglePetSelection(pet);
            setModalState(() {});
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: pet.image.startsWith('assets/')
                      ? AssetImage(pet.image) as ImageProvider
                      : FileImage(File(pet.image)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pet.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        pet.species.capitalize!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: subTextColor,
                            ),
                      ),
                      if (pet.medicalHistory?.notes != null && pet.medicalHistory!.notes!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          pet.medicalHistory!.notes!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: subTextColor,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                Checkbox(
                  value: isSelected,
                  onChanged: (value) {
                    controller.togglePetSelection(pet);
                    setModalState(() {});
                  },
                  activeColor: AppColors.orange,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  /// Build modal footer
  Widget _buildModalFooter(BuildContext context, StateSetter setModalState) {
    final isDark = THelperFunctions.isDarkMode(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: AppColors.orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Obx(() => Text(
                AppLocalizations.of(context).confirmPets(controller.selectedPets.length),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              )),
        ),
      ),
    );
  }
}