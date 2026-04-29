// lib/shared/widgets/uc_header.dart
// 역할: 모든 화면 상단 공통 헤더. UC 로고·학교명 + 선택적 설정 아이콘 표시.

import 'package:flutter/material.dart';
import 'package:university_portal_flutter/core/theme/app_colors.dart';

class UCHeader extends StatelessWidget implements PreferredSizeWidget {
  final bool showSettings;
  final VoidCallback? onSettingsTap;

  const UCHeader({
    super.key,
    this.showSettings = false,
    this.onSettingsTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      title: const Text(
        'UC Info',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      ),
      actions: [
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
