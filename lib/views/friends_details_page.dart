import 'package:flutter/material.dart';
import '../controllers/friends_details_controller.dart';

class FriendDetailsPage extends StatelessWidget {
  final String friendId;
  final FriendDetailsController _controller = FriendDetailsController();

  FriendDetailsPage({required this.friendId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friend Details'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: StreamBuilder<Map<String, dynamic>?>(
        stream: _controller.getFriendDetailsStream(friendId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading friend details.'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No details found.'));
          }

          final data = snapshot.data!;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Picture
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: data['profilePicture'] != null
                        ? NetworkImage(data['profilePicture'])
                        : null,
                    child: data['profilePicture'] == null
                        ? Icon(Icons.person, size: 60, color: Colors.white)
                        : null,
                    backgroundColor: Colors.pinkAccent,
                  ),
                  SizedBox(height: 20),

                  // Name
                  Text(
                    '${data['firstName'] ?? 'Unknown'} ${data['lastName'] ?? ''}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 10),

                  // Divider Line
                  Divider(thickness: 2, color: Colors.grey.shade300),
                  SizedBox(height: 20),

                  // Details Section
                  _buildDetailRow(Icons.flag, 'Country', data['country']),
                  _buildDetailRow(Icons.cake, 'Date of Birth', data['dob']),
                  _buildDetailRow(Icons.phone, 'Phone Number', data['phoneNumber']),
                  _buildDetailRow(Icons.email, 'Email', data['email']),

                  SizedBox(height: 30),

                  // Back Button
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back),
                    label: Text('Back to Friends'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Helper Widget to Build Rows of Details
  Widget _buildDetailRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.pinkAccent, size: 28),
          SizedBox(width: 15),
          Expanded(
            child: Text(
              '$label: ${value ?? 'N/A'}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
