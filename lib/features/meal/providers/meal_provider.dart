// 역할: 식단표 상태 관리 및 날짜별 식단 조회 프로바이더

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/meal_data.dart';
import '../../../data/repositories/meal_repository.dart';
import '../../../shared/providers/app_providers.dart';

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
    state = state.copyWith(requestedDate: normalizedDate, isLoading: true, errorMessage: null);
    try {
      final meal = await _repository.getMealByDate(normalizedDate);
      state = state.copyWith(meal: meal, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '식단 정보를 불러오지 못했습니다.',
      );
    }
  }

  Future<void> refreshCurrent() async {
    final meal = await _repository.getMealByDate(state.requestedDate);
    state = state.copyWith(meal: meal);
  }
}

final mealProvider = StateNotifierProvider.autoDispose<MealNotifier, MealState>((ref) {
  final repository = ref.watch(mealRepositoryProvider);
  return MealNotifier(repository);
});
