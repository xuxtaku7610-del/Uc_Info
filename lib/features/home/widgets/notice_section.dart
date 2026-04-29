// lib/features/home/widgets/notice_section.dart
// 역할: 공지사항 탭 바 + 필터된 리스트. 탭 선택 시 해당 카테고리 공지만 표시.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:university_portal_flutter/core/theme/app_colors.dart';
import 'package:university_portal_flutter/core/theme/app_spacing.dart';
import 'package:university_portal_flutter/core/theme/app_text_styles.dart';
import 'package:university_portal_flutter/data/mock/mock_data.dart';
import 'package:university_portal_flutter/features/home/providers/home_provider.dart';

const _tabs = ['공지사항', '학과소식', '학과공지', '장학·취업'];
const _categories = ['notice', 'dept_news', 'dept_notice', 'scholarship'];

class NoticeSection extends ConsumerWidget {
  const NoticeSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeProvider);
    final category = _categories[state.selectedTabIndex];
    final filtered =
        mockNotices.where((n) => n.category == category).toList();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 탭 바
          Row(
            children: List.generate(_tabs.length, (i) {
              final selected = i == state.selectedTabIndex;
              return Expanded(
                child: InkWell(
                  onTap: () =>
                      ref.read(homeProvider.notifier).selectTab(i),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sm + 2),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: selected
                              ? AppColors.accent
                              : AppColors.divider,
                          width: selected ? 2.5 : 1,
                        ),
                      ),
                    ),
                    child: Text(
                      _tabs[i],
                      style: AppTextStyles.label.copyWith(
                        color: selected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),

          // 공지 리스트
          if (filtered.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Center(
                child: Text(
                  '등록된 공지사항이 없습니다.',
                  style: AppTextStyles.body2
                      .copyWith(color: AppColors.textHint),
                ),
              ),
            )
          else
            ...filtered.map(
              (notice) => InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 40,
                        child: Text(
                          notice.date,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          notice.title,
                          style: AppTextStyles.body2,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        size: 16,
                        color: AppColors.textHint,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          const SizedBox(height: AppSpacing.xs),
        ],
      ),
    );
  }
}
