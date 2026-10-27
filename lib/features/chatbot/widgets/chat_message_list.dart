// lib/features/chatbot/widgets/chat_message_list.dart
// 역할: 대화 말풍선 목록. 대화가 비어 있으면 인사말과 예시 질문 칩을 보여준다.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:university_portal_flutter/core/theme/app_colors.dart';
import 'package:university_portal_flutter/core/theme/app_spacing.dart';
import 'package:university_portal_flutter/core/theme/app_text_styles.dart';
import 'package:university_portal_flutter/data/models/chat_models.dart';
import 'package:university_portal_flutter/features/auth/providers/user_provider.dart';
import 'package:university_portal_flutter/features/chatbot/providers/chat_provider.dart';
import 'package:university_portal_flutter/features/chatbot/widgets/message_bubble.dart';

class ChatMessageList extends ConsumerWidget {
  /// 예시 질문 칩을 눌렀을 때 바로 전송
  final ValueChanged<String> onSuggestion;

  const ChatMessageList({super.key, required this.onSuggestion});

  static const _suggestions = [
    '최근 공지 알려줘',
    '장학금 신청 기간',
    '학과 공지 몇 개야?',
    '기숙사 모집 일정',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chat = ref.watch(chatProvider);
    final name = ref.watch(userProvider.select((s) => s.user?.name));

    if (chat.messages.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          MessageBubble(
            message: ChatMessage(
              role: 'assistant',
              content: '안녕하세요${name != null ? ', $name님' : ''}!\n'
                  '학교·학과 공지를 찾아서 답해드릴게요.',
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final text in _suggestions)
                ActionChip(
                  label: Text(
                    text,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor: context.surface,
                  side: BorderSide(color: context.divider),
                  shape: const StadiumBorder(),
                  onPressed: () => onSuggestion(text),
                ),
            ],
          ),
        ],
      );
    }

    // reverse 목록: 새 메시지/토큰이 붙어도 항상 맨 아래가 보인다
    final messages = chat.messages.reversed.toList();
    return ListView.separated(
      reverse: true,
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: messages.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (_, index) => MessageBubble(
        message: messages[index],
        isPending: index == 0 && chat.isStreaming,
      ),
    );
  }
}
