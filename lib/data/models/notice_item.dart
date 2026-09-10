// lib/data/models/notice_item.dart
// 역할: 공지사항 데이터 모델.

class NoticeItem {
  final int id;
  final String title;
  final String content;
  final String category; // 'notice', 'dept_news', 'dept_notice', 'scholarship'
  final String date;     // 'MM.dd' 형식 (예: '09.10')
  final bool isRead;

  NoticeItem({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.date,
    this.isRead = false,
  });

  factory NoticeItem.fromJson(Map<String, dynamic> json) {
    return NoticeItem(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      category: json['category'] ?? 'notice',
      date: json['date'] ?? '',
      isRead: json['isRead'] ?? false,
    );
  }

  NoticeItem copyWith({
    int? id,
    String? title,
    String? content,
    String? category,
    String? date,
    bool? isRead,
  }) {
    return NoticeItem(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      date: date ?? this.date,
      isRead: isRead ?? this.isRead,
    );
  }
}