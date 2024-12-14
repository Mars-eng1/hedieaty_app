import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> login(
      String email, String password, BuildContext context) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(child: CircularProgressIndicator());
        },
      );

      // Perform Firebase login
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Close the loading dialog
      Navigator.of(context).pop();

      // Get user ID
      String userId = userCredential.user!.uid;

      // Fetch user data from Firestore
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        throw Exception("User data not found in Firestore.");
      }

      // Navigate based on user data completeness
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      if (userData['firstName'] == null || userData['lastName'] == null) {
        // Incomplete profile - Navigate to Account Setup
        Navigator.pushReplacementNamed(context, '/account',
            arguments: {'userId': userId, 'isSetup': true});
      } else {
        // Complete profile - Navigate to Home
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      // Close loading dialog if it was open
      Navigator.of(context).pop();

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
