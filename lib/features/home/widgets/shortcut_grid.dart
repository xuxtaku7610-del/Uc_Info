// lib/features/home/widgets/shortcut_grid.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:university_portal_flutter/core/theme/app_colors.dart';
import 'package:university_portal_flutter/shared/utils/debounced_navigation.dart';
import 'package:university_portal_flutter/shared/widgets/common_widgets.dart';
import 'package:university_portal_flutter/core/theme/app_spacing.dart';
import 'package:university_portal_flutter/core/theme/app_text_styles.dart';

class ShortcutGrid extends StatelessWidget {
  const ShortcutGrid({super.key});

  static const _items = [
    _ShortcutItem('홈페이지',    Icons.language,             url: 'https://www.uc.ac.kr'),
    _ShortcutItem('도서관',      Icons.local_library_outlined, url: 'https://lib.uc.ac.kr'),
    _ShortcutItem('학사 시스템', Icons.school_outlined,        url: 'https://portal.uc.ac.kr/common/login/login.do'),
    _ShortcutItem('학사일정',    Icons.calendar_month_outlined, route: '/academic-calendar'),
    _ShortcutItem('장학안내',    Icons.card_membership_outlined, route: '/scholarships'),
    _ShortcutItem('수강신청',    Icons.add_task_outlined,      route: '/course-picker'),
    _ShortcutItem('클로버',      Icons.computer, url: 'https://clover.uc.ac.kr/clientMain/a/t/main.do'),
  ];

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('바로가기', style: AppTextStyles.heading3),
          const SizedBox(height: AppSpacing.md),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) =>
                _ShortcutButton(item: _items[index]),
          ),
        ],
      ),
    );
  }
}

class _ShortcutItem {
  final String label;
  final IconData icon;
  final String? url;
  final String? route;

  const _ShortcutItem(this.label, this.icon, {this.url, this.route});
}

class _ShortcutButton extends StatelessWidget {
  final _ShortcutItem item;

  const _ShortcutButton({required this.item});

  Future<void> _handleTap(BuildContext context) async {
    if (item.route != null) {
      context.pushOnce(item.route!);
    } else if (item.url != null) {
      final uri = Uri.parse(item.url!);
      final opened = await launchUrl(uri, mode: LaunchMode.inAppWebView);
      if (!opened && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${item.label} 페이지를 열 수 없습니다.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${item.label} — 연결 예정입니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _handleTap(context),
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm + 4),
            decoration: BoxDecoration(
              color: context.primaryTint,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(item.icon, color: AppColors.primary, size: 26),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: context.textPrimary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
