import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import '../../models/time_slot_model.dart';
import '../../screens/vet_booking_screen.dart';

class VetBookingTimeSlots extends StatelessWidget {
  final VetBookingController controller;

  const VetBookingTimeSlots({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final textColor = isDark ? Colors.white : Colors.black;

    return Obx(() {
      if (controller.isLoadingTimeSlots.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: CircularProgressIndicator(color: AppColors.orange),
          ),
        );
      }

      if (controller.availableTimeSlots.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No available time slots for this date',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context).selectTimeSlot,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
          ),
          const SizedBox(height: 16),
          _buildTimeSlotSection(
            context,
            AppLocalizations.of(context).morning,
            controller.getAvailableTimeSlots('morning'),
            textColor,
            Icons.wb_sunny,
          ),
          const SizedBox(height: 16),
          _buildTimeSlotSection(
            context,
            AppLocalizations.of(context).afternoon,
            controller.getAvailableTimeSlots('afternoon'),
            textColor,
            Icons.wb_sunny_outlined,
          ),
          const SizedBox(height: 16),
          _buildTimeSlotSection(
            context,
            AppLocalizations.of(context).evening,
            controller.getAvailableTimeSlots('evening'),
            textColor,
            Icons.nightlight_round,
          ),
        ],
      );
    });
  }

  /// Build time slot section
  Widget _buildTimeSlotSection(
    BuildContext context,
    String title,
    List<TimeSlotModel> slots,
    Color textColor,
    IconData icon,
  ) {
    final isDark = THelperFunctions.isDarkMode(context);
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.orange, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
            ),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context).availableSlots(slots.length),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: subTextColor,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (slots.isEmpty)
          _buildNoSlotsAvailable(context, textColor)
        else
          _buildTimeSlotGrid(context, slots),
      ],
    );
  }

  /// Build no slots available message
  Widget _buildNoSlotsAvailable(BuildContext context, Color textColor) {
    final isDark = THelperFunctions.isDarkMode(context);
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.schedule_outlined,
            size: 32,
            color: subTextColor,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).noSlotsAvailable,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: subTextColor,
                ),
          ),
        ],
      ),
    );
  }

  /// Build time slot grid
  Widget _buildTimeSlotGrid(BuildContext context, List<TimeSlotModel> slots) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.5,
      ),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        return _buildTimeSlot(context, slots[index]);
      },
    );
  }

  /// Build individual time slot
  Widget _buildTimeSlot(BuildContext context, TimeSlotModel slot) {
    final isDark = THelperFunctions.isDarkMode(context);

    return Obx(() {
      final isSelected = controller.isTimeSlotSelected(slot);
      final isAvailable = slot.isBookableForDate(controller.selectedDay.value);

      return GestureDetector(
        onTap: isAvailable ? () => controller.updateTimeSlot(slot) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.orange
                : isAvailable
                    ? (isDark ? Colors.grey[800] : Colors.white)
                    : (isDark ? Colors.grey[900] : Colors.grey[100]),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppColors.orange
                  : isAvailable
                      ? (isDark ? Colors.grey[700]! : Colors.grey[300]!)
                      : (isDark ? Colors.grey[800]! : Colors.grey[200]!),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.orange.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : isDark
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                slot.displayTime,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isSelected
                          ? Colors.white
                          : isAvailable
                              ? (isDark ? Colors.white : Colors.grey[800])
                              : (isDark ? Colors.grey[600] : Colors.grey[400]),
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
              ),
              if (!isAvailable) ...[
                const SizedBox(height: 2),
                Text(
                  slot.isFull
                      ? 'Full'
                      : slot.isExpired(controller.selectedDay.value)
                          ? 'Expired'
                          : 'Unavailable',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark ? Colors.grey[600] : Colors.grey[400],
                        fontSize: 10,
                      ),
                ),
              ] else if (slot.availableSpots <= 2) ...[
                const SizedBox(height: 2),
                Text(
                  '${slot.availableSpots} left',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.orange,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }
}
