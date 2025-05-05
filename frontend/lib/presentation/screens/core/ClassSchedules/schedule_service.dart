import 'package:flutter/material.dart';
import 'package:frontend/models/class.dart';

class ScheduleService extends ChangeNotifier {
  final List<Class> _classes = [];
  final Map<String, Color> _subjectColors = {};
  final List<Color> colorPalette = [
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.amber,
    Colors.red,
    Colors.indigo,
    Colors.teal,
    Colors.pink,
    Colors.deepPurple,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.deepOrange,
    Colors.brown,
  ];

  List<Class> get classes => List.unmodifiable(_classes);
  Map<String, Color> get subjectColors => Map.unmodifiable(_subjectColors);

  Color _getNextColor() {
 
    if (_subjectColors.length >= colorPalette.length) {
      return colorPalette[_subjectColors.length % colorPalette.length];
    }
    return colorPalette[_subjectColors.length];
  }
  
  ScheduleService() {
    _initializeSampleData(); 
  }

  void _initializeSampleData() {
    final sampleClasses = [
      Class(
        day: 'Mon',
        startTime: '8 AM',
        endTime: '9 AM',
        subject: 'Mathematics',
        professor: 'Dr. Smith',
        room: 'Room 201',
      ),
      Class(
        day: 'Mon',
        startTime: '10 AM',
        endTime: '12 PM',
        subject: 'Physics',
        professor: 'Prof. Johnson',
        room: 'Lab 101',
      ),
      Class(
        day: 'Wed',
        startTime: '1 PM',
        endTime: '3 PM',
        subject: 'Comp Sci',
        professor: 'Dr. Ada L.',
        room: 'CS Bld 404',
      ),
      Class(
        day: 'Sat',
        startTime: '10 AM',
        endTime: '12 PM',
        subject: 'Yoga',
        professor: 'Instructor Lee',
        room: 'Studio 3',
      ),
    ];

    for (var classItem in sampleClasses) {
      addClass(classItem);
    }
  }

  void addClass(Class newClass) {
    // Ensure the subject has a color assigned
    if (!_subjectColors.containsKey(newClass.subject)) {
      _subjectColors[newClass.subject] = _getNextColor();
    }

    // Create a new class with the assigned color
    final classWithColor = newClass.copyWith(
      color: _subjectColors[newClass.subject]!,
    );

    _classes.add(classWithColor);
  }

  void updateClass(int id, Class updatedClass) {
    final index = _classes.indexWhere((c) => c.id == id);
    if (index != -1) {
      // Ensure the subject has a color assigned
      if (!_subjectColors.containsKey(updatedClass.subject)) {
        _subjectColors[updatedClass.subject] = _getNextColor();
      }

      final updatedWithColor = updatedClass.copyWith(
        color: _subjectColors[updatedClass.subject]!,
      );

      _classes[index] = updatedWithColor;
    }
  }

  void deleteClass(int id) {
    _classes.removeWhere((c) => c.id == id);
  }

  void addSubject(String subject, [Color? color]) {
    _subjectColors[subject] = color ?? _getNextColor();
  }

  void updateSubject(String oldName, String newName, [Color? color]) {
    if (_subjectColors.containsKey(oldName)) {
      final existingColor = _subjectColors[oldName]!;
      _subjectColors.remove(oldName);
      _subjectColors[newName] = color ?? existingColor;

      // Update all classes with the old subject name
      for (int i = 0; i < _classes.length; i++) {
        if (_classes[i].subject == oldName) {
          _classes[i] = _classes[i].copyWith(
            subject: newName,
            color: color ?? existingColor,
          );
        }
      }
    }
  }

  void deleteSubject(String subject) {
    _subjectColors.remove(subject);
  }
}
