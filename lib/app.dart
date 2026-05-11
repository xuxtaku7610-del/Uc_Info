import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/providers/settings_provider.dart';

class UniversityPortalApp extends ConsumerWidget {
  const UniversityPortalApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    // darkModeEnabled 값만 선택적으로 감시 — 다른 설정 변경 시 불필요한 rebuild 방지
    final isDark = ref.watch(
      settingsProvider.select((s) => s.darkModeEnabled),
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'UC Info',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
    );
  }
}