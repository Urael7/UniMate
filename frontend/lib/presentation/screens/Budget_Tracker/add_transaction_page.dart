import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTransactionPage extends StatefulWidget {
  final Function(String title, String date, String amount, bool isIncome)
  onAddTransaction;

  const AddTransactionPage({super.key, required this.onAddTransaction});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _selectedType = 'Monthly';
  bool _isIncome = false;

  void _handleAddTransaction() {
    final title = _titleController.text.trim();
    final amountStr = _amountController.text.trim();
    final date = DateFormat.MMMd().format(DateTime.now());

    if (title.isNotEmpty && amountStr.isNotEmpty) {
      final double amount = double.tryParse(amountStr) ?? 0;
      final isOverspending = !_isIncome && amount > 2000;

      if (isOverspending) {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Overspending Warning'),
                content: const Text(
                  'This expense exceeds your total budget. Are you sure you want to proceed?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onAddTransaction(
                        title,
                        date,
                        amountStr,
                        _isIncome,
                      );
                      Navigator.pop(context);
                    },
                    child: const Text('Proceed'),
                  ),
                ],
              ),
        );
      } else {
        widget.onAddTransaction(title, date, amountStr, _isIncome);
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Add Transaction',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text("Type: "),
                const SizedBox(width: 10),
                ChoiceChip(
                  label: const Text('Monthly'),
                  selected: _selectedType == 'Monthly',
                  onSelected: (_) {
                    setState(() {
                      _selectedType = 'Monthly';
                    });
                  },
                ),
                const SizedBox(width: 10),
                ChoiceChip(
                  label: const Text('One-time'),
                  selected: _selectedType == 'One-time',
                  onSelected: (_) {
                    setState(() {
                      _selectedType = 'One-time';
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text("Category: "),
                const SizedBox(width: 10),
                ChoiceChip(
                  label: const Text('Income'),
                  selected: _isIncome,
                  onSelected: (_) {
                    setState(() {
                      _isIncome = true;
                    });
                  },
                ),
                const SizedBox(width: 10),
                ChoiceChip(
                  label: const Text('Expense'),
                  selected: !_isIncome,
                  onSelected: (_) {
                    setState(() {
                      _isIncome = false;
                    });
                  },
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade400,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _handleAddTransaction,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Add Transaction'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
