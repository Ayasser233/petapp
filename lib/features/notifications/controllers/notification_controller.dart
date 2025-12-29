import 'package:get/get.dart';

class NotificationController extends GetxController {
  // Observable unread notification count
  final RxInt unreadCount = 0.obs;

  // Sample notifications data - Replace with actual data from your backend
  final RxList<NotificationItem> notifications = <NotificationItem>[
    NotificationItem(
      id: '1',
      title: 'Appointment Reminder',
      message: 'Your appointment with Dr. Ahmed is tomorrow at 10:00 AM',
      type: NotificationType.appointment,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
    ),
    NotificationItem(
      id: '2',
      title: 'Vaccination Due',
      message: 'Bella\'s rabies vaccination is due in 3 days',
      type: NotificationType.vaccination,
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: false,
    ),
    NotificationItem(
      id: '3',
      title: 'Appointment Confirmed',
      message: 'Your appointment has been confirmed for Dec 20, 2025',
      type: NotificationType.appointment,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    NotificationItem(
      id: '4',
      title: 'Points Earned',
      message: 'You earned 50 points from your recent appointment',
      type: NotificationType.points,
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
    ),
    NotificationItem(
      id: '5',
      title: 'Promotion',
      message: 'Get 20% off on your next vaccination appointment',
      type: NotificationType.promotion,
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
    ),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    _updateUnreadCount();
  }

  void _updateUnreadCount() {
    unreadCount.value = notifications.where((n) => !n.isRead).length;
  }

  void markAsRead(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      notifications[index].isRead = true;
      notifications.refresh();
      _updateUnreadCount();
    }
  }

  void markAllAsRead() {
    for (var notification in notifications) {
      notification.isRead = true;
    }
    notifications.refresh();
    _updateUnreadCount();
  }

  void deleteNotification(String id) {
    notifications.removeWhere((n) => n.id == id);
    notifications.refresh();
    _updateUnreadCount();
  }

  // Method to add new notification (for future use with FCM)
  void addNotification(NotificationItem notification) {
    notifications.insert(0, notification);
    notifications.refresh();
    _updateUnreadCount();
  }

  // Method to fetch notifications from API (for future implementation)
  Future<void> fetchNotifications() async {
    // TODO: Implement API call to fetch notifications
    // final response = await apiClient.get('/notifications');
    // notifications.value = response.data.map((n) => NotificationItem.fromJson(n)).toList();
    _updateUnreadCount();
  }
}

// Notification model
class NotificationItem {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
  });

  // Factory method to create from JSON (for API integration)
  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      type: _parseNotificationType(json['type']?.toString()),
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      isRead: json['isRead'] ?? false,
    );
  }

  static NotificationType _parseNotificationType(String? type) {
    switch (type?.toLowerCase()) {
      case 'appointment':
        return NotificationType.appointment;
      case 'vaccination':
        return NotificationType.vaccination;
      case 'points':
        return NotificationType.points;
      case 'promotion':
        return NotificationType.promotion;
      default:
        return NotificationType.general;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type.name,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
    };
  }
}

enum NotificationType {
  appointment,
  vaccination,
  points,
  promotion,
  general,
}

