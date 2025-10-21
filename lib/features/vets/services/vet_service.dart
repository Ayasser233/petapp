import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../models/vet_model.dart';
import '../models/vet_schedule_model.dart';
import '../models/review_model.dart';
import '../models/time_slot_model.dart';
import '../../../core/services/location_service.dart';
import '../../../core/services/api_client.dart';
import '../../../core/utils/api_constants.dart';

class VetService {
  static final VetService _instance = VetService._internal();
  factory VetService() => _instance;
  VetService._internal();

  // Use lazy getters instead of eager initialization
  LocationService get _locationService => Get.find<LocationService>();
  ApiClient get _apiClient => Get.find<ApiClient>();

  // Extended vet database with more entries and coordinates
  final List<VetModel> _allVets = [
    VetModel(
      id: '1',
      name: 'PetPals',
      category: 'Veterinary Clinic',
      location: 'El-Basatin Sharkeya, Cairo',
      distance: 'Calculating...',
      images: const [
        'assets/images/pet_hospital.jpg',
        'assets/images/pet_hospital2.jpg',
        'assets/images/pet_hospital3.jpg',
      ],
      description:
          'Banfield Pet Hospital is a network of specialized animal hospitals that offer emergency and specialist services. They focus on the care of pets that require specialized medical attention.',
      rating: 4.8,
      reviews: 178,
      patients: 709,
      yearsExperience: 5,
      latitude: 29.98294,
      longitude: 31.28259,
      phone: '+201113888368',
      email: 'info@banfield.com',
      services: const [
        'Emergency Care',
        'Surgery',
        'Dental Care',
        'Vaccination',
        'X-Ray',
        'Laboratory'
      ],
      openingHours: const {
        'Monday': '8:00 AM - 6:00 PM',
        'Tuesday': '8:00 AM - 6:00 PM',
        'Wednesday': '8:00 AM - 6:00 PM',
        'Thursday': '8:00 AM - 6:00 PM',
        'Friday': '8:00 AM - 6:00 PM',
        'Saturday': '9:00 AM - 4:00 PM',
        'Sunday': '10:00 AM - 2:00 PM',
      },
    ),
    VetModel(
      id: '2',
      name: 'VCA Animal Hospital',
      category: 'Hospital',
      location: 'Brooklyn, NY',
      distance: 'Calculating...',
      images: const [
        'assets/images/pet_hospital2.jpg',
        'assets/images/pet_hospital3.jpg',
        'assets/images/pet_hospital.jpg',
      ],
      description:
          'VCA Animal Hospital provides a full range of general medical and surgical services as well as specialized treatments for companion animals.',
      rating: 4.6,
      reviews: 287,
      patients: 583,
      yearsExperience: 12,
      latitude: 40.6782,
      longitude: -73.9442,
      phone: '+1 (555) 987-6543',
      email: 'contact@vca.com',
      services: const [
        'General Check-up',
        'Vaccination',
        'Grooming',
        'Surgery',
        'Pharmacy'
      ],
      openingHours: const {
        'Monday': '7:00 AM - 7:00 PM',
        'Tuesday': '7:00 AM - 7:00 PM',
        'Wednesday': '7:00 AM - 7:00 PM',
        'Thursday': '7:00 AM - 7:00 PM',
        'Friday': '7:00 AM - 7:00 PM',
        'Saturday': '8:00 AM - 5:00 PM',
        'Sunday': 'Closed',
      },
    ),
    VetModel(
      id: '3',
      name: 'BluePearl Pet Hospital',
      category: 'Emergency',
      location: 'Healdsburg, CA',
      distance: 'Calculating...',
      images: const [
        'assets/images/pet_hospital3.jpg',
        'assets/images/pet_hospital.jpg',
        'assets/images/pet_hospital2.jpg',
      ],
      description:
          'BluePearl Pet Hospital specializes in emergency and specialty care for pets when they need it most.',
      rating: 4.7,
      reviews: 127,
      patients: 709,
      yearsExperience: 15,
      latitude: 38.6104,
      longitude: -122.8695,
      phone: '+1 (555) 456-7890',
      email: 'info@bluepearlvet.com',
      services: const [
        'Emergency Care',
        'Specialty Care',
        'Surgery',
        'Diagnostics',
        '24/7 Care'
      ],
      openingHours: const {
        'Monday': '24 Hours',
        'Tuesday': '24 Hours',
        'Wednesday': '24 Hours',
        'Thursday': '24 Hours',
        'Friday': '24 Hours',
        'Saturday': '24 Hours',
        'Sunday': '24 Hours',
      },
    ),
    VetModel(
      id: '4',
      name: 'PetSmart Veterinary Services',
      category: 'Clinic',
      location: 'Phoenix, AZ',
      distance: 'Calculating...',
      images: const [
        'assets/images/pet_hospital.jpg',
        'assets/images/pet_hospital2.jpg',
        'assets/images/pet_hospital3.jpg',
      ],
      description:
          'Convenient veterinary care with grooming and pharmacy services all in one location.',
      rating: 4.3,
      reviews: 156,
      patients: 425,
      yearsExperience: 8,
      latitude: 33.4484,
      longitude: -112.0740,
      phone: '+1 (555) 321-9876',
      email: 'vet@petsmart.com',
      services: const [
        'Check-up',
        'Vaccination',
        'Grooming',
        'Pharmacy',
        'Nail Trimming'
      ],
      openingHours: const {
        'Monday': '9:00 AM - 8:00 PM',
        'Tuesday': '9:00 AM - 8:00 PM',
        'Wednesday': '9:00 AM - 8:00 PM',
        'Thursday': '9:00 AM - 8:00 PM',
        'Friday': '9:00 AM - 8:00 PM',
        'Saturday': '9:00 AM - 6:00 PM',
        'Sunday': '10:00 AM - 6:00 PM',
      },
    ),
    VetModel(
      id: '5',
      name: 'Animal Specialty Center',
      category: 'Specialty',
      location: 'Miami, FL',
      distance: 'Calculating...',
      images: const [
        'assets/images/pet_hospital2.jpg',
        'assets/images/pet_hospital3.jpg',
        'assets/images/pet_hospital.jpg',
      ],
      description:
          'Advanced specialty care including cardiology, oncology, and orthopedic surgery.',
      rating: 4.9,
      reviews: 89,
      patients: 312,
      yearsExperience: 20,
      latitude: 25.7617,
      longitude: -80.1918,
      phone: '+1 (555) 654-3210',
      email: 'info@animalspecialty.com',
      services: const [
        'Cardiology',
        'Oncology',
        'Orthopedics',
        'Neurology',
        'Advanced Surgery'
      ],
      openingHours: const {
        'Monday': '8:00 AM - 5:00 PM',
        'Tuesday': '8:00 AM - 5:00 PM',
        'Wednesday': '8:00 AM - 5:00 PM',
        'Thursday': '8:00 AM - 5:00 PM',
        'Friday': '8:00 AM - 5:00 PM',
        'Saturday': 'By Appointment',
        'Sunday': 'Emergency Only',
      },
    ),
    VetModel(
      id: '6',
      name: 'Happy Paws Grooming & Wellness',
      category: 'Grooming',
      location: 'Seattle, WA',
      distance: 'Calculating...',
      images: const [
        'assets/images/pet_hospital3.jpg',
        'assets/images/pet_hospital.jpg',
        'assets/images/pet_hospital2.jpg',
      ],
      description:
          'Full-service grooming with basic wellness checks and preventive care.',
      rating: 4.4,
      reviews: 203,
      patients: 567,
      yearsExperience: 6,
      latitude: 47.6062,
      longitude: -122.3321,
      phone: '+1 (555) 789-0123',
      email: 'hello@happypaws.com',
      services: const [
        'Full Grooming',
        'Bath & Brush',
        'Nail Care',
        'Wellness Check',
        'Flea Treatment'
      ],
      openingHours: const {
        'Monday': '9:00 AM - 6:00 PM',
        'Tuesday': '9:00 AM - 6:00 PM',
        'Wednesday': '9:00 AM - 6:00 PM',
        'Thursday': '9:00 AM - 6:00 PM',
        'Friday': '9:00 AM - 6:00 PM',
        'Saturday': '8:00 AM - 4:00 PM',
        'Sunday': 'Closed',
      },
    ),
    VetModel(
      id: '7',
      name: 'Metropolitan Animal Hospital',
      category: 'Hospital',
      location: 'Chicago, IL',
      distance: 'Calculating...',
      images: const [
        'assets/images/pet_hospital.jpg',
        'assets/images/pet_hospital2.jpg',
        'assets/images/pet_hospital3.jpg',
      ],
      description:
          'Full-service animal hospital serving the Chicago metropolitan area with comprehensive care.',
      rating: 4.5,
      reviews: 412,
      patients: 890,
      yearsExperience: 18,
      latitude: 41.8781,
      longitude: -87.6298,
      phone: '+1 (555) 246-8135',
      email: 'info@metroanimalhospital.com',
      services: const [
        'Emergency Care',
        'Surgery',
        'Dental Care',
        'Vaccination',
        'Boarding'
      ],
      openingHours: const {
        'Monday': '7:00 AM - 8:00 PM',
        'Tuesday': '7:00 AM - 8:00 PM',
        'Wednesday': '7:00 AM - 8:00 PM',
        'Thursday': '7:00 AM - 8:00 PM',
        'Friday': '7:00 AM - 8:00 PM',
        'Saturday': '8:00 AM - 6:00 PM',
        'Sunday': '10:00 AM - 4:00 PM',
      },
    ),
    VetModel(
      id: '8',
      name: 'Countryside Veterinary Clinic',
      category: 'Clinic',
      location: 'Austin, TX',
      distance: 'Calculating...',
      images: const [
        'assets/images/pet_hospital2.jpg',
        'assets/images/pet_hospital3.jpg',
        'assets/images/pet_hospital.jpg',
      ],
      description:
          'Family-owned veterinary vet providing personalized care for pets in a comfortable environment.',
      rating: 4.7,
      reviews: 268,
      patients: 534,
      yearsExperience: 10,
      latitude: 30.2672,
      longitude: -97.7431,
      phone: '+1 (555) 369-2580',
      email: 'care@countrysidevet.com',
      services: const [
        'General Check-up',
        'Vaccination',
        'Surgery',
        'Dental Care',
        'Microchipping'
      ],
      openingHours: const {
        'Monday': '8:00 AM - 6:00 PM',
        'Tuesday': '8:00 AM - 6:00 PM',
        'Wednesday': '8:00 AM - 6:00 PM',
        'Thursday': '8:00 AM - 6:00 PM',
        'Friday': '8:00 AM - 6:00 PM',
        'Saturday': '9:00 AM - 3:00 PM',
        'Sunday': 'Closed',
      },
    ),
    VetModel(
      id: '9',
      name: 'Coastal Pet Emergency Center',
      category: 'Emergency',
      location: 'San Diego, CA',
      distance: 'Calculating...',
      images: const [
        'assets/images/pet_hospital3.jpg',
        'assets/images/pet_hospital.jpg',
        'assets/images/pet_hospital2.jpg',
      ],
      description:
          '24/7 emergency veterinary care for critical and urgent pet medical needs.',
      rating: 4.6,
      reviews: 178,
      patients: 623,
      yearsExperience: 12,
      latitude: 32.7157,
      longitude: -117.1611,
      phone: '+1 (555) 147-8520',
      email: 'emergency@coastalpet.com',
      services: const [
        'Emergency Care',
        'Critical Care',
        'Surgery',
        'Diagnostics',
        'Intensive Care'
      ],
      openingHours: const {
        'Monday': '24 Hours',
        'Tuesday': '24 Hours',
        'Wednesday': '24 Hours',
        'Thursday': '24 Hours',
        'Friday': '24 Hours',
        'Saturday': '24 Hours',
        'Sunday': '24 Hours',
      },
    ),
    VetModel(
      id: '10',
      name: 'Paws & Claws Veterinary Pharmacy',
      category: 'Pharmacy',
      location: 'Denver, CO',
      distance: 'Calculating...',
      images: const [
        'assets/images/pet_hospital.jpg',
        'assets/images/pet_hospital2.jpg',
        'assets/images/pet_hospital3.jpg',
      ],
      description:
          'Specialized veterinary pharmacy with consultation services and medication delivery.',
      rating: 4.2,
      reviews: 94,
      patients: 312,
      yearsExperience: 5,
      latitude: 39.7392,
      longitude: -104.9903,
      phone: '+1 (555) 963-7410',
      email: 'pharmacy@pawsclaws.com',
      services: const [
        'Pharmacy',
        'Medication Consultation',
        'Prescription Delivery',
        'Compounding'
      ],
      openingHours: const {
        'Monday': '9:00 AM - 7:00 PM',
        'Tuesday': '9:00 AM - 7:00 PM',
        'Wednesday': '9:00 AM - 7:00 PM',
        'Thursday': '9:00 AM - 7:00 PM',
        'Friday': '9:00 AM - 7:00 PM',
        'Saturday': '10:00 AM - 5:00 PM',
        'Sunday': 'Closed',
      },
    ),
  ];

