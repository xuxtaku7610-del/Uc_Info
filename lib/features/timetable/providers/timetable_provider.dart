import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/schedule_item.dart';
import '../../../data/repositories/schedule_repository.dart';
import '../../../shared/providers/app_providers.dart';

class TimetableState {
  final List<ScheduleItem> schedule;
  final bool isLoading;
  final String? errorMessage;

  const TimetableState({
    this.schedule = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  TimetableState copyWith({
    List<ScheduleItem>? schedule,
    bool? isLoading,
    String? errorMessage,
  }) {
    return TimetableState(
      schedule: schedule ?? this.schedule,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class TimetableNotifier extends StateNotifier<TimetableState> {
  final ScheduleRepository _repository;

  TimetableNotifier(this._repository) : super(const TimetableState()) {
    fetchWeeklySchedule();
  }

  Future<void> fetchWeeklySchedule() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final schedule = await _repository.getWeeklySchedule();
      state = state.copyWith(schedule: schedule, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '시간표를 불러오지 못했습니다.',
      );
    }
  }
}

final timetableProvider =
    StateNotifierProvider.autoDispose<TimetableNotifier, TimetableState>((ref) {
  final repository = ref.watch(scheduleRepositoryProvider);
  return TimetableNotifier(repository);
});
