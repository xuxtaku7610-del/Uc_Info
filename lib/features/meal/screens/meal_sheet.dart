// lib/features/meal/screens/meal_sheet.dart
// 역할: 오늘의 식단표 Bottom Sheet. 조식·중식·석식 섹션과 알레르기 안내 표시.

import 'package:flutter/material.dart';
import 'package:university_portal_flutter/core/theme/app_colors.dart';
import 'package:university_portal_flutter/core/theme/app_spacing.dart';
import 'package:university_portal_flutter/core/theme/app_text_styles.dart';
import 'package:university_portal_flutter/data/models/meal_data.dart';
import 'package:university_portal_flutter/shared/widgets/common_widgets.dart';

class MealSheet extends StatelessWidget {
  final MealData? meal;

  const MealSheet({super.key, this.meal});

  @override
  Widget build(BuildContext context) {
    if (meal == null) {
      return const SizedBox(
        height: 300,
        child: Center(child: Text('식단 정보가 없습니다.')),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 드래그 핸들
          const Center(child: AppDragHandle()),
          const SizedBox(height: AppSpacing.md),

          // 헤더
          Row(
            children: [
              Text('오늘의 식단', style: AppTextStyles.heading2),
              const Spacer(),
              Text(meal!.date, style: AppTextStyles.caption),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // 조식 / 중식 / 석식
          _buildMealCard('조식', meal!.breakfast),
          const SizedBox(height: AppSpacing.sm),
          _buildMealCard('중식', meal!.lunch),
          const SizedBox(height: AppSpacing.sm),
          _buildMealCard('석식', meal!.dinner),
          const SizedBox(height: AppSpacing.md),

          // 알레르기 안내
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: Border.all(
                color: AppColors.accent.withValues(alpha: 0.5),
              ),
            ),
            child: Text(
              '⚠️  알레르기 유발식품 안내: 식단에 포함된 알레르기 성분은 학생식당 게시판을 확인해주세요.',
              style:
                  AppTextStyles.caption.copyWith(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealCard(String label, MealSection? section) {
    if (section == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.heading3.copyWith(color: AppColors.textHint)),
            const SizedBox(height: AppSpacing.sm),
            const Text('오늘은 운영하지 않습니다.', style: AppTextStyles.body2),
          ],
        ),
      );
    }
    return _MealCard(label: label, section: section);
  }
}

class _MealCard extends StatelessWidget {
  final String label;
  final MealSection section;

  const _MealCard({required this.label, required this.section});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8EE), // 크림색
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label, style: AppTextStyles.heading3),
              const Spacer(),
              Text(section.time, style: AppTextStyles.caption),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (section.items.isEmpty)
            const Text('식단 정보가 없습니다.', style: AppTextStyles.body2)
          else
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.xs,
              children: section.items
                  .map((item) => _MealDot(item: item))
                  .toList(),
            ),
        ],
      ),
    );
  }
}

class _MealDot extends StatelessWidget {
  final String item;

  const _MealDot({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(radius: 3, backgroundColor: AppColors.accent),
        const SizedBox(width: 4),
        Text(item, style: AppTextStyles.body2),
      ],
    );
  }
}
