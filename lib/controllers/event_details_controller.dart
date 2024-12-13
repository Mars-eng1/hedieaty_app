import 'package:flutter/material.dart';

class EventDetailsController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? category;
  final List<String> categories = [
    'Birthdays',
    'Weddings',
    'Engagements',
    'Graduations',
    'Holidays',
    'Other',
  ];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      dateController.text = pickedDate.toLocal().toString().split(' ')[0];
    }
  }

  bool saveEvent(BuildContext context, bool isEditing) {
    if (formKey.currentState!.validate()) {
      if (isEditing) {
        // Logic for editing an event
        print('Event updated: ${nameController.text}');
      } else {
        // Logic for creating a new event
        print('New event created: ${nameController.text}');
      }
      return true;
    }
    return false;
  }

  void loadEvent(String eventId) {
    // Mock data for editing an event
    category = 'Birthdays';
    nameController.text = 'John\'s Birthday';
    dateController.text = DateTime.now().toLocal().toString().split(' ')[0];
    descriptionController.text = 'Party at John\'s house';
  }
}
