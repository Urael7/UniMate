import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/presentation/screens/core/Exams/exam_service.dart';
import 'package:provider/provider.dart';
import 'package:frontend/models/exam.dart';
import 'package:intl/intl.dart';

enum ViewMode { list, calendar }

class ExamsPage extends StatefulWidget {
  const ExamsPage({super.key});

  @override
  State<ExamsPage> createState() => _ExamsPageState();
}

class _ExamsPageState extends State<ExamsPage> {

  String subjectFilter = 'all';
  String searchQuery = '';
  ViewMode viewMode = ViewMode.list;

  List<String> get subjects {
    final examService = Provider.of<ExamService>(context, listen: false);
    return ['all', ...examService.exams.map((e) => e.subject).toSet()];
  }

  List<Exam> get filteredExams {
    final examService = Provider.of<ExamService>(context, listen: false);
    var filtered =
        examService.exams.where((e) {
          if (subjectFilter != 'all' && e.subject != subjectFilter) {
            return false;
          }
          if (searchQuery.isNotEmpty &&
              !e.subject.toLowerCase().contains(searchQuery.toLowerCase()) &&
              !e.course.toLowerCase().contains(searchQuery.toLowerCase()) &&
              !e.location.toLowerCase().contains(searchQuery.toLowerCase())) {
            return false;
          }
          return true;
        }).toList();
    filtered.sort((a, b) => a.date.compareTo(b.date));
    return filtered;
  }

  // Groups exams by month for calendar view
  Map<String, List<Exam>> get examsByMonth {
    return filteredExams.fold({}, (Map<String, List<Exam>> acc, Exam exam) {
      final monthYear = DateFormat('MMMM yyyy').format(exam.date);
      acc.putIfAbsent(monthYear, () => []).add(exam);
      return acc;
    });
  }

 void _deleteExam(int id) {
    final examService = Provider.of<ExamService>(context, listen: false);
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Deletion'),
            content: const Text('Are you sure you want to delete this exam?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  examService.deleteExam(id);
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Exam deleted successfully')),
                  );
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

    void _showAddEditExamDialog({Exam? exam}) {
    final isEdit = exam != null;
    final formKey = GlobalKey<FormState>();
    final examService = Provider.of<ExamService>(context, listen: false);

    final subjectController = TextEditingController(text: exam?.subject ?? '');
    final courseController = TextEditingController(text: exam?.course ?? '');
    DateTime selectedDate = exam?.date ?? DateTime.now();
    final dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(selectedDate),
    );
    final timeController = TextEditingController(text: exam?.time ?? '');
    final locationController = TextEditingController(
      text: exam?.location ?? '',
    );
    final professorController = TextEditingController(
      text: exam?.professor ?? '',
    );
    final topicsController = TextEditingController(
      text: exam?.topics.join(', ') ?? '',
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(isEdit ? 'Edit Exam' : 'Add New Exam'),
          content: SizedBox(
            width: min(MediaQuery.of(dialogContext).size.width * 0.9, 500),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: subjectController,
                      decoration: const InputDecoration(labelText: 'Subject*'),
                      validator:
                          (value) =>
                              value?.trim().isEmpty ?? true
                                  ? 'Subject is required'
                                  : null,
                    ),
                    TextFormField(
                      controller: courseController,
                      decoration: const InputDecoration(labelText: 'Course*'),
                      validator:
                          (value) =>
                              value?.trim().isEmpty ?? true
                                  ? 'Course is required'
                                  : null,
                    ),
                    TextFormField(
                      controller: dateController,
                      decoration: const InputDecoration(
                        labelText: 'Date*',
                        hintText: 'YYYY-MM-DD',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      validator:
                          (value) =>
                              value?.isEmpty ?? true
                                  ? 'Date is required'
                                  : null,
                      onTap: () async {
                        FocusScope.of(dialogContext).requestFocus(FocusNode());
                        final date = await showDatePicker(
                          context: dialogContext,
                          initialDate: selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          selectedDate = date;
                          dateController.text = DateFormat(
                            'yyyy-MM-dd',
                          ).format(date);
                        }
                      },
                    ),
                    TextFormField(
                      controller: timeController,
                      decoration: const InputDecoration(
                        labelText: 'Time* (e.g., 9:00 AM - 11:00 AM)',
                      ),
                      validator:
                          (value) =>
                              value?.trim().isEmpty ?? true
                                  ? 'Time is required'
                                  : null,
                    ),
                    TextFormField(
                      controller: locationController,
                      decoration: const InputDecoration(labelText: 'Location*'),
                      validator:
                          (value) =>
                              value?.trim().isEmpty ?? true
                                  ? 'Location is required'
                                  : null,
                    ),
                    TextFormField(
                      controller: professorController,
                      decoration: const InputDecoration(
                        labelText: 'Professor (Optional)',
                      ),
                    ),
                    TextFormField(
                      controller: topicsController,
                      decoration: const InputDecoration(
                        labelText: 'Topics (comma separated, Optional)',
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '* indicates required field',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  final newExam = Exam(
                  
                    id: exam?.id ?? DateTime.now().millisecondsSinceEpoch,
                    subject: subjectController.text.trim(),
                    course: courseController.text.trim(),
                    date: DateFormat('yyyy-MM-dd').format(selectedDate),
                    time: timeController.text.trim(),
                    location: locationController.text.trim(),
                    professor: professorController.text.trim(),
                    topics:
                        topicsController.text
                            .split(',')
                            .map((e) => e.trim())
                            .where((e) => e.isNotEmpty)
                            .toList(),
                  );

                  if (isEdit) {
                    examService.updateExam(newExam);
                    
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Exam updated successfully'),
                      ),
                    );
                  } else {
                    examService.addExam(newExam);
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Exam added successfully')),
                    );
                  }
                  Navigator.pop(dialogContext);
                }
              },
              child: Text(isEdit ? 'Update' : 'Add'),
            ),
          ],
        );
      },
    );
  }

