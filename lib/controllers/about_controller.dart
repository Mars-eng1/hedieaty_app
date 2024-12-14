import 'package:flutter/material.dart';

class AboutController {
  // App Information
  final String appName = 'Hedieaty';
  final String appVersion = '1.0.0';
  final String appDescription =
      'Hedieaty is your ultimate gift management and event planning tool. '
      'It helps you organize events, track gifts, and make planning simple and enjoyable.';

  // Developer Information
  final String developers = 'Developed by Amr and the Flutter Experts team.';

  // Contact Information
  final String contactMessage = 'For support or inquiries, reach out to us at:';
  final String contactEmail = 'support@hedieatyapp.com';

  // Copyright Information
  final String copyright = '© 2024 Hedieaty Team. All Rights Reserved.';

  // Actions
  void openContactEmail() {
    // Logic to handle email tap (e.g., open email client)
    print('Opening email client for: $contactEmail');
  }
}
