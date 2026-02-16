import 'dart:convert';
import 'package:expense_traker/features/transactions/providers/mock_data.dart';

import '../models/transaction.dart';


class TransactionApiService {
  /// GET /transactions — fetch all transactions.
  /// Simulates network latency with a 600ms delay.
  Future<List<Transaction>> fetchTransactions() async {
    // Simulate network round-trip
    await Future.delayed(const Duration(milliseconds: 600));

    try {
      final Map<String, dynamic> decoded = jsonDecode(mockTransactionJson);
      final List<dynamic> rawList = decoded['transactions'] as List<dynamic>;

      return rawList
          .map((json) => Transaction.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to parse transactions: $e');
    }
  }

  /// POST /transactions — add a new transaction.
  /// Accepts a [Transaction], serializes it to JSON, and returns it
  /// as if the server echoed the created resource back.
  Future<Transaction> createTransaction(Transaction transaction) async {
    // Simulate network round-trip
    await Future.delayed(const Duration(milliseconds: 400));

    try {
      // Serialize → JSON string → deserialize (round-trip validation)
      final jsonMap = transaction.toJson();
      final jsonString = jsonEncode(jsonMap);
      final decoded = jsonDecode(jsonString) as Map<String, dynamic>;

      return Transaction.fromJson(decoded);
    } catch (e) {
      throw Exception('Failed to create transaction: $e');
    }
  }
}