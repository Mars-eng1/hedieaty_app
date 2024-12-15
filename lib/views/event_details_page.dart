import 'package:flutter/material.dart';
import '../controllers/event_details_controller.dart';

class EventDetailsPage extends StatefulWidget {
  final Map<String, dynamic> arguments;

  EventDetailsPage({required this.arguments});

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  final EventDetailsController _controller = EventDetailsController();

  @override
  void initState() {
    super.initState();
    final isEditing = widget.arguments['isEditing'] ?? false;
    if (isEditing) {
      _controller.loadEvent(widget.arguments['eventId']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.arguments['isEditing'] == true ? 'Edit Event' : 'Create Event',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _controller.formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _controller.category,
                decoration: InputDecoration(
                  labelText: 'Category',
                  filled: true,
                  fillColor: Colors.pinkAccent[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: _controller.categories
                    .map((category) => DropdownMenuItem(
                  value: category,
                  child: Text(category),
                ))
                    .toList(),
                onChanged: (value) => setState(() {
                  _controller.category = value;
                }),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _controller.nameController,
                decoration: InputDecoration(
                  labelText: 'Event Name',
                  filled: true,
                  fillColor: Colors.pinkAccent[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _controller.dateController,
                decoration: InputDecoration(
                  labelText: 'Date',
                  filled: true,
                  fillColor: Colors.pinkAccent[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onTap: () => _controller.selectDate(context),
                readOnly: true,
                validator: (value) =>
                value == null || value.isEmpty ? 'Please select a date' : null,
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
                  hintText: 'Add details of place, time, location, etc.',
                ),
                maxLines: 4,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final isEditing = widget.arguments['isEditing'] ?? false;
          if (await _controller.saveEvent(context, isEditing)) {
            Navigator.pop(context);
          }
        },
        label: Text('Save'),
        icon: Icon(Icons.check),
        backgroundColor: Colors.pinkAccent,
      ),
    );
  }
}
