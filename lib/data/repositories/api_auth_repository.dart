import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import 'auth_repository.dart';
import '../models/user.dart';

/// 역할: 백엔드 서버와 실제 통신하는 인증 Repository 구현체
class ApiAuthRepository implements AuthRepository {
  final ApiClient _apiClient;

  ApiAuthRepository(this._apiClient);

  @override
  Future<User> verifyStudent({
    required String department,
    required String name,
    required String studentId,
  }) async {
    try {
      final response = await _apiClient.dio.post('/api/auth/verify', data: {
        'department': department,
        'name': name,
        'studentId': studentId,
      });

      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('학생 인증 실패: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('알 수 없는 오류가 발생했습니다: $e');
    }
  }

  @override
  Future<User?> getMe() async {
    try {
      final response = await _apiClient.dio.get('/api/users/me');
      return User.fromJson(response.data);
    } on DioException catch (e) {
      // 401 Unauthorized인 경우에만 세션 만료로 보고 null 반환
      if (e.response?.statusCode == 401) {
        return null;
      }
      // 그 외의 에러는 외부에서 파악할 수 있도록 throw
      rethrow;
    }
  }
}
