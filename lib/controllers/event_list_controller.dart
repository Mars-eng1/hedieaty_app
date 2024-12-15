import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class EventListController {
  final FirestoreService _firestoreService = FirestoreService();

  String? selectedCategory;
  String? selectedStatus;

  final List<String> categories = [
    'Birthdays',
    'Weddings',
    'Engagements',
    'Graduations',
    'Holidays',
    'Other',
  ];

  final List<String> statuses = ['Upcoming', 'Past', 'Current'];

  List<Map<String, dynamic>> allEvents = [];
  List<Map<String, dynamic>> filteredEvents = [];

  // Stream for "My Events"
  Stream<List<Map<String, dynamic>>> getMyEventsStream(String userId) {
    return _firestoreService.getUserEventsStream(userId);
  }

  // Stream for "Other Events" (events created by friends)
  Stream<List<Map<String, dynamic>>> getOtherEventsStream(String userId) {
    return _firestoreService.getFriendsEventsStream(userId);
  }

  void filterByCategory(String category) {
    selectedCategory = category;
    _applyFilters();
  }

  void filterByStatus(String status) {
    selectedStatus = status;
    _applyFilters();
  }

  void sortEventsByName() {
    filteredEvents.sort((a, b) => a['name'].compareTo(b['name']));
  }

  void _applyFilters() {
    filteredEvents = allEvents.where((event) {
      final matchesCategory =
          selectedCategory == null || event['category'] == selectedCategory;
      final matchesStatus =
          selectedStatus == null || event['status'] == selectedStatus;
      return matchesCategory && matchesStatus;
    }).toList();
  }

  void navigateToCreateEvent(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/event_details',
      arguments: {'isEditing': false},
    );
  }

  void editEvent(BuildContext context, String eventId) {
    Navigator.pushNamed(
      context,
      '/event_details',
      arguments: {'isEditing': true, 'eventId': eventId},
    );
  }

  Future<void> deleteEvent(BuildContext context, String eventId) async {
    try {
      await _firestoreService.deleteEvent(eventId);
      allEvents.removeWhere((event) => event['id'] == eventId);
      _applyFilters();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event deleted successfully')),
      );
    } catch (e) {
      print("Error deleting event: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete event')),
      );
    }
  }

  void navigateToGiftList(BuildContext context, String eventId) {
    Navigator.pushNamed(
      context,
      '/gift_list',
      arguments: {
        'eventId': eventId,
        'isMyEvent': true,
      },
    );
  }

  void navigateToHome(BuildContext context) {
    Navigator.pushNamed(context, '/home');
  }
}
