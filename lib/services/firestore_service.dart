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

  // Real-time stream of user events
  Stream<List<Map<String, dynamic>>> getUserEventsStream(String userId) {
    return _firestore
        .collection('events')
        .where('createdBy', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;

      // Parse event date and determine status
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

  //Add a Helper to Fetch Event by ID
  Future<Map<String, dynamic>> getEventById(String eventId) async {
    final docSnapshot = await _firestore.collection('events').doc(eventId).get();
    return docSnapshot.data() ?? {};
  }

// Helper function to check if two dates are the same day
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }


  // Real-time stream of friends' events
  // Stream for friend's events (already implemented correctly)
  Stream<List<Map<String, dynamic>>> getFriendsEventsStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('friends')
        .snapshots()
        .asyncMap((friendSnapshots) async {
      final List<Map<String, dynamic>> events = [];
      for (final friend in friendSnapshots.docs) {
        final friendId = friend.id;
        final friendEvents = await _firestore
            .collection('events')
            .where('createdBy', isEqualTo: friendId)
            .get();

        events.addAll(friendEvents.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }));
      }
      return events;
    });
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

  // Get gifts for a specific event (stream)
  Stream<List<Map<String, dynamic>>> getEventGiftsStream(String eventId) {
    return _firestore
        .collection('events')
        .doc(eventId)
        .collection('gifts')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;

        // Ensure all required fields exist
        data['name'] ??= 'Unnamed Gift';
        data['status'] ??= 'Available';
        data['category'] ??= 'Uncategorized';

        return data;
      }).toList();
    });
  }

  // Send a notification to a user
  Future<void> sendNotification(String userId, String title, String message) async {
    try {
      await _firestore.collection('notifications').add({
        'userId': userId,
        'title': title,
        'message': message,
        'isRead': false,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error sending notification: $e');
    }
  }

  Future<void> updateNotificationPreference(String userId, bool notifyOnUnpledge) async {
    await _firestore.collection('users').doc(userId).update({
      'notifyOnUnpledge': notifyOnUnpledge,
    });
  }

  Future<bool> getNotificationPreference(String userId) async {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    return userDoc.data()?['notifyOnUnpledge'] ?? true; // Default to true
  }


  // Add a new gift
  Future<void> addGift(String eventId, Map<String, dynamic> giftData) async {
    await _firestore.collection('events').doc(eventId).collection('gifts').add(giftData);
  }

  // Update an existing gift
  Future<void> updateGift(String eventId, String giftId, Map<String, dynamic> giftData) async {
    await _firestore.collection('events').doc(eventId).collection('gifts').doc(giftId).update(giftData);
  }

  // Delete a gift
  Future<void> deleteGift(String eventId, String giftId) async {
    await _firestore.collection('events').doc(eventId).collection('gifts').doc(giftId).delete();
  }

  // Fetch a single gift
  Future<Map<String, dynamic>?> getGift(String eventId, String giftId) async {
    final doc = await _firestore.collection('events').doc(eventId).collection('gifts').doc(giftId).get();
    return doc.exists ? doc.data() : null;
  }

}
