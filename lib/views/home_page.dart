import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _controller = HomeController();

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.pinkAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.card_giftcard, color: Colors.white),
        ),
        title: Text(
          'Hedieaty',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          // Notifications Icon with Badge
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications, color: Colors.white),
                onPressed: () => _controller.navigateToNotifications(context),
              ),
              Positioned(
                right: 6,
                top: 6,
                child: StreamBuilder<int>(
                  stream: _controller.getUnreadNotificationCountStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data! > 0) {
                      return CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.red,
                        child: Text(
                          snapshot.data!.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.list, color: Colors.white),
            onPressed: () => _controller.navigateToEventList(context),
          ),
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () => _controller.navigateToCreateNewEvent(context),
          ),
          IconButton(
            icon: Icon(Icons.person, color: Colors.white),
            onPressed: () => _controller.navigateToProfile(context),
          ),
        ],
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

                final friends = snapshot.data!;
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
                      shadowColor: Colors.grey.withOpacity(0.3),
                      margin: const EdgeInsets.only(bottom: 15),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () => _controller.navigateToFriendEvents(
                          context,
                          friend['id'],
                          friend['name'] ?? 'Unknown',
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.purpleAccent,
                                Colors.pinkAccent.withOpacity(0.7)
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: friend['profilePicture'] != null && friend['profilePicture'].isNotEmpty
                                    ? NetworkImage(friend['profilePicture'])
                                    : null,
                                child: friend['profilePicture'] == null || friend['profilePicture'].isEmpty
                                    ? Icon(Icons.person, size: 30, color: Colors.grey)
                                    : null,
                                backgroundColor: Colors.white,
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      friend['name'] ?? 'Unknown',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      friend['upcomingEvents'] != null &&
                                          friend['upcomingEvents'] > 0
                                          ? 'Upcoming Events: ${friend['upcomingEvents']}'
                                          : 'No Upcoming Events',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
