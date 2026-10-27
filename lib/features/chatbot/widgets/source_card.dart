// lib/features/chatbot/widgets/source_card.dart
// 역할: AI 답변의 근거 공지 카드. 탭하면 공지 원문 링크를 외부 브라우저로 연다.

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:university_portal_flutter/core/theme/app_colors.dart';
import 'package:university_portal_flutter/core/theme/app_spacing.dart';
import 'package:university_portal_flutter/core/theme/app_text_styles.dart';
import 'package:university_portal_flutter/data/models/chat_models.dart';

class SourceCard extends StatelessWidget {
  final ChatSource source;

  const SourceCard({super.key, required this.source});

  @override
  Widget build(BuildContext context) {
    final url = source.sourceUrl;

    return Material(
      color: context.surface,
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        onTap: url == null
            ? null
            : () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: context.divider),
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: context.primaryTint,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  source.scopeLabel.replaceAll(' 공지', ''),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  source.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(color: context.textPrimary),
                ),
              ),
              if (url != null)
                const Icon(Icons.open_in_new, size: 14, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}
