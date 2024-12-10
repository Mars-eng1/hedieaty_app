import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/local_db_service.dart';
import '../models/user_model.dart'; // <-- Import UserModel

class SignupController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signup(String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user info to SQLite
      await LocalDbService.saveUser(UserModel(
        id: userCredential.user!.uid,
        email: email,
        name: "New User",
      ));

      // Navigate to the Home Page
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
