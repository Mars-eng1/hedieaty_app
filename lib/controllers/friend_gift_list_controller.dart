import 'dart:async';
import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class FriendGiftListController {
  final FirestoreService _firestoreService = FirestoreService();

  List<Map<String, dynamic>> allGifts = []; // Holds all gifts
  List<Map<String, dynamic>> filteredGifts = []; // Holds sorted/filtered gifts
  String? selectedCategory;
  String? selectedSort;

  // Categories for filtering
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

  // Stream Controller for filtered gifts
  final StreamController<List<Map<String, dynamic>>> _controller =
  StreamController<List<Map<String, dynamic>>>.broadcast();

  Stream<List<Map<String, dynamic>>> get filteredGiftsStream => _controller.stream;

  // Initialize gifts for the event
  void initializeGifts(String eventId) {
    _firestoreService.getEventGiftsStream(eventId).listen((gifts) {
      allGifts = gifts;
      _applyFiltersAndSort();
    });
  }

  // Apply filters and sorting logic
  void _applyFiltersAndSort() {
    filteredGifts = List.from(allGifts);

    // Apply category filter
    if (selectedCategory != null) {
      filteredGifts = filteredGifts
          .where((gift) => gift['category'] == selectedCategory)
          .toList();
    }

    // Apply sorting
    if (selectedSort == 'Name') {
      filteredGifts.sort((a, b) => (a['name'] ?? '').compareTo(b['name'] ?? ''));
    } else if (selectedSort == 'Status') {
      final statusOrder = {'Available': 0, 'Pledged': 1};
      filteredGifts.sort((a, b) =>
          (statusOrder[a['status']] ?? 2).compareTo(statusOrder[b['status']] ?? 2));
    }

    // Add filtered and sorted gifts to the stream
    _controller.add(filteredGifts);
    print('Filtered and Sorted Gifts: $filteredGifts'); // Debugging
  }

  // Sort by name
  void sortGiftsByName() {
    selectedSort = 'Name';
    _applyFiltersAndSort();
  }

  // Sort by status
  void sortGiftsByStatus() {
    selectedSort = 'Status';
    _applyFiltersAndSort();
  }

  // Filter by category
  void filterGiftsByCategory(String category) {
    selectedCategory = category;
    _applyFiltersAndSort();
  }

  // Clear all filters and sorts
  void clearFiltersAndSorts() {
    selectedCategory = null;
    selectedSort = null;
    _applyFiltersAndSort();
  }

  // Get available categories
  List<String> getCategories() {
    return categories;
  }

  // Pledge a gift
  Future<void> pledgeGift(BuildContext context, String eventId, String giftId) async {
    try {
      await _firestoreService.updateGift(eventId, giftId, {'status': 'Pledged'});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gift pledged successfully')),
      );
    } catch (e) {
      print('Error pledging gift: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error pledging gift')),
      );
    }
  }

  // Cancel a pledge
  Future<void> cancelPledge(BuildContext context, String eventId, String giftId) async {
    try {
      await _firestoreService.updateGift(eventId, giftId, {'status': 'Available'});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pledge canceled successfully')),
      );
    } catch (e) {
      print('Error canceling pledge: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error canceling pledge')),
      );
    }
  }

  // Show gift details in a popup with all the fields
  void showGiftDetails(BuildContext context, Map<String, dynamic> gift) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(gift['name']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: ${gift['category'] ?? 'No category'}'),
            Text('Description: ${gift['description'] ?? 'No description'}'),
            Text('Link: ${gift['link'] ?? 'No link provided'}'),
            Text('Price: ${gift['price'] ?? 'N/A'}'),
            Text('Quantity: ${gift['quantity'] ?? 'N/A'}'),
            Text('Priority: ${gift['priority'] ?? 'N/A'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
