// lib/features/scholarship/providers/scholarship_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/scholarship.dart';
import '../../../data/repositories/scholarship_repository.dart';
import '../../../shared/providers/app_providers.dart';

class ScholarshipListState {
  final List<Scholarship> scholarships;
  final bool isLoading;
  final String? errorMessage;
  final String? selectedType; // null=전체

  const ScholarshipListState({
    this.scholarships = const [],
    this.isLoading = false,
    this.errorMessage,
    this.selectedType,
  });

  ScholarshipListState copyWith({
    List<Scholarship>? scholarships,
    bool? isLoading,
    String? errorMessage,
    String? Function()? selectedType,
  }) {
    return ScholarshipListState(
      scholarships: scholarships ?? this.scholarships,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      selectedType: selectedType != null ? selectedType() : this.selectedType,
    );
  }
}

class ScholarshipListNotifier extends StateNotifier<ScholarshipListState> {
  final ScholarshipRepository _repository;

  ScholarshipListNotifier(this._repository) : super(const ScholarshipListState()) {
    fetchScholarships();
  }

  Future<void> fetchScholarships() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final list = await _repository.getScholarships(type: state.selectedType);
      // 마감일 임박순 정렬
      list.sort((a, b) => a.deadline.compareTo(b.deadline));
      state = state.copyWith(scholarships: list, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  void selectType(String? type) {
    if (state.selectedType == type) return;
    state = state.copyWith(selectedType: () => type);
    fetchScholarships();
  }
}

final scholarshipListProvider =
    StateNotifierProvider.autoDispose<ScholarshipListNotifier, ScholarshipListState>((ref) {
  final repository = ref.watch(scholarshipRepositoryProvider);
  return ScholarshipListNotifier(repository);
});
