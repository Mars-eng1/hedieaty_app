import 'package:flutter/material.dart';
import '../controllers/friend_events_controller.dart';

class FriendEventsPage extends StatefulWidget {
  final Map<String, dynamic> arguments;

  FriendEventsPage({required this.arguments});

  @override
  _FriendEventsPageState createState() => _FriendEventsPageState();
}

class _FriendEventsPageState extends State<FriendEventsPage> {
  final FriendEventsController _controller = FriendEventsController();

  @override
  Widget build(BuildContext context) {
    final friendName = widget.arguments['friendName'] ?? 'Friend';
    final friendId = widget.arguments['friendId'];

    return Scaffold(
      appBar: AppBar(
        title: Text('$friendName\'s Events'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _controller.getFriendEventsStream(friendId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading events.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No events found.'));
          }

          final events = snapshot.data!;
          return ListView.builder(
            itemCount: events.length,
            padding: const EdgeInsets.all(16.0),
            itemBuilder: (context, index) {
              final event = events[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  title: Text(event['name']),
                  subtitle: Text(
                      '${event['category']} | ${event['status']} | ${event['date']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.info_outline, color: Colors.pinkAccent),
                    onPressed: () => _showEventDescription(
                      context,
                      event['name'],
                      event['description'] ?? 'No description available.',
                    ),
                  ),
                  onTap: () => _controller.navigateToGiftList(
                      context, event['id'], event['name']),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Show event description in a modal bottom sheet
  void _showEventDescription(BuildContext context, String eventName, String description) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eventName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.pinkAccent,
                ),
              ),
              SizedBox(height: 10),
              Text(
                description,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text('Close', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

