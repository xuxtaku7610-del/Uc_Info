// lib/data/repositories/auth_repository.dart
// 역할: 학번 인증 Repository 인터페이스.

import 'package:university_portal_flutter/data/models/user.dart';

/// 역할: 학번 인증 Repository 인터페이스
abstract class AuthRepository {
  Future<User> verifyStudent({
    required String name,
    required String department,
    required String studentId,
  });

  Future<User?> getMe();
}
