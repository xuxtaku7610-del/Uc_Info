abstract class TranslationRepository {
  // 한국어 텍스트(text)를 영어로 번역해 반환한다.
  Future<String> translate(String text);
}
