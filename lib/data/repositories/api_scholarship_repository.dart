// lib/data/repositories/api_scholarship_repository.dart

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/scholarship.dart';
import 'scholarship_repository.dart';

class ApiScholarshipRepository implements ScholarshipRepository {
  final ApiClient _apiClient;

  ApiScholarshipRepository(this._apiClient);

  @override
  Future<List<Scholarship>> getScholarships({String? type}) async {
    try {
      final Map<String, dynamic> queryParams = {};
      if (type != null) {
        queryParams['type'] = type;
      }

      final response = await _apiClient.dio.get(
        '/api/scholarships',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Scholarship.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? '장학금 목록을 불러오지 못했습니다.';
      throw Exception(message);
    }
  }

  @override
  Future<Scholarship> getScholarshipDetail(int id) async {
    try {
      final response = await _apiClient.dio.get('/api/scholarships/$id');

      if (response.statusCode == 200) {
        return Scholarship.fromJson(response.data);
      }
      throw Exception('데이터 없음');
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? '장학금 상세 정보를 불러오지 못했습니다.';
      throw Exception(message);
    }
  }
}
