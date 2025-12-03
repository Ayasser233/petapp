import 'package:geolocator/geolocator.dart';
import '../../../core/utils/api_constants.dart';
import 'vet_schedule_model.dart';

/// Represents a discount offered by a vet clinic
class VetDiscount {
  final String title;
  final String description;
  final String type; // 'percentage' or 'fixed'
  final double value;
  final bool isActive;

  VetDiscount({
    required this.title,
    required this.description,
    required this.type,
    required this.value,
    required this.isActive,
  });

  factory VetDiscount.fromJson(Map<String, dynamic> json) {
    return VetDiscount(
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      type: json['type']?.toString() ?? 'percentage',
      value: (json['value'] is int)
          ? (json['value'] as int).toDouble()
          : (json['value'] ?? 0.0).toDouble(),
      isActive: json['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'type': type,
      'value': value,
      'isActive': isActive,
    };
  }

  /// Calculate discount amount based on original price
  double calculateDiscount(double originalPrice) {
    if (!isActive) return 0.0;

    if (type == 'percentage') {
      return originalPrice * (value / 100);
    } else {
      // Fixed amount discount
      return value > originalPrice ? originalPrice : value;
    }
  }

  /// Get formatted discount string for display
  String get formattedDiscount {
    if (type == 'percentage') {
      return '${value.toInt()}% OFF';
    } else {
      return '${value.toInt()} EGP OFF';
    }
  }
}

class VetModel {
  final String id;
  final String name;
  final String category;
  final String location;
  final String distance;
  final List<String> images; // List of images - first one used for card
  final String description;
  final double rating;
  final int reviews;
  final int patients;
  final int yearsExperience;
  final double? latitude;
  final double? longitude;
  final String? phone;
  final String? email;
  final List<String> services;
  final Map<String, String> openingHours;
  final double? consultationFee;
  final String? specialization;
  final String? bio;
  final String? ownerId;
  final VetDiscount? discount;
  final bool? isAvailable;  // Whether vet has available slots
  final List<VetScheduleSlot>? scheduleSlots; // Schedule information from API
  final String? openingDaysText; // E.g., "Mon - Fri" or "Mon, Wed, Fri"

  VetModel({
    required this.id,
    required this.name,
    required this.category,
    required this.location,
    required this.distance,
    this.images = const [
      'assets/images/pet_hospital.jpg'
    ], // Default image if none provided
    required this.description,
    required this.rating,
    required this.reviews,
    required this.patients,
    required this.yearsExperience,
    this.latitude,
    this.longitude,
    this.phone,
    this.email,
    this.services = const [],
    this.openingHours = const {},
    this.consultationFee,
    this.specialization,
    this.bio,
    this.ownerId,
    this.discount,
    this.isAvailable,
    this.scheduleSlots,
    this.openingDaysText,
  });

  // Helper getter to get the first image (for cards)
  String get primaryImage =>
      images.isNotEmpty ? images.first : 'assets/images/pet_hospital.jpg';

  /// Calculate distance from current location
  double? calculateDistanceFromCurrentLocation(
      double? currentLat, double? currentLon) {
    if (latitude == null ||
        longitude == null ||
        currentLat == null ||
        currentLon == null) {
      return null;
    }

    return Geolocator.distanceBetween(
        currentLat, currentLon, latitude!, longitude!);
  }

  /// Check if clinic is currently open
  bool get isCurrentlyOpen {
    final now = DateTime.now();
    final dayName = _getDayName(now.weekday);
    final currentHours = openingHours[dayName];

    if (currentHours == null || currentHours.isEmpty) return false;
    if (currentHours == '24 Hours') return true;
    if (currentHours == 'Closed') return false;

    // Parse hours like "9:00 AM - 6:00 PM"
    try {
      final parts = currentHours.split(' - ');
      if (parts.length != 2) return false;

      final openTime = _parseTime(parts[0]);
      final closeTime = _parseTime(parts[1]);
      final currentTime = now.hour * 60 + now.minute;

      return currentTime >= openTime && currentTime <= closeTime;
    } catch (e) {
      return false;
    }
  }

