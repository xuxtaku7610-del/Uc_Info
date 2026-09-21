// lib/features/settings/screens/settings_sheet.dart
// 역할: 설정 Bottom Sheet. 알림·다크모드 토글, 언어 선택 드롭다운.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:university_portal_flutter/core/theme/app_colors.dart';
import 'package:university_portal_flutter/core/theme/app_spacing.dart';
import 'package:university_portal_flutter/core/theme/app_text_styles.dart';
import 'package:university_portal_flutter/features/auth/providers/auth_session_provider.dart';
import 'package:university_portal_flutter/features/settings/providers/settings_provider.dart';
import 'package:university_portal_flutter/shared/widgets/common_widgets.dart';

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
          const Center(child: AppDragHandle()),
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
                  .copyWith(color: context.textPrimary),
              onChanged: notifier.setLanguage,
              items: const [
                DropdownMenuItem(value: '한국어', child: Text('한국어')),
                DropdownMenuItem(value: 'English', child: Text('English')),
              ],
            ),
          ),
          const Divider(height: 1),
          _SettingRow(
            label: '계정 관리',
            child: TextButton(
              onPressed: () => _showLogoutDialog(context, ref),
              child: const Text(
                '로그아웃',
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('정말 로그아웃 하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('취소', style: TextStyle(color: context.textSecondary)),
          ),
          TextButton(
            onPressed: () async {
              // 다이얼로그 닫기
              Navigator.of(context).pop();
              // 설정 시트(바텀시트) 닫기
              Navigator.of(context).pop();
              
              // 로그아웃 처리 (비동기)
              await ref.read(authSessionProvider.notifier).logout();
            },
            child: const Text('로그아웃', style: TextStyle(color: AppColors.error)),
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
