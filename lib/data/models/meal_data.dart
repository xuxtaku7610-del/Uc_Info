// lib/data/models/meal_data.dart
// 역할: 식단표 모델. 조식·중식·석식 각 섹션 포함 (백엔드 응답에 따라 nullable 허용)

class MealSection {
  final String time;
  final List<String> items;

  const MealSection({required this.time, required this.items});

  factory MealSection.fromJson(Map<String, dynamic> json) {
    return MealSection(
      time: json['time'] ?? '',
      items: List<String>.from(json['items'] ?? []),
    );
  }
}

class MealData {
  final String date;
  final MealSection? breakfast;
  final MealSection? lunch;
  final MealSection? dinner;

  const MealData({
    required this.date,
    this.breakfast,
    this.lunch,
    this.dinner,
  });

  factory MealData.fromJson(Map<String, dynamic> json) {
    return MealData(
      date: json['date'] ?? '',
      breakfast: json['breakfast'] != null ? MealSection.fromJson(json['breakfast']) : null,
      lunch: json['lunch'] != null ? MealSection.fromJson(json['lunch']) : null,
      dinner: json['dinner'] != null ? MealSection.fromJson(json['dinner']) : null,
    );
  }
}
