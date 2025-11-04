class PetModel {
  final String id;
  final String name;
  final String species;
  final String? customSpecies;
  final String? gender;
  final String dateOfBirth;
  final List<String>? allergies;
  final bool? spayNeuterStatus;
  final double? weight;
  final String? notes;
  final MedicalHistoryModel? medicalHistory;
  final String status;
  final int version;

  // Image can be from API (URL), local file path, or asset path
  final String image;
  final String? imageUrl; // Image URL from API

  PetModel({
    required this.id,
    required this.name,
    required this.species,
    this.customSpecies,
    this.gender,
    required this.dateOfBirth,
    this.allergies,
    this.spayNeuterStatus,
    this.weight,
    this.notes,
    this.medicalHistory,
    required this.status,
    required this.version,
    required this.image, // Local file path or asset path for fallback
    this.imageUrl, // Image URL from API
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      'id': id,
      'name': name,
      'species': species.substring(0, 1).toUpperCase() +
          species.substring(1).toLowerCase(), // API expects "Dog" or "Cat"
      'dateOfBirth': dateOfBirth, // API expects camelCase
      'status': status,
      'version': version,
    };

    // Include imageUrl if available from API
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      data['imageUrl'] = imageUrl;
    }

    if (customSpecies != null) {
      data['customSpecies'] = customSpecies;
    }

    if (gender != null) {
      data['gender'] = gender;
    }

    if (allergies != null && allergies!.isNotEmpty) {
      data['allergies'] = allergies;
    }

    if (spayNeuterStatus != null) {
      data['spayNeuterStatus'] = spayNeuterStatus;
    }

    if (weight != null) {
      data['weight'] = weight;
    }

    if (notes != null && notes!.isNotEmpty) {
      data['notes'] = notes;
    }

    if (medicalHistory != null) {
      data['medicalHistory'] = medicalHistory!.toMap();
    }

    return data;
  }

  factory PetModel.fromMap(Map<String, dynamic> map) {
    // Get image URL from API if available
    String? apiImageUrl = map['imageUrl'] ?? map['image_url'] ?? map['image'];

    // Determine fallback image based on species
    String imageAsset = 'assets/images/pet1.jpg'; // Default image
    if (map['species'] != null) {
      if (map['species'].toString().toLowerCase() == 'dog') {
        imageAsset = 'assets/images/dog_silhouette.png';
      } else if (map['species'].toString().toLowerCase() == 'cat') {
        imageAsset = 'assets/images/cat_silhouette.png';
      }
    }

    return PetModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      species: (map['species'] ?? '')
          .toString()
          .toLowerCase(), // Convert to lowercase for UI consistency
      customSpecies: map['customSpecies'],
      gender: map['gender'],
      dateOfBirth: map['dateOfBirth'] ??
          map['date_of_birth'] ??
          '', // Handle both formats
      allergies:
          map['allergies'] != null ? List<String>.from(map['allergies']) : null,
      spayNeuterStatus: map['spayNeuterStatus'],
      weight: map['weight'] != null
          ? double.tryParse(map['weight'].toString())
          : null,
      notes: map['notes'],
      medicalHistory: map['medicalHistory'] != null
          ? MedicalHistoryModel.fromMap(map['medicalHistory'])
          : null,
      status: map['status'] ?? 'active',
      version: map['version'] ?? 1,
      image: imageAsset, // Fallback image for UI compatibility
      imageUrl: apiImageUrl, // Image URL from API
    );
  }
}

class MedicalHistoryModel {
  final List<VaccinationModel>? vaccinations;
  final List<String>? allergies;
  final bool? spayNeuterStatus;
  final String? lastVetVisit;
  final double? weight;
  final String? notes;

  MedicalHistoryModel({
    this.vaccinations,
    this.allergies,
    this.spayNeuterStatus,
    this.lastVetVisit,
    this.weight,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};

    if (vaccinations != null && vaccinations!.isNotEmpty) {
      data['vaccinations'] = vaccinations!.map((v) => v.toMap()).toList();
    }

    if (allergies != null && allergies!.isNotEmpty) {
      data['allergies'] = allergies;
    }

    if (spayNeuterStatus != null) {
      data['spayNeuterStatus'] = spayNeuterStatus;
    }

    if (lastVetVisit != null) {
      data['lastVetVisit'] = lastVetVisit;
    }

    if (weight != null) {
      data['weight'] = weight;
    }

    if (notes != null) {
      data['notes'] = notes;
    }

    return data;
  }

  factory MedicalHistoryModel.fromMap(Map<String, dynamic> map) {
    return MedicalHistoryModel(
      vaccinations: map['vaccinations'] != null
          ? List<VaccinationModel>.from(
              map['vaccinations']?.map((x) => VaccinationModel.fromMap(x)))
          : null,
      allergies:
          map['allergies'] != null ? List<String>.from(map['allergies']) : null,
      spayNeuterStatus: map['spayNeuterStatus'],
      lastVetVisit: map['lastVetVisit'],
      weight: map['weight'] != null
          ? double.tryParse(map['weight'].toString())
          : null,
      notes: map['notes'],
    );
  }
}

class VaccinationModel {
  final String name;
  final String date;
  final String? expiresAt;

  VaccinationModel({
    required this.name,
    required this.date,
    this.expiresAt,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      'name': name,
      'date': date,
    };

    if (expiresAt != null) {
      data['expiresAt'] = expiresAt;
    }

    return data;
  }

  factory VaccinationModel.fromMap(Map<String, dynamic> map) {
    return VaccinationModel(
      name: map['name'] ?? '',
      date: map['date'] ?? '',
      expiresAt: map['expiresAt'],
    );
  }
}
