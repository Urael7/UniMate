import 'package:flutter/material.dart';
import 'package:frontend/models/budget.dart';
import 'package:frontend/presentation/screens/BudgetTracker/budget_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BudgetTrackerPage extends StatelessWidget {
  const BudgetTrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: const Text('Budget Tracker'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddTransactionDialog(context),
            tooltip: 'Add Transaction',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showBudgetSettingsDialog(context),
            tooltip: 'Budget Settings',
          ),
        ],
      ),
      body: Consumer<BudgetService>(
        builder: (context, budgetService, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBalanceOverview(context, budgetService),
                const SizedBox(height: 24),
                _buildBudgetSummaryCards(context, budgetService),
                const SizedBox(height: 24),
                _buildBudgetCategoriesSection(context, budgetService),
                const SizedBox(height: 24),
                _buildRecentTransactionsSection(context, budgetService),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBalanceOverview(
    BuildContext context,
    BudgetService budgetService,
  ) {
    return Card(
      elevation: 0,
      color: Colors.white,
      borderOnForeground: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[300]!, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Current Balance',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              _formatCurrency(budgetService.currentBalance),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 31, 95, 92),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryCard(
                  title: 'Income',
                  amount: budgetService.totalIncome,
                  color: Colors.green,
                  icon: Icons.arrow_downward,
                ),
                _buildSummaryCard(
                  title: 'Expenses',
                  amount: budgetService.totalExpenses,
                  color: Colors.red,
                  icon: Icons.arrow_upward,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required double amount,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withAlpha((255 * 0.1).round()),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          _formatCurrency(amount),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetSummaryCards(
    BuildContext context,
    BudgetService budgetService,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSummaryTile(
            title: 'Budget',
            value: budgetService.totalAllocated,
            color: Colors.blue,
          ),
          _buildSummaryTile(
            title: 'Spent',
            value: budgetService.totalSpent,
            color: Colors.orange,
          ),
          _buildSummaryTile(
            title: 'Remaining',
            value: budgetService.totalRemaining,
            color:
                budgetService.totalRemaining >= 0 ? Colors.green : Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryTile({
    required String title,
    required double value,
    required Color color,
  }) {
    return Card(
      color: Colors.white,
      borderOnForeground: true,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[300]!, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text(
              _formatCurrency(value),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetCategoriesSection(
    BuildContext context,
    BudgetService budgetService,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Budget Categories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed:
                  () => _showEditCategoriesDialog(context, budgetService),
              child: const Text('Edit'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          margin: EdgeInsets.all(0),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey[300]!, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children:
                  budgetService.categories.map((category) {
                    final percentage = _calculatePercentage(
                      category.spent,
                      category.allocated,
                    );
                    final remaining = category.allocated - category.spent;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                category.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${_formatCurrency(category.spent)} / ${_formatCurrency(category.allocated)}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color:
                                      percentage > 1 ? Colors.red : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: percentage > 1 ? 1 : percentage,
                            backgroundColor: Colors.grey[200],
                            color: percentage > 1 ? Colors.red : category.color,
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${(percentage * 100).toStringAsFixed(0)}%',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                remaining < 0
                                    ? 'Overspent: ${_formatCurrency(remaining.abs())}'
                                    : 'Remaining: ${_formatCurrency(remaining)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      remaining < 0 ? Colors.red : Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTransactionsSection(
    BuildContext context,
    BudgetService budgetService,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Transactions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          margin: EdgeInsets.all(0),
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey[300]!, width: 1.0),
          ),
          child: Column(
            children: [
              ...budgetService.recentTransactions.map((transaction) {
                final isIncome = transaction.amount > 0;

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isIncome ? Colors.green[50] : Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                      color: isIncome ? Colors.green : Colors.red,
                    ),
                  ),
                  title: Text(
                    transaction.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${transaction.category} • ${DateFormat('MMM d, h:mm a').format(transaction.date)}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  trailing: Text(
                    _formatCurrency(transaction.amount.abs()),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isIncome ? Colors.green : Colors.red,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  void _showAddTransactionDialog(BuildContext context) {
    final budgetService = Provider.of<BudgetService>(context, listen: false);
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    String selectedCategory =
        budgetService.categories.isNotEmpty
            ? budgetService.categories.first.name
            : 'Uncategorized';
    bool isIncome = false;
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              surfaceTintColor: Colors.white,
              title: const Text('Add New Transaction'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Title*',
                          hintText: 'e.g. Grocery Shopping',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: amountController,
                        decoration: const InputDecoration(
                          labelText: 'Amount*',
                          prefixText: 'ETB ',
                          hintText: '0.00',
                        ),
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an amount';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Amount must be positive';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: Text(
                          isIncome ? 'Income' : 'Expense',
                          style: TextStyle(
                            color: isIncome ? Colors.green : Colors.red,
                          ),
                        ),
                        value: isIncome,
                        onChanged: (value) {
                          setState(() {
                            isIncome = value;
                            if (isIncome) {
                              selectedCategory = 'Income';
                            } else if (budgetService.categories.isNotEmpty) {
                              selectedCategory =
                                  budgetService.categories.first.name;
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Category*',
                        ),
                        items: [
                          if (isIncome)
                            const DropdownMenuItem<String>(
                              value: 'Income',
                              child: Text('Income'),
                            )
                          else
                            ...budgetService.categories.map((category) {
                              return DropdownMenuItem<String>(
                                value: category.name,
                                child: Text(category.name),
                              );
                            }),
                          if (!isIncome && budgetService.categories.isEmpty)
                            const DropdownMenuItem<String>(
                              value: 'Uncategorized',
                              child: Text('Uncategorized'),
                            ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedCategory = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (date != null) {
                            setState(() {
                              selectedDate = date;
                            });
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(labelText: 'Date*'),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(DateFormat('MMM d, y').format(selectedDate)),
                              const Icon(Icons.calendar_today, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final amount = double.parse(amountController.text);
                      final newTransaction = Transaction(
                        title: titleController.text,
                        amount: isIncome ? amount : -amount,
                        category: selectedCategory,
                        date: selectedDate,
                      );

                      budgetService.addTransaction(newTransaction);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Add Transaction'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditCategoriesDialog(
    BuildContext context,
    BudgetService budgetService,
  ) {
    final categoryControllers =
        budgetService.categories
            .map(
              (c) =>
                  TextEditingController(text: c.allocated.toStringAsFixed(2)),
            )
            .toList();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          surfaceTintColor: Colors.white,
          title: const Text('Edit Budget Categories'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Available Balance: ${_formatCurrency(budgetService.currentBalance)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Total Allocated: ${_formatCurrency(budgetService.totalAllocated)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        budgetService.totalAllocated >
                                budgetService.currentBalance
                            ? Colors.red
                            : Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                ...budgetService.categories.asMap().entries.map((entry) {
                  final index = entry.key;
                  final category = entry.value;
                  final maxAllowed = budgetService.getMaxAllowedAllocation(
                    index,
                    category.allocated,
                  );

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: category.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            category.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 150,
                          child: TextFormField(
                            controller: categoryControllers[index],
                            decoration: InputDecoration(
                              prefixText: 'ETB ',
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              suffixIcon: Tooltip(
                                message: 'Max: ${_formatCurrency(maxAllowed)}',
                                child: const Icon(Icons.info_outline, size: 18),
                              ),
                            ),
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Invalid';
                              }
                              if (double.parse(value) < 0) {
                                return 'Must be ≥ 0';
                              }
                              if (double.parse(value) > maxAllowed) {
                                return 'Exceeds limit';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed:
                      () => _showAddCategoryDialog(context, budgetService),
                  child: const Text('Add New Category'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                bool isValid = true;
                double newTotalAllocation = 0;

                // First pass: validate all inputs
                for (var controller in categoryControllers) {
                  if (double.tryParse(controller.text) == null) {
                    isValid = false;
                    break;
                  }
                  newTotalAllocation += double.parse(controller.text);
                }

                if (!isValid) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please enter valid amounts for all categories',
                      ),
                    ),
                  );
                  return;
                }

                // Check if total allocation exceeds balance
                if (newTotalAllocation > budgetService.currentBalance) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Total budget cannot exceed available balance of ${_formatCurrency(budgetService.currentBalance)}',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // Second pass: update allocations
                for (int i = 0; i < budgetService.categories.length; i++) {
                  budgetService.updateCategoryAllocation(
                    i,
                    double.parse(categoryControllers[i].text),
                  );
                }
                Navigator.pop(context);
              },
              child: const Text('Save Changes'),
            ),
          ],
        );
      },
    );
  }

  void _showAddCategoryDialog(
    BuildContext context,
    BudgetService budgetService,
  ) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final amountController = TextEditingController(text: '0');
    Color selectedColor = Colors.blue;
    final maxAllowed =
        budgetService.currentBalance - budgetService.totalAllocated;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Category'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Available Budget: ${_formatCurrency(maxAllowed)}',
                    style: TextStyle(
                      color: maxAllowed > 0 ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Category Name*',
                      hintText: 'e.g. Dining Out',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      if (budgetService.categories.any(
                        (c) => c.name == value,
                      )) {
                        return 'Category already exists';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: amountController,
                    decoration: InputDecoration(
                      labelText: 'Budget Amount',
                      prefixText: 'ETB ',
                      hintText: '0.00',
                      suffixIcon: Tooltip(
                        message: 'Max: ${_formatCurrency(maxAllowed)}',
                        child: const Icon(Icons.info_outline, size: 18),
                      ),
                    ),
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return null; // Allow empty (will be treated as 0)
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      if (double.tryParse(value)! < 0) {
                        return 'Amount must be positive';
                      }
                      if (double.tryParse(value)! > maxAllowed) {
                        return 'Exceeds available budget';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<Color>(
                    value: selectedColor,
                    decoration: const InputDecoration(labelText: 'Color*'),
                    items:
                        [
                          Colors.blue,
                          Colors.green,
                          Colors.orange,
                          Colors.purple,
                          Colors.red,
                          Colors.teal,
                          Colors.pink,
                        ].map((color) {
                          return DropdownMenuItem<Color>(
                            value: color,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  color.toString().split('.').last,
                                  style: TextStyle(color: color),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        selectedColor = value;
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final amount =
                      amountController.text.isEmpty
                          ? 0.0
                          : double.parse(amountController.text);

                  // Check if adding this category would exceed balance
                  if (budgetService.totalAllocated + amount >
                      budgetService.currentBalance) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Adding this category would exceed your available balance',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  budgetService.addCategory(
                    BudgetCategory(
                      name: nameController.text,
                      allocated: amount,
                      spent: 0,
                      color: selectedColor,
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Add Category'),
            ),
          ],
        );
      },
    );
  }

  void _showBudgetSettingsDialog(BuildContext context) {
    Provider.of<BudgetService>(context, listen: false);
    bool notificationsEnabled = true;
    String selectedCurrency = 'ETB (ብር)';
    String selectedPeriod = 'Monthly';
    bool backupEnabled = false;

    final currencies = ['ETB (ብር)', 'USD (\$)', 'EUR (€)', 'GBP (£)'];
    final periods = ['Weekly', 'Monthly', 'Yearly'];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
              backgroundColor: Colors.white,
              child: Container(
                constraints: BoxConstraints(maxWidth: 500),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.settings, color: Colors.black87),
                          SizedBox(width: 12),
                          Text(
                            'Budget Settings',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildWhiteSettingItem(
                            icon: Icons.notifications_outlined,
                            title: 'Notifications',
                            subtitle: 'Receive budget alerts',
                            trailing: Switch(
                              value: notificationsEnabled,
                              onChanged:
                                  (value) => setState(
                                    () => notificationsEnabled = value,
                                  ),
                              activeColor: Colors.blue,
                            ),
                          ),

                          _buildWhiteSettingItem(
                            icon: Icons.currency_exchange_outlined,
                            title: 'Currency',
                            trailing: DropdownButton<String>(
                              value: selectedCurrency,
                              underline: Container(),
                              style: TextStyle(color: Colors.black87),
                              items:
                                  currencies.map((currency) {
                                    return DropdownMenuItem<String>(
                                      value: currency,
                                      child: Text(currency),
                                    );
                                  }).toList(),
                              onChanged:
                                  (value) =>
                                      setState(() => selectedCurrency = value!),
                            ),
                          ),

                          _buildWhiteSettingItem(
                            icon: Icons.calendar_today_outlined,
                            title: 'Budget Period',
                            trailing: DropdownButton<String>(
                              value: selectedPeriod,
                              underline: Container(),
                              style: TextStyle(color: Colors.black87),
                              items:
                                  periods.map((period) {
                                    return DropdownMenuItem<String>(
                                      value: period,
                                      child: Text(period),
                                    );
                                  }).toList(),
                              onChanged:
                                  (value) =>
                                      setState(() => selectedPeriod = value!),
                            ),
                          ),

                          _buildWhiteSettingItem(
                            icon: Icons.backup_outlined,
                            title: 'Auto Backup',
                            subtitle: 'Backup data weekly',
                            trailing: Switch(
                              value: backupEnabled,
                              onChanged:
                                  (value) =>
                                      setState(() => backupEnabled = value),
                              activeColor: Colors.blue,
                            ),
                          ),

                          _buildWhiteSettingItem(
                            icon: Icons.upload_outlined,
                            title: 'Export Data',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Export functionality coming soon',
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          ),

                          _buildWhiteSettingItem(
                            icon: Icons.download_outlined,
                            title: 'Import Data',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Import functionality coming soon',
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    // Footer
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'CANCEL',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              // Save settings
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Settings saved'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            child: Text(
                              'SAVE',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildWhiteSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade100, width: 1),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.black54),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  String _formatCurrency(double amount) {
    return '${NumberFormat('#,##0.00').format(amount)} ETB ';
  }

  double _calculatePercentage(double spent, double allocated) {
    if (allocated == 0) return 0.0;
    return spent / allocated;
  }
}
