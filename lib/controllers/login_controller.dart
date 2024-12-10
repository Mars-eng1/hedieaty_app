import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> login(String email, String password, BuildContext context) async {
    try {
      // Show loading indicator (this is now in the LoginPage itself, as a dialog)

      // Firebase login
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Close the loading dialog once login is done
      Navigator.of(context).pop();  // Close the loading dialog

      // Check if login is successful
      if (userCredential.user != null) {
        print("Login successful, navigating to Home page.");
        // Navigate to Home page
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        print("Login failed, user is null.");
      }
    } catch (e) {
      // Close the loading dialog if login fails
      Navigator.of(context).pop();  // Close the loading dialog

      print("Login failed: $e");
      // Show error dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Login Error"),
          content: Text("There was an error logging in: $e"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }
}
