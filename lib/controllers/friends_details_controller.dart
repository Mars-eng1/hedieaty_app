import 'package:cloud_firestore/cloud_firestore.dart';

class FriendDetailsController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream for live updates of a friend's details
  Stream<Map<String, dynamic>?> getFriendDetailsStream(String friendId) {
    return _firestore.collection('users').doc(friendId).snapshots().map((snapshot) {
      return snapshot.exists ? snapshot.data() : null;
    });
  }
}
