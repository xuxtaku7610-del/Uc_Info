// lib/features/home/widgets/shortcut_grid.dart
// 역할: 바로가기 4×2 그리드 (8개 항목). url이 있는 항목은 외부 브라우저로 열고,
//       없는 항목(Phase 2 예정)은 SnackBar로 안내한다.

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:university_portal_flutter/core/theme/app_colors.dart';
import 'package:university_portal_flutter/shared/widgets/common_widgets.dart';
import 'package:university_portal_flutter/core/theme/app_spacing.dart';
import 'package:university_portal_flutter/core/theme/app_text_styles.dart';

class ShortcutGrid extends StatelessWidget {
  const ShortcutGrid({super.key});

  static const _items = [
    _ShortcutItem('홈페이지',    Icons.language,             url: 'https://www.uc.ac.kr'),
    _ShortcutItem('도서관',      Icons.local_library_outlined, url: 'https://lib.uc.ac.kr'),
    _ShortcutItem('학사 시스템', Icons.school_outlined,        url: 'https://hak.uc.ac.kr'),
    _ShortcutItem('온라인 출결', Icons.how_to_reg_outlined),   // Phase 2
    _ShortcutItem('통학버스',    Icons.directions_bus_outlined), // Phase 2
    _ShortcutItem('학생 생활관', Icons.apartment),             // Phase 2
    _ShortcutItem('클로버 시스템', Icons.computer),            // Phase 2
    _ShortcutItem('캠퍼스 맵',   Icons.map_outlined),          // Phase 2
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
              childAspectRatio: 0.9,
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
  final String? url; // null이면 Phase 2 예정 항목

  const _ShortcutItem(this.label, this.icon, {this.url});
}

class _ShortcutButton extends StatelessWidget {
  final _ShortcutItem item;

  const _ShortcutButton({required this.item});

  Future<void> _handleTap(BuildContext context) async {
    if (item.url != null) {
      // url이 있는 항목: 외부 브라우저로 열기
      final uri = Uri.parse(item.url!);
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!opened && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.label} 페이지를 열 수 없습니다.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      // url이 없는 항목: Phase 2 안내
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item.label} — Phase 2에서 연결 예정입니다.'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
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
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(item.icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textPrimary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
