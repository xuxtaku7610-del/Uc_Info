// test/widget_test.dart
// 역할: 앱의 핵심 흐름을 검증하는 위젯 테스트.
//       SharedPreferences 상태에 따라 올바른 화면으로 이동하는지 확인한다.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:university_portal_flutter/app.dart';

void main() {
  // 각 테스트 전에 SharedPreferences를 초기화해 테스트 간 상태 누수를 방지한다.
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('미로그인 → 인증 화면 표시', (WidgetTester tester) async {
    // 로그인 이력 없음 (빈 SharedPreferences)
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      // Riverpod 사용 앱은 반드시 ProviderScope로 감싸야 한다.
      const ProviderScope(child: UniversityPortalApp()),
    );
    // GoRouter redirect + AsyncNotifier(authSessionProvider) 초기화 완료까지 대기
    await tester.pumpAndSettle();

    expect(find.text('학번 인증'), findsOneWidget);
    expect(find.text('학번 인증하기'), findsOneWidget);
    expect(find.text('이름'), findsOneWidget);
  });

  testWidgets('로그인 상태 → 홈 화면 표시', (WidgetTester tester) async {
    // is_logged_in = true 로 설정 (authSessionProvider가 읽는 키)
    SharedPreferences.setMockInitialValues({'is_logged_in': true});

    await tester.pumpWidget(
      const ProviderScope(child: UniversityPortalApp()),
    );
    await tester.pumpAndSettle();

    expect(find.text('바로가기'), findsOneWidget);
    expect(find.text('빠른 실행'), findsOneWidget);
  });
}
