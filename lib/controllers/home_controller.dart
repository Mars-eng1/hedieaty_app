import 'package:flutter/material.dart';

class HomeController {
  // Mock unread notifications count
  Future<int> getUnreadNotificationCount() async {
    await Future.delayed(Duration(milliseconds: 500)); // Simulate a delay
    return 3; // Mock unread notifications
  }

  // Navigate to Notifications Screen
  void navigateToNotifications(BuildContext context) {
    Navigator.pushNamed(context, '/notifications');
  }

  // Navigate to Event List Screen
  void navigateToEventList(BuildContext context) {
    Navigator.pushNamed(context, '/event_list');
  }

  // Navigate to Create New Event Screen
  void navigateToCreateNewEvent(BuildContext context) {
    Navigator.pushNamed(context, '/event_details');
  }

  // Navigate to Profile Screen
  void navigateToProfile(BuildContext context) {
    Navigator.pushNamed(context, '/profile');
  }

  // Navigate to Friend's Events
  void navigateToFriendEvents(BuildContext context, String friendId) {
    Navigator.pushNamed(context, '/friend_events', arguments: {'friendId': friendId});
  }

  // Search Friends
  void searchFriends(String query) {
    print('Searching friends with query: $query');
  }

  // Fetch Friends List
  Future<List<Map<String, dynamic>>> getFriends() async {
    return [
      {'id': '1', 'name': 'Alice Johnson', 'upcomingEvents': 2},
      {'id': '2', 'name': 'Bob Smith', 'profilePicture': 'https://via.placeholder.com/150', 'upcomingEvents': 0},
      {'id': '3', 'name': 'Charlie Brown', 'profilePicture': 'https://via.placeholder.com/150', 'upcomingEvents': 1},
    ];
  }

  // Navigate to Add Friend Screen
  void navigateToAddFriend(BuildContext context) {
    Navigator.pushNamed(context, '/add_friend');
  }
}
