import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch user events
  Future<List<Map<String, dynamic>>> getUserEvents(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('events')
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Add Firestore document ID to the data
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Error fetching user events: $e');
    }
  }

  // Delete an event
  Future<void> deleteEvent(String eventId) async {
    try {
      await _firestore.collection('events').doc(eventId).delete();
    } catch (e) {
      throw Exception('Error deleting event: $e');
    }
  }

  // Add or Update an event
  Future<void> saveEvent(String eventId, Map<String, dynamic> eventData) async {
    try {
      if (eventId.isEmpty) {
        await _firestore.collection('events').add(eventData);
      } else {
        await _firestore.collection('events').doc(eventId).set(eventData);
      }
    } catch (e) {
      throw Exception('Error saving event: $e');
    }
  }

  // Fetch user data by userId
  Future<Map<String, dynamic>?> getUser(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      return userDoc.exists ? userDoc.data() : null;
    } catch (e) {
      throw Exception('Error fetching user data: $e');
    }
  }

  // Save or update user data
  Future<void> saveUser(String userId, Map<String, dynamic> userData) async {
    try {
      await _firestore.collection('users').doc(userId).set(
        userData,
        SetOptions(merge: true),
      );
    } catch (e) {
      throw Exception('Error saving user data: $e');
    }
  }

  // Fetch friends of a user
  Future<List<Map<String, dynamic>>> getFriends(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('friends')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Error fetching friends: $e');
    }
  }
}
