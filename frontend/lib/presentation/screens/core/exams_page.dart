import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'models.dart'; 

class ExamsPage extends StatelessWidget {
   ExamsPage({super.key});

  final List<Exam> allExams = [
    Exam(
      id: '1',
      subject: 'Linear Algebra',
      dateTime: DateTime(2025, 5, 20, 9, 0),
      room: 'Exam Hall B',
      type: 'Midterm',
    ),
    Exam(
      id: '2',
      subject: 'Mobile Development',
      dateTime: DateTime(2025, 5, 28, 14, 0),
      room: 'Lab 404',
      type: 'Practical Exam',
    ),
    Exam(
      id: '3',
      subject: 'World History',
      dateTime: DateTime(2025, 6, 2, 11, 0),
      room: 'Auditorium A',
      type: 'Final',
    ),
    Exam(
      id: '4',
      subject: 'Calculus II',
      dateTime: DateTime(2025, 6, 5, 9, 0),
      room: 'Exam Hall C',
      type: 'Final',
    ),
    Exam(
      id: '5',
      subject: 'Data Structures',
      dateTime: DateTime(2025, 6, 9, 13, 0),
      room: 'Lab 101',
      type: 'Final',
    ),
  ];
 

  @override
  Widget build(BuildContext context) {

    allExams.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    final dashboardHelper = DashboardPage();

    if (allExams.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            'No exams scheduled at the moment.',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: allExams.length,
      itemBuilder: (context, index) {
        return dashboardHelper.buildExamItem(context, allExams[index]);
      },
    );
  }
}
