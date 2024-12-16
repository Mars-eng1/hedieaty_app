import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FriendEventsController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all events for a specific friend and calculate status dynamically
  Stream<List<Map<String, dynamic>>> getFriendEventsStream(String friendId) {
    return _firestore
        .collection('events')
        .where('createdBy', isEqualTo: friendId) // Matches the createdBy field
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id; // Include document ID

      // Calculate status dynamically
      final eventDateStr = data['date'];
      if (eventDateStr != null) {
        final eventDate = DateTime.parse(eventDateStr);
        final today = DateTime.now();

        if (_isSameDay(eventDate, today)) {
          data['status'] = 'Current';
        } else if (eventDate.isAfter(today)) {
          data['status'] = 'Upcoming';
        } else {
          data['status'] = 'Past';
        }
      } else {
        data['status'] = 'Unknown';
      }

      return data;
    }).toList());
  }

  // Helper to check if two dates are the same day
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // Navigate to the gift list page for a specific event
  void navigateToGiftList(
      BuildContext context, String eventId, String eventName) {
    Navigator.pushNamed(
      context,
      '/friend_gift_list',
      arguments: {
        'eventId': eventId,
        'eventName': eventName,
      },
    );
  }
}
