// main.dart
import 'package:flutter/material.dart';
import 'presentation/screens/authpages/login.dart';
import 'presentation/screens/authpages/signup.dart';
import 'presentation/screens/home pages/home.dart'; // HomePage
import 'presentation/screens/home pages/home1.dart'; // Home1Page
import 'presentation/screens/home pages/home2.dart'; // Home2Page (New Page)
import 'package:frontend/presentation/screens/Budget_Tracker/add_transaction_page.dart';
import 'package:frontend/presentation/screens/Budget_Tracker/budget_home_page.dart';
import 'package:frontend/presentation/screens/Budget_Tracker/spending_analysis_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
        '/': (context) => BudgetScreen(),
        '/add': (context) => AddTransactionPage(),
        '/analysis': (context) => SpendingAnalysisPage(),
      },
    );
  }
}
