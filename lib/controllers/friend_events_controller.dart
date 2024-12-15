import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FriendEventsController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all events for a specific friend
  Stream<List<Map<String, dynamic>>> getFriendEventsStream(String friendId) {
    return _firestore
        .collection('events')
        .where('createdBy', isEqualTo: friendId) // Matches the createdBy field
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id; // Include document ID
      return data;
    }).toList());
  }

  // Navigate to the gift list page for a specific event
  void navigateToGiftList(BuildContext context, String eventId, String eventName) {
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