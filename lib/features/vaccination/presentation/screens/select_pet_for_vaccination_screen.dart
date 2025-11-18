import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/features/pet/controllers/pet_controller.dart';
import 'package:petapp/features/pet/models/pet_model.dart';
import 'package:petapp/di/service_locator.dart';
import '../cubit/vaccination_cubit.dart';
import 'pet_vaccination_record_screen.dart';

/// Select Pet for Vaccination Screen
///
/// Allows user to select a pet to view vaccination records
class SelectPetForVaccinationScreen extends StatefulWidget {
  const SelectPetForVaccinationScreen({super.key});

  @override
  State<SelectPetForVaccinationScreen> createState() =>
      _SelectPetForVaccinationScreenState();
}

class _SelectPetForVaccinationScreenState
    extends State<SelectPetForVaccinationScreen> {
  final PetController _petController = Get.put(sl<PetController>());

  @override
  void initState() {
    super.initState();
    _petController.fetchPets();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final backgroundColor = isDark ? Colors.grey[900] : Colors.grey[50];
    final cardColor = isDark ? Colors.grey[850] : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).selectPet,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: cardColor,
      ),
      body: Obx(() {
        if (_petController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.orange),
          );
        }

        if (_petController.error.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 60),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context).errorLoadingPets,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    _petController.error.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
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

        if (_petController.pets.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.pets, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context).noPetsFound,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context).addPetToViewVaccination,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => Get.toNamed('/add-pet'),
                  icon: const Icon(Icons.add),
                  label: Text(AppLocalizations.of(context).addPet),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context).selectPetToViewVaccination,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: _petController.pets.length,
                  itemBuilder: (context, index) {
                    final pet = _petController.pets[index];
                    return _buildPetCard(context, pet, isDark, cardColor);
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildPetCard(
    BuildContext context,
    PetModel pet,
    bool isDark,
    Color? cardColor,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => sl<VaccinationCubit>(),
              child: PetVaccinationRecordScreen(pet: pet),
            ),
          ),
        );
      },
      child: Container(
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Pet Image
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.orange.withValues(alpha: 0.1),
                image: pet.imageUrl != null && pet.imageUrl!.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(pet.imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: pet.imageUrl == null || pet.imageUrl!.isEmpty
                  ? const Icon(
                      Icons.pets,
                      color: AppColors.orange,
                      size: 50,
                    )
                  : null,
            ),
            const SizedBox(height: 12),

            // Pet Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                pet.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),

            // Pet Type
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                _translateSpecies(context, pet.species),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),

            // Vaccination Icon
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.vaccines,
                    color: AppColors.orange,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    AppLocalizations.of(context).viewRecord,
                    style: const TextStyle(
                      color: AppColors.orange,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _translateSpecies(BuildContext context, String species) {
    final loc = AppLocalizations.of(context);
    final lowerSpecies = species.toLowerCase();

    if (lowerSpecies.contains('dog') || lowerSpecies.contains('كلب')) {
      return loc.dog;
    } else if (lowerSpecies.contains('cat') ||
        lowerSpecies.contains('قط') ||
        lowerSpecies.contains('قطة')) {
      return loc.cat;
    }

    return species; // Return original if no match
  }
}
