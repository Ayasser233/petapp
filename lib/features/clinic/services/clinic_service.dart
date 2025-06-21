import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../models/clinic_model.dart';
import '../../../core/services/location_service.dart';

class ClinicService {
  static final ClinicService _instance = ClinicService._internal();
  factory ClinicService() => _instance;
  ClinicService._internal();

  final LocationService _locationService = Get.find<LocationService>();

  // Extended clinic database with more entries and coordinates
  final List<ClinicModel> _allClinics = [
    ClinicModel(
      id: '1',
      name: 'Banfield Pet Hospital',
      category: 'Hospital',
      location: 'Los Angeles, CA',
      distance: 'Calculating...',
      image: 'assets/images/pet_hospital.jpg',
      description: 'Banfield Pet Hospital is a network of specialized animal hospitals that offer emergency and specialist services. They focus on the care of pets that require specialized medical attention.',
      rating: 4.8,
      reviews: 324,
      patients: 709,
      yearsExperience: 15,
      latitude: 34.0522,
      longitude: -118.2437,
      phone: '+1 (555) 123-4567',
      email: 'info@banfield.com',
      services: ['Emergency Care', 'Surgery', 'Dental Care', 'Vaccination', 'X-Ray', 'Laboratory'],
      openingHours: {
        'Monday': '8:00 AM - 6:00 PM',
        'Tuesday': '8:00 AM - 6:00 PM',
        'Wednesday': '8:00 AM - 6:00 PM',
        'Thursday': '8:00 AM - 6:00 PM',
        'Friday': '8:00 AM - 6:00 PM',
        'Saturday': '9:00 AM - 4:00 PM',
        'Sunday': '10:00 AM - 2:00 PM',
      },
    ),
    ClinicModel(
      id: '2',
      name: 'VCA Animal Hospital',
      category: 'Hospital',
      location: 'Brooklyn, NY',
      distance: 'Calculating...',
      image: 'assets/images/pet_hospital2.jpg',
      description: 'VCA Animal Hospital provides a full range of general medical and surgical services as well as specialized treatments for companion animals.',
      rating: 4.6,
      reviews: 287,
      patients: 583,
      yearsExperience: 12,
      latitude: 40.6782,
      longitude: -73.9442,
      phone: '+1 (555) 987-6543',
      email: 'contact@vca.com',
      services: ['General Check-up', 'Vaccination', 'Grooming', 'Surgery', 'Pharmacy'],
      openingHours: {
        'Monday': '7:00 AM - 7:00 PM',
        'Tuesday': '7:00 AM - 7:00 PM',
        'Wednesday': '7:00 AM - 7:00 PM',
        'Thursday': '7:00 AM - 7:00 PM',
        'Friday': '7:00 AM - 7:00 PM',
        'Saturday': '8:00 AM - 5:00 PM',
        'Sunday': 'Closed',
      },
    ),
    ClinicModel(
      id: '3',
      name: 'BluePearl Pet Hospital',
      category: 'Emergency',
      location: 'Healdsburg, CA',
      distance: 'Calculating...',
      image: 'assets/images/pet_hospital3.jpg',
      description: 'BluePearl Pet Hospital specializes in emergency and specialty care for pets when they need it most.',
      rating: 4.7,
      reviews: 127,
      patients: 709,
      yearsExperience: 15,
      latitude: 38.6104,
      longitude: -122.8695,
      phone: '+1 (555) 456-7890',
      email: 'info@bluepearlvet.com',
      services: ['Emergency Care', 'Specialty Care', 'Surgery', 'Diagnostics', '24/7 Care'],
      openingHours: {
        'Monday': '24 Hours',
        'Tuesday': '24 Hours',
        'Wednesday': '24 Hours',
        'Thursday': '24 Hours',
        'Friday': '24 Hours',
        'Saturday': '24 Hours',
        'Sunday': '24 Hours',
      },
    ),
    ClinicModel(
      id: '4',
      name: 'PetSmart Veterinary Services',
      category: 'Clinic',
      location: 'Phoenix, AZ',
      distance: 'Calculating...',
      image: 'assets/images/pet_hospital.jpg',
      description: 'Convenient veterinary care with grooming and pharmacy services all in one location.',
      rating: 4.3,
      reviews: 156,
      patients: 425,
      yearsExperience: 8,
      latitude: 33.4484,
      longitude: -112.0740,
      phone: '+1 (555) 321-9876',
      email: 'vet@petsmart.com',
      services: ['Check-up', 'Vaccination', 'Grooming', 'Pharmacy', 'Nail Trimming'],
      openingHours: {
        'Monday': '9:00 AM - 8:00 PM',
        'Tuesday': '9:00 AM - 8:00 PM',
        'Wednesday': '9:00 AM - 8:00 PM',
        'Thursday': '9:00 AM - 8:00 PM',
        'Friday': '9:00 AM - 8:00 PM',
        'Saturday': '9:00 AM - 6:00 PM',
        'Sunday': '10:00 AM - 6:00 PM',
      },
    ),
    ClinicModel(
      id: '5',
      name: 'Animal Specialty Center',
      category: 'Specialty',
      location: 'Miami, FL',
      distance: 'Calculating...',
      image: 'assets/images/pet_hospital2.jpg',
      description: 'Advanced specialty care including cardiology, oncology, and orthopedic surgery.',
      rating: 4.9,
      reviews: 89,
      patients: 312,
      yearsExperience: 20,
      latitude: 25.7617,
      longitude: -80.1918,
      phone: '+1 (555) 654-3210',
      email: 'info@animalspecialty.com',
      services: ['Cardiology', 'Oncology', 'Orthopedics', 'Neurology', 'Advanced Surgery'],
      openingHours: {
        'Monday': '8:00 AM - 5:00 PM',
        'Tuesday': '8:00 AM - 5:00 PM',
        'Wednesday': '8:00 AM - 5:00 PM',
        'Thursday': '8:00 AM - 5:00 PM',
        'Friday': '8:00 AM - 5:00 PM',
        'Saturday': 'By Appointment',
        'Sunday': 'Emergency Only',
      },
    ),
    ClinicModel(
      id: '6',
      name: 'Happy Paws Grooming & Wellness',
      category: 'Grooming',
      location: 'Seattle, WA',
      distance: 'Calculating...',
      image: 'assets/images/pet_hospital3.jpg',
      description: 'Full-service grooming with basic wellness checks and preventive care.',
      rating: 4.4,
      reviews: 203,
      patients: 567,
      yearsExperience: 6,
      latitude: 47.6062,
      longitude: -122.3321,
      phone: '+1 (555) 789-0123',
      email: 'hello@happypaws.com',
      services: ['Full Grooming', 'Bath & Brush', 'Nail Care', 'Wellness Check', 'Flea Treatment'],
      openingHours: {
        'Monday': '9:00 AM - 6:00 PM',
        'Tuesday': '9:00 AM - 6:00 PM',
        'Wednesday': '9:00 AM - 6:00 PM',
        'Thursday': '9:00 AM - 6:00 PM',
        'Friday': '9:00 AM - 6:00 PM',
        'Saturday': '8:00 AM - 4:00 PM',
        'Sunday': 'Closed',
      },
    ),
    ClinicModel(
      id: '7',
      name: 'Metropolitan Animal Hospital',
      category: 'Hospital',
      location: 'Chicago, IL',
      distance: 'Calculating...',
      image: 'assets/images/pet_hospital.jpg',
      description: 'Full-service animal hospital serving the Chicago metropolitan area with comprehensive care.',
      rating: 4.5,
      reviews: 412,
      patients: 890,
      yearsExperience: 18,
      latitude: 41.8781,
      longitude: -87.6298,
      phone: '+1 (555) 246-8135',
      email: 'info@metroanimalhospital.com',
      services: ['Emergency Care', 'Surgery', 'Dental Care', 'Vaccination', 'Boarding'],
      openingHours: {
        'Monday': '7:00 AM - 8:00 PM',
        'Tuesday': '7:00 AM - 8:00 PM',
        'Wednesday': '7:00 AM - 8:00 PM',
        'Thursday': '7:00 AM - 8:00 PM',
        'Friday': '7:00 AM - 8:00 PM',
        'Saturday': '8:00 AM - 6:00 PM',
        'Sunday': '10:00 AM - 4:00 PM',
      },
    ),
    ClinicModel(
      id: '8',
      name: 'Countryside Veterinary Clinic',
      category: 'Clinic',
      location: 'Austin, TX',
      distance: 'Calculating...',
      image: 'assets/images/pet_hospital2.jpg',
      description: 'Family-owned veterinary clinic providing personalized care for pets in a comfortable environment.',
      rating: 4.7,
      reviews: 268,
      patients: 534,
      yearsExperience: 10,
      latitude: 30.2672,
      longitude: -97.7431,
      phone: '+1 (555) 369-2580',
      email: 'care@countrysidevet.com',
      services: ['General Check-up', 'Vaccination', 'Surgery', 'Dental Care', 'Microchipping'],
      openingHours: {
        'Monday': '8:00 AM - 6:00 PM',
        'Tuesday': '8:00 AM - 6:00 PM',
        'Wednesday': '8:00 AM - 6:00 PM',
        'Thursday': '8:00 AM - 6:00 PM',
        'Friday': '8:00 AM - 6:00 PM',
        'Saturday': '9:00 AM - 3:00 PM',
        'Sunday': 'Closed',
      },
    ),
    ClinicModel(
      id: '9',
      name: 'Coastal Pet Emergency Center',
      category: 'Emergency',
      location: 'San Diego, CA',
      distance: 'Calculating...',
      image: 'assets/images/pet_hospital3.jpg',
      description: '24/7 emergency veterinary care for critical and urgent pet medical needs.',
      rating: 4.6,
      reviews: 178,
      patients: 623,
      yearsExperience: 12,
      latitude: 32.7157,
      longitude: -117.1611,
      phone: '+1 (555) 147-8520',
      email: 'emergency@coastalpet.com',
      services: ['Emergency Care', 'Critical Care', 'Surgery', 'Diagnostics', 'Intensive Care'],
      openingHours: {
        'Monday': '24 Hours',
        'Tuesday': '24 Hours',
        'Wednesday': '24 Hours',
        'Thursday': '24 Hours',
        'Friday': '24 Hours',
        'Saturday': '24 Hours',
        'Sunday': '24 Hours',
      },
    ),
    ClinicModel(
      id: '10',
      name: 'Paws & Claws Veterinary Pharmacy',
      category: 'Pharmacy',
      location: 'Denver, CO',
      distance: 'Calculating...',
      image: 'assets/images/pet_hospital.jpg',
      description: 'Specialized veterinary pharmacy with consultation services and medication delivery.',
      rating: 4.2,
      reviews: 94,
      patients: 312,
      yearsExperience: 5,
      latitude: 39.7392,
      longitude: -104.9903,
      phone: '+1 (555) 963-7410',
      email: 'pharmacy@pawsclaws.com',
      services: ['Pharmacy', 'Medication Consultation', 'Prescription Delivery', 'Compounding'],
      openingHours: {
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

  /// Get all clinics with location-based distances
  Future<List<ClinicModel>> getAllClinics() async {
    try {
      return await _updateClinicsWithDistances(_allClinics);
    } catch (e) {
      throw Exception('Failed to get all clinics: ${e.toString()}');
    }
  }

  /// Get nearby clinics (sorted by distance)
  Future<List<ClinicModel>> getNearByClinics({int limit = 3}) async {
    try {
      final allClinics = await getAllClinics();
      final currentPosition = _locationService.currentPosition;
      
      if (currentPosition == null) {
        return allClinics.take(limit).toList();
      }

      // Sort by distance and return limited results
      final sortedClinics = _sortClinicsByDistance(allClinics, currentPosition);
      return sortedClinics.take(limit).toList();
    } catch (e) {
      throw Exception('Failed to get nearby clinics: ${e.toString()}');
    }
  }

  /// Search clinics with location-based filtering
  Future<List<ClinicModel>> searchClinics({
    String? query,
    String? category,
    String? sortBy = 'distance',
    double? maxDistanceKm,
  }) async {
    try {
      List<ClinicModel> filteredClinics = await getAllClinics();
      final currentPosition = _locationService.currentPosition;

      // Apply text search filter
      if (query != null && query.isNotEmpty) {
        filteredClinics = _filterByQuery(filteredClinics, query);
      }

      // Apply category filter
      if (category != null && category != 'All' && category.isNotEmpty) {
        filteredClinics = _filterByCategory(filteredClinics, category);
      }

      // Apply distance filter if location is available
      if (currentPosition != null && maxDistanceKm != null) {
        filteredClinics = _filterByDistance(filteredClinics, currentPosition, maxDistanceKm);
      }

      // Apply sorting
      if (currentPosition != null) {
        filteredClinics = _sortClinics(filteredClinics, sortBy!, currentPosition);
      }

      return filteredClinics;
    } catch (e) {
      throw Exception('Failed to search clinics: ${e.toString()}');
    }
  }

  /// Get clinics by category
  Future<List<ClinicModel>> getClinicsByCategory(String category) async {
    try {
      final allClinics = await getAllClinics();
      if (category == 'All') return allClinics;
      
      return _filterByCategory(allClinics, category);
    } catch (e) {
      throw Exception('Failed to get clinics by category "$category": ${e.toString()}');
    }
  }

  /// Get clinics within specified distance
  Future<List<ClinicModel>> getClinicsWithinDistance(double maxDistanceKm) async {
    try {
      final allClinics = await getAllClinics();
      final currentPosition = _locationService.currentPosition;
      
      if (currentPosition == null) {
        throw Exception('Location service not available or permission not granted');
      }

      return _filterByDistance(allClinics, currentPosition, maxDistanceKm);
    } catch (e) {
      throw Exception('Failed to get clinics within ${maxDistanceKm}km: ${e.toString()}');
    }
  }

  /// Get clinic by ID
  Future<ClinicModel?> getClinicById(String id) async {
    try {
      final allClinics = await getAllClinics();
      return allClinics.firstWhere((clinic) => clinic.id == id);
    } catch (e) {
      throw Exception('Clinic not found with ID "$id": ${e.toString()}');
    }
  }

  /// Get popular clinics (high rating and reviews)
  Future<List<ClinicModel>> getPopularClinics({int limit = 5}) async {
    try {
      final allClinics = await getAllClinics();
      
      // Sort by rating and reviews
      allClinics.sort((a, b) {
        final aScore = a.rating * 0.7 + (a.reviews / 100) * 0.3;
        final bScore = b.rating * 0.7 + (b.reviews / 100) * 0.3;
        return bScore.compareTo(aScore);
      });
      
      return allClinics.take(limit).toList();
    } catch (e) {
      throw Exception('Failed to get popular clinics: ${e.toString()}');
    }
  }

  /// Get emergency clinics
  Future<List<ClinicModel>> getEmergencyClinics() async {
    try {
      final allClinics = await getAllClinics();
      final emergencyClinics = allClinics.where((clinic) {
        return clinic.category.toLowerCase().contains('emergency') ||
               clinic.services.any((service) => 
                   service.toLowerCase().contains('emergency') ||
                   service.toLowerCase().contains('24/7') ||
                   service.toLowerCase().contains('critical'));
      }).toList();

      if (emergencyClinics.isEmpty) {
        throw Exception('No emergency clinics found');
      }

      // Sort by distance if location available
      final currentPosition = _locationService.currentPosition;
      if (currentPosition != null) {
        return _sortClinicsByDistance(emergencyClinics, currentPosition);
      }
      
      return emergencyClinics;
    } catch (e) {
      throw Exception('Failed to get emergency clinics: ${e.toString()}');
    }
  }

  /// Get available categories
  List<String> getAvailableCategories() {
    try {
      final categories = _allClinics.map((clinic) => clinic.category).toSet().toList();
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
      for (final clinic in _allClinics) {
        services.addAll(clinic.services);
      }
      return services.toList()..sort();
    } catch (e) {
      throw Exception('Failed to get available services: ${e.toString()}');
    }
  }

  // Private helper methods

  /// Update clinics with calculated distances
  Future<List<ClinicModel>> _updateClinicsWithDistances(List<ClinicModel> clinics) async {
    try {
      final currentPosition = _locationService.currentPosition;
      
      if (currentPosition == null) {
        return clinics;
      }

      return clinics.map((clinic) {
        try {
          final distance = clinic.calculateDistanceFromCurrentLocation(
            currentPosition.latitude,
            currentPosition.longitude,
          );

          final formattedDistance = distance != null 
              ? _locationService.formatDistance(distance)
              : 'Unknown';

          return clinic.copyWith(distance: formattedDistance);
        } catch (e) {
          throw Exception('Failed to calculate distance for clinic "${clinic.name}": ${e.toString()}');
        }
      }).toList();
    } catch (e) {
      throw Exception('Failed to update clinics with distances: ${e.toString()}');
    }
  }

  /// Filter clinics by search query
  List<ClinicModel> _filterByQuery(List<ClinicModel> clinics, String query) {
    try {
      if (query.isEmpty) return clinics;
      
      final lowerQuery = query.toLowerCase();
      return clinics.where((clinic) {
        return clinic.name.toLowerCase().contains(lowerQuery) ||
               clinic.location.toLowerCase().contains(lowerQuery) ||
               clinic.description.toLowerCase().contains(lowerQuery) ||
               clinic.category.toLowerCase().contains(lowerQuery) ||
               clinic.services.any((service) => 
                   service.toLowerCase().contains(lowerQuery));
      }).toList();
    } catch (e) {
      throw Exception('Failed to filter clinics by query "$query": ${e.toString()}');
    }
  }

  /// Filter clinics by category
  List<ClinicModel> _filterByCategory(List<ClinicModel> clinics, String category) {
    try {
      if (category.isEmpty || category.toLowerCase() == 'all') return clinics;
      
      return clinics.where((clinic) => 
          clinic.category.toLowerCase() == category.toLowerCase()).toList();
    } catch (e) {
      throw Exception('Failed to filter clinics by category "$category": ${e.toString()}');
    }
  }

  /// Filter clinics by distance
  List<ClinicModel> _filterByDistance(
    List<ClinicModel> clinics, 
    Position currentPosition, 
    double maxDistanceKm
  ) {
    try {
      if (maxDistanceKm <= 0) {
        throw ArgumentError('Maximum distance must be greater than 0');
      }

      return clinics.where((clinic) {
        try {
          final distance = clinic.calculateDistanceFromCurrentLocation(
            currentPosition.latitude,
            currentPosition.longitude,
          );
          return distance != null && distance / 1000 <= maxDistanceKm;
        } catch (e) {
          throw Exception('Failed to calculate distance for clinic "${clinic.name}": ${e.toString()}');
        }
      }).toList();
    } catch (e) {
      throw Exception('Failed to filter clinics by distance ${maxDistanceKm}km: ${e.toString()}');
    }
  }

  /// Sort clinics by distance
  List<ClinicModel> _sortClinicsByDistance(List<ClinicModel> clinics, Position currentPosition) {
    try {
      clinics.sort((a, b) {
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
          throw Exception('Failed to compare distances for clinics "${a.name}" and "${b.name}": ${e.toString()}');
        }
      });
      
      return clinics;
    } catch (e) {
      throw Exception('Failed to sort clinics by distance: ${e.toString()}');
    }
  }

  /// Sort clinics by various criteria
  List<ClinicModel> _sortClinics(
    List<ClinicModel> clinics, 
    String sortBy, 
    Position currentPosition
  ) {
    try {
      switch (sortBy.toLowerCase()) {
        case 'distance':
          return _sortClinicsByDistance(clinics, currentPosition);
        case 'rating':
          clinics.sort((a, b) => b.rating.compareTo(a.rating));
          break;
        case 'reviews':
          clinics.sort((a, b) => b.reviews.compareTo(a.reviews));
          break;
        case 'name':
          clinics.sort((a, b) => a.name.compareTo(b.name));
          break;
        case 'experience':
          clinics.sort((a, b) => b.yearsExperience.compareTo(a.yearsExperience));
          break;
        default:
          return _sortClinicsByDistance(clinics, currentPosition);
      }
      return clinics;
    } catch (e) {
      throw Exception('Failed to sort clinics by "$sortBy": ${e.toString()}');
    }
  }
}

/// Custom exception classes for better error handling
class ClinicServiceException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const ClinicServiceException(
    this.message, {
    this.code,
    this.originalError,
  });

  @override
  String toString() {
    if (code != null) {
      return 'ClinicServiceException [$code]: $message';
    }
    return 'ClinicServiceException: $message';
  }
}

class LocationNotAvailableException extends ClinicServiceException {
  const LocationNotAvailableException([String? message])
      : super(
          message ?? 'Location service is not available or permission not granted',
          code: 'LOCATION_NOT_AVAILABLE',
        );
}

class ClinicNotFoundException extends ClinicServiceException {
  final String clinicId;
  
  const ClinicNotFoundException(this.clinicId)
      : super(
          'Clinic not found with ID: $clinicId',
          code: 'CLINIC_NOT_FOUND',
        );
}

class InvalidDistanceException extends ClinicServiceException {
  final double invalidDistance;
  
  const InvalidDistanceException(this.invalidDistance)
      : super(
          'Invalid distance value: $invalidDistance. Distance must be greater than 0',
          code: 'INVALID_DISTANCE',
        );
}