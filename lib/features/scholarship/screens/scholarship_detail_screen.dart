// lib/features/scholarship/screens/scholarship_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:university_portal_flutter/core/theme/app_colors.dart';
import 'package:university_portal_flutter/core/theme/app_spacing.dart';
import 'package:university_portal_flutter/core/theme/app_text_styles.dart';
import '../../../data/models/scholarship.dart';
import '../../../shared/providers/app_providers.dart';

class ScholarshipDetailScreen extends ConsumerWidget {
  final int scholarshipId;
  const ScholarshipDetailScreen({super.key, required this.scholarshipId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 간단하게 FutureProvider나 로컬 FutureBuilder 사용 가능. 
    // 여기선 명세에 맞춰 "상세 조회" 기능을 직접 호출
    final repo = ref.watch(scholarshipRepositoryProvider);

    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        title: const Text('장학금 상세', style: AppTextStyles.heading2),
        backgroundColor: context.surface,
        elevation: 0,
        foregroundColor: context.textPrimary,
      ),
      body: FutureBuilder<Scholarship>(
        future: repo.getScholarshipDetail(scholarshipId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString(), style: const TextStyle(color: AppColors.error)),
            );
          }
          final s = snapshot.data!;
          final deadlineStr = DateFormat('yyyy.MM.dd').format(s.deadline);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBadge(context, s.type),
                const SizedBox(height: AppSpacing.sm),
                Text(s.title, style: AppTextStyles.heading1),
                const SizedBox(height: AppSpacing.lg),
                const Divider(),
                const SizedBox(height: AppSpacing.md),
                _buildInfoRow(context, '신청 마감일', deadlineStr),
                _buildInfoRow(context, '장학 유형', s.type),
                const SizedBox(height: AppSpacing.xl),
                const Text(
                  '상세 모집 요강은 학교 홈페이지 및 장학 공지사항을 확인해 주시기 바랍니다.',
                  style: AppTextStyles.body2,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBadge(BuildContext context, String type) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: context.primaryTint,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Text(
        type,
        style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(label, style: AppTextStyles.label.copyWith(color: context.textSecondary))),
          Text(value, style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
