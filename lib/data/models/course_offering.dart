// lib/data/models/course_offering.dart

class CourseOffering {
  final int id;
  final String subject;
  final String day;
  final int startHour;
  final int endHour;
  final String room;
  final String professor;

  CourseOffering({
    required this.id,
    required this.subject,
    required this.day,
    required this.startHour,
    required this.endHour,
    required this.room,
    required this.professor,
  });

  factory CourseOffering.fromJson(Map<String, dynamic> json) {
    return CourseOffering(
      id: json['id'] ?? 0,
      subject: json['subject'] ?? '',
      day: json['day'] ?? '월',
      startHour: json['startHour'] ?? 9,
      endHour: json['endHour'] ?? 10,
      room: json['room'] ?? '',
      professor: json['professor'] ?? '',
    );
  }
}
