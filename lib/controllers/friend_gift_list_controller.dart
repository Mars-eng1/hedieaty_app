import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class FriendGiftListController {
  final FirestoreService _firestoreService = FirestoreService();

  // Get gifts for a specific event (stream)
  Stream<List<Map<String, dynamic>>> getEventGiftsStream(String eventId) {
    return _firestoreService.getEventGiftsStream(eventId);
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

  // Show gift details in a popup
  void showGiftDetails(BuildContext context, Map<String, dynamic> gift) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(gift['name']),
        content: Text(gift['description'] ?? 'No description available'),
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
