import 'package:flutter/material.dart';
import '../../../data/models/notice_item.dart';
import '../../../data/repositories/notice_repository.dart';

class NoticeProvider with ChangeNotifier {
  final NoticeRepository repository;

  List<NoticeItem> _notices = [];
  bool _isLoading = false;
  String? _errorMessage;

  NoticeProvider({required this.repository});

  List<NoticeItem> get notices => _notices;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchNotices() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _notices = await repository.getNotices();
    } catch (e) {
      _errorMessage = '공지사항을 불러오지 못했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> readNotice(int id) async {
    try {
      await repository.markAsRead(id);
      final index = _notices.indexWhere((n) => n.id == id);
      if (index != -1) {
        _notices[index] = _notices[index].copyWith(isRead: true);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('읽음 처리 API 전송 실패: $e');
    }
  }
}