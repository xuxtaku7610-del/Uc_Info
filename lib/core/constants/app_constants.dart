// lib/core/constants/app_constants.dart
// 역할: 앱 전역 상수. Phase 2에서 API base URL 등을 여기서 관리한다.

class AppConstants {
  static const String appName = 'UC Info';

  // TODO(Phase 2): 실제 API 서버 URL로 교체
  static const String apiBaseUrl = 'https://api.uc-info.example.com';

  // Phase 1 인증 통과 학번 (Mock 전용)
  static const String mockPassStudentId = '2411206';
}
