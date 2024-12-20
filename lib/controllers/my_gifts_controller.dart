import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/firestore_service.dart';

class MyGiftsController {
  final FirestoreService _firestoreService = FirestoreService();

  // Stream for all gifts created by the user
  Stream<List<Map<String, dynamic>>> getAllGiftsStream(String userId) {
    return _firestoreService.getGiftsStreamForUser(userId).map((gifts) {
      return gifts.map((gift) {
        gift['eventName'] = gift['eventName'] ?? 'Unknown Event';

        // Check if the pledgedBy user still exists
        final pledgedBy = gift['pledgedBy'];
        if (pledgedBy != null) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(pledgedBy)
              .get()
              .then((doc) {
            if (!doc.exists) {
              // Reset gift if the pledger no longer exists
              FirebaseFirestore.instance
                  .collection('events')
                  .doc(gift['eventId']) // Assuming eventId is included in the gift data
                  .collection('gifts')
                  .doc(gift['id'])
                  .update({'status': 'Available', 'pledgedBy': null});
            }
          });
        }

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
