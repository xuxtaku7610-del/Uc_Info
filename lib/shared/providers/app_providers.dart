// lib/shared/providers/app_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_client.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/api_auth_repository.dart';
import '../../data/models/user.dart';
import '../../data/repositories/notice_repository.dart';
import '../../data/repositories/api_notice_repository.dart';
import '../../data/repositories/meal_repository.dart';
import '../../data/repositories/api_meal_repository.dart';
import '../../data/repositories/schedule_repository.dart';
import '../../data/repositories/api_schedule_repository.dart';
import '../../data/repositories/banner_repository.dart';
import '../../data/repositories/api_banner_repository.dart';
import '../../data/repositories/academic_calendar_repository.dart';
import '../../data/repositories/api_academic_calendar_repository.dart';
import '../../data/repositories/scholarship_repository.dart';
import '../../data/repositories/api_scholarship_repository.dart';
import '../../data/repositories/course_repository.dart';
import '../../data/repositories/api_course_repository.dart';
import '../../data/repositories/enrollment_repository.dart';
import '../../data/repositories/api_enrollment_repository.dart';

// 1. ApiClient Provider
final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

// 2. Auth Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  // return ApiAuthRepository(ref.watch(apiClientProvider));
  return MockAuthRepository(); // 임시 더미 로그인 활성화
});

// 간단한 더미 로그인용 Mock 클래스
class MockAuthRepository implements AuthRepository {
  @override
  Future<User> verifyStudent({required String name, required String department, required String studentId}) async {
    // 아무 값이나 입력해도 7자리 숫자이기만 하면 로그인 성공 처리
    return User(studentId: studentId, name: name, department: department, year: 1);
  }
  @override
  Future<User?> getMe() async => User(studentId: '2024001', name: '테스터', department: '컴퓨터공학', year: 1);
}

// 3. Notice Repository Provider (API 연결 완료)
final noticeRepositoryProvider = Provider<NoticeRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ApiNoticeRepository(apiClient);
});

// 4. Meal Repository Provider (API 연결 완료)
final mealRepositoryProvider = Provider<MealRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ApiMealRepository(apiClient);
});

// 5. Schedule Repository Provider (백엔드 API 미준비로 인한 임시 Mock 유지)
final scheduleRepositoryProvider = Provider<ScheduleRepository>((ref) {
  // TODO: 백엔드 API(/api/schedule/me) 준비 완료 시 아래 코드로 교체
  // final apiClient = ref.watch(apiClientProvider);
  // return ApiScheduleRepository(apiClient);
  return MockScheduleRepository();
});

// 6. Banner Repository Provider
final bannerRepositoryProvider = Provider<BannerRepository>((ref) {
  // Phase 2 전환 시: return ApiBannerRepository(ref.watch(apiClientProvider));
  return MockBannerRepository();
});

// 7. Academic Calendar Repository Provider
final academicCalendarRepositoryProvider = Provider<AcademicCalendarRepository>((ref) {
  // Phase 2 전환 시: return ApiAcademicCalendarRepository(ref.watch(apiClientProvider));
  return MockAcademicCalendarRepository();
});

// 8. Scholarship Repository Provider
final scholarshipRepositoryProvider = Provider<ScholarshipRepository>((ref) {
  // Phase 2 전환 시: return ApiScholarshipRepository(ref.watch(apiClientProvider));
  return MockScholarshipRepository();
});

// 9. Course Repository Provider
final courseRepositoryProvider = Provider<CourseRepository>((ref) {
  // Phase 2 전환 시: return ApiCourseRepository(ref.watch(apiClientProvider));
  return MockCourseRepository();
});

// 10. Enrollment Repository Provider
final enrollmentRepositoryProvider = Provider<EnrollmentRepository>((ref) {
  // Phase 2 전환 시: return ApiEnrollmentRepository(ref.watch(apiClientProvider));
  return MockEnrollmentRepository();
});
