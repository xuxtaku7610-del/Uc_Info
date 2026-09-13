import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/token_storage.dart';

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
    await TokenStorage.clearToken();
    state = const AsyncData(false);
  }
}

final authSessionProvider =
    AsyncNotifierProvider<AuthSessionNotifier, bool>(AuthSessionNotifier.new);
