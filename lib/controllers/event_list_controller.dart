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
      await _firestoreService.deleteEvent(eventId);
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
