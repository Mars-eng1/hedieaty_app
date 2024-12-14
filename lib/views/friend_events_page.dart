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
  late Future<List<Map<String, dynamic>>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    final friendId = widget.arguments['friendId'];
    _eventsFuture = _controller.getFriendEvents(friendId);
  }

  @override
  Widget build(BuildContext context) {
    final friendName = widget.arguments['friendName'] ?? 'Friend';

    return Scaffold(
      appBar: AppBar(
        title: Text('$friendName\'s Events'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _eventsFuture,
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
                  onTap: () {
                    // Handle tap to navigate to event details
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
