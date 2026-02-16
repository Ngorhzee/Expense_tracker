import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/helpers.dart';
import '../models/transaction.dart';

class TransactionDetailScreen extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetailScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final categoryColor = getCategoryColor(transaction.category!);
    final statusColor = getStatusColor(transaction.status);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ──
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_left, size: 24),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.surfaceVariant,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Transaction Details',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  const SizedBox(width: 48), // balance
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Amount Hero ──
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: categoryColor.withValues( alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                getCategoryIcon(transaction.category!),
                color: categoryColor,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              transaction.merchant,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
            transaction.category!.label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textTertiary,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              '-${formatCurrency(transaction.displayAmount)}',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 40,
                    letterSpacing: -1,
                    color: AppColors.textPrimary,
                  ),
            ),

            const SizedBox(height: 32),

            // ── Details Card ──
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Drag handle
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.cardBorder,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      Text(
                        'Details',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                      ),
                      const SizedBox(height: 20),

                      _DetailRow(
                        icon: Icons.calendar_month_outlined,
                        label: 'Date',
                        value: formatDate(transaction.date),
                      ),
                      const _DetailDivider(),
                      _DetailRow(
                        icon: Icons.info_outline,
                        label: 'Status',
                        value: transaction.status.label,
                        valueColor: statusColor,
                      ),
                      const _DetailDivider(),
                      _DetailRow(
                        icon: Icons.category,
                        label: 'Category',
                        value: transaction.category!.label,
                        valueColor: categoryColor,
                      ),
                      const _DetailDivider(),
                      _DetailRow(
                        icon: Icons.receipt,
                        label: 'Transaction ID',
                        value: '#TXN-${transaction.id.padLeft(6, '0')}',
                      ),
                      const _DetailDivider(),
                      _DetailRow(
                        icon: Icons.money,
                        label: 'Amount',
                        value: formatCurrency(transaction.displayAmount),
                      ),

                      if (transaction.note != null) ...[
                        const _DetailDivider(),
                        _DetailRow(
                          icon: Icons.note,
                          label: 'Note',
                          value: transaction.note!,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textTertiary,
                  ),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? AppColors.textPrimary,
                  fontSize: 14,
                ),
          ),
        ],
      ),
    );
  }
}

class _DetailDivider extends StatelessWidget {
  const _DetailDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, color: AppColors.cardBorder);
  }
}