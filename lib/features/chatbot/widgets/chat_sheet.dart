// lib/features/chatbot/widgets/chat_sheet.dart
// 역할: 챗봇 바텀시트 본체. 헤더 + (대화 화면 | 대화 목록) 전환 + 입력창.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:university_portal_flutter/core/theme/app_colors.dart';
import 'package:university_portal_flutter/core/theme/app_spacing.dart';
import 'package:university_portal_flutter/core/theme/app_text_styles.dart';
import 'package:university_portal_flutter/features/chatbot/providers/chat_provider.dart';
import 'package:university_portal_flutter/features/chatbot/widgets/chat_composer.dart';
import 'package:university_portal_flutter/features/chatbot/widgets/chat_history_view.dart';
import 'package:university_portal_flutter/features/chatbot/widgets/chat_message_list.dart';

/// 화면 높이의 88%를 차지하는 챗봇 시트.
/// 입력창 컨트롤러와 화면 전환 여부만 로컬 상태로 가진다.
class ChatSheet extends ConsumerStatefulWidget {
  const ChatSheet({super.key});

  @override
  ConsumerState<ChatSheet> createState() => _ChatSheetState();
}

class _ChatSheetState extends ConsumerState<ChatSheet> {
  final _controller = TextEditingController();
  bool _showHistory = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send(String text) {
    _controller.clear();
    ref.read(chatProvider.notifier).send(text);
  }

  @override
  Widget build(BuildContext context) {
    final isStreaming = ref.watch(chatProvider.select((s) => s.isStreaming));

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.88,
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: Column(
          children: [
            const _GrabHandle(),
            _ChatSheetHeader(
              showHistory: _showHistory,
              isStreaming: isStreaming,
              onToggleHistory: () => setState(() => _showHistory = !_showHistory),
            ),
            Divider(height: 1, color: context.divider),
            Expanded(
              child: _showHistory
                  ? ChatHistoryView(onDone: () => setState(() => _showHistory = false))
                  : ChatMessageList(onSuggestion: _send),
            ),
            if (!_showHistory)
              ChatComposer(
                controller: _controller,
                enabled: !isStreaming,
                onSend: () => _send(_controller.text),
              ),
          ],
        ),
      ),
    );
  }
}

class _GrabHandle extends StatelessWidget {
  const _GrabHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 4,
      margin: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.xs),
      decoration: BoxDecoration(
        color: context.divider,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
    );
  }
}

/// 아바타 + 제목 + (대화 목록 / 뒤로) + 닫기
class _ChatSheetHeader extends StatelessWidget {
  final bool showHistory;
  final bool isStreaming;
  final VoidCallback onToggleHistory;

  const _ChatSheetHeader({
    required this.showHistory,
    required this.isStreaming,
    required this.onToggleHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.xs, AppSpacing.xs, AppSpacing.sm),
      child: Row(
        children: [
          if (showHistory)
            IconButton(
              icon: Icon(Icons.chevron_left, color: context.textSecondary),
              tooltip: '대화로 돌아가기',
              onPressed: onToggleHistory,
            )
          else
            CircleAvatar(
              radius: 16,
              backgroundColor: context.primaryTint,
              child: const Icon(Icons.smart_toy_outlined, size: 18, color: AppColors.primary),
            ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  showHistory ? '대화 목록' : '공지 AI',
                  style: AppTextStyles.heading3.copyWith(color: context.textPrimary),
                ),
                if (!showHistory)
                  Text(
                    isStreaming ? '답변 작성 중…' : '학교·학과 공지 기반 답변',
                    style: AppTextStyles.caption.copyWith(color: context.textSecondary),
                  ),
              ],
            ),
          ),
          if (!showHistory)
            IconButton(
              icon: Icon(Icons.history, color: context.textSecondary),
              tooltip: '대화 목록',
              onPressed: isStreaming ? null : onToggleHistory,
            ),
          IconButton(
            icon: Icon(Icons.close, color: context.textSecondary),
            tooltip: '닫기',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
