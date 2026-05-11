// lib/features/home/widgets/quick_action_section.dart
// 역할: 시간표·식단표 빠른 실행 카드 2열 그리드.

import 'package:flutter/material.dart';
import 'package:university_portal_flutter/core/theme/app_colors.dart';
import 'package:university_portal_flutter/core/theme/app_spacing.dart';
import 'package:university_portal_flutter/core/theme/app_text_styles.dart';
import 'package:university_portal_flutter/features/meal/screens/meal_sheet.dart';
import 'package:university_portal_flutter/features/timetable/screens/timetable_sheet.dart';
import 'package:university_portal_flutter/shared/widgets/common_widgets.dart';

class QuickActionSection extends StatelessWidget {
  const QuickActionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickCard(
            title: '시간표',
            subtitle: '이번 주 수업 확인',
            icon: Icons.calendar_today_outlined,
            onTap: () => showAppBottomSheet<void>(
              context,
              (_) => const TimetableSheet(),
              isScrollControlled: true,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _QuickCard(
            title: '식단표',
            subtitle: '오늘 메뉴 확인',
            icon: Icons.restaurant_outlined,
            onTap: () => showAppBottomSheet<void>(
              context,
              (_) => const MealSheet(),
              isScrollControlled: true,
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: AppCard(
        height: 110,
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primary, size: 26),
            const Spacer(),
            Text(
              title,
              style: AppTextStyles.heading3.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 2),
            Text(subtitle, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}
