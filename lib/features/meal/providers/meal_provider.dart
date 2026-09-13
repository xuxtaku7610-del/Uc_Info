import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/meal_data.dart';
import '../../../data/repositories/meal_repository.dart';
import '../../../shared/providers/app_providers.dart';

class MealState {
  final MealData? meal;
  final bool isLoading;
  final String? errorMessage;

  const MealState({
    this.meal,
    this.isLoading = false,
    this.errorMessage,
  });

  MealState copyWith({
    MealData? meal,
    bool? isLoading,
    String? errorMessage,
  }) {
    return MealState(
      meal: meal ?? this.meal,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class MealNotifier extends StateNotifier<MealState> {
  final MealRepository _repository;

  MealNotifier(this._repository) : super(const MealState()) {
    fetchTodayMeal();
  }

  Future<void> fetchTodayMeal() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final meal = await _repository.getTodayMeal();
      state = state.copyWith(meal: meal, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '식단 정보를 불러오지 못했습니다.',
      );
    }
  }
}

final mealProvider = StateNotifierProvider<MealNotifier, MealState>((ref) {
  final repository = ref.watch(mealRepositoryProvider);
  return MealNotifier(repository);
});
