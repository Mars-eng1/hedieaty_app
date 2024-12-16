import 'package:flutter/material.dart';
import '../controllers/gift_list_controller.dart';

class GiftListPage extends StatefulWidget {
  final Map<String, dynamic> arguments;

  GiftListPage({required this.arguments});

  @override
  _GiftListPageState createState() => _GiftListPageState();
}

class _GiftListPageState extends State<GiftListPage> {
  final GiftListController _controller = GiftListController();

  @override
  Widget build(BuildContext context) {
    final eventId = widget.arguments['eventId'];
    final eventName = widget.arguments['eventName'] ?? 'Event'; // Default title if eventName is null

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

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  title: Text(gift['name']),
                  subtitle: Text(gift['description'] ?? 'No description'),
                  trailing: isAvailable
                      ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () =>
                            _controller.editGift(context, eventId, gift['id']),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            _controller.deleteGift(context, eventId, gift['id']),
                      ),
                    ],
                  )
                      : ElevatedButton(
                    onPressed: null,
                    child: Text('Pledged'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                  ),
                  onTap: () => _controller.showGiftDetails(context, gift),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _controller.navigateToGiftDetails(context, eventId),
        label: Text('Add Gift'),
        icon: Icon(Icons.add),
        backgroundColor: Colors.pinkAccent,
      ),
    );
  }
}
