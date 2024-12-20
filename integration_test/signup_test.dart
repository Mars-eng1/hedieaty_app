import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hedieaty/views/home_page.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hedieaty/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Signup flow test', (WidgetTester tester) async {
    print('Starting the signup test...');

    // Step 1: Launch the app
    app.main();
    print('App is launching...');
    await tester.pumpAndSettle();
    print('App launched successfully.');

    // Step 2: Navigate to the Signup Page
    print('Finding "Sign Up" button...');
    final signupButton = find.text('Sign Up');
    expect(signupButton, findsOneWidget, reason: 'Sign Up button should exist.');
    print('"Sign Up" button found. Tapping the button...');
    await tester.tap(signupButton);
    await tester.pumpAndSettle();
    print('Navigated to Signup Page.');

    // Step 3: Interact with the Signup Page
    print('Finding email and password fields...');
    final emailField = find.byKey(Key('emailField'));
    final passwordField = find.byKey(Key('passwordField'));
    final confirmSignupButton = find.byKey(Key('signupButton'));
    expect(emailField, findsOneWidget, reason: 'Email field should exist.');
    expect(passwordField, findsOneWidget, reason: 'Password field should exist.');
    print('All necessary widgets found on the Signup Page.');

    const testEmail = 'testuser@example.com';
    const testPassword = 'password123';

    print('Entering email...');
    await tester.enterText(emailField, testEmail);
    print('Email entered: $testEmail');

    print('Entering password...');
    await tester.enterText(passwordField, testPassword);
    print('Password entered.');

    print('Submitting the signup form...');
    await tester.tap(confirmSignupButton);
    await tester.pumpAndSettle();
    print('Signup form submitted.');

    // Step 4: Verify navigation to Account Setup Page
    print('Checking if navigation to Account Setup Page occurred...');
    final accountSetupTitle = find.text('Complete Profile');
    final accountTitle = find.text('Account');
    final foundAccountPageTitle =
        accountSetupTitle.evaluate().isNotEmpty || accountTitle.evaluate().isNotEmpty;

    if (!foundAccountPageTitle) {
      print('DEBUG: Navigation did not reach Account Setup Page.');
      print('DEBUG: Current widgets tree:\n${tester.allElements.map((e) => e.widget.toString()).join('\n')}');
    }
    expect(foundAccountPageTitle, true, reason: 'Should navigate to Account Setup page with the correct title.');

    print('Navigated to Account Setup Page successfully.');

    // Step 5: Fill all Account Setup fields
    print('Filling out Account Setup fields...');
    final firstNameField = find.byKey(Key('firstNameField'));
    final lastNameField = find.byKey(Key('lastNameField'));
    final dobField = find.byKey(Key('dobField'));
    final genderDropdown = find.byKey(Key('genderDropdown'));
    final phoneField = find.byKey(Key('phoneField'));
    final countryDropdown = find.byKey(Key('countryDropdown'));
    final completeProfileButton = find.byKey(Key('completeProfileButton'));

    await tester.enterText(firstNameField, 'Test');
    await tester.enterText(lastNameField, 'User');
    print('First and Last Name entered.');

    print('Selecting DOB...');
    await tester.tap(dobField);
    await tester.pumpAndSettle();
    await tester.tap(find.text('15')); // Adjust this if necessary
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    print('DOB selected.');

    print('Selecting gender...');
    await tester.tap(genderDropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Male').last);
    await tester.pumpAndSettle();
    print('Gender selected.');

    print('Entering phone number...');
    await tester.enterText(phoneField, '123456789000');
    print('Phone number entered.');

    print('Selecting country...');
    await tester.tap(countryDropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('USA').last);
    await tester.pumpAndSettle();
    print('Country selected.');

    print('Tapping the complete profile button...');
    await tester.tap(completeProfileButton);
    await tester.pumpAndSettle();

    // Step 6: Verify navigation to Home Page
    print('Checking for navigation to Home Page...');
    final homePage = find.byType(HomePage);
    if (homePage.evaluate().isEmpty) {
      print('DEBUG: Navigation did not reach Home Page.');
      print('DEBUG: Current widgets tree:\n${tester.allElements.map((e) => e.widget).toList()}');
    }
    expect(homePage, findsOneWidget, reason: 'The user should navigate to the Home page after profile completion.');

    print('Signup test completed successfully.');
  });
}
