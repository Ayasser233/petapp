class VetActivity {
  final String id;
  final String vetName;
  final String clinicName;
  final String appointmentDate;
  final String appointmentTime;
  final String serviceType;
  final String? petName;
  final String status;
  final String type;
  final String duration;
  final double fee;
  final String notes;

  VetActivity({
    required this.id,
    required this.vetName,
    required this.clinicName,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.serviceType,
    required this.petName,
    required this.status,
    required this.type,
    required this.duration,
    required this.fee,
    this.notes = '',
  });

  // Create a copy with updated fields
  VetActivity copyWith({
    String? id,
    String? vetName,
    String? clinicName,
    String? appointmentDate,
    String? appointmentTime,
    String? serviceType,
    String? petName,
    String? status,
    String? type,
    String? duration,
    double? fee,
    String? notes,
  }) {
    return VetActivity(
      id: id ?? this.id,
      vetName: vetName ?? this.vetName,
      clinicName: clinicName ?? this.clinicName,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      serviceType: serviceType ?? this.serviceType,
      petName: petName ?? this.petName,
      status: status ?? this.status,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      fee: fee ?? this.fee,
      notes: notes ?? this.notes,
    );
  }
}