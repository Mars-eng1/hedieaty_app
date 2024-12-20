import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  // Helper function to check if two dates are the same day
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
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

  // Real-time stream of friends' events
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

  // Helper to Fetch Event by ID
  Future<Map<String, dynamic>> getEventById(String eventId) async {
    final docSnapshot = await _firestore.collection('events').doc(eventId).get();
    return docSnapshot.data() ?? {};
  }

  // Delete an event and its associated gifts
  Future<void> deleteEvent(String eventId) async {
    try {
      // First, delete all gifts in the event
      await deleteAllGiftsInEvent(eventId);

      // Then, delete the event itself
      await _firestore.collection('events').doc(eventId).delete();
      print('Event $eventId has been deleted.');
    } catch (e) {
      print('Error deleting event $eventId: $e');
      throw Exception('Failed to delete event.');
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

  // Fetch user data by userId
  Future<Map<String, dynamic>?> getUser(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      return userDoc.exists ? userDoc.data() : null;
    } catch (e) {
      throw Exception('Error fetching user data: $e');
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
  Future<void> addGift(String eventId, Map<String, dynamic> giftData, String createdBy) async {
    giftData['createdBy'] = createdBy; // Add the owner ID to the gift document
    await _firestore.collection('events').doc(eventId).collection('gifts').add(giftData);
  }

  // Update an existing gift
  Future<void> updateGift(String eventId, String giftId, Map<String, dynamic> giftData) async {
    await _firestore
        .collection('events')
        .doc(eventId)
        .collection('gifts')
        .doc(giftId)
        .update(giftData);
  }

  // Delete a gift
  Future<void> deleteGift(String eventId, String giftId) async {
    await _firestore.collection('events').doc(eventId).collection('gifts').doc(giftId).delete();
  }

  // Delete all gifts in an event
  Future<void> deleteAllGiftsInEvent(String eventId) async {
    try {
      final giftsCollection = _firestore.collection('events').doc(eventId).collection('gifts');
      final snapshot = await giftsCollection.get();

      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      print('All gifts in event $eventId have been deleted.');
    } catch (e) {
      print('Error deleting gifts for event $eventId: $e');
      throw Exception('Failed to delete gifts in the event.');
    }
  }

  // Fetch a single gift
  Future<Map<String, dynamic>?> getGift(String eventId, String giftId) async {
    final doc = await _firestore.collection('events').doc(eventId).collection('gifts').doc(giftId).get();
    return doc.exists ? doc.data() : null;
  }

  // Stream to fetch all gifts created by the user
  Stream<List<Map<String, dynamic>>> getGiftsStreamForUser(String userId) {
    print('FirestoreService: Fetching gifts for userId = $userId');
    return _firestore
        .collectionGroup('gifts')
        .where('createdBy', isEqualTo: userId)
        .snapshots()
        .asyncMap((snapshot) async {
      print('Firestore returned ${snapshot.docs.length} gifts.');

      // Process each gift to enrich data with eventName and pledgedBy details
      final enrichedGifts = await Future.wait(snapshot.docs.map((doc) async {
        final data = doc.data();
        data['id'] = doc.id;

        // Ensure eventName is resolved
        if (!data.containsKey('eventName') || data['eventName'] == 'Unknown Event') {
          try {
            final event = await _firestore.collection('events').doc(doc.reference.parent.parent?.id).get();
            data['eventName'] = event.data()?['name'] ?? 'Unknown Event';
          } catch (e) {
            print('Error fetching event name: $e');
            data['eventName'] = 'Unknown Event';
          }
        }

        // Ensure pledgedBy is resolved to the user's name if it exists
        if (data['pledgedBy'] != null && data['pledgedBy'] != 'N/A') {
          try {
            final userDoc = await _firestore.collection('users').doc(data['pledgedBy']).get();
            data['pledgedBy'] = '${userDoc.data()?['firstName'] ?? 'Unknown'} ${userDoc.data()?['lastName'] ?? ''}'.trim();
          } catch (e) {
            print('Error fetching pledgedBy user name: $e');
            data['pledgedBy'] = 'Unknown User';
          }
        }

        return data;
      }).toList());

      return enrichedGifts;
    });
  }

  Future<void> removeFriend(String friendId) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    final batch = _firestore.batch();

    try {
      // Remove friend relationship for both users
      final currentUserRef = _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('friends')
          .doc(friendId);

      final friendRef = _firestore
          .collection('users')
          .doc(friendId)
          .collection('friends')
          .doc(currentUserId);

      batch.delete(currentUserRef);
      batch.delete(friendRef);

      // Reset pledges for gifts the current user pledged to the friend
      await resetPledgesForUnfriendedUser(currentUserId, friendId);

      // Reset pledges for gifts the friend pledged to the current user
      await resetPledgesForUnfriendedUser(friendId, currentUserId);

      await batch.commit();
      print('Friendship and pledges successfully removed.');
    } catch (e) {
      print('Error removing friend: $e');
      throw Exception('Failed to remove friend.');
    }
  }

  Future<void> resetPledgesForUnfriendedUser(String unfriendedUserId, String currentUserId) async {
    try {
      final giftsSnapshot = await _firestore.collectionGroup('gifts')
          .where('pledgedBy', isEqualTo: unfriendedUserId)
          .get();

      final batch = _firestore.batch();

      for (var giftDoc in giftsSnapshot.docs) {
        final eventRef = giftDoc.reference.parent.parent;
        if (eventRef != null) {
          final eventOwner = (await eventRef.get()).data()?['createdBy'];

          if (eventOwner == currentUserId) {
            batch.update(giftDoc.reference, {
              'status': 'Available',
              'pledgedBy': null,
            });
          }
        }
      }

      await batch.commit();
      print('Pledges reset successfully for unfriended user $unfriendedUserId.');
    } catch (e) {
      print('Error resetting pledges: $e');
      throw Exception('Failed to reset pledges.');
    }
  }

  Future<void> resetPledgedGifts(String friendId) async {
    final giftsSnapshot = await _firestore
        .collectionGroup('gifts')
        .where('pledgedBy', isEqualTo: friendId)
        .get();

    final batch = _firestore.batch();

    for (var doc in giftsSnapshot.docs) {
      batch.update(doc.reference, {
        'status': 'Available',
        'pledgedBy': null,
      });
    }

    await batch.commit();
  }

}
