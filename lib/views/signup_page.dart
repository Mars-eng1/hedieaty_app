import 'package:flutter/material.dart';
import '../controllers/signup_controller.dart';
import 'package:form_field_validator/form_field_validator.dart';

class SignupPage extends StatelessWidget {
  final SignupController _controller = SignupController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Email Field
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: EmailValidator(errorText: 'Enter a valid email'),
              ),
              const SizedBox(height: 16),
              // Password Field
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: MinLengthValidator(6,
                    errorText: 'Password must be at least 6 characters'),
              ),
              const SizedBox(height: 16),
              // Signup Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _controller.signup(
                      _emailController.text,
                      _passwordController.text,
                      context,
                    );
                  }
                },
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
