// lib/data/repositories/api_academic_calendar_repository.dart

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/academic_event.dart';
import 'academic_calendar_repository.dart';

class ApiAcademicCalendarRepository implements AcademicCalendarRepository {
  final ApiClient _apiClient;

  ApiAcademicCalendarRepository(this._apiClient);

  @override
  Future<List<AcademicEvent>> getCalendar() async {
    try {
      final response = await _apiClient.dio.get('/api/academic-calendar');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => AcademicEvent.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = (data is Map && data['message'] != null) ? data['message'] as String : '학사일정을 불러오지 못했습니다.';
      throw Exception(message);
    }
  }
}
