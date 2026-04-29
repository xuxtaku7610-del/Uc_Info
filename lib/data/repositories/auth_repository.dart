// lib/data/repositories/auth_repository.dart
// 역할: 학번 인증 Repository 인터페이스 + Phase 1 Mock 구현체.
// TODO(Phase 2): MockAuthRepository → ApiAuthRepository로 교체

import 'package:university_portal_flutter/data/mock/mock_data.dart';
import 'package:university_portal_flutter/data/models/user.dart';

abstract class AuthRepository {
  Future<User> verifyStudent({
    required String name,
    required String department,
    required String studentId,
  });
}

// Phase 1 구현체 (Mock 데이터 반환)
// Why: UI 개발 단계에서 API 없이 동작 검증이 가능하도록 인터페이스를 먼저 분리했다.
class MockAuthRepository implements AuthRepository {
  @override
  Future<User> verifyStudent({
    required String name,
    required String department,
    required String studentId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500)); // 로딩 시뮬레이션
    const users = [mockUser, mockUser2, mockUser3];
    final match = users.cast<User?>().firstWhere(
      (u) => u!.studentId == studentId,
      orElse: () => null,
    );
    if (match != null) return match;
    throw Exception('학번을 확인해주세요.');
  }
}