  /// Get all vets with location-based distances
  Future<List<VetModel>> getAllVets() async {
    try {
      return await _updateVetsWithDistances(_allVets);
    } catch (e) {
      throw Exception('Failed to get all vets: ${e.toString()}');
    }
  }

  /// Get nearby vets (sorted by distance) from API
  Future<List<VetModel>> getNearByVets({int limit = 3}) async {
    try {
      print('🔄 Attempting to fetch vets from API...');

      final response = await getVets(
        page: 1,
        limit: limit,
      );

      final vets = response['vets'] as List<VetModel>;
      print('✅ Successfully fetched ${vets.length} vets from API');

      // Update with calculated distances if location available
      final currentPosition = _locationService.currentPosition;
      if (currentPosition != null) {
        return vets.map((vet) {
          if (vet.latitude != null && vet.longitude != null) {
            final distance = Geolocator.distanceBetween(
              currentPosition.latitude,
              currentPosition.longitude,
              vet.latitude!,
              vet.longitude!,
            );
            return vet.copyWith(
              distance: _locationService.formatDistance(distance),
            );
          }
          return vet;
        }).toList();
      }

      return vets;
    } catch (e) {
      print('❌ API Error in getNearByVets: ${e.toString()}');
      // No fallback - if API fails, return empty list
      return [];
    }
  }

