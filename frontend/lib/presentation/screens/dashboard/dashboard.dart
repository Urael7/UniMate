import 'package:flutter/material.dart';
import 'package:frontend/presentation/screens/dashboard/class_schedule.dart';
import 'package:frontend/presentation/screens/dashboard/assignments.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UniMate'),
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
        ),
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/Jon_doe.jpg'),
            radius: 16,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Next Class',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        '/class-schedule',
                      );
                    },
                    child: Text('View Schedule'),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(16.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Icon(Icons.access_time),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Mathematics'),
                        Text('9:00 AM - 10:30 AM • Room 202'),
                        Text('Dr. Smith'),
                        Text('Monday, April 21, 2025'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Priority Tasks',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/assignments');
                    },
                    child: Text('View All'),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildTaskCard(
                    'Midterm Study Guide',
                    'Mathematics',
                    50,
                    '10/18/2023',
                    true,
                  ),
                  _buildTaskCard(
                    'Programming Project',
                    'Computer Science',
                    30,
                    '10/20/2023',
                    true,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Upcoming Exams',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(onPressed: () {}, child: Text('View All')),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildExamCard(
                    'Mathematics',
                    'Midterm',
                    '10/25/2023 • 9:00 AM',
                    'Hall A',
                  ),
                  _buildExamCard(
                    'Computer Science',
                    'Final',
                    '11/5/2023 • 2:00 PM',
                    'Lab 201',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Grades',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(onPressed: () {}, child: Text('View All')),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildGradeCard('Physics', 'Lab Report 3', 'A', 95),
                  _buildGradeCard('History', 'Midterm Exam', 'B+', 88),
                  _buildGradeCard(
                    'Computer Science',
                    'Programming Assignment 2',
                    'A-',
                    92,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Student Portal',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/dashboard');
              },
            ),
            ListTile(
              leading: Icon(Icons.schedule),
              title: Text('Class Schedule'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/class-schedule');
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Assignments'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/assignments');
              },
            ),
            ListTile(
              leading: Icon(Icons.event),
              title: Text('Exams'),
              onTap: () {
                Navigator.pop(context); // Close drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
              onTap: () {
                Navigator.pop(context); // Close drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context); // Close drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.folder),
              title: Text('Resources'),
              onTap: () {
                Navigator.pop(context); // Close drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context); // Close drawer
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(
    String title,
    String subject,
    int progress,
    String dueDate,
    bool highPriority,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subject),
            LinearProgressIndicator(value: progress / 100),
            Text('Progress'),
            Text('Due: $dueDate'),
          ],
        ),
        trailing:
            highPriority
                ? Container(
                  padding: EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text('High Priority'),
                )
                : null,
      ),
    );
  }

  Widget _buildExamCard(
    String subject,
    String type,
    String dateTime,
    String location,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        title: Text(subject),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(type), Text(dateTime), Text(location)],
        ),
      ),
    );
  }

  Widget _buildGradeCard(
    String subject,
    String assignment,
    String grade,
    int score,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        title: Text(subject),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(assignment),
            Row(
              children: [
                Text(grade),
                SizedBox(width: 8.0),
                Expanded(child: LinearProgressIndicator(value: score / 100)),
                Text('$score/100'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
