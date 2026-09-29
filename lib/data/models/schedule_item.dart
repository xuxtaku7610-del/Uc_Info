// lib/data/models/schedule_item.dart
// 역할: 주간 시간표 수업 블록 모델.

class ScheduleItem {
  final int? enrollmentId; // 수강 취소(삭제) 시 필요한 고유 ID
  final String subject;
  final String day;       // '월' | '화' | '수' | '목' | '금'
  final int startHour;
  final int endHour;
  final String room;
  final String professor;
  final int color;        // AppColors.timetableColors 인덱스 (6으로 나눈 나머지로 순환)

  const ScheduleItem({
    this.enrollmentId,
    required this.subject,
    required this.day,
    required this.startHour,
    required this.endHour,
    required this.room,
    required this.professor,
    required this.color,
  });

  factory ScheduleItem.fromJson(Map<String, dynamic> json, {int index = 0}) {
    return ScheduleItem(
      enrollmentId: json['enrollmentId'],
      subject: json['subject'] ?? '',
      day: json['day'] ?? '월',
      startHour: json['startHour'] ?? 9,
      endHour: json['endHour'] ?? 10,
      room: json['room'] ?? '',
      professor: json['professor'] ?? '',
      color: index,
    );
  }
}
