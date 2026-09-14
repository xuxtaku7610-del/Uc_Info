import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_exception_util.dart';
import '../models/meal_data.dart';
import 'meal_repository.dart';

class ApiMealRepository implements MealRepository {
  final ApiClient _apiClient;

  ApiMealRepository(this._apiClient);

  @override
  Future<MealData> getTodayMeal() async {
    try {
      final response = await _apiClient.dio.get('/api/meal/today');

      return MealData.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(extractErrorMessage(e, '식단 정보 불러오기 실패: ${e.message}'));
    }
  }
}
