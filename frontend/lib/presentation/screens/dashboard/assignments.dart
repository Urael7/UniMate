import 'package:flutter/material.dart';
import 'package:frontend/presentation/screens/dashboard/dashboard.dart';
import 'package:frontend/presentation/screens/dashboard/class_schedule.dart';

class AssignmentsPage extends StatefulWidget {
  @override
  _AssignmentsPageState createState() => _AssignmentsPageState();
}

class _AssignmentsPageState extends State<AssignmentsPage> {
  // List of assignments with their initial status
  final List<Map<String, dynamic>> _assignments = [
    {
      'title': 'Lab Report',
      'subject': 'Physics',
      'status': 'Overdue',
      'dueDate': '10/5/2023',
      'description': 'Complete the lab report for Experiment 3.',
      'highPriority': true,
    },
    {
      'title': 'Research Paper',
      'subject': 'History',
      'status': 'Completed',
      'dueDate': '10/10/2023',
      'description': 'Write a 5-page paper on the Industrial Revolution.',
      'highPriority': false,
    },
    {
      'title': 'Calculus Problem Set',
      'subject': 'Mathematics',
      'status': 'Pending',
      'dueDate': '10/15/2023',
      'description': 'Complete problems 1-20 in Chapter 4.',
      'highPriority': false,
    },
    {
      'title': 'Midterm Study Guide',
      'subject': 'Mathematics',
      'status': 'Pending',
      'dueDate': '10/18/2023',
      'description': 'Complete the study guide for the midterm exam.',
      'highPriority': true,
    },
    {
      'title': 'Programming Project',
      'subject': 'Computer Science',
      'status': 'Pending',
      'dueDate': '10/20/2023',
      'description': 'Build a simple web application using React.',
      'highPriority': true,
    },
    {
      'title': 'Book Analysis',
      'subject': 'English Literature',
      'status': 'Pending',
      'dueDate': '10/25/2023',
      'description': 'Write a 3-page analysis of the assigned novel.',
      'highPriority': false,
    },
    {
      'title': 'Group Presentation',
      'subject': 'Biology',
      'status': 'Pending',
      'dueDate': '11/5/2023',
      'description':
          'Prepare a 15-minute presentation on cellular respiration.',
      'highPriority': false,
    },
  ];

  void _toggleAssignmentStatus(int index) {
    setState(() {
      if (_assignments[index]['status'] == 'Completed') {
        _assignments[index]['status'] = 'Pending';
      } else if (_assignments[index]['status'] != 'Overdue') {
        _assignments[index]['status'] = 'Completed';
      }
    });
  }

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
              child: Text(
                'Assignments',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Track and manage your assignments.'),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search assignments...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      items:
                          <String>[
                                'All Status',
                                'Pending',
                                'Completed',
                                'Overdue',
                              ]
                              .map(
                                (String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                ),
                              )
                              .toList(),
                      onChanged: (_) {},
                      value: 'All Status',
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      items:
                          <String>[
                                'All Subjects',
                                'Mathematics',
                                'Physics',
                                'Computer Science',
                                'History',
                                'English Literature',
                                'Biology',
                              ]
                              .map(
                                (String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                ),
                              )
                              .toList(),
                      onChanged: (_) {},
                      value: 'All Subjects',
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      items:
                          <String>['Due Date', 'A-Z', 'Z-A']
                              .map(
                                (String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                ),
                              )
                              .toList(),
                      onChanged: (_) {},
                      value: 'Due Date',
                    ),
                  ),
                ],
              ),
            ),
            for (int i = 0; i < _assignments.length; i++)
              _buildAssignmentCard(
                _assignments[i]['title'],
                _assignments[i]['subject'],
                _assignments[i]['status'],
                _assignments[i]['dueDate'],
                _assignments[i]['description'],
                _assignments[i]['highPriority'],
                i,
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

  Widget _buildAssignmentCard(
    String title,
    String subject,
    String status,
    String dueDate,
    String description,
    bool highPriority,
    int index,
  ) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: CheckboxListTile(
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subject),
            Text(highPriority ? 'High' : 'Medium'),
            Text('Due: $dueDate'),
            Text(description),
          ],
        ),
        value: status == 'Completed',
        onChanged: (bool? value) {
          _toggleAssignmentStatus(index);
        },
        secondary: Container(
          padding: EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color:
                status == 'Overdue'
                    ? Colors.red.shade100
                    : status == 'Completed'
                    ? Colors.green.shade100
                    : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(status),
        ),
      ),
    );
  }
}
