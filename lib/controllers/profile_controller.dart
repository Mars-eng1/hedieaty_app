import 'package:flutter/material.dart';

class ProfileController {
  // Navigate to Account Screen
  void navigateToAccount(BuildContext context) {
    Navigator.pushNamed(context, '/account');
  }

  // Navigate to My Gifts Screen
  void navigateToMyGifts(BuildContext context) {
    Navigator.pushNamed(context, '/my_gifts');
  }

  // Navigate to My Events Screen
  void navigateToMyEvents(BuildContext context) {
    Navigator.pushNamed(context, '/event_list');
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
