import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get unread notifications count for the current user
  Future<int> getUnreadNotificationCount() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return 0;

      final snapshot = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: currentUser.uid)
          .where('isRead', isEqualTo: false)
          .get();

      return snapshot.size;
    } catch (e) {
      print('Error fetching unread notifications: $e');
      return 0;
    }
  }

  // Fetch all friends
  Future<List<Map<String, dynamic>>> getFriends() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return [];

    final snapshot = await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('friends')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  // Search friends
  Future<List<Map<String, dynamic>>> searchFriends(String query) async {
    final friends = await getFriends();
    if (query.isEmpty) return friends;

    return friends
        .where((friend) =>
    friend['name']?.toLowerCase().contains(query.toLowerCase()) ?? false)
        .toList();
  }

  void navigateToNotifications(BuildContext context) {
    Navigator.pushNamed(context, '/notifications');
  }

  void navigateToEventList(BuildContext context) {
    Navigator.pushNamed(context, '/event_list');
  }

  void navigateToCreateNewEvent(BuildContext context) {
    Navigator.pushNamed(context, '/event_details');
  }

  void navigateToProfile(BuildContext context) {
    Navigator.pushNamed(context, '/profile');
  }

  void navigateToFriendEvents(
      BuildContext context, String friendId, String friendName) {
    Navigator.pushNamed(
      context,
      '/friend_events',
      arguments: {
        'friendId': friendId,
        'friendName': friendName,
      },
    );
  }

  void navigateToAddFriend(BuildContext context) {
    Navigator.pushNamed(context, '/add_friend');
  }
}
