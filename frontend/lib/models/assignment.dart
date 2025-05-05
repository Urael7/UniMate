enum AssignmentStatus { pending, completed, overdue }

enum PriorityLevel { high, medium, low }

class Assignment {
  static int _nextId = 0;

  final int id;
  final String title;
  final String subject;
  final DateTime dueDate;
  final String description;
  AssignmentStatus status;
  final PriorityLevel priority;

  bool get shouldBeOverdue =>
      dueDate.isBefore(DateTime.now()) && status == AssignmentStatus.pending;

  Assignment._internal({
    required this.id,
    required this.title,
    required this.subject,
    required this.dueDate,
    required this.description,
    required this.status,
    required this.priority,
  });

  Assignment({
    required this.title,
    required this.subject,
    required this.dueDate,
    required this.description,
    this.status = AssignmentStatus.pending,
    required this.priority,
  }) : id = _nextId++;

  Assignment copyWith({
    String? title,
    String? subject,
    DateTime? dueDate,
    String? description,
    AssignmentStatus? status,
    PriorityLevel? priority,
  }) {

    return Assignment._internal(
      id: id, 
      title: title ?? this.title,
      subject: subject ?? this.subject,
      dueDate: dueDate ?? this.dueDate,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
    );
  }
}
