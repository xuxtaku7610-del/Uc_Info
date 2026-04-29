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

  // Neutral
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
