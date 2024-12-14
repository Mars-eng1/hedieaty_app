import 'package:flutter/material.dart';
import '../controllers/account_controller.dart';

class AccountPage extends StatefulWidget {
  final Map<String, dynamic> arguments;

  AccountPage({required this.arguments});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late final AccountController _controller;
  bool _isLoading = true; // For showing a loading indicator while fetching data

  @override
  void initState() {
    super.initState();
    _controller = AccountController(userId: widget.arguments['userId']);
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      await _controller.loadUserData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading user data: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isSetup = widget.arguments['isSetup'] ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(isSetup ? 'Complete Profile' : 'Account'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading spinner
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _controller.formKey,
          child: ListView(
            children: [
              // First Name
              TextFormField(
                controller: _controller.firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  filled: true,
                  fillColor: Colors.pinkAccent[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'First name is required'
                    : null,
              ),
              const SizedBox(height: 16),

              // Last Name
              TextFormField(
                controller: _controller.lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  filled: true,
                  fillColor: Colors.pinkAccent[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Last name is required'
                    : null,
              ),
              const SizedBox(height: 16),

              // Date of Birth
              TextFormField(
                controller: _controller.dobController,
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                  filled: true,
                  fillColor: Colors.pinkAccent[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onTap: () => _controller.selectDate(context),
                readOnly: true,
              ),
              const SizedBox(height: 16),

              // Gender
              DropdownButtonFormField<String>(
                value: _controller.gender,
                decoration: InputDecoration(
                  labelText: 'Gender',
                  filled: true,
                  fillColor: Colors.pinkAccent[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: ['Male', 'Female']
                    .map((gender) => DropdownMenuItem(
                  value: gender,
                  child: Text(gender),
                ))
                    .toList(),
                onChanged: (value) => setState(() {
                  _controller.gender = value;
                }),
              ),
              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: _controller.emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  filled: true,
                  fillColor: Colors.pinkAccent[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                readOnly: true, // Email is not editable
              ),
              const SizedBox(height: 16),

              // Phone Number
              TextFormField(
                controller: _controller.phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  filled: true,
                  fillColor: Colors.pinkAccent[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              // Country/Region
              DropdownButtonFormField<String>(
                value: _controller.country,
                decoration: InputDecoration(
                  labelText: 'Country/Region',
                  filled: true,
                  fillColor: Colors.pinkAccent[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: _controller.countries
                    .map((country) => DropdownMenuItem(
                  value: country,
                  child: Text(country),
                ))
                    .toList(),
                onChanged: (value) => setState(() {
                  _controller.country = value;
                }),
              ),
              const SizedBox(height: 20),

              // Save Button
              ElevatedButton(
                onPressed: () {
                  if (_controller.formKey.currentState!.validate()) {
                    _controller.saveUserData(context, isSetup);
                  }
                },
                child: Text(isSetup ? 'Complete Profile' : 'Save'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
