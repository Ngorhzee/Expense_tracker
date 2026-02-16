import 'package:expense_traker/features/transactions/models/transaction.dart';
import 'package:expense_traker/features/transactions/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/helpers.dart';

class CategoryFilterChips extends ConsumerWidget {
  const CategoryFilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return SizedBox(
      height: 36.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        children: [
          _FilterChip(
            label: 'All',
            isSelected: selectedCategory == null,
            color: AppColors.primary,
            onTap:
                () => ref.read(selectedCategoryProvider.notifier).state = null,
          ),
          SizedBox(width: 8.w),
          ...TransactionCategory.values.map((category) {
            return Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: _FilterChip(
                label: category.label,
                isSelected: selectedCategory == category,
                color: getCategoryColor(category),
                onTap:
                    () =>
                        ref.read(selectedCategoryProvider.notifier).state =
                            selectedCategory == category ? null : category,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? color : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? color : AppColors.cardBorder,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isSelected ? Colors.white : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
