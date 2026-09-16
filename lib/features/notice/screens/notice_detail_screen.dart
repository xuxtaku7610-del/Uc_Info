// lib/features/notice/screens/notice_detail_screen.dart
// 역할: 공지사항 상세 화면. 카테고리 뱃지, 날짜, 제목, 본문을 표시한다.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:university_portal_flutter/core/theme/app_colors.dart';
import 'package:university_portal_flutter/core/theme/app_spacing.dart';
import 'package:university_portal_flutter/core/theme/app_text_styles.dart';
import 'package:university_portal_flutter/data/models/notice_item.dart';
import 'package:university_portal_flutter/features/auth/providers/user_provider.dart';
import 'package:university_portal_flutter/shared/providers/app_providers.dart';

class NoticeDetailScreen extends ConsumerStatefulWidget {
  final int noticeId;
  final NoticeItem? notice; // 직접 전달받거나 ID로 조회

  const NoticeDetailScreen({super.key, required this.noticeId, this.notice});

  @override
  ConsumerState<NoticeDetailScreen> createState() => _NoticeDetailScreenState();
}

class _NoticeDetailScreenState extends ConsumerState<NoticeDetailScreen> {
  @override
  void initState() {
    super.initState();
    // 화면 진입 시 비동기로 읽음 처리 실행
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _markAsRead();
    });
  }

  void _markAsRead() {
    final user = ref.read(userProvider).user;
    if (user != null) {
      ref.read(noticeRepositoryProvider).markAsRead(widget.noticeId, user.studentId);
    } else {
      // 혹시라도 아직 user 로딩 전이라면 listener를 통해 로딩 완료 시점에 재시도하도록 구성 가능
      debugPrint('Warning: studentId is null, marking as read skipped.');
    }
  }

  // 카테고리 키 → 한국어 레이블 (백엔드 대문자 규격에 맞춤)
  static const _categoryLabels = {
    'ACADEMIC':    '학사',
    'DEPARTMENT':  '학과공지',
    'EVENT':       '행사',
    'SCHOLARSHIP': '장학금',
    'EMPLOYMENT':  '취업',
  };

  @override
  Widget build(BuildContext context) {
    final notice = widget.notice;

    // 공지 정보가 없는 경우 처리 (추후 API 연동 시 Provider 등을 통해 가져오도록 수정 필요)
    if (notice == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('공지사항')),
        body: const Center(child: Text('공지사항 정보를 불러올 수 없습니다.')),
      );
    }

    final label = _categoryLabels[notice.category] ?? notice.category;

    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        backgroundColor: context.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          color: context.textPrimary,
          onPressed: () => context.pop(),
        ),
        title: Text(
          '공지사항',
          style: AppTextStyles.heading3.copyWith(color: context.textPrimary),
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
                    color: context.primaryTint,
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

            Divider(color: context.divider),
            const SizedBox(height: AppSpacing.md),

            // 본문
            Text(
              notice.content,
              style: AppTextStyles.body1.copyWith(
                height: 1.7,
                color: context.textPrimary,
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
