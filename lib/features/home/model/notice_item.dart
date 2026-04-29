class NoticeItem {
  final String title;
  // [수정 포인트: 필드 확장]
  // 현재 에러가 날 수 있습니다. home_page.dart에서 type 필드를 쓰고 있는데, 여기 모델에는 type이 없습니다.
  // 나중에 이 모델을 실제 DB 구조와 맞게 id, type, imageUrl 등을 추가해야 합니다.
  final String type; // 예시 추가
  final String date;

  const NoticeItem({
    required this.title,
    required this.type,
    required this.date,
  });
}