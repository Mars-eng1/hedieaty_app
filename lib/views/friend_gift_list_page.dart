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
        title: Text('$eventName\'s Gifts'),
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
            return Center(child: Text('No gifts found.'));
          }

          final gifts = snapshot.data!;
          return ListView.builder(
            itemCount: gifts.length,
            itemBuilder: (context, index) {
              final gift = gifts[index];
              final isAvailable = gift['status'] == 'Available';
              final isPledged = gift['status'] == 'Pledged';

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  title: Text(gift['name']),
                  subtitle: Text(gift['category'] ?? 'No category provided'),
                  trailing: isAvailable
                      ? ElevatedButton(
                    onPressed: () =>
                        _controller.pledgeGift(context, eventId, gift['id']),
                    child: Text('Available'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  )
                      : isPledged
                      ? ElevatedButton(
                    onPressed: () => _controller.cancelPledge(
                        context, eventId, gift['id']),
                    child: Text('Cancel Pledge'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red),
                  )
                      : ElevatedButton(
                    onPressed: null,
                    child: Text('Pledged'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey),
                  ),
                  onTap: () => _controller.showGiftDetails(context, gift), // Updated popup
                ),
              );
            },
          );
        },
      ),
    );
  }
}
