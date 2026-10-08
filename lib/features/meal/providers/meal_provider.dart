// 역할: 식단표 상태 관리 및 날짜별 식단 조회 프로바이더

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:university_portal_flutter/core/constants/app_constants.dart';
import '../../../data/models/meal_data.dart';
import '../../../data/repositories/meal_repository.dart';
import '../../../shared/providers/app_providers.dart';

bool _isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

class MealState {
  final MealData? meal;
  final bool isLoading;
  final String? errorMessage;
  final DateTime requestedDate;

  MealState({
    this.meal,
    this.isLoading = false,
    this.errorMessage,
    DateTime? requestedDate,
  }) : requestedDate = requestedDate != null
            ? DateTime(requestedDate.year, requestedDate.month, requestedDate.day)
            : DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  bool get isUnsupportedDate => !AppConstants.mealDateApiSupported && !_isSameDay(requestedDate, DateTime.now());

  MealState copyWith({
    MealData? meal,
    bool? isLoading,
    String? errorMessage,
    DateTime? requestedDate,
  }) {
    return MealState(
      meal: meal ?? this.meal,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      requestedDate: requestedDate ?? this.requestedDate,
    );
  }
}

class MealNotifier extends StateNotifier<MealState> {
  final MealRepository _repository;

  MealNotifier(this._repository) : super(MealState()) {
    fetchMealByDate(DateTime.now());
  }

  Future<void> fetchMealByDate(DateTime date) async {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    if (!AppConstants.mealDateApiSupported && !_isSameDay(normalizedDate, DateTime.now())) {
      state = state.copyWith(requestedDate: normalizedDate, isLoading: false, errorMessage: null);
      return;
    }

    // 이전 날짜의 식단이 남아 보이지 않도록 meal을 비운 새 상태로 시작한다
    state = MealState(requestedDate: normalizedDate, isLoading: true);
    try {
      final meal = await _repository.getMealByDate(normalizedDate);
      // 응답 대기 중 다른 날짜로 바뀌었다면 늦게 온 응답은 버린다
      if (!_isSameDay(state.requestedDate, normalizedDate)) return;
      state = state.copyWith(meal: meal, isLoading: false);
    } catch (e) {
      if (!_isSameDay(state.requestedDate, normalizedDate)) return;
      state = state.copyWith(
        isLoading: false,
        errorMessage: '식단 정보를 불러오지 못했습니다.',
      );
    }
  }

  Future<void> refreshCurrent() async {
    if (state.isUnsupportedDate) return;
    final meal = await _repository.getMealByDate(state.requestedDate);
    state = state.copyWith(meal: meal);
  }
}

final mealProvider = StateNotifierProvider.autoDispose<MealNotifier, MealState>((ref) {
  final repository = ref.watch(mealRepositoryProvider);
  return MealNotifier(repository);
});
