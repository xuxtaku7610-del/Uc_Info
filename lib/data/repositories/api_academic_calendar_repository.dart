// lib/data/repositories/api_academic_calendar_repository.dart

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_exception_util.dart';
import '../models/academic_event.dart';
import 'academic_calendar_repository.dart';

class ApiAcademicCalendarRepository implements AcademicCalendarRepository {
  final ApiClient _apiClient;

  ApiAcademicCalendarRepository(this._apiClient);

  @override
  Future<List<AcademicEvent>> getCalendar() async {
    try {
      final response = await _apiClient.dio.get('/api/academic-calendar');

      final rawData = response.data;
      if (rawData is! List) {
        throw Exception('예상치 못한 응답 형식입니다.');
      }
      final List<dynamic> data = rawData;

      try {
        return data.map((json) => AcademicEvent.fromJson(json)).toList();
      } catch (e) {
        throw Exception('데이터 형식이 올바르지 않습니다.');
      }
    } on DioException catch (e) {
      throw Exception(extractErrorMessage(e, '학사일정을 불러오지 못했습니다.'));
    }
  }
}
