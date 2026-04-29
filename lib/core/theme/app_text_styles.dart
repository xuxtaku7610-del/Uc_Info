// lib/core/theme/app_text_styles.dart
// 역할: 앱 전역 텍스트 스타일 토큰. 기본 폰트는 Pretendard (한국어 최적화).

import 'package:flutter/material.dart';
import 'package:university_portal_flutter/core/theme/app_colors.dart';

class AppTextStyles {
  static const TextStyle heading1  = TextStyle(fontSize: 22, fontWeight: FontWeight.w700);
  static const TextStyle heading2  = TextStyle(fontSize: 18, fontWeight: FontWeight.w700);
  static const TextStyle heading3  = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
  static const TextStyle body1     = TextStyle(fontSize: 15, fontWeight: FontWeight.w400);
  static const TextStyle body2     = TextStyle(fontSize: 14, fontWeight: FontWeight.w400);
  static const TextStyle caption   = TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textSecondary);
  static const TextStyle label     = TextStyle(fontSize: 13, fontWeight: FontWeight.w500);
  static const TextStyle buttonText = TextStyle(fontSize: 16, fontWeight: FontWeight.w700);
}
