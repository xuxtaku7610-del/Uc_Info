// lib/data/repositories/notice_repository.dart
import '../models/notice_item.dart';
import '../mock/mock_data.dart';

abstract class NoticeRepository {
  Future<List<NoticeItem>> getNotices();
  Future<NoticeItem> getNoticeDetail(int id);
  Future<void> markAsRead(int id);
}

class MockNoticeRepository implements NoticeRepository {
  @override
  Future<List<NoticeItem>> getNotices() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockData.notices;
  }

  @override
  Future<NoticeItem> getNoticeDetail(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.notices.firstWhere(
      (notice) => notice.id == id,
      orElse: () => throw Exception('해당 공지사항을 찾을 수 없습니다.'),
    );
  }

  @override
  Future<void> markAsRead(int id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    // 실제 상태 변경 로직은 생략하거나 MockData를 수정 가능하게 만들 수 있음
  }
}
