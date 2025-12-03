import 'package:petapp/core/services/api_client.dart';
import 'package:petapp/core/utils/api_constants.dart';
import 'package:petapp/features/pet/models/pet_model.dart';
import 'package:petapp/features/pet/models/pet_species_model.dart';
import 'package:petapp/features/pet/utils/pet_constants.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:convert';

class PetApiService {
  final ApiClient _apiClient;

  PetApiService({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Create a new pet - Limited to cats and dogs only
  Future<PetModel> createPet(Map<String, dynamic> petData, {String? imagePath}) async {
    try {
      // Validate species - only allow cats and dogs
      final species = petData['species']?.toString();
      PetConstants.validateSpecies(species, operation: 'create pet');

      dynamic requestData;

      // If image is provided, use FormData for multipart upload
      if (imagePath != null && imagePath.isNotEmpty) {
        final formData = FormData();

        // Add the image file
        final file = File(imagePath);
        if (await file.exists()) {
          formData.files.add(
            MapEntry(
              'images',
              await MultipartFile.fromFile(
                imagePath,
                filename: imagePath.split('/').last,
              ),
            ),
          );
        }

        // Add pet data as JSON string under 'data' key
        // Import dart:convert at the top if not already imported
        final jsonData = {
          ...petData,
          // Ensure allergies is sent as actual array, not string
          'allergies': petData['allergies'] ?? [],
        };

        formData.fields.add(MapEntry('data', jsonEncode(jsonData)));

        requestData = formData;
      } else {
        // No image, send as regular JSON
        requestData = petData;
      }

      final response = await _apiClient.post(
        ApiConstants.petsEndpoint,
        data: requestData,
      );

      // Handle nested response structure
      final userData =
          response.data['pet'] ?? response.data['data'] ?? response.data;
      return PetModel.fromMap(userData);
    } catch (error) {
      // Don't call ErrorHandlerService here - let the repository handle it to avoid duplicate logging
      rethrow;
    }
  }

  /// Get all pets for the authenticated user (paginated)
  Future<List<PetModel>> getUserPets({int? page, int? limit}) async {
    try {

      final queryParams = <String, dynamic>{};
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;

      final response = await _apiClient.get(
        ApiConstants.petsEndpoint,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );


      // Handle different response structures
      List<dynamic> petsJson = [];

      if (response.data == null) {
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
        return [];
      }

      // Filter out null items and convert to PetModel list
      return petsJson
          .where((json) => json != null)
          .map((json) => PetModel.fromMap(json))
          .toList();
    } catch (error) {

      // Check if this is a "no data" scenario that should return empty list instead of error
      final errorString = error.toString().toLowerCase();

      // Handle HTTP status codes that indicate "no data" rather than actual errors
      if (errorString.contains('404') ||
          errorString.contains('not found') ||
          errorString.contains('no pets found') ||
          errorString.contains('empty response')) {
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

      final response = await _apiClient.get(
        ApiConstants.petSpeciesAllowedEndpoint,
      );


      // Handle different response structures with better error handling
      List<dynamic> speciesJson = [];

      if (response.data == null) {
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
          return [];
        }
      } else if (response.data is List) {
        speciesJson = response.data as List<dynamic>;
      } else {
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
          }
        } catch (e) {
          continue;
        }
      }

      return result;
    } catch (error) {
      // Don't propagate error to avoid breaking the UI
      // Return empty list and let repository handle fallback
      return [];
    }
  }

  /// Get pet details by ID
  Future<PetModel> getPetById(String id) async {
    try {

      final response = await _apiClient.get(
        ApiConstants.petDetailEndpoint(id),
      );


      // Handle nested response structure
      final petData =
          response.data['pet'] ?? response.data['data'] ?? response.data;
      return PetModel.fromMap(petData);
    } catch (error) {
      // Don't call ErrorHandlerService here - let the repository handle it to avoid duplicate logging
      rethrow;
    }
  }

  /// Update pet by ID - Limited to cats and dogs only
  Future<PetModel> updatePet(String id, Map<String, dynamic> petData, {String? imagePath}) async {
    try {

      // Validate species if being updated - only allow cats and dogs
      final species = petData['species']?.toString();
      if (species != null) {
        PetConstants.validateSpecies(species, operation: 'update pet');
      }

      dynamic requestData;

      // If image is provided, use FormData for multipart upload
      if (imagePath != null && imagePath.isNotEmpty) {
        final formData = FormData();

        // Add the image file
        final file = File(imagePath);
        if (await file.exists()) {
          formData.files.add(
            MapEntry(
              'images',
              await MultipartFile.fromFile(
                imagePath,
                filename: imagePath.split('/').last,
              ),
            ),
          );
        }

        // Add pet data as JSON string under 'data' key
        final jsonData = {
          ...petData,
          // Ensure allergies is sent as actual array, not string
          'allergies': petData['allergies'] ?? [],
        };

        formData.fields.add(MapEntry('data', jsonEncode(jsonData)));

        requestData = formData;
      } else {
        // No image, send as regular JSON
        requestData = petData;
      }

      final response = await _apiClient.patch(
        ApiConstants.petUpdateEndpoint(id),
        data: requestData,
      );


      // Handle nested response structure
      final updatedPetData =
          response.data['pet'] ?? response.data['data'] ?? response.data;
      return PetModel.fromMap(updatedPetData);
    } catch (error) {
      // Don't call ErrorHandlerService here - let the repository handle it to avoid duplicate logging
      rethrow;
    }
  }

  /// Soft delete pet by ID
  Future<void> deletePet(String id) async {
    try {

      await _apiClient.delete(
        ApiConstants.petDeleteEndpoint(id),
      );

    } catch (error) {
      // Don't call ErrorHandlerService here - let the repository handle it to avoid duplicate logging
      rethrow;
    }
  }

  /// Restore soft-deleted pet by ID
  Future<PetModel> restorePet(String id) async {
    try {

      final response = await _apiClient.patch(
        ApiConstants.petRestoreEndpoint(id),
      );


      // Handle nested response structure
      final restoredPetData =
          response.data['pet'] ?? response.data['data'] ?? response.data;
      return PetModel.fromMap(restoredPetData);
    } catch (error) {
      // Don't call ErrorHandlerService here - let the repository handle it to avoid duplicate logging
      rethrow;
    }
  }

  /// Permanently delete pet by ID (admin only)
  Future<void> hardDeletePet(String id) async {
    try {

      await _apiClient.delete(
        ApiConstants.petHardDeleteEndpoint(id),
      );

    } catch (error) {
      // Don't call ErrorHandlerService here - let the repository handle it to avoid duplicate logging
      rethrow;
    }
  }

  /// Get pet details with appointments
  Future<Map<String, dynamic>> getPetWithAppointments(String id) async {
    try {

      final response = await _apiClient.get(
        ApiConstants.petAppointmentsEndpoint(id),
      );


      // Return full response data including pet and appointments
      return response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : {'data': response.data};
    } catch (error) {
      // Don't call ErrorHandlerService here - let the repository handle it to avoid duplicate logging
      rethrow;
    }
  }

  // Legacy method - kept for backward compatibility
  Future<PetModel> addPet(PetModel pet) async {
    return createPet(pet.toMap());
  }
}
