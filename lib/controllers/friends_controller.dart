import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';
import '../views/friends_details_page.dart';

class FriendsController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream to fetch the user's friends
  Stream<List<Map<String, dynamic>>> getFriendsStream() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('friends')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Include friend's ID
        return data;
      }).toList();
    });
  }

  // Filter friends by search query
  List<Map<String, dynamic>> filterFriends(List<Map<String, dynamic>> friends, String query) {
    if (query.isEmpty) return friends;

    return friends
        .where((friend) =>
    friend['name']?.toLowerCase().contains(query.toLowerCase()) ?? false)
        .toList();
  }

  // Navigate to a friend's details page
  void navigateToFriendDetails(BuildContext context, String friendId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FriendDetailsPage(friendId: friendId),
      ),
    );
  }

  // Navigate to Add Friend Page
  void navigateToAddFriend(BuildContext context) {
    Navigator.pushNamed(context, '/add_friend');
  }

  // Remove a friend with confirmation
  Future<void> removeFriend(BuildContext context, String friendId, String friendName) async {
    final firestoreService = FirestoreService();

    try {
      // Remove friend and reset pledges
      await firestoreService.removeFriend(friendId);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$friendName has been removed.')),
        );
      }
    } catch (e) {
      print('Error removing friend: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to remove $friendName.')),
        );
      }
    }
  }

}
