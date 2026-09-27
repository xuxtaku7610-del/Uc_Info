// 역할: 식단 데이터 조회를 위한 레포지토리 인터페이스 정의

import '../models/meal_data.dart';

abstract class MealRepository {
  Future<MealData> getMealByDate(DateTime date);
  Future<MealData> getTodayMeal() => getMealByDate(DateTime.now());
}
