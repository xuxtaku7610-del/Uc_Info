// lib/data/repositories/api_course_repository.dart

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_exception_util.dart';
import '../models/course_offering.dart';
import 'course_repository.dart';

class ApiCourseRepository implements CourseRepository {
  final ApiClient _apiClient;

  ApiCourseRepository(this._apiClient);

  @override
  Future<List<CourseOffering>> getAvailableCourses() async {
    try {
      final response = await _apiClient.dio.get('/api/courses');

      final rawData = response.data;
      if (rawData is! List) {
        throw Exception('예상치 못한 응답 형식입니다.');
      }
      final List<dynamic> data = rawData;

      try {
        return data.map((json) => CourseOffering.fromJson(json)).toList();
      } catch (e) {
        throw Exception('데이터 형식이 올바르지 않습니다.');
      }
    } on DioException catch (e) {
      throw Exception(extractErrorMessage(e, '개설과목을 불러오지 못했습니다.'));
    }
  }
}
