// lib/features/timetable/screens/timetable_sheet.dart
// 역할: 주간 시간표 Bottom Sheet. 월~금 그리드에 과목별 색상 블록 표시. 탭으로 90%까지 확장 가능.

import 'package:flutter/material.dart';
import 'package:university_portal_flutter/core/theme/app_colors.dart';
import 'package:university_portal_flutter/core/theme/app_spacing.dart';
import 'package:university_portal_flutter/core/theme/app_text_styles.dart';
import 'package:university_portal_flutter/data/mock/mock_data.dart';
import 'package:university_portal_flutter/data/models/schedule_item.dart';
import 'package:university_portal_flutter/shared/widgets/common_widgets.dart';

class TimetableSheet extends StatelessWidget {
  const TimetableSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // 드래그 핸들
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Center(child: AppDragHandle()),
            ),

            // 헤더
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                children: [
                  Text('주간 시간표', style: AppTextStyles.heading2),
                  const Spacer(),
                  Text('2026학년도 1학기', style: AppTextStyles.caption),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // 요일 헤더
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                children: [
                  const SizedBox(width: _TimetableGrid.timeColWidth),
                  ...['월', '화', '수', '목', '금'].map(
                    (d) => Expanded(
                      child: Center(
                        child: Text(
                          d,
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 8, color: AppColors.divider),

            // 그리드 본문
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: 4),
                child: _TimetableGrid(schedule: mockSchedule),
              ),
            ),
          ],
        );
      },
    );
  }
}

// 과목 블록 탭 시 상세 다이얼로그 표시
void _showCourseDialog(BuildContext context, ScheduleItem item) {
  final timeText = '${item.day}요일  ${item.startHour}:00 ~ ${item.endHour}:00';

  showDialog<void>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(item.subject, style: AppTextStyles.heading2),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _DialogRow(label: '강의실', value: item.room),
          _DialogRow(label: '교수명', value: item.professor),
          _DialogRow(label: '시간',   value: timeText),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('닫기'),
        ),
      ],
    ),
  );
}

class _TimetableGrid extends StatelessWidget {
  final List<ScheduleItem> schedule;

  const _TimetableGrid({required this.schedule});

  static const timeColWidth = 44.0;
  static const cellHeight = 54.0;
  static const startHour = 9;
  static const endHour = 18;
  static const days = ['월', '화', '수', '목', '금'];

  @override
  Widget build(BuildContext context) {
    final totalHours = endHour - startHour;

    return LayoutBuilder(
      builder: (context, constraints) {
        final colWidth = (constraints.maxWidth - timeColWidth) / 5;

        return SizedBox(
          height: totalHours * cellHeight,
          child: Stack(
            children: [
              // 시간 눈금 + 수평선
              ...List.generate(totalHours, (i) {
                final hour = startHour + i;
                return Positioned(
                  top: i * cellHeight,
                  left: 0,
                  right: 0,
                  height: cellHeight,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: timeColWidth,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 6, top: 2),
                          child: Text(
                            '$hour:00',
                            textAlign: TextAlign.right,
                            style: AppTextStyles.caption
                                .copyWith(fontSize: 10),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: AppColors.divider,
                                width: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              // 수업 블록
              ...schedule.map((item) {
                final dayIndex = days.indexOf(item.day);
                if (dayIndex == -1) return const SizedBox.shrink();

                final colorIndex =
                    item.color % AppColors.timetableColors.length;
                final top = (item.startHour - startHour) * cellHeight;
                final height =
                    (item.endHour - item.startHour) * cellHeight - 3;
                final left = timeColWidth + dayIndex * colWidth + 2;

                return Positioned(
                  top: top,
                  left: left,
                  width: colWidth - 4,
                  height: height,
                  child: GestureDetector(
                    onTap: () => _showCourseDialog(context, item),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.timetableColors[colorIndex],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.subject,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (height > 70)
                            Text(
                              item.room,
                              style: const TextStyle(
                                fontSize: 9,
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

// 다이얼로그 내 레이블-값 한 행
class _DialogRow extends StatelessWidget {
  final String label;
  final String value;

  const _DialogRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 52,
            child: Text(
              label,
              style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(value, style: AppTextStyles.body2),
          ),
        ],
      ),
    );
  }
}
