// lib/features/chatbot/widgets/chat_composer.dart
// 역할: 챗봇 시트 하단 입력창 + 전송 버튼. 답변 생성 중에는 비활성화.

import 'package:flutter/material.dart';
import 'package:university_portal_flutter/core/theme/app_colors.dart';
import 'package:university_portal_flutter/core/theme/app_spacing.dart';
import 'package:university_portal_flutter/core/theme/app_text_styles.dart';

class ChatComposer extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final VoidCallback onSend;

  const ChatComposer({
    super.key,
    required this.controller,
    required this.enabled,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.sm, AppSpacing.md),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: context.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              enabled: enabled,
              minLines: 1,
              maxLines: 4,
              maxLength: 500,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              style: AppTextStyles.body2.copyWith(color: context.textPrimary),
              decoration: InputDecoration(
                hintText: enabled ? '공지에 대해 물어보세요' : '답변 생성 중…',
                hintStyle: AppTextStyles.body2.copyWith(color: context.textHint),
                counterText: '',
                filled: true,
                fillColor: context.background,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          IconButton.filled(
            onPressed: enabled ? onSend : null,
            tooltip: '전송',
            style: IconButton.styleFrom(
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: context.divider,
            ),
            icon: const Icon(Icons.arrow_upward, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
