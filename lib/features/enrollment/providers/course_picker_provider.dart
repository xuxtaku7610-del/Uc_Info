// lib/features/enrollment/providers/course_picker_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/course_offering.dart';
import '../../../data/repositories/course_repository.dart';
import '../../../data/repositories/enrollment_repository.dart';
import '../../../shared/providers/app_providers.dart';
import '../../timetable/providers/timetable_provider.dart';

class CoursePickerState {
  final List<CourseOffering> courses;
  final Set<int> selectedCourseIds;
  final bool isLoading;
  final bool isSubmitting;
  final String? errorMessage;

  const CoursePickerState({
    this.courses = const [],
    this.selectedCourseIds = const {},
    this.isLoading = false,
    this.isSubmitting = false,
    this.errorMessage,
  });

  CoursePickerState copyWith({
    List<CourseOffering>? courses,
    Set<int>? selectedCourseIds,
    bool? isLoading,
    bool? isSubmitting,
    String? errorMessage,
  }) {
    return CoursePickerState(
      courses: courses ?? this.courses,
      selectedCourseIds: selectedCourseIds ?? this.selectedCourseIds,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
    );
  }
}

class CoursePickerNotifier extends StateNotifier<CoursePickerState> {
  final CourseRepository _courseRepo;
  final EnrollmentRepository _enrollmentRepo;
  final Ref _ref;

  CoursePickerNotifier(this._courseRepo, this._enrollmentRepo, this._ref) : super(const CoursePickerState()) {
    fetchAvailableCourses();
  }

  Future<void> fetchAvailableCourses() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final list = await _courseRepo.getAvailableCourses();
      // 요일/교시 순 정렬
      final days = ['월', '화', '수', '목', '금'];
      list.sort((a, b) {
        final dayCompare = days.indexOf(a.day).compareTo(days.indexOf(b.day));
        if (dayCompare != 0) return dayCompare;
        return a.startHour.compareTo(b.startHour);
      });
      state = state.copyWith(courses: list, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: '개설과목을 불러오지 못했습니다.');
    }
  }

  void toggleSelection(int courseId) {
    final newSet = Set<int>.from(state.selectedCourseIds);
    if (newSet.contains(courseId)) {
      newSet.remove(courseId);
    } else {
      newSet.add(courseId);
    }
    state = state.copyWith(selectedCourseIds: newSet);
  }

  Future<Map<String, dynamic>> submitEnrollments() async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);
    int successCount = 0;
    int failCount = 0;
    String lastError = '';

    for (final id in state.selectedCourseIds) {
      try {
        await _enrollmentRepo.enroll(id);
        successCount++;
      } catch (e) {
        failCount++;
        lastError = e.toString().replaceFirst('Exception: ', '');
      }
    }

    state = state.copyWith(isSubmitting: false, selectedCourseIds: {});
    
    // 시간표 새로고침
    _ref.invalidate(timetableProvider);
    
    return {
      'success': successCount,
      'fail': failCount,
      'lastError': lastError.isEmpty ? null : lastError,
    };
  }
}

final coursePickerProvider = StateNotifierProvider.autoDispose<CoursePickerNotifier, CoursePickerState>((ref) {
  final courseRepo = ref.watch(courseRepositoryProvider);
  final enrollmentRepo = ref.watch(enrollmentRepositoryProvider);
  return CoursePickerNotifier(courseRepo, enrollmentRepo, ref);
});
