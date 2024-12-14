import 'package:flutter/material.dart';

class NotificationController {
  // Mock notifications
  final List<Map<String, dynamic>> _notifications = [
    {
      'friendName': 'Alice Johnson',
      'giftName': 'Smart Watch',
      'eventName': 'Birthday Party',
      'time': '2 hours ago',
    },
    {
      'friendName': 'Bob Smith',
      'giftName': 'Bluetooth Speaker',
      'eventName': 'Graduation Celebration',
      'time': '1 day ago',
    },
    {
      'friendName': 'Charlie Brown',
      'giftName': 'Amazon Gift Card',
      'eventName': 'Holiday Event',
      'time': '3 days ago',
    },
  ];

  // Fetch notifications (mocking as a future for now)
  Future<List<Map<String, dynamic>>> getNotifications() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate loading
    return _notifications;
  }

  // Mark all notifications as read (Mock action for now)
  void markAllAsRead() {
    print('All notifications marked as read!');
  }
}
