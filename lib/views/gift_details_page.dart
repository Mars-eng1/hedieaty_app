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
      _controller.loadGift(widget.arguments['giftId']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.arguments['isEditing'] == true ? 'Edit Gift' : 'Add Gift',
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
              // Category Dropdown
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
              // Name Field
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
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a gift name'
                    : null,
              ),
              const SizedBox(height: 16),
              // Status Field (Fixed to "Available")
              TextFormField(
                initialValue: 'Available',
                decoration: InputDecoration(
                  labelText: 'Status',
                  filled: true,
                  fillColor: Colors.pinkAccent[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 16),
              // Price Field
              TextFormField(
                controller: _controller.priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                  filled: true,
                  fillColor: Colors.pinkAccent[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a price'
                    : null,
              ),
              const SizedBox(height: 16),
              // Description Field
              TextFormField(
                controller: _controller.descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  filled: true,
                  fillColor: Colors.pinkAccent[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Add details of the gift...',
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              // Link Field
              TextFormField(
                controller: _controller.linkController,
                decoration: InputDecoration(
                  labelText: 'Gift Link',
                  filled: true,
                  fillColor: Colors.pinkAccent[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Paste the gift link here...',
                ),
              ),
              const SizedBox(height: 16),
              // Image Upload Button
              ElevatedButton.icon(
                onPressed: _controller.uploadImage,
                icon: Icon(Icons.image, color: Colors.blueAccent,),
                label: Text('Upload Image',style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                ),
              ),
              const SizedBox(height: 8),
              // Display Selected Image (if any)
              if (_controller.imagePath != null)
                Image.network(
                  _controller.imagePath!,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_controller.saveGift(context, widget.arguments['isEditing'])) {
            Navigator.pop(context);
          }
        },
        label: Text('Save',style: TextStyle(color: Colors.white),),
        icon: Icon(Icons.check,color: Colors.white,),
        backgroundColor: Colors.pinkAccent,
      ),
    );
  }
}
