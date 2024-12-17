import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class GiftListController {
  final FirestoreService _firestoreService = FirestoreService();

  // Store all gifts and filtered gifts
  List<Map<String, dynamic>> allGifts = [];
  List<Map<String, dynamic>> filteredGifts = [];

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

  // Selected filter/sort options
  String? selectedCategory;
  String? selectedSort;

  // Stream of filtered/sorted gifts
  Stream<List<Map<String, dynamic>>> getFilteredGiftsStream(String eventId) async* {
    await for (final gifts in _firestoreService.getEventGiftsStream(eventId)) {
      allGifts = gifts;
      _applyFiltersAndSort();
      yield filteredGifts;
    }
  }

  // Apply sorting and filtering logic
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
      filteredGifts.sort((a, b) => a['name'].compareTo(b['name']));
    } else if (selectedSort == 'Status') {
      final statusOrder = {'Available': 0, 'Pledged': 1};
      filteredGifts.sort((a, b) =>
          (statusOrder[a['status']] ?? 2).compareTo(statusOrder[b['status']] ?? 2));
    }
    // Debugging
    print('Filtered and Sorted Gifts: $filteredGifts');

  }

  // Sort gifts by name
  void sortGiftsByName() {
    selectedSort = 'Name';
    _applyFiltersAndSort();
  }

  // Sort gifts by status
  void sortGiftsByStatus() {
    selectedSort = 'Status';
    _applyFiltersAndSort();
  }

  // Filter gifts by category
  void filterGiftsByCategory(String category) {
    selectedCategory = category;
    _applyFiltersAndSort();
  }

  // Clear all filters and sorts
  void clearFilters() {
    selectedCategory = null;
    selectedSort = null;
    _applyFiltersAndSort();
  }

  // Navigate to the Gift Details page (for creating or editing)
  void navigateToGiftDetails(BuildContext context, String eventId, {String? giftId}) {
    Navigator.pushNamed(
      context,
      '/gift_details',
      arguments: {
        'eventId': eventId,
        'isEditing': giftId != null,
        'giftId': giftId,
      },
    );
  }

  // Show gift details in a popup
  void showGiftDetails(BuildContext context, Map<String, dynamic> gift) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(gift['name']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (gift['description'] != null)
              Text('Description: ${gift['description']}'),
            if (gift['category'] != null)
              Text('Category: ${gift['category']}'),
            if (gift['price'] != null)
              Text('Price: ${gift['price']}'),
            if (gift['quantity'] != null)
              Text('Quantity: ${gift['quantity']}'),
            if (gift['priority'] != null)
              Text('Priority: ${gift['priority']}'),
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

  // Delete a gift
  Future<void> deleteGift(BuildContext context, String eventId, String giftId) async {
    try {
      await _firestoreService.deleteGift(eventId, giftId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gift deleted successfully')),
      );
    } catch (e) {
      print('Error deleting gift: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting gift')),
      );
    }
  }

  // Edit an existing gift
  void editGift(BuildContext context, String eventId, String giftId) {
    navigateToGiftDetails(context, eventId, giftId: giftId);
  }
}
