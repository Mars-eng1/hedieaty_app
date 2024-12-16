import 'package:flutter/material.dart';
import '../controllers/event_list_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventListPage extends StatefulWidget {
  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  final EventListController _controller = EventListController();
  late final String userId; // ID of the logged-in user

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser!.uid; // Get the logged-in user's ID
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Icon(Icons.card_giftcard, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              'My Events',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.pinkAccent,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _controller.getMyEventsStream(userId),
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  subtitle: Text('${event['category']} | ${event['date']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue[400]),
                        onPressed: () =>
                            _controller.editEvent(context, event['id']),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_forever_rounded,
                            color: Colors.red),
                        onPressed: () =>
                            _controller.deleteEvent(context, event['id']),
                      ),
                    ],
                  ),
                  onTap: () => _controller.navigateToGiftList(context, event['id']),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _controller.navigateToCreateEvent(context),
        label: Text(
          'Create Event',
          style: TextStyle(color: Colors.white),
        ),
        icon: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.pinkAccent,
      ),
    );
  }
}
