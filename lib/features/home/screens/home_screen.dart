import 'package:expense_traker/features/transactions/providers/transaction_provider.dart';
import 'package:expense_traker/features/home/widgets/spending_summary_card.dart';
import 'package:expense_traker/features/transactions/screens/add_transaction_screen.dart';
import 'package:expense_traker/features/transactions/screens/transaction_detail_screen.dart';
import 'package:expense_traker/features/transactions/screens/all_transactions_screen.dart';
import 'package:expense_traker/features/transactions/widgets/transaction_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';


/// Maximum number of transactions shown on the home screen.
const _maxRecentTransactions = 10;

class HomeScreen extends ConsumerWidget {
  static const routeName = 'home';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTransactions = ref.watch(transactionProvider);
    final allTransactions = ref.watch(transactionListProvider);

    // Show only the most recent transactions (capped).
    final recentTransactions = allTransactions.length > _maxRecentTransactions
        ? allTransactions.sublist(0, _maxRecentTransactions)
        : allTransactions;

    final hasMore = allTransactions.length > _maxRecentTransactions;

    return Scaffold(
      body: SafeArea(
        child: asyncTransactions.when(
          
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.accent),
          ),

          error: (error, _) => Center(
            child: Padding(
              padding:  EdgeInsets.all(32.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning,
                    size: 48.sp,
                    color: AppColors.error.withValues(alpha:  0.7),
                  ),
                   SizedBox(height: 16.h),
                  Text(
                    'Something went wrong',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                   SizedBox(height: 8.h),
                  Text(
                    error.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.textTertiary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () =>
                        ref.read(transactionProvider.notifier).refresh(),
                    icon:  Icon(Icons.refresh, size: 18.sp),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),

      
          data: (_) => RefreshIndicator(
            color: AppColors.accent,
            onRefresh: () =>
                ref.read(transactionProvider.notifier).refresh(),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                
                SliverToBoxAdapter(
                  child: Padding(
                    padding:  EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Expenses',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(fontSize: 28.sp),
                            ),
                             SizedBox(height: 2.h),
                            Text(
                              'Track your spending',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: AppColors.textTertiary),
                            ),
                          ],
                        ),
                        Container(
                          width: 44.w,
                          height: 44.w,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child:  Icon(
                            Icons.notifications,
                            color: AppColors.textSecondary,
                            size: 22.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

               
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: SpendingSummaryCard(),
                  ),
                ),

               
                SliverToBoxAdapter(
                  child: Padding(
                    padding:  EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 12.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Transactions',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontSize: 16.sp),
                        ),
                        if (hasMore)
                          GestureDetector(
                            onTap: () => context.pushNamed(AllTransactionsScreen.routeName),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'See All',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: AppColors.accent,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                 SizedBox(width: 4.w),
                                 Icon(
                                  Icons.arrow_right,
                                  size: 16.sp,
                                  color: AppColors.accent,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // ── Recent Transactions List ──
                recentTransactions.isEmpty
                    ? SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.receipt,
                                  size: 48,
                                  color:
                                      AppColors.textTertiary.withValues(alpha:  0.5),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'No transactions yet',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          color: AppColors.textTertiary),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Tap + to add your first expense',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          color: AppColors.textTertiary),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        sliver: SliverList.separated(
                          itemCount: recentTransactions.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final transaction = recentTransactions[index];
                            return TransactionTile(
                              transaction: transaction,
                              onTap: () => context.pushNamed(
                                TransactionDetailScreen.routeName,
                                pathParameters: {'id': transaction.id},
                                extra: transaction,
                              ),
                            );
                          },
                        ),
                      ),

                
                if (hasMore)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                      child: GestureDetector(
                        onTap: () => context.pushNamed('allTransactions'),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: AppColors.cardBorder, width: 1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'View All ${allTransactions.length} Transactions',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                              ),
                               SizedBox(width: 6.w),
                               Icon(
                                Icons.arrow_right,
                                size: 16.sp,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

               
                if (!hasMore)
                   SliverToBoxAdapter(
                    child: SizedBox(height: 100.h),
                  ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed(AddTransactionScreen.routeName),
        child:  Icon(Icons.add, size: 28.sp),
      ),
    );
  }
}