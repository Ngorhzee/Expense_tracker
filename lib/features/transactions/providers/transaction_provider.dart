import 'package:expense_traker/features/transactions/services/transaction_api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:uuid/uuid.dart';
import '../models/transaction.dart';

// API Service Provider

final transactionApiServiceProvider = Provider<TransactionApiService>(
  (ref) => TransactionApiService(),
);


class TransactionNotifier extends StateNotifier<AsyncValue<List<Transaction>>> {
  final TransactionApiService _apiService;

  TransactionNotifier(this._apiService) : super(const AsyncValue.loading()) {
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    try {
      state = const AsyncValue.loading();
      final transactions = await _apiService.fetchTransactions();
      state = AsyncValue.data(transactions);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // Add a new transaction via the API service.
 
  Future<void> addTransaction(Transaction transaction) async {
    try {
      final created = await _apiService.createTransaction(transaction);
      state.whenData((transactions) {
        state = AsyncValue.data([created, ...transactions]);
      });
    } catch (e, st) {
      
      state = AsyncValue.error(e, st);
    }
  }

  // Pull-to-refresh: re-fetches from the API.
  Future<void> refresh() async {
    try {
      final transactions = await _apiService.fetchTransactions();
      // Merge any locally added transactions (those not in mock data)
      final currentData = state.value??[];
      final mockIds = transactions.map((t) => t.id).toSet();
      final localOnly = currentData.where((t) => !mockIds.contains(t.id)).toList();
      state = AsyncValue.data([...localOnly, ...transactions]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final transactionProvider =
    StateNotifierProvider<TransactionNotifier, AsyncValue<List<Transaction>>>(
  (ref) {
    final apiService = ref.watch(transactionApiServiceProvider);
    return TransactionNotifier(apiService);
  },
);



final transactionListProvider = Provider<List<Transaction>>((ref) {
  return ref.watch(transactionProvider).value ?? [];
});

// Filter & Search State 


final selectedCategoryProvider =
    StateProvider<TransactionCategory?>((ref) => null);

/// Current search query string.
final searchQueryProvider = StateProvider<String>((ref) => '');



/// Filtered + searched transaction list.
final filteredTransactionsProvider = Provider<List<Transaction>>((ref) {
  final transactions = ref.watch(transactionListProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase().trim();

  return transactions.where((t) {
    final matchesCategory =
        selectedCategory == null || t.category == selectedCategory;
    final matchesSearch =
        searchQuery.isEmpty ||
        t.merchant.toLowerCase().contains(searchQuery);
    return matchesCategory && matchesSearch;
  }).toList();
});

/// Total spending (sum of all negative amounts).
final totalSpendingProvider = Provider<double>((ref) {
  final transactions = ref.watch(transactionListProvider);
  return transactions
      .where((t) => t.isExpense)
      .fold(0.0, (sum, t) => sum + t.displayAmount);
});


final categorySpendingProvider =
    Provider<Map<TransactionCategory, double>>((ref) {
  final transactions = ref.watch(transactionListProvider);
  final map = <TransactionCategory, double>{};
  for (final t in transactions) {
    map[t.category!] = (map[t.category] ?? 0) + t.displayAmount;
  }
  return map;
});

// UUID generator for new transactions.
const uuid = Uuid();