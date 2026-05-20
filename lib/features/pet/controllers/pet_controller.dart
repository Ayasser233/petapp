import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:petapp/features/pet/models/pet_model.dart';
import 'package:petapp/features/pet/models/pet_species_model.dart';
import 'package:petapp/features/pet/data/repositories/pet_repository.dart';
import 'package:petapp/core/services/auth_service.dart';
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
      // Check authentication before fetching data
      final authService = Get.find<AuthService>();
      if (authService.authStatus != AuthStatus.authenticated) {
        pets.clear();
        error.value = '';
        return;
      }

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

    } catch (e) {
      error.value = 'Failed to load pets: $e';
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

      final species = await _repository.getAllowedSpecies();
      allowedSpecies.assignAll(species);

    } catch (e) {
      // Don't show error for species as it's not critical
    } finally {
      isLoadingSpecies.value = false;
    }
  }

  /// Create a new pet
  Future<bool> createPet(Map<String, dynamic> petData, {String? imagePath}) async {
    // Check authentication before creating pet
    final authService = Get.find<AuthService>();
    if (authService.authStatus != AuthStatus.authenticated) {
      Get.snackbar(
        'Login Required',
        'You need to be logged in to add pets',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    isCreating.value = true;
    error.value = '';

    try {
      final newPet = await _repository.createPet(petData, imagePath: imagePath);
      pets.insert(0, newPet); // Add to beginning of list

      // Don't show snackbar here - let the UI screen handle user feedback
      // to avoid duplicate messages

      return true;
    } catch (e) {
      error.value = 'Failed to create pet: $e';

      // Don't show snackbar here - let the UI screen handle user feedback
      // to avoid duplicate messages

      return false;
    } finally {
      isCreating.value = false;
    }
  }

  /// Get pet by ID and set as selected
  Future<void> getPetById(String id) async {
    // Check authentication before fetching pet details
    final authService = Get.find<AuthService>();
    if (authService.authStatus != AuthStatus.authenticated) {
      selectedPet.value = null;
      return;
    }

    try {
      final pet = await _repository.getPetById(id);
      selectedPet.value = pet;
    } catch (e) {
      error.value = 'Failed to load pet details: $e';
      _handleError(e, 'fetch pet details');
    }
  }

  /// Update pet
  Future<bool> updatePet(String id, Map<String, dynamic> petData, {String? imagePath}) async {
    // Check authentication before updating pet
    final authService = Get.find<AuthService>();
    if (authService.authStatus != AuthStatus.authenticated) {
      Get.snackbar(
        'Login Required',
        'You need to be logged in to update pets',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    isUpdating.value = true;
    error.value = '';

    try {
      // Capture old image URL before update so we can evict it from cache
      final oldImageUrl = pets
          .firstWhereOrNull((p) => p.id == id)
          ?.imageUrl;

      final updatedPet = await _repository.updatePet(id, petData, imagePath: imagePath);

      // Evict stale cached image so the new one loads fresh
      if (oldImageUrl != null && oldImageUrl.isNotEmpty) {
        await CachedNetworkImage.evictFromCache(oldImageUrl);
      }

      // Update in local list
      final index = pets.indexWhere((pet) => pet.id == id);
      if (index != -1) {
        pets[index] = updatedPet;
        pets.refresh(); // Trigger observable update
      }

      // Update selected pet if it's the same
      if (selectedPet.value?.id == id) {
        selectedPet.value = updatedPet;
      }

      // Don't show snackbar here - let the UI screen handle user feedback
      // to avoid duplicate messages

      return true;
    } catch (e) {
      error.value = 'Failed to update pet: $e';

      // Don't show snackbar here - let the UI screen handle user feedback
      // to avoid duplicate messages

      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  /// Soft delete pet
  Future<bool> deletePet(String id) async {
    // Check authentication before deleting pet
    final authService = Get.find<AuthService>();
    if (authService.authStatus != AuthStatus.authenticated) {
      Get.snackbar(
        'Login Required',
        'You need to be logged in to delete pets',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    isDeleting.value = true;
    error.value = '';

    try {

      await _repository.deletePet(id);

      // Remove from local list
      pets.removeWhere((pet) => pet.id == id);

      // Clear selected pet if it's the same
      if (selectedPet.value?.id == id) {
        selectedPet.value = null;
      }

      // Don't show snackbar here - let the UI screen handle user feedback
      // to avoid duplicate messages

      return true;
    } catch (e) {
      error.value = 'Failed to delete pet: $e';

      // Don't show snackbar here - let the UI screen handle user feedback
      // to avoid duplicate messages

      return false;
    } finally {
      isDeleting.value = false;
    }
  }

  /// Restore soft-deleted pet
  Future<bool> restorePet(String id) async {
    // Check authentication before restoring pet
    final authService = Get.find<AuthService>();
    if (authService.authStatus != AuthStatus.authenticated) {
      Get.snackbar(
        'Login Required',
        'You need to be logged in to restore pets',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    isRestoring.value = true;
    error.value = '';

    try {

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

      return true;
    } catch (e) {
      error.value = 'Failed to restore pet: $e';

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

      return true;
    } catch (e) {
      error.value = 'Failed to permanently delete pet: $e';

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

      final petData = await _repository.getPetWithAppointments(id);
      petWithAppointments.value = petData;

    } catch (e) {
      error.value = 'Failed to load pet appointments: $e';

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
        error.toString().contains('unauthorized') ||
        error.toString().contains('token') ||
        error.toString().contains('Unauthorized')) {
      // Handle token expiration through AuthService for consistency
      final authService = Get.find<AuthService>();
      authService.handleTokenExpiration();
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