  /// Search vets with location-based filtering
  Future<List<VetModel>> searchVets({
    String? query,
    String? category,
    String? sortBy = 'distance',
    double? maxDistanceKm,
  }) async {
    try {
      List<VetModel> filteredVets = await getAllVets();
      final currentPosition = _locationService.currentPosition;

      // Apply text search filter
      if (query != null && query.isNotEmpty) {
        filteredVets = _filterByQuery(filteredVets, query);
      }

      // Apply category filter
      if (category != null && category != 'All' && category.isNotEmpty) {
        filteredVets = _filterByCategory(filteredVets, category);
      }

      // Apply distance filter if location is available
      if (currentPosition != null && maxDistanceKm != null) {
        filteredVets =
            _filterByDistance(filteredVets, currentPosition, maxDistanceKm);
      }

      // Apply sorting
      if (currentPosition != null) {
        filteredVets = _sortVets(filteredVets, sortBy!, currentPosition);
      }

      return filteredVets;
    } catch (e) {
      throw Exception('Failed to search vets: ${e.toString()}');
    }
  }

  /// Get vets by category
  Future<List<VetModel>> getVetsByCategory(String category) async {
    try {
      final allVets = await getAllVets();
      if (category == 'All') return allVets;

      return _filterByCategory(allVets, category);
    } catch (e) {
      throw Exception(
          'Failed to get vets by category "$category": ${e.toString()}');
    }
  }

