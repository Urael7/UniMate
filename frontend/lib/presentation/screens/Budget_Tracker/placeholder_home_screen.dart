import 'package:flutter/material.dart';

class PlaceholderHomeScreen extends StatelessWidget {
  const PlaceholderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'Placeholder Home Screen',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
