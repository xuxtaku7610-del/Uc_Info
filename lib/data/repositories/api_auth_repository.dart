import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/network/token_storage.dart';
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

      final user = User.fromJson(response.data);
      
      // 로그인 성공 시 응답에서 토큰을 추출하여 저장 (응답 구조에 따라 수정 필요)
      // 현재는 studentId를 토큰 대용으로 쓰거나 별도 필드가 있다고 가정
      final token = response.data['token'] ?? studentId; 
      await TokenStorage.saveToken(token);

      return user;
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
      if (e.response?.statusCode == 401) {
        return null;
      }
      rethrow;
    }
  }
}
