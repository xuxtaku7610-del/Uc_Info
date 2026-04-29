// lib/features/auth/screens/auth_screen.dart
// 역할: 학번 인증 화면. 이름·학과·학번을 입력받아 유효성 검사 후 홈으로 이동한다.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:university_portal_flutter/core/theme/app_colors.dart';
import 'package:university_portal_flutter/core/theme/app_spacing.dart';
import 'package:university_portal_flutter/core/theme/app_text_styles.dart';
import 'package:university_portal_flutter/features/auth/providers/auth_provider.dart';
import 'package:university_portal_flutter/shared/widgets/app_button.dart';
import 'package:university_portal_flutter/shared/widgets/app_text_field.dart';
import 'package:university_portal_flutter/shared/widgets/uc_header.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _nameController = TextEditingController();
  final _deptController = TextEditingController();
  final _idController   = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _deptController.dispose();
    _idController.dispose();
    super.dispose();
  }

  // 학번 인증을 시도한다.
  // Why: UI 위젯에서 직접 Repository를 호출하면 테스트가 어렵기 때문에 Notifier로 분리했다.
  Future<void> _onVerifyPressed() async {
    final success = await ref.read(authProvider.notifier).verifyStudent(
      name:       _nameController.text,
      department: _deptController.text,
      studentId:  _idController.text,
    );
    // await 이후 context 사용 전 mounted 체크 필수
    if (success && mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const UCHeader(),           // 설정 아이콘 없음
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical:   AppSpacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── 1. 파란 인증 배너 ──────────────────────────
              const SizedBox(height: AppSpacing.sm),
              const _AuthBanner(),

              // ── 2. 입력 폼 카드 ────────────────────────────
              const SizedBox(height: AppSpacing.lg),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    AppTextField(
                      label:           '이름',
                      placeholder:     '예: 홍길동',
                      isRequired:      true,
                      errorText:       state.nameError,
                      controller:      _nameController,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      label:           '학과',
                      placeholder:     '예: 컴퓨터공학과',
                      isRequired:      true,
                      errorText:       state.departmentError,
                      controller:      _deptController,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      label:           '학번',
                      placeholder:     '예: 2411206',
                      isRequired:      true,
                      errorText:       state.studentIdError,
                      controller:      _idController,
                      keyboardType:    TextInputType.number,
                      textInputAction: TextInputAction.done,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ],
                ),
              ),

              // ── 3. 인증 버튼 ────────────────────────────────
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label:        '학번 인증하기',
                trailingIcon: Icons.chevron_right,
                isLoading:    state.isLoading,
                onPressed:    state.isLoading ? null : _onVerifyPressed,
              ),

              // ── 4. 안내사항 ─────────────────────────────────
              const SizedBox(height: AppSpacing.lg),
              const _NoticeCard(),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════
// 파란 인증 배너 — 아이콘 + 제목 + 설명
// ══════════════════════════════════════════════
class _AuthBanner extends StatelessWidget {
  const _AuthBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF1A3BAF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Row(
        children: [
          // 아이콘 배지
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm + 2),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: const Icon(
              Icons.badge_outlined,
              color: Colors.white,
              size: 36,
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // 제목 + 설명
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '학번 인증',
                  style: AppTextStyles.heading2.copyWith(color: Colors.white),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '이름·학과·학번을 입력하여\n인증을 완료해주세요.',
                  style: AppTextStyles.body2.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════
// 안내사항 카드 — 핀 아이콘 + bullet 3개
// ══════════════════════════════════════════════
class _NoticeCard extends StatelessWidget {
  const _NoticeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 핀 아이콘 + 제목
          Row(
            children: [
              const Icon(Icons.push_pin, color: AppColors.primary, size: 18),
              const SizedBox(width: AppSpacing.xs),
              Text('안내사항', style: AppTextStyles.heading3),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // Bullet 3개
          const _BulletItem('학번은 입학년도를 포함한 7자리 숫자입니다. (예: 2411206)'),
          const _BulletItem('이름은 학교에 등록된 실명을 입력해주세요.'),
          const _BulletItem('인증 오류가 지속되면 학생처(☎ 052-950-9000)로 문의해주세요.'),
        ],
      ),
    );
  }
}

class _BulletItem extends StatelessWidget {
  final String text;

  const _BulletItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: CircleAvatar(radius: 2.5, backgroundColor: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.body2.copyWith(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
