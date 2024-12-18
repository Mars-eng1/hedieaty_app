import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../controllers/notification_controller.dart';

class NotificationPage extends StatelessWidget {
  final NotificationController _controller = NotificationController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Icon(Icons.notifications_active_rounded,
                color: Colors.yellow, size: 24),
            const SizedBox(width: 8),
            Text(
              'Notifications',
              style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _controller.getNotificationsStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error loading notifications.'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No notifications.'));
            }

            final notifications = snapshot.data!;
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.pinkAccent[100],
                      child: Icon(Icons.notifications, color: Colors.white),
                    ),
                    title: Text(
                      notification['title'] ?? 'Notification',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(notification['message'] ?? ''),
                    trailing: Text(
                      notification['timestamp'] != null
                          ? _formatTimestamp(notification['timestamp'])
                          : '',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: PopupMenuButton<String>(
        onSelected: (value) async {
          if (value == 'markAsRead') {
            await _controller.markAllAsRead();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('All notifications marked as read!')),
            );
          } else if (value == 'clearNotifications') {
            bool confirmed = await _showConfirmationDialog(context);
            if (confirmed) {
              await _controller.clearAllNotifications();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('All notifications cleared!')),
              );
            }
          } else if (value == 'settings') {
            _controller.navigateToSettings(context);
          }
        },
        icon: Icon(Icons.settings, color: Colors.pinkAccent),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'markAsRead',
            child: ListTile(
              leading: Icon(Icons.mark_unread_chat_alt_rounded,
                  color: Colors.pinkAccent),
              title: Text('Mark All as Read'),
            ),
          ),
          PopupMenuItem(
            value: 'clearNotifications',
            child: ListTile(
              leading: Icon(Icons.delete_forever, color: Colors.redAccent),
              title: Text('Clear Notifications'),
            ),
          ),
          PopupMenuItem(
            value: 'settings',
            child: ListTile(
              leading: Icon(Icons.settings, color: Colors.pinkAccent),
              title: Text('Settings'),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Notifications'),
        content: Text('Are you sure you want to delete all notifications?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ??
        false;
  }
}
