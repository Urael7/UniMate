import 'dart:ui';

int _nextId = 0;

class Class {

  final int id;
  final String day, startTime, endTime, subject, professor, room;
  final Color? color;


  Class({
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.subject,
    required this.professor,
    required this.room,
    this.color,
  }) : id = _nextId++;


  Class._withId({
    required this.id,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.subject,
    required this.professor,
    required this.room,
    this.color,
  });


  Class copyWith({
    String? day,
    String? startTime,
    String? endTime,
    String? subject,
    String? professor,
    String? room,
    Color? color,
  }) {
   
    return Class._withId(
      id: id, 
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
