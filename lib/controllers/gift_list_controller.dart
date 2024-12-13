import 'package:flutter/material.dart';

class GiftListController {
  final String eventId;
  final bool isMyEvent;

  GiftListController({required this.eventId, required this.isMyEvent});

  List<Map<String, dynamic>> allGifts = [];
  List<Map<String, dynamic>> filteredGifts = [];

  String? selectedCategory;
  String? selectedStatus;

  final List<String> categories = ['Electronics', 'Books', 'Fashion', 'Games', 'Toys', 'Other'];
  final List<String> statuses = ['Available', 'Pledged'];

  void loadGifts() {
    // Mock data for gifts
    allGifts = [
      {
        'id': '1',
        'name': 'Smartphone',
        'category': 'Electronics',
        'status': 'Available',
        'isPledged': false,
      },
      {
        'id': '2',
        'name': 'Novel',
        'category': 'Books',
        'status': 'Pledged',
        'isPledged': true,
      },
    ];
    filteredGifts = List.from(allGifts);
  }

  void filterByCategory(String category) {
    selectedCategory = category;
    _applyFilters();
  }

  void filterByStatus(String status) {
    selectedStatus = status;
    _applyFilters();
  }

  void sortGiftsByName() {
    filteredGifts.sort((a, b) => a['name'].compareTo(b['name']));
  }

  void _applyFilters() {
    filteredGifts = allGifts.where((gift) {
      final matchesCategory = selectedCategory == null || gift['category'] == selectedCategory;
      final matchesStatus = selectedStatus == null ||
          (selectedStatus == 'Available' && !gift['isPledged']) ||
          (selectedStatus == 'Pledged' && gift['isPledged']);
      return matchesCategory && matchesStatus;
    }).toList();
  }

  void navigateToCreateGift(BuildContext context) {
    Navigator.pushNamed(context, '/gift_details', arguments: {'isEditing': false, 'eventId': eventId});
  }

  void editGift(BuildContext context, String giftId) {
    Navigator.pushNamed(context, '/gift_details', arguments: {'isEditing': true, 'giftId': giftId});
  }

  void deleteGift(BuildContext context, String giftId) {
    // Logic to delete a gift
    print('Deleted gift: $giftId');
  }

  void togglePledgeStatus(Map<String, dynamic> gift) {
    gift['isPledged'] = !gift['isPledged'];
    loadGifts(); // Reload gifts to refresh the view
  }
}
