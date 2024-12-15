import 'package:cloud_firestore/cloud_firestore.dart';

class FriendGiftListController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all gifts for a specific event using streams
  Stream<List<Map<String, dynamic>>> getEventGiftsStream(String eventId) {
    return _firestore
        .collection('events')
        .doc(eventId)
        .collection('gifts')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList());
  }
}
