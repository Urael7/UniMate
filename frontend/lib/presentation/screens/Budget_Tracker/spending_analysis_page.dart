import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:frontend/presentation/screens/Budget_Tracker/transaction_model.dart';
import 'package:intl/intl.dart';

class SpendingAnalysisPage extends StatefulWidget {
  const SpendingAnalysisPage({super.key});

  @override
  _SpendingAnalysisPageState createState() => _SpendingAnalysisPageState();
}

class _SpendingAnalysisPageState extends State<SpendingAnalysisPage> {
  String _selectedFilter = 'Monthly';

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionModel>(
      builder: (context, model, child) {
        // Calculate weekly and monthly spending data from transactions
        final now = DateTime.now();
        final List<double> weeklySpendingData = List.filled(
          21,
          0.0,
        ); // 3 weeks (21 days)
        final List<double> monthlySpendingData = List.filled(
          12,
          0.0,
        ); // 3 months (12 weeks)

        // Process each transaction for the line chart
        for (int i = 0; i < model.transactions.length; i++) {
          final tx = model.transactions[i];
          if (!tx["isIncome"]) {
            DateTime date;
            try {
              // Handle both ISO 8601 (yyyy-MM-dd) and MMMd (Apr 12) formats
              if (tx["date"].contains('-')) {
                date = DateTime.parse(tx["date"]);
              } else {
                date = DateFormat.MMMd().parse(tx["date"]);
              }
            } catch (e) {
              // Fallback to current date if parsing fails
              date = now;
            }

            final amount =
                double.tryParse(
                  tx["amount"].replaceAll(RegExp(r'[^\d.]'), ''),
                ) ??
                0;

            // Map transactions to the 21-day window for weekly chart
            final dayIndex =
                (model.transactions.length - 1 - i) %
                21; // Cycle through 21 days
            final simulatedDate = now.subtract(Duration(days: dayIndex));
            final simulatedDayOfWeek =
                simulatedDate.weekday - 1; // 0 (Mon) to 6 (Sun)
            final weekOffset =
                (dayIndex ~/ 7) * 7; // Offset for each week (0, 7, 14)
            final weeklyIndex =
                weekOffset + simulatedDayOfWeek; // Position in 21-day array

            if (weeklyIndex >= 0 && weeklyIndex < 21) {
              weeklySpendingData[weeklyIndex] += amount;
            }

            // Monthly data (last 12 weeks, grouped by 4 weeks)
            final weekIndex =
                (model.transactions.length - 1 - i) %
                12; // Cycle through 12 weeks
            if (weekIndex >= 0 && weekIndex < 12) {
              monthlySpendingData[weekIndex] += amount;
            }
          }
        }

        // Calculate top categories for the pie chart
        final Map<String, double> transactionData = {};
        for (var tx in model.transactions) {
          if (!tx["isIncome"]) {
            final title = tx["title"];
            final amount =
                double.tryParse(
                  tx["amount"].replaceAll(RegExp(r'[^\d.]'), ''),
                ) ??
                0;
            transactionData[title] = (transactionData[title] ?? 0) + amount;
          }
        }

        // Select data based on filter for the line chart
        final isWeekly = _selectedFilter == 'Weekly';
        final List<double> spendingData =
            isWeekly ? weeklySpendingData : monthlySpendingData;
        final List<String> bottomLabels =
            isWeekly
                ? [
                  'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun', // Past week
                  'Mon',
                  'Tue',
                  'Wed',
                  'Thu',
                  'Fri',
                  'Sat',
                  'Sun', // Current week
                  'Mon',
                  'Tue',
                  'Wed',
                  'Thu',
                  'Fri',
                  'Sat',
                  'Sun', // Future week
                ]
                : [
                  'W1', 'W2', 'W3', 'W4', // Past 2 months
                  'W1', 'W2', 'W3', 'W4', // Current month
                  'W1', 'W2', 'W3', 'W4', // Future month
                ];

        // Calculate total spending for percentage calculation in the pie chart
        double totalSpending =
            transactionData.isNotEmpty
                ? transactionData.values.reduce((a, b) => a + b)
                : 0.0;

        // Colors for each category in the pie chart
        final Map<String, Color> categoryColors = {
          'Netflix': Colors.blueAccent,
          'Grocery Store': Colors.green,
          'Food': Colors.orange,
          'Others': Colors.grey,
        };

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              'Spending Analysis',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  children:
                      ['Weekly', 'Monthly'].map((label) {
                        final selected = label == _selectedFilter;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedFilter = label;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color:
                                    selected
                                        ? Colors.blueAccent
                                        : Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  label,
                                  style: TextStyle(
                                    color:
                                        selected ? Colors.white : Colors.black,
                                    fontWeight:
                                        selected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
                const SizedBox(height: 24),
                Text(
                  isWeekly ? 'Weekly Spending' : 'Monthly Spending',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                AspectRatio(
                  aspectRatio: 1.7,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width:
                          spendingData.length *
                          50.0, // Adjust width based on data length
                      child: LineChart(
                        LineChartData(
                          lineTouchData: LineTouchData(enabled: false),
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 100,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    value.toInt().toString(),
                                    style: const TextStyle(fontSize: 12),
                                  );
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final index = value.toInt();
                                  if (index >= 0 &&
                                      index < bottomLabels.length) {
                                    return Text(
                                      bottomLabels[index],
                                      style: const TextStyle(fontSize: 12),
                                    );
                                  }
                                  return const Text('');
                                },
                                interval: 1,
                              ),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          minX: 0,
                          maxX: spendingData.length - 1,
                          minY: 0,
                          maxY: 500,
                          lineBarsData: [
                            LineChartBarData(
                              spots:
                                  spendingData.asMap().entries.map((entry) {
                                    return FlSpot(
                                      entry.key.toDouble(),
                                      entry.value,
                                    );
                                  }).toList(),
                              isCurved: true,
                              color: Colors.blueAccent,
                              barWidth: 4,
                              dotData: FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                color: Colors.blueAccent.withOpacity(0.2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Top Categories',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    key: ValueKey(
                      model.transactions.length,
                    ), // Force rebuild when transactions change
                    itemCount: transactionData.length,
                    itemBuilder: (context, index) {
                      final category = transactionData.keys.toList()[index];
                      final amount = transactionData[category]!;
                      final percentage =
                          totalSpending != 0
                              ? (amount / totalSpending) * 100
                              : 0.0;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: PieChart(
                                PieChartData(
                                  sections: [
                                    PieChartSectionData(
                                      color:
                                          categoryColors[category] ??
                                          Colors.grey,
                                      value: percentage,
                                      title: '',
                                      radius: 10,
                                    ),
                                    PieChartSectionData(
                                      color: Colors.grey.withOpacity(0.2),
                                      value: 100 - percentage,
                                      title: '',
                                      radius: 10,
                                    ),
                                  ],
                                  sectionsSpace: 0,
                                  centerSpaceRadius: 15,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    category,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    '%${percentage.toInt()} of total',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
