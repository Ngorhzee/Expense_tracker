import 'package:expense_traker/features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/transactions/models/transaction.dart';
import '../../features/transactions/screens/all_transactions_screen.dart';
import '../../features/transactions/screens/transaction_detail_screen.dart';
import '../../features/transactions/screens/add_transaction_screen.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: HomeScreen.routeName,
      builder: (context, state) => const HomeScreen(),
    ),

    GoRoute(
      path: '/all-transactions',
      name: AllTransactionsScreen.routeName,
      builder: (context, state) => const AllTransactionsScreen(),
    ),
    GoRoute(
      path: '/transaction/:id',
      name: TransactionDetailScreen.routeName,
      builder: (context, state) {
        final transaction = state.extra as Transaction;
        return TransactionDetailScreen(transaction: transaction);
      },
    ),
    GoRoute(
      path: '/add',
      name: AddTransactionScreen.routeName,
      builder: (context, state) => const AddTransactionScreen(),
    ),
  ],
);