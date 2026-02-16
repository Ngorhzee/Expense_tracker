import 'package:expense_traker/features/transactions/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/helpers.dart';

class SpendingSummaryCard extends ConsumerWidget {
  const SpendingSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalSpending = ref.watch(totalSpendingProvider);
    final transactionCount = ref.watch(transactionProvider);

    return Container(
      width: 1.sw,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryLight],
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20.r,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Spending',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  '${transactionCount.value?.length ?? 0} transactions',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            formatCurrency(totalSpending),
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 36.sp,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 16),
          // Mini category breakdown bar
          _CategoryBar(ref: ref),
        ],
      ),
    );
  }
}

class _CategoryBar extends StatelessWidget {
  final WidgetRef ref;
  const _CategoryBar({required this.ref});

  @override
  Widget build(BuildContext context) {
    final categorySpending = ref.watch(categorySpendingProvider);
    final total = ref.watch(totalSpendingProvider);

    if (total == 0) return const SizedBox.shrink();

    final sorted =
        categorySpending.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            height: 6,
            child: Row(
              children:
                  sorted.map((entry) {
                    final fraction = entry.value / total;
                    return Expanded(
                      flex: (fraction * 1000).toInt(),
                      child: Container(color: getCategoryColor(entry.key)),
                    );
                  }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children:
              sorted.take(3).map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8.w,
                        height: 8.h,
                        decoration: BoxDecoration(
                          color: getCategoryColor(entry.key),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        entry.key.label,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}
