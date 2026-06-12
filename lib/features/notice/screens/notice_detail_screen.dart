// lib/features/notice/screens/notice_detail_screen.dart
// 역할: 공지사항 상세 화면. 카테고리 뱃지, 날짜, 제목, 본문을 표시한다.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:university_portal_flutter/core/theme/app_colors.dart';
import 'package:university_portal_flutter/core/theme/app_spacing.dart';
import 'package:university_portal_flutter/core/theme/app_text_styles.dart';
import 'package:university_portal_flutter/data/mock/mock_data.dart';

class NoticeDetailScreen extends StatelessWidget {
  final int noticeIndex;

  const NoticeDetailScreen({super.key, required this.noticeIndex});

  // 카테고리 키 → 한국어 레이블
  static const _categoryLabels = {
    'notice':      '공지사항',
    'dept_news':   '학과소식',
    'dept_notice': '학과공지',
    'scholarship': '장학·취업',
  };

  @override
  Widget build(BuildContext context) {
    final notice = mockNotices[noticeIndex];
    final label = _categoryLabels[notice.category] ?? notice.category;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          color: AppColors.textPrimary,
          onPressed: () => context.pop(),
        ),
        title: Text(
          '공지사항',
          style: AppTextStyles.heading3.copyWith(color: AppColors.textPrimary),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 카테고리 뱃지 + 날짜
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Text(
                    label,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                Text(notice.date, style: AppTextStyles.caption),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            // 제목
            Text(notice.title, style: AppTextStyles.heading2),
            const SizedBox(height: AppSpacing.md),

            const Divider(color: AppColors.divider),
            const SizedBox(height: AppSpacing.md),

            // 본문
            Text(
              notice.content,
              style: AppTextStyles.body1.copyWith(
                height: 1.7,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // 영어 번역 화면 진입 버튼 (외국인 유학생을 위한 한→영 번역)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => context.push('/notice/translation'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                ),
                icon: const Icon(Icons.translate),
                label: const Text('Translate to English 🌐', style: AppTextStyles.buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
