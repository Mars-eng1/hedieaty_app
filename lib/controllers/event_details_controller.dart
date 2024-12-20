import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventDetailsController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Future<bool> saveEvent(BuildContext context, bool isEditing, {String? eventId}) async {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not authenticated!')),
      );
      return false;
    }

    try {
      // Fetch user data to get firstName and lastName
      final userDoc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();

      final userData = userDoc.data();
      final createdByName =
          "${userData?['firstName'] ?? 'Unknown'} ${userData?['lastName'] ?? 'User'}";

      // Event data
      final eventData = {
        'name': nameController.text,
        'category': category,
        'date': dateController.text,
        'description': descriptionController.text,
        'createdBy': currentUser.uid,
        'createdByName': createdByName,
        'timestamp': FieldValue.serverTimestamp(),
      };

      if (isEditing && eventId != null) {
        // Update the existing event
        await _firestore.collection('events').doc(eventId).update(eventData);
        print('Event updated: $eventId');
      } else {
        // Create a new event
        final newEventRef = await _firestore.collection('events').add(eventData);

        // Increment "upcomingEvents" count for the user
        await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .update({'upcomingEvents': FieldValue.increment(1)});

        // Notify friends about the new event
        final friendsSnapshot = await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .collection('friends')
            .get();

        for (final friend in friendsSnapshot.docs) {
          await _firestore.collection('notifications').add({
            'userId': friend.id,
            'title': 'New Event Created',
            'message':
            '$createdByName created an event: ${nameController.text}',
            'isRead': false,
            'timestamp': FieldValue.serverTimestamp(),
          });

          // Update friend's view of User1's upcoming events count
          await _firestore
              .collection('users')
              .doc(friend.id)
              .collection('friends')
              .doc(currentUser.uid)
              .update({
            'upcomingEvents': FieldValue.increment(1),
          });
        }

        print('New event created: ${newEventRef.id}');
      }
      return true;
    } catch (e) {
      print('Error saving event: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving event.')),
      );
      return false;
    }
  }


  Future<void> loadEvent(String eventId) async {
    try {
      final eventDoc = await _firestore.collection('events').doc(eventId).get();
      if (eventDoc.exists) {
        final data = eventDoc.data()!;
        category = data['category'];
        nameController.text = data['name'];
        dateController.text = data['date'];
        descriptionController.text = data['description'];
      }
    } catch (e) {
      print('Error loading event: $e');
    }
  }
}
