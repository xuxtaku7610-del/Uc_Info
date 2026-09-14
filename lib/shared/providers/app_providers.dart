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
  // final apiClient = ref.watch(apiClientProvider);
  // return ApiAuthRepository(apiClient);
  return MockAuthRepository(); // 테스트를 위한 임시 Mock 전환
});

// 아래에 간단한 Mock 클래스 추가 (테스트 후 삭제 예정)
class MockAuthRepository implements AuthRepository {
  @override
  Future<User> verifyStudent({required String name, required String department, required String studentId}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return User(studentId: studentId, name: name, department: department, year: 2);
  }
  @override
  Future<User?> getMe() async => User(studentId: '2411206', name: '김철수', department: '컴퓨터공학과', year: 2);
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

// 5. Schedule Repository Provider (API 연결 완료)
final scheduleRepositoryProvider = Provider<ScheduleRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ApiScheduleRepository(apiClient);
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
