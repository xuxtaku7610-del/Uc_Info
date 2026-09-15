// lib/features/academic_calendar/providers/academic_calendar_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/academic_event.dart';
import '../../../data/repositories/academic_calendar_repository.dart';
import '../../../shared/providers/app_providers.dart';

class AcademicCalendarState {
  final List<AcademicEvent> events;
  final bool isLoading;
  final String? errorMessage;

  const AcademicCalendarState({
    this.events = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  AcademicCalendarState copyWith({
    List<AcademicEvent>? events,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AcademicCalendarState(
      events: events ?? this.events,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class AcademicCalendarNotifier extends StateNotifier<AcademicCalendarState> {
  final AcademicCalendarRepository _repository;

  AcademicCalendarNotifier(this._repository) : super(const AcademicCalendarState()) {
    fetchCalendar();
  }

  Future<void> fetchCalendar() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final events = await _repository.getCalendar();
      // 날짜순 정렬
      events.sort((a, b) => a.startDate.compareTo(b.startDate));
      state = state.copyWith(events: events, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '학사일정을 불러오지 못했습니다.',
      );
    }
  }
}

final academicCalendarProvider =
    StateNotifierProvider.autoDispose<AcademicCalendarNotifier, AcademicCalendarState>((ref) {
  final repository = ref.watch(academicCalendarRepositoryProvider);
  return AcademicCalendarNotifier(repository);
});
