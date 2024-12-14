import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/local_db_service.dart';
import '../models/user_model.dart'; // <-- Import UserModel

class SignupController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signup(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save basic user data in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        // Other fields can remain empty for setup
        'firstName': null,
        'lastName': null,
        'dob': null,
        'gender': null,
        'phoneNumber': null,
        'country': null,
      });

      // Save user info to SQLite
      await LocalDbService.saveUser(UserModel(
        id: userCredential.user!.uid,
        email: email,
        name: "New User",
      ));

      // Navigate to the Account Setup screen
      Navigator.pushReplacementNamed(
        context,
        '/account',
        arguments: {'userId': userCredential.user!.uid, 'isSetup': true},
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signup Failed: $e')),
      );
    }
  }
}
