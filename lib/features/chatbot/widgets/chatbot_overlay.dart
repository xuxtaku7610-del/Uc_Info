// lib/features/chatbot/widgets/chatbot_overlay.dart
// 역할: 로그인 후 모든 화면 우측 하단에 챗봇 플로팅 버튼을 띄우고, 누르면 챗봇 시트를 연다.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:university_portal_flutter/core/router/app_router.dart';
import 'package:university_portal_flutter/core/theme/app_colors.dart';
import 'package:university_portal_flutter/core/theme/app_spacing.dart';
import 'package:university_portal_flutter/core/theme/app_text_styles.dart';
import 'package:university_portal_flutter/features/auth/providers/auth_session_provider.dart';
import 'package:university_portal_flutter/features/chatbot/providers/chat_provider.dart';
import 'package:university_portal_flutter/features/chatbot/widgets/chat_sheet.dart';
import 'package:university_portal_flutter/shared/widgets/common_widgets.dart';

/// MaterialApp.router의 builder에서 전체 화면 위에 버튼을 겹쳐 그린다.
/// 기존 화면 코드를 수정하지 않고 모든 화면에 버튼을 노출하기 위함.
class ChatbotOverlay extends ConsumerStatefulWidget {
  final Widget child;

  const ChatbotOverlay({super.key, required this.child});

  @override
  ConsumerState<ChatbotOverlay> createState() => _ChatbotOverlayState();
}

class _ChatbotOverlayState extends ConsumerState<ChatbotOverlay> {
  // 하단 고정 버튼이 있는 화면은 플로팅 버튼을 그만큼 위로 올린다
  static const _liftedPaths = {'/course-picker'};
  static const double _liftOffset = 72;

  late final GoRouter _router;
  String _path = '';

  @override
  void initState() {
    super.initState();
    _router = ref.read(routerProvider);
    _router.routerDelegate.addListener(_onRouteChanged);
    _onRouteChanged();
  }

  @override
  void dispose() {
    _router.routerDelegate.removeListener(_onRouteChanged);
    super.dispose();
  }

  /// 라우터 알림은 빌드 도중에도 올 수 있어, 프레임이 끝난 뒤 경로를 반영한다.
  /// (빌드 중 setState → Navigator 재부모화 오류 방지)
  void _onRouteChanged() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final path = _router.routerDelegate.currentConfiguration.uri.path;
      if (path != _path) setState(() => _path = path);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = ref.watch(authSessionProvider).valueOrNull ?? false;
    final isSheetOpen = ref.watch(chatSheetOpenProvider);
    final showButton = isLoggedIn && !isSheetOpen && _path != '/auth';
    final bottom = MediaQuery.paddingOf(context).bottom +
        AppSpacing.md +
        (_liftedPaths.contains(_path) ? _liftOffset : 0);

    // 자식 구성을 항상 같게 유지해 Navigator(child)가 재배치되지 않도록 한다
    return Stack(
      children: [
        widget.child,
        Positioned(
          right: AppSpacing.md,
          bottom: bottom,
          child: Visibility(
            visible: showButton,
            child: _ChatbotButton(onTap: _openSheet),
          ),
        ),
      ],
    );
  }

  /// builder는 Navigator 바깥이므로 라우터의 Navigator context로 시트를 연다.
  Future<void> _openSheet() async {
    final navigatorContext = _router.routerDelegate.navigatorKey.currentContext;
    if (navigatorContext == null) return;

    ref.read(chatSheetOpenProvider.notifier).state = true;
    await showAppBottomSheet<void>(
      navigatorContext,
      (_) => const ChatSheet(),
      isScrollControlled: true,
    );
    if (!mounted) return;
    ref.read(chatSheetOpenProvider.notifier).state = false;
  }
}

/// 56px 원형 챗봇 버튼
class _ChatbotButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ChatbotButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '공지 AI 챗봇 열기',
      child: Material(
        color: AppColors.primary,
        shape: const CircleBorder(),
        elevation: 6,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 56,
            height: 56,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 20),
                Text(
                  '챗봇',
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
