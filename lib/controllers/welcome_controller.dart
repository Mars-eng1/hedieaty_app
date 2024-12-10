import 'package:flutter/material.dart';

class WelcomeController {
  void navigateToLogin(BuildContext context) {
    Navigator.pushNamed(context, '/login');
  }

  void navigateToSignUp(BuildContext context) {
    Navigator.pushNamed(context, '/signup');
  }
}
