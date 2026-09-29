// lib/data/models/scholarship.dart

class Scholarship {
  final int id;
  final String title;
  final String type; // "REGIONAL" | "GRADE" | "INTERNAL" | "EXTERNAL"
  final DateTime deadline;

  Scholarship({
    required this.id,
    required this.title,
    required this.type,
    required this.deadline,
  });

  factory Scholarship.fromJson(Map<String, dynamic> json) {
    DateTime parsedDeadline;
    try {
      parsedDeadline = DateTime.parse(json['deadline'] ?? '');
    } catch (_) {
      parsedDeadline = DateTime.now();
    }

    return Scholarship(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      type: json['type'] ?? 'INTERNAL',
      deadline: parsedDeadline,
    );
  }

  // D-Day 계산 헬퍼
  int get dDay {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(deadline.year, deadline.month, deadline.day);
    return target.difference(today).inDays;
  }
}
