class TimeSlotModel {
  final String id;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final bool isFull;
  final bool isActive;
  final int availableSpots;
  final bool isAvailableCurrentWeek;
  final bool isAvailableNextWeek;

  TimeSlotModel({
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

  /// Create from JSON (API response)
  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      id: json['id']?.toString() ?? '',
      dayOfWeek: json['dayOfWeek']?.toString() ?? '',
      startTime: json['startTime']?.toString() ?? '',
      endTime: json['endTime']?.toString() ?? '',
      isFull: json['isFull'] ?? false,
      isActive: json['isActive'] ?? true,
      availableSpots: json['availableSpots'] ?? 0,
      isAvailableCurrentWeek: json['isAvailableCurrentWeek'] ?? false,
      isAvailableNextWeek: json['isAvailableNextWeek'] ?? false,
    );
  }

  /// Convert to JSON
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

  /// Format time slot for display (e.g., "09:00 AM - 10:00 AM")
  String get formattedTime {
    return '${_formatTime(startTime)} - ${_formatTime(endTime)}';
  }

  /// Format time slot as simple display (e.g., "09:00 AM")
  String get displayTime {
    return _formatTime(startTime);
  }

  /// Check if slot is available based on selected week
  bool isAvailableForWeek(bool isCurrentWeek) {
    return isCurrentWeek ? isAvailableCurrentWeek : isAvailableNextWeek;
  }

  /// Check if the time slot has expired (for today's date only)
  ///
  /// A slot should not expire exactly at its start time; users may still need time
  /// to confirm/complete booking. We consider it expired only after the slot END
  /// time plus a grace period.
  bool isExpired(DateTime selectedDate, {Duration gracePeriod = const Duration(hours: 4)}) {
    // Only check expiration for today's date
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

    // If selected date is not today, slot is not expired
    if (!selected.isAtSameMomentAs(today)) {
      return false;
    }

    // Parse end time and check if it has passed + grace period
    try {
      final parts = endTime.split(':');
      if (parts.isEmpty) return false;

      final hour = int.tryParse(parts[0]) ?? 0;
      final minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;

      final slotEndDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      // Slot is expired only after end time + grace.
      return now.isAfter(slotEndDateTime.add(gracePeriod));
    } catch (e) {
      return false;
    }
  }

  /// Check if slot can be booked
  bool get isBookable {
    return isActive && !isFull && availableSpots > 0;
  }

  /// Check if slot can be booked for a specific date (includes time expiration check)
  bool isBookableForDate(DateTime selectedDate) {
    return isBookable && !isExpired(selectedDate);
  }

  /// Convert 24-hour time to 12-hour format with AM/PM
  String _formatTime(String time24) {
    try {
      // Parse hour from time string (e.g., "9:00" or "13:00")
      final parts = time24.split(':');
      if (parts.isEmpty) return time24;

      int hour = int.tryParse(parts[0]) ?? 0;
      final minute = parts.length > 1 ? parts[1] : '00';

      final period = hour >= 12 ? 'PM' : 'AM';

      // Convert to 12-hour format
      if (hour == 0) {
        hour = 12; // Midnight
      } else if (hour > 12) {
        hour = hour - 12;
      }

      // Don't pad single-digit hours with 0
      return '$hour:$minute $period';
    } catch (e) {
      return time24;
    }
  }

  /// Group time slots by time of day
  static String getTimeOfDay(String startTime) {
    try {
      final hour = int.tryParse(startTime.split(':')[0]) ?? 0;

      if (hour >= 0 && hour < 12) {
        return 'Morning';
      } else if (hour >= 12 && hour < 17) {
        return 'Afternoon';
      } else {
        return 'Evening';
      }
    } catch (e) {
      return 'Unknown';
    }
  }

  @override
  String toString() {
    return 'TimeSlotModel(id: $id, dayOfWeek: $dayOfWeek, time: $formattedTime, available: $isBookable)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimeSlotModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}