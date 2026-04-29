// lib/features/home/widgets/shortcut_grid.dart
// 역할: 바로가기 4×2 그리드 (8개 항목). Phase 2에서 각 항목에 외부 링크 연결 예정.

import 'package:flutter/material.dart';
import 'package:university_portal_flutter/core/theme/app_colors.dart';
import 'package:university_portal_flutter/core/theme/app_spacing.dart';
import 'package:university_portal_flutter/core/theme/app_text_styles.dart';

class ShortcutGrid extends StatelessWidget {
  const ShortcutGrid({super.key});

  static const _items = [
    _ShortcutItem('홈페이지', Icons.language),
    _ShortcutItem('도서관', Icons.local_library_outlined),
    _ShortcutItem('학사 시스템', Icons.school_outlined),
    _ShortcutItem('온라인 출결', Icons.how_to_reg_outlined),
    _ShortcutItem('통학버스', Icons.directions_bus_outlined),
    _ShortcutItem('학생 생활관', Icons.apartment),
    _ShortcutItem('클로버 시스템', Icons.computer),
    _ShortcutItem('캠퍼스 맵', Icons.map_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
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

  const _ShortcutItem(this.label, this.icon);
}

class _ShortcutButton extends StatelessWidget {
  final _ShortcutItem item;

  const _ShortcutButton({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item.label} — Phase 2에서 연결 예정'),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      ),
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
