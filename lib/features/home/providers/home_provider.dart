// lib/features/home/providers/home_provider.dart
// 역할: 메인 화면 공지사항 탭 선택 상태 관리.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/notice_item.dart';
import '../../../data/repositories/notice_repository.dart';
import '../../../data/repositories/api_notice_repository.dart';

class HomeState {
  final int selectedTabIndex; // 0=공지사항, 1=학과소식, 2=학과공지, 3=장학·취업
  final List<NoticeItem> notices;
  final bool isLoading;

  const HomeState({
    this.selectedTabIndex = 0,
    this.notices = const [],
    this.isLoading = false,
  });

  HomeState copyWith({
    int? selectedTabIndex,
    List<NoticeItem>? notices,
    bool? isLoading,
  }) =>
      HomeState(
        selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
        notices: notices ?? this.notices,
        isLoading: isLoading ?? this.isLoading,
      );
}

class HomeNotifier extends StateNotifier<HomeState> {
  final NoticeRepository _noticeRepository;

  HomeNotifier(this._noticeRepository) : super(const HomeState()) {
    fetchNotices();
  }

  void selectTab(int index) => state = state.copyWith(selectedTabIndex: index);

  Future<void> fetchNotices() async {
    state = state.copyWith(isLoading: true);
    try {
      final notices = await _noticeRepository.getNotices();
      state = state.copyWith(notices: notices, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      // 에러 처리는 필요에 따라 추가
    }
  }
}

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>(
  (ref) => HomeNotifier(ApiNoticeRepository()),
);
