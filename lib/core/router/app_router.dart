// lib/core/router/app_router.dart
// 역할: GoRouter 라우트 정의. TokenStorage(secure storage)의 토큰 존재 여부에 따라 /auth↔/home 리다이렉트.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:university_portal_flutter/features/auth/providers/auth_session_provider.dart';
import 'package:university_portal_flutter/features/auth/screens/auth_screen.dart';
import 'package:university_portal_flutter/features/grade_simulator/screens/grade_simulator_screen.dart';
import 'package:university_portal_flutter/features/home/screens/home_screen.dart';
import 'package:university_portal_flutter/features/mypage/screens/mypage_screen.dart';
import 'package:university_portal_flutter/features/mypage/screens/privacy_policy_screen.dart';
import 'package:university_portal_flutter/features/notice/screens/notice_detail_screen.dart';
import 'package:university_portal_flutter/features/notice/screens/notice_translation_screen.dart';
import 'package:university_portal_flutter/data/models/notice_item.dart';
import 'package:university_portal_flutter/features/academic_calendar/screens/academic_calendar_screen.dart';
import 'package:university_portal_flutter/features/scholarship/screens/scholarship_list_screen.dart';
import 'package:university_portal_flutter/features/scholarship/screens/scholarship_detail_screen.dart';
import 'package:university_portal_flutter/features/enrollment/screens/course_picker_screen.dart';

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
      GoRoute(path: '/privacy-policy', builder: (_, __) => const PrivacyPolicyScreen()),
      GoRoute(path: '/grade-simulator', builder: (_, _) => const GradeSimulatorScreen()),
      GoRoute(path: '/academic-calendar', builder: (_, _) => const AcademicCalendarScreen()),
      GoRoute(path: '/scholarships', builder: (_, _) => const ScholarshipListScreen()),
      GoRoute(path: '/course-picker', builder: (_, _) => const CoursePickerScreen()),
      GoRoute(
        path: '/scholarship/:id',
        builder: (context, state) {
          final id = _safeParseId(state.pathParameters['id']);
          if (id == null) {
            return const _InvalidRouteScreen(message: '잘못된 장학금 정보입니다.');
          }
          return ScholarshipDetailScreen(scholarshipId: id);
        },
      ),
      GoRoute(
        path: '/notice/translation',
        builder: (_, _) => const NoticeTranslationScreen(),
      ),
      GoRoute(
        path: '/notice/:id',
        builder: (context, state) {
          final id = _safeParseId(state.pathParameters['id']);
          if (id == null) {
            return const _InvalidRouteScreen(message: '잘못된 공지사항 정보입니다.');
          }
          // 만약 state.extra로 NoticeItem이 넘어온다면 사용 가능
          final notice = state.extra as NoticeItem?;
          return NoticeDetailScreen(noticeId: id, notice: notice);
        },
      ),
    ],
  );
});

/// 딥링크 등을 통해 전달된 ID 파라미터를 안전하게 숫자로 변환합니다.
int? _safeParseId(String? raw) => raw == null ? null : int.tryParse(raw);

/// 라우팅 파라미터 오류 시 표시되는 에러 화면입니다.
class _InvalidRouteScreen extends StatelessWidget {
  final String message;
  const _InvalidRouteScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('오류')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            Text(message, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('홈으로 돌아가기'),
            ),
          ],
        ),
      ),
    );
  }
}
