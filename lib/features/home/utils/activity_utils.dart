import 'package:flutter/material.dart';

class ActivityUtils {
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'upcoming':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'in_progress':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  static IconData getActivityIcon(String type) {
    switch (type.toLowerCase()) {
      case 'checkup':
        return Icons.health_and_safety;
      case 'vaccination':
        return Icons.medical_services;
      case 'grooming':
        return Icons.content_cut;
      case 'surgery':
        return Icons.local_hospital;
      default:
        return Icons.pets;
    }
  }

  static String formatStatus(String status) {
    return status.toUpperCase();
  }

  static String formatCurrency(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }
}