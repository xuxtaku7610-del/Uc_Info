// lib/features/scholarship/screens/scholarship_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:university_portal_flutter/core/theme/app_colors.dart';
import 'package:university_portal_flutter/core/theme/app_spacing.dart';
import 'package:university_portal_flutter/core/theme/app_text_styles.dart';
import 'package:university_portal_flutter/shared/utils/debounced_navigation.dart';
import 'package:university_portal_flutter/shared/widgets/empty_state.dart';
import '../providers/scholarship_provider.dart';
import '../../../data/models/scholarship.dart';

class ScholarshipListScreen extends ConsumerWidget {
  const ScholarshipListScreen({super.key});

  static const _types = [
    {'label': '전체', 'value': null},
    {'label': '지역', 'value': 'REGIONAL'},
    {'label': '성적', 'value': 'GRADE'},
    {'label': '교내', 'value': 'INTERNAL'},
    {'label': '교외', 'value': 'EXTERNAL'},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scholarshipListProvider);

    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        title: const Text('장학금 안내', style: AppTextStyles.heading2),
        backgroundColor: context.surface,
        elevation: 0,
        foregroundColor: context.textPrimary,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 필터 탭
          _buildFilterTabs(context, ref, state.selectedType),
          
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.errorMessage != null
                    ? Center(child: Text(state.errorMessage!))
                    : state.scholarships.isEmpty
                        ? const EmptyStateWidget(
                            message: '해당 조건의 장학금이 없습니다.',
                            icon: Icons.card_membership_outlined,
                          )
                        : RefreshIndicator(
                            onRefresh: () => ref.read(scholarshipListProvider.notifier).fetchScholarships(),
                            child: ListView.builder(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          itemCount: state.scholarships.length,
                          itemBuilder: (context, index) {
                            return _ScholarshipCard(scholarship: state.scholarships[index]);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs(BuildContext context, WidgetRef ref, String? selectedType) {
    return Container(
      color: context.surface,
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        itemCount: _types.length,
        itemBuilder: (context, i) {
          final type = _types[i];
          final isSelected = selectedType == type['value'];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(type['label'] as String),
              selected: isSelected,
              onSelected: (_) => ref.read(scholarshipListProvider.notifier).selectType(type['value'] as String?),
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
}

class _ScholarshipCard extends StatelessWidget {
  final Scholarship scholarship;
  const _ScholarshipCard({required this.scholarship});

  @override
  Widget build(BuildContext context) {
    final dDay = scholarship.dDay;
    final isExpired = dDay < 0;

    return Card(
      color: context.surface,
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
      child: InkWell(
        onTap: () => context.pushOnce('/scholarship/${scholarship.id}'),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '[${scholarship.type}]',
                      style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(scholarship.title, style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isExpired ? context.divider : AppColors.accent,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
                child: Text(
                  isExpired ? '마감' : 'D-$dDay',
                  style: AppTextStyles.label.copyWith(
                    color: isExpired ? context.textHint : context.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
