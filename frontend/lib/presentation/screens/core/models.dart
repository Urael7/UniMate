
class ClassInfo {
  final String subject;
  final String time;
  final String room;
  final String professor;
  final int? startsInMinutes; 

  ClassInfo({
    required this.subject,
    required this.time,
    required this.room,
    required this.professor,
    this.startsInMinutes,
  });
}

class Assignment {
  final String id;
  final String title;
  final String subject;
  final DateTime dueDate;
  final String status; 
  final double progress; 
  final String priority;

  Assignment({
    required this.id,
    required this.title,
    required this.subject,
    required this.dueDate,
    required this.status,
    required this.progress,
    required this.priority,
  });
}

class Exam {
  final String id;
  final String subject;
  final DateTime dateTime;
  final String room;
  final String type; 

  Exam({
    required this.id,
    required this.subject,
    required this.dateTime,
    required this.room,
    required this.type,
  });
}
