// lib/data/repositories/api_enrollment_repository.dart

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_exception_util.dart';
import 'enrollment_repository.dart';

class ApiEnrollmentRepository implements EnrollmentRepository {
  final ApiClient _apiClient;

  ApiEnrollmentRepository(this._apiClient);

  @override
  Future<void> enroll(int courseOfferingId) async {
    try {
      await _apiClient.dio.post('/api/enrollments', data: {
        'courseOfferingId': courseOfferingId,
      });
    } on DioException catch (e) {
      throw Exception(extractErrorMessage(e, '수강 신청에 실패했습니다.'));
    }
  }

  @override
  Future<void> unenroll(int enrollmentId) async {
    try {
      await _apiClient.dio.delete('/api/enrollments/$enrollmentId');
    } on DioException catch (e) {
      throw Exception(extractErrorMessage(e, '수강 취소에 실패했습니다.'));
    }
  }
}
