import 'package:geolocator/geolocator.dart';

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
    if (isCurrentlyOpen) return 'Open Now';

    final now = DateTime.now();
    final dayName = _getDayName(now.weekday);
    final currentHours = openingHours[dayName];

    if (currentHours == null ||
        currentHours.isEmpty ||
        currentHours == 'Closed') {
      return 'Closed';
    }

    return 'Closed • Opens ${currentHours.split(' - ')[0]}';
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
    );
  }

  /// Create from JSON (API response)
  factory VetModel.fromJson(Map<String, dynamic> json) {
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
    if (json['images'] != null && json['images'] is List) {
      imagesList = List<String>.from(json['images']);
    } else {
      // Fallback to single image fields
      final singleImage = json['image']?.toString() ??
          json['imageUrl']?.toString() ??
          json['profileImage']?.toString();
      if (singleImage != null && singleImage.isNotEmpty) {
        imagesList = [singleImage];
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
      reviews:
          json['reviews'] ?? json['reviewCount'] ?? json['totalReviews'] ?? 0,
      patients: json['patients'] ??
          json['patientCount'] ??
          json['totalPatients'] ??
          0,
      yearsExperience: json['yearsExperience'] ??
          json['experience'] ??
          json['years_experience'] ??
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
}
