
import 'package:flutter/material.dart';
import 'dart:math';


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
  static const List<String> _days = [
    'Mon', 'Tue', 'Wed', 'Thu',  'Fri',  'Sat', 'Sun'
  ];
  static const List<String> _timeSlots = [
    '8 AM', '9 AM', '10 AM', '11 AM','12 PM', '1 PM', '2 PM', '3 PM', '4 PM', '5 PM'
  ];

  // State
  final Random _random = Random();
  List<Class> _classes = [];
  final Map<String, Color> _subjectColors = {
    'Mathematics': Colors.blue,
    'Physics': Colors.green,
    'Comp Sci': Colors.purple,
    'Yoga': Colors.orange,
    'History': Colors.amber,
    'Literature': Colors.red,
    'Biology': Colors.indigo,
  };

  @override
  void initState() {
    super.initState();
    _initializeSampleClasses();
  }

  void _initializeSampleClasses() {
    _classes.addAll([
      Class(
        id: 1,
        day: 'Mon',
        startTime: '8 AM',
        endTime: '9 AM',
        subject: 'Mathematics',
        professor: 'Dr. Smith',
        room: 'Room 201',
        color: _subjectColors['Mathematics']!,
      ),
      Class(
        id: 2,
        day: 'Mon',
        startTime: '10 AM',
        endTime: '12 PM',
        subject: 'Physics',
        professor: 'Prof. Johnson',
        room: 'Lab 101',
        color: _subjectColors['Physics']!,
      ),
      Class(
        id: 3,
        day: 'Wed',
        startTime: '1 PM',
        endTime: '3 PM',
        subject: 'Comp Sci',
        professor: 'Dr. Ada L.',
        room: 'CS Bld 404',
        color: _subjectColors['Comp Sci']!,
      ),
      Class(
        id: 4,
        day: 'Sat',
        startTime: '10 AM',
        endTime: '12 PM',
        subject: 'Yoga',
        professor: 'Instructor Lee',
        room: 'Studio 3',
        color: _subjectColors['Yoga']!,
      ),
    ]);
  }

  // Helper methods
  Color _generateRandomColor() {
    return HSLColor.fromAHSL(
      1.0,
      _random.nextDouble() * 360,
      0.5 + _random.nextDouble() * 0.3,
      0.6 + _random.nextDouble() * 0.2,
    ).toColor();
  }

  double _calculateTopOffset(String startTime) {
    final startIndex = _timeSlots.indexOf(startTime);
    return startIndex != -1 ? startIndex * _hourSlotHeight : 0.0;
  }

  double _calculateClassHeight(String startTime, String endTime) {
    final startIndex = _timeSlots.indexOf(startTime);
    final endIndex = _timeSlots.indexOf(endTime);

    if (startIndex == -1 || endIndex == -1 || endIndex <= startIndex) {
      return _hourSlotHeight;
    }
    return (endIndex - startIndex) * _hourSlotHeight;
  }

  List<String> _getValidEndTimes(String startTime) {
    final startIndex = _timeSlots.indexOf(startTime);
    return startIndex != -1 ? _timeSlots.sublist(startIndex + 1) : [];
  }

  // UI Components
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Schedule'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add New Class',
            onPressed: _showAddClassDialog,
          ),
          _buildSubjectsMenuButton(),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildScheduleGrid()),
          if (_subjectColors.isNotEmpty) _buildSubjectLegend(),
        ],
      ),
    );
  }

  Widget _buildSubjectsMenuButton() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.palette_outlined),
      tooltip: 'Manage Subjects',
      onSelected: (value) {
        if (value == 'add_new_subject') {
          _showAddSubjectDialog().then((newSubject) {
            if (newSubject != null && newSubject.isNotEmpty) {
              setState(() {
                if (!_subjectColors.containsKey(newSubject)) {
                  _subjectColors[newSubject] = _generateRandomColor();
                }
              });
            }
          });
        }
      },
      itemBuilder:
          (BuildContext context) => <PopupMenuEntry<String>>[
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
                onTap:
                    () => Future.delayed(
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
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      ),
      child: Row(
        children: [
          SizedBox(width: _timeColumnWidth),
          ..._days.map(
            (day) => Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border:
                      _days.indexOf(day) < _days.length - 1
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
          ),
        ],
      ),
    );
  }

  Widget _buildTimeColumn(Color borderColor) {
    return Column(
      children:
          _timeSlots
              .map(
                (time) => Container(
                  width: _timeColumnWidth,
                  height: _hourSlotHeight,
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(color: borderColor),
                      top:
                          time != _timeSlots.first
                              ? BorderSide(color: borderColor.withValues(alpha: 0.5))
                              : BorderSide.none,
                    ),
                  ),
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.only(top: 4, right: 4),
                  child: Text(time, style: const TextStyle(fontSize: 10)),
                ),
              )
              .toList(),
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
                    border:
                        index < _timeSlots.length - 1
                            ? Border(
                              bottom: BorderSide(
                                color: borderColor.withValues(alpha: 0.5),
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
                      border:
                          index < _days.length - 1
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
          classItem.startTime,
          classItem.endTime,
        );
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

  Widget _buildClassItemWidget(Class classItem) {
    final Color color = _subjectColors[classItem.subject] ?? Colors.grey;
    final Color textColor =
        HSLColor.fromColor(color).lightness > 0.6
            ? Colors.black87
            : Colors.white;
    final bool isShort =
        _calculateClassHeight(classItem.startTime, classItem.endTime) <
        _hourSlotHeight * 0.8;

    return Padding(
      padding: const EdgeInsets.all(1.5),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          onTap: () => _showClassDetails(classItem),
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: DefaultTextStyle(
              style: TextStyle(color: textColor, fontSize: 10),
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
                      classItem.room.isNotEmpty ? classItem.room : 'No room',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      classItem.professor.isNotEmpty
                          ? classItem.professor
                          : 'No prof.',
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
        elevation: 0.5,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Wrap(
            spacing: 8,
            runSpacing: 4,
            children:
                _subjectColors.entries.map((entry) {
                  return _buildSubjectChip(entry.key, entry.value);
                }).toList(),
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
      tooltip: 'Edit "$subject"',
      backgroundColor: color.withValues(alpha: 0.15),
      side: BorderSide(color: color.withValues(alpha: 0.5)),
      labelStyle: const TextStyle(fontSize: 12),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
                  validEndTimes.isNotEmpty
                      ? validEndTimes.first
                      : _timeSlots.last;
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
                        selectedEndTime =
                            _getValidEndTimes(selectedStartTime).firstOrNull ??
                            _timeSlots.last;
                      }),
                    ),
                    const SizedBox(height: 16),
                    _buildEndTimeDropdown(
                      selectedEndTime,
                      _getValidEndTimes(selectedStartTime),
                      (value) => setDialogState(() => selectedEndTime = value!),
                    ),
                    const SizedBox(height: 16),
                    _buildSubjectDropdown(selectedSubject, (value) async {
                      if (value == 'add_new') {
                        final newSubject = await _showAddSubjectDialog();
                        if (newSubject != null && newSubject.isNotEmpty) {
                          setDialogState(() {
                            if (!_subjectColors.containsKey(newSubject)) {
                              _subjectColors[newSubject] =
                                  _generateRandomColor();
                            }
                            selectedSubject = newSubject;
                          });
                        }
                      } else {
                        setDialogState(() => selectedSubject = value);
                      }
                    }),
                    const SizedBox(height: 16),
                    _buildProfessorField(professorController),
                    const SizedBox(height: 16),
                    _buildRoomField(roomController),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed:
                      (selectedSubject == null ||
                              selectedSubject == 'add_new' ||
                              validEndTimes.isEmpty)
                          ? null
                          : () {
                            final newClass = Class(
                              id:
                                  (_classes.isEmpty
                                      ? 0
                                      : _classes.map((c) => c.id).reduce(max)) +
                                  1,
                              day: selectedDay,
                              startTime: selectedStartTime,
                              endTime: selectedEndTime,
                              subject: selectedSubject!,
                              professor: professorController.text.trim(),
                              room: roomController.text.trim(),
                              color: _subjectColors[selectedSubject!]!,
                            );
                            setState(() => _classes.add(newClass));
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

  Widget _buildDayDropdown(String value, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      items:
          _days
              .map((day) => DropdownMenuItem(value: day, child: Text(day)))
              .toList(),
      onChanged: onChanged,
      decoration: const InputDecoration(
        labelText: 'Day',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildStartTimeDropdown(
    String value,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      items:
          _timeSlots
              .map((time) => DropdownMenuItem(value: time, child: Text(time)))
              .toList(),
      onChanged: onChanged,
      decoration: const InputDecoration(
        labelText: 'Start Time',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildEndTimeDropdown(
    String value,
    List<String> validEndTimes,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      items:
          validEndTimes
              .map((time) => DropdownMenuItem(value: time, child: Text(time)))
              .toList(),
      onChanged: onChanged,
      decoration: const InputDecoration(
        labelText: 'End Time',
        border: OutlineInputBorder(),
      ),
      disabledHint:
          validEndTimes.isEmpty ? const Text("Select start time first") : null,
    );
  }

  Widget _buildSubjectDropdown(String? value, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      items: [
        ..._subjectColors.keys.map((subject) {
          return DropdownMenuItem(
            value: subject,
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  color: _subjectColors[subject],
                  margin: const EdgeInsets.only(right: 8),
                ),
                Flexible(child: Text(subject, overflow: TextOverflow.ellipsis)),
              ],
            ),
          );
        }).toList(),
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
      decoration: const InputDecoration(
        labelText: 'Subject',
        border: OutlineInputBorder(),
      ),
      hint: _subjectColors.isEmpty ? const Text("Add a subject first") : null,
    );
  }

  Widget _buildProfessorField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Professor',
        border: OutlineInputBorder(),
      ),
      textCapitalization: TextCapitalization.words,
    );
  }

  Widget _buildRoomField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Room',
        border: OutlineInputBorder(),
      ),
      textCapitalization: TextCapitalization.words,
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
            decoration: const InputDecoration(
              labelText: 'Subject Name',
              hintText: 'Enter subject name',
              border: OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.words,
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

    List<Color> colorOptions =
        {
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
          _generateRandomColor(),
        }.toList();

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
                      decoration: const InputDecoration(
                        labelText: 'Subject Name',
                        border: OutlineInputBorder(),
                      ),
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 16),
                    const Text('Select Color:'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children:
                          colorOptions
                              .map(
                                (color) => _buildColorOption(
                                  color,
                                  selectedColor,
                                  () {
                                    setDialogState(() => selectedColor = color);
                                  },
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
                      setState(() {
                        if (newName != originalSubjectName &&
                            _subjectColors.containsKey(newName)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Subject "$newName" already exists.',
                              ),
                            ),
                          );
                          return;
                        }

                        _subjectColors.remove(originalSubjectName);
                        _subjectColors[newName] = selectedColor;

                        _classes =
                            _classes.map((classItem) {
                              if (classItem.subject == originalSubjectName) {
                                return classItem.copyWith(
                                  subject: newName,
                                  color: selectedColor,
                                );
                              }
                              return classItem;
                            }).toList();
                      });
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
    Color color,
    Color selectedColor,
    VoidCallback onTap,
  ) {
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
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withAlpha(isSelected ? 255 : (255 * 0.5).round()),
            width: isSelected ? 3 : 1.5,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 3,
                      offset: const Offset(1, 1),
                    ),
                  ]
                  : null,
        ),
        child:
            isSelected
                ? Icon(
                  Icons.check,
                  color:
                      HSLColor.fromColor(color).lightness > 0.5
                          ? Colors.black
                          : Colors.white,
                  size: 20,
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
        builder:
            (context) => AlertDialog(
              title: const Text('Cannot Delete Subject'),
              content: Text(
                'Subject "$subject" is used in your schedule. Please remove or change classes using it first.',
              ),
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
        builder:
            (context) => AlertDialog(
              title: const Text('Delete Subject?'),
              content: Text(
                'Are you sure you want to delete the subject "$subject"? This cannot be undone.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  onPressed: () {
                    setState(() => _subjectColors.remove(subject));
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Subject "$subject" deleted.')),
                    );
                  },
                  child: const Text('Delete'),
                ),
              ],
            ),
      );
    }
  }

  void _showClassDetails(Class classItem) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
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
    final professorController = TextEditingController(
      text: classItem.professor,
    );
    final roomController = TextEditingController(text: classItem.room);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final validEndTimes = _getValidEndTimes(selectedStartTime);
            if (!validEndTimes.contains(selectedEndTime)) {
              selectedEndTime =
                  validEndTimes.isNotEmpty
                      ? validEndTimes.first
                      : _timeSlots.last;
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
                        selectedEndTime =
                            _getValidEndTimes(selectedStartTime).firstOrNull ??
                            _timeSlots.last;
                      }),
                    ),
                    const SizedBox(height: 16),
                    _buildEndTimeDropdown(
                      selectedEndTime,
                      _getValidEndTimes(selectedStartTime),
                      (value) => setDialogState(() => selectedEndTime = value!),
                    ),
                    const SizedBox(height: 16),
                    _buildSubjectDropdown(selectedSubject, (value) async {
                      if (value == 'add_new') {
                        final newSubject = await _showAddSubjectDialog();
                        if (newSubject != null && newSubject.isNotEmpty) {
                          setDialogState(() {
                            if (!_subjectColors.containsKey(newSubject)) {
                              _subjectColors[newSubject] =
                                  _generateRandomColor();
                            }
                            selectedSubject = newSubject;
                          });
                        }
                      } else {
                        setDialogState(() => selectedSubject = value!);
                      }
                    }),
                    const SizedBox(height: 16),
                    _buildProfessorField(professorController),
                    const SizedBox(height: 16),
                    _buildRoomField(roomController),
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
                    setState(() {
                      _classes[_classes.indexWhere(
                        (c) => c.id == classItem.id,
                      )] = classItem.copyWith(
                        day: selectedDay,
                        startTime: selectedStartTime,
                        endTime: selectedEndTime,
                        subject: selectedSubject,
                        professor: professorController.text.trim(),
                        room: roomController.text.trim(),
                        color: _subjectColors[selectedSubject]!,
                      );
                    });
                    Navigator.of(context).pop();
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
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Class?'),
            content: Text(
              'Are you sure you want to delete the class "${classItem.subject}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                onPressed: () {
                  setState(
                    () => _classes.removeWhere((c) => c.id == classItem.id),
                  );
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Class "${classItem.subject}" deleted.'),
                    ),
                  );
                },
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}

class Class {
  final int id;
  final String day, startTime, endTime, subject, professor, room;
  final Color color;

  Class({
    required this.id,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.subject,
    required this.professor,
    required this.room,
    required this.color,
  });

  Class copyWith({
    int? id,
    String? day, startTime, endTime, subject, professor, room,
   
    Color? color,
  }) {
    return Class(
      id: id ?? this.id,
      day: day ?? this.day,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      subject: subject ?? this.subject,
      professor: professor ?? this.professor,
      room: room ?? this.room,
      color: color ?? this.color,
    );
  }
}