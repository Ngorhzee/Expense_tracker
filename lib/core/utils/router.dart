import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/transactions/models/transaction.dart';
import '../../features/transactions/screens/transaction_list_screen.dart';
import '../../features/transactions/screens/transaction_detail_screen.dart';
import '../../features/transactions/screens/add_transaction_screen.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'transactions',
      builder: (context, state) => const TransactionListScreen(),
    ),
    GoRoute(
      path: '/transaction/:id',
      name: 'transactionDetail',
      builder: (context, state) {
        final transaction = state.extra as Transaction;
        return TransactionDetailScreen(transaction: transaction);
      },
    ),
    GoRoute(
      path: '/add',
      name: 'addTransaction',
      builder: (context, state) => const AddTransactionScreen(),
    ),
  ],
);