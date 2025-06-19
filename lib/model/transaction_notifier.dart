import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../model/transaction_model.dart';

final transactionsProvider =
    AsyncNotifierProvider<TransactionsNotifier, List<TransactionModel>>(
  TransactionsNotifier.new,
);

class TransactionsNotifier extends AsyncNotifier<List<TransactionModel>> {
  late Box<TransactionModel> _box;

  @override
  Future<List<TransactionModel>> build() async {
    _box = await Hive.openBox<TransactionModel>('transactions');
    return _box.values.toList();
  }

  /// Adds a new transaction and updates state
  Future<void> addTransaction(TransactionModel transaction) async {
    await _box.put(transaction.id, transaction);
    state = AsyncData([...state.value ?? [], transaction]);
  }

  /// Edits an existing transaction (if not Opening Balance)
  Future<void> editTransaction(TransactionModel updatedTx) async {
    final existing = _box.get(updatedTx.id);

    if (existing != null &&
        existing.title == 'Opening Balance' &&
        existing.category == 'Opening Balance' &&
        existing.note == 'Auto-added on account creation') {
      throw Exception("Cannot edit Opening Balance transaction.");
    }

    await _box.put(updatedTx.id, updatedTx);

    final updatedList = [
      for (final tx in state.value ?? [])
        if (tx.id == updatedTx.id) updatedTx else tx,
    ].cast<TransactionModel>();
    state = AsyncData(updatedList);
  }

  /// Deletes a transaction (if not Opening Balance)
  Future<void> deleteTransaction(String id) async {
    final existing = _box.get(id);

    if (existing != null &&
        existing.title == 'Opening Balance' &&
        existing.category == 'Opening Balance' &&
        existing.note == 'Auto-added on account creation') {
      throw Exception("Cannot delete Opening Balance transaction.");
    }

    await _box.delete(id);

    final updatedList = (state.value ?? []).where((tx) => tx.id != id).toList();
    state = AsyncData(updatedList);
  }
}
