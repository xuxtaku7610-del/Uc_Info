import '../models/notice_item.dart';

abstract class NoticeRepository {
  Future<List<NoticeItem>> getNotices();
  Future<NoticeItem> getNoticeDetail(int id);
  Future<void> markAsRead(int id, String studentId);
}
