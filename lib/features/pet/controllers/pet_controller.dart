import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/features/pet/models/pet_model.dart';
import 'package:petapp/features/pet/models/pet_species_model.dart';
import 'package:petapp/features/pet/data/repositories/pet_repository.dart';
import 'package:petapp/di/service_locator.dart';

class PetController extends GetxController {
  // Repository dependency
  final PetRepository _repository;

  // Observable state
  final RxList<PetModel> pets = <PetModel>[].obs;
  final RxList<PetSpecies> allowedSpecies = <PetSpecies>[].obs;
  final Rx<PetModel?> selectedPet = Rx<PetModel?>(null);
  final Rx<Map<String, dynamic>?> petWithAppointments =
      Rx<Map<String, dynamic>?>(null);

  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isLoadingSpecies = false.obs;
  final RxBool isCreating = false.obs;
  final RxBool isUpdating = false.obs;
  final RxBool isDeleting = false.obs;
  final RxBool isRestoring = false.obs;

  // Pagination state
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxBool hasMorePages = false.obs;

  // Error handling
  final RxString error = ''.obs;

  // Initialize with repository
  PetController({PetRepository? repository})
      : _repository = repository ?? sl<PetRepository>();

  @override
  void onInit() {
    super.onInit();
    fetchPets();
    fetchAllowedSpecies();
  }

  /// Fetch all pets for the user with pagination
  Future<void> fetchPets({int? page, int? limit, bool append = false}) async {
    if (!append) {
      isLoading.value = true;
    }
    error.value = '';

    try {
      print('🐾 Controller: Fetching pets (page: $page, limit: $limit)');

      final fetchedPets = await _repository.getUserPets(
          page: page ?? currentPage.value, limit: limit ?? 20);

      if (append) {
        pets.addAll(fetchedPets);
      } else {
        pets.assignAll(fetchedPets);
      }

      // Update pagination state
      if (page != null) {
        currentPage.value = page;
      }
      hasMorePages.value = fetchedPets.length == (limit ?? 20);

      // Clear error since we successfully got data (even if empty)
      error.value = '';

      // Log different scenarios for debugging
      if (fetchedPets.isEmpty) {
        print('📝 Controller: No pets found - user will see empty state');
      } else {
        print('✅ Controller: Fetched ${fetchedPets.length} pets');
      }
    } catch (e) {
      error.value = 'Failed to load pets: $e';
      print('❌ Controller: Failed to fetch pets: $e');

      // Only show error snackbar for actual failures, not when we have fallback data
      // The repository handles failures gracefully by returning fallback data
      // If we reach this catch block, it means the repository couldn't return any data
      _handleError(e, 'fetch pets');
    } finally {
      isLoading.value = false;
    }
  }

  /// Load more pets (for pagination)
  Future<void> loadMorePets() async {
    if (hasMorePages.value && !isLoading.value) {
      await fetchPets(page: currentPage.value + 1, append: true);
    }
  }

  /// Refresh pets list
  Future<void> refreshPets() async {
    currentPage.value = 1;
    hasMorePages.value = false;
    await fetchPets();
  }

  /// Fetch allowed pet species
  Future<void> fetchAllowedSpecies() async {
    isLoadingSpecies.value = true;

    try {
      print('🐾 Controller: Fetching allowed species');

      final species = await _repository.getAllowedSpecies();
      allowedSpecies.assignAll(species);

      print('✅ Controller: Fetched ${species.length} species');
    } catch (e) {
      print('❌ Controller: Failed to fetch species: $e');
      // Don't show error for species as it's not critical
    } finally {
      isLoadingSpecies.value = false;
    }
  }

