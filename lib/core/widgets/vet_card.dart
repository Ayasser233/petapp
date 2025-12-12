import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/features/vets/models/vet_model.dart';
import 'package:petapp/features/vets/models/vet_schedule_model.dart';
import 'package:petapp/features/vets/services/vet_service.dart';

/// Reusable Vet Card Component
/// Can be used in: Home Screen, Vet Explorer, Search Results, Favorites, etc.
class VetCard extends StatefulWidget {
  final String id;
  final String name;
  final String category;
  final String location;
  final String? distance;
  final String primaryImage;
  final double rating;
  final int totalReviews;
  final int yearsExperience;
  final List<String> services;
  final bool isOpen;
  final String openingStatus;
  final String? phone;
  final VoidCallback onTap;
  final VoidCallback? onCallPressed;
  final bool showDistance;
  final bool showActionButtons;
  final bool compact;
  final VetDiscount? discount;
  final bool hasEmergency;

  const VetCard({
    super.key,
    required this.id,
    required this.name,
    required this.category,
    required this.location,
    this.distance,
    required this.primaryImage,
    required this.rating,
    required this.totalReviews,
    required this.yearsExperience,
    this.services = const [],
    required this.isOpen,
    required this.openingStatus,
    this.phone,
    required this.onTap,
    this.onCallPressed,
    this.showDistance = true,
    this.showActionButtons = true,
    this.compact = false,
    this.discount,
    this.hasEmergency = false,
  });

  @override
  State<VetCard> createState() => _VetCardState();
}

class _VetCardState extends State<VetCard> {
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

      final schedule = await vetService.getVetScheduleSlots(widget.id);


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
        _dynamicOpeningStatus = 'Closed • Opens at ${_formatTime(nextSlot.startTime)}';
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
          _dynamicOpeningStatus = 'Closed • Opens tomorrow at ${_formatTime(earliestSlot.startTime)}';
        } else {
          _dynamicOpeningStatus = 'Closed • Opens on $nextDayName at ${_formatTime(earliestSlot.startTime)}';
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

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[700];
    final cardColor = isDark ? Colors.grey[850] : Colors.white;
    final chipBgColor = isDark ? Colors.grey[800] : Colors.grey[200];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: cardColor,
      shadowColor: isDark ? Colors.black : Colors.grey.withValues(alpha: 0.3),
      elevation: isDark ? 8 : 4,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVetImage(context, isDark),
            _buildVetInfo(
              context,
              isDark,
              textColor,
              subTextColor,
              chipBgColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVetImage(BuildContext context, bool isDark) {
    // Check if it's a network URL or local asset
    final isNetworkImage = widget.primaryImage.startsWith('http://') ||
        widget.primaryImage.startsWith('https://') ||
        widget.primaryImage.startsWith('www.');

    return Stack(
      children: [
        // Main Image
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: isNetworkImage
              ? Image.network(
                  widget.primaryImage,
                  width: double.infinity,
                  height: widget.compact ? 120 : 150,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: double.infinity,
                      height: widget.compact ? 120 : 150,
                      color: Colors.grey[300],
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          color: AppColors.orange,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: widget.compact ? 120 : 150,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.local_hospital,
                        size: 48,
                        color: Colors.grey,
                      ),
                    );
                  },
                )
              : Image.asset(
                  widget.primaryImage,
                  width: double.infinity,
                  height: widget.compact ? 120 : 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: widget.compact ? 120 : 150,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.local_hospital,
                        size: 48,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
        ),

        // Rating Badge (Top Right)
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 14),
                const SizedBox(width: 4),
                Text(
                  '${widget.rating} (${widget.totalReviews})',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ),

        // Category Badge (Top Left)
        Positioned(
          top: 8,
          left: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.orange,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              widget.category,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
            ),
          ),
        ),

        // Emergency Badge (Below Category Badge)
        if (widget.hasEmergency)
          Positioned(
            top: 40,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.shade600,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.emergency,
                    color: Colors.white,
                    size: 12,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    AppLocalizations.of(context).emergency,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                  ),
                ],
              ),
            ),
          ),

        // Distance Badge (Bottom Right) - Only show if enabled and available
        if (widget.showDistance && widget.distance != null && widget.distance!.isNotEmpty)
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.directions_car,
                      color: Colors.white, size: 12),
                  const SizedBox(width: 4),
                  Text(
                    widget.distance!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                        ),
                  ),
                ],
              ),
            ),
          ),

        // Discount Banner (Bottom Left) - Show if discount is active
        if (widget.discount != null && widget.discount!.isActive)
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.red.shade600,
                    Colors.red.shade400,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.local_offer,
                    color: Colors.white,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.discount!.formattedDiscount,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildVetInfo(
    BuildContext context,
    bool isDark,
    Color textColor,
    Color? subTextColor,
    Color? chipBgColor,
  ) {
    // Use dynamic status if available
    final isOpen = _isDynamicallyOpen ?? widget.isOpen;
    final openingStatus = _dynamicOpeningStatus ?? widget.openingStatus;

    return Padding(
      padding: EdgeInsets.all(widget.compact ? 12 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vet Name
          Text(
            widget.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),

          // Location and Experience
          Row(
            children: [
              const Icon(Icons.location_on, color: AppColors.orange, size: 16),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  widget.location,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: subTextColor,
                        fontSize: 13,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${widget.yearsExperience} ${AppLocalizations.of(context).yearsExp}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: subTextColor,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Opening Status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isOpen
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              openingStatus,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isOpen ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                  ),
            ),
          ),

          // Services (if not compact)
          if (!widget.compact && widget.services.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.services.take(4).map((service) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: chipBgColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    service,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: textColor,
                          fontSize: 11,
                        ),
                  ),
                );
              }).toList(),
            ),
          ],

          // Action Buttons
          if (widget.showActionButtons) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: isDark ? 8 : 2,
                    ),
                    child: Text(
                      AppLocalizations.of(context).viewDetails,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                    ),
                  ),
                ),
                if (widget.phone != null && widget.onCallPressed != null) ...[
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.orange),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: widget.onCallPressed,
                      icon: const Icon(Icons.phone, color: AppColors.orange),
                      tooltip: AppLocalizations.of(context).callVet,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
