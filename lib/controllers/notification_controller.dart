import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class NotificationController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream for unread notifications count
  Stream<int> getUnreadNotificationCountStream() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: currentUser.uid)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  // Stream for real-time notifications
  Stream<List<Map<String, dynamic>>> getNotificationsStream() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: currentUser.uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Include notification ID
        return data;
      }).toList();
    });
  }

  // Real-time stream for new notifications
  Stream<Map<String, dynamic>> getNewNotificationStream() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: currentUser.uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final latest = snapshot.docs.first;
        return {
          ...latest.data(),
          'id': latest.id,
        };
      }
      return {};
    });
  }

  // Mark all notifications as read
  Future<void> markAllAsRead() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final snapshot = await _firestore
        .collection('notifications')
        .where('userId', isEqualTo: currentUser.uid)
        .where('isRead', isEqualTo: false)
        .get();

    final batch = _firestore.batch();

    for (final doc in snapshot.docs) {
      batch.update(doc.reference, {'isRead': true});
    }

    await batch.commit();
  }

  // Clear all notifications
  Future<void> clearAllNotifications() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final snapshot = await _firestore
        .collection('notifications')
        .where('userId', isEqualTo: currentUser.uid)
        .get();

    final batch = _firestore.batch();

    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  // void showFloatingNotification(BuildContext context, String title, String message) {
  //   OverlayEntry overlayEntry = OverlayEntry(
  //     builder: (context) => FloatingNotification(title: title, message: message),
  //   );
  //
  //   // Insert the overlay
  //   Overlay.of(context).insert(overlayEntry);
  //
  //   // Automatically remove the notification after 3 seconds
  //   Future.delayed(Duration(seconds: 3), () {
  //     overlayEntry.remove();
  //   });
  // }

  void navigateToSettings(BuildContext context) {
    Navigator.pushNamed(context, '/settings');
  }
}
