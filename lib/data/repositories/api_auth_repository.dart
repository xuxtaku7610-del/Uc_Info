import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/api_client.dart';
import '../../core/network/token_storage.dart';
import '../../core/network/api_exception_util.dart';
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
      
      final data = response.data;
      final token = (data is Map && data['token'] != null) ? data['token'] as String : null;
      
      if (token == null) {
        throw Exception('서버 응답에 인증 토큰이 누락되었습니다.');
      }
      await TokenStorage.saveToken(token);

      // 계정별 데이터 관리를 위해 현재 학번 저장
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_student_id', user.studentId);

      return user;
    } on DioException catch (e) {
      throw Exception(extractErrorMessage(e, '학생 인증 실패: ${e.message}'));
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
      throw Exception(extractErrorMessage(e, '내 정보 불러오기 실패: ${e.message}'));
    }
  }
}