  /// Get vets within specified distance
  Future<List<VetModel>> getVetsWithinDistance(double maxDistanceKm) async {
    try {
      final allVets = await getAllVets();
      final currentPosition = _locationService.currentPosition;

      if (currentPosition == null) {
        throw Exception(
            'Location service not available or permission not granted');
      }

      return _filterByDistance(allVets, currentPosition, maxDistanceKm);
    } catch (e) {
      throw Exception(
          'Failed to get vets within ${maxDistanceKm}km: ${e.toString()}');
    }
  }

  /// Get popular vets (high rating and reviews)
  Future<List<VetModel>> getPopularVets({int limit = 5}) async {
    try {
      final allVets = await getAllVets();

      // Sort by rating and reviews
      allVets.sort((a, b) {
        final aScore = a.rating * 0.7 + (a.reviews / 100) * 0.3;
        final bScore = b.rating * 0.7 + (b.reviews / 100) * 0.3;
        return bScore.compareTo(aScore);
      });

      return allVets.take(limit).toList();
    } catch (e) {
      throw Exception('Failed to get popular vets: ${e.toString()}');
    }
  }

  /// Get emergency vets
  Future<List<VetModel>> getEmergencyVets() async {
    try {
      final allVets = await getAllVets();
      final emergencyVets = allVets.where((vet) {
        return vet.category.toLowerCase().contains('emergency') ||
            vet.services.any((service) =>
                service.toLowerCase().contains('emergency') ||
                service.toLowerCase().contains('24/7') ||
                service.toLowerCase().contains('critical'));
      }).toList();

      if (emergencyVets.isEmpty) {
        throw Exception('No emergency vets found');
      }

      // Sort by distance if location available
      final currentPosition = _locationService.currentPosition;
      if (currentPosition != null) {
        return _sortVetsByDistance(emergencyVets, currentPosition);
      }

      return emergencyVets;
    } catch (e) {
      throw Exception('Failed to get emergency vets: ${e.toString()}');
    }
  }

