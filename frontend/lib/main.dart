import 'package:flutter/material.dart';
import 'presentation/screens/authpages/login.dart';
import 'presentation/screens/authpages/signup.dart';
import 'presentation/screens/home pages/home.dart'; // HomePage
import 'presentation/screens/home pages/home1.dart'; // Home1Page
import 'presentation/screens/home pages/home2.dart'; // Home2Page (New Page)

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unimate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/home', // Starts at HomePage
      routes: {
        '/home': (context) => const HomePage(),
        '/home1': (context) => const Home1Page(), // Route for Home1Page
        '/home2': (context) => const Home2Page(), // Route for Home2Page
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
      },
    );
  }
}
