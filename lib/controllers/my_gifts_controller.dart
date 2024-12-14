import 'package:flutter/material.dart';

class MyGiftsController {
  final List<Map<String, dynamic>> _mockGifts = [
    {
      'id': '1',
      'name': 'Smart Watch',
      'eventName': 'John\'s Birthday',
      'status': 'Available',
    },
    {
      'id': '2',
      'name': 'Bluetooth Speaker',
      'eventName': 'Alice\'s Wedding',
      'status': 'Pledged',
    },
    {
      'id': '3',
      'name': 'Gift Card',
      'eventName': 'Graduation Party',
      'status': 'Available',
    },
    {
      'id': '4',
      'name': 'Perfume Set',
      'eventName': 'Holiday Gathering',
      'status': 'Pledged',
    },
  ];

  // Load Gifts (Mock for now)
  void loadGifts() {
    print('Loading gifts...');
  }

  // Fetch All Gifts (User's gifts from all events)
  Future<List<Map<String, dynamic>>> getAllGifts() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    return _mockGifts; // Return all gifts
  }

  // Fetch Only Pledged Gifts (From User's gifts)
  Future<List<Map<String, dynamic>>> getPledgedGifts() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    return _mockGifts.where((gift) => gift['status'] == 'Pledged').toList();
  }
}
