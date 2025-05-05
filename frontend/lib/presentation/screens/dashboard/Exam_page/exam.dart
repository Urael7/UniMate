import 'package:flutter/material.dart';
import '../profile.dart'; // Import ProfilePage
import '../../Budget_Tracker/budget_home_page.dart'; // Import BudgetScreen
import '../logout/logout.dart'; // Import LogoutPage
import '../resource.dart'; // Import ResourcePage

class ExamPage extends StatelessWidget {
  const ExamPage({super.key});

  @override
  Widget build(BuildContext context) {
    final exams = [
      {
        'subject': 'Mathematics',
        'date': 'Wed, March 25, 2025',
        'time': '9:00 AM - 11:00 AM',
        'location': 'Block 57',
        'teacher': 'Dr. Alex',
        'topic': 'Chapter 1-2',
      },
      {
        'subject': 'Physics',
        'date': 'Thu, March 26, 2025',
        'time': '1:00 PM - 3:00 PM',
        'location': 'Block 42',
        'teacher': 'Dr. Smith',
        'topic': 'Chapter 3-4',
      },
      {
        'subject': 'Chemistry',
        'date': 'Fri, March 27, 2025',
        'time': '10:00 AM - 12:00 PM',
        'location': 'Block 12',
        'teacher': 'Dr. Johnson',
        'topic': 'Chapter 5-6',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6), // Body background color
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Close Icon
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the drawer
                    },
                  ),
                ],
              ),
            ),
            const Divider(),

            // Menu Items
            ListTile(
              leading: const Icon(Icons.home, color: Colors.blue),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Handle Dashboard navigation
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.blue),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                ); // Navigate to ProfilePage
              },
            ),
            ListTile(
              leading: const Icon(Icons.attach_money, color: Colors.blue),
              title: const Text('Budget Tracker'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BudgetScreen()),
                ); // Navigate to BudgetScreen
              },
            ),
            ListTile(
              leading: const Icon(Icons.description, color: Colors.blue),
              title: const Text('Assignments'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Handle Assignments navigation
              },
            ),
            ListTile(
              leading: const Icon(Icons.school, color: Colors.blue),
              title: const Text('Exams'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ExamPage()),
                ); // Navigate to ExamPage
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications, color: Colors.blue),
              title: const Text('Notifications'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Handle Notifications navigation
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder, color: Colors.blue),
              title: const Text('Resources'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ResourcePage()),
                ); // Navigate to ResourcePage
              },
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LogoutPage()),
                ); // Navigate to LogoutPage
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Row(
          children: [
            const Text(
              'Unimate',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            const CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage('assets/profile.jpg'),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exam Header
            const Text(
              'Exam Timetable',
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'View your upcoming exams and prepare accordingly',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280), // Silver color
              ),
            ),
            const SizedBox(height: 16),

            // Search and Filter Card
            Card(
              color: Colors.white,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Search Bar
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Search exams...',
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Filter Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                          label: const Text(
                            'All Subjects',
                            style: TextStyle(color: Colors.grey),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.grey),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.calendar_today, color: Colors.blue),
                          label: const Text(
                            'List',
                            style: TextStyle(color: Colors.blue),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Exam Cards
            ...exams.map((exam) {
              return Card(
                color: Colors.white,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exam['subject']!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(exam['date']!, style: const TextStyle(color: Colors.black54)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 16, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(exam['time']!, style: const TextStyle(color: Colors.black54)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(exam['location']!, style: const TextStyle(color: Colors.black54)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.person, size: 16, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(exam['teacher']!, style: const TextStyle(color: Colors.black54)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Topic',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          exam['topic']!,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}