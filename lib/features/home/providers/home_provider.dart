// lib/features/home/providers/home_provider.dart
// 역할: 메인 화면 공지사항 탭 선택 상태 관리.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/notice_item.dart';
import '../../../data/repositories/notice_repository.dart';
import '../../../shared/providers/app_providers.dart';

class HomeState {
  final int selectedTabIndex; // 0=학사, 1=학과공지, 2=행사, 3=장학금, 4=취업
  final List<NoticeItem> notices;
  final bool isLoading;
  final String? errorMessage;

  const HomeState({
    this.selectedTabIndex = 0,
    this.notices = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  HomeState copyWith({
    int? selectedTabIndex,
    List<NoticeItem>? notices,
    bool? isLoading,
    String? errorMessage,
  }) =>
      HomeState(
        selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
        notices: notices ?? this.notices,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage,
      );
}

class HomeNotifier extends StateNotifier<HomeState> {
  final NoticeRepository _noticeRepository;

  HomeNotifier(this._noticeRepository) : super(const HomeState()) {
    fetchNotices();
  }

  void selectTab(int index) => state = state.copyWith(selectedTabIndex: index);

  Future<void> fetchNotices() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final notices = await _noticeRepository.getNotices();
      state = state.copyWith(notices: notices, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: '공지사항을 불러오지 못했습니다.');
    }
  }
}

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>(
  (ref) {
    final repository = ref.watch(noticeRepositoryProvider);
    return HomeNotifier(repository);
  },
);
