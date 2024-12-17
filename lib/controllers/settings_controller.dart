import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsController {
  final FirestoreService _firestoreService = FirestoreService();

  // Store the notification preference
  bool notifyOnUnpledge = true;

  // Fetch current preference from Firestore
  Future<void> loadNotificationPreference() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      notifyOnUnpledge = await _firestoreService.getNotificationPreference(userId);
    }
  }

  // Update preference in Firestore
  Future<void> updateNotificationPreference(bool value) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await _firestoreService.updateNotificationPreference(userId, value);
      notifyOnUnpledge = value;
    }
  }
}
