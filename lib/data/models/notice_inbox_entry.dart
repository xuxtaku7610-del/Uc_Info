import 'dart:convert';

class NoticeInboxEntry {
  final int noticeId;
  final String title;
  final String category;
  final String date;
  final DateTime addedAt;
  final bool seen;

  NoticeInboxEntry({
    required this.noticeId,
    required this.title,
    required this.category,
    required this.date,
    required this.addedAt,
    this.seen = false,
  });

  static const _categoryLabels = {
    'ACADEMIC': '학사',
    'DEPARTMENT': '학과공지',
    'EVENT': '행사',
    'SCHOLARSHIP': '장학금',
    'EMPLOYMENT': '취업',
  };

  /// 화면에 표시할 한국어 카테고리명. 알 수 없는 값은 원문 그대로 반환한다.
  String get categoryLabel => _categoryLabels[category] ?? category;

  NoticeInboxEntry copyWith({bool? seen}) {
    return NoticeInboxEntry(
      noticeId: noticeId,
      title: title,
      category: category,
      date: date,
      addedAt: addedAt,
      seen: seen ?? this.seen,
    );
  }

  Map<String, dynamic> toJson() => {
    'noticeId': noticeId,
    'title': title,
    'category': category,
    'date': date,
    'addedAt': addedAt.toIso8601String(),
    'seen': seen,
  };

  factory NoticeInboxEntry.fromJson(Map<String, dynamic> json) => NoticeInboxEntry(
    noticeId: json['noticeId'],
    title: json['title'],
    category: json['category'],
    date: json['date'],
    addedAt: DateTime.parse(json['addedAt']),
    seen: json['seen'] ?? false,
  );

  static String encode(List<NoticeInboxEntry> entries) =>
      json.encode(entries.map((e) => e.toJson()).toList());

  static List<NoticeInboxEntry> decode(String entries) =>
      (json.decode(entries) as List<dynamic>)
          .map((item) => NoticeInboxEntry.fromJson(item))
          .toList();
}
