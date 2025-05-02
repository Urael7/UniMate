import 'package:flutter/material.dart';
import 'package:frontend/presentation/screens/Budget_Tracker/add_transaction_page.dart';
import 'package:frontend/presentation/screens/Budget_Tracker/budget_home_page.dart';
import 'package:frontend/presentation/screens/Budget_Tracker/spending_analysis_page.dart';
import 'package:provider/provider.dart';
import 'package:frontend/presentation/screens/Budget_Tracker/transaction_model.dart';
import 'package:frontend/presentation/screens/Budget_Tracker/placeholder_home_screen.dart';
// ✅ Import your ProfilePage
// ✅ Import LogoutPage

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
      initialRoute: '/',
      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case '/':
            page = const BudgetScreen();
            break;
          case '/add':
            page = AddTransactionPage(
              onAddTransaction:
                  Provider.of<TransactionModel>(
                    context,
                    listen: false,
                  ).addTransaction,
            );
            break;
          case '/analysis':
            page = const SpendingAnalysisPage();
            break;
          case '/home':
            page = const PlaceholderHomeScreen();
            break;
          default:
            page = const BudgetScreen();
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
