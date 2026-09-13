import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/user.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../shared/providers/app_providers.dart';

class UserState {
  final User? user;
  final bool isLoading;

  const UserState({this.user, this.isLoading = false});

  UserState copyWith({User? user, bool? isLoading}) {
    return UserState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class UserNotifier extends StateNotifier<UserState> {
  final AuthRepository _repository;

  UserNotifier(this._repository) : super(const UserState()) {
    fetchMe();
  }

  Future<void> fetchMe() async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await _repository.getMe();
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return UserNotifier(repository);
});
