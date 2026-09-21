// lib/shared/widgets/uc_header.dart
// 역할: 모든 화면 상단 공통 헤더. UC 로고·학교명 + 선택적 설정/알림 아이콘 표시.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:university_portal_flutter/core/theme/app_colors.dart';
import 'package:university_portal_flutter/features/notification/providers/notice_inbox_provider.dart';

class UCHeader extends ConsumerWidget implements PreferredSizeWidget {
  final bool showSettings;
  final VoidCallback? onSettingsTap;
  final bool showNotificationBell;
  final VoidCallback? onNotificationTap;

  const UCHeader({
    super.key,
    this.showSettings = false,
    this.onSettingsTap,
    this.showNotificationBell = false,
    this.onNotificationTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasUnseen = ref.watch(noticeInboxProvider.notifier).hasUnseen;

    return AppBar(
      backgroundColor: AppColors.primary,
      title: const Text(
        'UC Info',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      ),
      actions: [
        if (showNotificationBell)
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                onPressed: onNotificationTap,
                tooltip: '알림',
              ),
              if (hasUnseen)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        if (showSettings)
          Semantics(
            label: '설정',
            child: IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: onSettingsTap,
              tooltip: '설정',
            ),
          ),
      ],
    );
  }
}
