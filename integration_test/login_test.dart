import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hedieaty/views/home_page.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hedieaty/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Login flow test', (WidgetTester tester) async {
    print('Starting the login test...');

    // Launch the app
    app.main();
    await tester.pumpAndSettle();
    print('App launched successfully.');

    // Find widgets using keys
    final emailField = find.byKey(Key('emailField'));
    final passwordField = find.byKey(Key('passwordField'));
    final loginButton = find.text('Login');
    print('Found all necessary widgets.');

    // Simulate user input
    const testEmail = 'amr@gmail.com';
    const testPassword = '12345678';

    print('Entering email...');
    await tester.enterText(emailField, testEmail);
    print('Email entered: $testEmail');

    print('Entering password...');
    await tester.enterText(passwordField, testPassword);
    print('Password entered.');

    // Tap the login button
    print('Tapping the login button...');
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    // Verify navigation to the home screen
    print('Checking for successful navigation...');
    expect(find.byType(HomePage), findsOneWidget, reason: 'The user should navigate to the Home page.');

    print('Login test completed successfully.');
  });
}
