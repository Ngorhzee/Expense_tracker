import 'package:flutter/foundation.dart';

enum TransactionCategory {
  groceries('Groceries'),
  transportation('Transportation'),
  dining('Dining'),
  entertainment('Entertainment'),
  healthcare('Healthcare'),
  shopping('Shopping'),
  utilities('Utilities');

  final String label;
  const TransactionCategory(this.label);

  /// Convert string to enum safely.
  static TransactionCategory fromString(String value) {
    return TransactionCategory.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => TransactionCategory.groceries,
    );
  }
}

enum TransactionStatus {
  completed('Completed'),
  pending('Pending'),
  failed('Failed');

  final String label;
  const TransactionStatus(this.label);

  static TransactionStatus fromString(String value) {
    return TransactionStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => TransactionStatus.completed,
    );
  }
}

@immutable
class Transaction {
  final String id;
  final double amount;
  final String merchant;
  final TransactionCategory? category;
  final DateTime date;
  final TransactionStatus status;
  final String? note;

  const Transaction({
    required this.id,
    required this.amount,
    required this.merchant,
    required this.category,
    required this.date,
    required this.status,
    this.note,
  });

  
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      amount: (json['amount']).toDouble(),
      merchant: json['merchant'] ,
      category: TransactionCategory.fromString(json['category']),
      date: DateTime.parse(json['date']),
      status: TransactionStatus.fromString(json['status']),
      note: json['note'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'merchant': merchant,
      'category': category?.name ?? 'unknown',
      'date': date.toIso8601String().split('T').first,
      'status': status.name,
      if (note != null) 'note': note,
    };
  }

  Transaction copyWith({
    String? id,
    double? amount,
    String? merchant,
    TransactionCategory? category,
    DateTime? date,
    TransactionStatus? status,
    String? note,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      merchant: merchant ?? this.merchant,
      category: category ?? this.category,
      date: date ?? this.date,
      status: status ?? this.status,
      note: note ?? this.note,
    );
  }

  /// Returns true if amount is negative (expense)
  bool get isExpense => amount < 0;

  /// Returns the absolute value of the amount for display
  double get displayAmount => amount.abs();

  @override
  String toString() =>
      'Transaction(id: $id, merchant: $merchant, amount: $amount)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Transaction &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}