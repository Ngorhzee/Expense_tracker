import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../../features/transactions/models/transaction.dart';

//Currency Formatting 

final _currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

String formatCurrency(double amount) => _currencyFormat.format(amount);

//Date Formatting

String formatDate(DateTime date) => DateFormat('MMM d, yyyy').format(date);

String formatDateRelative(DateTime date) {
  final now = DateTime.now();
  final diff = now.difference(date);

  if (diff.inDays == 0) return 'Today';
  if (diff.inDays == 1) return 'Yesterday';
  if (diff.inDays < 7) return DateFormat('EEEE').format(date);
  return DateFormat('MMM d, yyyy').format(date);
}

// Category Helpers 

Color getCategoryColor(TransactionCategory category) {
  switch (category) {
    case TransactionCategory.groceries:
      return AppColors.groceries;
    case TransactionCategory.transportation:
      return AppColors.transportation;
    case TransactionCategory.dining:
      return AppColors.dining;
    case TransactionCategory.entertainment:
      return AppColors.entertainment;
    case TransactionCategory.healthcare:
      return AppColors.healthcare;
    case TransactionCategory.shopping:
      return AppColors.shopping;
    case TransactionCategory.utilities:
      return AppColors.utilities;
  }
}

IconData getCategoryIcon(TransactionCategory category) {
  switch (category) {
    case TransactionCategory.groceries:
      return Icons.shopping_bag;
    case TransactionCategory.transportation:
      return Icons.car_rental;
    case TransactionCategory.dining:
      return Icons.local_cafe;
    case TransactionCategory.entertainment:
      return Icons.movie;
    case TransactionCategory.healthcare:
      return Icons.local_hospital;
    case TransactionCategory.shopping:
      return Icons.shopping_cart;
    case TransactionCategory.utilities:
      return Icons.flash_on;
  }
}

// ─── Status Helpers ─────────────────────────────────────────────────────

Color getStatusColor(TransactionStatus status) {
  switch (status) {
    case TransactionStatus.completed:
      return AppColors.success;
    case TransactionStatus.pending:
      return AppColors.pending;
    case TransactionStatus.failed:
      return AppColors.error;
  }
}