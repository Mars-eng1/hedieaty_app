import 'package:flutter/material.dart';
import '../controllers/notification_controller.dart';
import 'package:overlay_support/overlay_support.dart';

class NotificationListenerWidget extends StatefulWidget {
  final Widget child;

  NotificationListenerWidget({required this.child});

  @override
  _NotificationListenerWidgetState createState() =>
      _NotificationListenerWidgetState();
}

class _NotificationListenerWidgetState
    extends State<NotificationListenerWidget> {
  final NotificationController _notificationController = NotificationController();

  @override
  void initState() {
    super.initState();
    _listenToNotifications();
  }

  void _listenToNotifications() {
    _notificationController.getNewNotificationStream().listen((notification) {
      // Display the banner for each new notification
      showBannerNotification(
        notification['title'] ?? 'New Notification',
        notification['message'] ?? 'You have a new update!',
      );
    });
  }

  void showBannerNotification(String title, String message) {
    showSimpleNotification(
      Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      subtitle: Text(message, style: TextStyle(color: Colors.white70)),
      background: Colors.pinkAccent,
      slideDismiss: true, // Allow users to dismiss the banner by swiping
      duration: Duration(seconds: 4), // Automatically dismiss after 4 seconds
    );
  }

  // void _showNotificationPopup(Map<String, dynamic> notification) {
  //   final scaffold = ScaffoldMessenger.of(context);
  //   scaffold.showSnackBar(
  //     SnackBar(
  //       content: Text(
  //         notification['message'] ?? 'New Notification',
  //         style: TextStyle(fontWeight: FontWeight.bold),
  //       ),
  //       action: SnackBarAction(
  //         label: 'View',
  //         onPressed: () {
  //           // Navigate to notification page
  //           Navigator.pushNamed(context, '/notifications');
  //         },
  //       ),
  //       duration: Duration(seconds: 4),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
