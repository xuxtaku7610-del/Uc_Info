// test/widget_test.dart
// 역할: 앱의 핵심 흐름을 검증하는 위젯 테스트.
//       TokenStorage/토큰 존재 여부에 따라 올바른 화면으로 이동하는지 확인한다.

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:university_portal_flutter/app.dart';

void main() {
  const MethodChannel channel = MethodChannel('plugins.it_nomads.com/flutter_secure_storage');

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('미로그인 → 인증 화면 표시', (WidgetTester tester) async {
    // 토큰 없음 (null 반환)
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'read') return null;
      return null;
    });

    await tester.pumpWidget(
      const ProviderScope(child: UniversityPortalApp()),
    );
    await tester.pumpAndSettle();

    expect(find.text('학번 인증'), findsOneWidget);
    expect(find.text('학번 인증하기'), findsOneWidget);
    expect(find.text('이름'), findsOneWidget);
  });

  testWidgets('로그인 상태 → 홈 화면 표시', (WidgetTester tester) async {
    // 토큰 존재
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'read') return 'dummy_test_token';
      return null;
    });

    await tester.pumpWidget(
      const ProviderScope(child: UniversityPortalApp()),
    );
    await tester.pumpAndSettle();

    expect(find.text('바로가기'), findsOneWidget);
    expect(find.text('빠른 실행'), findsOneWidget);
  });
}
