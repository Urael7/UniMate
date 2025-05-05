import 'package:flutter/material.dart';
import 'profile.dart'; // Import ProfilePage
import '../Budget_Tracker/budget_home_page.dart'; // Import BudgetScreen
import 'logout/logout.dart'; // Import LogoutPage
import 'upload_resource.dart'; // Import UploadResourcePage

class ResourcePage extends StatelessWidget {
  const ResourcePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD4D4D4), // Set scaffold background color
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
            // Resource Header
            const Text(
              'Resources',
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Access and share study materials and resources',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
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
                        hintText: 'Search resources...',
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
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.grey),
                          ),
                          child: const Text(
                            'All Subjects',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.grey),
                          ),
                          child: const Text(
                            'All Types',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.grey),
                          ),
                          child: const Text(
                            'Upload Date',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Upload Resource Button
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UploadResourcePage(),
                          ),
                        ); // Navigate to UploadResourcePage
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.upload, color: Colors.white),
                      label: const Text(
                        'Upload Resource',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Resource List Card
            Card(
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
                    // Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Name',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Subject',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Resource List
                    ...List.generate(6, (index) {
                      final resources = [
                        {'name': 'Machine Learning', 'subject': 'Artificial Intelligence', 'type': 'pdf'},
                        {'name': 'Data Structures', 'subject': 'Computer Science', 'type': 'doc'},
                        {'name': 'Operating Systems', 'subject': 'Computer Science', 'type': 'pdf'},
                        {'name': 'Web Development', 'subject': 'Software Engineering', 'type': 'doc'},
                        {'name': 'Mobile App Development', 'subject': 'Software Engineering', 'type': 'pdf'},
                        {'name': 'Algorithms', 'subject': 'Computer Science', 'type': 'doc'},
                      ];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  resources[index]['type'] == 'pdf'
                                      ? Icons.picture_as_pdf
                                      : Icons.description,
                                  color: resources[index]['type'] == 'pdf'
                                      ? Colors.red
                                      : Colors.blue,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  resources[index]['name']!,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                            Text(
                              resources[index]['subject']!,
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ],
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