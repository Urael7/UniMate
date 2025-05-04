import 'package:flutter/material.dart';
import 'package:frontend/presentation/screens/Budget_Tracker/add_transaction_page.dart';
import 'package:frontend/presentation/screens/Budget_Tracker/budget_home_page.dart';
import 'package:frontend/presentation/screens/Budget_Tracker/spending_analysis_page.dart';
import 'package:frontend/presentation/screens/notification_page/notification.dart'; // Import NotificationPage
import 'package:provider/provider.dart';
import 'package:frontend/presentation/screens/Budget_Tracker/transaction_model.dart';
import 'package:frontend/presentation/screens/authpages/login.dart'; // LoginPage
import 'package:frontend/presentation/screens/authpages/signup.dart'; // Import SignUpPage
import 'package:frontend/presentation/screens/home pages/home.dart'; // Import HomePage
import 'package:frontend/presentation/screens/home pages/home1.dart'; // Import Home1Page
import 'package:frontend/presentation/screens/home pages/home2.dart'; // Import Home2Page
import 'package:frontend/presentation/screens/User profile/profile.dart'; // Import ProfilePage
import 'package:frontend/presentation/screens/User profile/edit_profile.dart'; // Import EditProfilePage
import 'package:frontend/presentation/screens/logout/logout.dart'; // Import LogoutPage
import 'package:frontend/presentation/screens/Resource_page/resource.dart'; // Import ResourcePage
import 'package:frontend/presentation/screens/Exam_page/exam.dart'; // Import ExamPage
import 'package:frontend/presentation/screens/event_page/admin_login.dart'; // Import AdminLoginPage

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TransactionModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unimate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/admin_login', // Set the initial route to AdminLoginPage
      routes: {
        '/login': (context) => const LoginPage(), // LoginPage route
        '/signup': (context) => const SignUpPage(), // SignUpPage route
        '/home': (context) => const HomePage(), // HomePage route
        '/home1': (context) => const Home1Page(), // Home1Page route
        '/home2': (context) => const Home2Page(), // Home2Page route
        '/profile': (context) => const ProfilePage(), // ProfilePage route
        '/edit_profile':
            (context) => const EditProfilePage(), // EditProfilePage route
        '/logout': (context) => const LogoutPage(), // LogoutPage route
        '/add':
            (context) => AddTransactionPage(
              onAddTransaction:
                  Provider.of<TransactionModel>(
                    context,
                    listen: false,
                  ).addTransaction,
            ), // AddTransactionPage route
        '/analysis':
            (context) =>
                const SpendingAnalysisPage(), // SpendingAnalysisPage route
        '/budget': (context) => const BudgetScreen(), // BudgetScreen route
        '/resource': (context) => const ResourcePage(), // ResourcePage route
        '/exam': (context) => const ExamPage(), // ExamPage route
        '/notification':
            (context) => const NotificationPage(), // NotificationPage route
        '/admin_login':
            (context) => const AdminLoginPage(), // AdminLoginPage route
      },
    );
  }
}
