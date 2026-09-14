// lib/data/models/academic_event.dart

class AcademicEvent {
  final int id;
  final String title;
  final DateTime startDate;
  final DateTime? endDate;
  final String category; // "ACADEMIC" | "EXAM" | "REGISTRATION" | "VACATION" | "EVENT" | "ETC"

  AcademicEvent({
    required this.id,
    required this.title,
    required this.startDate,
    this.endDate,
    required this.category,
  });

  factory AcademicEvent.fromJson(Map<String, dynamic> json) {
    try {
      return AcademicEvent(
        id: json['id'] ?? 0,
        title: json['title'] ?? '',
        startDate: DateTime.parse(json['startDate']),
        endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
        category: json['category'] ?? 'ETC',
      );
    } catch (e) {
      // 파싱 실패 시 방어 코드: 현재 시간으로 대체
      return AcademicEvent(
        id: json['id'] ?? 0,
        title: json['title'] ?? '날짜 형식 오류',
        startDate: DateTime.now(),
        category: 'ETC',
      );
    }
  }
}
