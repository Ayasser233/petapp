import 'package:petapp/features/pet/models/pet_model.dart';

class PetCreateModel {
  final String name;
  final String species;
  final String? customSpecies;
  final String dateOfBirth;
  final MedicalHistoryModel? medicalHistory;

  PetCreateModel({
    required this.name,
    required this.species,
    this.customSpecies,
    required this.dateOfBirth,
    this.medicalHistory,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'species': species,
      'dateOfBirth': dateOfBirth,
    };

    if (customSpecies != null) {
      data['customSpecies'] = customSpecies;
    }

    if (medicalHistory != null) {
      data['medicalHistory'] = medicalHistory!.toJson();
    }

    return data;
  }

  // Convert from PetModel to PetCreateModel
  factory PetCreateModel.fromPetModel(PetModel model) {
    // Convert the medical history if available
    MedicalHistoryModel? medicalHistory;
    if (model.medicalHistory != null) {
      final mh = model.medicalHistory!;
      medicalHistory = MedicalHistoryModel(
        vaccinations: mh.vaccinations?.map((v) => VaccinationModel(
                name: v.name,
                date: v.date,
                expiresAt: v.expiresAt
              )).toList(),
        allergies: mh.allergies,
        spayNeuterStatus: mh.spayNeuterStatus,
        lastVetVisit: mh.lastVetVisit,
        weight: mh.weight,
        notes: mh.notes,
      );
    }
    
    return PetCreateModel(
      name: model.name,
      species: model.species,
      customSpecies: model.customSpecies,
      dateOfBirth: model.dateOfBirth,
      medicalHistory: medicalHistory,
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (vaccinations != null && vaccinations!.isNotEmpty) {
      data['vaccinations'] = vaccinations!.map((v) => v.toJson()).toList();
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'date': date,
    };

    if (expiresAt != null) {
      data['expiresAt'] = expiresAt;
    }

    return data;
  }
}
