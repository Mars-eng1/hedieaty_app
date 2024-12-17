import 'package:flutter/material.dart';
import '../controllers/settings_controller.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SettingsController _controller = SettingsController();
  bool _notifyOnUnpledge = true; // Default value

  @override
  void initState() {
    super.initState();
    _loadPreference();
  }

  // Load the user's current preference
  void _loadPreference() async {
    await _controller.loadNotificationPreference();
    setState(() {
      _notifyOnUnpledge = _controller.notifyOnUnpledge;
    });
  }

  // Update the user's preference
  void _togglePreference(bool value) async {
    await _controller.updateNotificationPreference(value);
    setState(() {
      _notifyOnUnpledge = value;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Notification preference updated')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notification Preferences',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.pinkAccent,
              ),
            ),
            SizedBox(height: 16),
            SwitchListTile(
              title: Text(
                'Notify on Gift Unpledge',
                style: TextStyle(fontSize: 16),
              ),
              value: _notifyOnUnpledge,
              activeColor: Colors.pinkAccent,
              onChanged: (value) => _togglePreference(value),
            ),
          ],
        ),
      ),
    );
  }
}
