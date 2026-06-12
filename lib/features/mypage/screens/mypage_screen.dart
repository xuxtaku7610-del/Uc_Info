// lib/features/mypage/screens/mypage_screen.dart
// 역할: 마이페이지. 학생증 카드·학사정보·앱설정·기타 메뉴로 구성된다.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:university_portal_flutter/core/theme/app_colors.dart';
import 'package:university_portal_flutter/core/theme/app_spacing.dart';
import 'package:university_portal_flutter/core/theme/app_text_styles.dart';
import 'package:university_portal_flutter/data/mock/mock_data.dart';
import 'package:university_portal_flutter/features/auth/providers/auth_session_provider.dart';
import 'package:university_portal_flutter/features/settings/providers/settings_provider.dart';

class MypageScreen extends ConsumerWidget {
  const MypageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 1. 학생증 카드
              const _StudentCard(),

              // ── 2. 학사 정보
              const _SectionHeader(title: '학사 정보'),
              _MenuCard(children: [
                _MenuItem(
                  icon: Icons.person_outline,
                  label: '학적 정보 조회',
                  onTap: () {},
                ),
                const _ItemDivider(),
                _MenuItem(
                  icon: Icons.library_books_outlined,
                  label: '수강 신청 현황',
                  onTap: () {},
                ),
                const _ItemDivider(),
                _MenuItem(
                  icon: Icons.bar_chart_outlined,
                  label: '성적 확인',
                  onTap: () {},
                ),
              ]),

              // ── 3. 앱 설정
              const _SectionHeader(title: '앱 설정'),
              _MenuCard(children: [
                _MenuItem(
                  icon: Icons.notifications_outlined,
                  label: '알림 설정',
                  trailing: Switch(
                    value: settings.notificationsEnabled,
                    onChanged: (v) =>
                        ref.read(settingsProvider.notifier).toggleNotifications(v),
                    activeColor: AppColors.primary,
                  ),
                ),
                const _ItemDivider(),
                _MenuItem(
                  icon: Icons.language_outlined,
                  label: '언어 설정',
                  trailing: Text(
                    settings.language,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textHint,
                    ),
                  ),
                ),
                const _ItemDivider(),
                _MenuItem(
                  icon: Icons.dark_mode_outlined,
                  label: '다크 모드',
                  trailing: Switch(
                    value: settings.darkModeEnabled,
                    onChanged: (v) =>
                        ref.read(settingsProvider.notifier).toggleDarkMode(v),
                    activeColor: AppColors.primary,
                  ),
                ),
              ]),

              // ── 4. 기타
              const _SectionHeader(title: '기타'),
              _MenuCard(children: [
                _MenuItem(
                  icon: Icons.campaign_outlined,
                  label: '공지사항',
                  onTap: () {},
                ),
                const _ItemDivider(),
                _MenuItem(
                  icon: Icons.description_outlined,
                  label: '이용약관',
                  onTap: () {},
                ),
                const _ItemDivider(),
                _MenuItem(
                  icon: Icons.privacy_tip_outlined,
                  label: '개인정보처리방침',
                  onTap: () {},
                ),
                const _ItemDivider(),
                _MenuItem(
                  icon: Icons.info_outline,
                  label: '버전 정보',
                  trailing: Text(
                    'v1.0.0',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textHint,
                    ),
                  ),
                ),
                const _ItemDivider(),
                _MenuItem(
                  icon: Icons.logout,
                  label: '로그아웃',
                  isDestructive: true,
                  onTap: () => _showLogoutDialog(context, ref),
                ),
              ]),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}

// ── 로그아웃 확인 다이얼로그
void _showLogoutDialog(BuildContext context, WidgetRef ref) {
  showDialog<void>(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      title: Text('로그아웃', style: AppTextStyles.heading3),
      content: Text('정말 로그아웃 하시겠어요?', style: AppTextStyles.body2),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            '취소',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            // SharedPreferences 세션 삭제 → routerProvider redirect가 /auth로 자동 이동
            await ref.read(authSessionProvider.notifier).logout();
            // TODO(Phase 2): 캐시·로컬 데이터 초기화 추가
          },
          child: const Text(
            '로그아웃',
            style: TextStyle(
              color: AppColors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}

// ── 섹션 헤더 (학사 정보 / 앱 설정 / 기타)
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textHint,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ── 흰 카드 컨테이너 (메뉴 섹션 배경)
class _MenuCard extends StatelessWidget {
  const _MenuCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: const Color(0xFFEAECF0), width: 0.5),
      ),
      child: Column(children: children),
    );
  }
}

// ── 메뉴 아이템 (아이콘 + 라벨 + 우측 trailing)
class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    this.trailing,
    this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final iconColor = isDestructive ? AppColors.error : AppColors.textHint;
    final labelColor = isDestructive ? AppColors.error : AppColors.textPrimary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: SizedBox(
        height: 52,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            children: [
              Icon(icon, size: 22, color: iconColor),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: labelColor,
                  ),
                ),
              ),
              if (trailing != null)
                trailing!
              else
                const Icon(Icons.chevron_right, size: 18, color: AppColors.textHint),
            ],
          ),
        ),
      ),
    );
  }
}

// ── 아이템 간 구분선
class _ItemDivider extends StatelessWidget {
  const _ItemDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 0.5,
      color: Color(0xFFF9FAFB),
      indent: 16,
    );
  }
}

// ── 학생증 카드 (Phase 1: mockUser 고정)
class _StudentCard extends StatelessWidget {
  const _StudentCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: const Color(0xFFEAECF0), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2F5BE8).withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // 아바타: 이름 첫 글자 이니셜
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF2F5BE8), Color(0xFF6B8EF0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  mockUser.name.substring(0, 1),
                  style: AppTextStyles.heading3.copyWith(color: Colors.white),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(mockUser.name, style: AppTextStyles.heading2),
                  const SizedBox(height: 2),
                  Text(
                    '${mockUser.department} ${mockUser.year}학년',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    mockUser.studentId,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                // TODO(Phase 2): QR 화면으로 이동
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                minimumSize: const Size(0, 36),
              ),
              child: Text('모바일 학생증 보기', style: AppTextStyles.label),
            ),
          ),
        ],
      ),
    );
  }
}
