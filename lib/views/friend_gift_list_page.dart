import 'package:flutter/material.dart';
import '../controllers/friend_gift_list_controller.dart';

class FriendGiftListPage extends StatefulWidget {
  final Map<String, dynamic> arguments;

  FriendGiftListPage({required this.arguments});

  @override
  _FriendGiftListPageState createState() => _FriendGiftListPageState();
}

class _FriendGiftListPageState extends State<FriendGiftListPage> {
  final FriendGiftListController _controller = FriendGiftListController();

  @override
  Widget build(BuildContext context) {
    final eventId = widget.arguments['eventId'];
    final eventName = widget.arguments['eventName'];

    return Scaffold(
      appBar: AppBar(
        title: Text('$eventName Gifts'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _controller.getEventGiftsStream(eventId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading gifts.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No gifts associated yet.'));
          }

          final gifts = snapshot.data!;
          return ListView.builder(
            itemCount: gifts.length,
            padding: const EdgeInsets.all(16.0),
            itemBuilder: (context, index) {
              final gift = gifts[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  title: Text(gift['name']),
                  subtitle: Text(gift['description'] ?? ''),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
