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
  final List<String>? services;

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
    this.services,
  });

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
      'services': services,
    };
  }
  
  factory ClinicModel.fromMap(Map<String, dynamic> map) {
    return ClinicModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      location: map['location'] ?? '',
      distance: map['distance'] ?? '',
      image: map['image'] ?? '',
      description: map['description'] ?? '',
      rating: map['rating']?.toDouble() ?? 0.0,
      reviews: map['reviews'] ?? 0,
      patients: map['patients'] ?? 0,
      yearsExperience: map['yearsExperience'] ?? 0,
    );
  }
}