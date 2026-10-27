// lib/features/chatbot/widgets/message_bubble.dart
// 역할: 사용자/AI 말풍선 1개와 AI 답변의 출처 카드 목록.

import 'package:flutter/material.dart';
import 'package:university_portal_flutter/core/theme/app_colors.dart';
import 'package:university_portal_flutter/core/theme/app_spacing.dart';
import 'package:university_portal_flutter/core/theme/app_text_styles.dart';
import 'package:university_portal_flutter/data/models/chat_models.dart';
import 'package:university_portal_flutter/features/chatbot/widgets/source_card.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  /// 스트리밍 중인 마지막 AI 말풍선 여부 (아직 토큰이 없으면 안내 문구 표시)
  final bool isPending;

  const MessageBubble({super.key, required this.message, this.isPending = false});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final waiting = isPending && message.content.isEmpty;

    final textColor = isUser
        ? Colors.white
        : message.isError
            ? context.error
            : context.textPrimary;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.78),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isUser ? AppColors.primary : context.background,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isUser ? AppSpacing.radiusMd : AppSpacing.xs),
              topRight: Radius.circular(isUser ? AppSpacing.xs : AppSpacing.radiusMd),
              bottomLeft: const Radius.circular(AppSpacing.radiusMd),
              bottomRight: const Radius.circular(AppSpacing.radiusMd),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                waiting ? '공지를 찾는 중…' : message.content,
                style: AppTextStyles.body2.copyWith(
                  color: waiting ? context.textHint : textColor,
                  height: 1.5,
                ),
              ),
              for (final source in message.sources) ...[
                const SizedBox(height: AppSpacing.sm),
                SourceCard(source: source),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
