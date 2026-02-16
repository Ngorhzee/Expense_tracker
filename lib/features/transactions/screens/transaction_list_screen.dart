import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/transaction_provider.dart';
import '../widgets/spending_summary_card.dart';
import '../widgets/category_filter_chips.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/transaction_tile.dart';

class TransactionListScreen extends ConsumerWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTransactions = ref.watch(transactionProvider);
    final filteredTransactions = ref.watch(filteredTransactionsProvider);

    return Scaffold(
      body: SafeArea(
        child: asyncTransactions.when(
          // ── Loading State ──
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.accent),
          ),

          // ── Error State ──
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning,
                    size: 48,
                    color: AppColors.error.withValues(alpha: 0.7),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Something went wrong',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
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
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),

          // ── Data State ──
          data: (_) => RefreshIndicator(
            color: AppColors.accent,
            onRefresh: () =>
                ref.read(transactionProvider.notifier).refresh(),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                // ── Header ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
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
                                  ?.copyWith(fontSize: 28),
                            ),
                            const SizedBox(height: 2),
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
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.notifications,
                            color: AppColors.textSecondary,
                            size: 22,
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

                // ── Search ──
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: SearchBarWidget(),
                  ),
                ),

                // ── Category Filters ──
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 8),
                    child: CategoryFilterChips(),
                  ),
                ),

                // ── Section Title ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Transactions',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontSize: 16),
                        ),
                        Text(
                          '${filteredTransactions.length} items',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppColors.textTertiary),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Transaction List ──
                filteredTransactions.isEmpty
                    ? SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_rounded,
                                size: 48,
                                color:
                                    AppColors.textTertiary.withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No transactions found',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        color: AppColors.textTertiary),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                        sliver: SliverList.separated(
                          itemCount: filteredTransactions.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed('addTransaction'),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}