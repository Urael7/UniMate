import 'package:flutter/material.dart';
import 'package:frontend/presentation/screens/Budget_Tracker/add_transaction_page.dart';
import 'package:frontend/presentation/screens/Budget_Tracker/budget_home_page.dart';
import 'package:frontend/presentation/screens/Budget_Tracker/spending_analysis_page.dart';
import 'package:frontend/presentation/screens/notification_page/notification.dart'; // Import NotificationPage
import 'package:provider/provider.dart';
import 'package:frontend/presentation/screens/Budget_Tracker/transaction_model.dart';
// Import additional pages
import 'package:frontend/presentation/screens/authpages/login.dart'; // LoginPage
import 'package:frontend/presentation/screens/authpages/signup.dart'; // SignUpPage
import 'package:frontend/presentation/screens/home pages/home.dart'; // HomePage
import 'package:frontend/presentation/screens/home pages/home1.dart'; // Home1Page
import 'package:frontend/presentation/screens/home pages/home2.dart'; // Home2Page
import 'package:frontend/presentation/screens/User profile/profile.dart'; // ProfilePage
import 'package:frontend/presentation/screens/User profile/edit_profile.dart'; // EditProfilePage
import 'package:frontend/presentation/screens/logout/logout.dart'; // LogoutPage
import 'package:frontend/presentation/screens/Resource_page/resource.dart'; // ResourcePage
import 'package:frontend/presentation/screens/Exam_page/exam.dart'; // ExamPage
import 'package:frontend/presentation/screens/event_page/admin_login.dart'; // AdminLoginPage
import 'package:frontend/presentation/screens/dashboard/assignments.dart'; // AssignmentsPage
import 'package:frontend/presentation/screens/dashboard/dashboard.dart'; // DashboardPage
import 'package:frontend/presentation/screens/dashboard/class_schedule.dart'; // ClassSchedulePage
import 'package:frontend/presentation/screens/event_page/post_event_page.dart'; // PostEventPage
import 'package:frontend/presentation/screens/event_page/upcoming_event_page.dart'; // UpcomingEventPage

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
      initialRoute: '/dashboard', // Set initial route based on your preference
      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case '/dashboard':
            page = DashboardPage();
            break;
          case '/class-schedule':
            page = ClassSchedulePage();
            break;
          case '/assignments':
            page = AssignmentsPage();
            break;
          case '/':
            page = const BudgetScreen();
            break;
          case '/add':
            page = AddTransactionPage(
              onAddTransaction: Provider.of<TransactionModel>(
                context,
                listen: false,
              ).addTransaction,
            );
            break;
          case '/analysis':
            page = const SpendingAnalysisPage();
            break;
          case '/home':
            page = const HomePage();
            break;
          case '/home1':
            page = const Home1Page();
            break;
          case '/home2':
            page = const Home2Page();
            break;
          case '/profile':
            page = const ProfilePage();
            break;
          case '/edit_profile':
            page = const EditProfilePage();
            break;
          case '/logout':
            page = const LogoutPage();
            break;
          case '/resource':
            page = const ResourcePage();
            break;
          case '/exam':
            page = const ExamPage();
            break;
          case '/notification':
            page = const NotificationPage();
            break;
          case '/admin_login':
            page = const AdminLoginPage();
            break;
          case '/post-event':
            page = PostEventPage();
            break;
          case '/upcoming-event':
            page = UpcomingEventPage();
            break;
          default:
            page = DashboardPage();
        }
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      },
    );
  }
}
