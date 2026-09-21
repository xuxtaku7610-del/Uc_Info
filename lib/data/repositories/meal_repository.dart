import '../models/meal_data.dart';

abstract class MealRepository {
  Future<MealData> getTodayMeal();
}
