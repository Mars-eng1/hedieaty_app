import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class EventListController {
  final FirestoreService _firestoreService = FirestoreService();

  // Stream for "My Events"
  Stream<List<Map<String, dynamic>>> getMyEventsStream(String userId) {
    return _firestoreService.getUserEventsStream(userId);
  }

  void navigateToCreateEvent(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/event_details',
      arguments: {'isEditing': false},
    );
  }

  void editEvent(BuildContext context, String eventId) {
    Navigator.pushNamed(
      context,
      '/event_details',
      arguments: {'isEditing': true, 'eventId': eventId},
    );
  }

  Future<void> deleteEvent(BuildContext context, String eventId) async {
    try {
      final eventDoc =
      await _firestoreService.getEventById(eventId); // Fetch event details
      final createdBy = eventDoc['createdBy'];

      // Delete the event
      await _firestoreService.deleteEvent(eventId);

      // Decrement "upcomingEvents" count for the creator
      await FirebaseFirestore.instance
          .collection('users')
          .doc(createdBy)
          .update({'upcomingEvents': FieldValue.increment(-1)});

      // Decrement "upcomingEvents" count for friends
      final friendsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(createdBy)
          .collection('friends')
          .get();

      for (final friend in friendsSnapshot.docs) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(friend.id)
            .collection('friends')
            .doc(createdBy)
            .update({'upcomingEvents': FieldValue.increment(-1)});
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event deleted successfully')),
      );
    } catch (e) {
      print("Error deleting event: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete event')),
      );
    }
  }


  void navigateToGiftList(BuildContext context, String eventId) {
    Navigator.pushNamed(
      context,
      '/gift_list',
      arguments: {
        'eventId': eventId,
        'isMyEvent': true,
      },
    );
  }
}