  /// Get available categories
  List<String> getAvailableCategories() {
    try {
      final categories = _allVets.map((vet) => vet.category).toSet().toList();
      categories.insert(0, 'All');
      return categories;
    } catch (e) {
      throw Exception('Failed to get available categories: ${e.toString()}');
    }
  }

  /// Get available services
  List<String> getAvailableServices() {
    try {
      final services = <String>{};
      for (final vet in _allVets) {
        services.addAll(vet.services);
      }
      return services.toList()..sort();
    } catch (e) {
      throw Exception('Failed to get available services: ${e.toString()}');
    }
  }

  // Private helper methods

  /// Update vets with calculated distances
  Future<List<VetModel>> _updateVetsWithDistances(List<VetModel> vets) async {
    try {
      final currentPosition = _locationService.currentPosition;

      if (currentPosition == null) {
        print('⚠️ _updateVetsWithDistances: No current position available');
        print('   Permission granted: ${_locationService.isPermissionGranted}');
        return vets;
      }

      print(
          '📍 _updateVetsWithDistances: Current position: ${currentPosition.latitude}, ${currentPosition.longitude}');
      print('   Updating distances for ${vets.length} vets');

      return vets.map((vet) {
        try {
          if (vet.latitude == null || vet.longitude == null) {
            print('⚠️ Clinic "${vet.name}" has no coordinates');
            return vet.copyWith(distance: 'Unknown');
          }

          final distance = vet.calculateDistanceFromCurrentLocation(
            currentPosition.latitude,
            currentPosition.longitude,
          );

          final formattedDistance = distance != null
              ? _locationService.formatDistance(distance)
              : 'Unknown';

          print('✅ Clinic "${vet.name}": ${formattedDistance}');
          return vet.copyWith(distance: formattedDistance);
        } catch (e) {
          print('❌ Error calculating distance for "${vet.name}": $e');
          return vet.copyWith(distance: 'Unknown');
        }
      }).toList();
    } catch (e) {
      print('❌ _updateVetsWithDistances error: $e');
      throw Exception('Failed to update vets with distances: ${e.toString()}');
    }
  }

  /// Filter vets by search query
  List<VetModel> _filterByQuery(List<VetModel> vets, String query) {
    try {
      if (query.isEmpty) return vets;

      final lowerQuery = query.toLowerCase();
      return vets.where((vet) {
        return vet.name.toLowerCase().contains(lowerQuery) ||
            vet.location.toLowerCase().contains(lowerQuery) ||
            vet.description.toLowerCase().contains(lowerQuery) ||
            vet.category.toLowerCase().contains(lowerQuery) ||
            vet.services
                .any((service) => service.toLowerCase().contains(lowerQuery));
      }).toList();
    } catch (e) {
      throw Exception(
          'Failed to filter vets by query "$query": ${e.toString()}');
    }
  }

