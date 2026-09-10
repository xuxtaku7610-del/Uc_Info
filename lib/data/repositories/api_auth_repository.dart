import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/api_client.dart';
import 'auth_repository.dart';
import '../models/user.dart';

/// 역할: 백엔드 서버와 실제 통신하는 인증 Repository 구현체
class ApiAuthRepository implements AuthRepository {
  final Dio _dio = ApiClient.dio;

  @override
  Future<User> verifyStudent({
    required String department,
    required String name,
    required String studentId,
  }) async {
    final response = await _dio.post('/api/auth/verify', data: {
      'department': department,
      'name': name,
      'studentId': studentId,
    });

    // 필요시 토큰 저장 로직 추가 가능
    return User.fromJson(response.data);
  }

  @override
  Future<User?> getMe() async {
    try {
      final response = await _dio.get('/api/users/me');
      return User.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }
}