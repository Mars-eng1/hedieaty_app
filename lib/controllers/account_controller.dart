import 'package:flutter/material.dart';

class AccountController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  String? selectedGender;
  final List<String> genders = ['Male', 'Female'];

  String? selectedCountry;
  final List<String> countries = [
    'United States',
    'India',
    'United Kingdom',
    'Canada',
    'Australia',
    'Germany',
    'France',
    'Other',
  ];

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      dateOfBirthController.text = pickedDate.toLocal().toString().split(' ')[0];
    }
  }

  bool saveAccountDetails(BuildContext context) {
    if (formKey.currentState!.validate()) {
      // Save logic here
      print('First Name: ${firstNameController.text}');
      print('Last Name: ${lastNameController.text}');
      print('Date of Birth: ${dateOfBirthController.text}');
      print('Gender: $selectedGender');
      print('Email: ${emailController.text}');
      print('Phone Number: ${phoneNumberController.text}');
      print('Country: $selectedCountry');
      return true;
    }
    return false;
  }
}
