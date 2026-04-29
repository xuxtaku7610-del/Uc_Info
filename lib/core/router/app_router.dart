// lib/core/router/app_router.dart
// 역할: GoRouter 라우트 정의. 앱의 모든 화면 경로를 관리한다.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:university_portal_flutter/features/auth/screens/auth_screen.dart';
import 'package:university_portal_flutter/features/home/screens/home_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/auth',
    routes: [
      GoRoute(path: '/auth', builder: (_, _) => const AuthScreen()),
      GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
      // Bottom Sheet는 라우트 아닌 showModalBottomSheet로 처리
    ],
    redirect: (context, state) {
      // TODO(Phase 2): 로그인 여부에 따라 /auth 리다이렉트
      // Phase 1: 항상 통과
      return null;
    },
  );
});
