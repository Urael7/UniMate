import 'package:flutter/material.dart';
import 'package:frontend/models/assignment.dart';
import 'package:frontend/models/class.dart';
import 'package:frontend/models/exam.dart';
import 'package:frontend/presentation/screens/core/Assignments/assignment_service.dart';
import 'package:frontend/presentation/screens/core/Assignments/assignments_page.dart';
import 'package:frontend/presentation/screens/core/ClassSchedules/schedule_page.dart';
import 'package:frontend/presentation/screens/core/ClassSchedules/schedule_service.dart';
import 'package:frontend/presentation/screens/core/Exams/exam_service.dart';
import 'package:frontend/presentation/screens/core/Exams/exams_page.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final AssignmentService _assignmentService = AssignmentService();
  final ScheduleService _scheduleService = ScheduleService();
  final ExamService _examService = ExamService();

  List<Class> _todayClasses = [];
  Class? _nextClass;
  List<Exam> _upcomingExams = [];
  List<Assignment> _pendingAssignments = [];

  @override
  void initState() {
    super.initState();

    _assignmentService.addListener(_updateDashboardData);
    _scheduleService.addListener(_updateDashboardData);
    _examService.addListener(_updateDashboardData);

    _updateDashboardData();
  }

  @override
  void dispose() {
    _assignmentService.removeListener(_updateDashboardData);
    _scheduleService.removeListener(_updateDashboardData);
    _examService.removeListener(_updateDashboardData);
    super.dispose();
  }

void _updateDashboardData() {
    if (!mounted) return;

    final now = DateTime.now();
    final currentDayFull = DateFormat('EEEE').format(now); 
    final currentDayAbbr = DateFormat('E').format(now); 
    final currentTime = TimeOfDay.fromDateTime(now);

    final allTodayClasses =
        _scheduleService.classes
            .where(
              (c) =>
                  c.day.toLowerCase() == currentDayFull.toLowerCase() ||
                  c.day.toLowerCase() == currentDayAbbr.toLowerCase(),
            )
            .toList();


    allTodayClasses.sort((a, b) {
      final timeA = _parseTime(a.startTime);
      final timeB = _parseTime(b.startTime);
      return _compareTimeOfDay(timeA, timeB);
    });

    Class? foundNextClass;
    for (final classItem in allTodayClasses) {
      final startTime = _parseTime(classItem.startTime);
      if (_compareTimeOfDay(startTime, currentTime) >= 0) {
        foundNextClass = classItem;
        break;
      }
    }

    final allUpcomingExams = List<Exam>.from(_examService.upcomingExams);
    allUpcomingExams.sort((a, b) => a.date.compareTo(b.date));

    _assignmentService.updateOverdueStatus();
    final allPendingAssignments =
        _assignmentService.assignments
            .where((a) => a.status != AssignmentStatus.completed)
            .toList();
    allPendingAssignments.sort((a, b) => a.dueDate.compareTo(b.dueDate));

    setState(() {
      _todayClasses = allTodayClasses;
      _nextClass = foundNextClass;
      _upcomingExams = allUpcomingExams;
      _pendingAssignments = allPendingAssignments;
    });
  }
