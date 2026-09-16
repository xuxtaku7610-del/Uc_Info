// lib/features/home/widgets/notice_section.dart
// 역할: 공지사항 탭 바 + 필터된 리스트. 탭 선택 시 해당 카테고리 공지만 표시.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:university_portal_flutter/core/theme/app_colors.dart';
import 'package:university_portal_flutter/core/theme/app_spacing.dart';
import 'package:university_portal_flutter/core/theme/app_text_styles.dart';
import 'package:university_portal_flutter/features/home/providers/home_provider.dart';
import 'package:university_portal_flutter/data/models/notice_item.dart';
import 'package:university_portal_flutter/shared/utils/debounced_navigation.dart';
import 'package:university_portal_flutter/shared/widgets/common_widgets.dart';

const _tabs = ['학사', '학과공지', '행사', '장학금', '취업'];
const _categories = ['ACADEMIC', 'DEPARTMENT', 'EVENT', 'SCHOLARSHIP', 'EMPLOYMENT'];

class NoticeSection extends ConsumerWidget {
  const NoticeSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeProvider);
    final category = _categories[state.selectedTabIndex];

    // 가짜 데이터(mockNotices) 대신 Provider가 관리하는 실제 데이터(state.notices)를 필터링
    final filtered = state.notices.where((n) => n.category == category).toList();

    return AppCard(
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
                              : context.divider,
                          width: selected ? 2.5 : 1,
                        ),
                      ),
                    ),
                    child: Text(
                      _tabs[i],
                      style: AppTextStyles.label.copyWith(
                        color: selected
                            ? AppColors.primary
                            : context.textSecondary,
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
          if (state.isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (state.errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      state.errorMessage!,
                      style: AppTextStyles.body2.copyWith(color: context.textHint),
                    ),
                    TextButton.icon(
                      onPressed: () => ref.read(homeProvider.notifier).fetchNotices(),
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text('다시 시도'),
                    ),
                  ],
                ),
              ),
            )
          else if (filtered.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
              child: Center(
                child: Text(
                  '공지사항이 없습니다',
                  style: AppTextStyles.body2
                      .copyWith(color: context.textHint),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final notice = filtered[index];
                return _NoticeListItem(notice: notice);
              },
            ),

          const SizedBox(height: AppSpacing.xs),
        ],
      ),
    );
  }
}

class _NoticeListItem extends StatelessWidget {
  final NoticeItem notice;

  const _NoticeListItem({required this.notice});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushOnce(
        '/notice/${notice.id}',
        extra: notice,
      ),
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
            Icon(
              Icons.chevron_right,
              size: 16,
              color: context.textHint,
            ),
          ],
        ),
      ),
    );
  }
}
