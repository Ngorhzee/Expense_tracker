import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../providers/transaction_provider.dart';
import '../widgets/category_filter_chips.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/transaction_tile.dart';

class AllTransactionsScreen extends ConsumerWidget {
  static const routeName = 'allTransactions';
  const AllTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredTransactions = ref.watch(filteredTransactionsProvider);
    final totalCount = ref.watch(transactionListProvider).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
          
            Padding(
              padding: EdgeInsets.fromLTRB(8.w, 8.h, 20.w, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // Reset filters when leaving
                      ref.read(searchQueryProvider.notifier).state = '';
                      ref.read(selectedCategoryProvider.notifier).state = null;
                      context.pop();
                    },
                    icon:  Icon(Icons.keyboard_arrow_left_rounded, size: 24.sp),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.surfaceVariant,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'All Transactions',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  
                  Container(
                    padding:
                         EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$totalCount',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
            ),

             SizedBox(height: 16.h),

           
            const SearchBarWidget(),

             SizedBox(height: 12.h),

           
            const CategoryFilterChips(),

             SizedBox(height: 8.h),

          
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Results',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${filteredTransactions.length} of $totalCount',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.textTertiary),
                  ),
                ],
              ),
            ),

          
            Expanded(
              child: filteredTransactions.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_rounded,
                            size: 48,
                            color: AppColors.textTertiary.withValues(alpha:  0.5),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No transactions found',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppColors.textTertiary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Try a different search or filter',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppColors.textTertiary),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding:  EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 20.h),
                      physics: const BouncingScrollPhysics(),
                      itemCount: filteredTransactions.length,
                      separatorBuilder: (_, __) =>  SizedBox(height: 10.h),
                      itemBuilder: (context, index) {
                        final transaction = filteredTransactions[index];
                        return TransactionTile(
                          transaction: transaction,
                          onTap: () => context.pushNamed(
                            'transactionDetail',
                            pathParameters: {'id': transaction.id},
                            extra: transaction,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}