import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/features/store/models/order_model.dart';

class TrackingTimeline extends StatelessWidget {
  final List<OrderTrackingEventModel> events;

  const TrackingTimeline({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const Center(child: Text('No tracking information yet.'));
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: events.length,
      itemBuilder: (context, i) {
        final event = events[i];
        final isFirst = i == 0;
        final isLast = i == events.length - 1;
        return _TimelineItem(
          event: event,
          isFirst: isFirst,
          isLast: isLast,
          isActive: isFirst,
        );
      },
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final OrderTrackingEventModel event;
  final bool isFirst;
  final bool isLast;
  final bool isActive;

  const _TimelineItem({
    required this.event,
    required this.isFirst,
    required this.isLast,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = '';
    try {
      final dt = DateTime.parse(event.createdAt).toLocal();
      formattedDate = DateFormat('MMM d, y – h:mm a').format(dt);
    } catch (_) {
      formattedDate = event.createdAt;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline line + dot
          SizedBox(
            width: 32,
            child: Column(
              children: [
                if (!isFirst)
                  Container(width: 2, height: 16, color: Colors.grey.shade300),
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.orange : Colors.grey.shade400,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      if (isActive)
                        BoxShadow(
                          color: AppColors.orange.withValues(alpha: 0.4),
                          blurRadius: 6,
                        ),
                    ],
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(width: 2, color: Colors.grey.shade300),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.status,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isActive ? AppColors.orange : null,
                    ),
                  ),
                  if (event.description != null && event.description!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(event.description!, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                  ],
                  if (event.location != null && event.location!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.location_pin, size: 12, color: Colors.grey.shade500),
                        const SizedBox(width: 2),
                        Text(event.location!, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                      ],
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(formattedDate, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
