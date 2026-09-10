// lib/data/repositories/translation_repository.dart
// 역할: 공지사항 한→영 번역 Repository 인터페이스.

abstract class TranslationRepository {
  // 한국어 텍스트(text)를 영어로 번역해 반환한다.
  Future<String> translate(String text);
}
