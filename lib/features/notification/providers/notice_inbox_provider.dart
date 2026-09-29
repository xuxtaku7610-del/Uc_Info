import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/notice_inbox_entry.dart';
import '../../../shared/providers/app_providers.dart';

class NoticeInboxNotifier extends StateNotifier<List<NoticeInboxEntry>> {
  NoticeInboxNotifier(this._ref) : super([]) {
    _loadFromPrefs();
  }

  final Ref _ref;

  // 계정별 저장을 위한 동적 키 생성 헬퍼
  Future<String> _getEntriesKey() async {
    final prefs = await SharedPreferences.getInstance();
    final studentId = prefs.getString('current_student_id') ?? 'guest';
    return 'notice_inbox_entries_$studentId';
  }

  Future<String> _getNotifiedIdsKey() async {
    final prefs = await SharedPreferences.getInstance();
    final studentId = prefs.getString('current_student_id') ?? 'guest';
    return 'notified_notice_ids_$studentId';
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _getEntriesKey();
    final rawEntries = prefs.getString(key);
    if (rawEntries != null) {
      state = NoticeInboxEntry.decode(rawEntries);
    }
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _getEntriesKey();
    await prefs.setString(key, NoticeInboxEntry.encode(state));
  }

  Future<void> checkForUpdates() async {
    try {
      final repository = _ref.read(noticeRepositoryProvider);
      final remoteNotices = await repository.getNotices();
      
      final prefs = await SharedPreferences.getInstance();
      final key = await _getNotifiedIdsKey();
      final seenIds = prefs.getStringList(key)?.map(int.parse).toSet() ?? {};
      
      final newEntries = <NoticeInboxEntry>[];
      final newSeenIds = Set<int>.from(seenIds);

      for (final notice in remoteNotices) {
        if (!seenIds.contains(notice.id)) {
          newEntries.add(NoticeInboxEntry(
            noticeId: notice.id,
            title: notice.title,
            category: notice.category,
            date: notice.date,
            addedAt: DateTime.now(),
          ));
          newSeenIds.add(notice.id);
        }
      }

      if (newEntries.isNotEmpty) {
        state = [...newEntries, ...state];
        await _saveToPrefs();
        await prefs.setStringList(key, newSeenIds.map((id) => id.toString()).toList());
      }
    } catch (e) {
      // Background check failed silently
    }
  }

  Future<void> markEntrySeen(int noticeId) async {
    bool changed = false;
    state = state.map((entry) {
      if (entry.noticeId == noticeId && !entry.seen) {
        changed = true;
        return entry.copyWith(seen: true);
      }
      return entry;
    }).toList();

    if (changed) {
      await _saveToPrefs();
    }
  }

  /// 모든 알림을 읽음 처리하고 서버에도 반영합니다.
  Future<void> markAllSeen() async {
    if (!state.any((e) => !e.seen)) return;

    final prefs = await SharedPreferences.getInstance();
    final studentId = prefs.getString('current_student_id');
    final repository = _ref.read(noticeRepositoryProvider);

    // 읽지 않았던 항목들의 ID 추출
    final unseenIds = state
        .where((e) => !e.seen)
        .map((e) => e.noticeId)
        .toList();

    // 로컬 상태 즉시 업데이트
    state = state.map((e) => e.copyWith(seen: true)).toList();
    await _saveToPrefs();

    // 서버에도 비동기로 반영 (studentId가 있는 경우만)
    if (studentId != null) {
      for (final id in unseenIds) {
        repository.markAsRead(id, studentId).catchError((_) {
          // 개별 서버 호출 실패는 무시
        });
      }
    }
  }

  bool get hasUnseen => state.any((e) => !e.seen);
  
  List<NoticeInboxEntry> get entries {
    final list = List<NoticeInboxEntry>.from(state);
    list.sort((a, b) => b.addedAt.compareTo(a.addedAt));
    return list;
  }
}

final noticeInboxProvider = StateNotifierProvider<NoticeInboxNotifier, List<NoticeInboxEntry>>((ref) {
  return NoticeInboxNotifier(ref);
});
