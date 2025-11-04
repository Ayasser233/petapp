import 'package:petapp/core/services/api_client.dart';
import 'package:petapp/core/utils/api_constants.dart';
import 'package:petapp/features/pet/models/pet_model.dart';
import 'package:petapp/features/pet/models/pet_species_model.dart';
import 'package:petapp/features/pet/utils/pet_constants.dart';

class PetApiService {
  final ApiClient _apiClient;

  PetApiService({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Create a new pet - Limited to cats and dogs only
  Future<PetModel> createPet(Map<String, dynamic> petData) async {
    try {
      // Validate species - only allow cats and dogs
      final species = petData['species']?.toString();
      PetConstants.validateSpecies(species, operation: 'create pet');

      print('🐾 Creating pet with data: $petData');

      final response = await _apiClient.post(
        ApiConstants.petsEndpoint,
        data: petData,
      );

      print('✅ Pet created successfully: ${response.data}');

      // Handle nested response structure
      final userData =
          response.data['pet'] ?? response.data['data'] ?? response.data;
      return PetModel.fromMap(userData);
    } catch (error) {
      print('❌ Failed to create pet: $error');
      // Don't call ErrorHandlerService here - let the repository handle it to avoid duplicate logging
      rethrow;
    }
  }

  /// Get all pets for the authenticated user (paginated)
  Future<List<PetModel>> getUserPets({int? page, int? limit}) async {
    try {
      print('🐾 Fetching user pets (page: $page, limit: $limit)');

      final queryParams = <String, dynamic>{};
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;

      final response = await _apiClient.get(
        ApiConstants.petsEndpoint,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      print('✅ Pets fetched successfully: ${response.data}');

      // Handle different response structures
      List<dynamic> petsJson = [];

      if (response.data == null) {
        print('📝 API returned null response, returning empty list');
        return [];
      }

      if (response.data is Map) {
        // Paginated response structure
        final mapData = response.data as Map;
        petsJson = (mapData['pets'] ??
            mapData['data'] ??
            mapData['items'] ??
            []) as List<dynamic>;

        // If none of the expected keys exist and the response contains a single pet object
        if (petsJson.isEmpty && mapData.containsKey('id')) {
          petsJson = [mapData];
        }
      } else if (response.data is List) {
        // Direct array response
        petsJson = response.data as List<dynamic>;
      } else {
        print('📝 Unexpected response structure, returning empty list');
        return [];
      }

      // Filter out null items and convert to PetModel list
      return petsJson
          .where((json) => json != null)
          .map((json) => PetModel.fromMap(json))
          .toList();
    } catch (error) {
      print('❌ Failed to fetch pets: $error');

      // Check if this is a "no data" scenario that should return empty list instead of error
      final errorString = error.toString().toLowerCase();

      // Handle HTTP status codes that indicate "no data" rather than actual errors
      if (errorString.contains('404') ||
          errorString.contains('not found') ||
          errorString.contains('no pets found') ||
          errorString.contains('empty response')) {
        print('📝 No pets found, returning empty list instead of error');
        return [];
      }

      // For authentication errors, network errors, and other actual problems, still throw
      // Don't call ErrorHandlerService here - let the repository handle it to avoid duplicate logging
      rethrow;
    }
  }

  /// Get allowed pet species
  Future<List<PetSpecies>> getAllowedSpecies() async {
    try {
      print('🐾 Fetching allowed pet species');

      final response = await _apiClient.get(
        ApiConstants.petSpeciesAllowedEndpoint,
      );

      print('✅ Species fetched successfully: ${response.data}');

      // Handle different response structures with better error handling
      List<dynamic> speciesJson = [];

      if (response.data == null) {
        print('📝 API returned null response for species');
        return [];
      }

      if (response.data is Map) {
        final mapData = response.data as Map<String, dynamic>;

        // Try to extract species list from common response patterns
        if (mapData.containsKey('species') && mapData['species'] is List) {
          speciesJson = mapData['species'] as List<dynamic>;
        } else if (mapData.containsKey('data') && mapData['data'] is List) {
          speciesJson = mapData['data'] as List<dynamic>;
        } else if (mapData.containsKey('items') && mapData['items'] is List) {
          speciesJson = mapData['items'] as List<dynamic>;
        } else if (mapData.containsKey('id') && mapData.containsKey('name')) {
          // Single species object wrapped in response
          speciesJson = [mapData];
        } else {
          print(
              '📝 Unexpected Map structure for species response: ${mapData.keys}');
          return [];
        }
      } else if (response.data is List) {
        speciesJson = response.data as List<dynamic>;
      } else {
        print(
            '📝 Unexpected response type for species: ${response.data.runtimeType}');
        return [];
      }

      // Filter and safely convert to PetSpecies objects
      final result = <PetSpecies>[];
      for (final json in speciesJson) {
        try {
          if (json is Map<String, dynamic>) {
            result.add(PetSpecies.fromJson(json));
          } else if (json is Map) {
            // Convert Map to Map<String, dynamic>
            final convertedMap = Map<String, dynamic>.from(json);
            result.add(PetSpecies.fromJson(convertedMap));
          } else {
            print(
                '📝 Skipping invalid species item: $json (type: ${json.runtimeType})');
          }
        } catch (e) {
          print('📝 Failed to parse species item: $json, error: $e');
          continue;
        }
      }

      return result;
    } catch (error) {
      print('❌ Failed to fetch species: $error');
      // Don't propagate error to avoid breaking the UI
      // Return empty list and let repository handle fallback
      return [];
    }
  }

  /// Get pet details by ID
  Future<PetModel> getPetById(String id) async {
    try {
      print('🐾 Fetching pet details for ID: $id');

      final response = await _apiClient.get(
        ApiConstants.petDetailEndpoint(id),
      );

      print('✅ Pet details fetched successfully: ${response.data}');

      // Handle nested response structure
      final petData =
          response.data['pet'] ?? response.data['data'] ?? response.data;
      return PetModel.fromMap(petData);
    } catch (error) {
      print('❌ Failed to fetch pet details: $error');
      // Don't call ErrorHandlerService here - let the repository handle it to avoid duplicate logging
      rethrow;
    }
  }

  /// Update pet by ID - Limited to cats and dogs only
  Future<PetModel> updatePet(String id, Map<String, dynamic> petData) async {
    try {
      // Validate species if being updated - only allow cats and dogs
      final species = petData['species']?.toString();
      if (species != null) {
        PetConstants.validateSpecies(species, operation: 'update pet');
      }

      print('🐾 Updating pet $id with data:');
      print('   Request URL: ${ApiConstants.petUpdateEndpoint(id)}');
      print('   Request Method: PATCH');
      print('   Request Body: $petData');
      print('   Body Keys: ${petData.keys.toList()}');
      print('   Body Type: ${petData.runtimeType}');

      final response = await _apiClient.patch(
        ApiConstants.petUpdateEndpoint(id),
        data: petData,
      );

      print('✅ Pet updated successfully: ${response.data}');

      // Handle nested response structure
      final updatedPetData =
          response.data['pet'] ?? response.data['data'] ?? response.data;
      return PetModel.fromMap(updatedPetData);
    } catch (error) {
      print('❌ Failed to update pet: $error');
      // Don't call ErrorHandlerService here - let the repository handle it to avoid duplicate logging
      rethrow;
    }
  }

  /// Soft delete pet by ID
  Future<void> deletePet(String id) async {
    try {
      print('🐾 Soft deleting pet: $id');

      await _apiClient.delete(
        ApiConstants.petDeleteEndpoint(id),
      );

      print('✅ Pet soft deleted successfully');
    } catch (error) {
      print('❌ Failed to delete pet: $error');
      // Don't call ErrorHandlerService here - let the repository handle it to avoid duplicate logging
      rethrow;
    }
  }

  /// Restore soft-deleted pet by ID
  Future<PetModel> restorePet(String id) async {
    try {
      print('🐾 Restoring pet: $id');

      final response = await _apiClient.patch(
        ApiConstants.petRestoreEndpoint(id),
      );

      print('✅ Pet restored successfully: ${response.data}');

      // Handle nested response structure
      final restoredPetData =
          response.data['pet'] ?? response.data['data'] ?? response.data;
      return PetModel.fromMap(restoredPetData);
    } catch (error) {
      print('❌ Failed to restore pet: $error');
      // Don't call ErrorHandlerService here - let the repository handle it to avoid duplicate logging
      rethrow;
    }
  }

  /// Permanently delete pet by ID (admin only)
  Future<void> hardDeletePet(String id) async {
    try {
      print('🐾 Hard deleting pet: $id');

      await _apiClient.delete(
        ApiConstants.petHardDeleteEndpoint(id),
      );

      print('✅ Pet permanently deleted');
    } catch (error) {
      print('❌ Failed to permanently delete pet: $error');
      // Don't call ErrorHandlerService here - let the repository handle it to avoid duplicate logging
      rethrow;
    }
  }

  /// Get pet details with appointments
  Future<Map<String, dynamic>> getPetWithAppointments(String id) async {
    try {
      print('🐾 Fetching pet with appointments for ID: $id');

      final response = await _apiClient.get(
        ApiConstants.petAppointmentsEndpoint(id),
      );

      print('✅ Pet with appointments fetched successfully: ${response.data}');

      // Return full response data including pet and appointments
      return response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : {'data': response.data};
    } catch (error) {
      print('❌ Failed to fetch pet with appointments: $error');
      // Don't call ErrorHandlerService here - let the repository handle it to avoid duplicate logging
      rethrow;
    }
  }

  // Legacy method - kept for backward compatibility
  Future<PetModel> addPet(PetModel pet) async {
    return createPet(pet.toMap());
  }
}
