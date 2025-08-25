import 'package:petapp/features/pet/models/pet_model.dart';
import 'package:petapp/features/pet/services/pet_api_service.dart';

class PetRepository {
  final PetApiService _apiService;
  
  PetRepository({PetApiService? apiService}) 
    : _apiService = apiService ?? PetApiService();

  // Get all pets for the current user
  Future<List<PetModel>> getUserPets() async {
    try {
      return await _apiService.getUserPets();
    } catch (e) {
      // If API fails, return fallback data
      // This could also be loaded from local storage in a real app
      return _getFallbackPets();
    }
  }

  // Get a specific pet by ID
  Future<PetModel> getPetById(String id) async {
    try {
      return await _apiService.getPetById(id);
    } catch (e) {
      // Return a fallback pet if we can't get it from the API
      final fallbackPets = _getFallbackPets();
      final pet = fallbackPets.firstWhere(
        (pet) => pet.id == id, 
        orElse: () => throw Exception('Pet not found')
      );
      return pet;
    }
  }

  // Add a new pet
  Future<PetModel> addPet(PetModel pet) async {
    try {
      return await _apiService.addPet(pet);
    } catch (e) {
      // In a real app, we might save locally if API fails
      // For now, just return the pet with a fake ID
      return pet; // Assuming the ID is already set
    }
  }

  // Update a pet's details
  Future<PetModel> updatePet(String id, PetModel pet) async {
    try {
      return await _apiService.updatePet(id, pet);
    } catch (e) {
      // In a real app, we might update locally if API fails
      return pet;
    }
  }

  // Delete a pet
  Future<bool> deletePet(String id) async {
    try {
      return await _apiService.deletePet(id);
    } catch (e) {
      // In a real app, we might mark as "to delete" locally
      return true; // Optimistically return true
    }
  }

  // Fallback pets in case the API fails (this would typically come from local storage)
  List<PetModel> _getFallbackPets() {
    return [
      PetModel(
        id: '1',
        name: 'Max',
        image: 'assets/images/pet1.jpg',
        species: 'dog',
        dateOfBirth: '2020-05-15',
        medicalHistory: MedicalHistoryModel(
          notes: 'Allergic to chicken',
          vaccinations: [
            VaccinationModel(
              name: 'Rabies',
              date: '2025-01-15',
              expiresAt: '2026-01-15',
            )
          ],
        ),
        status: 'active',
        version: 1,
      ),
      PetModel(
        id: '2',
        name: 'Luna',
        image: 'assets/images/pet2.jpg',
        species: 'cat',
        dateOfBirth: '2021-02-10',
        medicalHistory: MedicalHistoryModel(
          notes: 'Needs special diet food',
          weight: 4.2,
        ),
        status: 'active',
        version: 1,
      ),
    ];
  }
}
