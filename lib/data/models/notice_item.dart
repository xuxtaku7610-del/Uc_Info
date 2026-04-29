// lib/data/models/notice_item.dart
// 역할: 공지사항 데이터 모델.

class NoticeItem {
  final String title;
  final String date;      // '04.28' 형식
  final String category;  // 'notice' | 'dept_news' | 'dept_notice' | 'scholarship'

  const NoticeItem({
    required this.title,
    required this.date,
    required this.category,
  });
}
