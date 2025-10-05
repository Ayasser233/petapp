class PetModel {
  final String id;
  final String name;
  final String species;
  final String? customSpecies;
  final String dateOfBirth;
  final MedicalHistoryModel? medicalHistory;
  final String status;
  final int version;

  // Keep image for UI compatibility until backend provides images
  final String image;

  PetModel({
    required this.id,
    required this.name,
    required this.species,
    this.customSpecies,
    required this.dateOfBirth,
    this.medicalHistory,
    required this.status,
    required this.version,
    required this.image, // Temporary field for UI compatibility
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      'id': id,
      'name': name,
      'species': species.toUpperCase(), // API expects uppercase
      'dateOfBirth': dateOfBirth, // API expects camelCase
      'status': status,
      'version': version,
      'image': image, // Temporary field for UI compatibility
    };

    if (customSpecies != null) {
      data['customSpecies'] = customSpecies;
    }

    if (medicalHistory != null) {
      data['medicalHistory'] = medicalHistory!.toMap();
    }

    return data;
  }

  factory PetModel.fromMap(Map<String, dynamic> map) {
    // Determine an appropriate image based on species
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
      dateOfBirth: map['dateOfBirth'] ??
          map['date_of_birth'] ??
          '', // Handle both formats
      medicalHistory: map['medicalHistory'] != null
          ? MedicalHistoryModel.fromMap(map['medicalHistory'])
          : null,
      status: map['status'] ?? 'active',
      version: map['version'] ?? 1,
      image: imageAsset, // Temporary field for UI compatibility
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
