import '../models/notice_item.dart';

// API든 Mock이든 공통으로 지켜야 할 규칙(인터페이스) 정의
abstract class NoticeRepository {
  Future<List<NoticeItem>> getNotices();
  Future<NoticeItem> getNoticeDetail(int id);
  Future<void> markAsRead(int id);
}