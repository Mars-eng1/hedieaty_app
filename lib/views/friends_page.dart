import 'package:flutter/material.dart';
import '../controllers/friends_controller.dart';

class FriendsPage extends StatefulWidget {
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final FriendsController _controller = FriendsController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextField(
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                hintText: 'Search friends...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                isDense: true,
              ),
            ),
          ),
          // Friends List
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _controller.getFriendsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error loading friends.'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No friends found.'));
                }

                // Apply search filter
                final friends = _controller.filterFriends(snapshot.data!, _searchQuery);

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
                    final friend = friends[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      margin: const EdgeInsets.only(bottom: 15),
                      child: ListTile(
                        onTap: () => _controller.navigateToFriendDetails(context, friend['id']),
                        leading: CircleAvatar(
                          backgroundImage: friend['profilePicture'] != null &&
                              friend['profilePicture'].isNotEmpty
                              ? NetworkImage(friend['profilePicture'])
                              : null,
                          child: friend['profilePicture'] == null ||
                              friend['profilePicture'].isEmpty
                              ? Icon(Icons.person, color: Colors.white)
                              : null,
                          backgroundColor: Colors.pinkAccent,
                        ),
                        title: Text(
                          friend['name'] ?? 'Unknown',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () => _showDeleteConfirmation(
                            context,
                            friend['id'],
                            friend['name'] ?? 'Unknown', // Ensure fallback for friend name
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _controller.navigateToAddFriend(context),
        label: Text('Add Friend'),
        icon: Icon(Icons.person_add),
        backgroundColor: Colors.pinkAccent,
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String friendId, String friendName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove Friend'),
        content: Text('Are you sure you want to remove $friendName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close the dialog
              try {
                await _controller.removeFriend(context, friendId, friendName);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$friendName has been removed.')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to remove $friendName.')),
                  );
                }
              }
            },
            child: Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

}