  /// Create a new pet
  Future<bool> createPet(Map<String, dynamic> petData) async {
    isCreating.value = true;
    error.value = '';

    try {
      print('🐾 Controller: Creating new pet');

      final newPet = await _repository.createPet(petData);
      pets.insert(0, newPet); // Add to beginning of list

      Get.snackbar(
        'Success',
        'Pet created successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      print('✅ Controller: Pet created successfully');
      return true;
    } catch (e) {
      error.value = 'Failed to create pet: $e';
      print('❌ Controller: Failed to create pet: $e');

      Get.snackbar(
        'Error',
        'Failed to create pet: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      return false;
    } finally {
      isCreating.value = false;
    }
  }

  /// Get pet by ID and set as selected
  Future<void> getPetById(String id) async {
    try {
      print('🐾 Controller: Fetching pet details for ID: $id');

      final pet = await _repository.getPetById(id);
      selectedPet.value = pet;

      print('✅ Controller: Pet details fetched successfully');
    } catch (e) {
      error.value = 'Failed to load pet details: $e';
      print('❌ Controller: Failed to fetch pet details: $e');

      _handleError(e, 'fetch pet details');
    }
  }

  /// Update pet
  Future<bool> updatePet(String id, Map<String, dynamic> petData) async {
    isUpdating.value = true;
    error.value = '';

    try {
      print('🐾 Controller: Updating pet $id');

      final updatedPet = await _repository.updatePet(id, petData);

      // Update in local list
      final index = pets.indexWhere((pet) => pet.id == id);
      if (index != -1) {
        pets[index] = updatedPet;
      }

      // Update selected pet if it's the same
      if (selectedPet.value?.id == id) {
        selectedPet.value = updatedPet;
      }

      Get.snackbar(
        'Success',
        'Pet updated successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      print('✅ Controller: Pet updated successfully');
      return true;
    } catch (e) {
      error.value = 'Failed to update pet: $e';
      print('❌ Controller: Failed to update pet: $e');

      Get.snackbar(
        'Error',
        'Failed to update pet: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  /// Soft delete pet
  Future<bool> deletePet(String id) async {
    isDeleting.value = true;
    error.value = '';

    try {
      print('🐾 Controller: Deleting pet $id');

      await _repository.deletePet(id);

      // Remove from local list
      pets.removeWhere((pet) => pet.id == id);

      // Clear selected pet if it's the same
      if (selectedPet.value?.id == id) {
        selectedPet.value = null;
      }

      Get.snackbar(
        'Success',
        'Pet deleted successfully',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      print('✅ Controller: Pet deleted successfully');
      return true;
    } catch (e) {
      error.value = 'Failed to delete pet: $e';
      print('❌ Controller: Failed to delete pet: $e');

      Get.snackbar(
        'Error',
        'Failed to delete pet: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      return false;
    } finally {
      isDeleting.value = false;
    }
  }

  /// Restore soft-deleted pet
  Future<bool> restorePet(String id) async {
    isRestoring.value = true;
    error.value = '';

    try {
      print('🐾 Controller: Restoring pet $id');

      final restoredPet = await _repository.restorePet(id);

      // Add back to local list
      pets.insert(0, restoredPet);

      Get.snackbar(
        'Success',
        'Pet restored successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      print('✅ Controller: Pet restored successfully');
      return true;
    } catch (e) {
      error.value = 'Failed to restore pet: $e';
      print('❌ Controller: Failed to restore pet: $e');

      Get.snackbar(
        'Error',
        'Failed to restore pet: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      return false;
    } finally {
      isRestoring.value = false;
    }
  }

  /// Permanently delete pet (admin only)
  Future<bool> hardDeletePet(String id) async {
    isDeleting.value = true;
    error.value = '';

    try {
      print('🐾 Controller: Permanently deleting pet $id');

      await _repository.hardDeletePet(id);

      // Remove from local list
      pets.removeWhere((pet) => pet.id == id);

      // Clear selected pet if it's the same
      if (selectedPet.value?.id == id) {
        selectedPet.value = null;
      }

      Get.snackbar(
        'Success',
        'Pet permanently deleted',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      print('✅ Controller: Pet permanently deleted');
      return true;
    } catch (e) {
      error.value = 'Failed to permanently delete pet: $e';
      print('❌ Controller: Failed to permanently delete pet: $e');

      Get.snackbar(
        'Error',
        'Failed to permanently delete pet: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      return false;
    } finally {
      isDeleting.value = false;
    }
  }

  /// Get pet with appointments
  Future<void> getPetWithAppointments(String id) async {
    try {
      print('🐾 Controller: Fetching pet with appointments for ID: $id');

      final petData = await _repository.getPetWithAppointments(id);
      petWithAppointments.value = petData;

      print('✅ Controller: Pet with appointments fetched successfully');
    } catch (e) {
      error.value = 'Failed to load pet appointments: $e';
      print('❌ Controller: Failed to fetch pet with appointments: $e');

      _handleError(e, 'fetch pet appointments');
    }
  }

  /// Clear selected pet
  void clearSelectedPet() {
    selectedPet.value = null;
    petWithAppointments.value = null;
  }

  /// Handle errors consistently
  void _handleError(dynamic error, String operation) {
    if (error.toString().contains('Authentication token not found') ||
        error.toString().contains('401') ||
        error.toString().contains('unauthorized')) {
      // Show authentication error message
      Get.snackbar(
        'Authentication Error',
        'Please log in to continue',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );

      // Redirect to login screen after a short delay
      Future.delayed(const Duration(seconds: 2), () {
        Get.offAllNamed('/auth');
      });
    } else {
      // Show generic error
      Get.snackbar(
        'Error',
        'Failed to $operation. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  // Legacy methods - kept for backward compatibility
  Future<void> addPet(PetModel pet) async {
    await createPet(pet.toMap());
  }

  Future<void> updatePetModel(String id, PetModel pet) async {
    await updatePet(id, pet.toMap());
  }
}
