import '../services/firestore_service.dart';

class MyGiftsController {
  final FirestoreService _firestoreService = FirestoreService();

  // Stream for all gifts created by the user
  Stream<List<Map<String, dynamic>>> getAllGiftsStream(String userId) {
    return _firestoreService.getGiftsStreamForUser(userId).map((gifts) {
      // Ensure the eventName field is included
      return gifts.map((gift) {
        gift['eventName'] = gift['eventName'] ?? 'Unknown Event';
        gift['pledgedBy'] = gift['pledgedBy'] ?? 'N/A';
        return gift;
      }).toList();
    });
  }

  // Stream for pledged gifts (filtered from all gifts)
  Stream<List<Map<String, dynamic>>> getPledgedGiftsStream(String userId) {
    return _firestoreService.getGiftsStreamForUser(userId).map((gifts) {
      return gifts.where((gift) => gift['status'] == 'Pledged').toList();
    });
  }
}
