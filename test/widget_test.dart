import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:university_portal_flutter/app.dart';

void main() {
  testWidgets('Scaffold template renders', (WidgetTester tester) async {
    await tester.pumpWidget(const UniversityPortalApp());

    expect(find.text('ULSAN COLLEGE'), findsOneWidget);
    expect(find.text('시간표'), findsOneWidget);
    expect(find.text('식단표'), findsOneWidget);
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });
}
