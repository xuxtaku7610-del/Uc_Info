// lib/shared/widgets/app_text_field.dart
// 역할: 앱 전역 텍스트 입력 필드. 필수 표시·에러 상태 내장.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:university_portal_flutter/core/theme/app_colors.dart';
import 'package:university_portal_flutter/core/theme/app_spacing.dart';
import 'package:university_portal_flutter/core/theme/app_text_styles.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final String placeholder;
  final bool isRequired;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;

  const AppTextField({
    super.key,
    required this.label,
    this.placeholder = '',
    this.isRequired = false,
    this.errorText,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: AppTextStyles.label),
            if (isRequired)
              const Text(
                ' (필수)',
                style: TextStyle(color: AppColors.error, fontSize: 13),
              ),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          // null이면 TextInputType.text로 명시 — 일부 Android 키보드가 null일 때 한/영 전환키를 숨김
          keyboardType: keyboardType ?? TextInputType.text,
          textInputAction: textInputAction,
          // none으로 설정 — 한글 조합 중 Flutter가 대문자 변환을 시도하면 IME가 끊기는 문제 방지
          textCapitalization: TextCapitalization.none,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: const TextStyle(color: AppColors.textHint),
            errorText: errorText,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.divider),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.error),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
          ),
        ),
      ],
    );
  }
}
