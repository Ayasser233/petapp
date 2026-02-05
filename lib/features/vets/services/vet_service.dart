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

  /// Get all vets with location-based distances

  // Extended vet database with more entries and coordinates
  final List<VetModel> _allVets = [];
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

      final response = await getVets(
        page: 1,
        limit: limit,
      );

      final vets = response['vets'] as List<VetModel>;

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
        return vets;
      }


      return vets.map((vet) {
        try {
          if (vet.latitude == null || vet.longitude == null) {
            return vet.copyWith(distance: 'Unknown');
          }

          final distance = vet.calculateDistanceFromCurrentLocation(
            currentPosition.latitude,
            currentPosition.longitude,
          );

          final formattedDistance = distance != null
              ? _locationService.formatDistance(distance)
              : 'Unknown';

          return vet.copyWith(distance: formattedDistance);
        } catch (e) {
          return vet.copyWith(distance: 'Unknown');
        }
      }).toList();
    } catch (e) {
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
    bool? hasEmergency,
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
      if (hasEmergency != null) {
        queryParams['hasEmergency'] = hasEmergency;
      }


      final response = await _apiClient.get(
        ApiConstants.vetsEndpoint,
        queryParameters: queryParams,
      );


      // API response structure: {"success":true,"message":"...","data":[...],"meta":{...}}
      final data = response.data['data'] as List<dynamic>?;
      final meta = response.data['meta'] as Map<String, dynamic>?;


      final vets = (data)
              ?.map((vet) => VetModel.fromJson(vet as Map<String, dynamic>))
              .toList() ??
          [];

      if (vets.isNotEmpty) {
        // Fetch schedule slots for each vet to get accurate opening status
        final vetsWithSchedule = await Future.wait(
          vets.map((vet) async {
            try {
              final scheduleSlots = await getVetScheduleSlots(vet.id);
              final openingInfo = await getVetOpeningInfo(vet.id);

              return vet.copyWith(
                scheduleSlots: scheduleSlots,
                isAvailable: openingInfo['isOpen'] as bool?,
                openingDaysText: openingInfo['openingDays'] != null && (openingInfo['openingDays'] as List).isNotEmpty
                    ? (openingInfo['openingDays'] as List<String>).join(', ')
                    : null,
              );
            } catch (e) {
              // Return vet without schedule info if fetch fails
              return vet;
            }
          }),
        );

        return {
          'vets': vetsWithSchedule,
          'total': meta?['total'] ?? 0,
          'page': meta?['page'] ?? page,
          'limit': meta?['limit'] ?? limit,
          'totalPages': meta?['lastPage'] ?? 1,
        };
      }

      return {
        'vets': vets,
        'total': meta?['total'] ?? 0,
        'page': meta?['page'] ?? page,
        'limit': meta?['limit'] ?? limit,
        'totalPages': meta?['lastPage'] ?? 1,
      };
    } catch (e) {
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

      final response = await _apiClient.get(
        ApiConstants.vetScheduleEndpoint(vetId),
        queryParameters: {
          'date': date.toIso8601String().split('T')[0], // Format: YYYY-MM-DD
        },
      );


      final data = response.data['data'] as List<dynamic>?;

      if (data == null || data.isEmpty) {
        return [];
      }

      final timeSlots = data
          .map((slot) => TimeSlotModel.fromJson(slot as Map<String, dynamic>))
          .toList();

      return timeSlots;
    } catch (e) {
      throw VetServiceException(
        'Failed to fetch time slots',
        originalError: e,
      );
    }
  }

  /// Get vet schedule slots (all days with availability info)
  Future<List<VetScheduleSlot>> getVetScheduleSlots(String vetId) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.vetScheduleEndpoint(vetId),
      );

      final data = response.data['data'] as List<dynamic>?;

      if (data == null || data.isEmpty) {
        return [];
      }

      final scheduleSlots = data
          .map((slot) => VetScheduleSlot.fromJson(slot as Map<String, dynamic>))
          .toList();

      return scheduleSlots;
    } catch (e) {
      throw VetServiceException(
        'Failed to fetch vet schedule slots',
        originalError: e,
      );
    }
  }

  /// Get vet opening days and times
  Future<Map<String, dynamic>> getVetOpeningInfo(String vetId) async {
    try {
      final scheduleSlots = await getVetScheduleSlots(vetId);

      if (scheduleSlots.isEmpty) {
        return {
          'isOpen': false,
          'openingDays': <String>[],
          'openingStatus': 'Closed',
        };
      }

      // Get current day of week
      final now = DateTime.now();
      final currentDayName = _getDayNameFromDateTime(now);

      // Filter active slots available for current week
      final activeSlots = scheduleSlots.where((slot) =>
        slot.isActive &&
        slot.isAvailableCurrentWeek &&
        !slot.isFull
      ).toList();

      // Check if open today
      final todaySlots = activeSlots.where((slot) =>
        slot.dayOfWeek == currentDayName
      ).toList();

      // Get unique days with available slots
      final openingDays = activeSlots
          .map((slot) => slot.dayOfWeek)
          .toSet()
          .toList();

      // Determine opening status
      String openingStatus = 'Closed';
      bool isOpen = false;

      if (todaySlots.isNotEmpty) {
        // Check if currently within operating hours
        final currentTime = now.hour * 60 + now.minute;

        for (final slot in todaySlots) {
          final startMinutes = _parseTimeToMinutes(slot.startTime);
          final endMinutes = _parseTimeToMinutes(slot.endTime);

          if (currentTime >= startMinutes && currentTime <= endMinutes) {
            openingStatus = 'Open Now';
            isOpen = true;
            break;
          }
        }

        // If not currently open but has slots today
        if (!isOpen && todaySlots.isNotEmpty) {
          final firstSlot = todaySlots.first;
          openingStatus = 'Closed • Opens at ${firstSlot.startTime}';
        }
      } else if (openingDays.isNotEmpty) {
        // Find next available day
        openingStatus = 'Closed • Opens ${_getNextAvailableDay(openingDays, currentDayName)}';
      }

      return {
        'isOpen': isOpen,
        'openingDays': openingDays,
        'openingStatus': openingStatus,
        'scheduleSlots': activeSlots,
      };
    } catch (e) {
      return {
        'isOpen': false,
        'openingDays': <String>[],
        'openingStatus': 'Closed',
      };
    }
  }

  /// Parse time string (e.g., "14:30") to minutes since midnight
  int _parseTimeToMinutes(String timeStr) {
    try {
      final parts = timeStr.split(':');
      if (parts.length != 2) return 0;

      final hours = int.parse(parts[0]);
      final minutes = int.parse(parts[1]);

      return hours * 60 + minutes;
    } catch (e) {
      return 0;
    }
  }

  /// Get day name from DateTime
  String _getDayNameFromDateTime(DateTime date) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[date.weekday - 1];
  }

  /// Get next available day text
  String _getNextAvailableDay(List<String> openingDays, String currentDay) {
    const dayOrder = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    final currentIndex = dayOrder.indexOf(currentDay);

    // Find next day in the week
    for (int i = 1; i <= 7; i++) {
      final nextIndex = (currentIndex + i) % 7;
      final nextDay = dayOrder[nextIndex];

      if (openingDays.contains(nextDay)) {
        if (i == 1) return 'tomorrow';
        return 'on $nextDay';
      }
    }

    return openingDays.isNotEmpty ? 'on ${openingDays.first}' : '';
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