  /// Get opening status text
  String get openingStatus {
    // Use schedule slots if available for more accurate status
    if (scheduleSlots != null && scheduleSlots!.isNotEmpty) {
      return _getStatusFromScheduleSlots();
    }

    // Fallback to API isAvailable field
    if (isAvailable != null && !isAvailable!) {
      return openingDaysText != null ? 'Closed • Opens $openingDaysText' : 'Closed';
    }

    // Then check opening hours
    if (isCurrentlyOpen) return 'Open Now';

    final now = DateTime.now();
    final dayName = _getDayName(now.weekday);
    final currentHours = openingHours[dayName];

    if (currentHours == null ||
        currentHours.isEmpty ||
        currentHours == 'Closed') {
      return openingDaysText != null ? 'Closed • Opens $openingDaysText' : 'Closed';
    }

    return 'Closed • Opens ${currentHours.split(' - ')[0]}';
  }

  /// Get status from schedule slots
  String _getStatusFromScheduleSlots() {
    if (scheduleSlots == null || scheduleSlots!.isEmpty) {
      return 'Closed';
    }

    final now = DateTime.now();
    final currentDayName = _getDayName(now.weekday);
    final currentTime = now.hour * 60 + now.minute;

    // Filter active slots for current week
    final activeSlots = scheduleSlots!.where((slot) =>
      slot.isActive &&
      slot.isAvailableCurrentWeek &&
      !slot.isFull &&
      slot.availableSpots > 0
    ).toList();

    if (activeSlots.isEmpty) {
      return 'Closed';
    }

    // Check if open now
    final todaySlots = activeSlots.where((slot) =>
      slot.dayOfWeek == currentDayName
    ).toList();

    for (final slot in todaySlots) {
      final startMinutes = _parseScheduleTime(slot.startTime);
      final endMinutes = _parseScheduleTime(slot.endTime);

      if (currentTime >= startMinutes && currentTime <= endMinutes) {
        return 'Open Now';
      }
    }

    // If not currently open but has slots today
    if (todaySlots.isNotEmpty) {
      final firstSlot = todaySlots.first;
      return 'Closed • Opens at ${firstSlot.startTime}';
    }

    // Find next available day
    final openingDays = activeSlots
        .map((slot) => slot.dayOfWeek)
        .toSet()
        .toList();

    if (openingDays.isNotEmpty) {
      final nextDay = _getNextAvailableDay(openingDays, currentDayName);
      return 'Closed • Opens $nextDay';
    }

    return 'Closed';
  }

  /// Parse schedule time (24-hour format like "14:30") to minutes
  int _parseScheduleTime(String timeStr) {
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

  /// Check if vet has available slots (used in cards)
  bool get hasAvailableSlots {
    // Use the API-provided isAvailable field if present
    if (isAvailable != null) {
      return isAvailable!;
    }

    // Fallback to opening hours check
    return isCurrentlyOpen;
  }

  /// Get day name from weekday number
  String _getDayName(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[weekday - 1];
  }

  /// Parse time string to minutes since midnight
  int _parseTime(String timeStr) {
    final cleanTime = timeStr.trim();
    final isAM = cleanTime.contains('AM');
    final isPM = cleanTime.contains('PM');

    final timePart = cleanTime.replaceAll(RegExp(r'[AP]M'), '').trim();
    final parts = timePart.split(':');

    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);

    if (isPM && hours != 12) hours += 12;
    if (isAM && hours == 12) hours = 0;

    return hours * 60 + minutes;
  }

  /// Copy with method for updating properties
  VetModel copyWith({
    String? id,
    String? name,
    String? category,
    String? location,
    String? distance,
    List<String>? images,
    String? description,
    double? rating,
    int? reviews,
    int? patients,
    int? yearsExperience,
    double? latitude,
    double? longitude,
    String? phone,
    String? email,
    List<String>? services,
    Map<String, String>? openingHours,
    double? consultationFee,
    String? specialization,
    String? bio,
    String? ownerId,
    VetDiscount? discount,
    bool? isAvailable,
    List<VetScheduleSlot>? scheduleSlots,
    String? openingDaysText,
  }) {
    return VetModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      location: location ?? this.location,
      distance: distance ?? this.distance,
      images: images ?? this.images,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
      patients: patients ?? this.patients,
      yearsExperience: yearsExperience ?? this.yearsExperience,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      services: services ?? this.services,
      openingHours: openingHours ?? this.openingHours,
      consultationFee: consultationFee ?? this.consultationFee,
      specialization: specialization ?? this.specialization,
      bio: bio ?? this.bio,
      ownerId: ownerId ?? this.ownerId,
      discount: discount ?? this.discount,
      isAvailable: isAvailable ?? this.isAvailable,
      scheduleSlots: scheduleSlots ?? this.scheduleSlots,
      openingDaysText: openingDaysText ?? this.openingDaysText,
    );
  }

