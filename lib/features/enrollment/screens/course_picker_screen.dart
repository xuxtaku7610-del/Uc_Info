// lib/features/enrollment/screens/course_picker_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:university_portal_flutter/core/theme/app_colors.dart';
import 'package:university_portal_flutter/core/theme/app_spacing.dart';
import 'package:university_portal_flutter/core/theme/app_text_styles.dart';
import 'package:university_portal_flutter/shared/widgets/empty_state.dart';
import '../providers/course_picker_provider.dart';
import '../../../data/models/course_offering.dart';

class CoursePickerScreen extends ConsumerWidget {
  const CoursePickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(coursePickerProvider);
    
    final filteredCourses = state.selectedYearFilter == null
        ? state.courses
        : state.courses.where((c) => c.targetYear == state.selectedYearFilter).toList();

    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        title: const Text('수강 신청', style: AppTextStyles.heading2),
        backgroundColor: context.surface,
        elevation: 0,
        foregroundColor: context.textPrimary,
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildYearTabs(context, ref, state.selectedYearFilter),
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.errorMessage != null
                    ? Center(child: Text(state.errorMessage!))
                    : filteredCourses.isEmpty
                        ? const EmptyStateWidget(
                            message: '수강 신청 가능한 과목이 없습니다.',
                            icon: Icons.list_alt_outlined,
                          )
                        : RefreshIndicator(
                            onRefresh: () => ref.read(coursePickerProvider.notifier).fetchAvailableCourses(),
                            child: ListView.builder(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              itemCount: filteredCourses.length,
                              itemBuilder: (context, index) {
                                final course = filteredCourses[index];
                                final isSelected = state.selectedCourseIds.contains(course.id);
                                return _CourseListItem(
                                  course: course,
                                  isSelected: isSelected,
                                  onChanged: (_) => ref.read(coursePickerProvider.notifier).toggleSelection(course.id),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context, ref, state),
    );
  }

  Widget _buildYearTabs(BuildContext context, WidgetRef ref, int? selectedYear) {
    final tabs = [
      {'label': '전체', 'value': null},
      {'label': '1학년', 'value': 1},
      {'label': '2학년', 'value': 2},
      {'label': '3학년', 'value': 3},
      {'label': '4학년', 'value': 4},
    ];

    return Container(
      color: context.surface,
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        itemCount: tabs.length,
        itemBuilder: (context, i) {
          final tab = tabs[i];
          final isSelected = selectedYear == tab['value'];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(tab['label'] as String),
              selected: isSelected,
              onSelected: (_) => ref.read(coursePickerProvider.notifier).setYearFilter(tab['value'] as int?),
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : context.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, WidgetRef ref, CoursePickerState state) {
    if (state.courses.isEmpty || state.isLoading) return const SizedBox.shrink();

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: context.surface,
          border: Border(top: BorderSide(color: context.divider)),
        ),
        child: ElevatedButton(
          onPressed: state.selectedCourseIds.isEmpty || state.isSubmitting
              ? null
              : () async {
                  final result = await ref.read(coursePickerProvider.notifier).submitEnrollments();
                  if (context.mounted) {
                    final s = result['success'] as int;
                    final f = result['fail'] as int;
                    final lastError = result['lastError'] as String?;
                    final message = f == 0
                        ? '신청 완료: $s개 성공'
                        : '신청 완료: $s개 성공, $f개 실패${lastError != null ? '\n($lastError)' : ''}';
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(message)),
                    );
                    if (f == 0) Navigator.pop(context);
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
          ),
          child: state.isSubmitting
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Text('${state.selectedCourseIds.length}과목 신청하기', style: AppTextStyles.buttonText),
        ),
      ),
    );
  }
}

class _CourseListItem extends StatelessWidget {
  final CourseOffering course;
  final bool isSelected;
  final ValueChanged<bool?> onChanged;

  const _CourseListItem({required this.course, required this.isSelected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.surface,
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        side: isSelected ? const BorderSide(color: AppColors.primary, width: 2) : BorderSide.none,
      ),
      child: CheckboxListTile(
        value: isSelected,
        onChanged: onChanged,
        activeColor: AppColors.primary,
        title: Text(course.subject, style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold)),
        subtitle: Text(
          '${course.department} | ${course.day} ${course.startHour}:00~${course.endHour}:00 | ${course.professor} | ${course.room}',
          style: AppTextStyles.caption,
        ),
      ),
    );
  }
}
