import 'package:get/get.dart';
import 'package:petapp/features/pet/models/pet_model.dart';
import 'package:petapp/features/pet/models/pet_species_model.dart';
import 'package:petapp/features/pet/services/pet_api_service.dart';
import 'package:petapp/features/pet/utils/pet_constants.dart';
import 'package:petapp/core/services/error_handler_service.dart';
import 'package:petapp/core/services/auth_service.dart';

class PetRepository {
  final PetApiService _apiService;

  PetRepository({required PetApiService apiService}) : _apiService = apiService;

  /// Helper method to handle token expiration and authentication errors
  Future<void> _handleAuthError(dynamic error) async {
    if (error.toString().contains('401') ||
        error.toString().contains('unauthorized') ||
        error.toString().contains('token') ||
        error.toString().contains('Unauthorized')) {
      final authService = Get.find<AuthService>();
      await authService.handleTokenExpiration();
    }
  }

  /// Create a new pet - Limited to cats and dogs only
  Future<PetModel> createPet(Map<String, dynamic> petData) async {
    // Check authentication before creating pet
    final authService = Get.find<AuthService>();
    if (authService.authStatus != AuthStatus.authenticated) {
      print('🚫 Repository: User not authenticated, cannot create pet');
      throw Exception('Authentication required to create pets');
    }

    try {
      // Validate species at repository level - only allow cats and dogs
      final species = petData['species']?.toString();
      if (species == null || species.isEmpty) {
        throw Exception('Species is required. Must be either "cat" or "dog".');
      }
      PetConstants.validateSpecies(species, operation: 'create pet');

      return await _apiService.createPet(petData);
    } catch (error) {
      await _handleAuthError(error);
      // Suppress user notification - let the UI screen handle user feedback to avoid duplicates
      ErrorHandlerService.instance
          .handleError(error, suppressUserNotification: true);
      rethrow;
    }
  }

  /// Get all pets for the current user with pagination support
  Future<List<PetModel>> getUserPets({int? page, int? limit}) async {
    // Check authentication before making API call
    final authService = Get.find<AuthService>();
    if (authService.authStatus != AuthStatus.authenticated) {
      print('🚫 Repository: User not authenticated, returning empty pets list');
      return [];
    }

    try {
      return await _apiService.getUserPets(page: page, limit: limit);
    } catch (e) {
      print('❌ Repository: Failed to fetch pets from API: $e');

      // Handle token expiration or authentication errors
      if (e.toString().contains('401') ||
          e.toString().contains('unauthorized') ||
          e.toString().contains('token') ||
          e.toString().contains('Unauthorized')) {
        final authService = Get.find<AuthService>();
        await authService.handleTokenExpiration();
      }

      // Return empty list instead of sample data so users see proper empty state
      // In production, you might want to return cached data from local storage here
      print('📝 Returning empty list to show proper empty state');
      return [];
    }
  }

  /// Get allowed pet species
  Future<List<PetSpecies>> getAllowedSpecies() async {
    try {
      final species = await _apiService.getAllowedSpecies();

      // If API returns empty list, use fallback
      if (species.isEmpty) {
        print('📝 Repository: API returned empty species list, using fallback');
        return _getFallbackSpecies();
      }

      return species;
    } catch (error) {
      await _handleAuthError(error);
      print('❌ Repository: Failed to fetch species, using fallback: $error');
      // Return fallback species list
      return _getFallbackSpecies();
    }
  }

  /// Get a specific pet by ID
  Future<PetModel> getPetById(String id) async {
    // Check authentication before making API call
    final authService = Get.find<AuthService>();
    if (authService.authStatus != AuthStatus.authenticated) {
      print('🚫 Repository: User not authenticated, cannot fetch pet details');
      throw Exception('Authentication required to access pet details');
    }

    try {
      return await _apiService.getPetById(id);
    } catch (e) {
      await _handleAuthError(e);
      print('❌ Repository: Failed to fetch pet $id, using fallback: $e');
      // Return a fallback pet if we can't get it from the API
      final fallbackPets = _getFallbackPets();
      final pet = fallbackPets.firstWhere((pet) => pet.id == id,
          orElse: () => throw Exception('Pet not found'));
      return pet;
    }
  }

