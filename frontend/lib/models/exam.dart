import 'package:intl/intl.dart';

class Exam {
  final int id;
  final String subject;
  final String course;
  final DateTime date;
  final String time;
  final String location;
  final String professor;
  final List<String> topics;

  Exam({
    required this.id,
    required this.subject,
    required this.course,
    required String date,
    required this.time,
    required this.location,
    required this.professor,
    required this.topics,
  }) : date = DateTime.parse(date);

  Exam copyWith({
    int? id,
    String? subject,
    String? course,
    String? date,
    String? time,
    String? location,
    String? professor,
    List<String>? topics,
  }) {
    return Exam(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      course: course ?? this.course,
      date: date ?? DateFormat('yyyy-MM-dd').format(this.date),
      time: time ?? this.time,
      location: location ?? this.location,
      professor: professor ?? this.professor,
      topics: topics ?? this.topics,
    );
  }
}
