import 'package:cloud_firestore/cloud_firestore.dart';

class FriendEventsController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all events for a specific friend
  Future<List<Map<String, dynamic>>> getFriendEvents(String friendId) async {
    try {
      final snapshot = await _firestore
          .collection('events')
          .where('ownerId', isEqualTo: friendId) // Assuming 'ownerId' references the friend
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Include document ID
        return data;
      }).toList();
    } catch (e) {
      print('Error fetching friend events: $e');
      return [];
    }
  }
}
