// lib/features/notice/screens/notice_translation_screen.dart
// 역할: 공지사항 한→영 번역 화면. 외국인 유학생을 위해 한국어 공지사항을
//       영어로 번역해 보여준다. (Phase 1: MockTranslationRepository 사용)

import 'package:flutter/material.dart';
import 'package:university_portal_flutter/core/theme/app_colors.dart';
import 'package:university_portal_flutter/core/theme/app_spacing.dart';
import 'package:university_portal_flutter/core/theme/app_text_styles.dart';
import 'package:university_portal_flutter/data/repositories/translation_repository.dart';

class NoticeTranslationScreen extends StatefulWidget {
  const NoticeTranslationScreen({super.key});

  @override
  State<NoticeTranslationScreen> createState() =>
      _NoticeTranslationScreenState();
}

class _NoticeTranslationScreenState extends State<NoticeTranslationScreen> {
  // why: Phase 1에서는 Mock 구현체를 직접 사용하고, Phase 2에서는
  //      ApiTranslationRepository로 교체하면 된다 (TODO 주석 참고).
  // TODO(Phase 2): MockTranslationRepository → ApiTranslationRepository로 교체
  final TranslationRepository _translationRepository =
      MockTranslationRepository();

  // 화면에 보여줄 하드코딩된 원본 공지사항 (제목/본문)
  static const String _originalTitle = '2026학년도 1학기 수강신청 변경 안내';
  static const String _originalContent =
      '수강신청 정정 기간이 3월 10일(월)부터 3월 14일(금)까지로 변경되었습니다.\n'
      '포털 시스템 접속 후 학사정보 메뉴에서 신청 가능합니다.\n'
      '문의사항은 학사지원처(052-123-4567)로 연락 바랍니다.';

  // 번역 결과 (null이면 결과 카드 미표시)
  String? _translatedText;
  // 번역 요청 진행 중 여부
  bool _isLoading = false;
  // 에러 메시지 (null이면 에러 영역 미표시)
  String? _errorMessage;

  // [Translate to English] 버튼을 눌렀을 때 실행되는 번역 로직.
  // how: 1) 로딩 시작 → 2) 제목/본문을 각각 번역 → 3) 결과 합치기 → 4) 성공/실패에 따라 상태 갱신
  Future<void> _translate() async {
    // why: 버튼을 누르는 즉시 로딩 상태로 전환하고, 이전 결과/에러는 초기화한다.
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _translatedText = null;
    });

    try {
      // 제목과 본문을 각각 번역 요청한다.
      final translatedTitle = await _translationRepository.translate(
        _originalTitle,
      );
      final translatedContent = await _translationRepository.translate(
        _originalContent,
      );

      // why: async 작업 이후 context/state를 사용하려면 위젯이 여전히
      //      트리에 있는지 mounted로 확인해야 한다.
      if (!mounted) return;

      // how: 제목과 본문을 한 문단으로 합쳐 _translatedText에 저장한다.
      setState(() {
        _translatedText = '$translatedTitle\n\n$translatedContent';
        _isLoading = false;
      });
    } catch (e) {
      // why: 번역 중 예외(네트워크 오류 등)가 발생하면 에러 메시지를 화면에 표시한다.
      if (!mounted) return;

      setState(() {
        _errorMessage = '번역에 실패했습니다. 잠시 후 다시 시도해주세요.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('공지사항 번역', style: AppTextStyles.heading2),
        backgroundColor: AppColors.surface,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // [A] 원본 공지사항 카드
              _buildOriginalCard(),
              const SizedBox(height: AppSpacing.md),

              // [B] 번역 버튼
              _buildTranslateButton(),
              const SizedBox(height: AppSpacing.md),

              // [C] 결과 영역 (로딩 / 에러 / 번역 결과 분기)
              _buildResultArea(),
            ],
          ),
        ),
      ),
    );
  }

  // ── [A] 원본 공지사항 카드 ──────────────────────────────────────
  Widget _buildOriginalCard() {
    return Card(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 카드 상단 라벨: "원본 (한국어)"
            Text(
              '원본 (한국어)',
              style: AppTextStyles.caption.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(_originalTitle, style: AppTextStyles.heading3),
            const SizedBox(height: AppSpacing.sm),
            const Text(_originalContent, style: AppTextStyles.body1),
          ],
        ),
      ),
    );
  }

  // ── [B] 번역 버튼 ──────────────────────────────────────────────
  Widget _buildTranslateButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        // why: 로딩 중에는 중복 요청을 막기 위해 버튼을 비활성화한다.
        onPressed: _isLoading ? null : _translate,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
        ),
        child: const Text('Translate to English 🌐', style: AppTextStyles.buttonText),
      ),
    );
  }

  // ── [C] 결과 영역 ──────────────────────────────────────────────
  // how: _isLoading → _errorMessage → _translatedText 순서로 분기 처리한다.
  Widget _buildResultArea() {
    // 케이스 1: 번역 요청 진행 중
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
        child: Column(
          children: [
            CircularProgressIndicator(color: AppColors.primary),
            SizedBox(height: AppSpacing.sm),
            Text('번역 중...', style: AppTextStyles.body2),
          ],
        ),
      );
    }

    // 케이스 2: 에러 발생
    if (_errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Text(
          _errorMessage!,
          style: AppTextStyles.body1.copyWith(color: AppColors.error),
        ),
      );
    }

    // 케이스 3: 번역 결과 표시
    if (_translatedText != null) {
      return Card(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 카드 상단 라벨: "Translation (English)"
              Text(
                'Translation (English)',
                style: AppTextStyles.caption.copyWith(color: AppColors.accentDark),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(_translatedText!, style: AppTextStyles.body1),
            ],
          ),
        ),
      );
    }

    // 기본: 아직 번역을 요청하지 않은 초기 상태 → 빈 영역
    return const SizedBox.shrink();
  }
}