@override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(isNarrow ? 12.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Exam Timetable',
              style: TextStyle(
                fontSize: isNarrow ? 22 : 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'View your upcoming exams and prepare accordingly.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            _buildFilterBar(isNarrow: isNarrow),
            const SizedBox(height: 20),
            Expanded(
              child:
                  viewMode == ViewMode.list
                      ? _buildListView(isNarrow:  isNarrow)
                      : _buildCalendarView(isNarrow: isNarrow),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        hoverElevation: 12,
        focusColor: Colors.transparent,
        onPressed: () => _showAddEditExamDialog(),
        tooltip: 'Add New Exam',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterBar({required bool isNarrow}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isNarrow ? 12 : 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((0.1 * 255).round()),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Wrap(
        spacing: 12.0,
        runSpacing: 8.0,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          // Search Field
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isNarrow ? double.infinity : 400,
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search exams...',
                prefixIcon: const Icon(Icons.search, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                isDense: true,
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // Subject Dropdown
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isNarrow ? 200 : 180),
                child: DropdownButtonFormField<String>(
                  value: subjectFilter,
                  isDense: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                  items:
                      subjects.map((subject) {
                        return DropdownMenuItem<String>(
                          value: subject,
                          child: Text(
                            subject == 'all' ? 'Subjects' : subject,
                            style: const TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        subjectFilter = value;
                      });
                    }
                  },
                ),
              ),

              // View Mode Toggle Buttons
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ViewModeButton(
                      icon: Icons.list,
                      isActive: viewMode == ViewMode.list,
                      onTap: () => setState(() => viewMode = ViewMode.list),
                    ),
                    Container(
                      width: 1,
                      height: 20,
                      color: Colors.grey.shade300,
                    ),
                    _ViewModeButton(
                      icon: Icons.calendar_month,
                      isActive: viewMode == ViewMode.calendar,
                      onTap: () => setState(() => viewMode = ViewMode.calendar),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListView({required bool isNarrow}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((0.1 * 255).round()),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child:
          filteredExams.isEmpty
              ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    'No exams found.',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              )
              : ListView.separated(
                itemCount: filteredExams.length,
                separatorBuilder:
                    (context, index) =>
                        const Divider(height: 1, indent: 16, endIndent: 16),
                itemBuilder: (context, index) {
                  final exam = filteredExams[index];
                  final isUpcoming = exam.date.isAfter(
                    DateTime.now().subtract(const Duration(days: 1)),
                  );

                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: isNarrow ? 10 : 12,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    exam.subject,
                                    style: TextStyle(
                                      fontSize: isNarrow ? 16 : 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    exam.course,
                                    style: TextStyle(
                                      fontSize: isNarrow ? 13 : 14,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isUpcoming
                                        ? Colors.green.shade50
                                        : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color:
                                      isUpcoming
                                          ? Colors.green.shade200
                                          : Colors.grey.shade300,
                                  width: 0.5,
                                ),
                              ),
                              child: Text(
                                isUpcoming ? 'Upcoming' : 'Past',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isUpcoming
                                          ? Colors.green.shade800
                                          : Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 16.0,
                          runSpacing: 6.0,
                          children: [
                            _ExamDetailItem(
                              icon: Icons.calendar_today,
                              text: DateFormat(
                                'EEE, MMM d, yyyy',
                              ).format(exam.date),
                              small: isNarrow,
                            ),
                            _ExamDetailItem(
                              icon: Icons.access_time,
                              text: exam.time,
                              small: isNarrow,
                            ),
                            _ExamDetailItem(
                              icon: Icons.location_on,
                              text: exam.location,
                              small: isNarrow,
                            ),
                            if (exam.professor.isNotEmpty)
                              _ExamDetailItem(
                                icon: Icons.person_outline,
                                text: exam.professor,
                                small: isNarrow,
                              ),
                          ],
                        ),
                        if (exam.topics.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children:
                                exam.topics.map((topic) {
                                  return Chip(
                                    label: Text(topic),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 0,
                                    ),
                                    labelStyle: TextStyle(
                                      fontSize: 11,
                                      color: Colors.blue.shade800,
                                    ),
                                    backgroundColor: Colors.blue.shade50,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    side: BorderSide(
                                      color: Colors.blue.shade100,
                                      width: 0.5,
                                    ),
                                  );
                                }).toList(),
                          ),
                        ],
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, size: 20),
                      tooltip: 'Options',
                      itemBuilder:
                          (context) => [
                            const PopupMenuItem<String>(
                              value: 'edit',
                              child: ListTile(
                                leading: Icon(Icons.edit_outlined, size: 20),
                                title: Text(
                                  'Edit',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'delete',
                              child: ListTile(
                                leading: Icon(
                                  Icons.delete_outline,
                                  size: 20,
                                  color: Colors.red,
                                ),
                                title: Text(
                                  'Delete',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ],
                      onSelected: (value) {
                        if (value == 'edit') {
                          _showAddEditExamDialog(exam: exam);
                        } else if (value == 'delete') {
                          _deleteExam(exam.id);
                        }
                      },
                    ),
                  );
                },
              ),
    );
  }

  // Calendar View Builder
  Widget _buildCalendarView({required bool isNarrow}) {
    final entries = examsByMonth.entries.toList();

    return entries.isEmpty
        ? Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'No exams found.',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        )
        : ListView.separated(
          itemCount: entries.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final monthYear = entries[index].key;
            final monthExams = entries[index].value;
            monthExams.sort((a, b) => a.date.compareTo(b.date));

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withAlpha((0.1 * 255).round()),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Month Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.blue.shade100,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      monthYear,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                  ),
                  // List of exams for the month
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: monthExams.length,
                    separatorBuilder:
                        (context, index) =>
                            const Divider(height: 1, indent: 16, endIndent: 16),
                    itemBuilder: (context, index) {
                      final exam = monthExams[index];

                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: isNarrow ? 8 : 10,
                        ),
                        leading: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 6,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                exam.date.day.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                DateFormat('E').format(exam.date).toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              exam.subject,
                              style: TextStyle(
                                fontSize: isNarrow ? 15 : 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              exam.course,
                              style: TextStyle(
                                fontSize: isNarrow ? 12 : 13,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 12.0,
                              runSpacing: 4.0,
                              children: [
                                _ExamDetailItem(
                                  icon: Icons.access_time,
                                  text: exam.time,
                                  small: true,
                                ),
                                _ExamDetailItem(
                                  icon: Icons.location_on,
                                  text: exam.location,
                                  small: true,
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert, size: 20),
                          tooltip: 'Options',
                          itemBuilder:
                              (context) => [
                                const PopupMenuItem<String>(
                                  value: 'edit',
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.edit_outlined,
                                      size: 20,
                                    ),
                                    title: Text(
                                      'Edit',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'delete',
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.delete_outline,
                                      size: 20,
                                      color: Colors.red,
                                    ),
                                    title: Text(
                                      'Delete',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                          onSelected: (value) {
                            if (value == 'edit') {
                              _showAddEditExamDialog(exam: exam);
                            } else if (value == 'delete') {
                              _deleteExam(exam.id);
                            }
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
  }
}

class _ViewModeButton extends StatelessWidget {
  final bool isActive;
  final IconData icon;
  final VoidCallback onTap;

  const _ViewModeButton({
    required this.isActive,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue.shade50 : Colors.transparent,
        ),
        child: Icon(
          icon,
          size: 20,
          color: isActive ? Colors.blue.shade700 : Colors.grey.shade600,
        ),
      ),
    );
  }
}

class _ExamDetailItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool small;

  const _ExamDetailItem({
    required this.icon,
    required this.text,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: small ? 14 : 16, color: Colors.grey.shade600),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: small ? 12 : 13,
              color: Colors.grey.shade700,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
