import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:petapp/features/notifications/controllers/notification_controller.dart';
import 'package:petapp/core/localization/app_localizations.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = Get.find<NotificationController>();
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.grey[50],
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white : Colors.black87,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          localizations.notificationsTitle,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Obx(() {
            if (controller.unreadCount.value > 0) {
              return TextButton(
                onPressed: () => controller.markAllAsRead(),
                child: Text(
                  localizations.markAllAsRead,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDark ? Colors.white70 : Colors.black54,
                        decoration: TextDecoration.underline,
                      ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(() {
        if (controller.notifications.isEmpty) {
          return _buildEmptyState(isDark, localizations);
        }

        return Column(
          children: [
            if (controller.unreadCount.value > 0)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                color: isDark ? AppColors.lightblack : Colors.white,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${controller.unreadCount.value} ${localizations.notificationNew}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.orange,
                              fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: controller.notifications.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final notification = controller.notifications[index];
                  return _buildNotificationCard(
                    notification,
                    isDark,
                    controller,
                    context,
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildEmptyState(bool isDark, AppLocalizations localizations) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            localizations.noNotificationsYet,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            localizations.weWillNotifyYou,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(
    NotificationItem notification,
    bool isDark,
    NotificationController controller,
    BuildContext context,
  ) {
    final localizations = AppLocalizations.of(context);

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        controller.deleteNotification(notification.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.notificationDeleted),
            backgroundColor: AppColors.orange,
            duration: const Duration(seconds: 2),
          ),
        );
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: 28,
        ),
      ),
      child: InkWell(
        onTap: () {
          controller.markAsRead(notification.id);
          // Handle notification tap - navigate to relevant screen
          _handleNotificationTap(notification);
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: notification.isRead
                ? (isDark ? AppColors.lightblack : Colors.white)
                : (isDark
                    ? AppColors.lightblack.withValues(alpha: 0.8)
                    : AppColors.orange.withValues(alpha: 0.05)),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: notification.isRead
                  ? Colors.transparent
                  : AppColors.orange.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.transparent
                    : Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notification icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getNotificationColor(notification.type)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getNotificationIcon(notification.type),
                  color: _getNotificationColor(notification.type),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              // Notification content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: notification.isRead
                                  ? FontWeight.w600
                                  : FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.orange,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notification.message,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white70 : Colors.black54,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatTimestamp(notification.timestamp, context),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.appointment:
        return Icons.calendar_today_rounded;
      case NotificationType.vaccination:
        return Icons.vaccines_rounded;
      case NotificationType.points:
        return Icons.stars_rounded;
      case NotificationType.promotion:
        return Icons.local_offer_rounded;
      case NotificationType.general:
        return Icons.notifications_rounded;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.appointment:
        return AppColors.orange;
      case NotificationType.vaccination:
        return Colors.blue;
      case NotificationType.points:
        return Colors.amber;
      case NotificationType.promotion:
        return Colors.green;
      case NotificationType.general:
        return Colors.grey;
    }
  }

  String _formatTimestamp(DateTime timestamp, BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return localizations.justNow;
    } else if (difference.inMinutes < 60) {
      return localizations.minutesAgo(difference.inMinutes);
    } else if (difference.inHours < 24) {
      return localizations.hoursAgo(difference.inHours);
    } else if (difference.inDays < 7) {
      return localizations.daysAgo(difference.inDays);
    } else {
      return DateFormat('MMM dd, yyyy').format(timestamp);
    }
  }

  void _handleNotificationTap(NotificationItem notification) {
    // Navigate to relevant screen based on notification type
    switch (notification.type) {
      case NotificationType.appointment:
        Get.toNamed('/my-appointments');
        break;
      case NotificationType.vaccination:
        Get.toNamed('/vaccination');
        break;
      case NotificationType.points:
        Get.toNamed('/points');
        break;
      case NotificationType.promotion:
        // Show promotion details or navigate to promotions screen
        break;
      case NotificationType.general:
        // Handle general notification
        break;
    }
  }
}


