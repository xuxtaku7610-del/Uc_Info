// 역할: Dio를 이용한 원격 서버 식단 데이터 레포지토리 구현체

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_exception_util.dart';
import '../models/meal_data.dart';
import 'meal_repository.dart';

class ApiMealRepository implements MealRepository {
  final ApiClient _apiClient;

  ApiMealRepository(this._apiClient);

  @override
  Future<MealData> getMealByDate(DateTime date) async {
    try {
      final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final response = await _apiClient.dio.get(
        '/api/meal/today',
        queryParameters: {'date': dateStr},
      );

      return MealData.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(extractErrorMessage(e, '식단 정보를 불러오지 못했습니다.'));
    }
  }

  @override
  Future<MealData> getTodayMeal() => getMealByDate(DateTime.now());
}