TimeOfDay _parseTime(String timeStr) {
    try {
      final format = DateFormat.jm(); 
      final dateTime = format.parse(timeStr);
      return TimeOfDay.fromDateTime(dateTime);
    } catch (e) {
      try {

        final parts = timeStr.split(':');
        if (parts.length == 2) {
          final hour = int.parse(parts[0]);
          final minute = int.parse(parts[1]);
          if (hour >= 0 && hour < 24 && minute >= 0 && minute < 60) {
            return TimeOfDay(hour: hour, minute: minute);
          }
        }
        final cleanedTime = timeStr.replaceAll(' ', '').toUpperCase();
        if (cleanedTime.contains('AM') || cleanedTime.contains('PM')) {
          final period = cleanedTime.contains('AM') ? 'AM' : 'PM';
          final timePart = cleanedTime
              .replaceAll('AM', '')
              .replaceAll('PM', '');
          final timeParts = timePart.split(':');
          if (timeParts.length == 2) {
            var hour = int.parse(timeParts[0]);
            final minute = int.parse(timeParts[1]);

            if (period == 'PM' && hour != 12) hour += 12;
            if (period == 'AM' && hour == 12) hour = 0;

            if (hour >= 0 && hour < 24 && minute >= 0 && minute < 60) {
              return TimeOfDay(hour: hour, minute: minute);
            }
          }
        }
      } catch (e2) {
       // print("Error parsing time '$timeStr': $e, $e2");
      }
    }

    //print("Failed to parse time '$timeStr', using current time as fallback");
    return TimeOfDay.fromDateTime(DateTime.now());
  }

  int _compareTimeOfDay(TimeOfDay a, TimeOfDay b) {
    final aMinutes = a.hour * 60 + a.minute;
    final bMinutes = b.hour * 60 + b.minute;
    return aMinutes.compareTo(bMinutes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _updateDashboardData();

          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (_nextClass != null)
                _buildNextClassCard(context, _nextClass!, _scheduleService)
              else if (_todayClasses.isNotEmpty)
                const Card(
                  color: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    side: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 32.0,
                      horizontal: 16.0,
                    ),
                    child: Center(
                      child: Text(
                        "No more classes scheduled for today.",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              else
                const Card(
                  color: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    side: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 32.0,
                      horizontal: 16.0,
                    ),
                    child: Center(
                      child: Text(
                        "No classes scheduled for today.",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 2 : 1,
                childAspectRatio:
                    MediaQuery.of(context).size.width > 600 ? 2.0 : 1.8,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildTodayClassesCard(
                    context,
                    _todayClasses,
                    _scheduleService,
                  ),
                  _buildUpcomingExamsCard(context, _upcomingExams),
                  _buildPendingAssignmentsCard(context, _pendingAssignments),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextClassCard(
    BuildContext context,
    Class nextClass,
    ScheduleService scheduleService,
  ) {
    final color =
        nextClass.color ??
        scheduleService.subjectColors[nextClass.subject] ??
        Colors.grey.shade400;

    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Next Class',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Navigate to Schedule Page (Not Implemented)",
                        ),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View Schedule',
                        style: TextStyle(overflow: TextOverflow.ellipsis),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.chevron_right, size: 16),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: color.withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.schedule, size: 32, color: color),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nextClass.subject,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${nextClass.startTime} - ${nextClass.endTime}',
                              style: TextStyle(color: Colors.grey.shade600),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              nextClass.room,
                              style: TextStyle(color: Colors.grey.shade600),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              nextClass.professor,
                              style: TextStyle(color: Colors.grey.shade600),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayClassesCard(
    BuildContext context,
    List<Class> todayClasses,
    ScheduleService scheduleService,
  ) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Today's Classes",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      const SchedulePage();
                    },
                  
                    child: const Text(
                      'View All',
                      style: TextStyle(overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (todayClasses.isEmpty)
              const Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'No classes scheduled for today',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: todayClasses.length,
                  itemBuilder: (context, index) {
                    final classItem = todayClasses[index];
                    final color =
                        classItem.color ??
                        scheduleService.subjectColors[classItem.subject] ??
                        Colors.grey.shade400;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 50,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  classItem.subject,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${classItem.startTime} - ${classItem.endTime}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${classItem.room} • ${classItem.professor}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
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
  }

  Widget _buildUpcomingExamsCard(
    BuildContext context,
    List<Exam> upcomingExams,
  ) {
    final DateFormat dateFormat = DateFormat('E, MMM d, y');

    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Upcoming Exams',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                     const ExamsPage();
                    },
                  
                    child: const Text(
                      'View All',
                      style: TextStyle(overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (upcomingExams.isEmpty)
              const Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'No upcoming exams',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: upcomingExams.length,
                  itemBuilder: (context, index) {
                    final exam = upcomingExams[index];

                    final color =
                        Colors
                            .primaries[exam.subject.hashCode %
                                Colors.primaries.length]
                            .shade100;
                    final textColor =
                        Colors
                            .primaries[exam.subject.hashCode %
                                Colors.primaries.length]
                            .shade800;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  exam.subject,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),

                              Chip(
                                label: Text(
                                  exam.course,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                backgroundColor: color,
                                visualDensity: VisualDensity.compact,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                side: BorderSide.none,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  dateFormat.format(exam.date),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  exam.time,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 14,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  exam.location,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),

                          if (exam.topics.isNotEmpty) const SizedBox(height: 8),
                          if (exam.topics.isNotEmpty)
                            Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              children:
                                  exam.topics.take(3).map((topic) {
                                    return Chip(
                                      label: Text(
                                        topic,
                                        style: const TextStyle(fontSize: 11),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      backgroundColor: Colors.grey.shade100,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 0,
                                      ),
                                      visualDensity: VisualDensity.compact,
                                      side: BorderSide.none,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    );
                                  }).toList(),
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
  }

  Widget _buildPendingAssignmentsCard(
    BuildContext context,
    List<Assignment> pendingAssignments,
  ) {
    final DateFormat dateFormat = DateFormat('E, MMM d');

    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pending Assignments',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      const AssignmentsPage();
                    },
                  
                    child: const Text(
                      'View All',
                      style: TextStyle(overflow: TextOverflow.ellipsis,),
                      softWrap: true,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (pendingAssignments.isEmpty)
              const Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'No pending assignments',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: pendingAssignments.length,
                  itemBuilder: (context, index) {
                    final assignment = pendingAssignments[index];

                    final bool isOverdue =
                        assignment.status == AssignmentStatus.overdue;

                    final Map<PriorityLevel, dynamic> priorityInfo = {
                      PriorityLevel.high: {
                        'color': Colors.red.shade400,
                        'name': 'High',
                      },
                      PriorityLevel.medium: {
                        'color': Colors.orange.shade400,
                        'name': 'Medium',
                      },
                      PriorityLevel.low: {
                        'color': Colors.blue.shade400,
                        'name': 'Low',
                      },
                    };

                    final Color priorityColor =
                        priorityInfo[assignment.priority]?['color'] ??
                        Colors.grey.shade400;
                    final String priorityName =
                        priorityInfo[assignment.priority]?['name'] ?? 'Unknown';
                    final Color dateColor =
                        isOverdue ? Colors.red.shade600 : Colors.grey.shade600;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  assignment.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Chip(
                                label: Text(
                                  priorityName,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: priorityColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                backgroundColor: priorityColor.withOpacity(
                                  0.15,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                                side: BorderSide.none,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            assignment.subject,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blueGrey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),

                          if (assignment.description.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                assignment.description,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
                                  height: 1.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: dateColor,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'Due: ${dateFormat.format(assignment.dueDate)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: dateColor,
                                    fontWeight:
                                        isOverdue
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                              if (isOverdue)
                                Text(
                                  ' (Overdue)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red.shade600,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
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
  }
}