  /// Filter vets by category
  List<VetModel> _filterByCategory(List<VetModel> vets, String category) {
    try {
      if (category.isEmpty || category.toLowerCase() == 'all') return vets;

      return vets
          .where((vet) => vet.category.toLowerCase() == category.toLowerCase())
          .toList();
    } catch (e) {
      throw Exception(
          'Failed to filter vets by category "$category": ${e.toString()}');
    }
  }

  /// Filter vets by distance
  List<VetModel> _filterByDistance(
      List<VetModel> vets, Position currentPosition, double maxDistanceKm) {
    try {
      if (maxDistanceKm <= 0) {
        throw ArgumentError('Maximum distance must be greater than 0');
      }

      return vets.where((vet) {
        try {
          final distance = vet.calculateDistanceFromCurrentLocation(
            currentPosition.latitude,
            currentPosition.longitude,
          );
          return distance != null && distance / 1000 <= maxDistanceKm;
        } catch (e) {
          throw Exception(
              'Failed to calculate distance for vet "${vet.name}": ${e.toString()}');
        }
      }).toList();
    } catch (e) {
      throw Exception(
          'Failed to filter vets by distance ${maxDistanceKm}km: ${e.toString()}');
    }
  }

  /// Sort vets by distance
  List<VetModel> _sortVetsByDistance(
      List<VetModel> vets, Position currentPosition) {
    try {
      vets.sort((a, b) {
        try {
          final distanceA = a.calculateDistanceFromCurrentLocation(
            currentPosition.latitude,
            currentPosition.longitude,
          );
          final distanceB = b.calculateDistanceFromCurrentLocation(
            currentPosition.latitude,
            currentPosition.longitude,
          );

          if (distanceA == null && distanceB == null) return 0;
          if (distanceA == null) return 1;
          if (distanceB == null) return -1;

          return distanceA.compareTo(distanceB);
        } catch (e) {
          throw Exception(
              'Failed to compare distances for vets "${a.name}" and "${b.name}": ${e.toString()}');
        }
      });

      return vets;
    } catch (e) {
      throw Exception('Failed to sort vets by distance: ${e.toString()}');
    }
  }

  /// Sort vets by various criteria
  List<VetModel> _sortVets(
      List<VetModel> vets, String sortBy, Position currentPosition) {
    try {
      switch (sortBy.toLowerCase()) {
        case 'distance':
          return _sortVetsByDistance(vets, currentPosition);
        case 'rating':
          vets.sort((a, b) => b.rating.compareTo(a.rating));
          break;
        case 'reviews':
          vets.sort((a, b) => b.reviews.compareTo(a.reviews));
          break;
        case 'name':
          vets.sort((a, b) => a.name.compareTo(b.name));
          break;
        case 'experience':
          vets.sort((a, b) => b.yearsExperience.compareTo(a.yearsExperience));
          break;
        default:
          return _sortVetsByDistance(vets, currentPosition);
      }
      return vets;
    } catch (e) {
      throw Exception('Failed to sort vets by "$sortBy": ${e.toString()}');
    }
  }

  // ========== NEW API METHODS ==========

  /// Get vets from API with filters and pagination
  Future<Map<String, dynamic>> getVets({
    int page = 1,
    int limit = 10,
    String? search,
    double? minPrice,
    double? maxPrice,
    int? minExperience,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      if (minPrice != null) {
        queryParams['minPrice'] = minPrice;
      }
      if (maxPrice != null) {
        queryParams['maxPrice'] = maxPrice;
      }
      if (minExperience != null) {
        queryParams['minExperience'] = minExperience;
      }

      print('📡 Making API request to: ${ApiConstants.vetsEndpoint}');
      print('📡 Query params: $queryParams');

      final response = await _apiClient.get(
        ApiConstants.vetsEndpoint,
        queryParameters: queryParams,
      );

      print('📡 Response received: ${response.data}');

      // API response structure: {"success":true,"message":"...","data":[...],"meta":{...}}
      final data = response.data['data'] as List<dynamic>?;
      final meta = response.data['meta'] as Map<String, dynamic>?;

      print('🔍 API Response - Data count: ${data?.length ?? 0}');
      print('🔍 API Response - Meta: $meta');

      final vets = (data)
              ?.map((vet) => VetModel.fromJson(vet as Map<String, dynamic>))
              .toList() ??
          [];

      print('🔍 Parsed vets count: ${vets.length}');
      if (vets.isNotEmpty) {
        print('🔍 First vet: ${vets.first.name}');
      }

      return {
        'vets': vets,
        'total': meta?['total'] ?? 0,
        'page': meta?['page'] ?? page,
        'limit': meta?['limit'] ?? limit,
        'totalPages': meta?['lastPage'] ?? 1,
      };
    } catch (e, stackTrace) {
      print('❌ Error in getVets: $e');
      print('❌ Stack trace: $stackTrace');
      throw VetServiceException(
        'Failed to fetch vets',
        originalError: e,
      );
    }
  }

