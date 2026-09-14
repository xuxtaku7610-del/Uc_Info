// lib/core/theme/app_colors.dart
// 역할: 앱 전역 색상 토큰. 모든 위젯에서 이 파일의 상수를 참조한다.

import 'package:flutter/material.dart';

class AppColors {
  // Primary — 브랜드 파란색 (헤더, 버튼 배경, 배지)
  static const Color primary      = Color(0xFF2F5BE8);
  static const Color primaryLight = Color(0xFFEAF0FF);

  // Accent — 강조 노란색 (CTA 버튼, 모바일 학생증 버튼)
  static const Color accent     = Color(0xFFFFC72C);
  static const Color accentDark = Color(0xFFE6A800); // pressed state

  // Neutral (Static Fallbacks)
  static const Color background    = Color(0xFFF4F6FA);
  static const Color surface       = Color(0xFFFFFFFF);
  static const Color divider       = Color(0xFFEAECF0);
  static const Color textPrimary   = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint      = Color(0xFFADB5BD);

  // Semantic
  static const Color error        = Color(0xFFE84040);
  static const Color errorLight   = Color(0xFFFFF0F0);
  static const Color success      = Color(0xFF22C55E);
  static const Color warning      = Color(0xFFFB923C);

  // 시간표 블록 색상 (주간 시간표 과목별 순환 배정)
  static const List<Color> timetableColors = [
    Color(0xFFBBF0D4), // 민트
    Color(0xFFFFE5B4), // 노랑
    Color(0xFFD4BBFF), // 보라
    Color(0xFFB4D4FF), // 파랑
    Color(0xFFFFB4C2), // 핑크
    Color(0xFFC8F5A0), // 연두
  ];
}

extension AppColorsX on BuildContext {
  bool get _isDark => Theme.of(this).brightness == Brightness.dark;

  Color get background => _isDark ? const Color(0xFF121212) : AppColors.background;
  Color get surface => _isDark ? const Color(0xFF1E1E1E) : AppColors.surface;
  Color get textPrimary => _isDark ? const Color(0xFFF4F6FA) : AppColors.textPrimary;
  Color get textSecondary => _isDark ? const Color(0xFFB0B3B8) : AppColors.textSecondary;
  Color get textHint => _isDark ? const Color(0xFF7A7D85) : AppColors.textHint;
  Color get divider => _isDark ? const Color(0xFF2C2C2E) : AppColors.divider;

  // 브랜드 컬러가 은은하게 깔린 카드/배지 배경 (안내문구, 아이콘 배지 등)
  Color get primaryTint => _isDark ? const Color(0xFF1B2540) : AppColors.primaryLight;
  // primaryTint 배경 위에 쓸 테두리색
  Color get primaryTintBorder => AppColors.primary.withValues(alpha: _isDark ? 0.35 : 0.2);

  // 브랜드 컬러도 필요한 경우 여기서 래핑 가능
  Color get primary => AppColors.primary;
  Color get accent => AppColors.accent;
  Color get error => AppColors.error;
}
