// lib/data/repositories/api_course_repository.dart

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/course_offering.dart';
import 'course_repository.dart';

class ApiCourseRepository implements CourseRepository {
  final ApiClient _apiClient;

  ApiCourseRepository(this._apiClient);

  @override
  Future<List<CourseOffering>> getAvailableCourses() async {
    try {
      final response = await _apiClient.dio.get('/api/courses');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => CourseOffering.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? '개설과목을 불러오지 못했습니다.';
      throw Exception(message);
    }
  }
}
