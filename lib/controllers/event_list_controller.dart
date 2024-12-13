import 'package:flutter/material.dart';

class EventListController {
  List<Map<String, dynamic>> allEvents = [
    {
      'id': '1',
      'name': 'John\'s Birthday',
      'category': 'Birthdays',
      'status': 'Upcoming',
    },
    {
      'id': '2',
      'name': 'Alice\'s Wedding',
      'category': 'Weddings',
      'status': 'Past',
    },
    {
      'id': '3',
      'name': 'Graduation Party',
      'category': 'Graduations',
      'status': 'Current',
    },
  ];

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

  List<Map<String, dynamic>> filteredEvents = [];

  EventListController() {
    // Load all events initially
    filteredEvents = List.from(allEvents);
  }

  void loadMyEvents() {
    // Logic for loading "My Events" (currently same as allEvents for simplicity)
    filteredEvents = List.from(allEvents);
  }

  void loadOtherEvents() {
    // Logic for loading "Other Events" (mocking same data for simplicity)
    filteredEvents = List.from(allEvents);
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
    Navigator.pushNamed(context, '/event_details', arguments: {'isEditing': false});
  }

  void editEvent(BuildContext context, String eventId) {
    Navigator.pushNamed(context, '/event_details',
        arguments: {'isEditing': true, 'eventId': eventId});
  }

  void deleteEvent(BuildContext context, String eventId) {
    // Logic to delete an event (mock for now)
    print('Deleted event: $eventId');
  }

  void navigateToGiftList(BuildContext context, String eventId) {
    Navigator.pushNamed(
      context,
      '/gift_list',
      arguments: {
        'eventId': eventId,
        'isMyEvent': true, // Pass true or false based on whether it’s "My Events" or "Other Events"
      },
    );
  }

  void navigateToHome(BuildContext context){
    Navigator.pushNamed(context, '/home');
  }
}
