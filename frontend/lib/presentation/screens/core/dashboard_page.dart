import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models.dart';





class DashboardPage extends StatelessWidget {
   DashboardPage({super.key});

  // --- Mock Data
  final ClassInfo nextClass = ClassInfo(
    subject: 'Linear Algebra',
    time: '10:00 AM - 11:30 AM',
    room: 'Room 305',
    professor: 'Dr. Evelyn Reed',
    startsInMinutes: 25,
  );

  final List<Assignment> assignments = [
    Assignment(
      id: '1',
      title: 'Vector Spaces Problem Set',
      subject: 'Linear Algebra',
      dueDate: DateTime(2025, 5, 10),
      status: 'pending',
      progress: 0.65,
      priority: 'high',
    ),
    Assignment(
      id: '2',
      title: 'Flutter UI Challenge',
      subject: 'Mobile Development',
      dueDate: DateTime(2025, 5, 15),
      status: 'pending',
      progress: 0.30,
      priority: 'high',
    ),
    Assignment(
      id: '3',
      title: 'Historical Analysis Essay',
      subject: 'World History',
      dueDate: DateTime(2025, 5, 5),
      status: 'completed',
      progress: 1.0,
      priority: 'medium',
    ),
  ];

  final List<Exam> exams = [
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
  ];


  @override
  Widget build(BuildContext context) {
    // Filter assignments for the dashboard view
    final pendingAssignments =
        assignments.where((a) => a.status == 'pending').take(3).toList();

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildGreeting(context),
        const SizedBox(height: 16),
        _buildNextClassCard(context, nextClass),
        const SizedBox(height: 16),
        _buildSectionHeader(context, 'Priority Tasks', () {
          /* Navigate to Assignments */
        }),
        _buildPriorityTasks(context, pendingAssignments),
        const SizedBox(height: 16),
        _buildSectionHeader(context, 'Upcoming Exams', () {
          /* Navigate to Exams */
        }),
        _buildUpcomingExams(
          context,
          exams.take(2).toList(),
        ), // Show first 2 exams
        // Add more sections like Recent Grades if needed
      ],
    );
  }

  Widget _buildGreeting(BuildContext context) {
    // In a real app, get user's name
    String userName = "Student";
    return Text(
      'Welcome back, $userName!',
      style: Theme.of(
        context,
      ).textTheme.headlineSmall?.copyWith(color: Colors.grey[800]),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    VoidCallback onViewAll,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        TextButton(
          onPressed: onViewAll,
          child: Text(
            'View All',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildNextClassCard(BuildContext context, ClassInfo? klass) {
    if (klass == null)
      return const SizedBox.shrink(); // Handle case where there's no next class

    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 3, // Slightly more prominent
      color: colorScheme.primaryContainer.withOpacity(
        0.6,
      ), // Use theme color container
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              Icons.schedule,
              size: 40,
              color: colorScheme.onPrimaryContainer,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Next Class',
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onPrimaryContainer.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    klass.subject,
                    style: textTheme.titleLarge?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_filled,
                        size: 14,
                        color: colorScheme.onPrimaryContainer.withOpacity(0.9),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        klass.time,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: colorScheme.onPrimaryContainer.withOpacity(0.9),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        klass.room,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    klass.professor,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onPrimaryContainer.withOpacity(0.9),
                    ),
                  ),

                  if (klass.startsInMinutes != null) ...[
                    const SizedBox(height: 8),
                    Chip(
                      avatar: Icon(
                        Icons.timer_outlined,
                        size: 16,
                        color: colorScheme.primary,
                      ),
                      label: Text('Starts in ${klass.startsInMinutes} min'),
                      labelStyle: TextStyle(
                        fontSize: 12,
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                      backgroundColor: colorScheme.primary.withOpacity(0.1),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      visualDensity: VisualDensity.compact,
                      side: BorderSide.none,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityTasks(
    BuildContext context,
    List<Assignment> assignments,
  ) {
    if (assignments.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'No pending assignments. Well done!',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return Column(
      children:
          assignments
              .map((assignment) => buildAssignmentItem(context, assignment))
              .toList(),
    );
  }

  Widget buildAssignmentItem(BuildContext context, Assignment assignment) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isHighPriority = assignment.priority == 'high';
    final daysLeft = assignment.dueDate.difference(DateTime.now()).inDays;
    String dueDateString;
    Color dateColor = textTheme.labelSmall!.color!;

    if (daysLeft < 0) {
      dueDateString = 'Overdue';
      dateColor = colorScheme.error;
    } else if (daysLeft == 0) {
      dueDateString = 'Due Today';
      dateColor = Colors.orange.shade700;
    } else if (daysLeft == 1) {
      dueDateString = 'Due Tomorrow';
      dateColor = Colors.orange.shade700;
    } else {
      dueDateString =
          'Due in $daysLeft days (${formatDate(assignment.dueDate)})';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 10), // Space between items
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    assignment.title,
                    style: textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isHighPriority)
                  Chip(
                    label: const Text('High Priority'),
                    labelStyle: TextStyle(
                      fontSize: 10,
                      color: colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                    backgroundColor: colorScheme.errorContainer.withOpacity(
                      0.5,
                    ),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    side: BorderSide.none,
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(assignment.subject, style: textTheme.bodySmall),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Progress', style: textTheme.labelSmall),
                Text(
                  '${(assignment.progress * 100).toInt()}%',
                  style: textTheme.labelSmall,
                ),
              ],
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: assignment.progress,
              backgroundColor: colorScheme.secondaryContainer,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
              borderRadius: BorderRadius.circular(4), // Rounded progress bar
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: dateColor),
                const SizedBox(width: 4),
                Text(
                  dueDateString,
                  style: textTheme.labelSmall?.copyWith(
                    color: dateColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingExams(BuildContext context, List<Exam> exams) {
    if (exams.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'No upcoming exams scheduled.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return Column(
      children: exams.map((exam) => buildExamItem(context, exam)).toList(),
    );
  }

  Widget buildExamItem(BuildContext context, Exam exam) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final formattedDate = formatDate(exam.dateTime);
    final formattedTime = formatTime(exam.dateTime);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colorScheme.tertiaryContainer,
          child: Icon(
            Icons.description,
            color: colorScheme.onTertiaryContainer,
            size: 20,
          ),
        ),
        title: Text(exam.subject, style: textTheme.titleMedium),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exam.type,
              style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.calendar_month,
                  size: 14,
                  color: textTheme.labelSmall?.color,
                ),
                const SizedBox(width: 4),
                Text(
                  '$formattedDate at $formattedTime',
                  style: textTheme.labelSmall,
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.location_pin,
                  size: 14,
                  color: textTheme.labelSmall?.color,
                ),
                const SizedBox(width: 4),
                Text(exam.room, style: textTheme.labelSmall),
              ],
            ),
          ],
        ),
        isThreeLine: true, // Allows more space for subtitle
      ),
    );
  }
}

String formatDate(DateTime date) {
  return DateFormat('MMM dd, yyyy').format(date); // e.g., Oct 15, 2023
}

String formatTime(DateTime time) {
  return DateFormat('h:mm a').format(time); // e.g., 10:00 AM
}
