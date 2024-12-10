import 'package:firebase_database/firebase_database.dart';
import '../models/friend_model.dart';

class FirebaseService {
  static final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Fetch friends from Firebase
  static Future<List<Friend>> fetchFriends(String userId) async {
    List<Friend> friends = [];

    try {
      final snapshot = await _database.child('users/$userId/friends').get();
      if (snapshot.exists) {
        Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.value as Map);
        data.forEach((key, value) {
          friends.add(Friend.fromMap(value));
        });
      }
    } catch (e) {
      print("Error fetching friends from Firebase: $e");
    }

    return friends;
  }
}
