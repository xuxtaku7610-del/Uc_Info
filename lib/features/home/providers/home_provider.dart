// lib/features/home/providers/home_provider.dart
// 역할: 메인 화면 공지사항 탭 선택 상태 관리.

import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeState {
  final int selectedTabIndex; // 0=공지사항, 1=학과소식, 2=학과공지, 3=장학·취업

  const HomeState({this.selectedTabIndex = 0});

  HomeState copyWith({int? selectedTabIndex}) =>
      HomeState(selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex);
}

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(const HomeState());

  void selectTab(int index) => state = state.copyWith(selectedTabIndex: index);
}

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>(
  (ref) => HomeNotifier(),
);
