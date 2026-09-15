// lib/shared/providers/app_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_client.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/api_auth_repository.dart';
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
final apiClientProvider = Provider<ApiClient>((ref) => ApiClient(ref));

// 2. Auth Repository Provider (API 연결 완료)
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ApiAuthRepository(apiClient);
});

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

// 6. Banner Repository Provider (API 연결 완료)
final bannerRepositoryProvider = Provider<BannerRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ApiBannerRepository(apiClient);
});

// 7. Academic Calendar Repository Provider (API 연결 완료)
final academicCalendarRepositoryProvider = Provider<AcademicCalendarRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ApiAcademicCalendarRepository(apiClient);
});

// 8. Scholarship Repository Provider (API 연결 완료)
final scholarshipRepositoryProvider = Provider<ScholarshipRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ApiScholarshipRepository(apiClient);
});

// 9. Course Repository Provider (API 연결 완료)
final courseRepositoryProvider = Provider<CourseRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ApiCourseRepository(apiClient);
});

// 10. Enrollment Repository Provider (API 연결 완료)
final enrollmentRepositoryProvider = Provider<EnrollmentRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ApiEnrollmentRepository(apiClient);
});
