import 'package:flutter/material.dart';
import '../controllers/gift_details_controller.dart';

class GiftDetailsPage extends StatefulWidget {
  final Map<String, dynamic> arguments;

  GiftDetailsPage({required this.arguments});

  @override
  _GiftDetailsPageState createState() => _GiftDetailsPageState();
}

class _GiftDetailsPageState extends State<GiftDetailsPage> {
  final GiftDetailsController _controller = GiftDetailsController();

  @override
  void initState() {
    super.initState();
    if (widget.arguments['isEditing'] == true) {
      _controller.loadGift(widget.arguments['eventId'], widget.arguments['giftId']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.arguments['isEditing'] == true ? 'Edit Gift' : 'Add Gift'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _controller.formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _controller.nameController,
                decoration: InputDecoration(
                  labelText: 'Gift Name',
                  filled: true,
                  fillColor: Colors.pinkAccent[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _controller.descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  filled: true,
                  fillColor: Colors.pinkAccent[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Add gift details...',
                ),
                maxLines: 4,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final success = await _controller.saveGift(context, widget.arguments['eventId'],
              widget.arguments['isEditing'], widget.arguments['giftId']);
          if (success) Navigator.pop(context);
        },
        label: Text('Save'),
        icon: Icon(Icons.check),
        backgroundColor: Colors.pinkAccent,
      ),
    );
  }
}
