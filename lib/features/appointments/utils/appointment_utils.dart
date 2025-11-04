import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Utility functions for appointments feature
class AppointmentUtils {
  /// Get color based on appointment status
  static Color getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return Colors.orange;
      case 'CONFIRMED':
        return Colors.blue;
      case 'COMPLETED':
        return Colors.green;
      case 'CANCELLED':
        return Colors.red;
      case 'RESCHEDULED':
        return Colors.purple;
      case 'UPCOMING':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  /// Get icon for appointment
  static IconData getAppointmentIcon() {
    return Icons.calendar_today;
  }

  /// Format currency amount in Egyptian Pounds (EGP)
  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      symbol: 'EGP ',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  /// Get status badge color with opacity
  static Color getStatusBadgeColor(String status) {
    return getStatusColor(status).withValues(alpha: 0.2);
  }

  /// Get status text color
  static Color getStatusTextColor(String status) {
    return getStatusColor(status);
  }

  /// Check if appointment can be cancelled
  static bool canBeCancelled(String status) {
    return status.toUpperCase() == 'PENDING' ||
        status.toUpperCase() == 'CONFIRMED' ||
        status.toUpperCase() == 'UPCOMING';
  }

  /// Check if appointment can be rescheduled
  static bool canBeRescheduled(String status) {
    return status.toUpperCase() == 'PENDING' ||
        status.toUpperCase() == 'CONFIRMED' ||
        status.toUpperCase() == 'UPCOMING';
  }

  /// Check if appointment can be reviewed
  static bool canBeReviewed(String status) {
    return status.toUpperCase() == 'COMPLETED';
  }

  /// Check if appointment is expired and should be marked as cancelled
  static bool isExpired(
      DateTime appointmentDate, String appointmentTime, String status) {
    // Don't mark already completed or cancelled appointments as expired
    if (status.toUpperCase() == 'COMPLETED' ||
        status.toUpperCase() == 'CANCELLED') {
      return false;
    }

    try {
      // Parse time (format: "HH:mm" or "HH:mm:ss")
      final timeParts = appointmentTime.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      // Create DateTime with appointment date and time
      final appointmentDateTime = DateTime(
        appointmentDate.year,
        appointmentDate.month,
        appointmentDate.day,
        hour,
        minute,
      );

      // Check if appointment date/time is in the past
      return appointmentDateTime.isBefore(DateTime.now());
    } catch (e) {
      print('Error checking if appointment is expired: $e');
      return false;
    }
  }

  /// Get effective status (returns 'CANCELLED' if expired, otherwise original status)
  static String getEffectiveStatus(
      DateTime appointmentDate, String appointmentTime, String status) {
    if (isExpired(appointmentDate, appointmentTime, status)) {
      return 'CANCELLED';
    }
    return status;
  }

  /// Get status display text
  static String getStatusDisplayText(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 'Pending';
      case 'CONFIRMED':
        return 'Confirmed';
      case 'COMPLETED':
        return 'Completed';
      case 'CANCELLED':
        return 'Cancelled';
      case 'RESCHEDULED':
        return 'Rescheduled';
      case 'UPCOMING':
        return 'Upcoming';
      default:
        return status;
    }
  }

  /// Alias for getStatusDisplayText
  static String getStatusDisplay(String status) {
    return getStatusDisplayText(status);
  }
}
