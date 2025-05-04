import 'package:flutter/material.dart';
import 'package:frontend/presentation/screens/dashboard/dashboard.dart';
import 'package:frontend/presentation/screens/dashboard/assignments.dart';
import 'package:intl/intl.dart';

class ClassSchedulePage extends StatefulWidget {
  @override
  _ClassSchedulePageState createState() => _ClassSchedulePageState();
}

class _ClassSchedulePageState extends State<ClassSchedulePage> {
  DateTime startDate = DateTime(
    2025,
    4,
    21,
  ); // Starting date (Monday, April 21, 2025)

  void _previousWeek() {
    setState(() {
      startDate = startDate.subtract(Duration(days: 7));
    });
  }

  void _nextWeek() {
    setState(() {
      startDate = startDate.add(Duration(days: 7));
    });
  }

  String _formatDateRange() {
    DateTime endDate = startDate.add(Duration(days: 6));
    String start = DateFormat('MMMM d').format(startDate);
    String end = DateFormat('MMMM d, yyyy').format(endDate);
    return 'Today  $start - $end';
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
                'Class Schedule',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('View your weekly class schedule.'),
            ),
            Container(
              margin: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left),
                    onPressed: _previousWeek,
                  ),
                  Text(_formatDateRange()),
                  IconButton(
                    icon: Icon(Icons.chevron_right),
                    onPressed: _nextWeek,
                  ),
                ],
              ),
            ),
            // Simplified Schedule Grid using Column and Row, now horizontally scrollable
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    // Header Row
                    Row(
                      children: [
                        _buildScheduleCell('', true),
                        _buildScheduleCell(
                          'Monday\n${DateFormat('MMM d').format(startDate)}',
                          true,
                        ),
                        _buildScheduleCell(
                          'Tuesday\n${DateFormat('MMM d').format(startDate.add(Duration(days: 1)))}',
                          true,
                        ),
                        _buildScheduleCell(
                          'Wednesday\n${DateFormat('MMM d').format(startDate.add(Duration(days: 2)))}',
                          true,
                        ),
                        _buildScheduleCell(
                          'Thursday\n${DateFormat('MMM d').format(startDate.add(Duration(days: 3)))}',
                          true,
                        ),
                        _buildScheduleCell(
                          'Friday\n${DateFormat('MMM d').format(startDate.add(Duration(days: 4)))}',
                          true,
                        ),
                        _buildScheduleCell(
                          'Saturday\n${DateFormat('MMM d').format(startDate.add(Duration(days: 5)))}',
                          true,
                        ),
                        _buildScheduleCell(
                          'Sunday\n${DateFormat('MMM d').format(startDate.add(Duration(days: 6)))}',
                          true,
                        ),
                      ],
                    ),
                    // Time Slots
                    _buildScheduleRow(
                      '8:00 AM',
                      [
                        '',
                        '',
                        'Mathematics\nRoom 201\nDr. Smith',
                        '',
                        'Physics\nLab 101\nProf. Newton',
                        '',
                        '',
                      ],
                      [
                        Colors.white,
                        Colors.white,
                        Colors.lightBlue.shade100,
                        Colors.white,
                        Colors.green.shade100,
                        Colors.white,
                        Colors.white,
                      ],
                    ),
                    _buildScheduleRow(
                      '9:00 AM',
                      [
                        'Mathematics\nRoom 202\nDr. Smith',
                        'Computer Science\nLab 301\nDr. Turing',
                        'Mathematics\nRoom 201\nDr. Smith',
                        'Computer Science\nLab 301\nDr. Turing',
                        '',
                        '',
                        '',
                      ],
                      [
                        Colors.lightBlue.shade100,
                        Colors.purple.shade100,
                        Colors.lightBlue.shade100,
                        Colors.purple.shade100,
                        Colors.white,
                        Colors.white,
                        Colors.white,
                      ],
                    ),
                    _buildScheduleRow(
                      '10:00 AM',
                      [
                        'Physics\nLab 101\nProf. Newton',
                        'English Literature\nRoom 103\nDr. Davis',
                        '',
                        'English Literature\nRoom 103\nDr. Davis',
                        'Biology\nRoom 204\nDr. Darwin',
                        '',
                        '',
                      ],
                      [
                        Colors.green.shade100,
                        Colors.red.shade100,
                        Colors.white,
                        Colors.red.shade100,
                        Colors.blue.shade100,
                        Colors.white,
                        Colors.white,
                      ],
                    ),
                    _buildScheduleRow(
                      '11:00 AM',
                      [
                        'Physics\nLab 101\nProf. Newton',
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                      ],
                      [
                        Colors.green.shade100,
                        Colors.white,
                        Colors.white,
                        Colors.white,
                        Colors.white,
                        Colors.white,
                        Colors.white,
                      ],
                    ),
                    _buildScheduleRow(
                      '12:00 PM',
                      ['', '', '', '', '', '', ''],
                      [
                        Colors.white,
                        Colors.white,
                        Colors.white,
                        Colors.white,
                        Colors.white,
                        Colors.white,
                        Colors.white,
                      ],
                    ),
                    _buildScheduleRow(
                      '1:00 PM',
                      [
                        '',
                        'English Literature\nRoom 103\nDr. Davis',
                        '',
                        '',
                        'History\nRoom 305\nProf. Orwell',
                        '',
                        '',
                      ],
                      [
                        Colors.white,
                        Colors.red.shade100,
                        Colors.white,
                        Colors.white,
                        Colors.yellow.shade100,
                        Colors.white,
                        Colors.white,
                      ],
                    ),
                    _buildScheduleRow(
                      '2:00 PM',
                      [
                        'History\nRoom 305\nProf. Orwell',
                        'English Literature\nRoom 103\nDr. Davis',
                        '',
                        '',
                        '',
                        '',
                        '',
                      ],
                      [
                        Colors.yellow.shade100,
                        Colors.red.shade100,
                        Colors.white,
                        Colors.white,
                        Colors.white,
                        Colors.white,
                        Colors.white,
                      ],
                    ),
                    _buildScheduleRow(
                      '3:00 PM',
                      [
                        'History\nRoom 305\nProf. Orwell',
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                      ],
                      [
                        Colors.yellow.shade100,
                        Colors.white,
                        Colors.white,
                        Colors.white,
                        Colors.white,
                        Colors.white,
                        Colors.white,
                      ],
                    ),
                    _buildScheduleRow(
                      '4:00 PM',
                      ['', '', '', '', '', '', ''],
                      [
                        Colors.white,
                        Colors.white,
                        Colors.white,
                        Colors.white,
                        Colors.white,
                        Colors.white,
                        Colors.white,
                      ],
                    ),
                    _buildScheduleRow(
                      '5:00 PM',
                      ['', '', '', 'Biology\nRoom 204\nDr. Darwin', '', '', ''],
                      [
                        Colors.white,
                        Colors.white,
                        Colors.white,
                        Colors.blue.shade100,
                        Colors.white,
                        Colors.white,
                        Colors.white,
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Subjects',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              child: Wrap(
                spacing: 8.0,
                children: [
                  _buildSubjectChip(Colors.lightBlue.shade100, 'Mathematics'),
                  _buildSubjectChip(Colors.green.shade100, 'Physics'),
                  _buildSubjectChip(Colors.purple.shade100, 'Computer Science'),
                  _buildSubjectChip(Colors.yellow.shade100, 'History'),
                  _buildSubjectChip(Colors.red.shade100, 'English Literature'),
                  _buildSubjectChip(Colors.blue.shade100, 'Biology'),
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

  Widget _buildScheduleCell(String text, bool isHeader) {
    return Container(
      width: 100.0, // Fixed width for each cell
      height: 60.0,
      margin: EdgeInsets.all(1.0),
      padding: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: isHeader ? Colors.grey.shade300 : Colors.white,
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleRow(
    String time,
    List<String> cells,
    List<Color> colors,
  ) {
    return Row(
      children: [
        _buildScheduleCell(time, false),
        for (int i = 0; i < 7; i++)
          Container(
            width: 100.0, // Fixed width for each cell
            height: 60.0,
            margin: EdgeInsets.all(1.0),
            padding: EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: cells[i].isEmpty ? Colors.white : colors[i],
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: Center(
              child: Text(
                cells[i],
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSubjectChip(Color color, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(label),
    );
  }
}
