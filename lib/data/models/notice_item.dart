// lib/data/models/notice_item.dart
// 역할: 공지사항 데이터 모델.

class NoticeItem {
  final String title;
  final String date;      // '04.28' 형식
  final String category;  // 'notice' | 'dept_news' | 'dept_notice' | 'scholarship'
  final String content;   // Phase 2에서 API 본문으로 대체

  const NoticeItem({
    required this.title,
    required this.date,
    required this.category,
    this.content = '공지사항 본문 내용입니다. Phase 2에서 API로 대체됩니다.',
  });
}
