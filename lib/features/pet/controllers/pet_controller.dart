import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/features/pet/models/pet_model.dart';
import 'package:petapp/features/pet/data/repositories/pet_repository.dart';

class PetController extends GetxController {
  // Repository dependency
  final PetRepository _repository;
  
  // Observable state
  final RxList<PetModel> pets = <PetModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  // Initialize with repository
  PetController({PetRepository? repository}) 
    : _repository = repository ?? PetRepository();

  @override
  void onInit() {
    super.onInit();
    fetchPets();
  }

  // Fetch all pets for the user
  Future<void> fetchPets() async {
    isLoading.value = true;
    error.value = '';
    
    try {
      final fetchedPets = await _repository.getUserPets();
      pets.assignAll(fetchedPets);
    } catch (e) {
      error.value = 'Failed to load pets: $e';
      
      // Handle authentication errors
      if (e.toString().contains('Authentication token not found') || 
          e.toString().contains('401')) {
        // Show error message
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
          // Use the appropriate route for your login screen
          Get.offAllNamed('/login');
        });
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Add a new pet
  Future<bool> addPet(PetModel pet) async {
    isLoading.value = true;
    error.value = '';
    
    try {
      final newPet = await _repository.addPet(pet);
      pets.add(newPet);
      return true;
    } catch (e) {
      error.value = 'Failed to add pet: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Update an existing pet
  Future<bool> updatePet(String id, PetModel updatedPet) async {
    isLoading.value = true;
    error.value = '';
    
    try {
      final pet = await _repository.updatePet(id, updatedPet);
      final index = pets.indexWhere((p) => p.id == id);
      if (index != -1) {
        pets[index] = pet;
      }
      return true;
    } catch (e) {
      error.value = 'Failed to update pet: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Delete a pet
  Future<bool> deletePet(String id) async {
    isLoading.value = true;
    error.value = '';
    
    try {
      final success = await _repository.deletePet(id);
      if (success) {
        pets.removeWhere((pet) => pet.id == id);
      }
      return success;
    } catch (e) {
      error.value = 'Failed to delete pet: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Get a specific pet by ID
  Future<PetModel?> getPetById(String id) async {
    try {
      return await _repository.getPetById(id);
    } catch (e) {
      error.value = 'Failed to get pet details: $e';
      return null;
    }
  }
}
