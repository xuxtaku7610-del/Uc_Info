// lib/data/repositories/translation_repository.dart
// 역할: 공지사항 한→영 번역 Repository 인터페이스 + Phase 1 Mock 구현체.

abstract class TranslationRepository {
  // 한국어 텍스트(text)를 영어로 번역해 반환한다.
  Future<String> translate(String text);
}

// Phase 1 구현체 (Mock 데이터 반환)
class MockTranslationRepository implements TranslationRepository {
  static const Map<String, String> _mockTranslations = {
    '2026학년도 1학기 수강신청 변경 안내':
        'Notice on Changes to Course Registration for the 2026 Spring Semester',
    '수강신청 정정 기간이 3월 10일(월)부터 3월 14일(금)까지로 변경되었습니다.':
        'The course registration correction period has been changed to March 10 (Mon).',
  };

  @override
  Future<String> translate(String text) async {
    await Future.delayed(const Duration(seconds: 1));

    final translated = _mockTranslations[text];
    if (translated != null) return translated;

    return '[Mock] Translation not available for this text.';
  }
}
