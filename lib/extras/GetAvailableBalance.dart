import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notegoexpense/model/transaction_model.dart';
import 'package:notegoexpense/model/transaction_notifier.dart';

double calculateAccountBalance(WidgetRef ref, String accountName) {
  final transactionsAsync = ref.read(transactionsProvider);

  final transactions = transactionsAsync.maybeWhen(
    data: (data) => data,
    orElse: () => [],
  );

  double balance = 0.0;

  for (final txn in transactions) {
    if (txn.account != accountName) continue;

    if (txn.category.startsWith("Opening Balance")) {
      balance += txn.amount;
    } else if (txn.type == TransactionType.expense) {
      balance -= txn.amount;
    } else if (txn.type == TransactionType.income) {
      balance += txn.amount;
    }
  }

  return balance;
}
