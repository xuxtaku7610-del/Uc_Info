import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_exception_util.dart';
import '../models/schedule_item.dart';
import 'schedule_repository.dart';

class ApiScheduleRepository implements ScheduleRepository {
  final ApiClient _apiClient;

  ApiScheduleRepository(this._apiClient);

  @override
  Future<List<ScheduleItem>> getWeeklySchedule() async {
    try {
      final response = await _apiClient.dio.get('/api/schedule/me');

      final rawData = response.data;
      if (rawData is! List) {
        throw Exception('예상치 못한 응답 형식입니다.');
      }
      final List<dynamic> data = rawData;

      try {
        return data.map((json) => ScheduleItem.fromJson(json)).toList();
      } catch (e) {
        throw Exception('데이터 형식이 올바르지 않습니다.');
      }
    } on DioException catch (e) {
      throw Exception(extractErrorMessage(e, '시간표 정보 불러오기 실패: ${e.message}'));
    }
  }
}
