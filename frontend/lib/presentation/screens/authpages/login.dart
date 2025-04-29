import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50), // Add some spacing at the top
            Text(
              'Log In',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // Handle Google login
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 200, 204, 209),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.g_mobiledata,
                      color: const Color.fromARGB(255, 58, 58, 58),
                    ), // Google icon
                    SizedBox(width: 10),
                    Text(
                      'Log in with Google',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 58, 58, 58),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                // Handle Facebook login
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 200, 204, 209),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.facebook, color: Colors.white), // Facebook icon
                    SizedBox(width: 10),
                    Text(
                      'Log in with Facebook',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('OR', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter Email',
                filled: true,
                fillColor: Color.fromARGB(255, 200, 204, 209),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Enter Password',
                filled: true,
                fillColor: Color.fromARGB(255, 200, 204, 209),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 10),
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
                    Text('Remember Me'),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    // Handle forgot password
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: Color(0xFF6C63FF)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account? "),
                GestureDetector(
                  onTap: () {
                    // Handle sign up
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(color: Color(0xFF5CB15A)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle login button press
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(
                  0xFF6C63FF,
                ), // Use backgroundColor instead of primary
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Log In', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
