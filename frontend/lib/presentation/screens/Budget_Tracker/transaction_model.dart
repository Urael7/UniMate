import 'package:flutter/material.dart';

class TransactionModel extends ChangeNotifier {
  final List<Map<String, dynamic>> _transactions = [
    {
      "title": "Netflix",
      "date": "Apr 12",
      "amount": "-ETB 150.00",
      "color": Colors.red,
      "isIncome": false,
    },
    {
      "title": "Grocery Store",
      "date": "Apr 13",
      "amount": "-ETB 200.00",
      "color": Colors.red,
      "isIncome": false,
    },
    {
      "title": "Food",
      "date": "Apr 14",
      "amount": "-ETB 100.00",
      "color": Colors.red,
      "isIncome": false,
    },
  ];

  final double _totalBudget = 2000.00;

  List<Map<String, dynamic>> get transactions => _transactions;

  double get totalBudget => _totalBudget;

  double get totalSpent {
    return _transactions.where((tx) => !tx["isIncome"]).fold(0.0, (sum, tx) {
      final cleaned =
          double.tryParse(tx["amount"].replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
      return sum + cleaned;
    });
  }

  double get totalIncome {
    return _transactions.where((tx) => tx["isIncome"]).fold(0.0, (sum, tx) {
      final cleaned =
          double.tryParse(tx["amount"].replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
      return sum + cleaned;
    });
  }

  double get balance => _totalBudget + totalIncome - totalSpent;

  void addTransaction(String title, String date, String amount, bool isIncome) {
    final rawAmount = double.parse(amount.replaceAll(RegExp(r'[^\d.]'), ''));
    _transactions.insert(0, {
      "title": title,
      "date": date,
      "amount": "${isIncome ? '+' : '-'}ETB ${rawAmount.toStringAsFixed(2)}",
      "color": isIncome ? Colors.green : Colors.red,
      "isIncome": isIncome,
    });
    notifyListeners();
  }
}
