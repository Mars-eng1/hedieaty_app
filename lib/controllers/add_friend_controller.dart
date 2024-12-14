import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddFriendController {
  final TextEditingController phoneNumberController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addFriend(BuildContext context) async {
    final phoneNumber = phoneNumberController.text.trim();

    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a phone number')),
      );
      return;
    }

    try {
      // Check if the friend exists in Firestore
      final querySnapshot = await _firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .get();

      if (querySnapshot.docs.isEmpty) {
        // No user found
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not found')),
        );
        return;
      }

      // Get friend's details
      final friendData = querySnapshot.docs.first.data();
      final friendId = querySnapshot.docs.first.id;

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final currentUserRef = _firestore.collection('users').doc(currentUser.uid);

        // Add the friend's data to the "friends" subcollection
        await currentUserRef.collection('friends').doc(friendId).set({
          'name': friendData['firstName'] + ' ' + (friendData['lastName'] ?? ''),
          'profilePicture': friendData['profilePicture'] ?? '',
          'upcomingEvents': 0, // Default value if no events
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Friend added successfully!')),
        );

        Navigator.pop(context); // Close the screen
      }
    } catch (e) {
      print('Error adding friend: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding friend')),
      );
    }
  }
}
