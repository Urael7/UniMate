import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:frontend/presentation/screens/Budget_Tracker/transaction_model.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  bool _hasShownOverspendingNotification = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionModel>(
      builder: (context, model, child) {
        String currentDate = DateFormat.yMMMM().format(DateTime.now());
        double progress =
            model.totalSpent / (model.totalBudget + model.totalIncome);

        // Check for overspending (70% threshold)
        if (progress >= 0.7 && !_hasShownOverspendingNotification) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Warning: You have spent over 70% of your budget!',
                ),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
              ),
            );
          });
          _hasShownOverspendingNotification = true;
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage('assets/Jon_doe.jpg'),
                        radius: 20,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Hi, John doe",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            currentDate,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Current Balance",
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                  Text(
                    "ETB ${model.balance.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.lightBlueAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Monthly Budget",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        LinearProgressIndicator(
                          value: progress.clamp(0.0, 1.0),
                          color: Colors.white,
                          backgroundColor: Colors.white.withOpacity(0.3),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "ETB ${model.totalSpent.toStringAsFixed(2)}/ETB ${(model.totalBudget + model.totalIncome).toStringAsFixed(2)}",
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          "${(progress * 100).toStringAsFixed(0)}%",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Recent Transactions",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children:
                        model.transactions.map((tx) {
                          return _buildTransaction(
                            tx["title"],
                            tx["date"],
                            tx["amount"],
                            tx["color"],
                          );
                        }).toList(),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: 0,
            items: [
              BottomNavigationBarItem(
                icon: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/home');
                  },
                  child: const Icon(Icons.home),
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: GestureDetector(
                  onTap: () async {
                    final result = await Navigator.pushNamed(context, '/add');
                    if (result != null && result is Map<String, dynamic>) {
                      // The transaction is already added via the TransactionModel
                    }
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/analysis',
                      arguments: model.transactions,
                    );
                  },
                  child: const Icon(Icons.bar_chart),
                ),
                label: "",
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTransaction(
    String title,
    String date,
    String amount,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 16)),
              Text(
                date,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          Text(amount, style: TextStyle(color: color, fontSize: 16)),
        ],
      ),
    );
  }
}
