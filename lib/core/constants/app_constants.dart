// 역할: 앱 전역 상수(앱 이름 등).

class AppConstants {
  static const String currentSemesterLabel = '2026학년도 1학기'; // TODO: 학기 API 생기면 동적으로 교체

  /// 백엔드 /api/meal/today 가 date 파라미터를 지원하면 true로 변경
  static const bool mealDateApiSupported = false;
}
