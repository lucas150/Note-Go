import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../model/transaction_model.dart';
import '../model/transaction_notifier.dart';

// Riverpod provider for managing accounts
final accountsProvider = AsyncNotifierProvider<AccountsNotifier, List<Account>>(
    AccountsNotifier.new);

class AccountsNotifier extends AsyncNotifier<List<Account>> {
  late Box<Account> _box;

// Initialize the hive box and load accounts
  @override
  Future<List<Account>> build() async {
    _box = await Hive.openBox<Account>('accounts');
    return _box.values.toList();
  }

// Add an account to the Hive box and update the state
  Future<void> addAccount(Account account) async {
    await _box.put(account.id, account);
    state = AsyncData([...state.value ?? [], account]);

    if (account.balance > 0) {
      final txBox = await Hive.openBox<TransactionModel>('transactions');
      final openingTx = TransactionModel(
        id: account.id,
        type: TransactionType.income,
        date: DateTime.now(),
        title: 'Opening Balance',
        amount: account.balance,
        account: account.name,
        category: 'Opening Balance',
        note: 'Auto-added on account creation',
      );
      await txBox.put(openingTx.id, openingTx);
    }
    ref.invalidate(transactionsProvider);
  }

// update an existing account in the Hive box and update the state
  Future<void> updateAccount(Account account) async {
    await _box.put(account.id, account);

    final txBox = await Hive.openBox<TransactionModel>('transactions');
    final existingTx = txBox.get(account.id);

    if (existingTx != null &&
        existingTx.title == 'Opening Balance' &&
        existingTx.category == 'Opening Balance') {
      final updatedTx = TransactionModel(
        id: existingTx.id,
        type: existingTx.type,
        date: DateTime.now(),
        title: existingTx.title,
        amount: account.balance,
        account: account.name,
        category: existingTx.category,
        note: existingTx.note,
      );

      await txBox.put(account.id, updatedTx); // 🔁 overwrite
    }

    // 2. Replace the updated account in the state list
    final updatedList = [
      for (final acc in state.value ?? [])
        if (acc.id == account.id) account else acc,
    ];

    state = AsyncData(updatedList.cast<Account>());
    ref.invalidate(transactionsProvider);
  }

// Delete an account from the Hive box and update the state
  Future<void> deleteAccount(String id) async {
    // 1. Delete the account from the box
    await _box.delete(id);

    // 2. Delete corresponding "Opening Balance" transaction, if exists
    final txBox = await Hive.openBox<TransactionModel>('transactions');
    final existingTx = txBox.get(id);

    if (existingTx != null &&
        existingTx.title == 'Opening Balance' &&
        existingTx.category == 'Opening Balance') {
      await txBox.delete(id);
    }

    // 3. Update state by removing the account
    final updatedList =
        (state.value ?? []).where((acc) => acc.id != id).toList();
    state = AsyncData(updatedList);
    ref.invalidate(transactionsProvider);
  }
}
