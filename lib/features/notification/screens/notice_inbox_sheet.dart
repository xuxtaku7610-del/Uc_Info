import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:university_portal_flutter/core/theme/app_spacing.dart';
import 'package:university_portal_flutter/core/theme/app_text_styles.dart';
import 'package:university_portal_flutter/shared/widgets/common_widgets.dart';
import '../providers/notice_inbox_provider.dart';

class NoticeInboxSheet extends ConsumerWidget {
  const NoticeInboxSheet({super.key});

  String _getTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    return '${diff.inDays}일 전';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(noticeInboxProvider.notifier).entries;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: AppDragHandle(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('알림함', style: AppTextStyles.heading2),
                TextButton(
                  onPressed: () {
                    // TODO: Clear all notifications? Not requested yet.
                  },
                  child: const Text('모두 읽음'),
                ),
              ],
            ),
          ),
          const Divider(),
          if (entries.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(child: Text('새로운 알림이 없습니다.')),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: entries.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  return ListTile(
                    tileColor: entry.seen ? null : Colors.blue.withValues(alpha: 0.05),
                    title: Text(
                      entry.title,
                      style: AppTextStyles.body2.copyWith(
                        fontWeight: entry.seen ? FontWeight.normal : FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Row(
                      children: [
                        Text(
                          entry.category,
                          style: AppTextStyles.caption.copyWith(color: Colors.blue),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _getTimeAgo(entry.addedAt),
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                    onTap: () {
                      ref.read(noticeInboxProvider.notifier).markEntrySeen(entry.noticeId);
                      Navigator.pop(context);
                      context.push('/notice/${entry.noticeId}');
                    },
                  );
                },
              ),
            ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
