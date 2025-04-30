import 'package:flutter/material.dart';

class AddTransactionPage extends StatefulWidget {
  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  bool isExpense = true;
  String selectedCategory = 'Food';
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => isExpense = true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isExpense ? Colors.cyan : Colors.grey.shade300,
                      foregroundColor: isExpense ? Colors.white : Colors.black,
                    ),
                    child: Text('Expense'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => isExpense = false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isExpense ? Colors.grey.shade300 : Colors.cyan,
                      foregroundColor: isExpense ? Colors.black : Colors.white,
                    ),
                    child: Text('Income'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Amount'),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(prefixText: '\$', hintText: '0.00'),
            ),
            SizedBox(height: 20),
            Text('Category'),
            DropdownButton<String>(
              value: selectedCategory,
              isExpanded: true,
              items:
                  ['Food', 'Grocery Store', 'Netflix', 'Rent', 'Utilities']
                      .map(
                        (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                      )
                      .toList(),
              onChanged: (val) => setState(() => selectedCategory = val!),
            ),
            SizedBox(height: 20),
            Text('Description (Optional)'),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(hintText: 'Grocery Shopping'),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                // Handle save transaction
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