  /// Update a pet's details - Limited to cats and dogs only
  Future<PetModel> updatePet(String id, Map<String, dynamic> petData) async {
    // Check authentication before updating pet
    final authService = Get.find<AuthService>();
    if (authService.authStatus != AuthStatus.authenticated) {
      print('🚫 Repository: User not authenticated, cannot update pet');
      throw Exception('Authentication required to update pets');
    }

    try {
      // Validate species if being updated - only allow cats and dogs
      final species = petData['species']?.toString();
      if (species != null) {
        PetConstants.validateSpecies(species, operation: 'update pet');
      }

      return await _apiService.updatePet(id, petData);
    } catch (error) {
      await _handleAuthError(error);
      // Suppress user notification - let the UI screen handle user feedback to avoid duplicates
      ErrorHandlerService.instance
          .handleError(error, suppressUserNotification: true);
      rethrow;
    }
  }

  /// Soft delete a pet
  Future<void> deletePet(String id) async {
    // Check authentication before deleting pet
    final authService = Get.find<AuthService>();
    if (authService.authStatus != AuthStatus.authenticated) {
      print('🚫 Repository: User not authenticated, cannot delete pet');
      throw Exception('Authentication required to delete pets');
    }

    try {
      await _apiService.deletePet(id);
    } catch (error) {
      await _handleAuthError(error);
      // Suppress user notification - let the UI screen handle user feedback to avoid duplicates
      ErrorHandlerService.instance
          .handleError(error, suppressUserNotification: true);
      rethrow;
    }
  }

  /// Restore a soft-deleted pet
  Future<PetModel> restorePet(String id) async {
    // Check authentication before restoring pet
    final authService = Get.find<AuthService>();
    if (authService.authStatus != AuthStatus.authenticated) {
      print('🚫 Repository: User not authenticated, cannot restore pet');
      throw Exception('Authentication required to restore pets');
    }

    try {
      return await _apiService.restorePet(id);
    } catch (error) {
      await _handleAuthError(error);
      ErrorHandlerService.instance.handleError(error);
      rethrow;
    }
  }

  /// Permanently delete a pet (admin only)
  Future<void> hardDeletePet(String id) async {
    try {
      await _apiService.hardDeletePet(id);
    } catch (error) {
      await _handleAuthError(error);
      ErrorHandlerService.instance.handleError(error);
      rethrow;
    }
  }

  /// Get pet details with appointments
  Future<Map<String, dynamic>> getPetWithAppointments(String id) async {
    try {
      return await _apiService.getPetWithAppointments(id);
    } catch (error) {
      await _handleAuthError(error);
      ErrorHandlerService.instance.handleError(error);
      rethrow;
    }
  }

  // Legacy method - kept for backward compatibility
  Future<PetModel> addPet(PetModel pet) async {
    return createPet(pet.toMap());
  }

  // Legacy method - kept for backward compatibility with PetModel parameter
  Future<PetModel> updatePetModel(String id, PetModel pet) async {
    return updatePet(id, pet.toMap());
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
          weight: 25.5,
          spayNeuterStatus: true,
        ),
        status: 'active',
        version: 1,
      ),
      PetModel(
        id: '2',
        name: 'Luna',
        image: 'assets/images/pet2.jpg',
        species: 'cat',
        dateOfBirth: '2021-03-10',
        medicalHistory: MedicalHistoryModel(
          notes: 'Indoor cat, very playful',
          vaccinations: [
            VaccinationModel(
              name: 'FVRCP',
              date: '2025-02-20',
              expiresAt: '2026-02-20',
            )
          ],
          weight: 4.2,
          spayNeuterStatus: true,
        ),
        status: 'active',
        version: 1,
      ),
      PetModel(
        id: '3',
        name: 'Charlie',
        image: 'assets/images/pet1.jpg',
        species: 'dog',
        dateOfBirth: '2019-08-22',
        medicalHistory: MedicalHistoryModel(
          notes: 'Loves swimming, regular exercise needed',
          allergies: ['grass', 'pollen'],
          vaccinations: [
            VaccinationModel(
              name: 'DHPP',
              date: '2025-01-10',
              expiresAt: '2026-01-10',
            ),
            VaccinationModel(
              name: 'Rabies',
              date: '2025-01-15',
              expiresAt: '2026-01-15',
            )
          ],
          weight: 32.0,
          spayNeuterStatus: false,
        ),
        status: 'active',
        version: 1,
      ),
    ];
  }

  // Fallback species list - Limited to cats and dogs only
  List<PetSpecies> _getFallbackSpecies() {
    return [
      PetSpecies(
        id: '1',
        name: 'Dog',
        description: 'Domestic dogs',
        isActive: true,
      ),
      PetSpecies(
        id: '2',
        name: 'Cat',
        description: 'Domestic cats',
        isActive: true,
      ),
    ];
  }
}
