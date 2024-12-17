import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
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
  // Pledge a gift and notify User1
  Future<void> pledgeGift(BuildContext context, String eventId, String giftId) async {
    try {
      // Update gift status to 'Pledged'
      await _firestoreService.updateGift(eventId, giftId, {'status': 'Pledged'});

      // Fetch gift details for notification
      final gift = await _firestoreService.getGift(eventId, giftId);
      if (gift == null) return;

      // Fetch event details to notify the owner
      final event = await _firestoreService.getEventById(eventId);
      final ownerId = event['createdBy'];
      final eventName = event['name'] ?? 'an event';
      final giftName = gift['name'] ?? 'a gift';

      // Fetch current user (User2) details from Firestore
      final currentUser = FirebaseAuth.instance.currentUser;
      String pledgerName = 'A user';
      if (currentUser != null) {
        final userData = await _firestoreService.getUser(currentUser.uid);
        if (userData != null) {
          pledgerName = '${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}'.trim();
        }
      }

      // Create notification message
      final message = '$pledgerName pledged "$giftName" in "$eventName".';

      // Send notification to User1
      await _firestoreService.sendNotification(ownerId, 'Gift Pledged', message);

      // Success feedback
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
      // Update gift status to 'Available'
      await _firestoreService.updateGift(eventId, giftId, {'status': 'Available'});

      // Fetch gift details for notification
      final gift = await _firestoreService.getGift(eventId, giftId);
      if (gift == null) return;

      // Fetch event details to notify the owner
      final event = await _firestoreService.getEventById(eventId);
      final ownerId = event['createdBy'];
      final eventName = event['name'] ?? 'an event';
      final giftName = gift['name'] ?? 'a gift';

      // Check owner's notification preference for unpledge
      final notifyOnUnpledge = await _firestoreService.getNotificationPreference(ownerId);
      if (!notifyOnUnpledge) {
        print('Notification for unpledge is disabled for user: $ownerId');
        return; // Skip sending notification
      }

      // Fetch current user (User2) details from Firestore
      final currentUser = FirebaseAuth.instance.currentUser;
      String unpledgerName = 'A user';
      if (currentUser != null) {
        final userData = await _firestoreService.getUser(currentUser.uid);
        if (userData != null) {
          unpledgerName = '${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}'.trim();
        }
      }

      // Create notification message
      final message = '$unpledgerName unpledged "$giftName" in "$eventName".';

      // Send notification to User1
      await _firestoreService.sendNotification(ownerId, 'Gift Unpledged', message);

      // Success feedback
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
