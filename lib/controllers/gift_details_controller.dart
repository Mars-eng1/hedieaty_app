import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class GiftDetailsController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  // Load gift details for editing
  Future<void> loadGift(String eventId, String giftId) async {
    try {
      final gift = await _firestoreService.getGift(eventId, giftId);
      if (gift != null) {
        nameController.text = gift['name'] ?? '';
        descriptionController.text = gift['description'] ?? '';
      }
    } catch (e) {
      print('Error loading gift: $e');
    }
  }

  // Save a gift (create or update)
  Future<bool> saveGift(
      BuildContext context,
      String eventId,
      bool isEditing,
      String? giftId,
      ) async {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    final giftData = {
      'name': nameController.text,
      'description': descriptionController.text,
      'status': 'Available', // Default status
    };

    try {
      if (isEditing && giftId != null) {
        await _firestoreService.updateGift(eventId, giftId, giftData);
      } else {
        await _firestoreService.addGift(eventId, giftData);
      }
      return true;
    } catch (e) {
      print('Error saving gift: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving gift')),
      );
      return false;
    }
  }
}
