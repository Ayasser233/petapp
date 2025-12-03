/// Model for vet schedule slot from API
class VetScheduleSlot {
  final String id;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final bool isFull;
  final bool isActive;
  final int availableSpots;
  final bool isAvailableCurrentWeek;
  final bool isAvailableNextWeek;

  VetScheduleSlot({
    required this.id,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.isFull,
    required this.isActive,
    required this.availableSpots,
    required this.isAvailableCurrentWeek,
    required this.isAvailableNextWeek,
  });

  factory VetScheduleSlot.fromJson(Map<String, dynamic> json) {
    return VetScheduleSlot(
      id: json['id']?.toString() ?? '',
      dayOfWeek: json['dayOfWeek']?.toString() ?? '',
      startTime: json['startTime']?.toString() ?? '',
      endTime: json['endTime']?.toString() ?? '',
      isFull: json['isFull'] ?? false,
      isActive: json['isActive'] ?? false,
      availableSpots: json['availableSpots'] ?? 0,
      isAvailableCurrentWeek: json['isAvailableCurrentWeek'] ?? false,
      isAvailableNextWeek: json['isAvailableNextWeek'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dayOfWeek': dayOfWeek,
      'startTime': startTime,
      'endTime': endTime,
      'isFull': isFull,
      'isActive': isActive,
      'availableSpots': availableSpots,
      'isAvailableCurrentWeek': isAvailableCurrentWeek,
      'isAvailableNextWeek': isAvailableNextWeek,
    };
  }

  /// Check if this slot is available (active and has spots)
  bool get isAvailable => isActive && !isFull && availableSpots > 0;

  /// Get formatted time range (e.g., "6:00 - 7:00")
  String get timeRange => '$startTime - $endTime';
}

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
