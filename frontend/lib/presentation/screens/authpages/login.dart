import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Background color
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50), // Add some spacing at the top
              const Text(
                'Log In',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // Login with Google Button
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // Shadow position
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: () {
                    // Handle Google login
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/google_logo.jpg', // Path to the Google logo
                          height: 24,
                          width: 24,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Log in with Google',
                          style: TextStyle(color: Color(0xFF3A3A3A)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Login with Facebook Button
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // Shadow position
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: () {
                    // Handle Facebook login
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 80,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.facebook,
                          color: Colors.blue,
                        ), // Facebook icon
                        SizedBox(width: 10),
                        Text(
                          'Log in with Facebook',
                          style: TextStyle(color: Color(0xFF3A3A3A)),
                     ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('OR', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              // Enter Email Field
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // Shadow position
                    ),
                  ],
                ),
                child: TextField(
                  //controller:  emailController,
                  decoration: InputDecoration(
                    hintText: 'Enter Email',
                    hintStyle: const TextStyle(
                      color: Color(0xFFB0B0B0),
                    ), // Light silver text color
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.deepPurple),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Enter Password Field
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // Shadow position
                    ),
                  ],
                ),
                child: TextField(
                  // controller: ,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter Password',
                    hintStyle: const TextStyle(
                      color: Color(0xFFB0B0B0),
                    ), // Light silver text color
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.deepPurple),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: true,
                        onChanged: (value) {
                          // Handle checkbox state
                        },
                        activeColor: Colors.blue,
                      ),
                      const Text('Remember Me'),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      // Handle forgot password
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Color(0xFF6C63FF)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/signup',
                      ); // Navigate to SignUpPage
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(color: Color(0xFF5CB15A)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle login button press
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 32,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Log In',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
