import 'package:expense_traker/features/transactions/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/helpers.dart';


class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onTap;

  const TransactionTile({
    super.key,
    required this.transaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final categoryColor = getCategoryColor(transaction.category!);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:  EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.cardBorder, width: 1.w),
        ),
        child: Row(
          children: [
            // Category icon
            Container(
              width: 46.w,
              height: 46.w,
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha:  0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                getCategoryIcon(transaction.category!),
                color: categoryColor,
                size: 22.sp,
              ),
            ),
             SizedBox(width: 14.w),

            // Merchant, category & date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.merchant,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Text(
                        transaction.category!.label,
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textTertiary,
                                  fontSize: 12.sp,
                                ),
                      ),
                      SizedBox(width: 6.w),
                      Container(
                        width: 3.w,
                        height: 3.w,
                        decoration: const BoxDecoration(
                          color: AppColors.textTertiary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        formatDateRelative(transaction.date),
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textTertiary,
                                  fontSize: 12.sp,
                                ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Amount & status
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '-${formatCurrency(transaction.displayAmount)}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                ),
                 SizedBox(height: 3.h),
                _StatusBadge(status: transaction.status),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final TransactionStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = getStatusColor(status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        status.label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}