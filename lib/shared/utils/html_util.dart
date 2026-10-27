// 역할: HTML 본문 정규화 유틸 (태그가 없는 경우 줄바꿈 문자를 <br>로 치환)

String normalizeNoticeContent(String raw) {
  if (!raw.contains(RegExp(r'<[^>]*>'))) {
    return raw.replaceAll('\n', '<br>');
  }
  return raw;
}
