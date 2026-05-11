// lib/features/auth/providers/auth_session_provider.dart
// 역할: SharedPreferences로 로그인 세션 영속성 관리.
//       앱 재시작 후에도 로그인 상태를 유지한다.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthSessionNotifier extends AsyncNotifier<bool> {
  static const _key = 'is_logged_in';

  @override
  Future<bool> build() async {
    // 앱 시작 시 SharedPreferences에서 로그인 여부를 읽어온다
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  Future<void> login() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
    state = const AsyncData(true);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    state = const AsyncData(false);
  }
}

final authSessionProvider =
    AsyncNotifierProvider<AuthSessionNotifier, bool>(AuthSessionNotifier.new);
