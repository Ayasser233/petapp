import 'package:intl/intl.dart';
import 'package:petapp/features/appointments/domain/entities/appointment_entity.dart';

/// Extension methods for AppointmentEntity to handle presentation logic
extension AppointmentEntityExtension on AppointmentEntity {
  /// Formatted date string (e.g., "Mon, Jan 15")
  String get formattedDate {
    return DateFormat('EEE, MMM d').format(startTime);
  }

  /// Formatted date with year (e.g., "Jan 15, 2025")
  String get formattedDateWithYear {
    return DateFormat('MMM d, y').format(startTime);
  }

  /// Formatted time string (e.g., "10:00 AM")
  String get formattedTime {
    return DateFormat('h:mm a').format(startTime);
  }

  /// Formatted end time string (e.g., "11:00 AM")
  String get formattedEndTime {
    return DateFormat('h:mm a').format(endTime);
  }

  /// Get localized time range (e.g., "10:00 AM - 11:00 AM" for English or "10:00 ص - 11:00 ص" for Arabic)
  String getLocalizedTimeRange(String languageCode) {
    if (languageCode == 'ar') {
      // Arabic formatting
      final startHour = startTime.hour;
      final startMinute = startTime.minute;
      final endHour = endTime.hour;
      final endMinute = endTime.minute;

      String formatArabicTime(int hour, int minute) {
        final isPM = hour >= 12;
        final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
        final minuteStr = minute.toString().padLeft(2, '0');
        final period = isPM ? 'م' : 'ص';
        return '$displayHour:$minuteStr $period';
      }

      return '${formatArabicTime(startHour, startMinute)} - ${formatArabicTime(endHour, endMinute)}';
    } else {
      // English formatting (default)
      return '$formattedTime - $formattedEndTime';
    }
  }

  /// Get status display color
  String get statusDisplayText {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 'Pending';
      case 'CONFIRMED':
        return 'Confirmed';
      case 'COMPLETED':
        return 'Completed';
      case 'CANCELLED':
        return 'Cancelled';
      default:
        return status;
    }
  }

  /// Check if appointment can be cancelled
  bool get canBeCancelled {
    return status.toUpperCase() == 'PENDING' ||
        status.toUpperCase() == 'CONFIRMED';
  }

  /// Check if appointment can be rescheduled
  bool get canBeRescheduled {
    return status.toUpperCase() == 'PENDING' ||
        status.toUpperCase() == 'CONFIRMED';
  }

  /// Check if appointment can be reviewed
  bool get canBeReviewed {
    return status.toUpperCase() == 'COMPLETED' && rating == null;
  }

  /// Check if appointment is in the past
  bool get isPast {
    return endTime.isBefore(DateTime.now());
  }

  /// Always false — status is determined by the server, not locally by time
  bool get isExpired => false;

  /// Returns the raw API status directly (no time-based overrides)
  String get effectiveStatus => status;

  /// Get effective status display text
  String get effectiveStatusDisplayText => statusDisplayText;

  /// Check if appointment is upcoming
  bool get isUpcoming {
    return startTime.isAfter(DateTime.now());
  }

  /// Check if appointment is today
  bool get isToday {
    final now = DateTime.now();
    return startTime.year == now.year &&
        startTime.month == now.month &&
        startTime.day == now.day;
  }
}