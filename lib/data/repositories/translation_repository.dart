// lib/data/repositories/translation_repository.dart
// 역할: 공지사항 한→영 번역 Repository 인터페이스 + Phase 1 Mock 구현체.
// TODO(Phase 2): MockTranslationRepository → ApiTranslationRepository(DeepL 등 실제 API)로 교체

abstract class TranslationRepository {
  // 한국어 텍스트(text)를 영어로 번역해 반환한다.
  Future<String> translate(String text);
}

// Phase 1 구현체 (Mock 데이터 반환)
// why: 실제 번역 API(DeepL 등) 연동 전, UI(로딩/결과/에러 분기) 동작을 검증하기 위해
//      네트워크 호출 없이 하드코딩된 번역 결과를 반환한다.
class MockTranslationRepository implements TranslationRepository {
  // 데모용 한→영 번역 매핑.
  // how: 화면에서 사용할 공지사항 원문(제목+본문)을 key로 두고, 미리 준비한 영어 번역을 value로 둔다.
  static const Map<String, String> _mockTranslations = {
    '2026학년도 1학기 수강신청 변경 안내':
        'Notice on Changes to Course Registration for the 2026 Spring Semester',
    '수강신청 정정 기간이 3월 10일(월)부터 3월 14일(금)까지로 변경되었습니다.\n'
            '포털 시스템 접속 후 학사정보 메뉴에서 신청 가능합니다.\n'
            '문의사항은 학사지원처(052-123-4567)로 연락 바랍니다.':
        'The course registration correction period has been changed to '
            'March 10 (Mon) through March 14 (Fri).\n'
            'You can apply via the Academic Information menu after logging '
            'into the portal system.\n'
            'For inquiries, please contact the Academic Affairs Office '
            '(052-123-4567).',
  };

  @override
  Future<String> translate(String text) async {
    // why: 실제 API 호출처럼 보이도록 약간의 지연을 주어 로딩 상태(_isLoading)를 체감할 수 있게 한다.
    await Future.delayed(const Duration(seconds: 1));

    final translated = _mockTranslations[text];
    if (translated != null) return translated;

    // how: 매핑에 없는 텍스트는 안내 문구를 반환한다 (Phase 2에서는 실제 API 응답으로 대체).
    return '[Mock] Translation not available for this text.';
  }
}
