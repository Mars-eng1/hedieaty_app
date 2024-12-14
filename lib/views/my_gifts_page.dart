import 'package:flutter/material.dart';
import '../controllers/my_gifts_controller.dart';

class MyGiftsPage extends StatefulWidget {
  @override
  _MyGiftsPageState createState() => _MyGiftsPageState();
}

class _MyGiftsPageState extends State<MyGiftsPage> {
  final MyGiftsController _controller = MyGiftsController();
  bool _showAllGifts = true; // Toggle for All Gifts or Pledged Gifts

  @override
  void initState() {
    super.initState();
    _controller.loadGifts(); // Load gifts when screen initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Gifts',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.pinkAccent,
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _showAllGifts = true;
              });
            },
            child: Text(
              'All Gifts',
              style: TextStyle(
                color: _showAllGifts ? Colors.white : Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _showAllGifts = false;
              });
            },
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _showAllGifts ? _controller.getAllGifts() : _controller.getPledgedGifts(),
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
            padding: const EdgeInsets.all(16),
            itemCount: gifts.length,
            itemBuilder: (context, index) {
              final gift = gifts[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.pinkAccent.withOpacity(0.7),
                    child: Icon(
                      gift['status'] == 'Pledged' ? Icons.lock : Icons.card_giftcard,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(gift['name']),
                  subtitle: Text(
                    'Event: ${gift['eventName']} \nStatus: ${gift['status']}',
                    style: TextStyle(fontSize: 14),
                  ),
                  trailing: gift['status'] == 'Available'
                      ? ElevatedButton(
                    onPressed: null,
                    child: Text(
                      'Available',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  )
                      : ElevatedButton(
                    onPressed: null,
                    child: Text(
                      'Pledged',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
