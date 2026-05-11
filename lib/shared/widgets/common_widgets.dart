// lib/shared/widgets/common_widgets.dart
// 역할: 앱 전반에서 반복 사용되는 공용 위젯·함수 모음.

import 'package:flutter/material.dart';
import 'package:university_portal_flutter/core/theme/app_colors.dart';
import 'package:university_portal_flutter/core/theme/app_spacing.dart';
// AppTextStyles는 이 파일에서 직접 사용하지 않으므로 import하지 않는다.

/// Bottom Sheet 상단 드래그 핸들.
/// settings_sheet, timetable_sheet, student_banner 등 모든 시트에서 공용으로 사용.
class AppDragHandle extends StatelessWidget {
  const AppDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

/// 앱 표준 카드 컨테이너. surface 배경 + radiusMd 모서리 + 미세 그림자.
/// quick_action_section, shortcut_grid, notice_section 등 카드형 레이아웃 공용.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? height;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// 위 모서리가 둥근 표준 Bottom Sheet 표시 함수.
/// [isScrollControlled]: DraggableScrollableSheet 등 전체 높이가 필요한 경우 true.
Future<T?> showAppBottomSheet<T>(
  BuildContext context,
  WidgetBuilder builder, {
  bool isScrollControlled = false,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSpacing.radiusLg),
      ),
    ),
    builder: builder,
  );
}
