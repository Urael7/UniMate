import 'package:flutter/material.dart';
import 'package:frontend/models/assignment.dart';


class AssignmentService extends ChangeNotifier {
  final List<Assignment> _assignments = [];

  List<Assignment> get assignments => List.unmodifiable(_assignments);

  AssignmentService() {
    _loadInitialAssignments();
  }

  void _loadInitialAssignments() {
    _assignments.addAll([
      Assignment(
        title: 'Math Homework 5',
        subject: 'Math',
        dueDate: DateTime.now().add(const Duration(days: 2)),
        description: 'Chapter 3 problems',
        priority: PriorityLevel.high,
      ),
      Assignment(
        title: 'History Essay',
        subject: 'History',
        dueDate: DateTime.now().add(const Duration(days: 5)),
        description: 'World War II causes',
        priority: PriorityLevel.medium,
        status: AssignmentStatus.completed,
      ),
      Assignment(
        title: 'Science Lab Report',
        subject: 'Science',
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
        description: 'Photosynthesis experiment',
        priority: PriorityLevel.high,
      ),
      Assignment(
        title: 'English Reading',
        subject: 'English',
        dueDate: DateTime.now().add(const Duration(days: 10)),
        description: 'Read chapters 1-3 of "To Kill a Mockingbird"',
        priority: PriorityLevel.low,
      ),
    ]);
    updateOverdueStatus(notify: false);
  }

  void updateOverdueStatus({bool notify = true}) {
    bool changed = false;
    for (var assignment in _assignments) {
      if (assignment.status == AssignmentStatus.pending &&
          assignment.dueDate.isBefore(DateTime.now())) {
        assignment.status = AssignmentStatus.overdue;
        changed = true;
      } else if (assignment.status == AssignmentStatus.overdue &&
          assignment.dueDate.isAfter(DateTime.now())) {
        assignment.status = AssignmentStatus.pending;
        changed = true;
      }
    }
    if (changed && notify) {
      notifyListeners();
    }
  }

  void addAssignment({
    required String title,
    required String subject,
    required DateTime dueDate,
    required String description,
    required PriorityLevel priority,
  }) {
    final newAssignment = Assignment(
      title: title,
      subject: subject,
      dueDate: dueDate,
      description: description,
      priority: priority,
      status:
          dueDate.isBefore(DateTime.now())
              ? AssignmentStatus.overdue
              : AssignmentStatus.pending,
    );
    _assignments.add(newAssignment);
    notifyListeners();
  }

  void toggleAssignmentStatus(int id) {
    final index = _assignments.indexWhere((a) => a.id == id);
    if (index != -1) {
      final assignment = _assignments[index];
      if (assignment.status == AssignmentStatus.completed) {
        if (assignment.dueDate.isBefore(DateTime.now())) {
          assignment.status = AssignmentStatus.overdue;
        } else {
          assignment.status = AssignmentStatus.pending;
        }
      } else {
        assignment.status = AssignmentStatus.completed;
      }
      notifyListeners();
    }
  }

  void deleteAssignment(int id) {
    final initialLength = _assignments.length;
    _assignments.removeWhere((a) => a.id == id);
    if (_assignments.length != initialLength) {
      notifyListeners();
    }
  }

  Set<String> getUniqueSubjects() {
    return _assignments.map((a) => a.subject).toSet();
  }
}
