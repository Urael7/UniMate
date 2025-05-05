
import 'dart:ui';

class BudgetCategory {
  String name;
  double allocated;
  double spent;
  Color color;

  BudgetCategory({
    required this.name,
    required this.allocated,
    required this.spent,
    required this.color,
  });
}

class Transaction {
  static int _nextId = 0;
  final int id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;


  Transaction({
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  }) : id = _nextId++; 


  Transaction._({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });

  // copyWith method
  Transaction copyWith({
    String? title,
    double? amount,
    String? category,
    DateTime? date,
  }) {
    return Transaction._(
      id: id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
    );
  }
}