  /// Convert to map for navigation arguments
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'location': location,
      'distance': distance,
      'images': images,
      'description': description,
      'rating': rating,
      'reviews': reviews,
      'patients': patients,
      'yearsExperience': yearsExperience,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'email': email,
      'services': services,
      'openingHours': openingHours,
      'consultationFee': consultationFee,
      'specialization': specialization,
      'bio': bio,
      'ownerId': ownerId,
      'discount': discount?.toJson(),
    };
  }

  /// Create from map
  factory VetModel.fromMap(Map<String, dynamic> map) {
    List<String> imagesList = [];

    // Handle both 'images' array and single 'image' field
    if (map['images'] != null && map['images'] is List) {
      imagesList = List<String>.from(map['images']);
    } else if (map['image'] != null) {
      imagesList = [map['image'].toString()];
    }

    return VetModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      location: map['location'] ?? '',
      distance: map['distance'] ?? '',
      images: imagesList.isNotEmpty
          ? imagesList
          : const ['assets/images/pet_hospital.jpg'],
      description: map['description'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      reviews: map['reviews'] ?? 0,
      patients: map['patients'] ?? 0,
      yearsExperience: map['yearsExperience'] ?? 0,
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      phone: map['phone'],
      email: map['email'],
      services: List<String>.from(map['services'] ?? []),
      openingHours: Map<String, String>.from(map['openingHours'] ?? {}),
      consultationFee: map['consultationFee']?.toDouble(),
      specialization: map['specialization'],
      bio: map['bio'],
      ownerId: map['ownerId'],
      discount: map['discount'] != null
          ? VetDiscount.fromJson(map['discount'])
          : null,
    );
  }

  /// Create from JSON (API response)
  factory VetModel.fromJson(Map<String, dynamic> json) {
    // Debug: Print the raw JSON to see what the API is sending

    // Handle location object or string
    String locationString = '';
    double? lat;
    double? lng;

    if (json['location'] != null) {
      if (json['location'] is String) {
        locationString = json['location'] as String;
      } else if (json['location'] is Map) {
        final locationMap = json['location'] as Map<String, dynamic>;
        locationString = locationMap['address']?.toString() ??
            '${locationMap['city'] ?? ''}, ${locationMap['state'] ?? ''}'
                .trim();

        // Extract coordinates from location object
        if (locationMap['coordinates'] != null) {
          final coords = locationMap['coordinates'] as Map<String, dynamic>;
          // Handle coordinates as string or number
          lat = _parseDouble(coords['lat']);
          lng = _parseDouble(coords['lng']);
        }
      }
    }

    // Handle images - support both array and single image
    List<String> imagesList = [];

    // First, handle profileImage - this is the primary display image for cards
    if (json['profileImage'] != null && json['profileImage'].toString().trim().isNotEmpty) {
      final profileImagePath = _convertImagePath(json['profileImage'].toString());
      imagesList.add(profileImagePath);
    }

    // Then, handle the images array if it exists and has items
    if (json['images'] != null && json['images'] is List) {
      final imagesArray = json['images'] as List;
      if (imagesArray.isNotEmpty) {
        final additionalImages = imagesArray
            .where((img) => img != null && img.toString().trim().isNotEmpty)
            .map((img) => _convertImagePath(img.toString()))
            .where((path) => !imagesList.contains(path)) // Avoid duplicates
            .toList();
        imagesList.addAll(additionalImages);
      }
    }

    // Fallback to other single image fields if both are empty
    if (imagesList.isEmpty) {
      final singleImage = json['image']?.toString() ??
          json['imageUrl']?.toString() ??
          json['photo']?.toString() ??
          json['picture']?.toString();
      if (singleImage != null && singleImage.isNotEmpty) {
        imagesList = [_convertImagePath(singleImage)];
      }
    }

    return VetModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ??
          json['type']?.toString() ??
          json['specialization']?.toString() ??
          '',
      location: locationString.isNotEmpty
          ? locationString
          : (json['address']?.toString() ?? ''),
      distance: json['distance']?.toString() ?? 'Calculating...',
      images: imagesList.isNotEmpty
          ? imagesList
          : const ['assets/images/pet_hospital.jpg'],
      description: json['description']?.toString() ??
          json['about']?.toString() ??
          json['bio']?.toString() ??
          '',
      rating: (json['rating'] is int)
          ? (json['rating'] as int).toDouble()
          : (json['rating'] ?? 0.0).toDouble(),
      reviews: _parseInt(json['reviews']) ??
          _parseInt(json['reviewCount']) ??
          _parseInt(json['totalReviews']) ??
          _parseInt(json['review_count']) ??
          _parseInt(json['total_reviews']) ??
          0,
      patients: _parseInt(json['patients']) ??
          _parseInt(json['patientCount']) ??
          _parseInt(json['totalPatients']) ??
          _parseInt(json['patient_count']) ??
          _parseInt(json['total_patients']) ??
          0,
      yearsExperience: _parseInt(json['yearsExperience']) ??
          _parseInt(json['experience']) ??
          _parseInt(json['years_experience']) ??
          _parseInt(json['experienceYears']) ??
          _parseInt(json['experience_years']) ??
          0,
      latitude:
          lat ?? _parseDouble(json['latitude']) ?? _parseDouble(json['lat']),
      longitude:
          lng ?? _parseDouble(json['longitude']) ?? _parseDouble(json['lng']),
      phone: json['phone']?.toString() ??
          json['phoneNumber']?.toString() ??
          json['contact']?.toString(),
      email: json['email']?.toString() ?? json['contactEmail']?.toString(),
      services: json['services'] != null
          ? (json['services'] as List)
              .map((service) {
                // Handle both string and object formats
                if (service is String) {
                  return service;
                } else if (service is Map) {
                  // Extract service title or type from object
                  return service['title']?.toString() ??
                      service['serviceType']?.toString() ??
                      service['name']?.toString() ??
                      '';
                }
                return service.toString();
              })
              .where((s) => s.isNotEmpty)
              .toList()
          : [],
      openingHours: json['openingHours'] != null
          ? Map<String, String>.from(json['openingHours'])
          : (json['hours'] != null
              ? Map<String, String>.from(json['hours'])
              : {}),
      consultationFee: (json['consultationFee'] is int)
          ? (json['consultationFee'] as int).toDouble()
          : json['consultationFee']?.toDouble(),
      specialization: json['specialization']?.toString(),
      bio: json['bio']?.toString(),
      ownerId: json['ownerId']?.toString(),
      discount: json['discount'] != null
          ? VetDiscount.fromJson(json['discount'])
          : null,
      isAvailable: json['isAvailable'] as bool?,
    );
  }

  /// Convert to JSON (for API requests)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'location': location,
      'distance': distance,
      'images': images,
      'description': description,
      'rating': rating,
      'reviews': reviews,
      'patients': patients,
      'yearsExperience': yearsExperience,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'email': email,
      'services': services,
      'openingHours': openingHours,
      'consultationFee': consultationFee,
      'specialization': specialization,
      'bio': bio,
      'ownerId': ownerId,
    };
  }

  /// Helper method to parse double from dynamic value (handles string or number)
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  /// Helper method to parse int from dynamic value (handles string or number)
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  /// Helper method to convert relative image paths to full URLs
  static String _convertImagePath(String imagePath) {
    // If already a full URL or asset path, return as is
    if (imagePath.startsWith('http://') ||
        imagePath.startsWith('https://') ||
        imagePath.startsWith('assets/')) {
      return imagePath;
    }

    // If it's a relative API path, convert to full URL
    if (imagePath.startsWith('/api/')) {
      final baseUrl = ApiConstants.apiBaseUrl;
      // Remove /api/v1 from baseUrl and the path since path already has it
      final cleanBaseUrl = baseUrl.replaceAll('/api/v1', '');
      return '$cleanBaseUrl$imagePath';
    }

    // If it starts with just /, assume it's relative to base URL
    if (imagePath.startsWith('/')) {
      return '${ApiConstants.apiBaseUrl}$imagePath';
    }

    // For paths like "users/abc.jpg" or "pets/abc.jpg" or "d5997f53104ccfa3b55e4.png"
    // Images are served from MinIO storage
    const minioBaseUrl = 'https://minio-api.aleefy-app.com/uploads';
    String cleanPath = imagePath;

    // Remove "uploads/" prefix if present (since we'll add it back)
    if (cleanPath.startsWith('uploads/')) {
      cleanPath = cleanPath.replaceFirst('uploads/', '');
    }

    // Build the URL with MinIO base URL
    return '$minioBaseUrl/$cleanPath';
  }
}
