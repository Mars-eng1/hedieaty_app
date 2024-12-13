import 'package:flutter/material.dart';

class AddFriendController {
  final TextEditingController phoneNumberController = TextEditingController();

  String? selectedCountryCode = '+1';

  final List<String> countryCodes = ['+1', '+91', '+44', '+61', '+81'];

  void updateCountryCode(String? code) {
    selectedCountryCode = code;
  }

  void addFriend(BuildContext context) {
    final phoneNumber = '$selectedCountryCode ${phoneNumberController.text.trim()}';

    if (phoneNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a phone number')),
      );
      return;
    }

    print('Friend added: $phoneNumber');
    Navigator.pop(context); // Close the screen after successful addition
  }
}
