// lib/core/utils/app_date_utils.dart
// 역할: 날짜·시간 관련 공통 유틸 함수.

class AppDateUtils {
  static String formatDate(DateTime date) {
    return '${date.year}년 ${date.month}월 ${date.day}일';
  }

  // weekday: 1(월) ~ 7(일) → 한글 요일 반환
  static String dayLabel(int weekday) {
    const days = ['월', '화', '수', '목', '금', '토', '일'];
    return days[weekday - 1];
  }
}
