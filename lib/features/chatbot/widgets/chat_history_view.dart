// lib/features/chatbot/widgets/chat_history_view.dart
// 역할: 챗봇 시트 안의 대화 목록. 새 대화 시작 / 이어서 대화 / 삭제.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:university_portal_flutter/core/theme/app_colors.dart';
import 'package:university_portal_flutter/core/theme/app_spacing.dart';
import 'package:university_portal_flutter/core/theme/app_text_styles.dart';
import 'package:university_portal_flutter/data/models/chat_models.dart';
import 'package:university_portal_flutter/features/chatbot/providers/chat_provider.dart';

class ChatHistoryView extends ConsumerWidget {
  /// 대화를 고르거나 새 대화를 시작한 뒤 대화 화면으로 돌아갈 때 호출
  final VoidCallback onDone;

  const ChatHistoryView({super.key, required this.onDone});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(chatSessionsProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: context.primaryTint,
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
              ),
              icon: const Icon(Icons.add),
              label: const Text('새 대화', style: AppTextStyles.label),
              onPressed: () {
                ref.read(chatProvider.notifier).newChat();
                onDone();
              },
            ),
          ),
        ),
        Expanded(
          child: sessions.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => _Message(
              text: e.toString().replaceFirst('Exception: ', ''),
              onRetry: () => ref.invalidate(chatSessionsProvider),
            ),
            data: (items) => items.isEmpty
                ? const _Message(text: '아직 대화가 없어요.')
                : ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, _) => Divider(height: 1, color: context.divider),
                    itemBuilder: (_, index) => _SessionTile(session: items[index], onDone: onDone),
                  ),
          ),
        ),
      ],
    );
  }
}

class _SessionTile extends ConsumerWidget {
  final ChatSession session;
  final VoidCallback onDone;

  const _SessionTile({required this.session, required this.onDone});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createdAt = session.createdAt;

    return ListTile(
      title: Text(
        session.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.body2.copyWith(color: context.textPrimary),
      ),
      subtitle: createdAt == null
          ? null
          : Text(
              DateFormat('MM.dd HH:mm').format(createdAt),
              style: AppTextStyles.caption.copyWith(color: context.textSecondary),
            ),
      trailing: IconButton(
        icon: Icon(Icons.delete_outline, color: context.error),
        tooltip: '삭제',
        onPressed: () => _confirmDelete(context, ref),
      ),
      onTap: () async {
        try {
          await ref.read(chatProvider.notifier).openSession(session.id);
          onDone();
        } catch (e) {
          if (!context.mounted) return;
          _showError(context, e);
        }
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('대화 삭제'),
        content: const Text('이 대화를 삭제할까요?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('취소')),
          TextButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('삭제')),
        ],
      ),
    );
    if (ok != true) return;

    try {
      await ref.read(chatProvider.notifier).deleteSession(session.id);
      ref.invalidate(chatSessionsProvider);
    } catch (e) {
      if (!context.mounted) return;
      _showError(context, e);
    }
  }

  void _showError(BuildContext context, Object e) {
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
    );
  }
}

class _Message extends StatelessWidget {
  final String text;
  final VoidCallback? onRetry;

  const _Message({required this.text, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text, style: AppTextStyles.body2.copyWith(color: context.textSecondary)),
          if (onRetry != null) TextButton(onPressed: onRetry, child: const Text('다시 시도')),
        ],
      ),
    );
  }
}
