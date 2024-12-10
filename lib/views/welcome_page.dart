import 'package:flutter/material.dart';
import '../controllers/welcome_controller.dart';

class WelcomePage extends StatelessWidget {
  final WelcomeController _controller = WelcomeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple, Colors.pinkAccent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Name
              Text(
                'Hedieaty',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 300), // Spacer for buttons

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Login Button
                  ElevatedButton(
                    onPressed: () => _controller.navigateToLogin(context),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 40),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.purple,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  // Sign Up Button
                  ElevatedButton(
                    onPressed: () => _controller.navigateToSignUp(context),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 40),
                    ),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.purple,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
