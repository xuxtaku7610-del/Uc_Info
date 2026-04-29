// 하나의 '공지사항' 데이터를 담는 규격 상자입니다.
class NoticeItem {
  // 생성자(Constructor): 이 상자를 만들 때 반드시(required)
  // 날짜(day), 제목(title), 종류(type)를 넣도록 강제합니다.
  const NoticeItem({
    required this.day,
    required this.title,
    required this.type,
  });

  // final: 한 번 상자에 담긴 데이터는 나중에 함부로 변경할 수 없도록 잠급니다. (안전성 확보)
  final String day;   // 예: '28'
  final String title; // 예: '2026학년도 1학기 수강신청 최종 안내'
  final String type;  // 예: 'notice' (이 값을 기준으로 탭 필터링이 동작합니다)
}