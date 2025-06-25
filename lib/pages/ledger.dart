import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:notegoexpense/model/transaction_notifier.dart';
import '../model/transaction_model.dart';
import '../widgets/calandar.dart';
import '../model/account_notifier.dart';

class LedgerPage extends ConsumerStatefulWidget {
  const LedgerPage({super.key});

  @override
  ConsumerState<LedgerPage> createState() => _LedgerPageState();
}

class _LedgerPageState extends ConsumerState<LedgerPage> {
  DateTimeRange? _selectedRange;
  String _selectedCategory = 'All';
  String _selectedAccount = 'All';
  // final _titleController = TextEditingController();
  // final _amountController = TextEditingController();
  // final _noteController = TextEditingController();

  void _deleteTransaction(TransactionModel tx) {
    final accountsNotifier = ref.read(accountsProvider.notifier);
    final accountAsync = ref.read(accountsProvider);

    final accounts = accountAsync.maybeWhen(
      data: (data) => data,
      orElse: () => [],
    );

    final account = accounts.firstWhere(
      (acc) => acc.name == tx.account,
      orElse: () => throw Exception('Account not found'),
    );

    double balance = account.balance;

    if (tx.type == TransactionType.income) {
      balance -= tx.amount ?? 0;
    } else {
      balance += tx.amount ?? 0;
    }

    final updatedAccount = account.copyWith(balance: balance);
    accountsNotifier.updateAccount(updatedAccount);

    ref.read(transactionsProvider.notifier).deleteTransaction(tx.id ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(transactionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Ledger'),
            DateRangeSelector(
              initialRange: _selectedRange,
              onRangeSelected: (range) {
                setState(() => _selectedRange = range);
              },
            ),
          ],
        ),
      ),
      body: transactionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (transactions) {
          List<TransactionModel> filtered = transactions;

          if (_selectedCategory != 'All') {
            filtered = filtered
                .where((tx) => tx.category == _selectedCategory)
                .toList();
          }

          if (_selectedAccount != 'All') {
            filtered =
                filtered.where((tx) => tx.account == _selectedAccount).toList();
          }

          if (_selectedRange != null) {
            filtered = filtered.where((tx) {
              final txDate = tx.date ?? DateTime.now();
              return txDate.isAfter(_selectedRange!.start
                      .subtract(const Duration(days: 1))) &&
                  txDate.isBefore(
                      _selectedRange!.end.add(const Duration(days: 1)));
            }).toList();
          }

          final incomeTotal = filtered
              .where((tx) => tx.type == TransactionType.income)
              .fold<double>(0, (sum, tx) => sum + (tx.amount ?? 0));
          final expenseTotal = filtered
              .where((tx) => tx.type == TransactionType.expense)
              .fold<double>(0, (sum, tx) => sum + (tx.amount ?? 0));
          final savingsTotal = filtered
              .where((tx) => tx.type == TransactionType.savings)
              .fold<double>(0, (sum, tx) => sum + (tx.amount ?? 0));
          final net = incomeTotal - expenseTotal;

          final categories = {
            'All',
            ...transactions.map((tx) => tx.category ?? '').toSet()
          };
          final accounts = {
            'All',
            ...transactions.map((tx) => tx.account ?? '').toSet()
          };

          final grouped = <String, List<TransactionModel>>{};
          for (final tx in filtered) {
            final date =
                DateFormat('yyyy-MM-dd').format(tx.date ?? DateTime.now());
            grouped.putIfAbsent(date, () => []).add(tx);
          }

          final sortedKeys = grouped.keys.toList()
            ..sort((a, b) => b.compareTo(a));

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Category",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey)),
                          DropdownButton<String>(
                            value: _selectedCategory,
                            isExpanded: true,
                            items: categories.map((cat) {
                              return DropdownMenuItem(
                                value: cat,
                                child: Text(cat.isEmpty ? 'Uncategorized' : cat,
                                    style: const TextStyle(fontSize: 14)),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _selectedCategory = value);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Account",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey)),
                          DropdownButton<String>(
                            value: _selectedAccount,
                            isExpanded: true,
                            items: accounts.map((acc) {
                              return DropdownMenuItem(
                                value: acc,
                                child: Text(acc.isEmpty ? 'Unnamed' : acc,
                                    style: const TextStyle(fontSize: 14)),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _selectedAccount = value);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSummaryTile('Income', incomeTotal, Colors.green),
                    _buildSummaryTile('Expense', expenseTotal, Colors.red),
                    _buildSummaryTile('Savings', savingsTotal, Colors.indigo),
                    _buildSummaryTile(
                        'Net', net, net >= 0 ? Colors.blue : Colors.red),
                  ],
                ),
              ),
              const Divider(),
              Flexible(
                fit: FlexFit.loose,
                child: filtered.isEmpty
                    ? const Center(
                        child: Text('No transactions for selected filter.'))
                    : ListView.builder(
                        itemCount: sortedKeys.length,
                        itemBuilder: (context, index) {
                          final dateKey = sortedKeys[index];
                          final dateTxs = grouped[dateKey]!;
                          final formattedDate =
                              DateFormat.yMMMd().format(dateTxs.first.date!);

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                color: Colors.grey.shade200,
                                child: Text(
                                  formattedDate,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              ...dateTxs.map((tx) {
                                final isOpeningBalance = tx.title ==
                                        'Opening Balance' &&
                                    tx.category == 'Opening Balance' &&
                                    tx.note == 'Auto-added on account creation';

                                return ListTile(
                                  leading: Icon(
                                    tx.type == TransactionType.income
                                        ? Icons.arrow_circle_down
                                        : tx.type == TransactionType.savings
                                            ? Icons.savings
                                            : Icons.arrow_circle_up,
                                    color: tx.type == TransactionType.income
                                        ? Colors.green
                                        : tx.type == TransactionType.savings
                                            ? Colors.indigo
                                            : Colors.red,
                                  ),
                                  title: Text(tx.title ?? 'No Title'),
                                  subtitle: Text(
                                      '${tx.category} • ${tx.account ?? ''}'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '₹${tx.amount?.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: tx.type ==
                                                  TransactionType.income
                                              ? Colors.green
                                              : tx.type ==
                                                      TransactionType.savings
                                                  ? Colors.indigo
                                                  : Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (!isOpeningBalance)
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.redAccent),
                                          onPressed: () =>
                                              _deleteTransaction(tx),
                                        ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryTile(String label, double amount, Color color) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        const SizedBox(height: 2),
        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
