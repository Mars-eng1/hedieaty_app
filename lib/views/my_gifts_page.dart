import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controllers/my_gifts_controller.dart';

class MyGiftsPage extends StatefulWidget {
  @override
  _MyGiftsPageState createState() => _MyGiftsPageState();
}

class _MyGiftsPageState extends State<MyGiftsPage> {
  final MyGiftsController _controller = MyGiftsController();
  bool _showAllGifts = true; // Toggle for All Gifts or Pledged Gifts
  late String userId;
  String _searchQuery = ''; // For search functionality

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    print('Current User ID: $userId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Gifts'),
        backgroundColor: Colors.pinkAccent,
        actions: [
          TextButton(
            onPressed: () => setState(() => _showAllGifts = true),
            child: Text(
              'All Gifts',
              style: TextStyle(
                color: _showAllGifts ? Colors.white : Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () => setState(() => _showAllGifts = false),
            child: Text(
              'Pledged Gifts',
              style: TextStyle(
                color: !_showAllGifts ? Colors.white : Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar for filtering gifts by name
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (query) {
                setState(() {
                  _searchQuery = query.trim().toLowerCase();
                });
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                hintText: 'Search gifts by name...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(child: _buildGiftsStream()),
        ],
      ),
    );
  }

  Widget _buildGiftsStream() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _showAllGifts
          ? _controller.getAllGiftsStream(userId)
          : _controller.getPledgedGiftsStream(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
          return Center(child: Text('Error loading gifts.'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No gifts found.'));
        }

        // Filter gifts by search query
        final gifts = snapshot.data!
            .where((gift) =>
            gift['name'].toString().toLowerCase().contains(_searchQuery))
            .toList();
        print('Filtered gifts count: ${gifts.length}');

        return ListView.builder(
          itemCount: gifts.length,
          itemBuilder: (context, index) {
            final gift = gifts[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text(gift['name'] ?? 'Unnamed Gift'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Event: ${gift['eventName']}'),
                    Text('Status: ${gift['status']}'),
                    if (gift['status'] == 'Pledged')
                      Text('Pledged by: ${gift['pledgedBy']}'),
                  ],
                ),
                trailing: Icon(
                  gift['status'] == 'Pledged'
                      ? Icons.lock
                      : Icons.card_giftcard,
                  color: gift['status'] == 'Pledged'
                      ? Colors.redAccent
                      : Colors.green,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
