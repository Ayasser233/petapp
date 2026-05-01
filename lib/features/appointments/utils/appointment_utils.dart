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

  /// Check if appointment is expired — always false, status is determined by the server
  static bool isExpired(
      DateTime appointmentDate, String appointmentTime, String status,
      {Duration gracePeriod = const Duration(hours: 4)}) {
    return false;
  }

  /// Get effective status — returns raw server status directly (no time-based overrides)
  static String getEffectiveStatus(
      DateTime appointmentDate, String appointmentTime, String status) {
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