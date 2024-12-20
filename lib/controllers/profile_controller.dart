import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';

class ProfileController {

  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Navigate to Account Screen
  void navigateToAccount(BuildContext context) async {
    try {
      final userId = _auth.currentUser!.uid;

      // Fetch user data from Firestore
      final userData = await _firestoreService.getUser(userId);

      // Navigate to the Account Page with user data
      Navigator.pushNamed(
        context,
        '/account',
        arguments: {
          'userId': userId,
          'isSetup': false, // Indicate this is an edit operation
          'userData': userData, // Pass the fetched user data
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading account information: $e')),
      );
    }
  }

  // Navigate to My Gifts Screen
  void navigateToMyGifts(BuildContext context) {
    Navigator.pushNamed(context, '/my_gifts');
  }

  // Navigate to My Events Screen
  void navigateToMyEvents(BuildContext context) {
    Navigator.pushNamed(context, '/event_list');
  }

  // Navigate to My Friends Screen
  void navigateToMyFriends(BuildContext context) {
    Navigator.pushNamed(context, '/my_friends');
  }

  // Navigate to Settings Screen
  void navigateToSettings(BuildContext context) {
    Navigator.pushNamed(context, '/settings');
  }

  // Navigate to About Screen
  void navigateToAbout(BuildContext context) {
    Navigator.pushNamed(context, '/about');
  }

  // Logout Functionality
  void logout(BuildContext context) {
    // Perform any necessary logout actions here (e.g., clear user session)
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }
}
