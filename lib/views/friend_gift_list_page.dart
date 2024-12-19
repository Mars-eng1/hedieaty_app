import 'package:firebase_auth/firebase_auth.dart';
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
  late String eventId;
  late String eventName;

  @override
  void initState() {
    super.initState();
    eventId = widget.arguments['eventId'];
    eventName = widget.arguments['eventName'] ?? 'Event';
    _controller.initializeGifts(eventId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$eventName\'s Gifts'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _controller.filteredGiftsStream,
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
                  subtitle: Text(
                      '${gift['category'] ?? 'No category'} | ${gift['status']}'),
                  trailing: isAvailable
                      ? ElevatedButton(
                          onPressed: () => _controller.pledgeGift(
                              context, eventId, gift['id']),
                          child: Text('Available'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                        )
                      : (gift['pledgedBy'] ==
                              FirebaseAuth.instance.currentUser?.uid)
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
                  onTap: () => _controller.showGiftDetails(context, gift),
                ),
              );
            },
          );
        },
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pinkAccent, Colors.deepPurpleAccent],
                ),
              ),
              child: Text(
                'Filter & Sort',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.sort_by_alpha),
              title: Text('Sort by Name'),
              onTap: () {
                _controller.sortGiftsByName();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.check_circle_outline),
              title: Text('Sort by Status'),
              onTap: () {
                _controller.sortGiftsByStatus();
                Navigator.pop(context);
              },
            ),
            ExpansionTile(
              leading: Icon(Icons.filter_list),
              title: Text('Filter by Category'),
              children: _controller.getCategories().map((category) {
                return ListTile(
                  title: Text(category),
                  onTap: () {
                    _controller.filterGiftsByCategory(category);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
            ListTile(
              leading: Icon(Icons.clear_all),
              title: Text('Clear Filters & Sorts'),
              onTap: () {
                _controller.clearFiltersAndSorts();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
