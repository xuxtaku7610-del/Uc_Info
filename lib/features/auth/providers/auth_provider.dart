// lib/features/auth/providers/auth_provider.dart
// 역할: 학번 인증 상태를 관리하는 StateNotifier.
// 인증 성공 시 AuthState.isSuccess = true, 실패 시 각 필드 에러 표시.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:university_portal_flutter/data/repositories/auth_repository.dart';
import 'package:university_portal_flutter/features/auth/providers/auth_session_provider.dart';
import 'package:university_portal_flutter/data/repositories/api_auth_repository.dart';
import 'package:university_portal_flutter/shared/providers/app_providers.dart';

class AuthState {
  final bool isLoading;
  final String? nameError;
  final String? departmentError;
  final String? studentIdError;

  const AuthState({
    this.isLoading = false,
    this.nameError,
    this.departmentError,
    this.studentIdError,
  });

  // nullable 필드를 명시적으로 null로 지울 수 있도록 Function() 래퍼 패턴 사용
  AuthState copyWith({
    bool? isLoading,
    String? Function()? nameError,
    String? Function()? departmentError,
    String? Function()? studentIdError,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      nameError: nameError != null ? nameError() : this.nameError,
      departmentError: departmentError != null ? departmentError() : this.departmentError,
      studentIdError: studentIdError != null ? studentIdError() : this.studentIdError,
    );
  }
}

// 학번 인증 상태를 관리하는 StateNotifier.
// 인증 성공 시 true 반환, 실패(유효성 오류·Mock 불일치) 시 false 반환.
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier({required AuthRepository repository, required Ref ref})
      : _repository = repository,
        _ref = ref,
        super(const AuthState());

  final AuthRepository _repository;
  final Ref _ref;

  Future<bool> verifyStudent({
    required String name,
    required String department,
    required String studentId,
  }) async {
    // 유효성 검사: 버튼 탭 시 전체 필드 동시 검사
    final nameErr = name.trim().length < 2 ? '이름을 입력해주세요.' : null;
    final deptErr = department.trim().isEmpty ? '학과를 입력해주세요.' : null;
    final idErr = studentId.trim().isEmpty
        ? '학번을 입력해주세요.'
        : null;

    state = state.copyWith(
      nameError: () => nameErr,
      departmentError: () => deptErr,
      studentIdError: () => idErr,
    );

    if (nameErr != null || deptErr != null || idErr != null) return false;

    state = state.copyWith(isLoading: true);
    try {
      await _repository.verifyStudent(
        name: name.trim(),
        department: department.trim(),
        studentId: studentId.trim(),
      );
      // 인증 성공 → TokenStorage(secure storage)에 저장된 토큰 기준으로 세션 상태 갱신
      await _ref.read(authSessionProvider.notifier).login();
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        studentIdError: () => e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository: repository, ref: ref);
});