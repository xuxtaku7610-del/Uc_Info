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

// 1. ApiClient Provider
final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

// 2. Auth Repository Provider
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
