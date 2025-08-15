import 'package:geolocator/geolocator.dart';

class ClinicModel {
  final String id;
  final String name;
  final String category;
  final String location;
  final String distance;
  final String image;
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

  ClinicModel({
    required this.id,
    required this.name,
    required this.category,
    required this.location,
    required this.distance,
    required this.image,
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
  });

  /// Calculate distance from current location
  double? calculateDistanceFromCurrentLocation(double? currentLat, double? currentLon) {
    if (latitude == null || longitude == null || currentLat == null || currentLon == null) {
      return null;
    }
    
    return Geolocator.distanceBetween(currentLat, currentLon, latitude!, longitude!);
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
    
    if (currentHours == null || currentHours.isEmpty || currentHours == 'Closed') {
      return 'Closed';
    }
    
    return 'Closed • Opens ${currentHours.split(' - ')[0]}';
  }

  /// Get day name from weekday number
  String _getDayName(int weekday) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
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
  ClinicModel copyWith({
    String? id,
    String? name,
    String? category,
    String? location,
    String? distance,
    String? image,
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
  }) {
    return ClinicModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      location: location ?? this.location,
      distance: distance ?? this.distance,
      image: image ?? this.image,
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
      'image': image,
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
    };
  }

  /// Create from map
  factory ClinicModel.fromMap(Map<String, dynamic> map) {
    return ClinicModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      location: map['location'] ?? '',
      distance: map['distance'] ?? '',
      image: map['image'] ?? '',
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
    );
  }
}