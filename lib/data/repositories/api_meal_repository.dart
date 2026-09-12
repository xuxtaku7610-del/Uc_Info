import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/meal_data.dart';
import 'meal_repository.dart';

class ApiMealRepository implements MealRepository {
  final ApiClient _apiClient;

  ApiMealRepository(this._apiClient);

  @override
  Future<MealData> getTodayMeal() async {
    try {
      final response = await _apiClient.dio.get('/api/meal/today');

      if (response.statusCode == 200) {
        return MealData.fromJson(response.data);
      }
      throw Exception('오늘의 식단 데이터가 없습니다.');
    } on DioException catch (e) {
      throw Exception('식단 정보 불러오기 실패: ${e.message}');
    }
  }
}
