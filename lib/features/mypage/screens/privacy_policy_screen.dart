// lib/features/mypage/screens/privacy_policy_screen.dart
// 역할: 개인정보처리방침 화면. 수집 항목, 목적, 보유 기간 등을 명시한다.

import 'package:flutter/material.dart';
import 'package:university_portal_flutter/core/theme/app_colors.dart';
import 'package:university_portal_flutter/core/theme/app_spacing.dart';
import 'package:university_portal_flutter/core/theme/app_text_styles.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        title: const Text('개인정보처리방침', style: AppTextStyles.heading2),
        backgroundColor: context.surface,
        elevation: 0,
        foregroundColor: context.textPrimary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '최종 수정일: 2026-09-14 (시행 전 학교 담당 부서 검토가 필요한 초안입니다)',
              style: AppTextStyles.caption.copyWith(color: context.textHint),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '본 방침은 추후 변경될 수 있습니다.',
              style: AppTextStyles.caption.copyWith(color: context.textHint),
            ),
            const SizedBox(height: AppSpacing.lg),
            
            _buildSection(
              title: '1. 수집하는 개인정보 항목',
              content: '• 이름, 학번, 소속 학과, 학년\n'
                  '• (수집 목적: 학생 인증 및 맞춤 정보 제공)',
            ),
            _buildSection(
              title: '2. 개인정보의 수집 및 이용 목적',
              content: '• 학생 본인 확인(인증)\n'
                  '• 학과별 공지사항·학사일정·장학금 정보 제공\n'
                  '• 수강신청(개설과목 선택) 처리',
            ),
            _buildSection(
              title: '3. 개인정보의 보유 및 이용 기간',
              content: '• 서비스 이용 기간 동안 보유하며, 탈퇴 또는 서비스 종료 시 즉시 파기함',
            ),
            _buildSection(
              title: '4. 개인정보의 제3자 제공',
              content: '• 본 서비스는 수집한 개인정보를 외부 제3자에게 제공하지 않음',
            ),
            _buildSection(
              title: '5. 이용자의 권리',
              content: '• 이용자는 언제든지 본인의 개인정보 조회, 정정을 요청할 수 있음',
            ),
            _buildSection(
              title: '6. 문의처',
              content: '• [학교명/학과명] 개발팀 (연락처: 추후 기재)',
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.heading3),
          const SizedBox(height: AppSpacing.xs),
          Text(content, style: AppTextStyles.body1),
        ],
      ),
    );
  }
}