  /// Get specific vet details by ID
  Future<VetModel> getVetById(String vetId) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.vetDetailEndpoint(vetId),
      );

      return VetModel.fromJson(response.data);
    } catch (e) {
      throw VetNotFoundException(vetId);
    }
  }

  /// Get vet schedule for a specific date
  Future<VetScheduleModel> getVetSchedule(String vetId, String date) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.vetScheduleEndpoint(vetId),
        queryParameters: {'date': date},
      );

      return VetScheduleModel.fromJson(response.data);
    } catch (e) {
      throw VetServiceException(
        'Failed to fetch vet schedule',
        originalError: e,
      );
    }
  }

  /// Get vet reviews with pagination
  Future<ReviewsResponse> getVetReviews(
    String vetId, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.vetReviewsEndpoint(vetId),
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      return ReviewsResponse.fromJson(response.data);
    } catch (e) {
      throw VetServiceException(
        'Failed to fetch vet reviews',
        originalError: e,
      );
    }
  }

  /// Get available time slots for a vet on a specific date
  Future<List<TimeSlotModel>> getVetTimeSlots(
    String vetId,
    DateTime date,
  ) async {
    try {
      print(
          '🔄 Fetching time slots for vet: $vetId on ${date.toIso8601String()}');

      final response = await _apiClient.get(
        ApiConstants.vetScheduleEndpoint(vetId),
        queryParameters: {
          'date': date.toIso8601String().split('T')[0], // Format: YYYY-MM-DD
        },
      );

      print('✅ Time slots response: ${response.data}');

      final data = response.data['data'] as List<dynamic>?;

      if (data == null || data.isEmpty) {
        print('⚠️ No time slots available');
        return [];
      }

      final timeSlots = data
          .map((slot) => TimeSlotModel.fromJson(slot as Map<String, dynamic>))
          .toList();

      print('✅ Parsed ${timeSlots.length} time slots');
      return timeSlots;
    } catch (e, stackTrace) {
      print('❌ Error fetching time slots: $e');
      print('❌ Stack trace: $stackTrace');
      throw VetServiceException(
        'Failed to fetch time slots',
        originalError: e,
      );
    }
  }
}

/// Custom exception classes for better error handling
class VetServiceException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const VetServiceException(
    this.message, {
    this.code,
    this.originalError,
  });

  @override
  String toString() {
    if (code != null) {
      return 'VetServiceException [$code]: $message';
    }
    return 'VetServiceException: $message';
  }
}

class LocationNotAvailableException extends VetServiceException {
  const LocationNotAvailableException([String? message])
      : super(
          message ??
              'Location service is not available or permission not granted',
          code: 'LOCATION_NOT_AVAILABLE',
        );
}

class VetNotFoundException extends VetServiceException {
  final String clinicId;

  const VetNotFoundException(this.clinicId)
      : super(
          'Clinic not found with ID: $clinicId',
          code: 'CLINIC_NOT_FOUND',
        );
}

class InvalidDistanceException extends VetServiceException {
  final double invalidDistance;

  const InvalidDistanceException(this.invalidDistance)
      : super(
          'Invalid distance value: $invalidDistance. Distance must be greater than 0',
          code: 'INVALID_DISTANCE',
        );
}
