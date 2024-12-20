import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../views/add_friend_page.dart';
import '../views/event_details_page.dart';
import '../views/event_list_page.dart';
import '../views/friend_events_page.dart';
import '../views/notification_page.dart';
import '../views/profile_page.dart';

class HomeController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream controller for filtered friends
  final StreamController<List<Map<String, dynamic>>> _filteredFriendsController =
  StreamController<List<Map<String, dynamic>>>.broadcast();

  // Getter for filtered friends stream
  Stream<List<Map<String, dynamic>>> get filteredFriendsStream =>
      _filteredFriendsController.stream;

  // Stream for unread notifications count
  Stream<int> getUnreadNotificationCountStream() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: currentUser.uid)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  // Stream to get friends in real-time
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
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  // Filter friends based on search query and emit results
  void searchFriends(List<Map<String, dynamic>> friends, String query) {
    final filteredFriends = query.isEmpty
        ? friends
        : friends
        .where((friend) =>
    friend['name']?.toLowerCase().contains(query.toLowerCase()) ??
        false)
        .toList();
    _filteredFriendsController.add(filteredFriends);
  }

  // Dispose the stream controller
  void dispose() {
    _filteredFriendsController.close();
  }

  // Navigation functions
  void navigateToNotifications(BuildContext context) {
    _navigateWithAnimation(context, NotificationPage());
  }

  void navigateToEventList(BuildContext context) {
    _navigateWithAnimation(context, EventListPage());
  }

  void navigateToCreateNewEvent(BuildContext context) {
    _navigateWithAnimation(context, EventDetailsPage(arguments: {}));
  }

  void navigateToProfile(BuildContext context) {
    _navigateWithAnimation(context, ProfilePage());
  }

  void navigateToFriendEvents(BuildContext context, String friendId, String friendName) {
    _navigateWithAnimation(
      context,
      FriendEventsPage(arguments: {'friendId': friendId, 'friendName': friendName}),
    );
  }

  void navigateToAddFriend(BuildContext context) {
    _navigateWithAnimation(context, AddFriendPage());
  }



  void _navigateWithAnimation(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0); // Slide from the right
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }



}
