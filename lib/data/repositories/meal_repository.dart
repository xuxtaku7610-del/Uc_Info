import '../models/meal_data.dart';
import '../mock/mock_data.dart';

abstract class MealRepository {
  Future<MealData> getTodayMeal();
}

class MockMealRepository implements MealRepository {
  @override
  Future<MealData> getTodayMeal() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockData.todayMeal;
  }
}
