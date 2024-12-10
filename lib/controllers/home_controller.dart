import 'package:flutter/material.dart';

class HomeController {
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
    Navigator.pushNamed(context, '/create_event');
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
    // This function can update a list of friends in a state management approach.
    // For now, you can implement it to filter friends list as per the search query.
    print('Searching friends with query: $query');
  }

  // Fetch Friends List
  Future<List<Map<String, dynamic>>> getFriends() async {
    // This should fetch the friends list. For now, using mock data.
    return [
      {
        'id': '1',
        'name': 'Alice Johnson',
        //'profilePicture': 'https://via.placeholder.com/150',
        'upcomingEvents': 2,
      },
      {
        'id': '2',
        'name': 'Bob Smith',
        'profilePicture': 'https://via.placeholder.com/150',
        'upcomingEvents': 0,
      },
      {
        'id': '3',
        'name': 'Charlie Brown',
        'profilePicture': 'https://via.placeholder.com/150',
        'upcomingEvents': 1,
      },
    ];
  }

  // Show Add Friend Options
  void showAddFriendOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Add via Phone Number'),
              onTap: () {
                Navigator.pop(context);
                _addFriendViaPhoneNumber(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.contacts),
              title: Text('Add from Contacts'),
              onTap: () {
                Navigator.pop(context);
                _addFriendFromContacts(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _addFriendViaPhoneNumber(BuildContext context) {
    // Logic to add a friend via phone number
    print('Add friend via phone number');
  }

  void _addFriendFromContacts(BuildContext context) {
    // Logic to add a friend from contacts
    print('Add friend from contacts');
  }
}
