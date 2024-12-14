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
  bool _isLoading = true; // Show loading indicator while fetching data
  String userId = ''; // ID of the logged-in user

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser!.uid; // Get the logged-in user's ID
    _loadEvents(); // Load "My Events" by default
  }

  Future<void> _loadEvents() async {
    setState(() {
      _isLoading = true;
    });

    if (_isMyEvents) {
      await _controller.loadMyEvents(userId);
    } else {
      await _controller.loadOtherEvents(); // Placeholder logic for "Other Events"
    }

    setState(() {
      _isLoading = false;
    });
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
              _loadEvents(); // Reload "My Events"
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
              _loadEvents(); // Reload "Other Events"
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Loading Indicator
          : Column(
        children: [
          // Filters
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _controller.sortEventsByName();
                    });
                  },
                  child: Text(
                    'All',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                DropdownButton<String>(
                  borderRadius: BorderRadius.circular(10),
                  value: _controller.selectedCategory,
                  hint: Text('Category'),
                  items: _controller.categories
                      .map((category) => DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _controller.filterByCategory(value);
                      });
                    }
                  },
                ),
                DropdownButton<String>(
                  borderRadius: BorderRadius.circular(10),
                  value: _controller.selectedStatus,
                  hint: Text('Status'),
                  items: _controller.statuses
                      .map((status) => DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _controller.filterByStatus(value);
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          // Event List
          Expanded(
            child: _controller.filteredEvents.isEmpty
                ? Center(child: Text('No events found.'))
                : ListView.builder(
              itemCount: _controller.filteredEvents.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final event = _controller.filteredEvents[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    title: Text(event['name']),
                    subtitle: Text(
                        '${event['category']} | ${event['status']}'),
                    trailing: _isMyEvents
                        ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit,
                              color: Colors.blue[400]),
                          onPressed: () => _controller.editEvent(
                              context, event['id']),
                        ),
                        IconButton(
                          icon: Icon(
                              Icons.delete_forever_rounded,
                              color: Colors.red),
                          onPressed: () =>
                              _controller.deleteEvent(
                                  context, event['id']),
                        ),
                      ],
                    )
                        : null,
                    onTap: () => _controller.navigateToGiftList(
                        context, event['id']),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // Floating Action Buttons
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
