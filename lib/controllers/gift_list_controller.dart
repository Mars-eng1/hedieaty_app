import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class GiftListController {
  final FirestoreService _firestoreService = FirestoreService();

  // Get gifts for a specific event (stream)
  Stream<List<Map<String, dynamic>>> getEventGiftsStream(String eventId) {
    return _firestoreService.getEventGiftsStream(eventId);
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
