// lib/features/home/screens/home_screen.dart
// 역할: 메인 화면. UCHeader + 학생 배너 + 빠른 실행 + 바로가기 + 공지사항을 조립한다.

import 'package:flutter/material.dart';
import 'package:university_portal_flutter/core/theme/app_colors.dart';
import 'package:university_portal_flutter/core/theme/app_spacing.dart';
import 'package:university_portal_flutter/core/theme/app_text_styles.dart';
import 'package:university_portal_flutter/data/mock/mock_data.dart';
import 'package:university_portal_flutter/features/home/widgets/notice_section.dart';
import 'package:university_portal_flutter/features/home/widgets/quick_action_section.dart';
import 'package:university_portal_flutter/features/home/widgets/shortcut_grid.dart';
import 'package:university_portal_flutter/features/home/widgets/student_banner.dart';
import 'package:university_portal_flutter/features/settings/screens/settings_sheet.dart';
import 'package:university_portal_flutter/shared/widgets/uc_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: UCHeader(
        showSettings: true,
        onSettingsTap: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusLg),
            ),
          ),
          builder: (_) => const SettingsSheet(),
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
              const SizedBox(height: AppSpacing.sm),
              StudentBanner(user: mockUser),

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
