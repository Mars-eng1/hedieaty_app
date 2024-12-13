import 'package:flutter/material.dart';
import '../controllers/gift_list_controller.dart';

class GiftListPage extends StatefulWidget {
  final Map<String, dynamic> arguments;

  GiftListPage({required this.arguments});

  @override
  _GiftListPageState createState() => _GiftListPageState();
}

class _GiftListPageState extends State<GiftListPage> {
  late final GiftListController _controller;

  @override
  void initState() {
    super.initState();
    // Safely retrieve arguments with default values
    final eventId = widget.arguments['eventId'] as String;
    final isMyEvent = widget.arguments['isMyEvent'] as bool? ?? false;

    _controller = GiftListController(eventId: eventId, isMyEvent: isMyEvent);
    _controller.loadGifts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.card_giftcard, color: Colors.black),
            const SizedBox(width: 8),
            Text(
              'Gift List',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.pinkAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
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
                      _controller.sortGiftsByName();
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
          // Gift List
          Expanded(
            child: ListView.builder(
              itemCount: _controller.filteredGifts.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final gift = _controller.filteredGifts[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    title: Text(gift['name']),
                    subtitle: Text('${gift['category']} | ${gift['status']}'),
                    trailing: _controller.isMyEvent
                        ? _buildMyEventTrailing(context, gift)
                        : _buildOtherEventTrailing(context, gift),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // Floating Action Button for My Events Only
      floatingActionButton: _controller.isMyEvent
          ? FloatingActionButton.extended(
        onPressed: () => _controller.navigateToCreateGift(context),
        label: Text(
          'Create Gift',
          style: TextStyle(color: Colors.white),
        ),
        icon: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.pinkAccent,
      )
          : null,
    );
  }

  Widget _buildMyEventTrailing(BuildContext context, Map<String, dynamic> gift) {
    if (gift['isPledged'] ?? false) {
      return ElevatedButton.icon(
        onPressed: null,
        icon: Icon(Icons.lock, color: Colors.white),
        label: Text('Pledged', style: TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.blue[400]),
            onPressed: () => _controller.editGift(context, gift['id']),
          ),
          IconButton(
            icon: Icon(Icons.delete_forever_rounded, color: Colors.red),
            onPressed: () => _controller.deleteGift(context, gift['id']),
          ),
        ],
      );
    }
  }

  Widget _buildOtherEventTrailing(BuildContext context, Map<String, dynamic> gift) {
    return ElevatedButton.icon(
      onPressed: () => setState(() {
        _controller.togglePledgeStatus(gift);
      }),
      icon: Icon(
        gift['isPledged'] ? Icons.lock : Icons.check,
        color: Colors.white,
      ),
      label: Text(
        gift['isPledged'] ? 'Pledged' : 'Available',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: gift['isPledged'] ? Colors.redAccent : Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
