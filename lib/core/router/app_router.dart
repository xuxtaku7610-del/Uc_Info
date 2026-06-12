// lib/core/router/app_router.dart
// 역할: GoRouter 라우트 정의. SharedPreferences 로그인 상태에 따라 /auth↔/home 리다이렉트.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:university_portal_flutter/features/auth/providers/auth_session_provider.dart';
import 'package:university_portal_flutter/features/auth/screens/auth_screen.dart';
import 'package:university_portal_flutter/features/grade_simulator/screens/grade_simulator_screen.dart';
import 'package:university_portal_flutter/features/home/screens/home_screen.dart';
import 'package:university_portal_flutter/features/mypage/screens/mypage_screen.dart';
import 'package:university_portal_flutter/features/notice/screens/notice_detail_screen.dart';

// GoRouter는 Listenable만 수신 가능 → Riverpod 상태 변화를 ChangeNotifier로 브릿지
class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(this._ref) {
    // authSessionProvider가 바뀔 때마다 GoRouter가 redirect를 재평가하도록 알린다
    _ref.listen<AsyncValue<bool>>(authSessionProvider, (_, _) {
      notifyListeners();
    });
  }
  final Ref _ref;
}

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier(ref);

  return GoRouter(
    initialLocation: '/auth',
    refreshListenable: notifier,
    redirect: (context, state) {
      final authState = ref.read(authSessionProvider);

      // 로딩 중: SharedPreferences 읽기 완료 전이므로 리다이렉트 보류
      if (authState.isLoading) return null;

      final isLoggedIn = authState.valueOrNull ?? false;
      final isOnAuth   = state.matchedLocation == '/auth';

      if (!isLoggedIn && !isOnAuth) return '/auth'; // 미로그인 → 인증 화면 강제
      if (isLoggedIn  && isOnAuth)  return '/home'; // 로그인 완료 → 홈으로
      return null;
    },
    routes: [
      GoRoute(path: '/auth', builder: (_, _) => const AuthScreen()),
      GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
      GoRoute(path: '/mypage', builder: (_, _) => const MypageScreen()),
      GoRoute(path: '/grade-simulator', builder: (_, _) => const GradeSimulatorScreen()),
      GoRoute(
        path: '/notice/:id',
        builder: (_, state) {
          final id = int.parse(state.pathParameters['id']!);
          return NoticeDetailScreen(noticeIndex: id);
        },
      ),
    ],
  );
});
