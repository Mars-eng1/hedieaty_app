import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class GiftDetailsController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  String? category;
  String? priority;

  final List<String> categories = [
    'Electronics',
    'Books',
    'Fashion',
    'Home Appliances',
    'Toys',
    'Sports',
    'Gadgets',
    'Jewelry',
    'Gift Cards',
    'Custom Gifts',
    'Furniture',
    'Art',
    'Travel Accessories',
    'Outdoor Gear',
    'Others',
  ];

  final List<String> priorities = ['High', 'Medium', 'Low'];

  final FirestoreService _firestoreService = FirestoreService();

  Future<void> loadGift(String eventId, String giftId) async {
    try {
      final gift = await _firestoreService.getGift(eventId, giftId);
      if (gift != null) {
        nameController.text = gift['name'] ?? '';
        descriptionController.text = gift['description'] ?? '';
        linkController.text = gift['link'] ?? '';
        priceController.text = gift['price']?.toString() ?? '';
        quantityController.text = gift['quantity']?.toString() ?? '';
        category = gift['category'];
        priority = gift['priority'];
      }
    } catch (e) {
      print('Error loading gift: $e');
    }
  }

  Future<bool> saveGift(
      BuildContext context, String eventId, bool isEditing, String? giftId) async {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    final giftData = {
      'name': nameController.text,
      'description': descriptionController.text,
      'link': linkController.text,
      'price': double.tryParse(priceController.text) ?? 0,
      'quantity': int.tryParse(quantityController.text) ?? 1,
      'category': category,
      'priority': priority,
      'status': 'Available', // Default status
    };

    final currentUser = FirebaseAuth.instance.currentUser;

    try {
      if (isEditing && giftId != null) {
        await _firestoreService.updateGift(eventId, giftId, giftData);
      } else {
        await _firestoreService.addGift(eventId, giftData, currentUser!.uid);
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
