import 'package:flutter/material.dart';
import 'package:frontend/models/exam.dart';

class ExamService with ChangeNotifier {
  final List<Exam> _exams = [];

  List<Exam> get exams => List.unmodifiable(_exams);

  List<Exam> get upcomingExams {
    final now = DateTime.now();
    return _exams.where((exam) => exam.date.isAfter(now)).toList();
  }

  List<Exam> getPastExams() {
    final now = DateTime.now();
    return _exams.where((exam) => exam.date.isBefore(now)).toList();
  }

  List<Exam> getExamsBySubject(String subject) {
    return _exams.where((exam) => exam.subject == subject).toList();
  }

  void addExam(Exam exam) {
    final newId =
        _exams.isEmpty
            ? 1
            : _exams.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
    _exams.add(exam.copyWith(id: newId));
    notifyListeners();
  }

  void updateExam(Exam updatedExam) {
    final index = _exams.indexWhere((e) => e.id == updatedExam.id);
    if (index != -1) {
      _exams[index] = updatedExam;
      notifyListeners();
    }
  }

  void deleteExam(int id) {
    _exams.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  ExamService(){
    _initializeSampleData();
  }

  void _initializeSampleData() {
    _exams.addAll([
      Exam(
        id: 1,
        subject: 'Mathematics',
        course: 'Calculus II',
        date: '2025-10-25',
        time: '9:00 AM - 11:00 AM',
        location: 'Hall A',
        professor: 'Dr. Smith',
        topics: ['Derivatives', 'Integrals', 'Applications'],
      ),
      Exam(
        id: 2,
        subject: 'Computer Science',
        course: 'Data Structures',
        date: '2025-11-05',
        time: '2:00 PM - 4:00 PM',
        location: 'Lab 201',
        professor: 'Dr. Wilson',
        topics: ['Trees', 'Graphs', 'Sorting Algorithms'],
      ),
    ]);
  }
}
