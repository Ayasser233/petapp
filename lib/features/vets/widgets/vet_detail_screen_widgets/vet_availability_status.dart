import 'package:flutter/material.dart';
import 'package:petapp/core/utils/helper_functions.dart';

class VetAvailabilityStatus extends StatelessWidget {
  final Map<String, dynamic> vet;

  const VetAvailabilityStatus({
    super.key,
    required this.vet,
  });

  bool get _isOpen {
    final openingHours = vet['openingHours'] as Map<String, dynamic>?;
    if (openingHours == null || openingHours.isEmpty) return false;

    final now = DateTime.now();
    final dayName = _getDayName(now.weekday);
    final currentHours = openingHours[dayName] as String?;

    if (currentHours == null || currentHours.isEmpty) return false;
    if (currentHours == '24 Hours') return true;
    if (currentHours == 'Closed') return false;

    try {
      final parts = currentHours.split(' - ');
      if (parts.length != 2) return false;

      final openTime = _parseTime(parts[0]);
      final closeTime = _parseTime(parts[1]);
      final currentTime = now.hour * 60 + now.minute;

      return currentTime >= openTime && currentTime <= closeTime;
    } catch (e) {
      return false;
    }
  }

  String get _statusText {
    final openingHours = vet['openingHours'] as Map<String, dynamic>?;
    if (openingHours == null || openingHours.isEmpty) {
      return 'Hours not available';
    }

    if (_isOpen) return 'Open Now';

    // Check if closed for the day
    final now = DateTime.now();
    final dayName = _getDayName(now.weekday);
    final currentHours = openingHours[dayName] as String?;

    if (currentHours == 'Closed') return 'Closed Today';

    // Find next opening time
    if (currentHours != null && currentHours.isNotEmpty) {
      try {
        final parts = currentHours.split(' - ');
        if (parts.isNotEmpty) {
          return 'Opens at ${parts[0]}';
        }
      } catch (e) {
        // Ignore
      }
    }

    return 'Closed';
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'Monday';
    }
  }

  int _parseTime(String time) {
    final cleanTime = time.trim().toUpperCase();
    final isPM = cleanTime.contains('PM');
    final timeOnly = cleanTime.replaceAll(RegExp(r'[^0-9:]'), '');
    final parts = timeOnly.split(':');

    if (parts.isEmpty) return 0;

    int hours = int.tryParse(parts[0]) ?? 0;
    final minutes = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;

    if (isPM && hours != 12) hours += 12;
    if (!isPM && hours == 12) hours = 0;

    return hours * 60 + minutes;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final textColor = isDark ? Colors.white : Colors.black;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _isOpen
            ? Colors.green.withValues(alpha: isDark ? 0.2 : 0.1)
            : Colors.red.withValues(alpha: isDark ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _isOpen
              ? Colors.green.withValues(alpha: 0.4)
              : Colors.red.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _isOpen ? Colors.green : Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _statusText,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

