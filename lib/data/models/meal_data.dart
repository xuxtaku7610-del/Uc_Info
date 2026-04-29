// lib/data/models/meal_data.dart
// 역할: 식단표 모델. 조식·중식·석식 각 섹션 포함.

class MealSection {
  final String time;
  final List<String> items;

  const MealSection({required this.time, required this.items});
}

class MealData {
  final String date;
  final MealSection breakfast;
  final MealSection lunch;
  final MealSection dinner;

  const MealData({
    required this.date,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
  });
}
