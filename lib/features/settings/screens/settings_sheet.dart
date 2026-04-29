// lib/features/settings/screens/settings_sheet.dart
// 역할: 설정 Bottom Sheet. 알림·다크모드 토글, 언어 선택 드롭다운.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:university_portal_flutter/core/theme/app_colors.dart';
import 'package:university_portal_flutter/core/theme/app_spacing.dart';
import 'package:university_portal_flutter/core/theme/app_text_styles.dart';
import 'package:university_portal_flutter/features/settings/providers/settings_provider.dart';

class SettingsSheet extends ConsumerWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Padding(
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
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          Text('설정', style: AppTextStyles.heading2),
          const SizedBox(height: AppSpacing.sm),

          _SettingRow(
            label: '알림',
            child: Switch(
              value: settings.notificationsEnabled,
              onChanged: notifier.toggleNotifications,
              activeThumbColor: AppColors.primary,
            ),
          ),
          const Divider(height: 1),
          _SettingRow(
            label: '다크 모드',
            child: Switch(
              value: settings.darkModeEnabled,
              onChanged: notifier.toggleDarkMode,
              activeThumbColor: AppColors.primary,
            ),
          ),
          const Divider(height: 1),
          _SettingRow(
            label: '언어 설정',
            child: DropdownButton<String>(
              value: settings.language,
              underline: const SizedBox.shrink(),
              style: AppTextStyles.body2
                  .copyWith(color: AppColors.textPrimary),
              onChanged: notifier.setLanguage,
              items: const [
                DropdownMenuItem(value: '한국어', child: Text('한국어')),
                DropdownMenuItem(value: 'English', child: Text('English')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final String label;
  final Widget child;

  const _SettingRow({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.body1),
          child,
        ],
      ),
    );
  }
}
