import 'package:cloud_firestore/cloud_firestore.dart';

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
}