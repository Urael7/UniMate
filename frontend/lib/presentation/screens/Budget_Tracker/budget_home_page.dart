import 'package:flutter/material.dart';

class BudgetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hi, John doe",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "march, 2025",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    backgroundImage: AssetImage(
                      'assets/avatar.jpg',
                    ), // Replace with actual image asset
                    radius: 20,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Current Balance",
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
              Text(
                "ETB258,90",
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Monthly Budget",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: 0.7,
                      color: Colors.white,
                      backgroundColor: Colors.white.withOpacity(0.3),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "ETB14,00/ETB2,000",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text("%70", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Recent Transactions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildTransaction(
                "Income from fam",
                "Mar 12",
                "+ETB1,500.00",
                Colors.green,
              ),
              _buildTransaction(
                "Grocery Store",
                "Mar 15",
                "-ETB150.39",
                Colors.red,
              ),
              _buildTransaction("Food", "Mar 12", "-ETB610.00", Colors.red),
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
                // Future home navigation logic or placeholder for dark screen
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Icon(Icons.home),
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/add');
              },
              child: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.add, color: Colors.white),
              ),
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/analysis');
              },
              child: Icon(Icons.bar_chart),
            ),
            label: "",
          ),
        ],
      ),
    );
  }

  Widget _buildTransaction(
    String title,
    String date,
    String amount,
    Color color,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.all(12),
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
              Text(title, style: TextStyle(fontSize: 16)),
              Text(date, style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          Text(amount, style: TextStyle(color: color, fontSize: 16)),
        ],
      ),
    );
  }
}
