class VetScheduleModel {
  final String id;
  final String date;
  final List<TimeSlot> availableSlots;
  final List<TimeSlot> bookedSlots;

  VetScheduleModel({
    required this.id,
    required this.date,
    required this.availableSlots,
    required this.bookedSlots,
  });

  factory VetScheduleModel.fromJson(Map<String, dynamic> json) {
    return VetScheduleModel(
      id: json['id']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      availableSlots: (json['availableSlots'] as List<dynamic>?)
              ?.map((slot) => TimeSlot.fromJson(slot as Map<String, dynamic>))
              .toList() ??
          [],
      bookedSlots: (json['bookedSlots'] as List<dynamic>?)
              ?.map((slot) => TimeSlot.fromJson(slot as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'availableSlots': availableSlots.map((slot) => slot.toJson()).toList(),
      'bookedSlots': bookedSlots.map((slot) => slot.toJson()).toList(),
    };
  }

  /// Check if a specific time slot is available
  bool isSlotAvailable(String time) {
    return availableSlots.any((slot) => slot.time == time);
  }

  /// Check if a specific time slot is booked
  bool isSlotBooked(String time) {
    return bookedSlots.any((slot) => slot.time == time);
  }

  /// Get all time slots (available + booked)
  List<TimeSlot> get allSlots {
    return [...availableSlots, ...bookedSlots];
  }
}

class TimeSlot {
  final String id;
  final String time;
  final String? startTime;
  final String? endTime;
  final bool isAvailable;

  TimeSlot({
    required this.id,
    required this.time,
    this.startTime,
    this.endTime,
    this.isAvailable = true,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      id: json['id']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      startTime: json['startTime']?.toString(),
      endTime: json['endTime']?.toString(),
      isAvailable: json['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'time': time,
      'startTime': startTime,
      'endTime': endTime,
      'isAvailable': isAvailable,
    };
  }

  /// Get formatted time range
  String get timeRange {
    if (startTime != null && endTime != null) {
      return '$startTime - $endTime';
    }
    return time;
  }
}
