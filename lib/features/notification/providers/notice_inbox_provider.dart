import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/notice_inbox_entry.dart';
import '../../../shared/providers/app_providers.dart';

class NoticeInboxNotifier extends StateNotifier<List<NoticeInboxEntry>> {
  NoticeInboxNotifier(this._ref) : super([]) {
    _loadFromPrefs();
  }

  final Ref _ref;
  static const _entriesKey = 'notice_inbox_entries';
  static const _seenIdsKey = 'notified_notice_ids';

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final rawEntries = prefs.getString(_entriesKey);
    if (rawEntries != null) {
      state = NoticeInboxEntry.decode(rawEntries);
    }
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_entriesKey, NoticeInboxEntry.encode(state));
  }

  Future<void> checkForUpdates() async {
    try {
      final repository = _ref.read(noticeRepositoryProvider);
      final remoteNotices = await repository.getNotices();
      
      final prefs = await SharedPreferences.getInstance();
      final seenIds = prefs.getStringList(_seenIdsKey)?.map(int.parse).toSet() ?? {};
      
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
        await prefs.setStringList(_seenIdsKey, newSeenIds.map((id) => id.toString()).toList());
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
