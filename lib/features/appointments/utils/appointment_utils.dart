import 'package:flutter/material.dart';

class AppointmentUtils {
  static Color getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return Colors.orange; // Pending - waiting for confirmation
      case 'CONFIRMED':
        return Colors.blue; // Confirmed - appointment is set
      case 'COMPLETED':
        return Colors.green; // Completed - appointment finished
      case 'CANCELLED':
        return Colors.red; // Cancelled - appointment cancelled
      default:
        return Colors.grey;
    }
  }

  static String getStatusDisplay(String status) {
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

  static IconData getAppointmentIcon() {
    return Icons.event_available;
  }

  static String formatStatus(String status) {
    return status.toUpperCase();
  }

  static String formatCurrency(double amount) {
    return '${amount.toStringAsFixed(2)} EGP';
  }
}
