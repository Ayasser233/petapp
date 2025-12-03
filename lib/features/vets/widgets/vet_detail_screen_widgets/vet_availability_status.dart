import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/features/vets/models/vet_schedule_model.dart';
import 'package:petapp/features/vets/services/vet_service.dart';

class VetAvailabilityStatus extends StatefulWidget {
  final Map<String, dynamic> vet;

  const VetAvailabilityStatus({
    super.key,
    required this.vet,
  });

  @override
  State<VetAvailabilityStatus> createState() => _VetAvailabilityStatusState();
}

class _VetAvailabilityStatusState extends State<VetAvailabilityStatus> {
  List<VetScheduleSlot>? _scheduleSlots;
  bool _isLoadingSchedule = false;
  String? _dynamicOpeningStatus;
  bool? _isDynamicallyOpen;

  @override
  void initState() {
    super.initState();
    _fetchSchedule();
  }

  Future<void> _fetchSchedule() async {
    if (_isLoadingSchedule) return;

    final vetId = widget.vet['id']?.toString();
    if (vetId == null || vetId.isEmpty) {
      return;
    }

    setState(() {
      _isLoadingSchedule = true;
    });

    try {
      // Try to get VetService - it should already be registered
      VetService? vetService;

      try {
        if (Get.isRegistered<VetService>()) {
          vetService = Get.find<VetService>();
        } else {
          setState(() {
            _isLoadingSchedule = false;
          });
          return;
        }
      } catch (e) {
        setState(() {
          _isLoadingSchedule = false;
        });
        return;
      }

      final schedule = await vetService.getVetScheduleSlots(vetId);

      if (mounted) {
        setState(() {
          _scheduleSlots = schedule;
          _updateOpeningStatus();
          _isLoadingSchedule = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingSchedule = false;
        });
      }
    }
  }

  void _updateOpeningStatus() {
    if (_scheduleSlots == null || _scheduleSlots!.isEmpty) {
      _isDynamicallyOpen = null;
      _dynamicOpeningStatus = null;
      return;
    }

    final now = DateTime.now();
    final currentDayName = _getDayName(now.weekday);
    final currentTime = now.hour * 60 + now.minute;

    // Filter active slots for current week
    final activeSlots = _scheduleSlots!
        .where((slot) =>
            slot.isActive &&
            slot.isAvailableCurrentWeek &&
            !slot.isFull &&
            slot.availableSpots > 0)
        .toList();

    if (activeSlots.isEmpty) {
      _isDynamicallyOpen = false;
      _dynamicOpeningStatus = 'Closed';
      return;
    }

    // Check if open now
    final todaySlots =
        activeSlots.where((slot) => slot.dayOfWeek == currentDayName).toList();

    for (final slot in todaySlots) {
      final startMinutes = _parseScheduleTime(slot.startTime);
      final endMinutes = _parseScheduleTime(slot.endTime);

      if (currentTime >= startMinutes && currentTime <= endMinutes) {
        _isDynamicallyOpen = true;
        _dynamicOpeningStatus = 'Open Now';
        return;
      }
    }

    // If not currently open but has slots today
    if (todaySlots.isNotEmpty) {
      final upcomingSlots = todaySlots
          .where((slot) => _parseScheduleTime(slot.startTime) > currentTime)
          .toList();

      if (upcomingSlots.isNotEmpty) {
        final nextSlot = upcomingSlots.first;
        _isDynamicallyOpen = false;
        _dynamicOpeningStatus = 'Opens at ${_formatTime(nextSlot.startTime)}';
        return;
      }
    }

    // Find next available day and time
    final daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final currentDayIndex = daysOfWeek.indexOf(currentDayName);

    // Look for slots in the next 7 days
    for (int i = 1; i <= 7; i++) {
      final nextDayIndex = (currentDayIndex + i) % 7;
      final nextDayName = daysOfWeek[nextDayIndex];

      final nextDaySlots = activeSlots
          .where((slot) => slot.dayOfWeek == nextDayName)
          .toList();

      if (nextDaySlots.isNotEmpty) {
        // Sort by start time and get earliest
        nextDaySlots.sort((a, b) => _parseScheduleTime(a.startTime).compareTo(_parseScheduleTime(b.startTime)));
        final earliestSlot = nextDaySlots.first;

        _isDynamicallyOpen = false;
        if (i == 1) {
          _dynamicOpeningStatus = 'Opens tomorrow at ${_formatTime(earliestSlot.startTime)}';
        } else {
          _dynamicOpeningStatus = 'Opens on $nextDayName at ${_formatTime(earliestSlot.startTime)}';
        }
        return;
      }
    }

    _isDynamicallyOpen = false;
    _dynamicOpeningStatus = 'Closed';
  }

  String _formatTime(String time24) {
    try {
      final parts = time24.split(':');
      if (parts.length != 2) return time24;

      int hours = int.parse(parts[0]);
      final minutes = parts[1];

      if (hours == 0) {
        return '12:$minutes AM';
      } else if (hours < 12) {
        return '$hours:$minutes AM';
      } else if (hours == 12) {
        return '12:$minutes PM';
      } else {
        return '${hours - 12}:$minutes PM';
      }
    } catch (e) {
      return time24;
    }
  }

  int _parseScheduleTime(String timeStr) {
    try {
      final parts = timeStr.split(':');
      if (parts.length != 2) return 0;

      final hours = int.parse(parts[0]);
      final minutes = int.parse(parts[1]);

      return hours * 60 + minutes;
    } catch (e) {
      return 0;
    }
  }

  String _getDayName(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[weekday - 1];
  }

  bool get _isOpen {
    // Use dynamic status if available, otherwise fallback
    if (_isDynamicallyOpen != null) {
      return _isDynamicallyOpen!;
    }

    // Fallback to old logic if schedule not loaded yet
    final openingHours = widget.vet['openingHours'] as Map<String, dynamic>?;
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
    // Use dynamic status if available
    if (_dynamicOpeningStatus != null && _dynamicOpeningStatus!.isNotEmpty) {
      return _dynamicOpeningStatus!;
    }

    // Show loading state
    if (_isLoadingSchedule) {
      return 'Checking availability...';
    }

    // Fallback to old logic if schedule not loaded yet
    final openingHours = widget.vet['openingHours'] as Map<String, dynamic>?;
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
          if (_isLoadingSchedule)
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isDark ? Colors.white70 : Colors.black54,
                ),
              ),
            )
          else
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

