import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/schedule_item.dart';
import 'schedule_repository.dart';

class ApiScheduleRepository implements ScheduleRepository {
  final ApiClient _apiClient;

  ApiScheduleRepository(this._apiClient);

  @override
  Future<List<ScheduleItem>> getWeeklySchedule() async {
    try {
      final response = await _apiClient.dio.get('/api/schedule/me');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ScheduleItem.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception('시간표 정보 불러오기 실패: ${e.message}');
    }
  }
}
