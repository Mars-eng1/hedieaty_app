import 'package:flutter/material.dart';

class GiftDetailsController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? category;
  String? imagePath;
  final List<String> categories = ['Electronics', 'Books', 'Fashion', 'Games', 'Toys', 'Other'];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController linkController = TextEditingController();

  Future<void> uploadImage() async {
    // Logic to upload and retrieve image URL (Mocked for now)
    imagePath = 'https://via.placeholder.com/150'; // Replace with actual logic
  }

  bool saveGift(BuildContext context, bool isEditing) {
    if (formKey.currentState!.validate()) {
      if (isEditing) {
        print('Gift updated: ${nameController.text}');
      } else {
        print('Gift created: ${nameController.text}');
      }
      return true;
    }
    return false;
  }

  void loadGift(String giftId) {
    // Mock data for loading an existing gift
    category = 'Books';
    nameController.text = 'Sample Gift';
    priceController.text = '50';
    descriptionController.text = 'This is a sample description.';
    linkController.text = 'https://example.com';
    imagePath = 'https://via.placeholder.com/150'; // Replace with actual logic
  }
}
