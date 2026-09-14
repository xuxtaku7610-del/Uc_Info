// lib/features/enrollment/screens/course_picker_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:university_portal_flutter/core/theme/app_colors.dart';
import 'package:university_portal_flutter/core/theme/app_spacing.dart';
import 'package:university_portal_flutter/core/theme/app_text_styles.dart';
import '../providers/course_picker_provider.dart';
import '../../../data/models/course_offering.dart';

class CoursePickerScreen extends ConsumerWidget {
  const CoursePickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(coursePickerProvider);

    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        title: const Text('수강 신청', style: AppTextStyles.heading2),
        backgroundColor: context.surface,
        elevation: 0,
        foregroundColor: context.textPrimary,
        centerTitle: true,
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.errorMessage != null
              ? Center(child: Text(state.errorMessage!))
              : ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: state.courses.length,
                  itemBuilder: (context, index) {
                    final course = state.courses[index];
                    final isSelected = state.selectedCourseIds.contains(course.id);
                    return _CourseListItem(
                      course: course,
                      isSelected: isSelected,
                      onChanged: (_) => ref.read(coursePickerProvider.notifier).toggleSelection(course.id),
                    );
                  },
                ),
      bottomNavigationBar: _buildBottomBar(context, ref, state),
    );
  }

  Widget _buildBottomBar(BuildContext context, WidgetRef ref, CoursePickerState state) {
    if (state.courses.isEmpty || state.isLoading) return const SizedBox.shrink();

    return Container(
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
          '${course.day} ${course.startHour}:00~${course.endHour}:00 | ${course.professor} | ${course.room}',
          style: AppTextStyles.caption,
        ),
      ),
    );
  }
}
