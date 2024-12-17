import 'package:flutter/material.dart';
import '../controllers/gift_list_controller.dart';

class GiftListPage extends StatefulWidget {
  final Map<String, dynamic> arguments;

  GiftListPage({required this.arguments});

  @override
  _GiftListPageState createState() => _GiftListPageState();
}

class _GiftListPageState extends State<GiftListPage> {
  final GiftListController _controller = GiftListController();
  late String eventId;
  late String eventName;

  @override
  void initState() {
    super.initState();
    eventId = widget.arguments['eventId'];
    eventName = widget.arguments['eventName'] ?? 'Event';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$eventName\'s Gifts'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _controller.getFilteredGiftsStream(eventId),
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

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  title: Text(gift['name']),
                  subtitle: Text(gift['description'] ?? 'No description'),
                  trailing: isAvailable
                      ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () =>
                            _controller.editGift(context, eventId, gift['id']),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            _controller.deleteGift(context, eventId, gift['id']),
                      ),
                    ],
                  )
                      : ElevatedButton(
                    onPressed: null,
                    child: Text('Pledged'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                  ),
                  onTap: () => _controller.showGiftDetails(context, gift),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _controller.navigateToGiftDetails(context, eventId),
        label: Text('Add Gift'),
        icon: Icon(Icons.add),
        backgroundColor: Colors.pinkAccent,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.pinkAccent),
              child: Center(
                child: Text(
                  'Filters & Sorting',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text('Sort by Name'),
              trailing: Icon(Icons.sort_by_alpha),
              onTap: () {
                setState(() {
                  _controller.sortGiftsByName();
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Sort by Status'),
              trailing: Icon(Icons.sort),
              onTap: () {
                setState(() {
                  _controller.sortGiftsByStatus();
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Filter by Category'),
              trailing: Icon(Icons.filter_list),
              onTap: () => _showCategoryFilter(context),
            ),
            ListTile(
              title: Text('Clear Filters'),
              trailing: Icon(Icons.clear),
              onTap: () {
                setState(() {
                  _controller.clearFilters();
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCategoryFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children: _controller.categories.map((category) {
            return ListTile(
              title: Text(category),
              onTap: () {
                setState(() {
                  _controller.filterGiftsByCategory(category);
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }
}
