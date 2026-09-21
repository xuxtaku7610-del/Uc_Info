// lib/features/home/screens/home_screen.dart
// 역할: 메인 화면. UCHeader + 학생 배너 + 빠른 실행 + 바로가기 + 공지사항을 조립한다.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:university_portal_flutter/core/theme/app_colors.dart';
import 'package:university_portal_flutter/core/theme/app_spacing.dart';
import 'package:university_portal_flutter/core/theme/app_text_styles.dart';
import 'package:university_portal_flutter/features/home/widgets/notice_section.dart';
import 'package:university_portal_flutter/features/home/widgets/quick_action_section.dart';
import 'package:university_portal_flutter/features/home/widgets/shortcut_grid.dart';
import 'package:university_portal_flutter/features/home/widgets/student_banner.dart';
import 'package:university_portal_flutter/features/home/widgets/banner_carousel.dart';
import 'package:university_portal_flutter/features/auth/providers/user_provider.dart';
import 'package:university_portal_flutter/features/notification/providers/notice_inbox_provider.dart';
import 'package:university_portal_flutter/features/notification/screens/notice_inbox_sheet.dart';
import 'package:university_portal_flutter/features/settings/screens/settings_sheet.dart';
import 'package:university_portal_flutter/shared/widgets/common_widgets.dart';
import 'package:university_portal_flutter/shared/widgets/uc_header.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // 앱 시작 시 공지 업데이트 체크
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(noticeInboxProvider.notifier).checkForUpdates();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // 앱 복귀 시 공지 업데이트 체크
      ref.read(noticeInboxProvider.notifier).checkForUpdates();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: context.background,
      appBar: UCHeader(
        showSettings: true,
        onSettingsTap: () => showAppBottomSheet<void>(
          context,
          (_) => const SettingsSheet(),
          isScrollControlled: true,
        ),
        showNotificationBell: true,
        onNotificationTap: () => showAppBottomSheet<void>(
          context,
          (_) => const NoticeInboxSheet(),
          isScrollControlled: true,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 1. 학생 인사 배너
              if (userState.isLoading)
                const SizedBox(
                  height: 120,
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (userState.user != null)
                StudentBanner(user: userState.user!)
              else
                const SizedBox(height: AppSpacing.sm),

              // ── 1-1. 공지 배너 캐러셀
              const SizedBox(height: AppSpacing.md),
              const BannerCarousel(),

              // ── 2. 빠른 실행 (시간표 · 식단표)
              const SizedBox(height: AppSpacing.lg),
              Text('빠른 실행', style: AppTextStyles.heading3),
              const SizedBox(height: AppSpacing.sm),
              const QuickActionSection(),

              // ── 3. 바로가기 8개 그리드
              const SizedBox(height: AppSpacing.lg),
              const ShortcutGrid(),

              // ── 4. 공지사항 탭 + 리스트
              const SizedBox(height: AppSpacing.lg),
              const NoticeSection(),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
