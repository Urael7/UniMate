import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/models/class.dart';
import 'package:frontend/presentation/screens/core/ClassSchedules/schedule_service.dart';


class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  // Constants
  static const double _timeColumnWidth = 70.0;
  static const double _hourSlotHeight = 90.0;
  static const double _dayHeaderHeight = 50.0;
  static const List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const List<String> _timeSlots = [
    '8 AM', '9 AM', '10 AM', '11 AM', '12 PM',
    '1 PM', '2 PM', '3 PM', '4 PM', '5 PM',
  ];

  final ScheduleService _scheduleService = ScheduleService();

  List<Class> get _classes => _scheduleService.classes;
  Map<String, Color> get _subjectColors => _scheduleService.subjectColors;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Class Schedule',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: _showAddClassDialog,
            tooltip: 'Add New Class',
          ),
          _buildSubjectsMenuButton(),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildScheduleGrid(),
          ),
          if (_subjectColors.isNotEmpty) _buildSubjectLegend(),
        ],
      ),
    );
  }

  Widget _buildSubjectsMenuButton() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.palette_outlined, color: Colors.black),
      tooltip: 'Manage Subjects',
      onSelected: (value) {
        if (value == 'add_new_subject') {
          _showAddSubjectDialog().then((newSubject) {
            if (newSubject != null && newSubject.isNotEmpty) {
              setState(() {
                _scheduleService.addSubject(newSubject);
              });
            }
          });
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'add_new_subject',
          child: ListTile(
            leading: Icon(Icons.add),
            title: Text('Add New Subject'),
          ),
        ),
        if (_subjectColors.isNotEmpty) const PopupMenuDivider(),
        ..._subjectColors.keys.map(
          (subject) => PopupMenuItem<String>(
            value: 'edit_$subject',
            onTap: () => Future.delayed(
              Duration.zero,
              () => _showEditSubjectDialog(subject),
            ),
            child: ListTile(
              leading: Icon(
                Icons.edit_outlined,
                size: 20,
                color: _subjectColors[subject],
              ),
              title: Text(subject),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleGrid() {
    final totalGridHeight = _timeSlots.length * _hourSlotHeight;
    final gridBorderColor = Colors.grey.shade300;

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(color: gridBorderColor),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Column(
          children: [
            _buildDayHeaders(gridBorderColor),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: _timeColumnWidth + _days.length * 100.0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTimeColumn(gridBorderColor),
                    _buildScheduleGridContent(totalGridHeight, gridBorderColor),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayHeaders(Color borderColor) {
    return Container(
      height: _dayHeaderHeight,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Row(
        children: [
          SizedBox(width: _timeColumnWidth),
          ..._days.map(
            (day) => Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: _days.indexOf(day) < _days.length - 1
                      ? Border(left: BorderSide(color: borderColor))
                      : null,
                ),
                child: Center(
                  child: Text(
                    day,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ).toList(),
        ],
      ),
    );
  }

  Widget _buildTimeColumn(Color borderColor) {
    return Column(
      children: _timeSlots.map(
        (time) => Container(
          width: _timeColumnWidth,
          height: _hourSlotHeight,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(color: borderColor),
              top: time != _timeSlots.first
                  ? BorderSide(color: borderColor.withAlpha(128)) // 0.5 opacity
                  : BorderSide.none,
            ),
          ),
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(top: 4, right: 4),
          child: Text(
            time,
            style: const TextStyle(fontSize: 10),
          ),
        ),
      ).toList(),
    );
  }

  Widget _buildScheduleGridContent(double totalHeight, Color borderColor) {
    return Expanded(
      child: SizedBox(
        height: totalHeight,
        child: Stack(
          children: [
            Column(
              children: List.generate(
                _timeSlots.length,
                (index) => Container(
                  height: _hourSlotHeight,
                  decoration: BoxDecoration(
                    border: index < _timeSlots.length - 1
                        ? Border(
                            bottom: BorderSide(
                              color: borderColor.withOpacity(0.5),
                            ),
                          )
                        : null,
                  ),
                ),
              ),
            ),
            Row(
              children: List.generate(
                _days.length,
                (index) => Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: index < _days.length - 1
                          ? Border(left: BorderSide(color: borderColor))
                          : null,
                    ),
                  ),
                ),
              ),
            ),
            ..._buildClassItemsForGrid(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildClassItemsForGrid() {
    final List<Widget> classWidgets = [];
    final double dayColumnWidth =
        (MediaQuery.of(context).size.width - _timeColumnWidth - 16) /
            _days.length;
    final effectiveDayWidth = max(dayColumnWidth, 100.0);

    for (int dayIndex = 0; dayIndex < _days.length; dayIndex++) {
      final day = _days[dayIndex];
      final classesForDay = _classes.where((c) => c.day == day).toList();

      for (final classItem in classesForDay) {
        final topOffset = _calculateTopOffset(classItem.startTime);
        final height = _calculateClassHeight(
            classItem.startTime, classItem.endTime);
        final leftOffset = dayIndex * effectiveDayWidth;

        classWidgets.add(
          Positioned(
            top: topOffset,
            left: leftOffset,
            width: effectiveDayWidth,
            height: height,
            child: _buildClassItemWidget(classItem),
          ),
        );
      }
    }
    return classWidgets;
  }

  double _calculateTopOffset(String startTime) {
    final startIndex = _timeSlots.indexOf(startTime);
    return startIndex != -1 ? startIndex * _hourSlotHeight : 0.0;
  }

  double _calculateClassHeight(String startTime, String endTime) {
    final startIndex = _timeSlots.indexOf(startTime);
    final endIndex = _timeSlots.indexOf(endTime);
    return (startIndex != -1 && endIndex != -1 && endIndex > startIndex)
        ? (endIndex - startIndex) * _hourSlotHeight
        : _hourSlotHeight;
  }

  List<String> _getValidEndTimes(String startTime) {
    final startIndex = _timeSlots.indexOf(startTime);
    return startIndex != -1 ? _timeSlots.sublist(startIndex + 1) : [];
  }

  Widget _buildClassItemWidget(Class classItem) {
    final Color color = _subjectColors[classItem.subject] ?? Colors.grey;
    final bool isShort =
        _calculateClassHeight(classItem.startTime, classItem.endTime) <
            _hourSlotHeight * 0.8;

    return Padding(
      padding: const EdgeInsets.all(1.5),
      child: Material(
        color: color.withAlpha(51), // 0.2 opacity
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          onTap: () => _showClassDetails(classItem),
          borderRadius: BorderRadius.circular(4),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: color.withAlpha(128)), // 0.5 opacity
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.all(5),
            child: DefaultTextStyle(
              style: const TextStyle(fontSize: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    classItem.subject,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                    maxLines: isShort ? 1 : 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (!isShort) ...[
                    Text(
                      classItem.room,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      classItem.professor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                  ],
                  Text(
                    '${classItem.startTime} - ${classItem.endTime}',
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectLegend() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Wrap(
            spacing: 8,
            runSpacing: 4,
            children: _subjectColors.entries
                .map((entry) => _buildSubjectChip(entry.key, entry.value))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectChip(String subject, Color color) {
    return ActionChip(
      avatar: CircleAvatar(backgroundColor: color, radius: 8),
      label: Text(subject),
      onPressed: () => _showEditSubjectDialog(subject),
      backgroundColor: Colors.white,
      side: BorderSide(color: color),
      labelStyle: const TextStyle(fontSize: 12),
    );
  }

  // Dialog methods
  void _showAddClassDialog() {
    String selectedDay = _days[0];
    String selectedStartTime = _timeSlots[0];
    String selectedEndTime = _timeSlots[1];
    String? selectedSubject = _subjectColors.keys.first;
    final professorController = TextEditingController();
    final roomController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final validEndTimes = _getValidEndTimes(selectedStartTime);
            if (!validEndTimes.contains(selectedEndTime)) {
              selectedEndTime =
                  validEndTimes.isNotEmpty ? validEndTimes.first : _timeSlots.last;
            }

            return AlertDialog(
              title: const Text('Add New Class'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDayDropdown(
                      selectedDay,
                      (value) => setDialogState(() => selectedDay = value!),
                    ),
                    const SizedBox(height: 16),
                    _buildStartTimeDropdown(
                      selectedStartTime,
                      (value) => setDialogState(() {
                        selectedStartTime = value!;
                        selectedEndTime = _getValidEndTimes(selectedStartTime)
                                .firstOrNull ??
                            _timeSlots.last;
                      }),
                    ),
                    const SizedBox(height: 16),
                    _buildEndTimeDropdown(
                      selectedEndTime,
                      validEndTimes,
                      (value) => setDialogState(() => selectedEndTime = value!),
                    ),
                    const SizedBox(height: 16),
                    _buildSubjectDropdown(
                      selectedSubject,
                      (value) async {
                        if (value == 'add_new') {
                          final newSubject = await _showAddSubjectDialog();
                          if (newSubject != null && newSubject.isNotEmpty) {
                            setDialogState(() {
                              _scheduleService.addSubject(newSubject);
                              selectedSubject = newSubject;
                            });
                          }
                        } else {
                          setDialogState(() => selectedSubject = value);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: professorController,
                      decoration: const InputDecoration(labelText: 'Professor'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: roomController,
                      decoration: const InputDecoration(labelText: 'Room'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: (selectedSubject == null ||
                          selectedSubject == 'add_new' ||
                          validEndTimes.isEmpty)
                      ? null
                      : () {
                          _scheduleService.addClass(Class(
                            day: selectedDay,
                            startTime: selectedStartTime,
                            endTime: selectedEndTime,
                            subject: selectedSubject!,
                            professor: professorController.text.trim(),
                            room: roomController.text.trim(),
                          ));
                          setState(() {});
                          Navigator.of(context).pop();
                        },
                  child: const Text('Add Class'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  DropdownButtonFormField<String> _buildDayDropdown(
      String value, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      items: _days
          .map((day) => DropdownMenuItem(value: day, child: Text(day)))
          .toList(),
      onChanged: onChanged,
      decoration: const InputDecoration(labelText: 'Day'),
    );
  }

  DropdownButtonFormField<String> _buildStartTimeDropdown(
      String value, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      items: _timeSlots
          .map((time) => DropdownMenuItem(value: time, child: Text(time)))
          .toList(),
      onChanged: onChanged,
      decoration: const InputDecoration(labelText: 'Start Time'),
    );
  }

  DropdownButtonFormField<String> _buildEndTimeDropdown(
      String value, List<String> validEndTimes, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      items: validEndTimes
          .map((time) => DropdownMenuItem(value: time, child: Text(time)))
          .toList(),
      onChanged: onChanged,
      decoration: const InputDecoration(labelText: 'End Time'),
    );
  }

  DropdownButtonFormField<String> _buildSubjectDropdown(
      String? value, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      items: [
        ..._subjectColors.keys.map((subject) => DropdownMenuItem(
              value: subject,
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    color: _subjectColors[subject],
                    margin: const EdgeInsets.only(right: 8),
                  ),
                  Text(subject),
                ],
              ),
            )),
        const DropdownMenuItem(
          value: 'add_new',
          child: Row(
            children: [
              Icon(Icons.add, size: 16),
              SizedBox(width: 8),
              Text('Add new...'),
            ],
          ),
        ),
      ],
      onChanged: onChanged,
      decoration: const InputDecoration(labelText: 'Subject'),
    );
  }

  void _showClassDetails(Class classItem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(classItem.subject),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Professor: ${classItem.professor}'),
            Text('Room: ${classItem.room}'),
            Text('Day: ${classItem.day}'),
            Text('Time: ${classItem.startTime} - ${classItem.endTime}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showEditClassDialog(classItem);
            },
            child: const Text('Edit'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showEditClassDialog(Class classItem) {
    String selectedDay = classItem.day;
    String selectedStartTime = classItem.startTime;
    String selectedEndTime = classItem.endTime;
    String selectedSubject = classItem.subject;
    final professorController = TextEditingController(text: classItem.professor);
    final roomController = TextEditingController(text: classItem.room);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final validEndTimes = _getValidEndTimes(selectedStartTime);
            if (!validEndTimes.contains(selectedEndTime)) {
              selectedEndTime =
                  validEndTimes.isNotEmpty ? validEndTimes.first : _timeSlots.last;
            }

            return AlertDialog(
              title: const Text('Edit Class'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDayDropdown(
                      selectedDay,
                      (value) => setDialogState(() => selectedDay = value!),
                    ),
                    const SizedBox(height: 16),
                    _buildStartTimeDropdown(
                      selectedStartTime,
                      (value) => setDialogState(() {
                        selectedStartTime = value!;
                        selectedEndTime = _getValidEndTimes(selectedStartTime)
                                .firstOrNull ??
                            _timeSlots.last;
                      }),
                    ),
                    const SizedBox(height: 16),
                    _buildEndTimeDropdown(
                      selectedEndTime,
                      validEndTimes,
                      (value) => setDialogState(() => selectedEndTime = value!),
                    ),
                    const SizedBox(height: 16),
                    _buildSubjectDropdown(
                      selectedSubject,
                      (value) async {
                        if (value == 'add_new') {
                          final newSubject = await _showAddSubjectDialog();
                          if (newSubject != null && newSubject.isNotEmpty) {
                            setDialogState(() {
                              _scheduleService.addSubject(newSubject);
                              selectedSubject = newSubject;
                            });
                          }
                        } else {
                          setDialogState(() => selectedSubject = value!);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: professorController,
                      decoration: const InputDecoration(labelText: 'Professor'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: roomController,
                      decoration: const InputDecoration(labelText: 'Room'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _deleteClass(classItem);
                  },
                  child: const Text('Delete'),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Validate inputs first
                    if (selectedDay.isEmpty ||
                        selectedStartTime.isEmpty ||
                        selectedEndTime.isEmpty ||
                        selectedSubject.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill all required fields'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }
                    try {
                      final updatedClass = classItem.copyWith(
                        day: selectedDay,
                        startTime: selectedStartTime,
                        endTime: selectedEndTime,
                        subject: selectedSubject,
                        professor: professorController.text.trim(),
                        room: roomController.text.trim(),
                      );

                      _scheduleService.updateClass(classItem.id, updatedClass);
                      setState(() {});
                      Navigator.of(context).pop();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Error updating class: ${e.toString()}',
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteClass(Class classItem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Class?'),
        content: Text('Are you sure you want to delete the class "${classItem.subject}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              _scheduleService.deleteClass(classItem.id);
              setState(() {});
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<String?> _showAddSubjectDialog() {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Subject'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Subject Name'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final text = controller.text.trim();
                if (text.isNotEmpty) Navigator.of(context).pop(text);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditSubjectDialog(String subject) {
    final nameController = TextEditingController(text: subject);
    Color selectedColor = _subjectColors[subject]!;
    final String originalSubjectName = subject;

    List<Color> colorOptions = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.indigo,
      Colors.teal,
      Colors.pink,
      if (![
        Colors.red,
        Colors.blue,
        Colors.green,
        Colors.purple,
        Colors.orange,
        Colors.indigo,
        Colors.teal,
        Colors.pink,
      ].contains(selectedColor))
        selectedColor,
      ..._scheduleService.colorPalette.where((color) => !_subjectColors.values.contains(color)),
    ];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Edit "$subject"'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Subject Name'),
                    ),
                    const SizedBox(height: 16),
                    const Text('Select Color:'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: colorOptions
                          .map(
                            (color) => _buildColorOption(
                              color,
                              selectedColor,
                              () => setDialogState(() => selectedColor = color),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _deleteSubject(originalSubjectName);
                  },
                  child: const Text('Delete'),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final newName = nameController.text.trim();
                    if (newName.isNotEmpty) {
                      _scheduleService.updateSubject(
                        originalSubjectName,
                        newName,
                        selectedColor,
                      );
                      setState(() {});
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildColorOption(
      Color color, Color selectedColor, VoidCallback onTap) {
    bool isSelected = color == selectedColor;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.black.withOpacity(isSelected ? 1.0 : 0.5),
            width: isSelected ? 3 : 1.5,
          ),
        ),
        child: isSelected
            ? Icon(
                Icons.check,
                color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
              )
            : null,
      ),
    );
  }

  void _deleteSubject(String subject) {
    final isUsed = _classes.any((c) => c.subject == subject);

    if (isUsed) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Cannot Delete Subject'),
          content: Text(
              'Subject "$subject" is used in your schedule. Please remove or change classes using it first.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Subject?'),
          content: Text(
              'Are you sure you want to delete the subject "$subject"? This cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () {
                _scheduleService.deleteSubject(subject);
                setState(() {});
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        ),
      );
    }
  }
}