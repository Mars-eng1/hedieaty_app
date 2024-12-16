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
              // Gift Category Dropdown
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
                validator: (value) => value == null ? 'Please select a category' : null,
              ),
              const SizedBox(height: 16),

              // Gift Name
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

              // Gift Description
              TextFormField(
                controller: _controller.descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  filled: true,
                  fillColor: Colors.pinkAccent[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Add details of your gift...',
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 16),

              // Gift Link
              TextFormField(
                controller: _controller.linkController,
                decoration: InputDecoration(
                  labelText: 'Link (optional)',
                  filled: true,
                  fillColor: Colors.pinkAccent[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Add a URL for the gift...',
                ),
              ),
              const SizedBox(height: 16),

              // Gift Price
              TextFormField(
                controller: _controller.priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Price',
                  filled: true,
                  fillColor: Colors.pinkAccent[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter a price';
                  if (double.tryParse(value) == null || double.parse(value) < 0) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Quantity
              TextFormField(
                controller: _controller.quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  filled: true,
                  fillColor: Colors.pinkAccent[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter quantity';
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Please enter a valid quantity';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Priority Dropdown
              DropdownButtonFormField<String>(
                value: _controller.priority,
                decoration: InputDecoration(
                  labelText: 'Priority',
                  filled: true,
                  fillColor: Colors.pinkAccent[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: _controller.priorities
                    .map((priority) => DropdownMenuItem(
                  value: priority,
                  child: Text(priority),
                ))
                    .toList(),
                onChanged: (value) => setState(() {
                  _controller.priority = value;
                }),
                validator: (value) => value == null ? 'Please select a priority' : null,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final success = await _controller.saveGift(
              context, widget.arguments['eventId'], widget.arguments['isEditing'], widget.arguments['giftId']);
          if (success) Navigator.pop(context);
        },
        label: Text('Save'),
        icon: Icon(Icons.check),
        backgroundColor: Colors.pinkAccent,
      ),
    );
  }
}
