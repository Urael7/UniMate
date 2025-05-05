import 'package:flutter/material.dart';
import 'package:frontend/models/budget.dart';

class BudgetService with ChangeNotifier {
  final List<BudgetCategory> _categories = [
    BudgetCategory(name: 'Food', allocated: 500, spent: 250, color: Colors.blue),
    BudgetCategory(name: 'Transport', allocated: 300, spent: 200, color: Colors.green),
    BudgetCategory(name: 'Entertainment', allocated: 200, spent: 180, color: Colors.orange),
    BudgetCategory(name: 'Utilities', allocated: 400, spent: 60, color: Colors.purple),
    BudgetCategory(name: 'Shopping', allocated: 300, spent: 355, color: Colors.red),
  ];

  final List<Transaction> _recentTransactions = [
    Transaction(
      title: 'Grocery Store',
      amount: -85.50,
      category: 'Food',
      date: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Transaction(
      title: 'Salary Deposit',
      amount: 2500.00,
      category: 'Income',
      date: DateTime.now().subtract(const Duration(days: 1))
    ),
  ];

  List<BudgetCategory> get categories => _categories;
  List<Transaction> get recentTransactions => _recentTransactions;

  double get totalIncome => _recentTransactions
      .where((t) => t.amount > 0)
      .fold(0, (sum, t) => sum + t.amount);

  double get totalExpenses => _recentTransactions
      .where((t) => t.amount < 0)
      .fold(0, (sum, t) => sum + t.amount.abs());

  double get currentBalance => totalIncome - totalExpenses;

  double get totalAllocated => _categories.fold(0.0, (sum, c) => sum + c.allocated);
  double get totalSpent => _categories.fold(0.0, (sum, c) => sum + c.spent);
  double get totalRemaining => totalAllocated - totalSpent;

  void addTransaction(Transaction transaction) {
    _recentTransactions.insert(0, transaction);
    
    if (transaction.amount < 0 && transaction.category != 'Income') {
      final categoryIndex = _categories.indexWhere(
        (c) => c.name == transaction.category,
      );
      if (categoryIndex != -1) {
        _categories[categoryIndex].spent += transaction.amount.abs();
      }
    }
    
    notifyListeners();
  }

  void updateCategoryAllocation(int index, double newAllocation) {
    _categories[index].allocated = newAllocation;
    notifyListeners();
  }

  void addCategory(BudgetCategory category) {
    _categories.add(category);
    notifyListeners();
  }

  void removeCategory(int index) {
    // Before removing, we should handle any transactions associated with this category
    _categories.removeAt(index);
    notifyListeners();
  }


  bool canAllocateBudget(double newTotalAllocation) {
    return newTotalAllocation <= currentBalance;
  }


  double getMaxAllowedAllocation(int index, double currentAllocation) {
    final currentTotal = totalAllocated;
    final currentCategoryAllocation = _categories[index].allocated;
    final availableBalance = currentBalance - (currentTotal - currentCategoryAllocation);
    return availableBalance > 0 ? availableBalance : 0;
  }
}