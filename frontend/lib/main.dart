// main.dart
import 'package:flutter/material.dart';
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
      debugShowCheckedModeBanner: false,
      title: 'Mini Finance App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => BudgetScreen(),
        '/add': (context) => AddTransactionPage(),
        '/analysis': (context) => SpendingAnalysisPage(),
      },
    );
  }
}
