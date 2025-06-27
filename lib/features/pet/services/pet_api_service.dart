import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petapp/core/utils/api_constants.dart';
import 'package:petapp/features/pet/models/pet_model.dart';
import 'package:petapp/features/pet/models/pet_create_model.dart';
import 'package:petapp/core/services/token_service.dart';
import 'package:get_it/get_it.dart';

class PetApiService {
  final http.Client _client;
  final TokenService _tokenService;
  
  PetApiService({
    http.Client? client, 
    TokenService? tokenService
  }) : _client = client ?? http.Client(),
       _tokenService = tokenService ?? GetIt.instance<TokenService>();
  
  // Get all pets for the authenticated user
  Future<List<PetModel>> getUserPets() async {
    try {
      // Get authentication token
      final token = await _tokenService.getToken();
      if (token == null) {
        throw Exception('Authentication token not found. Please log in again.');
      }
      
      final response = await _client.get(
        Uri.parse('${ApiConstants.apiBaseUrl}${ApiConstants.petsEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> petsJson = json.decode(response.body);
        
        // Filter out owner data for privacy/security
        for (var pet in petsJson) {
          if (pet is Map && pet.containsKey('owner')) {
            pet.remove('owner');
          }
        }
        
        return petsJson.map((json) => PetModel.fromMap(json)).toList();
      } else {
        throw Exception('Failed to load pets: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback to the backup API if the main one fails
      try {
        // Get authentication token for fallback API
        final token = await _tokenService.getToken();
        if (token == null) {
          throw Exception('Authentication token not found. Please log in again.');
        }
        
        final response = await _client.get(
          Uri.parse('${ApiConstants.fallbackApiBaseUrl}${ApiConstants.petsEndpoint}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ).timeout(ApiConstants.connectionTimeout);

        if (response.statusCode == 200) {
          final List<dynamic> petsJson = json.decode(response.body);
          
          // Filter out owner data for privacy/security
          for (var pet in petsJson) {
            if (pet is Map && pet.containsKey('owner')) {
              pet.remove('owner');
            }
          }
          
          return petsJson.map((json) => PetModel.fromMap(json)).toList();
        } else {
          throw Exception('Failed to load pets from fallback API: ${response.statusCode}');
        }
      } catch (fallbackError) {
        throw Exception('Error fetching pets: $e. Fallback error: $fallbackError');
      }
    }
  }

  // Get pet by ID
  Future<PetModel> getPetById(String id) async {
    try {
      // Get authentication token
      final token = await _tokenService.getToken();
      if (token == null) {
        throw Exception('Authentication token not found. Please log in again.');
      }
      
      final response = await _client.get(
        Uri.parse('${ApiConstants.apiBaseUrl}${ApiConstants.petDetailEndpoint(id)}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200) {
        final petJson = json.decode(response.body);
        
        // Remove owner data for privacy/security
        if (petJson is Map && petJson.containsKey('owner')) {
          petJson.remove('owner');
        }
        
        return PetModel.fromMap(petJson);
      } else {
        throw Exception('Failed to load pet details: ${response.statusCode}');
      }
    } catch (e) {
      // Try fallback API
      try {
        // Get authentication token for fallback API
        final token = await _tokenService.getToken();
        if (token == null) {
          throw Exception('Authentication token not found. Please log in again.');
        }
        
        final response = await _client.get(
          Uri.parse('${ApiConstants.fallbackApiBaseUrl}${ApiConstants.petDetailEndpoint(id)}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ).timeout(ApiConstants.connectionTimeout);

        if (response.statusCode == 200) {
          final petJson = json.decode(response.body);
          
          // Remove owner data for privacy/security
          if (petJson is Map && petJson.containsKey('owner')) {
            petJson.remove('owner');
          }
          
          return PetModel.fromMap(petJson);
        } else {
          throw Exception('Failed to load pet details from fallback API: ${response.statusCode}');
        }
      } catch (fallbackError) {
        throw Exception('Error fetching pet details: $e. Fallback error: $fallbackError');
      }
    }
  }

  // Add a new pet
  Future<PetModel> addPet(PetModel pet) async {
    try {
      // Get authentication token
      final token = await _tokenService.getToken();
      if (token == null) {
        throw Exception('Authentication token not found. Please log in again.');
      }
      
      // Convert PetModel to PetCreateModel to match the required schema
      final petCreateModel = PetCreateModel.fromPetModel(pet);
      
      final response = await _client.post(
        Uri.parse('${ApiConstants.apiBaseUrl}${ApiConstants.petsEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(petCreateModel.toJson()),
      ).timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 201) {
        final petJson = json.decode(response.body);
        return PetModel.fromMap(petJson);
      } else {
        throw Exception('Failed to add pet: ${response.statusCode}');
      }
    } catch (e) {
      // Try fallback API
      try {
        // Get authentication token for fallback API
        final token = await _tokenService.getToken();
        if (token == null) {
          throw Exception('Authentication token not found. Please log in again.');
        }
        
        // Convert PetModel to PetCreateModel for the fallback API
        final petCreateModel = PetCreateModel.fromPetModel(pet);
        
        final response = await _client.post(
          Uri.parse('${ApiConstants.fallbackApiBaseUrl}${ApiConstants.petsEndpoint}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode(petCreateModel.toJson()),
        ).timeout(ApiConstants.connectionTimeout);

        if (response.statusCode == 201) {
          final petJson = json.decode(response.body);
          return PetModel.fromMap(petJson);
        } else {
          throw Exception('Failed to add pet to fallback API: ${response.statusCode}');
        }
      } catch (fallbackError) {
        throw Exception('Error adding pet: $e. Fallback error: $fallbackError');
      }
    }
  }

  // Update a pet
  Future<PetModel> updatePet(String id, PetModel pet) async {
    try {
      // Get authentication token
      final token = await _tokenService.getToken();
      if (token == null) {
        throw Exception('Authentication token not found. Please log in again.');
      }
      
      // Convert PetModel to the format expected by the API
      final petCreateModel = PetCreateModel.fromPetModel(pet);
      
      final response = await _client.put(
        Uri.parse('${ApiConstants.apiBaseUrl}${ApiConstants.petDetailEndpoint(id)}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(petCreateModel.toJson()),
      ).timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200) {
        final petJson = json.decode(response.body);
        return PetModel.fromMap(petJson);
      } else {
        throw Exception('Failed to update pet: ${response.statusCode}');
      }
    } catch (e) {
      // Try fallback API
      try {
        // Get authentication token for fallback API
        final token = await _tokenService.getToken();
        if (token == null) {
          throw Exception('Authentication token not found. Please log in again.');
        }
        
        // Convert PetModel to the format expected by the API
        final petCreateModel = PetCreateModel.fromPetModel(pet);
      
        final response = await _client.put(
          Uri.parse('${ApiConstants.fallbackApiBaseUrl}${ApiConstants.petDetailEndpoint(id)}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode(petCreateModel.toJson()),
        ).timeout(ApiConstants.connectionTimeout);

        if (response.statusCode == 200) {
          final petJson = json.decode(response.body);
          return PetModel.fromMap(petJson);
        } else {
          throw Exception('Failed to update pet on fallback API: ${response.statusCode}');
        }
      } catch (fallbackError) {
        throw Exception('Error updating pet: $e. Fallback error: $fallbackError');
      }
    }
  }

  // Delete a pet
  Future<bool> deletePet(String id) async {
    try {
      // Get authentication token
      final token = await _tokenService.getToken();
      if (token == null) {
        throw Exception('Authentication token not found. Please log in again.');
      }
      
      final response = await _client.delete(
        Uri.parse('${ApiConstants.apiBaseUrl}${ApiConstants.petDetailEndpoint(id)}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(ApiConstants.connectionTimeout);

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      // Try fallback API
      try {
        // Get authentication token for fallback API
        final token = await _tokenService.getToken();
        if (token == null) {
          throw Exception('Authentication token not found. Please log in again.');
        }
        
        final response = await _client.delete(
          Uri.parse('${ApiConstants.fallbackApiBaseUrl}${ApiConstants.petDetailEndpoint(id)}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ).timeout(ApiConstants.connectionTimeout);

        return response.statusCode == 200 || response.statusCode == 204;
      } catch (fallbackError) {
        throw Exception('Error deleting pet: $e. Fallback error: $fallbackError');
      }
    }
  }
}
