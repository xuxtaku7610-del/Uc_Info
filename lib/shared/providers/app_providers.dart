// lib/shared/providers/app_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_client.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/api_auth_repository.dart';
import '../../data/repositories/notice_repository.dart';
import '../../data/repositories/meal_repository.dart';

// 1. ApiClient Provider
final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

// 2. Auth Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ApiAuthRepository(apiClient);
});

// 3. Notice Repository Provider (TODO: Phase2 전환 시 ApiNoticeRepository로 교체)
final noticeRepositoryProvider = Provider<NoticeRepository>((ref) {
  // final apiClient = ref.watch(apiClientProvider);
  // return ApiNoticeRepository(apiClient);
  return MockNoticeRepository();
});

// 4. Meal Repository Provider (TODO: Phase2 전환 시 ApiMealRepository로 교체)
final mealRepositoryProvider = Provider<MealRepository>((ref) {
  // final apiClient = ref.watch(apiClientProvider);
  // return ApiMealRepository(apiClient);
  return MockMealRepository();
});
