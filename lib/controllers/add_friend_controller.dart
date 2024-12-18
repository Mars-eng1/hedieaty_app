import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddFriendController {
  final TextEditingController phoneNumberController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Notify the friend being added
  Future<void> _sendNotificationToFriend(String friendId, String currentUserName) async {
    await _firestore.collection('notifications').add({
      'userId': friendId,
      'title': 'New Friend Added!',
      'message': '$currentUserName has added you as a friend.',
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
    });
  }

  Future<void> addFriend(BuildContext context) async {
    final phoneNumber = phoneNumberController.text.trim();

    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a phone number')),
      );
      return;
    }

    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .get();

      if (querySnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not found')),
        );
        return;
      }

      final friendData = querySnapshot.docs.first.data();
      final friendId = querySnapshot.docs.first.id;

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not logged in')),
        );
        return;
      }

      final currentUserId = currentUser.uid;
      final currentUserRef = _firestore.collection('users').doc(currentUserId);
      final friendRef = _firestore.collection('users').doc(friendId);

      // Fetch current user details for mutual addition
      final currentUserData = (await currentUserRef.get()).data();

      if (currentUserData == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching your details. Please try again.')),
        );
        return;
      }

      // Add friend to current user's "friends" subcollection
      await currentUserRef.collection('friends').doc(friendId).set({
        'name': friendData['firstName'] + ' ' + (friendData['lastName'] ?? ''),
        'profilePicture': friendData['profilePicture'] ?? '',
        'upcomingEvents': 0, // Placeholder, will update later
      });

      // Add current user to friend's "friends" subcollection
      await friendRef.collection('friends').doc(currentUserId).set({
        'name': currentUserData['firstName'] +
            ' ' +
            (currentUserData['lastName'] ?? ''),
        'profilePicture': currentUserData['profilePicture'] ?? '',
        'upcomingEvents': 0,
      });

      // Fetch friend's events and calculate their upcoming events count
      final friendEventsSnapshot = await _firestore
          .collection('events')
          .where('createdBy', isEqualTo: friendId)
          .get();

      int friendUpcomingEventsCount = friendEventsSnapshot.docs.where((eventDoc) {
        final eventData = eventDoc.data();
        final eventDate = DateTime.tryParse(eventData['date'] ?? '');
        return eventDate != null && eventDate.isAfter(DateTime.now());
      }).length;

      // Fetch current user's events and calculate their upcoming events count
      final currentUserEventsSnapshot = await _firestore
          .collection('events')
          .where('createdBy', isEqualTo: currentUserId)
          .get();

      int currentUserUpcomingEventsCount =
          currentUserEventsSnapshot.docs.where((eventDoc) {
            final eventData = eventDoc.data();
            final eventDate = DateTime.tryParse(eventData['date'] ?? '');
            return eventDate != null && eventDate.isAfter(DateTime.now());
          }).length;

      // Update the "upcomingEvents" count for the friend in the current user's view
      await currentUserRef.collection('friends').doc(friendId).update({
        'upcomingEvents': friendUpcomingEventsCount,
      });

      // Update the "upcomingEvents" count for the current user in the friend's view
      await friendRef.collection('friends').doc(currentUserId).update({
        'upcomingEvents': currentUserUpcomingEventsCount,
      });

      // Create a notification for the friend
      await _firestore.collection('notifications').add({
        'userId': friendId,
        'type': 'friend_added',
        'message': '${currentUserData['firstName']} added you as a friend',
        'isRead': false,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Friend added successfully!')),
      );

      Navigator.pop(context);
    } catch (e) {
      print('Error adding friend: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding friend')),
      );
    }
  }


}
