// lib/data/models/course_offering.dart

class CourseOffering {
  final int id;
  final String subject;
  final String day;
  final int startHour;
  final int endHour;
  final String room;
  final String professor;
  final String department;
  final int targetYear;

  CourseOffering({
    required this.id,
    required this.subject,
    required this.day,
    required this.startHour,
    required this.endHour,
    required this.room,
    required this.professor,
    required this.department,
    required this.targetYear,
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
      department: json['department'] ?? '',
      // TODO: 실제 서버 필드명이 'targetYear'가 맞는지 실응답으로 확인 필요
      targetYear: json['targetYear'] ?? 1,
    );
  }
}
