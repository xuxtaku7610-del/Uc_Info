import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/token_storage.dart';
import '../../../features/notification/providers/notice_inbox_provider.dart';
import 'user_provider.dart';

class AuthSessionNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    // 단순 플래그가 아닌 실제 토큰 존재 여부로 세션 판단
    final token = await TokenStorage.getToken();
    return token != null;
  }

  Future<void> login() async {
    // 토큰 저장은 Repository에서 수행하므로 여기선 상태만 갱신
    state = const AsyncData(true);
  }

  Future<void> logout() async {
    // 1. 보안 저장소 토큰 삭제
    await TokenStorage.clearToken();

    // 2. 알림함 로컬 데이터(디스크) 삭제
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(NoticeInboxNotifier.entriesKey);
    await prefs.remove(NoticeInboxNotifier.notifiedIdsKey);

    // 3. 메모리 상의 Provider 상태들 초기화
    ref.invalidate(userProvider);
    ref.invalidate(noticeInboxProvider);

    state = const AsyncData(false);
  }
}

final authSessionProvider =
    AsyncNotifierProvider<AuthSessionNotifier, bool>(AuthSessionNotifier.new);
