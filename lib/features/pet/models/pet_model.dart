class PetModel {
  final String id;
  final String name;
  final String image;
  final String type;
  final String? specificType;
  final String birthdate;
  final String? notes;
  final List<ClinicVisit>? clinicVisits;

  PetModel({
    required this.id,
    required this.name,
    required this.image,
    required this.type,
    this.specificType,
    required this.birthdate,
    this.notes,
    this.clinicVisits,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'type': type,
      'specificType': specificType,
      'birthdate': birthdate,
      'notes': notes,
      'clinicVisits': clinicVisits?.map((visit) => visit.toMap()).toList(),
    };
  }

  factory PetModel.fromMap(Map<String, dynamic> map) {
    return PetModel(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      type: map['type'],
      specificType: map['specificType'],
      birthdate: map['birthdate'],
      notes: map['notes'],
      clinicVisits: map['clinicVisits'] != null
          ? List<ClinicVisit>.from(
              map['clinicVisits']?.map((x) => ClinicVisit.fromMap(x)))
          : null,
    );
  }
}

class ClinicVisit {
  final String id;
  final String clinicName;
  final String date;
  final String reason;
  final String? diagnosis;
  final String? treatment;

  ClinicVisit({
    required this.id,
    required this.clinicName,
    required this.date,
    required this.reason,
    this.diagnosis,
    this.treatment,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clinicName': clinicName,
      'date': date,
      'reason': reason,
      'diagnosis': diagnosis,
      'treatment': treatment,
    };
  }

  factory ClinicVisit.fromMap(Map<String, dynamic> map) {
    return ClinicVisit(
      id: map['id'],
      clinicName: map['clinicName'],
      date: map['date'],
      reason: map['reason'],
      diagnosis: map['diagnosis'],
      treatment: map['treatment'],
    );
  }
}