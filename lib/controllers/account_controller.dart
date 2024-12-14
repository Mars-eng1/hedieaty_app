import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountController {
  final String userId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  String? gender;
  String? country;
  final List<String> countries = ['USA', 'India', 'UK', 'Canada', 'Australia'];

  AccountController({required this.userId});

  Future<void> loadUserData() async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final data = userDoc.data()!;
        firstNameController.text = data['firstName'] ?? '';
        lastNameController.text = data['lastName'] ?? '';
        dobController.text = data['dob'] ?? '';
        gender = data['gender'];
        emailController.text = data['email'] ?? '';
        phoneNumberController.text = data['phoneNumber'] ?? '';
        country = data['country'];
      }
    } catch (e) {
      throw Exception('Failed to load user data: $e');
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      dobController.text = pickedDate.toLocal().toString().split(' ')[0];
    }
  }

  Future<void> saveUserData(BuildContext context, bool isSetup) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'dob': dobController.text,
        'gender': gender,
        'email': emailController.text,
        'phoneNumber': phoneNumberController.text,
        'country': country,
      }, SetOptions(merge: true));

      if (isSetup) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving user data: $e')),
      );
    }
  }
}
