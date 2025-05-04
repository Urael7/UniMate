import 'package:flutter/material.dart';
import 'edit_profile.dart'; // Import the EditProfilePage
import '../Budget_Tracker/budget_home_page.dart'; // Import BudgetScreen
import '../logout/logout.dart'; // Import LogoutPage

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              leading: const Icon(Icons.schedule, color: Colors.blue),
              title: const Text('Class Schedule'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Handle Class Schedule navigation
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
                // Handle Exams navigation
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
                // Handle Resources navigation
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
            const Text(
              'Profile',
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Manage your personal information and preference',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 16),

            // Full-width centered profile card
            SizedBox(
              width: double.infinity,
              child: Card(
                color: const Color(0xFFEFF6FF),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage('assets/profile.jpg'),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'John Doe',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Computer Science, Junior',
                        style: TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Student ID: 123456789',
                        style: TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          side: const BorderSide(color: Colors.black12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const EditProfilePage()),
                          );
                        },
                        child: const Text('Edit Profile'),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Combined Personal, Academic Info, and Bio Card
            Card(
              color: Colors.white,
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Personal Information',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: const [
                        Icon(Icons.email, color: Colors.black54),
                        SizedBox(width: 8),
                        Text('Email'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text('student@example.com', style: TextStyle(color: Colors.black87)),
                    const SizedBox(height: 12),
                    Row(
                      children: const [
                        Icon(Icons.phone, color: Colors.black54),
                        SizedBox(width: 8),
                        Text('Phone'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text('+251 905783838', style: TextStyle(color: Colors.black87)),

                    const SizedBox(height: 16),

                    // Academic Info
                    const Text(
                      'Academic Information',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: const [
                        Icon(Icons.book, color: Colors.black54),
                        SizedBox(width: 8),
                        Text('Major: Computer Science'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text('Year: Junior', style: TextStyle(color: Colors.black87)),

                    const SizedBox(height: 16),

                    // Bio
                    const Text(
                      'Bio',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Computer science student with interest in AI and web development.',
                      style: TextStyle(color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Enrolled Courses Card
            Card(
              color: Colors.white,
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Enrolled Courses',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    const SizedBox(height: 12),
                    ...List.generate(6, (index) {
                      final courses = [
                        'Data Structures',
                        'Algorithms',
                        'Operating Systems',
                        'Artificial Intelligence',
                        'Web Development',
                        'Mobile App Development',
                      ];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                courses[index],
                                style: const TextStyle(color: Colors.black),
                              ),
                              Text(
                                'View Detail',
                                style: TextStyle(color: Colors.blue[700]),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}