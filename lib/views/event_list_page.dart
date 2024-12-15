import 'package:flutter/material.dart';
import '../controllers/event_list_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventListPage extends StatefulWidget {
  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  final EventListController _controller = EventListController();
  bool _isMyEvents = true; // Toggle between "My Events" and "Other Events"
  String userId = ''; // ID of the logged-in user

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser!.uid; // Get the logged-in user's ID
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Event List',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.pinkAccent,
        leading: Icon(Icons.card_giftcard, color: Colors.white),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _isMyEvents = true;
              });
            },
            child: Text(
              'My Events',
              style: TextStyle(
                color: _isMyEvents ? Colors.white : Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _isMyEvents = false;
              });
            },
            child: Text(
              'Other Events',
              style: TextStyle(
                color: !_isMyEvents ? Colors.white : Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _isMyEvents
            ? _controller.getMyEventsStream(userId)
            : _controller.getOtherEventsStream(userId),
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
                  subtitle: Text('${event['category']} | ${event['status']}'),
                  trailing: _isMyEvents
                      ? Row(
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
                  )
                      : null,
                  onTap: () => _controller.navigateToGiftList(context, event['id']),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Row(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 10, 0),
            child: FloatingActionButton.extended(
              onPressed: () => _controller.navigateToHome(context),
              label: Text(
                'Home',
                style: TextStyle(color: Colors.white),
              ),
              icon: Icon(
                Icons.home_rounded,
                color: Colors.white,
              ),
              backgroundColor: Colors.pinkAccent,
              heroTag: 'homeFAB',
            ),
          ),
          if (_isMyEvents)
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 25, 0),
              child: FloatingActionButton.extended(
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
                heroTag: 'createEventFAB',
              ),
            ),
        ],
      ),
    );
  }
}
