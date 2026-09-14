// lib/features/academic_calendar/screens/academic_calendar_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:university_portal_flutter/core/theme/app_colors.dart';
import 'package:university_portal_flutter/core/theme/app_spacing.dart';
import 'package:university_portal_flutter/core/theme/app_text_styles.dart';
import '../providers/academic_calendar_provider.dart';
import '../../../data/models/academic_event.dart';

class AcademicCalendarScreen extends ConsumerWidget {
  const AcademicCalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(academicCalendarProvider);

    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        title: const Text('학사일정', style: AppTextStyles.heading2),
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
                  itemCount: state.events.length,
                  itemBuilder: (context, index) {
                    return _CalendarEventCard(event: state.events[index]);
                  },
                ),
    );
  }
}

class _CalendarEventCard extends StatelessWidget {
  final AcademicEvent event;
  const _CalendarEventCard({required this.event});

  static const _categoryLabels = {
    'ACADEMIC': '학사',
    'EXAM': '시험',
    'REGISTRATION': '수강신청',
    'VACATION': '방학',
    'EVENT': '행사',
    'ETC': '기타',
  };

  Color _getCategoryColor() {
    switch (event.category) {
      case 'ACADEMIC':     return Colors.blue;
      case 'EXAM':         return Colors.red;
      case 'REGISTRATION': return Colors.green;
      case 'VACATION':     return Colors.orange;
      case 'EVENT':        return Colors.purple;
      default:             return Colors.grey;
    }
  }

  String _formatDate(DateTime date) => DateFormat('MM.dd(E)', 'ko_KR').format(date);

  @override
  Widget build(BuildContext context) {
    final dateText = event.endDate == null
        ? _formatDate(event.startDate)
        : '${_formatDate(event.startDate)} ~ ${_formatDate(event.endDate!)}';

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: _getCategoryColor(),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.title, style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(dateText, style: AppTextStyles.caption.copyWith(color: context.textSecondary)),
                ],
              ),
            ),
            _CategoryBadge(
              category: _categoryLabels[event.category] ?? event.category,
              color: _getCategoryColor(),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final String category;
  final Color color;
  const _CategoryBadge({required this.category, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Text(
        category,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
