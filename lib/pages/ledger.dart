// // // // // // // // // // // import 'package:flutter/material.dart';
// // // // // // // // // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // // // // // // // // import 'package:intl/intl.dart';
// // // // // // // // // // // import 'package:notegoexpense/model/transaction_notifier.dart';
// // // // // // // // // // // import '../model/transaction_model.dart';
// // // // // // // // // // // import '../widgets/calandar.dart';
// // // // // // // // // // // import '../model/account_notifier.dart';

// // // // // // // // // // // class LedgerPage extends ConsumerStatefulWidget {
// // // // // // // // // // //   const LedgerPage({super.key});

// // // // // // // // // // //   @override
// // // // // // // // // // //   ConsumerState<LedgerPage> createState() => _LedgerPageState();
// // // // // // // // // // // }

// // // // // // // // // // // class _LedgerPageState extends ConsumerState<LedgerPage> {
// // // // // // // // // // //   DateTimeRange? _selectedRange;
// // // // // // // // // // //   String _selectedCategory = 'All';
// // // // // // // // // // //   String _selectedAccount = 'All';
// // // // // // // // // // //   // final _titleController = TextEditingController();
// // // // // // // // // // //   // final _amountController = TextEditingController();
// // // // // // // // // // //   // final _noteController = TextEditingController();

// // // // // // // // // // //   void _deleteTransaction(TransactionModel tx) {
// // // // // // // // // // //     final accountsNotifier = ref.read(accountsProvider.notifier);
// // // // // // // // // // //     final accountAsync = ref.read(accountsProvider);

// // // // // // // // // // //     final accounts = accountAsync.maybeWhen(
// // // // // // // // // // //       data: (data) => data,
// // // // // // // // // // //       orElse: () => [],
// // // // // // // // // // //     );

// // // // // // // // // // //     final account = accounts.firstWhere(
// // // // // // // // // // //       (acc) => acc.name == tx.account,
// // // // // // // // // // //       orElse: () => throw Exception('Account not found'),
// // // // // // // // // // //     );

// // // // // // // // // // //     double balance = account.balance;

// // // // // // // // // // //     if (tx.type == TransactionType.income) {
// // // // // // // // // // //       balance -= tx.amount ?? 0;
// // // // // // // // // // //     } else {
// // // // // // // // // // //       balance += tx.amount ?? 0;
// // // // // // // // // // //     }

// // // // // // // // // // //     final updatedAccount = account.copyWith(balance: balance);
// // // // // // // // // // //     accountsNotifier.updateAccount(updatedAccount);

// // // // // // // // // // //     ref.read(transactionsProvider.notifier).deleteTransaction(tx.id ?? '');
// // // // // // // // // // //   }

// // // // // // // // // // //   @override
// // // // // // // // // // //   Widget build(BuildContext context) {
// // // // // // // // // // //     final transactionsAsync = ref.watch(transactionsProvider);

// // // // // // // // // // //     return Scaffold(
// // // // // // // // // // //       appBar: AppBar(
// // // // // // // // // // //         title: Row(
// // // // // // // // // // //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // // // // // // // // //           children: [
// // // // // // // // // // //             const Text('Ledger'),
// // // // // // // // // // //             DateRangeSelector(
// // // // // // // // // // //               initialRange: _selectedRange,
// // // // // // // // // // //               onRangeSelected: (range) {
// // // // // // // // // // //                 setState(() => _selectedRange = range);
// // // // // // // // // // //               },
// // // // // // // // // // //             ),
// // // // // // // // // // //           ],
// // // // // // // // // // //         ),
// // // // // // // // // // //       ),
// // // // // // // // // // //       body: transactionsAsync.when(
// // // // // // // // // // //         loading: () => const Center(child: CircularProgressIndicator()),
// // // // // // // // // // //         error: (e, st) => Center(child: Text('Error: $e')),
// // // // // // // // // // //         data: (transactions) {
// // // // // // // // // // //           List<TransactionModel> filtered = transactions;

// // // // // // // // // // //           if (_selectedCategory != 'All') {
// // // // // // // // // // //             filtered = filtered
// // // // // // // // // // //                 .where((tx) => tx.category == _selectedCategory)
// // // // // // // // // // //                 .toList();
// // // // // // // // // // //           }

// // // // // // // // // // //           if (_selectedAccount != 'All') {
// // // // // // // // // // //             filtered =
// // // // // // // // // // //                 filtered.where((tx) => tx.account == _selectedAccount).toList();
// // // // // // // // // // //           }

// // // // // // // // // // //           if (_selectedRange != null) {
// // // // // // // // // // //             filtered = filtered.where((tx) {
// // // // // // // // // // //               final txDate = tx.date ?? DateTime.now();
// // // // // // // // // // //               return txDate.isAfter(_selectedRange!.start
// // // // // // // // // // //                       .subtract(const Duration(days: 1))) &&
// // // // // // // // // // //                   txDate.isBefore(
// // // // // // // // // // //                       _selectedRange!.end.add(const Duration(days: 1)));
// // // // // // // // // // //             }).toList();
// // // // // // // // // // //           }

// // // // // // // // // // //           final incomeTotal = filtered
// // // // // // // // // // //               .where((tx) => tx.type == TransactionType.income)
// // // // // // // // // // //               .fold<double>(0, (sum, tx) => sum + (tx.amount ?? 0));
// // // // // // // // // // //           final expenseTotal = filtered
// // // // // // // // // // //               .where((tx) => tx.type == TransactionType.expense)
// // // // // // // // // // //               .fold<double>(0, (sum, tx) => sum + (tx.amount ?? 0));
// // // // // // // // // // //           final savingsTotal = filtered
// // // // // // // // // // //               .where((tx) => tx.type == TransactionType.savings)
// // // // // // // // // // //               .fold<double>(0, (sum, tx) => sum + (tx.amount ?? 0));
// // // // // // // // // // //           final net = incomeTotal - expenseTotal;

// // // // // // // // // // //           final categories = {
// // // // // // // // // // //             'All',
// // // // // // // // // // //             ...transactions.map((tx) => tx.category ?? '').toSet()
// // // // // // // // // // //           };
// // // // // // // // // // //           final accounts = {
// // // // // // // // // // //             'All',
// // // // // // // // // // //             ...transactions.map((tx) => tx.account ?? '').toSet()
// // // // // // // // // // //           };

// // // // // // // // // // //           final grouped = <String, List<TransactionModel>>{};
// // // // // // // // // // //           for (final tx in filtered) {
// // // // // // // // // // //             final date =
// // // // // // // // // // //                 DateFormat('yyyy-MM-dd').format(tx.date ?? DateTime.now());
// // // // // // // // // // //             grouped.putIfAbsent(date, () => []).add(tx);
// // // // // // // // // // //           }

// // // // // // // // // // //           final sortedKeys = grouped.keys.toList()
// // // // // // // // // // //             ..sort((a, b) => b.compareTo(a));

// // // // // // // // // // //           return Column(
// // // // // // // // // // //             children: [
// // // // // // // // // // //               Padding(
// // // // // // // // // // //                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// // // // // // // // // // //                 child: Row(
// // // // // // // // // // //                   children: [
// // // // // // // // // // //                     Expanded(
// // // // // // // // // // //                       child: Column(
// // // // // // // // // // //                         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // // // // // //                         children: [
// // // // // // // // // // //                           const Text("Category",
// // // // // // // // // // //                               style:
// // // // // // // // // // //                                   TextStyle(fontSize: 12, color: Colors.grey)),
// // // // // // // // // // //                           DropdownButton<String>(
// // // // // // // // // // //                             value: _selectedCategory,
// // // // // // // // // // //                             isExpanded: true,
// // // // // // // // // // //                             items: categories.map((cat) {
// // // // // // // // // // //                               return DropdownMenuItem(
// // // // // // // // // // //                                 value: cat,
// // // // // // // // // // //                                 child: Text(cat.isEmpty ? 'Uncategorized' : cat,
// // // // // // // // // // //                                     style: const TextStyle(fontSize: 14)),
// // // // // // // // // // //                               );
// // // // // // // // // // //                             }).toList(),
// // // // // // // // // // //                             onChanged: (value) {
// // // // // // // // // // //                               if (value != null) {
// // // // // // // // // // //                                 setState(() => _selectedCategory = value);
// // // // // // // // // // //                               }
// // // // // // // // // // //                             },
// // // // // // // // // // //                           ),
// // // // // // // // // // //                         ],
// // // // // // // // // // //                       ),
// // // // // // // // // // //                     ),
// // // // // // // // // // //                     const SizedBox(width: 8),
// // // // // // // // // // //                     Expanded(
// // // // // // // // // // //                       child: Column(
// // // // // // // // // // //                         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // // // // // //                         children: [
// // // // // // // // // // //                           const Text("Account",
// // // // // // // // // // //                               style:
// // // // // // // // // // //                                   TextStyle(fontSize: 12, color: Colors.grey)),
// // // // // // // // // // //                           DropdownButton<String>(
// // // // // // // // // // //                             value: _selectedAccount,
// // // // // // // // // // //                             isExpanded: true,
// // // // // // // // // // //                             items: accounts.map((acc) {
// // // // // // // // // // //                               return DropdownMenuItem(
// // // // // // // // // // //                                 value: acc,
// // // // // // // // // // //                                 child: Text(acc.isEmpty ? 'Unnamed' : acc,
// // // // // // // // // // //                                     style: const TextStyle(fontSize: 14)),
// // // // // // // // // // //                               );
// // // // // // // // // // //                             }).toList(),
// // // // // // // // // // //                             onChanged: (value) {
// // // // // // // // // // //                               if (value != null) {
// // // // // // // // // // //                                 setState(() => _selectedAccount = value);
// // // // // // // // // // //                               }
// // // // // // // // // // //                             },
// // // // // // // // // // //                           ),
// // // // // // // // // // //                         ],
// // // // // // // // // // //                       ),
// // // // // // // // // // //                     ),
// // // // // // // // // // //                   ],
// // // // // // // // // // //                 ),
// // // // // // // // // // //               ),
// // // // // // // // // // //               Padding(
// // // // // // // // // // //                 padding: const EdgeInsets.all(8),
// // // // // // // // // // //                 child: Row(
// // // // // // // // // // //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// // // // // // // // // // //                   children: [
// // // // // // // // // // //                     _buildSummaryTile('Income', incomeTotal, Colors.green),
// // // // // // // // // // //                     _buildSummaryTile('Expense', expenseTotal, Colors.red),
// // // // // // // // // // //                     _buildSummaryTile('Savings', savingsTotal, Colors.indigo),
// // // // // // // // // // //                     _buildSummaryTile(
// // // // // // // // // // //                         'Net', net, net >= 0 ? Colors.blue : Colors.red),
// // // // // // // // // // //                   ],
// // // // // // // // // // //                 ),
// // // // // // // // // // //               ),
// // // // // // // // // // //               const Divider(),
// // // // // // // // // // //               Flexible(
// // // // // // // // // // //                 fit: FlexFit.loose,
// // // // // // // // // // //                 child: filtered.isEmpty
// // // // // // // // // // //                     ? const Center(
// // // // // // // // // // //                         child: Text('No transactions for selected filter.'))
// // // // // // // // // // //                     : ListView.builder(
// // // // // // // // // // //                         itemCount: sortedKeys.length,
// // // // // // // // // // //                         itemBuilder: (context, index) {
// // // // // // // // // // //                           final dateKey = sortedKeys[index];
// // // // // // // // // // //                           final dateTxs = grouped[dateKey]!;
// // // // // // // // // // //                           final formattedDate =
// // // // // // // // // // //                               DateFormat.yMMMd().format(dateTxs.first.date!);

// // // // // // // // // // //                           return Column(
// // // // // // // // // // //                             crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // // // // // //                             children: [
// // // // // // // // // // //                               Container(
// // // // // // // // // // //                                 width: double.infinity,
// // // // // // // // // // //                                 padding: const EdgeInsets.symmetric(
// // // // // // // // // // //                                     horizontal: 16, vertical: 8),
// // // // // // // // // // //                                 color: Colors.grey.shade200,
// // // // // // // // // // //                                 child: Text(
// // // // // // // // // // //                                   formattedDate,
// // // // // // // // // // //                                   style: const TextStyle(
// // // // // // // // // // //                                       fontWeight: FontWeight.bold),
// // // // // // // // // // //                                 ),
// // // // // // // // // // //                               ),
// // // // // // // // // // //                               ...dateTxs.map((tx) {
// // // // // // // // // // //                                 final isOpeningBalance = tx.title ==
// // // // // // // // // // //                                         'Opening Balance' &&
// // // // // // // // // // //                                     tx.category == 'Opening Balance' &&
// // // // // // // // // // //                                     tx.note == 'Auto-added on account creation';

// // // // // // // // // // //                                 return ListTile(
// // // // // // // // // // //                                   leading: Icon(
// // // // // // // // // // //                                     tx.type == TransactionType.income
// // // // // // // // // // //                                         ? Icons.arrow_circle_down
// // // // // // // // // // //                                         : tx.type == TransactionType.savings
// // // // // // // // // // //                                             ? Icons.savings
// // // // // // // // // // //                                             : Icons.arrow_circle_up,
// // // // // // // // // // //                                     color: tx.type == TransactionType.income
// // // // // // // // // // //                                         ? Colors.green
// // // // // // // // // // //                                         : tx.type == TransactionType.savings
// // // // // // // // // // //                                             ? Colors.indigo
// // // // // // // // // // //                                             : Colors.red,
// // // // // // // // // // //                                   ),
// // // // // // // // // // //                                   title: Text(tx.title ?? 'No Title'),
// // // // // // // // // // //                                   subtitle: Text(
// // // // // // // // // // //                                       '${tx.category} • ${tx.account ?? ''}'),
// // // // // // // // // // //                                   trailing: Row(
// // // // // // // // // // //                                     mainAxisSize: MainAxisSize.min,
// // // // // // // // // // //                                     children: [
// // // // // // // // // // //                                       Text(
// // // // // // // // // // //                                         '₹${tx.amount?.toStringAsFixed(2)}',
// // // // // // // // // // //                                         style: TextStyle(
// // // // // // // // // // //                                           color: tx.type ==
// // // // // // // // // // //                                                   TransactionType.income
// // // // // // // // // // //                                               ? Colors.green
// // // // // // // // // // //                                               : tx.type ==
// // // // // // // // // // //                                                       TransactionType.savings
// // // // // // // // // // //                                                   ? Colors.indigo
// // // // // // // // // // //                                                   : Colors.red,
// // // // // // // // // // //                                           fontWeight: FontWeight.bold,
// // // // // // // // // // //                                         ),
// // // // // // // // // // //                                       ),
// // // // // // // // // // //                                       if (!isOpeningBalance)
// // // // // // // // // // //                                         IconButton(
// // // // // // // // // // //                                           icon: const Icon(Icons.delete,
// // // // // // // // // // //                                               color: Colors.redAccent),
// // // // // // // // // // //                                           onPressed: () =>
// // // // // // // // // // //                                               _deleteTransaction(tx),
// // // // // // // // // // //                                         ),
// // // // // // // // // // //                                     ],
// // // // // // // // // // //                                   ),
// // // // // // // // // // //                                 );
// // // // // // // // // // //                               }),
// // // // // // // // // // //                             ],
// // // // // // // // // // //                           );
// // // // // // // // // // //                         },
// // // // // // // // // // //                       ),
// // // // // // // // // // //               ),
// // // // // // // // // // //             ],
// // // // // // // // // // //           );
// // // // // // // // // // //         },
// // // // // // // // // // //       ),
// // // // // // // // // // //     );
// // // // // // // // // // //   }

// // // // // // // // // // //   Widget _buildSummaryTile(String label, double amount, Color color) {
// // // // // // // // // // //     return Column(
// // // // // // // // // // //       children: [
// // // // // // // // // // //         Text(label,
// // // // // // // // // // //             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
// // // // // // // // // // //         const SizedBox(height: 2),
// // // // // // // // // // //         Text(
// // // // // // // // // // //           '₹${amount.toStringAsFixed(2)}',
// // // // // // // // // // //           style: TextStyle(
// // // // // // // // // // //             color: color,
// // // // // // // // // // //             fontSize: 14,
// // // // // // // // // // //             fontWeight: FontWeight.w600,
// // // // // // // // // // //           ),
// // // // // // // // // // //         ),
// // // // // // // // // // //       ],
// // // // // // // // // // //     );
// // // // // // // // // // //   }
// // // // // // // // // // // }

// // // // // // // // // // import 'package:flutter/material.dart';
// // // // // // // // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // // // // // // // import 'package:intl/intl.dart';
// // // // // // // // // // import 'package:notegoexpense/model/transaction_notifier.dart';
// // // // // // // // // // import '../model/transaction_model.dart';
// // // // // // // // // // import '../widgets/calandar.dart';
// // // // // // // // // // import '../model/account_notifier.dart';

// // // // // // // // // // class LedgerPage extends ConsumerStatefulWidget {
// // // // // // // // // //   const LedgerPage({super.key});

// // // // // // // // // //   @override
// // // // // // // // // //   ConsumerState<LedgerPage> createState() => _LedgerPageState();
// // // // // // // // // // }

// // // // // // // // // // class _LedgerPageState extends ConsumerState<LedgerPage> {
// // // // // // // // // //   String _selectedView = 'Daily';
// // // // // // // // // //   String _selectedCategory = 'All';
// // // // // // // // // //   String _selectedAccount = 'All';

// // // // // // // // // //   void _deleteTransaction(TransactionModel tx) {
// // // // // // // // // //     final accountsNotifier = ref.read(accountsProvider.notifier);
// // // // // // // // // //     final accountAsync = ref.read(accountsProvider);

// // // // // // // // // //     final accounts = accountAsync.maybeWhen(
// // // // // // // // // //       data: (data) => data,
// // // // // // // // // //       orElse: () => [],
// // // // // // // // // //     );

// // // // // // // // // //     final account = accounts.firstWhere(
// // // // // // // // // //       (acc) => acc.name == tx.account,
// // // // // // // // // //       orElse: () => throw Exception('Account not found'),
// // // // // // // // // //     );

// // // // // // // // // //     double balance = account.balance;

// // // // // // // // // //     if (tx.type == TransactionType.income) {
// // // // // // // // // //       balance -= tx.amount ?? 0;
// // // // // // // // // //     } else {
// // // // // // // // // //       balance += tx.amount ?? 0;
// // // // // // // // // //     }

// // // // // // // // // //     final updatedAccount = account.copyWith(balance: balance);
// // // // // // // // // //     accountsNotifier.updateAccount(updatedAccount);

// // // // // // // // // //     ref.read(transactionsProvider.notifier).deleteTransaction(tx.id ?? '');
// // // // // // // // // //   }

// // // // // // // // // //   @override
// // // // // // // // // //   Widget build(BuildContext context) {
// // // // // // // // // //     final transactionsAsync = ref.watch(transactionsProvider);

// // // // // // // // // //     return Scaffold(
// // // // // // // // // //       appBar: AppBar(
// // // // // // // // // //         title: const Text('Ledger'),
// // // // // // // // // //         actions: [
// // // // // // // // // //           DropdownButton<String>(
// // // // // // // // // //             value: _selectedView,
// // // // // // // // // //             items: const [
// // // // // // // // // //               DropdownMenuItem(value: 'Daily', child: Text('Daily')),
// // // // // // // // // //               DropdownMenuItem(value: 'Weekly', child: Text('Weekly')),
// // // // // // // // // //               DropdownMenuItem(value: 'Monthly', child: Text('Monthly')),
// // // // // // // // // //               DropdownMenuItem(value: 'Total', child: Text('Total')),
// // // // // // // // // //             ],
// // // // // // // // // //             onChanged: (val) {
// // // // // // // // // //               if (val != null) setState(() => _selectedView = val);
// // // // // // // // // //             },
// // // // // // // // // //           )
// // // // // // // // // //         ],
// // // // // // // // // //       ),
// // // // // // // // // //       body: transactionsAsync.when(
// // // // // // // // // //         loading: () => const Center(child: CircularProgressIndicator()),
// // // // // // // // // //         error: (e, st) => Center(child: Text('Error: $e')),
// // // // // // // // // //         data: (transactions) {
// // // // // // // // // //           final categories = {
// // // // // // // // // //             'All',
// // // // // // // // // //             ...transactions.map((tx) => tx.category ?? '').toSet()
// // // // // // // // // //           };
// // // // // // // // // //           final accounts = {
// // // // // // // // // //             'All',
// // // // // // // // // //             ...transactions.map((tx) => tx.account ?? '').toSet()
// // // // // // // // // //           };

// // // // // // // // // //           return Column(
// // // // // // // // // //             children: [
// // // // // // // // // //               Padding(
// // // // // // // // // //                 padding: const EdgeInsets.all(8),
// // // // // // // // // //                 child: Row(
// // // // // // // // // //                   children: [
// // // // // // // // // //                     Expanded(
// // // // // // // // // //                       child: DropdownButton<String>(
// // // // // // // // // //                         value: _selectedCategory,
// // // // // // // // // //                         isExpanded: true,
// // // // // // // // // //                         items: categories.map((cat) {
// // // // // // // // // //                           return DropdownMenuItem(
// // // // // // // // // //                             value: cat,
// // // // // // // // // //                             child: Text(cat.isEmpty ? 'Uncategorized' : cat),
// // // // // // // // // //                           );
// // // // // // // // // //                         }).toList(),
// // // // // // // // // //                         onChanged: (val) {
// // // // // // // // // //                           if (val != null)
// // // // // // // // // //                             setState(() => _selectedCategory = val);
// // // // // // // // // //                         },
// // // // // // // // // //                       ),
// // // // // // // // // //                     ),
// // // // // // // // // //                     const SizedBox(width: 8),
// // // // // // // // // //                     Expanded(
// // // // // // // // // //                       child: DropdownButton<String>(
// // // // // // // // // //                         value: _selectedAccount,
// // // // // // // // // //                         isExpanded: true,
// // // // // // // // // //                         items: accounts.map((acc) {
// // // // // // // // // //                           return DropdownMenuItem(
// // // // // // // // // //                             value: acc,
// // // // // // // // // //                             child: Text(acc.isEmpty ? 'Unnamed' : acc),
// // // // // // // // // //                           );
// // // // // // // // // //                         }).toList(),
// // // // // // // // // //                         onChanged: (val) {
// // // // // // // // // //                           if (val != null)
// // // // // // // // // //                             setState(() => _selectedAccount = val);
// // // // // // // // // //                         },
// // // // // // // // // //                       ),
// // // // // // // // // //                     ),
// // // // // // // // // //                   ],
// // // // // // // // // //                 ),
// // // // // // // // // //               ),
// // // // // // // // // //               const Divider(),
// // // // // // // // // //               Expanded(
// // // // // // // // // //                 child: _selectedView == 'Daily'
// // // // // // // // // //                     ? _buildDailyView(transactions)
// // // // // // // // // //                     : _selectedView == 'Weekly'
// // // // // // // // // //                         ? _buildWeeklyView(transactions)
// // // // // // // // // //                         : _selectedView == 'Monthly'
// // // // // // // // // //                             ? _buildMonthlyView(transactions)
// // // // // // // // // //                             : _buildTotalView(transactions),
// // // // // // // // // //               ),
// // // // // // // // // //             ],
// // // // // // // // // //           );
// // // // // // // // // //         },
// // // // // // // // // //       ),
// // // // // // // // // //     );
// // // // // // // // // //   }

// // // // // // // // // //   Widget _buildDailyView(List<TransactionModel> transactions) {
// // // // // // // // // //     final filtered = _applyFilters(transactions);
// // // // // // // // // //     final grouped = <String, List<TransactionModel>>{};
// // // // // // // // // //     for (final tx in filtered) {
// // // // // // // // // //       final date = DateFormat('yyyy-MM-dd').format(tx.date ?? DateTime.now());
// // // // // // // // // //       grouped.putIfAbsent(date, () => []).add(tx);
// // // // // // // // // //     }
// // // // // // // // // //     final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

// // // // // // // // // //     if (filtered.isEmpty) {
// // // // // // // // // //       return const Center(child: Text('No transactions found.'));
// // // // // // // // // //     }

// // // // // // // // // //     return ListView.builder(
// // // // // // // // // //       itemCount: sortedKeys.length,
// // // // // // // // // //       itemBuilder: (context, index) {
// // // // // // // // // //         final dateKey = sortedKeys[index];
// // // // // // // // // //         final dateTxs = grouped[dateKey]!;
// // // // // // // // // //         final formattedDate = DateFormat.yMMMd().format(dateTxs.first.date!);

// // // // // // // // // //         return Column(
// // // // // // // // // //           crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // // // // //           children: [
// // // // // // // // // //             Container(
// // // // // // // // // //               width: double.infinity,
// // // // // // // // // //               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// // // // // // // // // //               color: Colors.grey.shade200,
// // // // // // // // // //               child: Text(formattedDate,
// // // // // // // // // //                   style: const TextStyle(fontWeight: FontWeight.bold)),
// // // // // // // // // //             ),
// // // // // // // // // //             ...dateTxs.map(_buildTransactionTile),
// // // // // // // // // //           ],
// // // // // // // // // //         );
// // // // // // // // // //       },
// // // // // // // // // //     );
// // // // // // // // // //   }

// // // // // // // // // //   Widget _buildWeeklyView(List<TransactionModel> transactions) {
// // // // // // // // // //     final filtered = _applyFilters(transactions);
// // // // // // // // // //     final Map<String, List<TransactionModel>> weeklyGrouped = {};

// // // // // // // // // //     for (final tx in filtered) {
// // // // // // // // // //       final weekStart = tx.date!.subtract(Duration(days: tx.date!.weekday - 1));
// // // // // // // // // //       final weekEnd = weekStart.add(const Duration(days: 6));
// // // // // // // // // //       final label =
// // // // // // // // // //           '${DateFormat('d/M/yy').format(weekStart)} - ${DateFormat('d/M/yy').format(weekEnd)}';
// // // // // // // // // //       weeklyGrouped.putIfAbsent(label, () => []).add(tx);
// // // // // // // // // //     }

// // // // // // // // // //     final sortedKeys = weeklyGrouped.keys.toList()
// // // // // // // // // //       ..sort((a, b) => b.compareTo(a));

// // // // // // // // // //     if (filtered.isEmpty) {
// // // // // // // // // //       return const Center(child: Text('No transactions found.'));
// // // // // // // // // //     }

// // // // // // // // // //     return ListView.builder(
// // // // // // // // // //       itemCount: sortedKeys.length,
// // // // // // // // // //       itemBuilder: (context, index) {
// // // // // // // // // //         final label = sortedKeys[index];
// // // // // // // // // //         final txs = weeklyGrouped[label]!;

// // // // // // // // // //         final expenseTotal = txs
// // // // // // // // // //             .where((tx) => tx.type == TransactionType.expense)
// // // // // // // // // //             .fold<double>(0, (sum, tx) => sum + (tx.amount ?? 0));
// // // // // // // // // //         final incomeTotal = txs
// // // // // // // // // //             .where((tx) => tx.type == TransactionType.income)
// // // // // // // // // //             .fold<double>(0, (sum, tx) => sum + (tx.amount ?? 0));

// // // // // // // // // //         return ListTile(
// // // // // // // // // //           title: Text(label),
// // // // // // // // // //           subtitle: Text(
// // // // // // // // // //               'Expense: ₹${expenseTotal.toStringAsFixed(2)}  |  Income: ₹${incomeTotal.toStringAsFixed(2)}'),
// // // // // // // // // //         );
// // // // // // // // // //       },
// // // // // // // // // //     );
// // // // // // // // // //   }

// // // // // // // // // //   Widget _buildMonthlyView(List<TransactionModel> transactions) {
// // // // // // // // // //     final filtered = _applyFilters(transactions);
// // // // // // // // // //     final Map<String, List<TransactionModel>> monthlyGrouped = {};

// // // // // // // // // //     for (final tx in filtered) {
// // // // // // // // // //       final monthKey = DateFormat('MMM yyyy').format(tx.date!);
// // // // // // // // // //       monthlyGrouped.putIfAbsent(monthKey, () => []).add(tx);
// // // // // // // // // //     }

// // // // // // // // // //     final sortedKeys = monthlyGrouped.keys.toList()
// // // // // // // // // //       ..sort((a, b) => b.compareTo(a));

// // // // // // // // // //     if (filtered.isEmpty) {
// // // // // // // // // //       return const Center(child: Text('No transactions found.'));
// // // // // // // // // //     }

// // // // // // // // // //     return ListView.builder(
// // // // // // // // // //       itemCount: sortedKeys.length,
// // // // // // // // // //       itemBuilder: (context, index) {
// // // // // // // // // //         final label = sortedKeys[index];
// // // // // // // // // //         final txs = monthlyGrouped[label]!;

// // // // // // // // // //         final expenseTotal = txs
// // // // // // // // // //             .where((tx) => tx.type == TransactionType.expense)
// // // // // // // // // //             .fold<double>(0, (sum, tx) => sum + (tx.amount ?? 0));
// // // // // // // // // //         final incomeTotal = txs
// // // // // // // // // //             .where((tx) => tx.type == TransactionType.income)
// // // // // // // // // //             .fold<double>(0, (sum, tx) => sum + (tx.amount ?? 0));

// // // // // // // // // //         return ListTile(
// // // // // // // // // //           title: Text(label),
// // // // // // // // // //           subtitle: Text(
// // // // // // // // // //               'Expense: ₹${expenseTotal.toStringAsFixed(2)}  |  Income: ₹${incomeTotal.toStringAsFixed(2)}'),
// // // // // // // // // //         );
// // // // // // // // // //       },
// // // // // // // // // //     );
// // // // // // // // // //   }

// // // // // // // // // //   Widget _buildTotalView(List<TransactionModel> transactions) {
// // // // // // // // // //     // Budget UI can be added later here
// // // // // // // // // //     return const Center(
// // // // // // // // // //       child: Text('Total view with budget coming soon.'),
// // // // // // // // // //     );
// // // // // // // // // //   }

// // // // // // // // // //   List<TransactionModel> _applyFilters(List<TransactionModel> transactions) {
// // // // // // // // // //     return transactions.where((tx) {
// // // // // // // // // //       final categoryMatch =
// // // // // // // // // //           _selectedCategory == 'All' || tx.category == _selectedCategory;
// // // // // // // // // //       final accountMatch =
// // // // // // // // // //           _selectedAccount == 'All' || tx.account == _selectedAccount;
// // // // // // // // // //       return categoryMatch && accountMatch;
// // // // // // // // // //     }).toList();
// // // // // // // // // //   }

// // // // // // // // // //   Widget _buildTransactionTile(TransactionModel tx) {
// // // // // // // // // //     final isOpeningBalance = tx.title == 'Opening Balance' &&
// // // // // // // // // //         tx.category == 'Opening Balance' &&
// // // // // // // // // //         tx.note == 'Auto-added on account creation';

// // // // // // // // // //     return ListTile(
// // // // // // // // // //       leading: Icon(
// // // // // // // // // //         tx.type == TransactionType.income
// // // // // // // // // //             ? Icons.arrow_circle_down
// // // // // // // // // //             : tx.type == TransactionType.savings
// // // // // // // // // //                 ? Icons.savings
// // // // // // // // // //                 : Icons.arrow_circle_up,
// // // // // // // // // //         color: tx.type == TransactionType.income
// // // // // // // // // //             ? Colors.green
// // // // // // // // // //             : tx.type == TransactionType.savings
// // // // // // // // // //                 ? Colors.indigo
// // // // // // // // // //                 : Colors.red,
// // // // // // // // // //       ),
// // // // // // // // // //       title: Text(tx.title ?? 'No Title'),
// // // // // // // // // //       subtitle: Text('${tx.category} • ${tx.account ?? ''}'),
// // // // // // // // // //       trailing: Row(
// // // // // // // // // //         mainAxisSize: MainAxisSize.min,
// // // // // // // // // //         children: [
// // // // // // // // // //           Text(
// // // // // // // // // //             '₹${tx.amount?.toStringAsFixed(2)}',
// // // // // // // // // //             style: TextStyle(
// // // // // // // // // //               color: tx.type == TransactionType.income
// // // // // // // // // //                   ? Colors.green
// // // // // // // // // //                   : tx.type == TransactionType.savings
// // // // // // // // // //                       ? Colors.indigo
// // // // // // // // // //                       : Colors.red,
// // // // // // // // // //               fontWeight: FontWeight.bold,
// // // // // // // // // //             ),
// // // // // // // // // //           ),
// // // // // // // // // //           if (!isOpeningBalance)
// // // // // // // // // //             IconButton(
// // // // // // // // // //               icon: const Icon(Icons.delete, color: Colors.redAccent),
// // // // // // // // // //               onPressed: () => _deleteTransaction(tx),
// // // // // // // // // //             ),
// // // // // // // // // //         ],
// // // // // // // // // //       ),
// // // // // // // // // //     );
// // // // // // // // // //   }
// // // // // // // // // // }

// // // // // // // // // import 'package:flutter/material.dart';
// // // // // // // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // // // // // // import 'package:intl/intl.dart';
// // // // // // // // // import 'package:notegoexpense/model/transaction_notifier.dart';
// // // // // // // // // import '../model/transaction_model.dart';
// // // // // // // // // import '../widgets/calandar.dart';
// // // // // // // // // import '../model/account_notifier.dart';

// // // // // // // // // class LedgerPage extends ConsumerStatefulWidget {
// // // // // // // // //   const LedgerPage({super.key});

// // // // // // // // //   @override
// // // // // // // // //   ConsumerState<LedgerPage> createState() => _LedgerPageState();
// // // // // // // // // }

// // // // // // // // // class _LedgerPageState extends ConsumerState<LedgerPage> {
// // // // // // // // //   String _selectedView = 'Daily';
// // // // // // // // //   DateTimeRange? _customRange;
// // // // // // // // //   DateTime _today = DateTime.now();

// // // // // // // // //   String _selectedCategory = 'All';
// // // // // // // // //   String _selectedAccount = 'All';

// // // // // // // // //   final List<String> _views = ['Daily', 'Weekly', 'Monthly', 'Total', 'Custom'];

// // // // // // // // //   @override
// // // // // // // // //   Widget build(BuildContext context) {
// // // // // // // // //     final transactionsAsync = ref.watch(transactionsProvider);

// // // // // // // // //     return Scaffold(
// // // // // // // // //       appBar: AppBar(
// // // // // // // // //         title: const Text('Ledger'),
// // // // // // // // //       ),
// // // // // // // // //       body: transactionsAsync.when(
// // // // // // // // //         loading: () => const Center(child: CircularProgressIndicator()),
// // // // // // // // //         error: (e, st) => Center(child: Text('Error: $e')),
// // // // // // // // //         data: (transactions) {
// // // // // // // // //           List<TransactionModel> filtered = transactions;

// // // // // // // // //           final categories = {
// // // // // // // // //             'All',
// // // // // // // // //             ...transactions.map((tx) => tx.category ?? '').toSet()
// // // // // // // // //           };
// // // // // // // // //           final accounts = {
// // // // // // // // //             'All',
// // // // // // // // //             ...transactions.map((tx) => tx.account ?? '').toSet()
// // // // // // // // //           };

// // // // // // // // //           DateTime start;
// // // // // // // // //           DateTime end;

// // // // // // // // //           if (_selectedView == 'Daily') {
// // // // // // // // //             start = DateTime(_today.year, _today.month, _today.day);
// // // // // // // // //             end = start.add(const Duration(days: 1));
// // // // // // // // //           } else if (_selectedView == 'Weekly') {
// // // // // // // // //             start = _today.subtract(Duration(days: _today.weekday - 1));
// // // // // // // // //             end = start.add(const Duration(days: 7));
// // // // // // // // //           } else if (_selectedView == 'Monthly') {
// // // // // // // // //             start = DateTime(_today.year, _today.month, 1);
// // // // // // // // //             end = DateTime(_today.year, _today.month + 1, 1);
// // // // // // // // //           } else if (_selectedView == 'Custom' && _customRange != null) {
// // // // // // // // //             start = _customRange!.start;
// // // // // // // // //             end = _customRange!.end.add(const Duration(days: 1));
// // // // // // // // //           } else {
// // // // // // // // //             start = DateTime(2000);
// // // // // // // // //             end = DateTime(2100);
// // // // // // // // //           }

// // // // // // // // //           filtered = filtered.where((tx) {
// // // // // // // // //             final txDate = tx.date ?? DateTime.now();
// // // // // // // // //             final matchesCategory =
// // // // // // // // //                 _selectedCategory == 'All' || tx.category == _selectedCategory;
// // // // // // // // //             final matchesAccount =
// // // // // // // // //                 _selectedAccount == 'All' || tx.account == _selectedAccount;
// // // // // // // // //             return txDate.isAfter(start.subtract(const Duration(seconds: 1))) &&
// // // // // // // // //                 txDate.isBefore(end) &&
// // // // // // // // //                 matchesCategory &&
// // // // // // // // //                 matchesAccount;
// // // // // // // // //           }).toList();

// // // // // // // // //           final incomeTotal = filtered
// // // // // // // // //               .where((tx) => tx.type == TransactionType.income)
// // // // // // // // //               .fold<double>(0, (sum, tx) => sum + (tx.amount ?? 0));
// // // // // // // // //           final expenseTotal = filtered
// // // // // // // // //               .where((tx) => tx.type == TransactionType.expense)
// // // // // // // // //               .fold<double>(0, (sum, tx) => sum + (tx.amount ?? 0));
// // // // // // // // //           final net = incomeTotal - expenseTotal;

// // // // // // // // //           return Column(
// // // // // // // // //             children: [
// // // // // // // // //               Padding(
// // // // // // // // //                 padding: const EdgeInsets.all(8),
// // // // // // // // //                 child: Row(
// // // // // // // // //                   children: [
// // // // // // // // //                     Expanded(
// // // // // // // // //                       child: DropdownButtonFormField<String>(
// // // // // // // // //                         value: _selectedCategory,
// // // // // // // // //                         decoration: const InputDecoration(
// // // // // // // // //                           labelText: 'Category',
// // // // // // // // //                           contentPadding: EdgeInsets.symmetric(horizontal: 8),
// // // // // // // // //                           border: OutlineInputBorder(),
// // // // // // // // //                         ),
// // // // // // // // //                         items: categories.map((cat) {
// // // // // // // // //                           return DropdownMenuItem(
// // // // // // // // //                             value: cat,
// // // // // // // // //                             child: Text(cat.isEmpty ? 'Uncategorized' : cat),
// // // // // // // // //                           );
// // // // // // // // //                         }).toList(),
// // // // // // // // //                         onChanged: (value) {
// // // // // // // // //                           if (value != null) {
// // // // // // // // //                             setState(() => _selectedCategory = value);
// // // // // // // // //                           }
// // // // // // // // //                         },
// // // // // // // // //                       ),
// // // // // // // // //                     ),
// // // // // // // // //                     const SizedBox(width: 8),
// // // // // // // // //                     Expanded(
// // // // // // // // //                       child: DropdownButtonFormField<String>(
// // // // // // // // //                         value: _selectedAccount,
// // // // // // // // //                         decoration: const InputDecoration(
// // // // // // // // //                           labelText: 'Account',
// // // // // // // // //                           contentPadding: EdgeInsets.symmetric(horizontal: 8),
// // // // // // // // //                           border: OutlineInputBorder(),
// // // // // // // // //                         ),
// // // // // // // // //                         items: accounts.map((acc) {
// // // // // // // // //                           return DropdownMenuItem(
// // // // // // // // //                             value: acc,
// // // // // // // // //                             child: Text(acc.isEmpty ? 'Unnamed' : acc),
// // // // // // // // //                           );
// // // // // // // // //                         }).toList(),
// // // // // // // // //                         onChanged: (value) {
// // // // // // // // //                           if (value != null) {
// // // // // // // // //                             setState(() => _selectedAccount = value);
// // // // // // // // //                           }
// // // // // // // // //                         },
// // // // // // // // //                       ),
// // // // // // // // //                     ),
// // // // // // // // //                   ],
// // // // // // // // //                 ),
// // // // // // // // //               ),
// // // // // // // // //               Padding(
// // // // // // // // //                 padding: const EdgeInsets.symmetric(horizontal: 8),
// // // // // // // // //                 child: Row(
// // // // // // // // //                   children: _views.map((view) {
// // // // // // // // //                     final isSelected = _selectedView == view;
// // // // // // // // //                     return Expanded(
// // // // // // // // //                       child: Padding(
// // // // // // // // //                         padding: const EdgeInsets.symmetric(horizontal: 2),
// // // // // // // // //                         child: ElevatedButton(
// // // // // // // // //                           style: ElevatedButton.styleFrom(
// // // // // // // // //                             backgroundColor:
// // // // // // // // //                                 isSelected ? Colors.blue : Colors.grey.shade200,
// // // // // // // // //                             foregroundColor:
// // // // // // // // //                                 isSelected ? Colors.white : Colors.black,
// // // // // // // // //                           ),
// // // // // // // // //                           onPressed: () async {
// // // // // // // // //                             if (view == 'Custom') {
// // // // // // // // //                               final picked = await showDateRangePicker(
// // // // // // // // //                                 context: context,
// // // // // // // // //                                 firstDate: DateTime(2000),
// // // // // // // // //                                 lastDate: DateTime(2100),
// // // // // // // // //                               );
// // // // // // // // //                               if (picked != null) {
// // // // // // // // //                                 setState(() {
// // // // // // // // //                                   _customRange = picked;
// // // // // // // // //                                   _selectedView = view;
// // // // // // // // //                                 });
// // // // // // // // //                               }
// // // // // // // // //                             } else {
// // // // // // // // //                               setState(() {
// // // // // // // // //                                 _selectedView = view;
// // // // // // // // //                                 _today = DateTime.now();
// // // // // // // // //                               });
// // // // // // // // //                             }
// // // // // // // // //                           },
// // // // // // // // //                           child:
// // // // // // // // //                               Text(view, style: const TextStyle(fontSize: 12)),
// // // // // // // // //                         ),
// // // // // // // // //                       ),
// // // // // // // // //                     );
// // // // // // // // //                   }).toList(),
// // // // // // // // //                 ),
// // // // // // // // //               ),
// // // // // // // // //               Padding(
// // // // // // // // //                 padding: const EdgeInsets.all(12),
// // // // // // // // //                 child: Row(
// // // // // // // // //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// // // // // // // // //                   children: [
// // // // // // // // //                     _buildSummaryTile('Income', incomeTotal, Colors.green),
// // // // // // // // //                     _buildSummaryTile('Expense', expenseTotal, Colors.red),
// // // // // // // // //                     _buildSummaryTile(
// // // // // // // // //                         'Net', net, net >= 0 ? Colors.blue : Colors.red),
// // // // // // // // //                   ],
// // // // // // // // //                 ),
// // // // // // // // //               ),
// // // // // // // // //               const Divider(),
// // // // // // // // //               Expanded(
// // // // // // // // //                 child: filtered.isEmpty
// // // // // // // // //                     ? const Center(child: Text('No transactions.'))
// // // // // // // // //                     : ListView.builder(
// // // // // // // // //                         itemCount: filtered.length,
// // // // // // // // //                         itemBuilder: (context, index) {
// // // // // // // // //                           final tx = filtered[index];
// // // // // // // // //                           return ListTile(
// // // // // // // // //                             leading: Icon(
// // // // // // // // //                               tx.type == TransactionType.income
// // // // // // // // //                                   ? Icons.arrow_downward
// // // // // // // // //                                   : Icons.arrow_upward,
// // // // // // // // //                               color: tx.type == TransactionType.income
// // // // // // // // //                                   ? Colors.green
// // // // // // // // //                                   : Colors.red,
// // // // // // // // //                             ),
// // // // // // // // //                             title: Text(tx.title ?? 'No Title'),
// // // // // // // // //                             subtitle: Text(
// // // // // // // // //                                 '${DateFormat.yMMMd().format(tx.date ?? DateTime.now())} • ${tx.account} • ${tx.category}'),
// // // // // // // // //                             trailing: Text(
// // // // // // // // //                               '₹${tx.amount?.toStringAsFixed(2)}',
// // // // // // // // //                               style:
// // // // // // // // //                                   const TextStyle(fontWeight: FontWeight.bold),
// // // // // // // // //                             ),
// // // // // // // // //                           );
// // // // // // // // //                         },
// // // // // // // // //                       ),
// // // // // // // // //               ),
// // // // // // // // //             ],
// // // // // // // // //           );
// // // // // // // // //         },
// // // // // // // // //       ),
// // // // // // // // //     );
// // // // // // // // //   }

// // // // // // // // //   Widget _buildSummaryTile(String label, double amount, Color color) {
// // // // // // // // //     return Column(
// // // // // // // // //       children: [
// // // // // // // // //         Text(label,
// // // // // // // // //             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
// // // // // // // // //         const SizedBox(height: 2),
// // // // // // // // //         Text(
// // // // // // // // //           '₹${amount.toStringAsFixed(2)}',
// // // // // // // // //           style: TextStyle(
// // // // // // // // //             color: color,
// // // // // // // // //             fontSize: 14,
// // // // // // // // //             fontWeight: FontWeight.w600,
// // // // // // // // //           ),
// // // // // // // // //         ),
// // // // // // // // //       ],
// // // // // // // // //     );
// // // // // // // // //   }
// // // // // // // // // }
// // // // // // // // import 'package:flutter/material.dart';
// // // // // // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // // // // // import 'package:intl/intl.dart';
// // // // // // // // import 'package:notegoexpense/model/transaction_notifier.dart';
// // // // // // // // import '../model/transaction_model.dart';
// // // // // // // // // Assuming 'calandar.dart' is not directly used in the LedgerPage UI,
// // // // // // // // // but if it's a utility for date picking, it's fine to keep the import
// // // // // // // // // import '../widgets/calandar.dart';
// // // // // // // // import '../model/account_notifier.dart'; // Keep if AccountNotifier is used elsewhere, not directly in this snippet
// // // // // // // // import '../extras/AppColors.dart'; // Import your custom AppColors

// // // // // // // // class LedgerPage extends ConsumerStatefulWidget {
// // // // // // // //   const LedgerPage({super.key});

// // // // // // // //   @override
// // // // // // // //   ConsumerState<LedgerPage> createState() => _LedgerPageState();
// // // // // // // // }

// // // // // // // // class _LedgerPageState extends ConsumerState<LedgerPage> {
// // // // // // // //   String _selectedView = 'Daily';
// // // // // // // //   DateTimeRange? _customRange;
// // // // // // // //   DateTime _currentDate =
// // // // // // // //       DateTime.now(); // Renamed _today to _currentDate for clarity

// // // // // // // //   String _selectedCategory = 'All';
// // // // // // // //   String _selectedAccount = 'All';

// // // // // // // //   final List<String> _views = ['Daily', 'Weekly', 'Monthly', 'Total', 'Custom'];

// // // // // // // //   // Function to move the date range
// // // // // // // //   void _moveDate(int days) {
// // // // // // // //     setState(() {
// // // // // // // //       _currentDate = _currentDate.add(Duration(days: days));
// // // // // // // //     });
// // // // // // // //   }

// // // // // // // //   void _moveWeek(int weeks) {
// // // // // // // //     setState(() {
// // // // // // // //       _currentDate = _currentDate.add(Duration(days: weeks * 7));
// // // // // // // //     });
// // // // // // // //   }

// // // // // // // //   void _moveMonth(int months) {
// // // // // // // //     setState(() {
// // // // // // // //       _currentDate = DateTime(
// // // // // // // //         _currentDate.year,
// // // // // // // //         _currentDate.month + months,
// // // // // // // //         _currentDate.day,
// // // // // // // //       );
// // // // // // // //     });
// // // // // // // //   }

// // // // // // // //   @override
// // // // // // // //   Widget build(BuildContext context) {
// // // // // // // //     final transactionsAsync = ref.watch(transactionsProvider);

// // // // // // // //     return Theme(
// // // // // // // //       // Wrap with Theme to apply AppColors
// // // // // // // //       data: ThemeData(
// // // // // // // //         brightness: Brightness.dark, // Set to dark theme
// // // // // // // //         scaffoldBackgroundColor: AppColors.background,
// // // // // // // //         cardColor: AppColors.card,
// // // // // // // //         primaryColor: AppColors.primary,
// // // // // // // //         hintColor: AppColors.textSecondary, // For labels in input fields
// // // // // // // //         appBarTheme: const AppBarTheme(
// // // // // // // //           backgroundColor: AppColors.background,
// // // // // // // //           foregroundColor: AppColors.textPrimary,
// // // // // // // //           elevation: 1,
// // // // // // // //         ),
// // // // // // // //         textTheme: const TextTheme(
// // // // // // // //           displayLarge: TextStyle(color: AppColors.textPrimary),
// // // // // // // //           displayMedium: TextStyle(color: AppColors.textPrimary),
// // // // // // // //           displaySmall: TextStyle(color: AppColors.textPrimary),
// // // // // // // //           headlineLarge: TextStyle(color: AppColors.textPrimary),
// // // // // // // //           headlineMedium: TextStyle(color: AppColors.textPrimary),
// // // // // // // //           headlineSmall: TextStyle(color: AppColors.textPrimary),
// // // // // // // //           titleLarge: TextStyle(color: AppColors.textPrimary),
// // // // // // // //           titleMedium: TextStyle(color: AppColors.textPrimary),
// // // // // // // //           titleSmall: TextStyle(color: AppColors.textPrimary),
// // // // // // // //           bodyLarge: TextStyle(color: AppColors.textPrimary),
// // // // // // // //           bodyMedium: TextStyle(color: AppColors.textPrimary),
// // // // // // // //           bodySmall: TextStyle(color: AppColors.textSecondary),
// // // // // // // //           labelLarge: TextStyle(color: AppColors.buttonText), // For button text
// // // // // // // //           labelMedium: TextStyle(color: AppColors.textSecondary),
// // // // // // // //           labelSmall: TextStyle(color: AppColors.textSecondary),
// // // // // // // //         ),
// // // // // // // //         inputDecorationTheme: InputDecorationTheme(
// // // // // // // //           labelStyle: const TextStyle(color: AppColors.textSecondary),
// // // // // // // //           enabledBorder: OutlineInputBorder(
// // // // // // // //             borderRadius: BorderRadius.circular(10.0),
// // // // // // // //             borderSide: const BorderSide(color: AppColors.border),
// // // // // // // //           ),
// // // // // // // //           focusedBorder: OutlineInputBorder(
// // // // // // // //             borderRadius: BorderRadius.circular(10.0),
// // // // // // // //             borderSide: const BorderSide(color: AppColors.primary),
// // // // // // // //           ),
// // // // // // // //           border: OutlineInputBorder(
// // // // // // // //             borderRadius: BorderRadius.circular(10.0),
// // // // // // // //             borderSide: const BorderSide(color: AppColors.border),
// // // // // // // //           ),
// // // // // // // //           filled: true,
// // // // // // // //           fillColor: AppColors.chip, // Use chip color for input background
// // // // // // // //         ),
// // // // // // // //         elevatedButtonTheme: ElevatedButtonThemeData(
// // // // // // // //           style: ElevatedButton.styleFrom(
// // // // // // // //             shape: RoundedRectangleBorder(
// // // // // // // //               borderRadius: BorderRadius.circular(8.0),
// // // // // // // //             ),
// // // // // // // //             padding: const EdgeInsets.symmetric(vertical: 10.0),
// // // // // // // //           ),
// // // // // // // //         ),
// // // // // // // //         cardTheme: CardThemeData(
// // // // // // // //           color: AppColors.card,
// // // // // // // //           elevation: 2,
// // // // // // // //           shape: RoundedRectangleBorder(
// // // // // // // //             borderRadius: BorderRadius.circular(10.0),
// // // // // // // //           ),
// // // // // // // //         ),
// // // // // // // //         dividerColor: AppColors.border,
// // // // // // // //         // Customize dropdown menu button text color
// // // // // // // //         // This affects the selected item's text color when dropdown is closed
// // // // // // // //         dropdownMenuTheme: DropdownMenuThemeData(
// // // // // // // //           textStyle: const TextStyle(color: AppColors.textPrimary),
// // // // // // // //           menuStyle: MenuStyle(
// // // // // // // //             backgroundColor: MaterialStateProperty.all(AppColors.card),
// // // // // // // //           ),
// // // // // // // //         ),
// // // // // // // //       ),
// // // // // // // //       child: Scaffold(
// // // // // // // //         appBar: AppBar(
// // // // // // // //           title: const Text(
// // // // // // // //             'Ledger',
// // // // // // // //             style: TextStyle(
// // // // // // // //               fontWeight: FontWeight.bold,
// // // // // // // //               fontSize: 22,
// // // // // // // //             ),
// // // // // // // //           ),
// // // // // // // //           centerTitle: true,
// // // // // // // //         ),
// // // // // // // //         body: transactionsAsync.when(
// // // // // // // //           loading: () => const Center(child: CircularProgressIndicator()),
// // // // // // // //           error: (e, st) => Center(
// // // // // // // //               child: Text('Error: $e',
// // // // // // // //                   style: const TextStyle(color: AppColors.delete))),
// // // // // // // //           data: (transactions) {
// // // // // // // //             List<TransactionModel> filtered = transactions;

// // // // // // // //             final List<String> categories = {
// // // // // // // //               'All',
// // // // // // // //               ...transactions.map((tx) => tx.category ?? '')
// // // // // // // //             }.where((category) => category.isNotEmpty).toList();
// // // // // // // //             categories.sort();
// // // // // // // //             if (categories.contains('All')) {
// // // // // // // //               categories.remove('All');
// // // // // // // //             }
// // // // // // // //             categories.insert(0, 'All');

// // // // // // // //             final List<String> accounts = {
// // // // // // // //               'All',
// // // // // // // //               ...transactions.map((tx) => tx.account ?? '')
// // // // // // // //             }.where((account) => account.isNotEmpty).toList();
// // // // // // // //             accounts.sort();
// // // // // // // //             if (accounts.contains('All')) {
// // // // // // // //               accounts.remove('All');
// // // // // // // //             }
// // // // // // // //             accounts.insert(0, 'All');

// // // // // // // //             DateTime start;
// // // // // // // //             DateTime end;
// // // // // // // //             String dateRangeDisplay = '';

// // // // // // // //             if (_selectedView == 'Daily') {
// // // // // // // //               start = DateTime(
// // // // // // // //                   _currentDate.year, _currentDate.month, _currentDate.day);
// // // // // // // //               end = start.add(const Duration(days: 1));
// // // // // // // //               dateRangeDisplay = DateFormat.yMMMd().format(_currentDate);
// // // // // // // //             } else if (_selectedView == 'Weekly') {
// // // // // // // //               start = _currentDate
// // // // // // // //                   .subtract(Duration(days: _currentDate.weekday - 1)); // Monday
// // // // // // // //               end = start.add(const Duration(days: 7));
// // // // // // // //               dateRangeDisplay =
// // // // // // // //                   '${DateFormat.yMMMd().format(start)} - ${DateFormat.yMMMd().format(end.subtract(const Duration(days: 1)))}';
// // // // // // // //             } else if (_selectedView == 'Monthly') {
// // // // // // // //               start = DateTime(_currentDate.year, _currentDate.month, 1);
// // // // // // // //               end = DateTime(_currentDate.year, _currentDate.month + 1, 1);
// // // // // // // //               dateRangeDisplay = DateFormat.yMMMM().format(_currentDate);
// // // // // // // //             } else if (_selectedView == 'Custom' && _customRange != null) {
// // // // // // // //               start = _customRange!.start;
// // // // // // // //               end = _customRange!.end.add(const Duration(days: 1));
// // // // // // // //               dateRangeDisplay =
// // // // // // // //                   '${DateFormat.yMMMd().format(_customRange!.start)} - ${DateFormat.yMMMd().format(_customRange!.end)}';
// // // // // // // //             } else {
// // // // // // // //               start = DateTime(2000, 1, 1);
// // // // // // // //               end = DateTime(2100, 1, 1);
// // // // // // // //               dateRangeDisplay = 'All Time';
// // // // // // // //             }

// // // // // // // //             filtered = filtered.where((tx) {
// // // // // // // //               final txDate = tx.date ?? DateTime.now();
// // // // // // // //               final matchesCategory = _selectedCategory == 'All' ||
// // // // // // // //                   (tx.category ?? '') == _selectedCategory;
// // // // // // // //               final matchesAccount = _selectedAccount == 'All' ||
// // // // // // // //                   (tx.account ?? '') == _selectedAccount;

// // // // // // // //               return txDate.isAfter(
// // // // // // // //                       start.subtract(const Duration(milliseconds: 1))) &&
// // // // // // // //                   txDate.isBefore(end) &&
// // // // // // // //                   matchesCategory &&
// // // // // // // //                   matchesAccount;
// // // // // // // //             }).toList();

// // // // // // // //             filtered.sort((a, b) =>
// // // // // // // //                 (b.date ?? DateTime.now()).compareTo(a.date ?? DateTime.now()));

// // // // // // // //             final incomeTotal = filtered
// // // // // // // //                 .where((tx) => tx.type == TransactionType.income)
// // // // // // // //                 .fold<double>(0, (sum, tx) => sum + (tx.amount ?? 0));
// // // // // // // //             final expenseTotal = filtered
// // // // // // // //                 .where((tx) => tx.type == TransactionType.expense)
// // // // // // // //                 .fold<double>(0, (sum, tx) => sum + (tx.amount ?? 0));
// // // // // // // //             final net = incomeTotal - expenseTotal;

// // // // // // // //             return Column(
// // // // // // // //               children: [
// // // // // // // //                 Padding(
// // // // // // // //                   padding: const EdgeInsets.all(16.0),
// // // // // // // //                   child: Row(
// // // // // // // //                     children: [
// // // // // // // //                       Expanded(
// // // // // // // //                         child: DropdownButtonFormField<String>(
// // // // // // // //                           value: _selectedCategory,
// // // // // // // //                           decoration: const InputDecoration(
// // // // // // // //                             labelText: 'Category',
// // // // // // // //                             // Styles are applied via ThemeData
// // // // // // // //                           ),
// // // // // // // //                           items: categories.map((cat) {
// // // // // // // //                             return DropdownMenuItem(
// // // // // // // //                               value: cat,
// // // // // // // //                               child: Text(
// // // // // // // //                                 cat == 'All'
// // // // // // // //                                     ? 'All Categories'
// // // // // // // //                                     : (cat.isEmpty ? 'Uncategorized' : cat),
// // // // // // // //                                 style: const TextStyle(fontSize: 14),
// // // // // // // //                               ),
// // // // // // // //                             );
// // // // // // // //                           }).toList(),
// // // // // // // //                           onChanged: (value) {
// // // // // // // //                             if (value != null) {
// // // // // // // //                               setState(() => _selectedCategory = value);
// // // // // // // //                             }
// // // // // // // //                           },
// // // // // // // //                           // Ensure the selected item's text color is primary
// // // // // // // //                           selectedItemBuilder: (BuildContext context) {
// // // // // // // //                             return categories.map((String value) {
// // // // // // // //                               return Text(
// // // // // // // //                                 value == 'All'
// // // // // // // //                                     ? 'All Categories'
// // // // // // // //                                     : (value.isEmpty ? 'Uncategorized' : value),
// // // // // // // //                                 style: TextStyle(
// // // // // // // //                                     color: Theme.of(context)
// // // // // // // //                                         .textTheme
// // // // // // // //                                         .bodyLarge
// // // // // // // //                                         ?.color),
// // // // // // // //                               );
// // // // // // // //                             }).toList();
// // // // // // // //                           },
// // // // // // // //                         ),
// // // // // // // //                       ),
// // // // // // // //                       const SizedBox(width: 12),
// // // // // // // //                       Expanded(
// // // // // // // //                         child: DropdownButtonFormField<String>(
// // // // // // // //                           value: _selectedAccount,
// // // // // // // //                           decoration: const InputDecoration(
// // // // // // // //                             labelText: 'Account',
// // // // // // // //                             // Styles are applied via ThemeData
// // // // // // // //                           ),
// // // // // // // //                           items: accounts.map((acc) {
// // // // // // // //                             return DropdownMenuItem(
// // // // // // // //                               value: acc,
// // // // // // // //                               child: Text(
// // // // // // // //                                 acc == 'All'
// // // // // // // //                                     ? 'All Accounts'
// // // // // // // //                                     : (acc.isEmpty ? 'Unnamed' : acc),
// // // // // // // //                                 style: const TextStyle(fontSize: 14),
// // // // // // // //                               ),
// // // // // // // //                             );
// // // // // // // //                           }).toList(),
// // // // // // // //                           onChanged: (value) {
// // // // // // // //                             if (value != null) {
// // // // // // // //                               setState(() => _selectedAccount = value);
// // // // // // // //                             }
// // // // // // // //                           },
// // // // // // // //                           // Ensure the selected item's text color is primary
// // // // // // // //                           selectedItemBuilder: (BuildContext context) {
// // // // // // // //                             return accounts.map((String value) {
// // // // // // // //                               return Text(
// // // // // // // //                                 value == 'All'
// // // // // // // //                                     ? 'All Accounts'
// // // // // // // //                                     : (value.isEmpty ? 'Unnamed' : value),
// // // // // // // //                                 style: TextStyle(
// // // // // // // //                                     color: Theme.of(context)
// // // // // // // //                                         .textTheme
// // // // // // // //                                         .bodyLarge
// // // // // // // //                                         ?.color),
// // // // // // // //                               );
// // // // // // // //                             }).toList();
// // // // // // // //                           },
// // // // // // // //                         ),
// // // // // // // //                       ),
// // // // // // // //                     ],
// // // // // // // //                   ),
// // // // // // // //                 ),
// // // // // // // //                 Padding(
// // // // // // // //                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
// // // // // // // //                   child: Row(
// // // // // // // //                     children: _views.map((view) {
// // // // // // // //                       final isSelected = _selectedView == view;
// // // // // // // //                       return Expanded(
// // // // // // // //                         child: Padding(
// // // // // // // //                           padding: const EdgeInsets.symmetric(horizontal: 4.0),
// // // // // // // //                           child: ElevatedButton(
// // // // // // // //                             style: ElevatedButton.styleFrom(
// // // // // // // //                               backgroundColor: isSelected
// // // // // // // //                                   ? AppColors.primary
// // // // // // // //                                   : AppColors.chip, // Use AppColors
// // // // // // // //                               foregroundColor: isSelected
// // // // // // // //                                   ? AppColors.buttonText
// // // // // // // //                                   : AppColors.textPrimary, // Use AppColors
// // // // // // // //                               elevation: isSelected ? 4 : 0,
// // // // // // // //                               shadowColor: isSelected
// // // // // // // //                                   ? AppColors.primary.withOpacity(0.3)
// // // // // // // //                                   : Colors.transparent,
// // // // // // // //                             ),
// // // // // // // //                             onPressed: () async {
// // // // // // // //                               if (view == 'Custom') {
// // // // // // // //                                 final picked = await showDateRangePicker(
// // // // // // // //                                   context: context,
// // // // // // // //                                   firstDate: DateTime(2000),
// // // // // // // //                                   lastDate: DateTime(2100),
// // // // // // // //                                   helpText: 'Select Custom Date Range',
// // // // // // // //                                   confirmText: 'Confirm',
// // // // // // // //                                   cancelText: 'Cancel',
// // // // // // // //                                   builder: (context, child) {
// // // // // // // //                                     return Theme(
// // // // // // // //                                       data: ThemeData.dark().copyWith(
// // // // // // // //                                         // Use dark theme for picker
// // // // // // // //                                         primaryColor: AppColors.primary,
// // // // // // // //                                         colorScheme: ColorScheme.dark(
// // // // // // // //                                           primary: AppColors.primary,
// // // // // // // //                                           onPrimary: AppColors
// // // // // // // //                                               .buttonText, // Text on primary background
// // // // // // // //                                           surface: AppColors
// // // // // // // //                                               .card, // Picker background
// // // // // // // //                                           onSurface: AppColors
// // // // // // // //                                               .textPrimary, // Text on picker background
// // // // // // // //                                         ),
// // // // // // // //                                         textTheme: const TextTheme(
// // // // // // // //                                           titleLarge: TextStyle(
// // // // // // // //                                               color: AppColors
// // // // // // // //                                                   .textPrimary), // Year/Month title
// // // // // // // //                                           bodyLarge: TextStyle(
// // // // // // // //                                               color: AppColors
// // // // // // // //                                                   .textPrimary), // Day numbers
// // // // // // // //                                           labelLarge: TextStyle(
// // // // // // // //                                               color: AppColors
// // // // // // // //                                                   .textPrimary), // Button text (CANCEL/OK)
// // // // // // // //                                         ),
// // // // // // // //                                         dialogBackgroundColor:
// // // // // // // //                                             AppColors.background,
// // // // // // // //                                       ),
// // // // // // // //                                       child: child!,
// // // // // // // //                                     );
// // // // // // // //                                   },
// // // // // // // //                                 );
// // // // // // // //                                 if (picked != null) {
// // // // // // // //                                   setState(() {
// // // // // // // //                                     _customRange = picked;
// // // // // // // //                                     _selectedView = view;
// // // // // // // //                                   });
// // // // // // // //                                 }
// // // // // // // //                               } else {
// // // // // // // //                                 setState(() {
// // // // // // // //                                   _selectedView = view;
// // // // // // // //                                   // When switching to a non-custom view, reset _currentDate to now for consistency
// // // // // // // //                                   // unless it's already set for that specific period (handled by _moveDate functions)
// // // // // // // //                                   if (view == 'Daily' &&
// // // // // // // //                                           _currentDate.day !=
// // // // // // // //                                               DateTime.now().day ||
// // // // // // // //                                       view == 'Weekly' &&
// // // // // // // //                                           _currentDate.weekday !=
// // // // // // // //                                               DateTime.now().weekday ||
// // // // // // // //                                       view == 'Monthly' &&
// // // // // // // //                                           _currentDate.month !=
// // // // // // // //                                               DateTime.now().month) {
// // // // // // // //                                     _currentDate = DateTime.now();
// // // // // // // //                                   }
// // // // // // // //                                 });
// // // // // // // //                               }
// // // // // // // //                             },
// // // // // // // //                             child: Text(view,
// // // // // // // //                                 style: const TextStyle(
// // // // // // // //                                     fontSize: 13, fontWeight: FontWeight.w500)),
// // // // // // // //                           ),
// // // // // // // //                         ),
// // // // // // // //                       );
// // // // // // // //                     }).toList(),
// // // // // // // //                   ),
// // // // // // // //                 ),
// // // // // // // //                 const SizedBox(height: 12), // Adjusted spacing

// // // // // // // //                 // Date Navigation Row
// // // // // // // //                 if (_selectedView != 'Total' && _selectedView != 'Custom')
// // // // // // // //                   Padding(
// // // // // // // //                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
// // // // // // // //                     child: Row(
// // // // // // // //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // // // // // //                       children: [
// // // // // // // //                         IconButton(
// // // // // // // //                           icon: const Icon(Icons.arrow_back_ios, size: 18),
// // // // // // // //                           color: AppColors.textPrimary,
// // // // // // // //                           onPressed: () {
// // // // // // // //                             if (_selectedView == 'Daily') _moveDate(-1);
// // // // // // // //                             if (_selectedView == 'Weekly') _moveWeek(-1);
// // // // // // // //                             if (_selectedView == 'Monthly') _moveMonth(-1);
// // // // // // // //                           },
// // // // // // // //                         ),
// // // // // // // //                         Expanded(
// // // // // // // //                           child: Center(
// // // // // // // //                             child: Text(
// // // // // // // //                               dateRangeDisplay,
// // // // // // // //                               style: const TextStyle(
// // // // // // // //                                 fontSize: 16,
// // // // // // // //                                 fontWeight: FontWeight.bold,
// // // // // // // //                                 color: AppColors.textPrimary,
// // // // // // // //                               ),
// // // // // // // //                             ),
// // // // // // // //                           ),
// // // // // // // //                         ),
// // // // // // // //                         IconButton(
// // // // // // // //                           icon: const Icon(Icons.arrow_forward_ios, size: 18),
// // // // // // // //                           color: AppColors.textPrimary,
// // // // // // // //                           onPressed: () {
// // // // // // // //                             if (_selectedView == 'Daily') _moveDate(1);
// // // // // // // //                             if (_selectedView == 'Weekly') _moveWeek(1);
// // // // // // // //                             if (_selectedView == 'Monthly') _moveMonth(1);
// // // // // // // //                           },
// // // // // // // //                         ),
// // // // // // // //                       ],
// // // // // // // //                     ),
// // // // // // // //                   ),
// // // // // // // //                 const SizedBox(height: 12), // Spacing after date navigation

// // // // // // // //                 Container(
// // // // // // // //                   margin: const EdgeInsets.symmetric(horizontal: 16.0),
// // // // // // // //                   padding: const EdgeInsets.all(16.0),
// // // // // // // //                   decoration: BoxDecoration(
// // // // // // // //                     color: AppColors.card, // Use AppColors
// // // // // // // //                     borderRadius: BorderRadius.circular(12.0),
// // // // // // // //                     boxShadow: [
// // // // // // // //                       BoxShadow(
// // // // // // // //                         color: Colors.black
// // // // // // // //                             .withOpacity(0.2), // Darker shadow for dark theme
// // // // // // // //                         spreadRadius: 1,
// // // // // // // //                         blurRadius: 5,
// // // // // // // //                         offset: const Offset(0, 3),
// // // // // // // //                       ),
// // // // // // // //                     ],
// // // // // // // //                   ),
// // // // // // // //                   child: Row(
// // // // // // // //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// // // // // // // //                     children: [
// // // // // // // //                       _buildSummaryTile('Income', incomeTotal,
// // // // // // // //                           Colors.greenAccent.shade400), // Brighter green
// // // // // // // //                       _buildSummaryTile('Expense', expenseTotal,
// // // // // // // //                           Colors.redAccent.shade400), // Brighter red
// // // // // // // //                       _buildSummaryTile(
// // // // // // // //                           'Net',
// // // // // // // //                           net,
// // // // // // // //                           net >= 0
// // // // // // // //                               ? AppColors.primary
// // // // // // // //                               : Colors.redAccent
// // // // // // // //                                   .shade400), // Use primary for net positive
// // // // // // // //                     ],
// // // // // // // //                   ),
// // // // // // // //                 ),
// // // // // // // //                 const SizedBox(height: 16),
// // // // // // // //                 const Padding(
// // // // // // // //                   padding: EdgeInsets.symmetric(horizontal: 16.0),
// // // // // // // //                   child: Align(
// // // // // // // //                     alignment: Alignment.centerLeft,
// // // // // // // //                     child: Text(
// // // // // // // //                       'Transactions',
// // // // // // // //                       style: TextStyle(
// // // // // // // //                         fontSize: 18,
// // // // // // // //                         fontWeight: FontWeight.bold,
// // // // // // // //                         color: AppColors.textPrimary,
// // // // // // // //                       ),
// // // // // // // //                     ),
// // // // // // // //                   ),
// // // // // // // //                 ),
// // // // // // // //                 const Divider(
// // // // // // // //                     height: 24, thickness: 1, color: AppColors.border),
// // // // // // // //                 Expanded(
// // // // // // // //                   child: filtered.isEmpty
// // // // // // // //                       ? Center(
// // // // // // // //                           child: Column(
// // // // // // // //                             mainAxisAlignment: MainAxisAlignment.center,
// // // // // // // //                             children: [
// // // // // // // //                               Icon(Icons.receipt_long,
// // // // // // // //                                   size: 60, color: AppColors.textSecondary),
// // // // // // // //                               const SizedBox(height: 10),
// // // // // // // //                               Text(
// // // // // // // //                                 'No transactions found for this period.',
// // // // // // // //                                 style: TextStyle(
// // // // // // // //                                   fontSize: 16,
// // // // // // // //                                   color: AppColors.textSecondary,
// // // // // // // //                                 ),
// // // // // // // //                               ),
// // // // // // // //                             ],
// // // // // // // //                           ),
// // // // // // // //                         )
// // // // // // // //                       : ListView.builder(
// // // // // // // //                           itemCount: filtered.length,
// // // // // // // //                           itemBuilder: (context, index) {
// // // // // // // //                             final tx = filtered[index];
// // // // // // // //                             return Card(
// // // // // // // //                               margin: const EdgeInsets.symmetric(
// // // // // // // //                                   horizontal: 16, vertical: 6),
// // // // // // // //                               elevation: 2,
// // // // // // // //                               child: ListTile(
// // // // // // // //                                 contentPadding: const EdgeInsets.symmetric(
// // // // // // // //                                     horizontal: 16.0, vertical: 8.0),
// // // // // // // //                                 leading: CircleAvatar(
// // // // // // // //                                   backgroundColor: tx.type ==
// // // // // // // //                                           TransactionType.income
// // // // // // // //                                       ? Colors.green
// // // // // // // //                                           .shade800 // Darker shade for income background
// // // // // // // //                                       : Colors.red
// // // // // // // //                                           .shade800, // Darker shade for expense background
// // // // // // // //                                   child: Icon(
// // // // // // // //                                     tx.type == TransactionType.income
// // // // // // // //                                         ? Icons.arrow_downward_rounded
// // // // // // // //                                         : Icons.arrow_upward_rounded,
// // // // // // // //                                     color: tx.type == TransactionType.income
// // // // // // // //                                         ? Colors.greenAccent
// // // // // // // //                                             .shade100 // Brighter icon
// // // // // // // //                                         : Colors.redAccent
// // // // // // // //                                             .shade100, // Brighter icon
// // // // // // // //                                   ),
// // // // // // // //                                 ),
// // // // // // // //                                 title: Text(
// // // // // // // //                                   tx.title ?? 'No Title',
// // // // // // // //                                   style: const TextStyle(
// // // // // // // //                                     fontWeight: FontWeight.bold,
// // // // // // // //                                     fontSize: 16,
// // // // // // // //                                     color: AppColors
// // // // // // // //                                         .cardText, // White text for titles on cards
// // // // // // // //                                   ),
// // // // // // // //                                 ),
// // // // // // // //                                 subtitle: Text(
// // // // // // // //                                   '${DateFormat('MMM d, y').format(tx.date ?? DateTime.now())} • ${tx.account ?? 'N/A'} • ${tx.category ?? 'N/A'}',
// // // // // // // //                                   style: const TextStyle(
// // // // // // // //                                     fontSize: 12,
// // // // // // // //                                     color: AppColors.textSecondary,
// // // // // // // //                                   ),
// // // // // // // //                                 ),
// // // // // // // //                                 trailing: Text(
// // // // // // // //                                   '₹${tx.amount?.toStringAsFixed(2)}',
// // // // // // // //                                   style: TextStyle(
// // // // // // // //                                     fontWeight: FontWeight.w800,
// // // // // // // //                                     fontSize: 16,
// // // // // // // //                                     color: tx.type == TransactionType.income
// // // // // // // //                                         ? Colors.greenAccent.shade400
// // // // // // // //                                         : Colors.redAccent.shade400,
// // // // // // // //                                   ),
// // // // // // // //                                 ),
// // // // // // // //                               ),
// // // // // // // //                             );
// // // // // // // //                           },
// // // // // // // //                         ),
// // // // // // // //                 ),
// // // // // // // //               ],
// // // // // // // //             );
// // // // // // // //           },
// // // // // // // //         ),
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   Widget _buildSummaryTile(String label, double amount, Color color) {
// // // // // // // //     return Column(
// // // // // // // //       children: [
// // // // // // // //         Text(
// // // // // // // //           label,
// // // // // // // //           style: const TextStyle(
// // // // // // // //             fontWeight: FontWeight.bold,
// // // // // // // //             fontSize: 14,
// // // // // // // //             color: AppColors.textSecondary, // Use secondary text color
// // // // // // // //           ),
// // // // // // // //         ),
// // // // // // // //         const SizedBox(height: 4),
// // // // // // // //         Text(
// // // // // // // //           '₹${amount.toStringAsFixed(2)}',
// // // // // // // //           style: TextStyle(
// // // // // // // //             color: color,
// // // // // // // //             fontSize: 18,
// // // // // // // //             fontWeight: FontWeight.w800,
// // // // // // // //           ),
// // // // // // // //         ),
// // // // // // // //       ],
// // // // // // // //     );
// // // // // // // //   }
// // // // // // // // }

// // // // // // // import 'package:flutter/material.dart';
// // // // // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // // // // import 'package:intl/intl.dart';
// // // // // // // import 'package:notegoexpense/model/transaction_notifier.dart';
// // // // // // // import '../model/transaction_model.dart';
// // // // // // // import '../extras/AppColors.dart'; // Import your custom AppColors

// // // // // // // // Helper class to represent items in the grouped list (either a date header or a transaction)
// // // // // // // class GroupedTransactionItem {
// // // // // // //   final DateTime? date; // For date headers
// // // // // // //   final TransactionModel? transaction; // For transaction items

// // // // // // //   GroupedTransactionItem.date(this.date) : transaction = null;
// // // // // // //   GroupedTransactionItem.transaction(this.transaction) : date = null;

// // // // // // //   bool get isDateHeader => date != null;
// // // // // // //   bool get isTransaction => transaction != null;
// // // // // // // }

// // // // // // // class LedgerPage extends ConsumerStatefulWidget {
// // // // // // //   const LedgerPage({super.key});

// // // // // // //   @override
// // // // // // //   ConsumerState<LedgerPage> createState() => _LedgerPageState();
// // // // // // // }

// // // // // // // class _LedgerPageState extends ConsumerState<LedgerPage> {
// // // // // // //   String _selectedView = 'Daily';
// // // // // // //   DateTimeRange? _customRange;
// // // // // // //   DateTime _currentDate =
// // // // // // //       DateTime.now(); // Renamed _today to _currentDate for clarity

// // // // // // //   String _selectedCategory = 'All';
// // // // // // //   String _selectedAccount = 'All';

// // // // // // //   final List<String> _views = ['Daily', 'Weekly', 'Monthly', 'Total', 'Custom'];

// // // // // // //   // Function to move the date range for Daily/Weekly/Monthly views
// // // // // // //   void _navigatePeriod(int amount, String viewType) {
// // // // // // //     setState(() {
// // // // // // //       if (viewType == 'Daily') {
// // // // // // //         _currentDate = _currentDate.add(Duration(days: amount));
// // // // // // //       } else if (viewType == 'Weekly') {
// // // // // // //         _currentDate = _currentDate.add(Duration(days: amount * 7));
// // // // // // //       } else if (viewType == 'Monthly') {
// // // // // // //         // Correctly handle month addition/subtraction
// // // // // // //         _currentDate = DateTime(
// // // // // // //           _currentDate.year,
// // // // // // //           _currentDate.month + amount,
// // // // // // //           // Clamp day to prevent overflow to next month (e.g., Feb 30th -> Mar 2nd)
// // // // // // //           _currentDate.day.clamp(
// // // // // // //               1,
// // // // // // //               DateTime(_currentDate.year, _currentDate.month + amount + 1, 0)
// // // // // // //                   .day),
// // // // // // //         );
// // // // // // //       }
// // // // // // //     });
// // // // // // //   }

// // // // // // //   // Helper method to group transactions by date for display
// // // // // // //   List<GroupedTransactionItem> _getGroupedTransactionItems(
// // // // // // //       List<TransactionModel> transactions) {
// // // // // // //     final List<GroupedTransactionItem> items = [];
// // // // // // //     if (transactions.isEmpty) return items;

// // // // // // //     // Sort by date descending
// // // // // // //     transactions.sort((a, b) =>
// // // // // // //         (b.date ?? DateTime.now()).compareTo(a.date ?? DateTime.now()));

// // // // // // //     DateTime? lastDateHeader;
// // // // // // //     for (var tx in transactions) {
// // // // // // //       final txDate = tx.date ?? DateTime.now();
// // // // // // //       // Normalize txDate to just year, month, day for comparison
// // // // // // //       final normalizedTxDate = DateTime(txDate.year, txDate.month, txDate.day);

// // // // // // //       // Add a date header if it's a new day or the first transaction
// // // // // // //       // Check if lastDateHeader is different from normalizedTxDate
// // // // // // //       if (lastDateHeader == null ||
// // // // // // //           !normalizedTxDate.isAtSameMomentAs(lastDateHeader)) {
// // // // // // //         items.add(GroupedTransactionItem.date(normalizedTxDate));
// // // // // // //         lastDateHeader = normalizedTxDate;
// // // // // // //       }
// // // // // // //       items.add(GroupedTransactionItem.transaction(tx));
// // // // // // //     }
// // // // // // //     return items;
// // // // // // //   }

// // // // // // //   @override
// // // // // // //   Widget build(BuildContext context) {
// // // // // // //     final transactionsAsync = ref.watch(transactionsProvider);

// // // // // // //     return Theme(
// // // // // // //       // Wrap with Theme to apply AppColors
// // // // // // //       data: ThemeData(
// // // // // // //         brightness: Brightness.dark, // Set to dark theme
// // // // // // //         scaffoldBackgroundColor: AppColors.background,
// // // // // // //         cardColor: AppColors.card,
// // // // // // //         primaryColor: AppColors.primary,
// // // // // // //         hintColor: AppColors.textSecondary, // For labels in input fields
// // // // // // //         appBarTheme: const AppBarTheme(
// // // // // // //           backgroundColor: AppColors.background,
// // // // // // //           foregroundColor: AppColors.textPrimary,
// // // // // // //           elevation: 1,
// // // // // // //         ),
// // // // // // //         textTheme: const TextTheme(
// // // // // // //           displayLarge: TextStyle(color: AppColors.textPrimary),
// // // // // // //           displayMedium: TextStyle(color: AppColors.textPrimary),
// // // // // // //           displaySmall: TextStyle(color: AppColors.textPrimary),
// // // // // // //           headlineLarge: TextStyle(color: AppColors.textPrimary),
// // // // // // //           headlineMedium: TextStyle(color: AppColors.textPrimary),
// // // // // // //           headlineSmall: TextStyle(color: AppColors.textPrimary),
// // // // // // //           titleLarge: TextStyle(color: AppColors.textPrimary),
// // // // // // //           titleMedium: TextStyle(color: AppColors.textPrimary),
// // // // // // //           titleSmall: TextStyle(color: AppColors.textPrimary),
// // // // // // //           bodyLarge: TextStyle(color: AppColors.textPrimary),
// // // // // // //           bodyMedium: TextStyle(color: AppColors.textPrimary),
// // // // // // //           bodySmall: TextStyle(color: AppColors.textSecondary),
// // // // // // //           labelLarge: TextStyle(color: AppColors.buttonText), // For button text
// // // // // // //           labelMedium: TextStyle(color: AppColors.textSecondary),
// // // // // // //           labelSmall: TextStyle(color: AppColors.textSecondary),
// // // // // // //         ),
// // // // // // //         inputDecorationTheme: InputDecorationTheme(
// // // // // // //           labelStyle: const TextStyle(color: AppColors.textSecondary),
// // // // // // //           enabledBorder: OutlineInputBorder(
// // // // // // //             borderRadius: BorderRadius.circular(10.0),
// // // // // // //             borderSide: const BorderSide(color: AppColors.border),
// // // // // // //           ),
// // // // // // //           focusedBorder: OutlineInputBorder(
// // // // // // //             borderRadius: BorderRadius.circular(10.0),
// // // // // // //             borderSide: const BorderSide(color: AppColors.primary),
// // // // // // //           ),
// // // // // // //           border: OutlineInputBorder(
// // // // // // //             borderRadius: BorderRadius.circular(10.0),
// // // // // // //             borderSide: const BorderSide(color: AppColors.border),
// // // // // // //           ),
// // // // // // //           filled: true,
// // // // // // //           fillColor: AppColors.chip, // Use chip color for input background
// // // // // // //         ),
// // // // // // //         elevatedButtonTheme: ElevatedButtonThemeData(
// // // // // // //           style: ElevatedButton.styleFrom(
// // // // // // //             shape: RoundedRectangleBorder(
// // // // // // //               borderRadius: BorderRadius.circular(8.0),
// // // // // // //             ),
// // // // // // //             padding: const EdgeInsets.symmetric(vertical: 10.0),
// // // // // // //           ),
// // // // // // //         ),
// // // // // // //         cardTheme: CardThemeData(
// // // // // // //           color: AppColors.card,
// // // // // // //           elevation: 2,
// // // // // // //           shape: RoundedRectangleBorder(
// // // // // // //             borderRadius: BorderRadius.circular(10.0),
// // // // // // //           ),
// // // // // // //         ),
// // // // // // //         dividerColor: AppColors.border,
// // // // // // //         // Customize dropdown menu button text color
// // // // // // //         dropdownMenuTheme: DropdownMenuThemeData(
// // // // // // //           textStyle: const TextStyle(
// // // // // // //               color: AppColors
// // // // // // //                   .textPrimary), // Text color of selected item in dropdown
// // // // // // //           menuStyle: MenuStyle(
// // // // // // //             backgroundColor: MaterialStateProperty.all(
// // // // // // //                 AppColors.card), // Background of dropdown menu itself
// // // // // // //           ),
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //       child: Scaffold(
// // // // // // //         appBar: AppBar(
// // // // // // //           title: const Text(
// // // // // // //             'Ledger',
// // // // // // //             style: TextStyle(
// // // // // // //               fontWeight: FontWeight.bold,
// // // // // // //               fontSize: 22,
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //           centerTitle: true,
// // // // // // //         ),
// // // // // // //         body: transactionsAsync.when(
// // // // // // //           loading: () => const Center(child: CircularProgressIndicator()),
// // // // // // //           error: (e, st) => Center(
// // // // // // //               child: Text('Error: $e',
// // // // // // //                   style: const TextStyle(color: AppColors.delete))),
// // // // // // //           data: (transactions) {
// // // // // // //             List<TransactionModel> filtered = transactions;

// // // // // // //             // Corrected categories and accounts generation to prevent duplicates of 'All'
// // // // // // //             final List<String> categories = {
// // // // // // //               'All', // Start with 'All' in the set
// // // // // // //               ...transactions.map((tx) => tx.category ?? '')
// // // // // // //             }
// // // // // // //                 .where((category) =>
// // // // // // //                     category.isNotEmpty) // Filter out empty strings if any
// // // // // // //                 .toList();
// // // // // // //             categories
// // // // // // //                 .sort(); // Sort the existing unique elements (including 'All')

// // // // // // //             // Ensure 'All' is at the very beginning and only once
// // // // // // //             if (categories.contains('All')) {
// // // // // // //               categories
// // // // // // //                   .remove('All'); // Remove if it was sorted somewhere else
// // // // // // //             }
// // // // // // //             categories.insert(0, 'All'); // Add it back at the beginning

// // // // // // //             final List<String> accounts = {
// // // // // // //               'All', // Start with 'All' in the set
// // // // // // //               ...transactions.map((tx) => tx.account ?? '')
// // // // // // //             }
// // // // // // //                 .where((account) =>
// // // // // // //                     account.isNotEmpty) // Filter out empty strings if any
// // // // // // //                 .toList();
// // // // // // //             accounts
// // // // // // //                 .sort(); // Sort the existing unique elements (including 'All')

// // // // // // //             // Ensure 'All' is at the very beginning and only once
// // // // // // //             if (accounts.contains('All')) {
// // // // // // //               accounts.remove('All'); // Remove if it was sorted somewhere else
// // // // // // //             }
// // // // // // //             accounts.insert(0, 'All'); // Add it back at the beginning

// // // // // // //             DateTime start;
// // // // // // //             DateTime end;
// // // // // // //             String dateRangeDisplay = '';

// // // // // // //             if (_selectedView == 'Daily') {
// // // // // // //               start = DateTime(
// // // // // // //                   _currentDate.year, _currentDate.month, _currentDate.day);
// // // // // // //               end = start.add(const Duration(days: 1));
// // // // // // //               dateRangeDisplay = DateFormat.yMMMd().format(_currentDate);
// // // // // // //             } else if (_selectedView == 'Weekly') {
// // // // // // //               // Calculate start of the week (Monday)
// // // // // // //               start = _currentDate
// // // // // // //                   .subtract(Duration(days: _currentDate.weekday - 1));
// // // // // // //               end = start.add(const Duration(days: 7));
// // // // // // //               dateRangeDisplay =
// // // // // // //                   '${DateFormat.yMMMd().format(start)} - ${DateFormat.yMMMd().format(end.subtract(const Duration(days: 1)))}';
// // // // // // //             } else if (_selectedView == 'Monthly') {
// // // // // // //               start = DateTime(_currentDate.year, _currentDate.month, 1);
// // // // // // //               end = DateTime(_currentDate.year, _currentDate.month + 1, 1);
// // // // // // //               dateRangeDisplay = DateFormat.yMMMM().format(_currentDate);
// // // // // // //             } else if (_selectedView == 'Custom' && _customRange != null) {
// // // // // // //               start = _customRange!.start;
// // // // // // //               // The end date from showDateRangePicker is inclusive, so add 1 day to make it exclusive for filtering
// // // // // // //               end = _customRange!.end.add(const Duration(days: 1));
// // // // // // //               dateRangeDisplay =
// // // // // // //                   '${DateFormat.yMMMd().format(_customRange!.start)} - ${DateFormat.yMMMd().format(_customRange!.end)}';
// // // // // // //             } else {
// // // // // // //               // Total view
// // // // // // //               start = DateTime(2000, 1, 1); // Very old date
// // // // // // //               end = DateTime.now()
// // // // // // //                   .add(const Duration(days: 365 * 10)); // Far future date
// // // // // // //               dateRangeDisplay = 'All Time';
// // // // // // //             }

// // // // // // //             filtered = filtered.where((tx) {
// // // // // // //               final txDate = tx.date ?? DateTime.now();
// // // // // // //               final matchesCategory = _selectedCategory == 'All' ||
// // // // // // //                   (tx.category ?? '') == _selectedCategory;
// // // // // // //               final matchesAccount = _selectedAccount == 'All' ||
// // // // // // //                   (tx.account ?? '') == _selectedAccount;

// // // // // // //               // Ensure comparison is consistent: txDate >= start and txDate < end
// // // // // // //               return txDate.isAfter(
// // // // // // //                       start.subtract(const Duration(milliseconds: 1))) &&
// // // // // // //                   txDate.isBefore(end) &&
// // // // // // //                   matchesCategory &&
// // // // // // //                   matchesAccount;
// // // // // // //             }).toList();

// // // // // // //             final incomeTotal = filtered
// // // // // // //                 .where((tx) => tx.type == TransactionType.income)
// // // // // // //                 .fold<double>(0, (sum, tx) => sum + (tx.amount ?? 0));
// // // // // // //             final expenseTotal = filtered
// // // // // // //                 .where((tx) => tx.type == TransactionType.expense)
// // // // // // //                 .fold<double>(0, (sum, tx) => sum + (tx.amount ?? 0));
// // // // // // //             final net = incomeTotal - expenseTotal;

// // // // // // //             // Get grouped transactions for the ListView
// // // // // // //             final List<GroupedTransactionItem> groupedItems =
// // // // // // //                 _getGroupedTransactionItems(filtered);

// // // // // // //             return Column(
// // // // // // //               children: [
// // // // // // //                 Padding(
// // // // // // //                   padding: const EdgeInsets.all(16.0),
// // // // // // //                   child: Row(
// // // // // // //                     children: [
// // // // // // //                       Expanded(
// // // // // // //                         child: DropdownButtonFormField<String>(
// // // // // // //                           value: _selectedCategory,
// // // // // // //                           isExpanded: true, // Crucial for dropdown overflow fix
// // // // // // //                           decoration: const InputDecoration(
// // // // // // //                             labelText: 'Category',
// // // // // // //                             // Styles are applied via ThemeData
// // // // // // //                           ),
// // // // // // //                           items: categories.map((cat) {
// // // // // // //                             return DropdownMenuItem(
// // // // // // //                               value: cat,
// // // // // // //                               child: Text(
// // // // // // //                                 cat == 'All'
// // // // // // //                                     ? 'All Categories'
// // // // // // //                                     : (cat.isEmpty ? 'Uncategorized' : cat),
// // // // // // //                                 style: const TextStyle(fontSize: 14),
// // // // // // //                                 overflow: TextOverflow
// // // // // // //                                     .ellipsis, // Crucial for dropdown overflow fix
// // // // // // //                               ),
// // // // // // //                             );
// // // // // // //                           }).toList(),
// // // // // // //                           onChanged: (value) {
// // // // // // //                             if (value != null) {
// // // // // // //                               setState(() => _selectedCategory = value);
// // // // // // //                             }
// // // // // // //                           },
// // // // // // //                           // Ensure the selected item's text color is primary
// // // // // // //                           selectedItemBuilder: (BuildContext context) {
// // // // // // //                             return categories.map((String value) {
// // // // // // //                               return Text(
// // // // // // //                                 value == 'All'
// // // // // // //                                     ? 'All Categories'
// // // // // // //                                     : (value.isEmpty ? 'Uncategorized' : value),
// // // // // // //                                 style: TextStyle(
// // // // // // //                                     color: Theme.of(context)
// // // // // // //                                         .textTheme
// // // // // // //                                         .bodyLarge
// // // // // // //                                         ?.color),
// // // // // // //                                 overflow: TextOverflow
// // // // // // //                                     .ellipsis, // Crucial for dropdown overflow fix
// // // // // // //                               );
// // // // // // //                             }).toList();
// // // // // // //                           },
// // // // // // //                         ),
// // // // // // //                       ),
// // // // // // //                       const SizedBox(width: 12),
// // // // // // //                       Expanded(
// // // // // // //                         child: DropdownButtonFormField<String>(
// // // // // // //                           value: _selectedAccount,
// // // // // // //                           isExpanded: true, // Crucial for dropdown overflow fix
// // // // // // //                           decoration: const InputDecoration(
// // // // // // //                             labelText: 'Account',
// // // // // // //                             // Styles are applied via ThemeData
// // // // // // //                           ),
// // // // // // //                           items: accounts.map((acc) {
// // // // // // //                             return DropdownMenuItem(
// // // // // // //                               value: acc,
// // // // // // //                               child: Text(
// // // // // // //                                 acc == 'All'
// // // // // // //                                     ? 'All Accounts'
// // // // // // //                                     : (acc.isEmpty ? 'Unnamed' : acc),
// // // // // // //                                 style: const TextStyle(fontSize: 14),
// // // // // // //                                 overflow: TextOverflow
// // // // // // //                                     .ellipsis, // Crucial for dropdown overflow fix
// // // // // // //                               ),
// // // // // // //                             );
// // // // // // //                           }).toList(),
// // // // // // //                           onChanged: (value) {
// // // // // // //                             if (value != null) {
// // // // // // //                               setState(() => _selectedAccount = value);
// // // // // // //                             }
// // // // // // //                           },
// // // // // // //                           // Ensure the selected item's text color is primary
// // // // // // //                           selectedItemBuilder: (BuildContext context) {
// // // // // // //                             return accounts.map((String value) {
// // // // // // //                               return Text(
// // // // // // //                                 value == 'All'
// // // // // // //                                     ? 'All Accounts'
// // // // // // //                                     : (value.isEmpty ? 'Unnamed' : value),
// // // // // // //                                 style: TextStyle(
// // // // // // //                                     color: Theme.of(context)
// // // // // // //                                         .textTheme
// // // // // // //                                         .bodyLarge
// // // // // // //                                         ?.color),
// // // // // // //                                 overflow: TextOverflow
// // // // // // //                                     .ellipsis, // Crucial for dropdown overflow fix
// // // // // // //                               );
// // // // // // //                             }).toList();
// // // // // // //                           },
// // // // // // //                         ),
// // // // // // //                       ),
// // // // // // //                     ],
// // // // // // //                   ),
// // // // // // //                 ),
// // // // // // //                 Padding(
// // // // // // //                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
// // // // // // //                   child: Row(
// // // // // // //                     children: _views.map((view) {
// // // // // // //                       final isSelected = _selectedView == view;
// // // // // // //                       return Expanded(
// // // // // // //                         child: Padding(
// // // // // // //                           padding: const EdgeInsets.symmetric(horizontal: 4.0),
// // // // // // //                           child: ElevatedButton(
// // // // // // //                             style: ElevatedButton.styleFrom(
// // // // // // //                               backgroundColor: isSelected
// // // // // // //                                   ? AppColors.primary
// // // // // // //                                   : AppColors.chip, // Use AppColors
// // // // // // //                               foregroundColor: isSelected
// // // // // // //                                   ? AppColors.buttonText
// // // // // // //                                   : AppColors.textPrimary, // Use AppColors
// // // // // // //                               elevation: isSelected ? 4 : 0,
// // // // // // //                               shadowColor: isSelected
// // // // // // //                                   ? AppColors.primary.withOpacity(0.3)
// // // // // // //                                   : Colors.transparent,
// // // // // // //                             ),
// // // // // // //                             onPressed: () async {
// // // // // // //                               if (view == 'Custom') {
// // // // // // //                                 final picked = await showDateRangePicker(
// // // // // // //                                   context: context,
// // // // // // //                                   firstDate: DateTime(2000),
// // // // // // //                                   lastDate: DateTime(2100),
// // // // // // //                                   helpText: 'Select Custom Date Range',
// // // // // // //                                   confirmText: 'Confirm',
// // // // // // //                                   cancelText: 'Cancel',
// // // // // // //                                   builder: (context, child) {
// // // // // // //                                     return Theme(
// // // // // // //                                       data: ThemeData.dark().copyWith(
// // // // // // //                                         // Use dark theme for picker
// // // // // // //                                         primaryColor: AppColors.primary,
// // // // // // //                                         colorScheme: ColorScheme.dark(
// // // // // // //                                           primary: AppColors.primary,
// // // // // // //                                           onPrimary: AppColors
// // // // // // //                                               .buttonText, // Text on primary background
// // // // // // //                                           surface: AppColors
// // // // // // //                                               .card, // Picker background
// // // // // // //                                           onSurface: AppColors
// // // // // // //                                               .textPrimary, // Text on picker background
// // // // // // //                                         ),
// // // // // // //                                         textTheme: const TextTheme(
// // // // // // //                                           titleLarge: TextStyle(
// // // // // // //                                               color: AppColors
// // // // // // //                                                   .textPrimary), // Year/Month title
// // // // // // //                                           bodyLarge: TextStyle(
// // // // // // //                                               color: AppColors
// // // // // // //                                                   .textPrimary), // Day numbers
// // // // // // //                                           labelLarge: TextStyle(
// // // // // // //                                               color: AppColors
// // // // // // //                                                   .textPrimary), // Button text (CANCEL/OK)
// // // // // // //                                         ),
// // // // // // //                                         dialogBackgroundColor:
// // // // // // //                                             AppColors.background,
// // // // // // //                                       ),
// // // // // // //                                       child: child!,
// // // // // // //                                     );
// // // // // // //                                   },
// // // // // // //                                 );
// // // // // // //                                 if (picked != null) {
// // // // // // //                                   setState(() {
// // // // // // //                                     _customRange = picked;
// // // // // // //                                     _selectedView = view;
// // // // // // //                                   });
// // // // // // //                                 }
// // // // // // //                               } else {
// // // // // // //                                 setState(() {
// // // // // // //                                   _selectedView = view;
// // // // // // //                                   // When switching to a non-custom view, reset _currentDate to now for consistency
// // // // // // //                                   if (view == 'Daily' ||
// // // // // // //                                       view == 'Weekly' ||
// // // // // // //                                       view == 'Monthly') {
// // // // // // //                                     bool shouldReset = false;
// // // // // // //                                     // Check if current date for the selected view is significantly off from "now"
// // // // // // //                                     if (view == 'Daily' &&
// // // // // // //                                         !(_currentDate.year ==
// // // // // // //                                                 DateTime.now().year &&
// // // // // // //                                             _currentDate.month ==
// // // // // // //                                                 DateTime.now().month &&
// // // // // // //                                             _currentDate.day ==
// // // // // // //                                                 DateTime.now().day)) {
// // // // // // //                                       shouldReset = true;
// // // // // // //                                     } else if (view == 'Weekly') {
// // // // // // //                                       final currentWeekMonday = DateTime.now()
// // // // // // //                                           .subtract(Duration(
// // // // // // //                                               days:
// // // // // // //                                                   DateTime.now().weekday - 1));
// // // // // // //                                       final selectedWeekMonday =
// // // // // // //                                           _currentDate.subtract(Duration(
// // // // // // //                                               days: _currentDate.weekday - 1));
// // // // // // //                                       if (currentWeekMonday
// // // // // // //                                               .difference(selectedWeekMonday)
// // // // // // //                                               .inDays !=
// // // // // // //                                           0) {
// // // // // // //                                         shouldReset = true;
// // // // // // //                                       }
// // // // // // //                                     } else if (view == 'Monthly' &&
// // // // // // //                                         !(_currentDate.year ==
// // // // // // //                                                 DateTime.now().year &&
// // // // // // //                                             _currentDate.month ==
// // // // // // //                                                 DateTime.now().month)) {
// // // // // // //                                       shouldReset = true;
// // // // // // //                                     }

// // // // // // //                                     if (shouldReset) {
// // // // // // //                                       _currentDate = DateTime.now();
// // // // // // //                                     }
// // // // // // //                                   }
// // // // // // //                                 });
// // // // // // //                               }
// // // // // // //                             },
// // // // // // //                             child: Text(view,
// // // // // // //                                 style: const TextStyle(
// // // // // // //                                     fontSize: 13, fontWeight: FontWeight.w500)),
// // // // // // //                           ),
// // // // // // //                         ),
// // // // // // //                       );
// // // // // // //                     }).toList(),
// // // // // // //                   ),
// // // // // // //                 ),
// // // // // // //                 const SizedBox(height: 12),

// // // // // // //                 // Date Navigation Row (only for Daily, Weekly, Monthly)
// // // // // // //                 if (_selectedView != 'Total' && _selectedView != 'Custom')
// // // // // // //                   Padding(
// // // // // // //                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
// // // // // // //                     child: Row(
// // // // // // //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // // // // //                       children: [
// // // // // // //                         IconButton(
// // // // // // //                           icon: const Icon(Icons.arrow_back_ios, size: 18),
// // // // // // //                           color: AppColors.textPrimary,
// // // // // // //                           onPressed: () => _navigatePeriod(-1, _selectedView),
// // // // // // //                         ),
// // // // // // //                         Expanded(
// // // // // // //                           // Use Expanded to prevent overflow
// // // // // // //                           child: Center(
// // // // // // //                             child: Text(
// // // // // // //                               dateRangeDisplay,
// // // // // // //                               style: const TextStyle(
// // // // // // //                                 fontSize: 16,
// // // // // // //                                 fontWeight: FontWeight.bold,
// // // // // // //                                 color: AppColors.textPrimary,
// // // // // // //                               ),
// // // // // // //                             ),
// // // // // // //                           ),
// // // // // // //                         ),
// // // // // // //                         IconButton(
// // // // // // //                           icon: const Icon(Icons.arrow_forward_ios, size: 18),
// // // // // // //                           color: AppColors.textPrimary,
// // // // // // //                           onPressed: () => _navigatePeriod(1, _selectedView),
// // // // // // //                         ),
// // // // // // //                       ],
// // // // // // //                     ),
// // // // // // //                   ),
// // // // // // //                 const SizedBox(height: 12),

// // // // // // //                 Container(
// // // // // // //                   margin: const EdgeInsets.symmetric(horizontal: 16.0),
// // // // // // //                   padding: const EdgeInsets.all(16.0),
// // // // // // //                   decoration: BoxDecoration(
// // // // // // //                     color: AppColors.card, // Use AppColors
// // // // // // //                     borderRadius: BorderRadius.circular(12.0),
// // // // // // //                     boxShadow: [
// // // // // // //                       BoxShadow(
// // // // // // //                         color: Colors.black
// // // // // // //                             .withOpacity(0.2), // Darker shadow for dark theme
// // // // // // //                         spreadRadius: 1,
// // // // // // //                         blurRadius: 5,
// // // // // // //                         offset: const Offset(0, 3),
// // // // // // //                       ),
// // // // // // //                     ],
// // // // // // //                   ),
// // // // // // //                   child: Row(
// // // // // // //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// // // // // // //                     children: [
// // // // // // //                       _buildSummaryTile('Income', incomeTotal,
// // // // // // //                           Colors.greenAccent.shade400), // Brighter green
// // // // // // //                       _buildSummaryTile('Expense', expenseTotal,
// // // // // // //                           Colors.redAccent.shade400), // Brighter red
// // // // // // //                       _buildSummaryTile(
// // // // // // //                           'Net',
// // // // // // //                           net,
// // // // // // //                           net >= 0
// // // // // // //                               ? AppColors.primary
// // // // // // //                               : Colors.redAccent
// // // // // // //                                   .shade400), // Use primary for net positive
// // // // // // //                     ],
// // // // // // //                   ),
// // // // // // //                 ),
// // // // // // //                 const SizedBox(height: 16),
// // // // // // //                 const Padding(
// // // // // // //                   padding: EdgeInsets.symmetric(horizontal: 16.0),
// // // // // // //                   child: Align(
// // // // // // //                     alignment: Alignment.centerLeft,
// // // // // // //                     child: Text(
// // // // // // //                       'Transactions',
// // // // // // //                       style: TextStyle(
// // // // // // //                         fontSize: 18,
// // // // // // //                         fontWeight: FontWeight.bold,
// // // // // // //                         color: AppColors.textPrimary,
// // // // // // //                       ),
// // // // // // //                     ),
// // // // // // //                   ),
// // // // // // //                 ),
// // // // // // //                 const Divider(
// // // // // // //                     height: 24, thickness: 1, color: AppColors.border),
// // // // // // //                 Expanded(
// // // // // // //                   child: groupedItems.isEmpty
// // // // // // //                       ? Center(
// // // // // // //                           child: Column(
// // // // // // //                             mainAxisAlignment: MainAxisAlignment.center,
// // // // // // //                             children: [
// // // // // // //                               Icon(Icons.receipt_long,
// // // // // // //                                   size: 60, color: AppColors.textSecondary),
// // // // // // //                               const SizedBox(height: 10),
// // // // // // //                               Text(
// // // // // // //                                 'No transactions found for this period.',
// // // // // // //                                 style: TextStyle(
// // // // // // //                                   fontSize: 16,
// // // // // // //                                   color: AppColors.textSecondary,
// // // // // // //                                 ),
// // // // // // //                               ),
// // // // // // //                             ],
// // // // // // //                           ),
// // // // // // //                         )
// // // // // // //                       : ListView.builder(
// // // // // // //                           itemCount: groupedItems.length,
// // // // // // //                           itemBuilder: (context, index) {
// // // // // // //                             final item = groupedItems[index];

// // // // // // //                             if (item.isDateHeader) {
// // // // // // //                               // It's a date header
// // // // // // //                               return Padding(
// // // // // // //                                 padding: const EdgeInsets.symmetric(
// // // // // // //                                     horizontal: 16.0, vertical: 8.0),
// // // // // // //                                 child: Text(
// // // // // // //                                   DateFormat('EEEE, MMM d, y').format(item
// // // // // // //                                       .date!), // E.g., "Thursday, Jun 27, 2025"
// // // // // // //                                   style: const TextStyle(
// // // // // // //                                     fontSize: 16,
// // // // // // //                                     fontWeight: FontWeight.bold,
// // // // // // //                                     color: AppColors.textPrimary,
// // // // // // //                                   ),
// // // // // // //                                 ),
// // // // // // //                               );
// // // // // // //                             } else {
// // // // // // //                               // It's a transaction item
// // // // // // //                               final tx = item.transaction!;
// // // // // // //                               return Card(
// // // // // // //                                 margin: const EdgeInsets.symmetric(
// // // // // // //                                     horizontal: 16, vertical: 6),
// // // // // // //                                 elevation: 2,
// // // // // // //                                 child: ListTile(
// // // // // // //                                   contentPadding: const EdgeInsets.symmetric(
// // // // // // //                                       horizontal: 16.0, vertical: 8.0),
// // // // // // //                                   leading: CircleAvatar(
// // // // // // //                                     backgroundColor: tx.type ==
// // // // // // //                                             TransactionType.income
// // // // // // //                                         ? Colors.green
// // // // // // //                                             .shade800 // Darker shade for income background
// // // // // // //                                         : Colors.red
// // // // // // //                                             .shade800, // Darker shade for expense background
// // // // // // //                                     child: Icon(
// // // // // // //                                       tx.type == TransactionType.income
// // // // // // //                                           ? Icons.arrow_downward_rounded
// // // // // // //                                           : Icons.arrow_upward_rounded,
// // // // // // //                                       color: tx.type == TransactionType.income
// // // // // // //                                           ? Colors.greenAccent
// // // // // // //                                               .shade100 // Brighter icon
// // // // // // //                                           : Colors.redAccent
// // // // // // //                                               .shade100, // Brighter icon
// // // // // // //                                     ),
// // // // // // //                                   ),
// // // // // // //                                   title: Text(
// // // // // // //                                     tx.title ?? 'No Title',
// // // // // // //                                     style: const TextStyle(
// // // // // // //                                       fontWeight: FontWeight.bold,
// // // // // // //                                       fontSize: 16,
// // // // // // //                                       color: AppColors
// // // // // // //                                           .cardText, // White text for titles on cards
// // // // // // //                                     ),
// // // // // // //                                   ),
// // // // // // //                                   subtitle: Text(
// // // // // // //                                     // Adjusted subtitle to use 'h:mm a' for time and only date for daily, then account and category
// // // // // // //                                     '${DateFormat('MMMM d, y').format(tx.date ?? DateTime.now())} ${DateFormat('h:mm a').format(tx.date ?? DateTime.now())} • ${tx.account ?? 'N/A'} • ${tx.category ?? 'N/A'}',
// // // // // // //                                     style: const TextStyle(
// // // // // // //                                       fontSize: 12,
// // // // // // //                                       color: AppColors.textSecondary,
// // // // // // //                                     ),
// // // // // // //                                   ),
// // // // // // //                                   trailing: Text(
// // // // // // //                                     '₹${tx.amount?.toStringAsFixed(2)}',
// // // // // // //                                     style: TextStyle(
// // // // // // //                                       fontWeight: FontWeight.w800,
// // // // // // //                                       fontSize: 16,
// // // // // // //                                       color: tx.type == TransactionType.income
// // // // // // //                                           ? Colors.greenAccent.shade400
// // // // // // //                                           : Colors.redAccent.shade400,
// // // // // // //                                     ),
// // // // // // //                                   ),
// // // // // // //                                 ),
// // // // // // //                               );
// // // // // // //                             }
// // // // // // //                           },
// // // // // // //                         ),
// // // // // // //                 ),
// // // // // // //               ],
// // // // // // //             );
// // // // // // //           },
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   Widget _buildSummaryTile(String label, double amount, Color color) {
// // // // // // //     return Column(
// // // // // // //       children: [
// // // // // // //         Text(
// // // // // // //           label,
// // // // // // //           style: const TextStyle(
// // // // // // //             fontWeight: FontWeight.bold,
// // // // // // //             fontSize: 14,
// // // // // // //             color: AppColors.textSecondary, // Use secondary text color
// // // // // // //           ),
// // // // // // //         ),
// // // // // // //         const SizedBox(height: 4),
// // // // // // //         Text(
// // // // // // //           '₹${amount.toStringAsFixed(2)}',
// // // // // // //           style: TextStyle(
// // // // // // //             color: color,
// // // // // // //             fontSize: 18,
// // // // // // //             fontWeight: FontWeight.w800,
// // // // // // //           ),
// // // // // // //         ),
// // // // // // //       ],
// // // // // // //     );
// // // // // // //   }
// // // // // // // }

// // // // // // import 'package:flutter/material.dart';
// // // // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // // // import 'package:intl/intl.dart';
// // // // // // import 'package:notegoexpense/model/transaction_notifier.dart';
// // // // // // import '../model/transaction_model.dart';
// // // // // // import '../extras/AppColors.dart';
// // // // // // import 'package:flutter_slidable/flutter_slidable.dart'; // Import the slidable package

// // // // // // // Helper class to represent items in the grouped list (either a date header or a transaction)
// // // // // // class GroupedTransactionItem {
// // // // // //   final DateTime? date; // For date headers
// // // // // //   final TransactionModel? transaction; // For transaction items

// // // // // //   GroupedTransactionItem.date(this.date) : transaction = null;
// // // // // //   GroupedTransactionItem.transaction(this.transaction) : date = null;

// // // // // //   bool get isDateHeader => date != null;
// // // // // //   bool get isTransaction => transaction != null;
// // // // // // }

// // // // // // class LedgerPage extends ConsumerStatefulWidget {
// // // // // //   const LedgerPage({super.key});

// // // // // //   @override
// // // // // //   ConsumerState<LedgerPage> createState() => _LedgerPageState();
// // // // // // }

// // // // // // class _LedgerPageState extends ConsumerState<LedgerPage> {
// // // // // //   String _selectedView = 'Daily';
// // // // // //   DateTimeRange? _customRange;
// // // // // //   DateTime _currentDate =
// // // // // //       DateTime.now(); // Renamed _today to _currentDate for clarity

// // // // // //   String _selectedCategory = 'All';
// // // // // //   String _selectedAccount = 'All';

// // // // // //   final List<String> _views = ['Daily', 'Weekly', 'Monthly', 'Total', 'Custom'];

// // // // // //   // Function to move the date range for Daily/Weekly/Monthly views
// // // // // //   void _navigatePeriod(int amount, String viewType) {
// // // // // //     setState(() {
// // // // // //       if (viewType == 'Daily') {
// // // // // //         _currentDate = _currentDate.add(Duration(days: amount));
// // // // // //       } else if (viewType == 'Weekly') {
// // // // // //         _currentDate = _currentDate.add(Duration(days: amount * 7));
// // // // // //       } else if (viewType == 'Monthly') {
// // // // // //         // Correctly handle month addition/subtraction
// // // // // //         _currentDate = DateTime(
// // // // // //           _currentDate.year,
// // // // // //           _currentDate.month + amount,
// // // // // //           // Clamp day to prevent overflow to next month (e.g., Feb 30th -> Mar 2nd)
// // // // // //           _currentDate.day.clamp(
// // // // // //               1,
// // // // // //               DateTime(_currentDate.year, _currentDate.month + amount + 1, 0)
// // // // // //                   .day),
// // // // // //         );
// // // // // //       }
// // // // // //     });
// // // // // //   }

// // // // // //   // Helper method to group transactions by date for display
// // // // // //   List<GroupedTransactionItem> _getGroupedTransactionItems(
// // // // // //       List<TransactionModel> transactions) {
// // // // // //     final List<GroupedTransactionItem> items = [];
// // // // // //     if (transactions.isEmpty) return items;

// // // // // //     // Sort by date descending
// // // // // //     transactions.sort((a, b) =>
// // // // // //         (b.date ?? DateTime.now()).compareTo(a.date ?? DateTime.now()));

// // // // // //     DateTime? lastDateHeader;
// // // // // //     for (var tx in transactions) {
// // // // // //       final txDate = tx.date ?? DateTime.now();
// // // // // //       // Normalize txDate to just year, month, day for comparison
// // // // // //       final normalizedTxDate = DateTime(txDate.year, txDate.month, txDate.day);

// // // // // //       // Add a date header if it's a new day or the first transaction
// // // // // //       // Check if lastDateHeader is different from normalizedTxDate
// // // // // //       if (lastDateHeader == null ||
// // // // // //           !normalizedTxDate.isAtSameMomentAs(lastDateHeader)) {
// // // // // //         items.add(GroupedTransactionItem.date(normalizedTxDate));
// // // // // //         lastDateHeader = normalizedTxDate;
// // // // // //       }
// // // // // //       items.add(GroupedTransactionItem.transaction(tx));
// // // // // //     }
// // // // // //     return items;
// // // // // //   }

// // // // // //   // Function to show confirmation dialog and then delete transaction
// // // // // //   Future<void> _confirmAndDelete(
// // // // // //       BuildContext context, TransactionModel transaction) async {
// // // // // //     final bool confirm = await showDialog(
// // // // // //           context: context,
// // // // // //           builder: (BuildContext context) {
// // // // // //             return AlertDialog(
// // // // // //               backgroundColor: AppColors.card, // Use card background for dialog
// // // // // //               title: Text('Delete Transaction?',
// // // // // //                   style: TextStyle(color: AppColors.textPrimary)),
// // // // // //               content: Text(
// // // // // //                 'Are you sure you want to delete "${transaction.title ?? 'this transaction'}"?',
// // // // // //                 style: TextStyle(color: AppColors.textPrimary),
// // // // // //               ),
// // // // // //               actions: <Widget>[
// // // // // //                 TextButton(
// // // // // //                   onPressed: () => Navigator.of(context).pop(false),
// // // // // //                   child: Text('Cancel',
// // // // // //                       style: TextStyle(color: AppColors.textSecondary)),
// // // // // //                 ),
// // // // // //                 ElevatedButton(
// // // // // //                   onPressed: () => Navigator.of(context).pop(true),
// // // // // //                   style: ElevatedButton.styleFrom(
// // // // // //                     backgroundColor: AppColors
// // // // // //                         .delete, // Use delete color for confirmation button
// // // // // //                     foregroundColor: AppColors.buttonText,
// // // // // //                   ),
// // // // // //                   child: const Text('Delete'),
// // // // // //                 ),
// // // // // //               ],
// // // // // //             );
// // // // // //           },
// // // // // //         ) ??
// // // // // //         false; // Default to false if dialog is dismissed

// // // // // //     if (confirm) {
// // // // // //       try {
// // // // // //         await ref
// // // // // //             .read(transactionsProvider.notifier)
// // // // // //             .deleteTransaction(transaction.id!);
// // // // // //         ScaffoldMessenger.of(context).showSnackBar(
// // // // // //           SnackBar(
// // // // // //             content: Text(
// // // // // //                 'Transaction "${transaction.title ?? 'Unknown'}" deleted.',
// // // // // //                 style: TextStyle(color: AppColors.textPrimary)),
// // // // // //             backgroundColor: Colors.green, // Success color
// // // // // //           ),
// // // // // //         );
// // // // // //       } catch (e) {
// // // // // //         ScaffoldMessenger.of(context).showSnackBar(
// // // // // //           SnackBar(
// // // // // //             content: Text(e.toString().replaceFirst('Exception: ', ''),
// // // // // //                 style: TextStyle(color: AppColors.buttonText)),
// // // // // //             backgroundColor: AppColors.delete, // Error color
// // // // // //           ),
// // // // // //         );
// // // // // //       }
// // // // // //     }
// // // // // //   }

// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     final transactionsAsync = ref.watch(transactionsProvider);

// // // // // //     return Theme(
// // // // // //       // Wrap with Theme to apply AppColors
// // // // // //       data: ThemeData(
// // // // // //         brightness: Brightness.dark, // Set to dark theme
// // // // // //         scaffoldBackgroundColor: AppColors.background,
// // // // // //         cardColor: AppColors.card,
// // // // // //         primaryColor: AppColors.primary,
// // // // // //         hintColor: AppColors.textSecondary, // For labels in input fields
// // // // // //         appBarTheme: const AppBarTheme(
// // // // // //           backgroundColor: AppColors.background,
// // // // // //           foregroundColor: AppColors.textPrimary,
// // // // // //           elevation: 1,
// // // // // //         ),
// // // // // //         textTheme: const TextTheme(
// // // // // //           displayLarge: TextStyle(color: AppColors.textPrimary),
// // // // // //           displayMedium: TextStyle(color: AppColors.textPrimary),
// // // // // //           displaySmall: TextStyle(color: AppColors.textPrimary),
// // // // // //           headlineLarge: TextStyle(color: AppColors.textPrimary),
// // // // // //           headlineMedium: TextStyle(color: AppColors.textPrimary),
// // // // // //           headlineSmall: TextStyle(color: AppColors.textPrimary),
// // // // // //           titleLarge: TextStyle(color: AppColors.textPrimary),
// // // // // //           titleMedium: TextStyle(color: AppColors.textPrimary),
// // // // // //           titleSmall: TextStyle(color: AppColors.textPrimary),
// // // // // //           bodyLarge: TextStyle(color: AppColors.textPrimary),
// // // // // //           bodyMedium: TextStyle(color: AppColors.textPrimary),
// // // // // //           bodySmall: TextStyle(color: AppColors.textSecondary),
// // // // // //           labelLarge: TextStyle(color: AppColors.buttonText), // For button text
// // // // // //           labelMedium: TextStyle(color: AppColors.textSecondary),
// // // // // //           labelSmall: TextStyle(color: AppColors.textSecondary),
// // // // // //         ),
// // // // // //         inputDecorationTheme: InputDecorationTheme(
// // // // // //           labelStyle: const TextStyle(color: AppColors.textSecondary),
// // // // // //           enabledBorder: OutlineInputBorder(
// // // // // //             borderRadius: BorderRadius.circular(10.0),
// // // // // //             borderSide: const BorderSide(color: AppColors.border),
// // // // // //           ),
// // // // // //           focusedBorder: OutlineInputBorder(
// // // // // //             borderRadius: BorderRadius.circular(10.0),
// // // // // //             borderSide: const BorderSide(color: AppColors.primary),
// // // // // //           ),
// // // // // //           border: OutlineInputBorder(
// // // // // //             borderRadius: BorderRadius.circular(10.0),
// // // // // //             borderSide: const BorderSide(color: AppColors.border),
// // // // // //           ),
// // // // // //           filled: true,
// // // // // //           fillColor: AppColors.chip, // Use chip color for input background
// // // // // //         ),
// // // // // //         elevatedButtonTheme: ElevatedButtonThemeData(
// // // // // //           style: ElevatedButton.styleFrom(
// // // // // //             shape: RoundedRectangleBorder(
// // // // // //               borderRadius: BorderRadius.circular(8.0),
// // // // // //             ),
// // // // // //             padding: const EdgeInsets.symmetric(vertical: 10.0),
// // // // // //           ),
// // // // // //         ),
// // // // // //         cardTheme: CardThemeData(
// // // // // //           color: AppColors.card,
// // // // // //           elevation: 2,
// // // // // //           shape: RoundedRectangleBorder(
// // // // // //             borderRadius: BorderRadius.circular(10.0),
// // // // // //           ),
// // // // // //         ),
// // // // // //         dividerColor: AppColors.border,
// // // // // //         // Customize dropdown menu button text color
// // // // // //         dropdownMenuTheme: DropdownMenuThemeData(
// // // // // //           textStyle: const TextStyle(
// // // // // //               color: AppColors
// // // // // //                   .textPrimary), // Text color of selected item in dropdown
// // // // // //           menuStyle: MenuStyle(
// // // // // //             backgroundColor: MaterialStateProperty.all(
// // // // // //                 AppColors.card), // Background of dropdown menu itself
// // // // // //           ),
// // // // // //         ),
// // // // // //       ),
// // // // // //       child: Scaffold(
// // // // // //         appBar: AppBar(
// // // // // //           title: const Text(
// // // // // //             'Ledger',
// // // // // //             style: TextStyle(
// // // // // //               fontWeight: FontWeight.bold,
// // // // // //               fontSize: 22,
// // // // // //             ),
// // // // // //           ),
// // // // // //           centerTitle: true,
// // // // // //         ),
// // // // // //         body: transactionsAsync.when(
// // // // // //           loading: () => const Center(child: CircularProgressIndicator()),
// // // // // //           error: (e, st) => Center(
// // // // // //               child: Text('Error: $e',
// // // // // //                   style: const TextStyle(color: AppColors.delete))),
// // // // // //           data: (transactions) {
// // // // // //             List<TransactionModel> filtered = transactions;

// // // // // //             // Corrected categories and accounts generation to prevent duplicates of 'All'
// // // // // //             final List<String> categories = {
// // // // // //               'All', // Start with 'All' in the set
// // // // // //               ...transactions.map((tx) => tx.category ?? '')
// // // // // //             }
// // // // // //                 .where((category) =>
// // // // // //                     category.isNotEmpty) // Filter out empty strings if any
// // // // // //                 .toList();
// // // // // //             categories
// // // // // //                 .sort(); // Sort the existing unique elements (including 'All')

// // // // // //             // Ensure 'All' is at the very beginning and only once
// // // // // //             if (categories.contains('All')) {
// // // // // //               categories
// // // // // //                   .remove('All'); // Remove if it was sorted somewhere else
// // // // // //             }
// // // // // //             categories.insert(0, 'All'); // Add it back at the beginning

// // // // // //             final List<String> accounts = {
// // // // // //               'All', // Start with 'All' in the set
// // // // // //               ...transactions.map((tx) => tx.account ?? '')
// // // // // //             }
// // // // // //                 .where((account) =>
// // // // // //                     account.isNotEmpty) // Filter out empty strings if any
// // // // // //                 .toList();
// // // // // //             accounts
// // // // // //                 .sort(); // Sort the existing unique elements (including 'All')

// // // // // //             // Ensure 'All' is at the very beginning and only once
// // // // // //             if (accounts.contains('All')) {
// // // // // //               accounts.remove('All'); // Remove if it was sorted somewhere else
// // // // // //             }
// // // // // //             accounts.insert(0, 'All'); // Add it back at the beginning

// // // // // //             DateTime start;
// // // // // //             DateTime end;
// // // // // //             String dateRangeDisplay = '';

// // // // // //             if (_selectedView == 'Daily') {
// // // // // //               start = DateTime(
// // // // // //                   _currentDate.year, _currentDate.month, _currentDate.day);
// // // // // //               end = start.add(const Duration(days: 1));
// // // // // //               dateRangeDisplay = DateFormat.yMMMd().format(_currentDate);
// // // // // //             } else if (_selectedView == 'Weekly') {
// // // // // //               // Calculate start of the week (Monday)
// // // // // //               start = _currentDate
// // // // // //                   .subtract(Duration(days: _currentDate.weekday - 1));
// // // // // //               end = start.add(const Duration(days: 7));
// // // // // //               dateRangeDisplay =
// // // // // //                   '${DateFormat.yMMMd().format(start)} - ${DateFormat.yMMMd().format(end.subtract(const Duration(days: 1)))}';
// // // // // //             } else if (_selectedView == 'Monthly') {
// // // // // //               start = DateTime(_currentDate.year, _currentDate.month, 1);
// // // // // //               end = DateTime(_currentDate.year, _currentDate.month + 1, 1);
// // // // // //               dateRangeDisplay = DateFormat.yMMMM().format(_currentDate);
// // // // // //             } else if (_selectedView == 'Custom' && _customRange != null) {
// // // // // //               start = _customRange!.start;
// // // // // //               // The end date from showDateRangePicker is inclusive, so add 1 day to make it exclusive for filtering
// // // // // //               end = _customRange!.end.add(const Duration(days: 1));
// // // // // //               dateRangeDisplay =
// // // // // //                   '${DateFormat.yMMMd().format(_customRange!.start)} - ${DateFormat.yMMMd().format(_customRange!.end)}';
// // // // // //             } else {
// // // // // //               // Total view
// // // // // //               start = DateTime(2000, 1, 1); // Very old date
// // // // // //               end = DateTime.now()
// // // // // //                   .add(const Duration(days: 365 * 10)); // Far future date
// // // // // //               dateRangeDisplay = 'All Time';
// // // // // //             }

// // // // // //             filtered = filtered.where((tx) {
// // // // // //               final txDate = tx.date ?? DateTime.now();
// // // // // //               final matchesCategory = _selectedCategory == 'All' ||
// // // // // //                   (tx.category ?? '') == _selectedCategory;
// // // // // //               final matchesAccount = _selectedAccount == 'All' ||
// // // // // //                   (tx.account ?? '') == _selectedAccount;

// // // // // //               // Ensure comparison is consistent: txDate >= start and txDate < end
// // // // // //               return txDate.isAfter(
// // // // // //                       start.subtract(const Duration(milliseconds: 1))) &&
// // // // // //                   txDate.isBefore(end) &&
// // // // // //                   matchesCategory &&
// // // // // //                   matchesAccount;
// // // // // //             }).toList();

// // // // // //             final incomeTotal = filtered
// // // // // //                 .where((tx) => tx.type == TransactionType.income)
// // // // // //                 .fold<double>(0, (sum, tx) => sum + (tx.amount ?? 0));
// // // // // //             final expenseTotal = filtered
// // // // // //                 .where((tx) => tx.type == TransactionType.expense)
// // // // // //                 .fold<double>(0, (sum, tx) => sum + (tx.amount ?? 0));
// // // // // //             final net = incomeTotal - expenseTotal;

// // // // // //             // Get grouped transactions for the ListView
// // // // // //             final List<GroupedTransactionItem> groupedItems =
// // // // // //                 _getGroupedTransactionItems(filtered);

// // // // // //             return Column(
// // // // // //               children: [
// // // // // //                 Padding(
// // // // // //                   padding: const EdgeInsets.all(16.0),
// // // // // //                   child: Row(
// // // // // //                     children: [
// // // // // //                       Expanded(
// // // // // //                         child: DropdownButtonFormField<String>(
// // // // // //                           value: _selectedCategory,
// // // // // //                           isExpanded: true, // Crucial for dropdown overflow fix
// // // // // //                           decoration: const InputDecoration(
// // // // // //                             labelText: 'Category',
// // // // // //                             // Styles are applied via ThemeData
// // // // // //                           ),
// // // // // //                           items: categories.map((cat) {
// // // // // //                             return DropdownMenuItem(
// // // // // //                               value: cat,
// // // // // //                               child: Text(
// // // // // //                                 cat == 'All'
// // // // // //                                     ? 'All Categories'
// // // // // //                                     : (cat.isEmpty ? 'Uncategorized' : cat),
// // // // // //                                 style: const TextStyle(fontSize: 14),
// // // // // //                                 overflow: TextOverflow
// // // // // //                                     .ellipsis, // Crucial for dropdown overflow fix
// // // // // //                               ),
// // // // // //                             );
// // // // // //                           }).toList(),
// // // // // //                           onChanged: (value) {
// // // // // //                             if (value != null) {
// // // // // //                               setState(() => _selectedCategory = value);
// // // // // //                             }
// // // // // //                           },
// // // // // //                           // Ensure the selected item's text color is primary
// // // // // //                           selectedItemBuilder: (BuildContext context) {
// // // // // //                             return categories.map((String value) {
// // // // // //                               return Text(
// // // // // //                                 value == 'All'
// // // // // //                                     ? 'All Categories'
// // // // // //                                     : (value.isEmpty ? 'Uncategorized' : value),
// // // // // //                                 style: TextStyle(
// // // // // //                                     color: Theme.of(context)
// // // // // //                                         .textTheme
// // // // // //                                         .bodyLarge
// // // // // //                                         ?.color),
// // // // // //                                 overflow: TextOverflow
// // // // // //                                     .ellipsis, // Crucial for dropdown overflow fix
// // // // // //                               );
// // // // // //                             }).toList();
// // // // // //                           },
// // // // // //                         ),
// // // // // //                       ),
// // // // // //                       const SizedBox(width: 12),
// // // // // //                       Expanded(
// // // // // //                         child: DropdownButtonFormField<String>(
// // // // // //                           value: _selectedAccount,
// // // // // //                           isExpanded: true, // Crucial for dropdown overflow fix
// // // // // //                           decoration: const InputDecoration(
// // // // // //                             labelText: 'Account',
// // // // // //                             // Styles are applied via ThemeData
// // // // // //                           ),
// // // // // //                           items: accounts.map((acc) {
// // // // // //                             return DropdownMenuItem(
// // // // // //                               value: acc,
// // // // // //                               child: Text(
// // // // // //                                 acc == 'All'
// // // // // //                                     ? 'All Accounts'
// // // // // //                                     : (acc.isEmpty ? 'Unnamed' : acc),
// // // // // //                                 style: const TextStyle(fontSize: 14),
// // // // // //                                 overflow: TextOverflow
// // // // // //                                     .ellipsis, // Crucial for dropdown overflow fix
// // // // // //                               ),
// // // // // //                             );
// // // // // //                           }).toList(),
// // // // // //                           onChanged: (value) {
// // // // // //                             if (value != null) {
// // // // // //                               setState(() => _selectedAccount = value);
// // // // // //                             }
// // // // // //                           },
// // // // // //                           // Ensure the selected item's text color is primary
// // // // // //                           selectedItemBuilder: (BuildContext context) {
// // // // // //                             return accounts.map((String value) {
// // // // // //                               return Text(
// // // // // //                                 value == 'All'
// // // // // //                                     ? 'All Accounts'
// // // // // //                                     : (value.isEmpty ? 'Unnamed' : value),
// // // // // //                                 style: TextStyle(
// // // // // //                                     color: Theme.of(context)
// // // // // //                                         .textTheme
// // // // // //                                         .bodyLarge
// // // // // //                                         ?.color),
// // // // // //                                 overflow: TextOverflow
// // // // // //                                     .ellipsis, // Crucial for dropdown overflow fix
// // // // // //                               );
// // // // // //                             }).toList();
// // // // // //                           },
// // // // // //                         ),
// // // // // //                       ),
// // // // // //                     ],
// // // // // //                   ),
// // // // // //                 ),
// // // // // //                 Padding(
// // // // // //                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
// // // // // //                   child: Row(
// // // // // //                     children: _views.map((view) {
// // // // // //                       final isSelected = _selectedView == view;
// // // // // //                       return Expanded(
// // // // // //                         child: Padding(
// // // // // //                           padding: const EdgeInsets.symmetric(horizontal: 4.0),
// // // // // //                           child: ElevatedButton(
// // // // // //                             style: ElevatedButton.styleFrom(
// // // // // //                               backgroundColor: isSelected
// // // // // //                                   ? AppColors.primary
// // // // // //                                   : AppColors.chip, // Use AppColors
// // // // // //                               foregroundColor: isSelected
// // // // // //                                   ? AppColors.buttonText
// // // // // //                                   : AppColors.textPrimary, // Use AppColors
// // // // // //                               elevation: isSelected ? 4 : 0,
// // // // // //                               shadowColor: isSelected
// // // // // //                                   ? AppColors.primary.withOpacity(0.3)
// // // // // //                                   : Colors.transparent,
// // // // // //                             ),
// // // // // //                             onPressed: () async {
// // // // // //                               if (view == 'Custom') {
// // // // // //                                 final picked = await showDateRangePicker(
// // // // // //                                   context: context,
// // // // // //                                   firstDate: DateTime(2000),
// // // // // //                                   lastDate: DateTime(2100),
// // // // // //                                   helpText: 'Select Custom Date Range',
// // // // // //                                   confirmText: 'Confirm',
// // // // // //                                   cancelText: 'Cancel',
// // // // // //                                   builder: (context, child) {
// // // // // //                                     return Theme(
// // // // // //                                       data: ThemeData.dark().copyWith(
// // // // // //                                         // Use dark theme for picker
// // // // // //                                         primaryColor: AppColors.primary,
// // // // // //                                         colorScheme: ColorScheme.dark(
// // // // // //                                           primary: AppColors.primary,
// // // // // //                                           onPrimary: AppColors
// // // // // //                                               .buttonText, // Text on primary background
// // // // // //                                           surface: AppColors
// // // // // //                                               .card, // Picker background
// // // // // //                                           onSurface: AppColors
// // // // // //                                               .textPrimary, // Text on picker background
// // // // // //                                         ),
// // // // // //                                         textTheme: const TextTheme(
// // // // // //                                           titleLarge: TextStyle(
// // // // // //                                               color: AppColors
// // // // // //                                                   .textPrimary), // Year/Month title
// // // // // //                                           bodyLarge: TextStyle(
// // // // // //                                               color: AppColors
// // // // // //                                                   .textPrimary), // Day numbers
// // // // // //                                           labelLarge: TextStyle(
// // // // // //                                               color: AppColors
// // // // // //                                                   .textPrimary), // Button text (CANCEL/OK)
// // // // // //                                         ),
// // // // // //                                         dialogBackgroundColor:
// // // // // //                                             AppColors.background,
// // // // // //                                       ),
// // // // // //                                       child: child!,
// // // // // //                                     );
// // // // // //                                   },
// // // // // //                                 );
// // // // // //                                 if (picked != null) {
// // // // // //                                   setState(() {
// // // // // //                                     _customRange = picked;
// // // // // //                                     _selectedView = view;
// // // // // //                                   });
// // // // // //                                 }
// // // // // //                               } else {
// // // // // //                                 setState(() {
// // // // // //                                   _selectedView = view;
// // // // // //                                   // When switching to a non-custom view, reset _currentDate to now for consistency
// // // // // //                                   if (view == 'Daily' ||
// // // // // //                                       view == 'Weekly' ||
// // // // // //                                       view == 'Monthly') {
// // // // // //                                     bool shouldReset = false;
// // // // // //                                     // Check if current date for the selected view is significantly off from "now"
// // // // // //                                     if (view == 'Daily' &&
// // // // // //                                         !(_currentDate.year ==
// // // // // //                                                 DateTime.now().year &&
// // // // // //                                             _currentDate.month ==
// // // // // //                                                 DateTime.now().month &&
// // // // // //                                             _currentDate.day ==
// // // // // //                                                 DateTime.now().day)) {
// // // // // //                                       shouldReset = true;
// // // // // //                                     } else if (view == 'Weekly') {
// // // // // //                                       final currentWeekMonday = DateTime.now()
// // // // // //                                           .subtract(Duration(
// // // // // //                                               days:
// // // // // //                                                   DateTime.now().weekday - 1));
// // // // // //                                       final selectedWeekMonday =
// // // // // //                                           _currentDate.subtract(Duration(
// // // // // //                                               days: _currentDate.weekday - 1));
// // // // // //                                       if (currentWeekMonday
// // // // // //                                               .difference(selectedWeekMonday)
// // // // // //                                               .inDays !=
// // // // // //                                           0) {
// // // // // //                                         shouldReset = true;
// // // // // //                                       }
// // // // // //                                     } else if (view == 'Monthly' &&
// // // // // //                                         !(_currentDate.year ==
// // // // // //                                                 DateTime.now().year &&
// // // // // //                                             _currentDate.month ==
// // // // // //                                                 DateTime.now().month)) {
// // // // // //                                       shouldReset = true;
// // // // // //                                     }

// // // // // //                                     if (shouldReset) {
// // // // // //                                       _currentDate = DateTime.now();
// // // // // //                                     }
// // // // // //                                   }
// // // // // //                                 });
// // // // // //                               }
// // // // // //                             },
// // // // // //                             child: Text(view,
// // // // // //                                 style: const TextStyle(
// // // // // //                                     fontSize: 13, fontWeight: FontWeight.w500)),
// // // // // //                           ),
// // // // // //                         ),
// // // // // //                       );
// // // // // //                     }).toList(),
// // // // // //                   ),
// // // // // //                 ),
// // // // // //                 const SizedBox(height: 12),

// // // // // //                 // Date Navigation Row (only for Daily, Weekly, Monthly)
// // // // // //                 if (_selectedView != 'Total' && _selectedView != 'Custom')
// // // // // //                   Padding(
// // // // // //                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
// // // // // //                     child: Row(
// // // // // //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // // // //                       children: [
// // // // // //                         IconButton(
// // // // // //                           icon: const Icon(Icons.arrow_back_ios, size: 18),
// // // // // //                           color: AppColors.textPrimary,
// // // // // //                           onPressed: () => _navigatePeriod(-1, _selectedView),
// // // // // //                         ),
// // // // // //                         Expanded(
// // // // // //                           // Use Expanded to prevent overflow
// // // // // //                           child: Center(
// // // // // //                             child: Text(
// // // // // //                               dateRangeDisplay,
// // // // // //                               style: const TextStyle(
// // // // // //                                 fontSize: 16,
// // // // // //                                 fontWeight: FontWeight.bold,
// // // // // //                                 color: AppColors.textPrimary,
// // // // // //                               ),
// // // // // //                             ),
// // // // // //                           ),
// // // // // //                         ),
// // // // // //                         IconButton(
// // // // // //                           icon: const Icon(Icons.arrow_forward_ios, size: 18),
// // // // // //                           color: AppColors.textPrimary,
// // // // // //                           onPressed: () => _navigatePeriod(1, _selectedView),
// // // // // //                         ),
// // // // // //                       ],
// // // // // //                     ),
// // // // // //                   ),
// // // // // //                 const SizedBox(height: 12),

// // // // // //                 Container(
// // // // // //                   margin: const EdgeInsets.symmetric(horizontal: 16.0),
// // // // // //                   padding: const EdgeInsets.all(16.0),
// // // // // //                   decoration: BoxDecoration(
// // // // // //                     color: AppColors.card, // Use AppColors
// // // // // //                     borderRadius: BorderRadius.circular(12.0),
// // // // // //                     boxShadow: [
// // // // // //                       BoxShadow(
// // // // // //                         color: Colors.black
// // // // // //                             .withOpacity(0.2), // Darker shadow for dark theme
// // // // // //                         spreadRadius: 1,
// // // // // //                         blurRadius: 5,
// // // // // //                         offset: const Offset(0, 3),
// // // // // //                       ),
// // // // // //                     ],
// // // // // //                   ),
// // // // // //                   child: Row(
// // // // // //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// // // // // //                     children: [
// // // // // //                       _buildSummaryTile('Income', incomeTotal,
// // // // // //                           Colors.greenAccent.shade400), // Brighter green
// // // // // //                       _buildSummaryTile('Expense', expenseTotal,
// // // // // //                           Colors.redAccent.shade400), // Brighter red
// // // // // //                       _buildSummaryTile(
// // // // // //                           'Net',
// // // // // //                           net,
// // // // // //                           net >= 0
// // // // // //                               ? AppColors.primary
// // // // // //                               : Colors.redAccent
// // // // // //                                   .shade400), // Use primary for net positive
// // // // // //                     ],
// // // // // //                   ),
// // // // // //                 ),
// // // // // //                 const SizedBox(height: 16),
// // // // // //                 const Padding(
// // // // // //                   padding: EdgeInsets.symmetric(horizontal: 16.0),
// // // // // //                   child: Align(
// // // // // //                     alignment: Alignment.centerLeft,
// // // // // //                     child: Text(
// // // // // //                       'Transactions',
// // // // // //                       style: TextStyle(
// // // // // //                         fontSize: 18,
// // // // // //                         fontWeight: FontWeight.bold,
// // // // // //                         color: AppColors.textPrimary,
// // // // // //                       ),
// // // // // //                     ),
// // // // // //                   ),
// // // // // //                 ),
// // // // // //                 const Divider(
// // // // // //                     height: 24, thickness: 1, color: AppColors.border),
// // // // // //                 Expanded(
// // // // // //                   child: groupedItems.isEmpty
// // // // // //                       ? Center(
// // // // // //                           child: Column(
// // // // // //                             mainAxisAlignment: MainAxisAlignment.center,
// // // // // //                             children: [
// // // // // //                               Icon(Icons.receipt_long,
// // // // // //                                   size: 60, color: AppColors.textSecondary),
// // // // // //                               const SizedBox(height: 10),
// // // // // //                               Text(
// // // // // //                                 'No transactions found for this period.',
// // // // // //                                 style: TextStyle(
// // // // // //                                   fontSize: 16,
// // // // // //                                   color: AppColors.textSecondary,
// // // // // //                                 ),
// // // // // //                               ),
// // // // // //                             ],
// // // // // //                           ),
// // // // // //                         )
// // // // // //                       : ListView.builder(
// // // // // //                           itemCount: groupedItems.length,
// // // // // //                           itemBuilder: (context, index) {
// // // // // //                             final item = groupedItems[index];

// // // // // //                             if (item.isDateHeader) {
// // // // // //                               // It's a date header
// // // // // //                               return Padding(
// // // // // //                                 padding: const EdgeInsets.symmetric(
// // // // // //                                     horizontal: 16.0, vertical: 8.0),
// // // // // //                                 child: Text(
// // // // // //                                   DateFormat('EEEE, MMM d, y').format(item
// // // // // //                                       .date!), // E.g., "Thursday, Jun 27, 2025"
// // // // // //                                   style: const TextStyle(
// // // // // //                                     fontSize: 16,
// // // // // //                                     fontWeight: FontWeight.bold,
// // // // // //                                     color: AppColors.textPrimary,
// // // // // //                                   ),
// // // // // //                                 ),
// // // // // //                               );
// // // // // //                             } else {
// // // // // //                               // It's a transaction item
// // // // // //                               final tx = item.transaction!;
// // // // // //                               return Slidable(
// // // // // //                                 // Wrap the Card with Slidable
// // // // // //                                 key: ValueKey(
// // // // // //                                     tx.id), // Unique key for each slidable item
// // // // // //                                 endActionPane: ActionPane(
// // // // // //                                   motion:
// // // // // //                                       const DrawerMotion(), // Simple drawer motion
// // // // // //                                   extentRatio:
// // // // // //                                       0.25, // How much of the item width the action pane takes
// // // // // //                                   children: [
// // // // // //                                     SlidableAction(
// // // // // //                                       onPressed: (context) =>
// // // // // //                                           _confirmAndDelete(context, tx),
// // // // // //                                       backgroundColor: AppColors.delete,
// // // // // //                                       foregroundColor: AppColors.buttonText,
// // // // // //                                       icon: Icons.delete,
// // // // // //                                       label: 'Delete',
// // // // // //                                     ),
// // // // // //                                   ],
// // // // // //                                 ),
// // // // // //                                 child: Card(
// // // // // //                                   margin: const EdgeInsets.symmetric(
// // // // // //                                       horizontal: 16, vertical: 6),
// // // // // //                                   elevation: 2,
// // // // // //                                   child: ListTile(
// // // // // //                                     contentPadding: const EdgeInsets.symmetric(
// // // // // //                                         horizontal: 16.0, vertical: 8.0),
// // // // // //                                     leading: CircleAvatar(
// // // // // //                                       backgroundColor: tx.type ==
// // // // // //                                               TransactionType.income
// // // // // //                                           ? Colors.green
// // // // // //                                               .shade800 // Darker shade for income background
// // // // // //                                           : Colors.red
// // // // // //                                               .shade800, // Darker shade for expense background
// // // // // //                                       child: Icon(
// // // // // //                                         tx.type == TransactionType.income
// // // // // //                                             ? Icons.arrow_downward_rounded
// // // // // //                                             : Icons.arrow_upward_rounded,
// // // // // //                                         color: tx.type == TransactionType.income
// // // // // //                                             ? Colors.greenAccent
// // // // // //                                                 .shade100 // Brighter icon
// // // // // //                                             : Colors.redAccent
// // // // // //                                                 .shade100, // Brighter icon
// // // // // //                                       ),
// // // // // //                                     ),
// // // // // //                                     title: Text(
// // // // // //                                       tx.title ?? 'No Title',
// // // // // //                                       style: const TextStyle(
// // // // // //                                         fontWeight: FontWeight.bold,
// // // // // //                                         fontSize: 16,
// // // // // //                                         color: AppColors
// // // // // //                                             .cardText, // White text for titles on cards
// // // // // //                                       ),
// // // // // //                                     ),
// // // // // //                                     subtitle: Text(
// // // // // //                                       // Adjusted subtitle to show full date for daily, then time, account and category
// // // // // //                                       '${DateFormat('MMMM d, y').format(tx.date ?? DateTime.now())} ${DateFormat('h:mm a').format(tx.date ?? DateTime.now())} • ${tx.account ?? 'N/A'} • ${tx.category ?? 'N/A'}',
// // // // // //                                       style: const TextStyle(
// // // // // //                                         fontSize: 12,
// // // // // //                                         color: AppColors.textSecondary,
// // // // // //                                       ),
// // // // // //                                     ),
// // // // // //                                     trailing: Text(
// // // // // //                                       '₹${tx.amount?.toStringAsFixed(2)}',
// // // // // //                                       style: TextStyle(
// // // // // //                                         fontWeight: FontWeight.w800,
// // // // // //                                         fontSize: 16,
// // // // // //                                         color: tx.type == TransactionType.income
// // // // // //                                             ? Colors.greenAccent.shade400
// // // // // //                                             : Colors.redAccent.shade400,
// // // // // //                                       ),
// // // // // //                                     ),
// // // // // //                                   ),
// // // // // //                                 ),
// // // // // //                               );
// // // // // //                             }
// // // // // //                           },
// // // // // //                         ),
// // // // // //                 ),
// // // // // //               ],
// // // // // //             );
// // // // // //           },
// // // // // //         ),
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // //   Widget _buildSummaryTile(String label, double amount, Color color) {
// // // // // //     return Column(
// // // // // //       children: [
// // // // // //         Text(
// // // // // //           label,
// // // // // //           style: const TextStyle(
// // // // // //             fontWeight: FontWeight.bold,
// // // // // //             fontSize: 14,
// // // // // //             color: AppColors.textSecondary, // Use secondary text color
// // // // // //           ),
// // // // // //         ),
// // // // // //         const SizedBox(height: 4),
// // // // // //         Text(
// // // // // //           '₹${amount.toStringAsFixed(2)}',
// // // // // //           style: TextStyle(
// // // // // //             color: color,
// // // // // //             fontSize: 18,
// // // // // //             fontWeight: FontWeight.w800,
// // // // // //           ),
// // // // // //         ),
// // // // // //       ],
// // // // // //     );
// // // // // //   }
// // // // // // }

// // // // // // lib/pages/ledger.dart
// // // // // // lib/pages/ledger.dart

// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // // import 'package:intl/intl.dart';
// // // // // import 'package:notegoexpense/model/transaction_notifier.dart';
// // // // // import '../model/transaction_model.dart';
// // // // // import '../extras/AppColors.dart';
// // // // // import 'package:flutter_slidable/flutter_slidable.dart';
// // // // // // Import the file where scaffoldMessengerKey is defined
// // // // // import 'package:notegoexpense/main.dart'; // Adjust this path if main.dart is not in lib/

// // // // // // Helper class to represent items in the grouped list (either a date header or a transaction)
// // // // // class GroupedTransactionItem {
// // // // //   final DateTime? date; // For date headers
// // // // //   final TransactionModel? transaction; // For transaction items

// // // // //   GroupedTransactionItem.date(this.date) : transaction = null;
// // // // //   GroupedTransactionItem.transaction(this.transaction) : date = null;

// // // // //   bool get isDateHeader => date != null;
// // // // //   bool get isTransaction => transaction != null;
// // // // // }

// // // // // class LedgerPage extends ConsumerStatefulWidget {
// // // // //   const LedgerPage({super.key});

// // // // //   @override
// // // // //   ConsumerState<LedgerPage> createState() => _LedgerPageState();
// // // // // }

// // // // // class _LedgerPageState extends ConsumerState<LedgerPage> {
// // // // //   String _selectedView = 'Daily';
// // // // //   DateTimeRange? _customRange;
// // // // //   DateTime _currentDate = DateTime.now(); // Renamed _today to _currentDate for clarity

// // // // //   String _selectedCategory = 'All';
// // // // //   String _selectedAccount = 'All';

// // // // //   final List<String> _views = ['Daily', 'Weekly', 'Monthly', 'Total', 'Custom'];

// // // // //   // Function to move the date range for Daily/Weekly/Monthly views
// // // // //   void _navigatePeriod(int amount, String viewType) {
// // // // //     setState(() {
// // // // //       if (viewType == 'Daily') {
// // // // //         _currentDate = _currentDate.add(Duration(days: amount));
// // // // //       } else if (viewType == 'Weekly') {
// // // // //         _currentDate = _currentDate.add(Duration(days: amount * 7));
// // // // //       } else if (viewType == 'Monthly') {
// // // // //         // Correctly handle month addition/subtraction
// // // // //         _currentDate = DateTime(
// // // // //           _currentDate.year,
// // // // //           _currentDate.month + amount,
// // // // //           // Clamp day to prevent overflow to next month (e.g., Feb 30th -> Mar 2nd)
// // // // //           _currentDate.day.clamp(1, DateTime(_currentDate.year, _currentDate.month + amount + 1, 0).day),
// // // // //         );
// // // // //       }
// // // // //     });
// // // // //   }

// // // // //   // Helper method to group transactions by date for display
// // // // //   List<GroupedTransactionItem> _getGroupedTransactionItems(List<TransactionModel> transactions) {
// // // // //     final List<GroupedTransactionItem> items = [];
// // // // //     if (transactions.isEmpty) return items;

// // // // //     // Sort by date descending
// // // // //     transactions.sort((a, b) => (b.date ?? DateTime.now()).compareTo(a.date ?? DateTime.now()));

// // // // //     DateTime? lastDateHeader;
// // // // //     for (var tx in transactions) {
// // // // //       final txDate = tx.date ?? DateTime.now();
// // // // //       // Normalize txDate to just year, month, day for comparison
// // // // //       final normalizedTxDate = DateTime(txDate.year, txDate.month, txDate.day);

// // // // //       // Add a date header if it's a new day or the first transaction
// // // // //       // Check if lastDateHeader is different from normalizedTxDate
// // // // //       if (lastDateHeader == null || !normalizedTxDate.isAtSameMomentAs(lastDateHeader)) {
// // // // //           items.add(GroupedTransactionItem.date(normalizedTxDate));
// // // // //           lastDateHeader = normalizedTxDate;
// // // // //       }
// // // // //       items.add(GroupedTransactionItem.transaction(tx));
// // // // //     }
// // // // //     return items;
// // // // //   }

// // // // //   // Function to show confirmation dialog and then delete transaction
// // // // //   Future<void> _confirmAndDelete(BuildContext context, TransactionModel transaction) async {
// // // // //     final bool confirm = await showDialog(
// // // // //       context: context, // Still use the local context for the dialog itself
// // // // //       builder: (BuildContext dialogContext) {
// // // // //         return AlertDialog(
// // // // //           backgroundColor: AppColors.card, // Use card background for dialog
// // // // //           title: Text('Delete Transaction?', style: TextStyle(color: AppColors.textPrimary)),
// // // // //           content: Text(
// // // // //             'Are you sure you want to delete "${transaction.title ?? 'this transaction'}"?',
// // // // //             style: TextStyle(color: AppColors.textPrimary),
// // // // //           ),
// // // // //           actions: <Widget>[
// // // // //             TextButton(
// // // // //               onPressed: () => Navigator.of(dialogContext).pop(false),
// // // // //               child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
// // // // //             ),
// // // // //             ElevatedButton(
// // // // //               onPressed: () => Navigator.of(dialogContext).pop(true),
// // // // //               style: ElevatedButton.styleFrom(
// // // // //                 backgroundColor: AppColors.delete, // Use delete color for confirmation button
// // // // //                 foregroundColor: AppColors.buttonText,
// // // // //               ),
// // // // //               child: const Text('Delete'),
// // // // //             ),
// // // // //           ],
// // // // //         );
// // // // //       },
// // // // //     ) ?? false; // Default to false if dialog is dismissed

// // // // //     // No need for `if (!mounted)` directly before showDialog, as context is valid then.
// // // // //     // Also, after showDialog, if the widget were unmounted, the `confirm` variable
// // // // //     // wouldn't be set until the dialog returned.

// // // // //     if (confirm) {
// // // // //       try {
// // // // //         await ref.read(transactionsProvider.notifier).deleteTransaction(transaction.id);

// // // // //         // Use the global key to access ScaffoldMessenger, no need for `mounted` check here
// // // // //         scaffoldMessengerKey.currentState?.showSnackBar(
// // // // //           SnackBar(
// // // // //             content: Text('Transaction "${transaction.title ?? 'Unknown'}" deleted.', style: TextStyle(color: AppColors.textPrimary)),
// // // // //             backgroundColor: Colors.green, // Success color
// // // // //           ),
// // // // //         );
// // // // //       } catch (e) {
// // // // //         // Use the global key to access ScaffoldMessenger, no need for `mounted` check here
// // // // //         scaffoldMessengerKey.currentState?.showSnackBar(
// // // // //           SnackBar(
// // // // //             content: Text(e.toString().replaceFirst('Exception: ', ''), style: TextStyle(color: AppColors.buttonText)),
// // // // //             backgroundColor: AppColors.delete, // Error color
// // // // //           ),
// // // // //         );
// // // // //       }
// // // // //     }
// // // // //   }

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     final transactionsAsync = ref.watch(transactionsProvider);

// // // // //     return Theme( // Wrap with Theme to apply AppColors
// // // // //       data: ThemeData(
// // // // //         brightness: Brightness.dark, // Set to dark theme
// // // // //         scaffoldBackgroundColor: AppColors.background,
// // // // //         cardColor: AppColors.card,
// // // // //         primaryColor: AppColors.primary,
// // // // //         hintColor: AppColors.textSecondary, // For labels in input fields
// // // // //         appBarTheme: const AppBarTheme(
// // // // //           backgroundColor: AppColors.background,
// // // // //           foregroundColor: AppColors.textPrimary,
// // // // //           elevation: 1,
// // // // //         ),
// // // // //         textTheme: const TextTheme(
// // // // //           displayLarge: TextStyle(color: AppColors.textPrimary),
// // // // //           displayMedium: TextStyle(color: AppColors.textPrimary),
// // // // //           displaySmall: TextStyle(color: AppColors.textPrimary),
// // // // //           headlineLarge: TextStyle(color: AppColors.textPrimary),
// // // // //           headlineMedium: TextStyle(color: AppColors.textPrimary),
// // // // //           headlineSmall: TextStyle(color: AppColors.textPrimary),
// // // // //           titleLarge: TextStyle(color: AppColors.textPrimary),
// // // // //           titleMedium: TextStyle(color: AppColors.textPrimary),
// // // // //           titleSmall: TextStyle(color: AppColors.textPrimary),
// // // // //           bodyLarge: TextStyle(color: AppColors.textPrimary),
// // // // //           bodyMedium: TextStyle(color: AppColors.textPrimary),
// // // // //           bodySmall: TextStyle(color: AppColors.textSecondary),
// // // // //           labelLarge: TextStyle(color: AppColors.buttonText), // For button text
// // // // //           labelMedium: TextStyle(color: AppColors.textSecondary),
// // // // //           labelSmall: TextStyle(color: AppColors.textSecondary),
// // // // //         ),
// // // // //         inputDecorationTheme: InputDecorationTheme(
// // // // //           labelStyle: const TextStyle(color: AppColors.textSecondary),
// // // // //           enabledBorder: OutlineInputBorder(
// // // // //             borderRadius: BorderRadius.circular(10.0),
// // // // //             borderSide: const BorderSide(color: AppColors.border),
// // // // //           ),
// // // // //           focusedBorder: OutlineInputBorder(
// // // // //             borderRadius: BorderRadius.circular(10.0),
// // // // //             borderSide: const BorderSide(color: AppColors.primary),
// // // // //           ),
// // // // //           border: OutlineInputBorder(
// // // // //             borderRadius: BorderRadius.circular(10.0),
// // // // //             borderSide: const BorderSide(color: AppColors.border),
// // // // //           ),
// // // // //           filled: true,
// // // // //           fillColor: AppColors.chip, // Use chip color for input background
// // // // //         ),
// // // // //         elevatedButtonTheme: ElevatedButtonThemeData(
// // // // //           style: ElevatedButton.styleFrom(
// // // // //             shape: RoundedRectangleBorder(
// // // // //               borderRadius: BorderRadius.circular(8.0),
// // // // //             ),
// // // // //             padding: const EdgeInsets.symmetric(vertical: 10.0),
// // // // //           ),
// // // // //         ),
// // // // //         cardTheme: CardThemeData(
// // // // //           color: AppColors.card,
// // // // //           elevation: 2,
// // // // //           shape: RoundedRectangleBorder(
// // // // //             borderRadius: BorderRadius.circular(10.0),
// // // // //           ),
// // // // //         ),
// // // // //         dividerColor: AppColors.border,
// // // // //         // Customize dropdown menu button text color
// // // // //         dropdownMenuTheme: DropdownMenuThemeData(
// // // // //           textStyle: const TextStyle(color: AppColors.textPrimary), // Text color of selected item in dropdown
// // // // //           menuStyle: MenuStyle(
// // // // //             backgroundColor: MaterialStateProperty.all(AppColors.card), // Background of dropdown menu itself
// // // // //           ),
// // // // //         ),
// // // // //       ),
// // // // //       child: Scaffold(
// // // // //         appBar: AppBar(
// // // // //           title: const Text(
// // // // //             'Ledger',
// // // // //             style: TextStyle(
// // // // //               fontWeight: FontWeight.bold,
// // // // //               fontSize: 22,
// // // // //             ),
// // // // //           ),
// // // // //           centerTitle: true,
// // // // //         ),
// // // // //         body: transactionsAsync.when(
// // // // //           loading: () => const Center(child: CircularProgressIndicator()),
// // // // //           error: (e, st) => Center(
// // // // //               child: Text('Error: $e', style: const TextStyle(color: AppColors.delete))),
// // // // //           data: (transactions) {
// // // // //             List<TransactionModel> filtered = transactions;

// // // // //             // Corrected categories and accounts generation to prevent duplicates of 'All'
// // // // //             final List<String> categories = {
// // // // //               'All', // Start with 'All' in the set
// // // // //               ...transactions.map((tx) => tx.category ?? '')
// // // // //             }
// // // // //                 .where((category) => category.isNotEmpty) // Filter out empty strings if any
// // // // //                 .toList();
// // // // //             categories.sort(); // Sort the existing unique elements (including 'All')

// // // // //             // Ensure 'All' is at the very beginning and only once
// // // // //             if (categories.contains('All')) {
// // // // //               categories.remove('All'); // Remove if it was sorted somewhere else
// // // // //             }
// // // // //             categories.insert(0, 'All'); // Add it back at the beginning

// // // // //             final List<String> accounts = {
// // // // //               'All', // Start with 'All' in the set
// // // // //               ...transactions.map((tx) => tx.account ?? '')
// // // // //             }
// // // // //                 .where((account) => account.isNotEmpty) // Filter out empty strings if any
// // // // //                 .toList();
// // // // //             accounts.sort(); // Sort the existing unique elements (including 'All')

// // // // //             // Ensure 'All' is at the very beginning and only once
// // // // //             if (accounts.contains('All')) {
// // // // //               accounts.remove('All'); // Remove if it was sorted somewhere else
// // // // //             }
// // // // //             accounts.insert(0, 'All'); // Add it back at the beginning

// // // // //             DateTime start;
// // // // //             DateTime end;
// // // // //             String dateRangeDisplay = '';

// // // // //             if (_selectedView == 'Daily') {
// // // // //               start = DateTime(_currentDate.year, _currentDate.month, _currentDate.day);
// // // // //               end = start.add(const Duration(days: 1));
// // // // //               dateRangeDisplay = DateFormat.yMMMd().format(_currentDate);
// // // // //             } else if (_selectedView == 'Weekly') {
// // // // //               // Calculate start of the week (Monday)
// // // // //               start = _currentDate.subtract(Duration(days: _currentDate.weekday - 1));
// // // // //               end = start.add(const Duration(days: 7));
// // // // //               dateRangeDisplay =
// // // // //                   '${DateFormat.yMMMd().format(start)} - ${DateFormat.yMMMd().format(end.subtract(const Duration(days: 1)))}';
// // // // //             } else if (_selectedView == 'Monthly') {
// // // // //               start = DateTime(_currentDate.year, _currentDate.month, 1);
// // // // //               end = DateTime(_currentDate.year, _currentDate.month + 1, 1);
// // // // //               dateRangeDisplay = DateFormat.yMMMM().format(_currentDate);
// // // // //             } else if (_selectedView == 'Custom' && _customRange != null) {
// // // // //               start = _customRange!.start;
// // // // //               // The end date from showDateRangePicker is inclusive, so add 1 day to make it exclusive for filtering
// // // // //               end = _customRange!.end.add(const Duration(days: 1));
// // // // //               dateRangeDisplay =
// // // // //                   '${DateFormat.yMMMd().format(_customRange!.start)} - ${DateFormat.yMMMd().format(_customRange!.end)}';
// // // // //             } else {
// // // // //               // Total view
// // // // //               start = DateTime(2000, 1, 1); // Very old date
// // // // //               end = DateTime.now().add(const Duration(days: 365 * 10)); // Far future date
// // // // //               dateRangeDisplay = 'All Time';
// // // // //             }

// // // // //             filtered = filtered.where((tx) {
// // // // //               final txDate = tx.date ?? DateTime.now();
// // // // //               final matchesCategory = _selectedCategory == 'All' ||
// // // // //                   (tx.category ?? '') == _selectedCategory;
// // // // //               final matchesAccount = _selectedAccount == 'All' ||
// // // // //                   (tx.account ?? '') == _selectedAccount;

// // // // //               // Ensure comparison is consistent: txDate >= start and txDate < end
// // // // //               return txDate.isAfter(start.subtract(const Duration(milliseconds: 1))) &&
// // // // //                   txDate.isBefore(end) &&
// // // // //                   matchesCategory &&
// // // // //                   matchesAccount;
// // // // //             }).toList();

// // // // //             final incomeTotal = filtered
// // // // //                 .where((tx) => tx.type == TransactionType.income)
// // // // //                 .fold<double>(0, (sum, tx) => sum + (tx.amount ?? 0));
// // // // //             final expenseTotal = filtered
// // // // //                 .where((tx) => tx.type == TransactionType.expense)
// // // // //                 .fold<double>(0, (sum, tx) => sum + (tx.amount ?? 0));
// // // // //             final net = incomeTotal - expenseTotal;

// // // // //             // Get grouped transactions for the ListView
// // // // //             final List<GroupedTransactionItem> groupedItems = _getGroupedTransactionItems(filtered);

// // // // //             return Column(
// // // // //               children: [
// // // // //                 Padding(
// // // // //                   padding: const EdgeInsets.all(16.0),
// // // // //                   child: Row(
// // // // //                     children: [
// // // // //                       Expanded(
// // // // //                         child: DropdownButtonFormField<String>(
// // // // //                           value: _selectedCategory,
// // // // //                           isExpanded: true, // Crucial for dropdown overflow fix
// // // // //                           decoration: const InputDecoration(
// // // // //                             labelText: 'Category',
// // // // //                             // Styles are applied via ThemeData
// // // // //                           ),
// // // // //                           items: categories.map((cat) {
// // // // //                             return DropdownMenuItem(
// // // // //                               value: cat,
// // // // //                               child: Text(
// // // // //                                 cat == 'All'
// // // // //                                     ? 'All Categories'
// // // // //                                     : (cat.isEmpty ? 'Uncategorized' : cat),
// // // // //                                 style: const TextStyle(fontSize: 14),
// // // // //                                 overflow: TextOverflow.ellipsis, // Crucial for dropdown overflow fix
// // // // //                               ),
// // // // //                             );
// // // // //                           }).toList(),
// // // // //                           onChanged: (value) {
// // // // //                             if (value != null) {
// // // // //                               setState(() => _selectedCategory = value);
// // // // //                             }
// // // // //                           },
// // // // //                           // Ensure the selected item's text color is primary
// // // // //                           selectedItemBuilder: (BuildContext context) {
// // // // //                             return categories.map((String value) {
// // // // //                               return Text(
// // // // //                                 value == 'All'
// // // // //                                     ? 'All Categories'
// // // // //                                     : (value.isEmpty ? 'Uncategorized' : value),
// // // // //                                 style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
// // // // //                                 overflow: TextOverflow.ellipsis, // Crucial for dropdown overflow fix
// // // // //                               );
// // // // //                             }).toList();
// // // // //                           },
// // // // //                         ),
// // // // //                       ),
// // // // //                       const SizedBox(width: 12),
// // // // //                       Expanded(
// // // // //                         child: DropdownButtonFormField<String>(
// // // // //                           value: _selectedAccount,
// // // // //                           isExpanded: true, // Crucial for dropdown overflow fix
// // // // //                           decoration: const InputDecoration(
// // // // //                             labelText: 'Account',
// // // // //                             // Styles are applied via ThemeData
// // // // //                           ),
// // // // //                           items: accounts.map((acc) {
// // // // //                             return DropdownMenuItem(
// // // // //                               value: acc,
// // // // //                               child: Text(
// // // // //                                 acc == 'All'
// // // // //                                     ? 'All Accounts'
// // // // //                                     : (acc.isEmpty ? 'Unnamed' : acc),
// // // // //                                 style: const TextStyle(fontSize: 14),
// // // // //                                 overflow: TextOverflow.ellipsis, // Crucial for dropdown overflow fix
// // // // //                               ),
// // // // //                             );
// // // // //                           }).toList(),
// // // // //                           onChanged: (value) {
// // // // //                             if (value != null) {
// // // // //                               setState(() => _selectedAccount = value);
// // // // //                             }
// // // // //                           },
// // // // //                           // Ensure the selected item's text color is primary
// // // // //                           selectedItemBuilder: (BuildContext context) {
// // // // //                             return accounts.map((String value) {
// // // // //                               return Text(
// // // // //                                 value == 'All'
// // // // //                                     ? 'All Accounts'
// // // // //                                     : (value.isEmpty ? 'Unnamed' : value),
// // // // //                                 style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
// // // // //                                 overflow: TextOverflow.ellipsis, // Crucial for dropdown overflow fix
// // // // //                               );
// // // // //                             }).toList();
// // // // //                           },
// // // // //                         ),
// // // // //                       ),
// // // // //                     ],
// // // // //                   ),
// // // // //                 ),
// // // // //                 Padding(
// // // // //                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
// // // // //                   child: Row(
// // // // //                     children: _views.map((view) {
// // // // //                       final isSelected = _selectedView == view;
// // // // //                       return Expanded(
// // // // //                         child: Padding(
// // // // //                           padding: const EdgeInsets.symmetric(horizontal: 4.0),
// // // // //                           child: ElevatedButton(
// // // // //                             style: ElevatedButton.styleFrom(
// // // // //                               backgroundColor: isSelected
// // // // //                                   ? AppColors.primary
// // // // //                                   : AppColors.chip, // Use AppColors
// // // // //                               foregroundColor:
// // // // //                                   isSelected ? AppColors.buttonText : AppColors.textPrimary, // Use AppColors
// // // // //                               elevation: isSelected ? 4 : 0,
// // // // //                               shadowColor: isSelected ? AppColors.primary.withOpacity(0.3) : Colors.transparent,
// // // // //                             ),
// // // // //                             onPressed: () async {
// // // // //                               if (view == 'Custom') {
// // // // //                                 final picked = await showDateRangePicker(
// // // // //                                   context: context,
// // // // //                                   firstDate: DateTime(2000),
// // // // //                                   lastDate: DateTime(2100),
// // // // //                                   helpText: 'Select Custom Date Range',
// // // // //                                   confirmText: 'Confirm',
// // // // //                                   cancelText: 'Cancel',
// // // // //                                   builder: (context, child) {
// // // // //                                     return Theme(
// // // // //                                       data: ThemeData.dark().copyWith( // Use dark theme for picker
// // // // //                                         primaryColor: AppColors.primary,
// // // // //                                         colorScheme: ColorScheme.dark(
// // // // //                                           primary: AppColors.primary,
// // // // //                                           onPrimary: AppColors.buttonText, // Text on primary background
// // // // //                                           surface: AppColors.card, // Picker background
// // // // //                                           onSurface: AppColors.textPrimary, // Text on picker background
// // // // //                                         ),
// // // // //                                         textTheme: const TextTheme(
// // // // //                                           titleLarge: TextStyle(color: AppColors.textPrimary), // Year/Month title
// // // // //                                           bodyLarge: TextStyle(color: AppColors.textPrimary), // Day numbers
// // // // //                                           labelLarge: TextStyle(color: AppColors.textPrimary), // Button text (CANCEL/OK)
// // // // //                                         ),
// // // // //                                         dialogBackgroundColor: AppColors.background,
// // // // //                                       ),
// // // // //                                       child: child!,
// // // // //                                     );
// // // // //                                   },
// // // // //                                 );
// // // // //                                 if (picked != null) {
// // // // //                                   setState(() {
// // // // //                                     _customRange = picked;
// // // // //                                     _selectedView = view;
// // // // //                                   });
// // // // //                                 }
// // // // //                               } else {
// // // // //                                 setState(() {
// // // // //                                   _selectedView = view;
// // // // //                                   // When switching to a non-custom view, reset _currentDate to now for consistency
// // // // //                                   if (view == 'Daily' || view == 'Weekly' || view == 'Monthly') {
// // // // //                                     bool shouldReset = false;
// // // // //                                     // Check if current date for the selected view is significantly off from "now"
// // // // //                                     if (view == 'Daily' && !(_currentDate.year == DateTime.now().year && _currentDate.month == DateTime.now().month && _currentDate.day == DateTime.now().day)) {
// // // // //                                       shouldReset = true;
// // // // //                                     } else if (view == 'Weekly') {
// // // // //                                       final currentWeekMonday = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
// // // // //                                       final selectedWeekMonday = _currentDate.subtract(Duration(days: _currentDate.weekday - 1));
// // // // //                                       if (currentWeekMonday.difference(selectedWeekMonday).inDays != 0) {
// // // // //                                         shouldReset = true;
// // // // //                                       }
// // // // //                                     } else if (view == 'Monthly' && !(_currentDate.year == DateTime.now().year && _currentDate.month == DateTime.now().month)) {
// // // // //                                       shouldReset = true;
// // // // //                                     }

// // // // //                                     if (shouldReset) {
// // // // //                                       _currentDate = DateTime.now();
// // // // //                                     }
// // // // //                                   }
// // // // //                                 });
// // // // //                               }
// // // // //                             },
// // // // //                             child:
// // // // //                                 Text(view, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
// // // // //                           ),
// // // // //                         ),
// // // // //                       );
// // // // //                     }).toList(),
// // // // //                   ),
// // // // //                 ),
// // // // //                 const SizedBox(height: 12),

// // // // //                 // Date Navigation Row (only for Daily, Weekly, Monthly)
// // // // //                 if (_selectedView != 'Total' && _selectedView != 'Custom')
// // // // //                   Padding(
// // // // //                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
// // // // //                     child: Row(
// // // // //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // // //                       children: [
// // // // //                         IconButton(
// // // // //                           icon: const Icon(Icons.arrow_back_ios, size: 18),
// // // // //                           color: AppColors.textPrimary,
// // // // //                           onPressed: () => _navigatePeriod(-1, _selectedView),
// // // // //                         ),
// // // // //                         Expanded( // Use Expanded to prevent overflow
// // // // //                           child: Center(
// // // // //                             child: Text(
// // // // //                               dateRangeDisplay,
// // // // //                               style: const TextStyle(
// // // // //                                 fontSize: 16,
// // // // //                                 fontWeight: FontWeight.bold,
// // // // //                                 color: AppColors.textPrimary,
// // // // //                               ),
// // // // //                             ),
// // // // //                           ),
// // // // //                         ),
// // // // //                         IconButton(
// // // // //                           icon: const Icon(Icons.arrow_forward_ios, size: 18),
// // // // //                           color: AppColors.textPrimary,
// // // // //                           onPressed: () => _navigatePeriod(1, _selectedView),
// // // // //                         ),
// // // // //                       ],
// // // // //                     ),
// // // // //                   ),
// // // // //                 const SizedBox(height: 12),

// // // // //                 Container(
// // // // //                   margin: const EdgeInsets.symmetric(horizontal: 16.0),
// // // // //                   padding: const EdgeInsets.all(16.0),
// // // // //                   decoration: BoxDecoration(
// // // // //                     color: AppColors.card, // Use AppColors
// // // // //                     borderRadius: BorderRadius.circular(12.0),
// // // // //                     boxShadow: [
// // // // //                       BoxShadow(
// // // // //                         color: Colors.black.withOpacity(0.2), // Darker shadow for dark theme
// // // // //                         spreadRadius: 1,
// // // // //                         blurRadius: 5,
// // // // //                         offset: const Offset(0, 3),
// // // // //                       ),
// // // // //                     ],
// // // // //                   ),
// // // // //                   child: Row(
// // // // //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// // // // //                     children: [
// // // // //                       _buildSummaryTile('Income', incomeTotal, Colors.greenAccent.shade400), // Brighter green
// // // // //                       _buildSummaryTile('Expense', expenseTotal, Colors.redAccent.shade400),   // Brighter red
// // // // //                       _buildSummaryTile(
// // // // //                           'Net', net, net >= 0 ? AppColors.primary : Colors.redAccent.shade400), // Use primary for net positive
// // // // //                     ],
// // // // //                   ),
// // // // //                 ),
// // // // //                 const SizedBox(height: 16),
// // // // //                 const Padding(
// // // // //                   padding: EdgeInsets.symmetric(horizontal: 16.0),
// // // // //                   child: Align(
// // // // //                     alignment: Alignment.centerLeft,
// // // // //                     child: Text(
// // // // //                       'Transactions',
// // // // //                       style: TextStyle(
// // // // //                         fontSize: 18,
// // // // //                         fontWeight: FontWeight.bold,
// // // // //                         color: AppColors.textPrimary,
// // // // //                       ),
// // // // //                     ),
// // // // //                   ),
// // // // //                 ),
// // // // //                 const Divider(height: 24, thickness: 1, color: AppColors.border),
// // // // //                 Expanded(
// // // // //                   child: groupedItems.isEmpty
// // // // //                       ? Center(
// // // // //                           child: Column(
// // // // //                             mainAxisAlignment: MainAxisAlignment.center,
// // // // //                             children: [
// // // // //                               Icon(Icons.receipt_long, size: 60, color: AppColors.textSecondary),
// // // // //                               const SizedBox(height: 10),
// // // // //                               Text(
// // // // //                                 'No transactions found for this period.',
// // // // //                                 style: TextStyle(
// // // // //                                   fontSize: 16,
// // // // //                                   color: AppColors.textSecondary,
// // // // //                                 ),
// // // // //                               ),
// // // // //                             ],
// // // // //                           ),
// // // // //                         )
// // // // //                       : ListView.builder(
// // // // //                           itemCount: groupedItems.length,
// // // // //                           itemBuilder: (context, index) {
// // // // //                             final item = groupedItems[index];

// // // // //                             if (item.isDateHeader) {
// // // // //                               // It's a date header
// // // // //                               return Padding(
// // // // //                                 padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
// // // // //                                 child: Text(
// // // // //                                   DateFormat('EEEE, MMM d, y').format(item.date!), // E.g., "Thursday, Jun 27, 2025"
// // // // //                                   style: const TextStyle(
// // // // //                                     fontSize: 16,
// // // // //                                     fontWeight: FontWeight.bold,
// // // // //                                     color: AppColors.textPrimary,
// // // // //                                   ),
// // // // //                                 ),
// // // // //                               );
// // // // //                             } else {
// // // // //                               // It's a transaction item
// // // // //                               final tx = item.transaction!;
// // // // //                               return Slidable( // Wrap the Card with Slidable
// // // // //                                 key: ValueKey(tx.id), // Unique key for each slidable item
// // // // //                                 endActionPane: ActionPane(
// // // // //                                   motion: const DrawerMotion(), // Simple drawer motion
// // // // //                                   extentRatio: 0.25, // How much of the item width the action pane takes
// // // // //                                   children: [
// // // // //                                     SlidableAction(
// // // // //                                       onPressed: (context) => _confirmAndDelete(context, tx),
// // // // //                                       backgroundColor: AppColors.delete,
// // // // //                                       foregroundColor: AppColors.buttonText,
// // // // //                                       icon: Icons.delete,
// // // // //                                       label: 'Delete',
// // // // //                                     ),
// // // // //                                   ],
// // // // //                                 ),
// // // // //                                 child: Card(
// // // // //                                   margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
// // // // //                                   elevation: 2,
// // // // //                                   child: ListTile(
// // // // //                                     contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
// // // // //                                     leading: CircleAvatar(
// // // // //                                       backgroundColor: tx.type == TransactionType.income
// // // // //                                           ? Colors.green.shade800 // Darker shade for income background
// // // // //                                           : Colors.red.shade800, // Darker shade for expense background
// // // // //                                       child: Icon(
// // // // //                                         tx.type == TransactionType.income
// // // // //                                             ? Icons.arrow_downward_rounded
// // // // //                                             : Icons.arrow_upward_rounded,
// // // // //                                         color: tx.type == TransactionType.income
// // // // //                                             ? Colors.greenAccent.shade100 // Brighter icon
// // // // //                                             : Colors.redAccent.shade100, // Brighter icon
// // // // //                                       ),
// // // // //                                     ),
// // // // //                                     title: Text(
// // // // //                                       tx.title ?? 'No Title',
// // // // //                                       style: const TextStyle(
// // // // //                                         fontWeight: FontWeight.bold,
// // // // //                                         fontSize: 16,
// // // // //                                         color: AppColors.cardText, // White text for titles on cards
// // // // //                                       ),
// // // // //                                     ),
// // // // //                                     subtitle: Text(
// // // // //                                       // Adjusted subtitle to show full date for daily, then time, account and category
// // // // //                                       '${DateFormat('MMMM d, y').format(tx.date ?? DateTime.now())} ${DateFormat('h:mm a').format(tx.date ?? DateTime.now())} • ${tx.account ?? 'N/A'} • ${tx.category ?? 'N/A'}',
// // // // //                                       style: const TextStyle(
// // // // //                                         fontSize: 12,
// // // // //                                         color: AppColors.textSecondary,
// // // // //                                       ),
// // // // //                                     ),
// // // // //                                     trailing: Text(
// // // // //                                       '₹${tx.amount?.toStringAsFixed(2)}',
// // // // //                                       style: TextStyle(
// // // // //                                         fontWeight: FontWeight.w800,
// // // // //                                         fontSize: 16,
// // // // //                                         color: tx.type == TransactionType.income
// // // // //                                             ? Colors.greenAccent.shade400
// // // // //                                             : Colors.redAccent.shade400,
// // // // //                                       ),
// // // // //                                     ),
// // // // //                                   ),
// // // // //                                 ),
// // // // //                               );
// // // // //                             }
// // // // //                           },
// // // // //                         ),
// // // // //                 ),
// // // // //               ],
// // // // //             );
// // // // //           },
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   Widget _buildSummaryTile(String label, double amount, Color color) {
// // // // //     return Column(
// // // // //       children: [
// // // // //         Text(
// // // // //           label,
// // // // //           style: const TextStyle(
// // // // //             fontWeight: FontWeight.bold,
// // // // //             fontSize: 14,
// // // // //             color: AppColors.textSecondary, // Use secondary text color
// // // // //           ),
// // // // //         ),
// // // // //         const SizedBox(height: 4),
// // // // //         Text(
// // // // //           '₹${amount.toStringAsFixed(2)}',
// // // // //           style: TextStyle(
// // // // //             color: color,
// // // // //             fontSize: 18,
// // // // //             fontWeight: FontWeight.w800,
// // // // //           ),
// // // // //         ),
// // // // //       ],
// // // // //     );
// // // // //   }
// // // // // }
// // // // // lib/pages/ledger.dart

// // // // import 'package:flutter/material.dart';
// // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // import 'package:intl/intl.dart';
// // // // import 'package:notegoexpense/model/transaction_notifier.dart';
// // // // import '../model/transaction_model.dart';
// // // // import '../extras/AppColors.dart';
// // // // import 'package:flutter_slidable/flutter_slidable.dart';
// // // // // Import the file where scaffoldMessengerKey is defined
// // // // import 'package:notegoexpense/main.dart'; // <--- IMPORTANT: Adjust this path if main.dart is elsewhere

// // // // // Helper class to represent items in the grouped list (either a date header or a transaction)
// // // // class GroupedTransactionItem {
// // // //   final DateTime? date; // For date headers
// // // //   final TransactionModel? transaction; // For transaction items

// // // //   GroupedTransactionItem.date(this.date) : transaction = null;
// // // //   GroupedTransactionItem.transaction(this.transaction) : date = null;

// // // //   bool get isDateHeader => date != null;
// // // //   bool get isTransaction => transaction != null;
// // // // }

// // // // class LedgerPage extends ConsumerStatefulWidget {
// // // //   const LedgerPage({super.key});

// // // //   @override
// // // //   ConsumerState<LedgerPage> createState() => _LedgerPageState();
// // // // }

// // // // class _LedgerPageState extends ConsumerState<LedgerPage> {
// // // //   String _selectedView = 'Daily';
// // // //   DateTimeRange? _customRange;
// // // //   DateTime _currentDate = DateTime.now(); // Renamed _today to _currentDate for clarity

// // // //   String _selectedCategory = 'All';
// // // //   String _selectedAccount = 'All';

// // // //   final List<String> _views = ['Daily', 'Weekly', 'Monthly', 'Total', 'Custom'];

// // // //   // Function to move the date range for Daily/Weekly/Monthly views
// // // //   void _navigatePeriod(int amount, String viewType) {
// // // //     setState(() {
// // // //       if (viewType == 'Daily') {
// // // //         _currentDate = _currentDate.add(Duration(days: amount));
// // // //       } else if (viewType == 'Weekly') {
// // // //         _currentDate = _currentDate.add(Duration(days: amount * 7));
// // // //       } else if (viewType == 'Monthly') {
// // // //         // Correctly handle month addition/subtraction
// // // //         _currentDate = DateTime(
// // // //           _currentDate.year,
// // // //           _currentDate.month + amount,
// // // //           // Clamp day to prevent overflow to next month (e.g., Feb 30th -> Mar 2nd)
// // // //           _currentDate.day.clamp(1, DateTime(_currentDate.year, _currentDate.month + amount + 1, 0).day),
// // // //         );
// // // //       }
// // // //     });
// // // //   }

// // // //   // Helper method to group transactions by date for display
// // // //   List<GroupedTransactionItem> _getGroupedTransactionItems(List<TransactionModel> transactions) {
// // // //     final List<GroupedTransactionItem> items = [];
// // // //     if (transactions.isEmpty) return items;

// // // //     // Sort by date descending
// // // //     transactions.sort((a, b) => (b.date ?? DateTime.now()).compareTo(a.date ?? DateTime.now()));

// // // //     DateTime? lastDateHeader;
// // // //     for (var tx in transactions) {
// // // //       final txDate = tx.date ?? DateTime.now();
// // // //       // Normalize txDate to just year, month, day for comparison
// // // //       final normalizedTxDate = DateTime(txDate.year, txDate.month, txDate.day);

// // // //       // Add a date header if it's a new day or the first transaction
// // // //       // Check if lastDateHeader is different from normalizedTxDate
// // // //       if (lastDateHeader == null || !normalizedTxDate.isAtSameMomentAs(lastDateHeader)) {
// // // //           items.add(GroupedTransactionItem.date(normalizedTxDate));
// // // //           lastDateHeader = normalizedTxDate;
// // // //       }
// // // //       items.add(GroupedTransactionItem.transaction(tx));
// // // //     }
// // // //     return items;
// // // //   }

// // // //   // Function to show confirmation dialog and then delete transaction
// // // //   Future<void> _confirmAndDelete(BuildContext context, TransactionModel transaction) async {
// // // //     final bool confirm = await showDialog(
// // // //       context: context, // Use the local context for the dialog itself
// // // //       builder: (BuildContext dialogContext) {
// // // //         return AlertDialog(
// // // //           backgroundColor: AppColors.card, // Use card background for dialog
// // // //           title: Text('Delete Transaction?', style: TextStyle(color: AppColors.textPrimary)),
// // // //           content: Text(
// // // //             'Are you sure you want to delete "${transaction.title ?? 'this transaction'}"?',
// // // //             style: TextStyle(color: AppColors.textPrimary),
// // // //           ),
// // // //           actions: <Widget>[
// // // //             TextButton(
// // // //               onPressed: () => Navigator.of(dialogContext).pop(false),
// // // //               child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
// // // //             ),
// // // //             ElevatedButton(
// // // //               onPressed: () => Navigator.of(dialogContext).pop(true),
// // // //               style: ElevatedButton.styleFrom(
// // // //                 backgroundColor: AppColors.delete, // Use delete color for confirmation button
// // // //                 foregroundColor: AppColors.buttonText,
// // // //               ),
// // // //               child: const Text('Delete'),
// // // //             ),
// // // //           ],
// // // //         );
// // // //       },
// // // //     ) ?? false; // Default to false if dialog is dismissed

// // // //     // IMPORTANT: Check if the widget is still mounted after the await call
// // // //     // This is crucial for *any* subsequent operation using the widget's context.
// // // //     if (!mounted) {
// // // //       return;
// // // //     }

// // // //     if (confirm) {
// // // //       try {
// // // //         // The line below only triggers the notifier; it does not directly use context for UI.
// // // //         await ref.read(transactionsProvider.notifier).deleteTransaction(transaction.id!);

// // // //         // Use the global key for ScaffoldMessenger, no need for `mounted` check here
// // // //         // as the global key is independent of this widget's mounted state.
// // // //         scaffoldMessengerKey.currentState?.showSnackBar(
// // // //           SnackBar(
// // // //             content: Text('Transaction "${transaction.title ?? 'Unknown'}" deleted.', style: TextStyle(color: AppColors.textPrimary)),
// // // //             backgroundColor: Colors.green, // Success color
// // // //           ),
// // // //         );
// // // //       } catch (e) {
// // // //         // Use the global key for ScaffoldMessenger, no need for `mounted` check here.
// // // //         scaffoldMessengerKey.currentState?.showSnackBar(
// // // //           SnackBar(
// // // //             content: Text(e.toString().replaceFirst('Exception: ', ''), style: TextStyle(color: AppColors.buttonText)),
// // // //             backgroundColor: AppColors.delete, // Error color
// // // //           ),
// // // //         );
// // // //       }
// // // //     }
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     final transactionsAsync = ref.watch(transactionsProvider);

// // // //     return Theme( // Wrap with Theme to apply AppColors
// // // //       data: ThemeData(
// // // //         brightness: Brightness.dark, // Set to dark theme
// // // //         scaffoldBackgroundColor: AppColors.background,
// // // //         cardColor: AppColors.card,
// // // //         primaryColor: AppColors.primary,
// // // //         hintColor: AppColors.textSecondary, // For labels in input fields
// // // //         appBarTheme: const AppBarTheme(
// // // //           backgroundColor: AppColors.background,
// // // //           foregroundColor: AppColors.textPrimary,
// // // //           elevation: 1,
// // // //         ),
// // // //         textTheme: const TextTheme(
// // // //           displayLarge: TextStyle(color: AppColors.textPrimary),
// // // //           displayMedium: TextStyle(color: AppColors.textPrimary),
// // // //           displaySmall: TextStyle(color: AppColors.textPrimary),
// // // //           headlineLarge: TextStyle(color: AppColors.textPrimary),
// // // //           headlineMedium: TextStyle(color: AppColors.textPrimary),
// // // //           headlineSmall: TextStyle(color: AppColors.textPrimary),
// // // //           titleLarge: TextStyle(color: AppColors.textPrimary),
// // // //           titleMedium: TextStyle(color: AppColors.textPrimary),
// // // //           titleSmall: TextStyle(color: AppColors.textPrimary),
// // // //           bodyLarge: TextStyle(color: AppColors.textPrimary),
// // // //           bodyMedium: TextStyle(color: AppColors.textPrimary),
// // // //           bodySmall: TextStyle(color: AppColors.textSecondary),
// // // //           labelLarge: TextStyle(color: AppColors.buttonText), // For button text
// // // //           labelMedium: TextStyle(color: AppColors.textSecondary),
// // // //           labelSmall: TextStyle(color: AppColors.textSecondary),
// // // //         ),
// // // //         inputDecorationTheme: InputDecorationTheme(
// // // //           labelStyle: const TextStyle(color: AppColors.textSecondary),
// // // //           enabledBorder: OutlineInputBorder(
// // // //             borderRadius: BorderRadius.circular(10.0),
// // // //             borderSide: const BorderSide(color: AppColors.border),
// // // //           ),
// // // //           focusedBorder: OutlineInputBorder(
// // // //             borderRadius: BorderRadius.circular(10.0),
// // // //             borderSide: const BorderSide(color: AppColors.primary),
// // // //           ),
// // // //           border: OutlineInputBorder(
// // // //             borderRadius: BorderRadius.circular(10.0),
// // // //             borderSide: const BorderSide(color: AppColors.border),
// // // //           ),
// // // //           filled: true,
// // // //           fillColor: AppColors.chip, // Use chip color for input background
// // // //         ),
// // // //         elevatedButtonTheme: ElevatedButtonThemeData(
// // // //           style: ElevatedButton.styleFrom(
// // // //             shape: RoundedRectangleBorder(
// // // //               borderRadius: BorderRadius.circular(8.0),
// // // //             ),
// // // //             padding: const EdgeInsets.symmetric(vertical: 10.0),
// // // //           ),
// // // //         ),
// // // //         cardTheme: CardThemeData(
// // // //           color: AppColors.card,
// // // //           elevation: 2,
// // // //           shape: RoundedRectangleBorder(
// // // //             borderRadius: BorderRadius.circular(10.0),
// // // //           ),
// // // //         ),
// // // //         dividerColor: AppColors.border,
// // // //         // Customize dropdown menu button text color
// // // //         dropdownMenuTheme: DropdownMenuThemeData(
// // // //           textStyle: const TextStyle(color: AppColors.textPrimary), // Text color of selected item in dropdown
// // // //           menuStyle: MenuStyle(
// // // //             backgroundColor: MaterialStateProperty.all(AppColors.card), // Background of dropdown menu itself
// // // //           ),
// // // //         ),
// // // //       ),
// // // //       child: Scaffold(
// // // //         appBar: AppBar(
// // // //           title: const Text(
// // // //             'Ledger',
// // // //             style: TextStyle(
// // // //               fontWeight: FontWeight.bold,
// // // //               fontSize: 22,
// // // //             ),
// // // //           ),
// // // //           centerTitle: true,
// // // //         ),
// // // //         body: transactionsAsync.when(
// // // //           loading: () => const Center(child: CircularProgressIndicator()),
// // // //           error: (e, st) => Center(
// // // //               child: Text('Error: $e', style: const TextStyle(color: AppColors.delete))),
// // // //           data: (transactions) {
// // // //             List<TransactionModel> filtered = transactions;

// // // //             // Corrected categories and accounts generation to prevent duplicates of 'All'
// // // //             final List<String> categories = {
// // // //               'All', // Start with 'All' in the set
// // // //               ...transactions.map((tx) => tx.category ?? '')
// // // //             }
// // // //                 .where((category) => category.isNotEmpty) // Filter out empty strings if any
// // // //                 .toList();
// // // //             categories.sort(); // Sort the existing unique elements (including 'All')

// // // //             // Ensure 'All' is at the very beginning and only once
// // // //             if (categories.contains('All')) {
// // // //               categories.remove('All'); // Remove if it was sorted somewhere else
// // // //             }
// // // //             categories.insert(0, 'All'); // Add it back at the beginning

// // // //             final List<String> accounts = {
// // // //               'All', // Start with 'All' in the set
// // // //               ...transactions.map((tx) => tx.account ?? '')
// // // //             }
// // // //                 .where((account) => account.isNotEmpty) // Filter out empty strings if any
// // // //                 .toList();
// // // //             accounts.sort(); // Sort the existing unique elements (including 'All')

// // // //             // Ensure 'All' is at the very beginning and only once
// // // //             if (accounts.contains('All')) {
// // // //               accounts.remove('All'); // Remove if it was sorted somewhere else
// // // //             }
// // // //             accounts.insert(0, 'All'); // Add it back at the beginning

// // // //             DateTime start;
// // // //             DateTime end;
// // // //             String dateRangeDisplay = '';

// // // //             if (_selectedView == 'Daily') {
// // // //               start = DateTime(_currentDate.year, _currentDate.month, _currentDate.day);
// // // //               end = start.add(const Duration(days: 1));
// // // //               dateRangeDisplay = DateFormat.yMMMd().format(_currentDate);
// // // //             } else if (_selectedView == 'Weekly') {
// // // //               // Calculate start of the week (Monday)
// // // //               start = _currentDate.subtract(Duration(days: _currentDate.weekday - 1));
// // // //               end = start.add(const Duration(days: 7));
// // // //               dateRangeDisplay =
// // // //                   '${DateFormat.yMMMd().format(start)} - ${DateFormat.yMMMd().format(end.subtract(const Duration(days: 1)))}';
// // // //             } else if (_selectedView == 'Monthly') {
// // // //               start = DateTime(_currentDate.year, _currentDate.month, 1);
// // // //               end = DateTime(_currentDate.year, _currentDate.month + 1, 1);
// // // //               dateRangeDisplay = DateFormat.yMMMM().format(_currentDate);
// // // //             } else if (_selectedView == 'Custom' && _customRange != null) {
// // // //               start = _customRange!.start;
// // // //               // The end date from showDateRangePicker is inclusive, so add 1 day to make it exclusive for filtering
// // // //               end = _customRange!.end.add(const Duration(days: 1));
// // // //               dateRangeDisplay =
// // // //                   '${DateFormat.yMMMd().format(_customRange!.start)} - ${DateFormat.yMMMd().format(_customRange!.end)}';
// // // //             } else {
// // // //               // Total view
// // // //               start = DateTime(2000, 1, 1); // Very old date
// // // //               end = DateTime.now().add(const Duration(days: 365 * 10)); // Far future date
// // // //               dateRangeDisplay = 'All Time';
// // // //             }

// // // //             filtered = filtered.where((tx) {
// // // //               final txDate = tx.date ?? DateTime.now();
// // // //               final matchesCategory = _selectedCategory == 'All' ||
// // // //                   (tx.category ?? '') == _selectedCategory;
// // // //               final matchesAccount = _selectedAccount == 'All' ||
// // // //                   (tx.account ?? '') == _selectedAccount;

// // // //               // Ensure comparison is consistent: txDate >= start and txDate < end
// // // //               return txDate.isAfter(start.subtract(const Duration(milliseconds: 1))) &&
// // // //                   txDate.isBefore(end) &&
// // // //                   matchesCategory &&
// // // //                   matchesAccount;
// // // //             }).toList();

// // // //             final incomeTotal = filtered
// // // //                 .where((tx) => tx.type == TransactionType.income)
// // // //                 .fold<double>(0, (sum, tx) => sum + (tx.amount ?? 0));
// // // //             final expenseTotal = filtered
// // // //                 .where((tx) => tx.type == TransactionType.expense)
// // // //                 .fold<double>(0, (sum, tx) => sum + (tx.amount ?? 0));
// // // //             final net = incomeTotal - expenseTotal;

// // // //             // Get grouped transactions for the ListView
// // // //             final List<GroupedTransactionItem> groupedItems = _getGroupedTransactionItems(filtered);

// // // //             return Column(
// // // //               children: [
// // // //                 Padding(
// // // //                   padding: const EdgeInsets.all(16.0),
// // // //                   child: Row(
// // // //                     children: [
// // // //                       Expanded(
// // // //                         child: DropdownButtonFormField<String>(
// // // //                           value: _selectedCategory,
// // // //                           isExpanded: true, // Crucial for dropdown overflow fix
// // // //                           decoration: const InputDecoration(
// // // //                             labelText: 'Category',
// // // //                             // Styles are applied via ThemeData
// // // //                           ),
// // // //                           items: categories.map((cat) {
// // // //                             return DropdownMenuItem(
// // // //                               value: cat,
// // // //                               child: Text(
// // // //                                 cat == 'All'
// // // //                                     ? 'All Categories'
// // // //                                     : (cat.isEmpty ? 'Uncategorized' : cat),
// // // //                                 style: const TextStyle(fontSize: 14),
// // // //                                 overflow: TextOverflow.ellipsis, // Crucial for dropdown overflow fix
// // // //                               ),
// // // //                             );
// // // //                           }).toList(),
// // // //                           onChanged: (value) {
// // // //                             if (value != null) {
// // // //                               setState(() => _selectedCategory = value);
// // // //                             }
// // // //                           },
// // // //                           // Ensure the selected item's text color is primary
// // // //                           selectedItemBuilder: (BuildContext context) {
// // // //                             return categories.map((String value) {
// // // //                               return Text(
// // // //                                 value == 'All'
// // // //                                     ? 'All Categories'
// // // //                                     : (value.isEmpty ? 'Uncategorized' : value),
// // // //                                 style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
// // // //                                 overflow: TextOverflow.ellipsis, // Crucial for dropdown overflow fix
// // // //                               );
// // // //                             }).toList();
// // // //                           },
// // // //                         ),
// // // //                       ),
// // // //                       const SizedBox(width: 12),
// // // // lib/pages/ledger.dart

// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // import 'package:intl/intl.dart';
// // // import 'package:notegoexpense/model/transaction_notifier.dart';
// // // import '../model/transaction_model.dart';
// // // import '../extras/AppColors.dart'; // Ensure this path is correct
// // // import 'package:flutter_slidable/flutter_slidable.dart';
// // // // IMPORTANT: Import the file where scaffoldMessengerKey is defined
// // // import 'package:notegoexpense/main.dart'; // Adjust this path if main.dart is not in lib/

// // // // Helper class to represent items in the grouped list (either a date header or a transaction)
// // // class GroupedTransactionItem {
// // //   final DateTime? date; // For date headers
// // //   final TransactionModel? transaction; // For transaction items

// // //   GroupedTransactionItem.date(this.date) : transaction = null;
// // //   GroupedTransactionItem.transaction(this.transaction) : date = null;

// // //   bool get isDateHeader => date != null;
// // //   bool get isTransaction => transaction != null;
// // // }

// // // class LedgerPage extends ConsumerStatefulWidget {
// // //   const LedgerPage({super.key});

// // //   @override
// // //   ConsumerState<LedgerPage> createState() => _LedgerPageState();
// // // }

// // // class _LedgerPageState extends ConsumerState<LedgerPage> {
// // //   String _selectedView = 'Daily';
// // //   DateTimeRange? _customRange;
// // //   DateTime _currentDate =
// // //       DateTime.now(); // Renamed _today to _currentDate for clarity

// // //   String _selectedCategory = 'All';
// // //   String _selectedAccount = 'All';

// // //   final List<String> _views = ['Daily', 'Weekly', 'Monthly', 'Total', 'Custom'];

// // //   // Function to move the date range for Daily/Weekly/Monthly views
// // //   void _navigatePeriod(int amount, String viewType) {
// // //     setState(() {
// // //       if (viewType == 'Daily') {
// // //         _currentDate = _currentDate.add(Duration(days: amount));
// // //       } else if (viewType == 'Weekly') {
// // //         _currentDate = _currentDate.add(Duration(days: amount * 7));
// // //       } else if (viewType == 'Monthly') {
// // //         // Correctly handle month addition/subtraction
// // //         _currentDate = DateTime(
// // //           _currentDate.year,
// // //           _currentDate.month + amount,
// // //           // Clamp day to prevent overflow to next month (e.g., Feb 30th -> Mar 2nd)
// // //           _currentDate.day.clamp(
// // //               1,
// // //               DateTime(_currentDate.year, _currentDate.month + amount + 1, 0)
// // //                   .day),
// // //         );
// // //       }
// // //     });
// // //   }

// // //   // Helper method to group transactions by date for display
// // //   List<GroupedTransactionItem> _getGroupedTransactionItems(
// // //       List<TransactionModel> transactions) {
// // //     final List<GroupedTransactionItem> items = [];
// // //     if (transactions.isEmpty) return items;

// // //     // Sort by date descending
// // //     transactions.sort((a, b) =>
// // //         (b.date ?? DateTime.now()).compareTo(a.date ?? DateTime.now()));

// // //     DateTime? lastDateHeader;
// // //     for (var tx in transactions) {
// // //       final txDate = tx.date ?? DateTime.now();
// // //       // Normalize txDate to just year, month, day for comparison
// // //       final normalizedTxDate = DateTime(txDate.year, txDate.month, txDate.day);

// // //       // Add a date header if it's a new day or the first transaction
// // //       // Check if lastDateHeader is different from normalizedTxDate
// // //       if (lastDateHeader == null ||
// // //           !normalizedTxDate.isAtSameMomentAs(lastDateHeader)) {
// // //         items.add(GroupedTransactionItem.date(normalizedTxDate));
// // //         lastDateHeader = normalizedTxDate;
// // //       }
// // //       items.add(GroupedTransactionItem.transaction(tx));
// // //     }
// // //     return items;
// // //   }

// // //   // Function to show confirmation dialog and then delete transaction
// // //   Future<void> _confirmAndDelete(
// // //       BuildContext context, TransactionModel transaction) async {
// // //     final bool confirm = await showDialog(
// // //           context: context, // Use the local context for the dialog itself
// // //           builder: (BuildContext dialogContext) {
// // //             return AlertDialog(
// // //               backgroundColor: AppColors.card, // Use card background for dialog
// // //               title: Text('Delete Transaction?',
// // //                   style: TextStyle(color: AppColors.textPrimary)),
// // //               content: Text(
// // //                 'Are you sure you want to delete "${transaction.title ?? 'this transaction'}"?',
// // //                 style: TextStyle(color: AppColors.textPrimary),
// // //               ),
// // //               actions: <Widget>[
// // //                 TextButton(
// // //                   onPressed: () => Navigator.of(dialogContext).pop(false),
// // //                   child: Text('Cancel',
// // //                       style: TextStyle(color: AppColors.textSecondary)),
// // //                 ),
// // //                 ElevatedButton(
// // //                   onPressed: () => Navigator.of(dialogContext).pop(true),
// // //                   style: ElevatedButton.styleFrom(
// // //                     backgroundColor: AppColors
// // //                         .delete, // Use delete color for confirmation button
// // //                     foregroundColor: AppColors.buttonText,
// // //                   ),
// // //                   child: const Text('Delete'),
// // //                 ),
// // //               ],
// // //             );
// // //           },
// // //         ) ??
// // //         false; // Default to false if dialog is dismissed

// // //     // IMPORTANT: Check if the widget is still mounted after the await call
// // //     // This is crucial for *any* subsequent operation using the widget's context,
// // //     // or if the widget could be unmounted while the dialog was open.
// // //     if (!mounted) {
// // //       return;
// // //     }

// // //     if (confirm) {
// // //       try {
// // //         // The line below only triggers the notifier; it does not directly use context for UI.
// // //         await ref
// // //             .read(transactionsProvider.notifier)
// // //             .deleteTransaction(transaction.id!);

// // //         // Use the global key for ScaffoldMessenger.
// // //         // This is robust as it doesn't rely on the local 'context' being mounted.
// // //         scaffoldMessengerKey.currentState?.showSnackBar(
// // //           SnackBar(
// // //             content: Text(
// // //                 'Transaction "${transaction.title ?? 'Unknown'}" deleted.',
// // //                 style: TextStyle(color: AppColors.textPrimary)),
// // //             backgroundColor: AppColors.success, // Use AppColors.success
// // //           ),
// // //         );
// // //       } catch (e) {
// // //         // Use the global key for ScaffoldMessenger.
// // //         scaffoldMessengerKey.currentState?.showSnackBar(
// // //           SnackBar(
// // //             content: Text(e.toString().replaceFirst('Exception: ', ''),
// // //                 style: TextStyle(color: AppColors.buttonText)),
// // //             backgroundColor: AppColors.error, // Use AppColors.error
// // //           ),
// // //         );
// // //       }
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final transactionsAsync = ref.watch(transactionsProvider);

// // //     return Theme(
// // //       // Wrap with Theme to apply AppColors
// // //       data: ThemeData(
// // //         brightness: Brightness.dark, // Set to dark theme
// // //         scaffoldBackgroundColor: AppColors.background,
// // //         cardColor: AppColors.card,
// // //         primaryColor: AppColors.primary, // Used for focus/active states
// // //         hintColor: AppColors.textSecondary, // For labels in input fields
// // //         appBarTheme: const AppBarTheme(
// // //           backgroundColor: AppColors.background,
// // //           foregroundColor: AppColors.textPrimary,
// // //           elevation: 1,
// // //         ),
// // //         textTheme: const TextTheme(
// // //           // Use textPrimary for main text
// // //           displayLarge: TextStyle(color: AppColors.textPrimary),
// // //           displayMedium: TextStyle(color: AppColors.textPrimary),
// // //           displaySmall: TextStyle(color: AppColors.textPrimary),
// // //           headlineLarge: TextStyle(color: AppColors.textPrimary),
// // //           headlineMedium: TextStyle(color: AppColors.textPrimary),
// // //           headlineSmall: TextStyle(color: AppColors.textPrimary),
// // //           titleLarge: TextStyle(color: AppColors.textPrimary),
// // //           titleMedium: TextStyle(color: AppColors.textPrimary),
// // //           titleSmall: TextStyle(color: AppColors.textPrimary),
// // //           bodyLarge: TextStyle(color: AppColors.textPrimary),
// // //           bodyMedium: TextStyle(color: AppColors.textPrimary),
// // //           // Use textSecondary for less prominent text (like bodySmall)
// // //           bodySmall: TextStyle(color: AppColors.textSecondary),
// // //           // Use buttonText for text on primary/accent buttons
// // //           labelLarge: TextStyle(color: AppColors.buttonText),
// // //           labelMedium: TextStyle(color: AppColors.textSecondary),
// // //           labelSmall: TextStyle(color: AppColors.textSecondary),
// // //         ),
// // //         inputDecorationTheme: InputDecorationTheme(
// // //           labelStyle: const TextStyle(color: AppColors.textSecondary),
// // //           enabledBorder: OutlineInputBorder(
// // //             borderRadius: BorderRadius.circular(10.0),
// // //             borderSide: const BorderSide(color: AppColors.border),
// // //           ),
// // //           focusedBorder: OutlineInputBorder(
// // //             borderRadius: BorderRadius.circular(10.0),
// // //             borderSide: const BorderSide(color: AppColors.primary),
// // //           ),
// // //           border: OutlineInputBorder(
// // //             borderRadius: BorderRadius.circular(10.0),
// // //             borderSide: const BorderSide(color: AppColors.border),
// // //           ),
// // //           filled: true,
// // //           fillColor: AppColors.chip, // Use chip color for input background
// // //         ),
// // //         elevatedButtonTheme: ElevatedButtonThemeData(
// // //           style: ElevatedButton.styleFrom(
// // //             shape: RoundedRectangleBorder(
// // //               borderRadius: BorderRadius.circular(8.0),
// // //             ),
// // //             padding: const EdgeInsets.symmetric(vertical: 10.0),
// // //           ),
// // //         ),
// // //         cardTheme: CardThemeData(
// // //           color: AppColors.card,
// // //           elevation: 2,
// // //           shape: RoundedRectangleBorder(
// // //             borderRadius: BorderRadius.circular(10.0),
// // //           ),
// // //         ),
// // //         dividerColor: AppColors.border,
// // //         // Customize dropdown menu button text color
// // //         dropdownMenuTheme: DropdownMenuThemeData(
// // //           textStyle: const TextStyle(
// // //               color: AppColors
// // //                   .textPrimary), // Text color of selected item in dropdown
// // //           menuStyle: MenuStyle(
// // //             backgroundColor: MaterialStateProperty.all(
// // //                 AppColors.card), // Background of dropdown menu itself
// // //           ),
// // //         ),
// // //       ),
// // //       child: Scaffold(
// // //         appBar: AppBar(
// // //           title: const Text(
// // //             'Ledger',
// // //             style: TextStyle(
// // //               fontWeight: FontWeight.bold,
// // //               fontSize: 22,
// // //             ),
// // //           ),
// // //           centerTitle: true,
// // //         ),
// // //         body: transactionsAsync.when(
// // //           loading: () => const Center(child: CircularProgressIndicator()),
// // //           error: (e, st) => Center(
// // //               child: Text('Error: $e',
// // //                   style: const TextStyle(color: AppColors.delete))),
// // //           data: (transactions) {
// // //             List<TransactionModel> filtered = transactions;

// // //             // Corrected categories and accounts generation to prevent duplicates of 'All'
// // //             final List<String> categories = {
// // //               'All', // Start with 'All' in the set
// // //               ...transactions.map((tx) => tx.category ?? '')
// // //             }
// // //                 .where((category) =>
// // //                     category.isNotEmpty) // Filter out empty strings if any
// // //                 .toList();
// // //             categories
// // //                 .sort(); // Sort the existing unique elements (including 'All')

// // //             // Ensure 'All' is at the very beginning and only once
// // //             if (categories.contains('All')) {
// // //               categories
// // //                   .remove('All'); // Remove if it was sorted somewhere else
// // //             }
// // //             categories.insert(0, 'All'); // Add it back at the beginning

// // //             final List<String> accounts = {
// // //               'All', // Start with 'All' in the set
// // //               ...transactions.map((tx) => tx.account ?? '')
// // //             }
// // //                 .where((account) =>
// // //                     account.isNotEmpty) // Filter out empty strings if any
// // //                 .toList();
// // //             accounts
// // //                 .sort(); // Sort the existing unique elements (including 'All')

// // //             // Ensure 'All' is at the very beginning and only once
// // //             if (accounts.contains('All')) {
// // //               accounts.remove('All'); // Remove if it was sorted somewhere else
// // //             }
// // //             accounts.insert(0, 'All'); // Add it back at the beginning

// // //             DateTime start;
// // //             DateTime end;
// // //             String dateRangeDisplay = '';

// // //             if (_selectedView == 'Daily') {
// // //               start = DateTime(
// // //                   _currentDate.year, _currentDate.month, _currentDate.day);
// // //               end = start.add(const Duration(days: 1));
// // //               dateRangeDisplay = DateFormat.yMMMd().format(_currentDate);
// // //             } else if (_selectedView == 'Weekly') {
// // //               // Calculate start of the week (Monday)
// // //               start = _currentDate
// // //                   .subtract(Duration(days: _currentDate.weekday - 1));
// // //               end = start.add(const Duration(days: 7));
// // //               dateRangeDisplay =
// // //                   '${DateFormat.yMMMd().format(start)} - ${DateFormat.yMMMd().format(end.subtract(const Duration(days: 1)))}';
// // //             } else if (_selectedView == 'Monthly') {
// // //               start = DateTime(_currentDate.year, _currentDate.month, 1);
// // //               end = DateTime(_currentDate.year, _currentDate.month + 1, 1);
// // //               dateRangeDisplay = DateFormat.yMMMM().format(_currentDate);
// // //             } else if (_selectedView == 'Custom' && _customRange != null) {
// // //               start = _customRange!.start;
// // //               // The end date from showDateRangePicker is inclusive, so add 1 day to make it exclusive for filtering
// // //               end = _customRange!.end.add(const Duration(days: 1));
// // //               dateRangeDisplay =
// // //                   '${DateFormat.yMMMd().format(_customRange!.start)} - ${DateFormat.yMMMd().format(_customRange!.end)}';
// // //             } else {
// // //               // Total view
// // //               start = DateTime(2000, 1, 1); // Very old date
// // //               end = DateTime.now()
// // //                   .add(const Duration(days: 365 * 10)); // Far future date
// // //               dateRangeDisplay = 'All Time';
// // //             }

// // //             filtered = filtered.where((tx) {
// // //               final txDate = tx.date ?? DateTime.now();
// // //               final matchesCategory = _selectedCategory == 'All' ||
// // //                   (tx.category ?? '') == _selectedCategory;
// // //               final matchesAccount = _selectedAccount == 'All' ||
// // //                   (tx.account ?? '') == _selectedAccount;

// // //               // Ensure comparison is consistent: txDate >= start and txDate < end
// // //               return txDate.isAfter(
// // //                       start.subtract(const Duration(milliseconds: 1))) &&
// // //                   txDate.isBefore(end) &&
// // //                   matchesCategory &&
// // //                   matchesAccount;
// // //             }).toList();

// // //             final incomeTotal = filtered
// // //                 .where((tx) => tx.type == TransactionType.income)
// // //                 .fold<double>(0, (sum, tx) => sum + (tx.amount ?? 0));
// // //             final expenseTotal = filtered
// // //                 .where((tx) => tx.type == TransactionType.expense)
// // //                 .fold<double>(0, (sum, tx) => sum + (tx.amount ?? 0));
// // //             final net = incomeTotal - expenseTotal;

// // //             // Get grouped transactions for the ListView
// // //             final List<GroupedTransactionItem> groupedItems =
// // //                 _getGroupedTransactionItems(filtered);

// // //             return Column(
// // //               children: [
// // //                 Padding(
// // //                   padding: const EdgeInsets.all(16.0),
// // //                   child: Row(
// // //                     children: [
// // //                       Expanded(
// // //                         child: DropdownButtonFormField<String>(
// // //                           value: _selectedCategory,
// // //                           isExpanded: true, // Crucial for dropdown overflow fix
// // //                           decoration: const InputDecoration(
// // //                             labelText: 'Category',
// // //                             // Styles are applied via ThemeData
// // //                           ),
// // //                           items: categories.map((cat) {
// // //                             return DropdownMenuItem(
// // //                               value: cat,
// // //                               child: Text(
// // //                                 cat == 'All'
// // //                                     ? 'All Categories'
// // //                                     : (cat.isEmpty ? 'Uncategorized' : cat),
// // //                                 style: const TextStyle(fontSize: 14),
// // //                                 overflow: TextOverflow
// // //                                     .ellipsis, // Crucial for dropdown overflow fix
// // //                               ),
// // //                             );
// // //                           }).toList(),
// // //                           onChanged: (value) {
// // //                             if (value != null) {
// // //                               setState(() => _selectedCategory = value);
// // //                             }
// // //                           },
// // //                           // Ensure the selected item's text color is primary
// // //                           selectedItemBuilder: (BuildContext context) {
// // //                             return categories.map((String value) {
// // //                               return Text(
// // //                                 value == 'All'
// // //                                     ? 'All Categories'
// // //                                     : (value.isEmpty ? 'Uncategorized' : value),
// // //                                 style: TextStyle(
// // //                                     color: Theme.of(context)
// // //                                         .textTheme
// // //                                         .bodyLarge
// // //                                         ?.color),
// // //                                 overflow: TextOverflow
// // //                                     .ellipsis, // Crucial for dropdown overflow fix
// // //                               );
// // //                             }).toList();
// // //                           },
// // //                         ),
// // //                       ),
// // //                       const SizedBox(width: 12),
// // //                       Expanded(
// // //                         child: DropdownButtonFormField<String>(
// // //                           value: _selectedAccount,
// // //                           isExpanded: true, // Crucial for dropdown overflow fix
// // //                           decoration: const InputDecoration(
// // //                             labelText: 'Account',
// // //                             // Styles are applied via ThemeData
// // //                           ),
// // //                           items: accounts.map((acc) {
// // //                             return DropdownMenuItem(
// // //                               value: acc,
// // //                               child: Text(
// // //                                 acc == 'All'
// // //                                     ? 'All Accounts'
// // //                                     : (acc.isEmpty ? 'Unnamed' : acc),
// // //                                 style: const TextStyle(fontSize: 14),
// // //                                 overflow: TextOverflow
// // //                                     .ellipsis, // Crucial for dropdown overflow fix
// // //                               ),
// // //                             );
// // //                           }).toList(),
// // //                           onChanged: (value) {
// // //                             if (value != null) {
// // //                               setState(() => _selectedAccount = value);
// // //                             }
// // //                           },
// // //                           // Ensure the selected item's text color is primary
// // //                           selectedItemBuilder: (BuildContext context) {
// // //                             return accounts.map((String value) {
// // //                               return Text(
// // //                                 value == 'All'
// // //                                     ? 'All Accounts'
// // //                                     : (value.isEmpty ? 'Unnamed' : value),
// // //                                 style: TextStyle(
// // //                                     color: Theme.of(context)
// // //                                         .textTheme
// // //                                         .bodyLarge
// // //                                         ?.color),
// // //                                 overflow: TextOverflow
// // //                                     .ellipsis, // Crucial for dropdown overflow fix
// // //                               );
// // //                             }).toList();
// // //                           },
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //                 Padding(
// // //                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
// // //                   child: Row(
// // //                     children: _views.map((view) {
// // //                       final isSelected = _selectedView == view;
// // //                       return Expanded(
// // //                         child: Padding(
// // //                           padding: const EdgeInsets.symmetric(horizontal: 4.0),
// // //                           child: ElevatedButton(
// // //                             style: ElevatedButton.styleFrom(
// // //                               backgroundColor: isSelected
// // //                                   ? AppColors
// // //                                       .primary // Use primary for selected button
// // //                                   : AppColors
// // //                                       .chip, // Use chip for unselected button
// // //                               foregroundColor: isSelected
// // //                                   ? AppColors.buttonText
// // //                                   : AppColors.textPrimary, // Text color changes
// // //                               elevation: isSelected ? 4 : 0,
// // //                               shadowColor: isSelected
// // //                                   ? AppColors.primary.withOpacity(0.3)
// // //                                   : Colors.transparent,
// // //                             ),
// // //                             onPressed: () async {
// // //                               if (view == 'Custom') {
// // //                                 final picked = await showDateRangePicker(
// // //                                   context: context,
// // //                                   firstDate: DateTime(2000),
// // //                                   lastDate: DateTime(2100),
// // //                                   helpText: 'Select Custom Date Range',
// // //                                   confirmText: 'Confirm',
// // //                                   cancelText: 'Cancel',
// // //                                   builder: (context, child) {
// // //                                     return Theme(
// // //                                       data: ThemeData.dark().copyWith(
// // //                                         // Use dark theme for picker
// // //                                         primaryColor: AppColors.primary,
// // //                                         colorScheme: ColorScheme.dark(
// // //                                           primary: AppColors.primary,
// // //                                           onPrimary: AppColors
// // //                                               .buttonText, // Text on primary background
// // //                                           surface: AppColors
// // //                                               .card, // Picker background
// // //                                           onSurface: AppColors
// // //                                               .textPrimary, // Text on picker background
// // //                                         ),
// // //                                         textTheme: const TextTheme(
// // //                                           titleLarge: TextStyle(
// // //                                               color: AppColors
// // //                                                   .textPrimary), // Year/Month title
// // //                                           bodyLarge: TextStyle(
// // //                                               color: AppColors
// // //                                                   .textPrimary), // Day numbers
// // //                                           labelLarge: TextStyle(
// // //                                               color: AppColors
// // //                                                   .textPrimary), // Button text (CANCEL/OK)
// // //                                         ),
// // //                                         dialogBackgroundColor:
// // //                                             AppColors.background,
// // //                                       ),
// // //                                       child: child!,
// // //                                     );
// // //                                   },
// // //                                 );
// // //                                 // IMPORTANT: Check mounted after showDateRangePicker
// // //                                 if (!mounted) {
// // //                                   return;
// // //                                 }
// // //                                 if (picked != null) {
// // //                                   setState(() {
// // //                                     _customRange = picked;
// // //                                     _selectedView = view;
// // //                                   });
// // //                                 }
// // //                               } else {
// // //                                 setState(() {
// // //                                   _selectedView = view;
// // //                                   // When switching to a non-custom view, reset _currentDate to now for consistency
// // //                                   if (view == 'Daily' ||
// // //                                       view == 'Weekly' ||
// // //                                       view == 'Monthly') {
// // //                                     bool shouldReset = false;
// // //                                     // Check if current date for the selected view is significantly off from "now"
// // //                                     if (view == 'Daily' &&
// // //                                         !(_currentDate.year ==
// // //                                                 DateTime.now().year &&
// // //                                             _currentDate.month ==
// // //                                                 DateTime.now().month &&
// // //                                             _currentDate.day ==
// // //                                                 DateTime.now().day)) {
// // //                                       shouldReset = true;
// // //                                     } else if (view == 'Weekly') {
// // //                                       final currentWeekMonday = DateTime.now()
// // //                                           .subtract(Duration(
// // //                                               days:
// // //                                                   DateTime.now().weekday - 1));
// // //                                       final selectedWeekMonday =
// // //                                           _currentDate.subtract(Duration(
// // //                                               days: _currentDate.weekday - 1));
// // //                                       if (currentWeekMonday
// // //                                               .difference(selectedWeekMonday)
// // //                                               .inDays !=
// // //                                           0) {
// // //                                         shouldReset = true;
// // //                                       }
// // //                                     } else if (view == 'Monthly' &&
// // //                                         !(_currentDate.year ==
// // //                                                 DateTime.now().year &&
// // //                                             _currentDate.month ==
// // //                                                 DateTime.now().month)) {
// // //                                       shouldReset = true;
// // //                                     }

// // //                                     if (shouldReset) {
// // //                                       _currentDate = DateTime.now();
// // //                                     }
// // //                                   }
// // //                                 });
// // //                               }
// // //                             },
// // //                             child: Text(view,
// // //                                 style: const TextStyle(
// // //                                     fontSize: 13, fontWeight: FontWeight.w500)),
// // //                           ),
// // //                         ),
// // //                       );
// // //                     }).toList(),
// // //                   ),
// // //                 ),
// // //                 const SizedBox(height: 12),

// // //                 // Date Navigation Row (only for Daily, Weekly, Monthly)
// // //                 if (_selectedView != 'Total' && _selectedView != 'Custom')
// // //                   Padding(
// // //                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
// // //                     child: Row(
// // //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                       children: [
// // //                         IconButton(
// // //                           icon: const Icon(Icons.arrow_back_ios, size: 18),
// // //                           color: AppColors.textPrimary,
// // //                           onPressed: () => _navigatePeriod(-1, _selectedView),
// // //                         ),
// // //                         Expanded(
// // //                           // Use Expanded to prevent overflow
// // //                           child: Center(
// // //                             child: Text(
// // //                               dateRangeDisplay,
// // //                               style: const TextStyle(
// // //                                 fontSize: 16,
// // //                                 fontWeight: FontWeight.bold,
// // //                                 color: AppColors.textPrimary,
// // //                               ),
// // //                             ),
// // //                           ),
// // //                         ),
// // //                         IconButton(
// // //                           icon: const Icon(Icons.arrow_forward_ios, size: 18),
// // //                           color: AppColors.textPrimary,
// // //                           onPressed: () => _navigatePeriod(1, _selectedView),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                 const SizedBox(height: 12),

// // //                 Container(
// // //                   margin: const EdgeInsets.symmetric(horizontal: 16.0),
// // //                   padding: const EdgeInsets.all(16.0),
// // //                   decoration: BoxDecoration(
// // //                     color: AppColors.card, // Use AppColors
// // //                     borderRadius: BorderRadius.circular(12.0),
// // //                     boxShadow: [
// // //                       BoxShadow(
// // //                         color: Colors.black
// // //                             .withOpacity(0.2), // Darker shadow for dark theme
// // //                         spreadRadius: 1,
// // //                         blurRadius: 5,
// // //                         offset: const Offset(0, 3),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                   child: Row(
// // //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// // //                     children: [
// // //                       _buildSummaryTile(
// // //                           'Income',
// // //                           incomeTotal,
// // //                           AppColors
// // //                               .incomeDisplay), // Using new AppColors inferred
// // //                       _buildSummaryTile(
// // //                           'Expense',
// // //                           expenseTotal,
// // //                           AppColors
// // //                               .expenseDisplay), // Using new AppColors inferred
// // //                       _buildSummaryTile(
// // //                           'Net',
// // //                           net,
// // //                           net >= 0
// // //                               ? AppColors.primary
// // //                               : AppColors
// // //                                   .expenseDisplay), // Use primary for net positive
// // //                     ],
// // //                   ),
// // //                 ),
// // //                 const SizedBox(height: 16),
// // //                 const Padding(
// // //                   padding: EdgeInsets.symmetric(horizontal: 16.0),
// // //                   child: Align(
// // //                     alignment: Alignment.centerLeft,
// // //                     child: Text(
// // //                       'Transactions',
// // //                       style: TextStyle(
// // //                         fontSize: 18,
// // //                         fontWeight: FontWeight.bold,
// // //                         color: AppColors.textPrimary,
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 const Divider(
// // //                     height: 24, thickness: 1, color: AppColors.border),
// // //                 Expanded(
// // //                   child: groupedItems.isEmpty
// // //                       ? Center(
// // //                           child: Column(
// // //                             mainAxisAlignment: MainAxisAlignment.center,
// // //                             children: [
// // //                               Icon(Icons.receipt_long,
// // //                                   size: 60, color: AppColors.textSecondary),
// // //                               const SizedBox(height: 10),
// // //                               Text(
// // //                                 'No transactions found for this period.',
// // //                                 style: TextStyle(
// // //                                   fontSize: 16,
// // //                                   color: AppColors.textSecondary,
// // //                                 ),
// // //                               ),
// // //                             ],
// // //                           ),
// // //                         )
// // //                       : ListView.builder(
// // //                           itemCount: groupedItems.length,
// // //                           itemBuilder: (context, index) {
// // //                             final item = groupedItems[index];

// // //                             if (item.isDateHeader) {
// // //                               // It's a date header
// // //                               return Padding(
// // //                                 padding: const EdgeInsets.symmetric(
// // //                                     horizontal: 16.0, vertical: 8.0),
// // //                                 child: Text(
// // //                                   DateFormat('EEEE, MMM d, y').format(item
// // //                                       .date!), // E.g., "Thursday, Jun 27, 2025"
// // //                                   style: const TextStyle(
// // //                                     fontSize: 16,
// // //                                     fontWeight: FontWeight.bold,
// // //                                     color: AppColors.textPrimary,
// // //                                   ),
// // //                                 ),
// // //                               );
// // //                             } else {
// // //                               // It's a transaction item
// // //                               final tx = item.transaction!;
// // //                               return Slidable(
// // //                                 // Wrap the Card with Slidable
// // //                                 key: ValueKey(
// // //                                     tx.id), // Unique key for each slidable item
// // //                                 endActionPane: ActionPane(
// // //                                   motion:
// // //                                       const DrawerMotion(), // Simple drawer motion
// // //                                   extentRatio:
// // //                                       0.25, // How much of the item width the action pane takes
// // //                                   children: [
// // //                                     SlidableAction(
// // //                                       onPressed: (context) =>
// // //                                           _confirmAndDelete(context, tx),
// // //                                       backgroundColor: AppColors.delete,
// // //                                       foregroundColor: AppColors.buttonText,
// // //                                       icon: Icons.delete,
// // //                                       label: 'Delete',
// // //                                     ),
// // //                                   ],
// // //                                 ),
// // //                                 child: Card(
// // //                                   margin: const EdgeInsets.symmetric(
// // //                                       horizontal: 16, vertical: 6),
// // //                                   elevation: 2,
// // //                                   child: ListTile(
// // //                                     contentPadding: const EdgeInsets.symmetric(
// // //                                         horizontal: 16.0, vertical: 8.0),
// // //                                     leading: CircleAvatar(
// // //                                       backgroundColor: tx.type ==
// // //                                               TransactionType.income
// // //                                           ? AppColors.incomeDisplay.withOpacity(
// // //                                               0.2) // Lighter background for circle
// // //                                           : AppColors.expenseDisplay.withOpacity(
// // //                                               0.2), // Lighter background for circle
// // //                                       child: Icon(
// // //                                         tx.type == TransactionType.income
// // //                                             ? Icons.arrow_downward_rounded
// // //                                             : Icons.arrow_upward_rounded,
// // //                                         color: tx.type == TransactionType.income
// // //                                             ? AppColors
// // //                                                 .incomeDisplay // Icon color
// // //                                             : AppColors
// // //                                                 .expenseDisplay, // Icon color
// // //                                       ),
// // //                                     ),
// // //                                     title: Text(
// // //                                       tx.title ?? 'No Title',
// // //                                       style: const TextStyle(
// // //                                         fontWeight: FontWeight.bold,
// // //                                         fontSize: 16,
// // //                                         color: AppColors
// // //                                             .cardText, // White text for titles on cards
// // //                                       ),
// // //                                     ),
// // //                                     subtitle: Text(
// // //                                       // Adjusted subtitle to show full date for daily, then time, account and category
// // //                                       '${DateFormat('MMMM d, y').format(tx.date ?? DateTime.now())} ${DateFormat('h:mm a').format(tx.date ?? DateTime.now())} • ${tx.account ?? 'N/A'} • ${tx.category ?? 'N/A'}',
// // //                                       style: const TextStyle(
// // //                                         fontSize: 12,
// // //                                         color: AppColors.textSecondary,
// // //                                       ),
// // //                                     ),
// // //                                     trailing: Text(
// // //                                       '₹${tx.amount?.toStringAsFixed(2)}',
// // //                                       style: TextStyle(
// // //                                         fontWeight: FontWeight.w800,
// // //                                         fontSize: 16,
// // //                                         color: tx.type == TransactionType.income
// // //                                             ? AppColors.incomeDisplay
// // //                                             : AppColors.expenseDisplay,
// // //                                       ),
// // //                                     ),
// // //                                   ),
// // //                                 ),
// // //                               );
// // //                             }
// // //                           },
// // //                         ),
// // //                 ),
// // //               ],
// // //             );
// // //           },
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildSummaryTile(String label, double amount, Color color) {
// // //     return Column(
// // //       children: [
// // //         Text(
// // //           label,
// // //           style: const TextStyle(
// // //             fontWeight: FontWeight.bold,
// // //             fontSize: 14,
// // //             color: AppColors.textSecondary, // Use secondary text color
// // //           ),
// // //         ),
// // //         const SizedBox(height: 4),
// // //         Text(
// // //           '₹${amount.toStringAsFixed(2)}',
// // //           style: TextStyle(
// // //             color: color,
// // //             fontSize: 18,
// // //             fontWeight: FontWeight.w800,
// // //           ),
// // //         ),
// // //       ],
// // //     );
// // //   }
// // // }

// // // lib/pages/ledger.dart

// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:intl/intl.dart';
// // import 'package:notegoexpense/model/transaction_notifier.dart';
// // import '../model/transaction_model.dart';
// // import '../extras/AppColors.dart';
// // import 'package:flutter_slidable/flutter_slidable.dart';
// // import 'package:notegoexpense/main.dart';

// // // Helper class to represent items in the grouped list (either a date header or a transaction)
// // class GroupedTransactionItem {
// //   final DateTime? date;
// //   final TransactionModel? transaction;

// //   GroupedTransactionItem.date(this.date) : transaction = null;
// //   GroupedTransactionItem.transaction(this.transaction) : date = null;

// //   bool get isDateHeader => date != null;
// //   bool get isTransaction => transaction != null;
// // }

// // class LedgerPage extends ConsumerStatefulWidget {
// //   const LedgerPage({super.key});

// //   @override
// //   ConsumerState<LedgerPage> createState() => _LedgerPageState();
// // }

// // class _LedgerPageState extends ConsumerState<LedgerPage> {
// //   String _selectedView = 'Daily';
// //   DateTimeRange? _customRange;
// //   DateTime _currentDate = DateTime.now();

// //   String _selectedCategory = 'All';
// //   String _selectedAccount = 'All';

// //   final List<String> _views = ['Daily', 'Weekly', 'Monthly', 'Total', 'Custom'];

// //   void _navigatePeriod(int amount, String viewType) {
// //     setState(() {
// //       if (viewType == 'Daily') {
// //         _currentDate = _currentDate.add(Duration(days: amount));
// //       } else if (viewType == 'Weekly') {
// //         _currentDate = _currentDate.add(Duration(days: amount * 7));
// //       } else if (viewType == 'Monthly') {
// //         _currentDate = DateTime(
// //           _currentDate.year,
// //           _currentDate.month + amount,
// //           _currentDate.day.clamp(1, DateTime(_currentDate.year, _currentDate.month + amount + 1, 0).day),
// //         );
// //       }
// //     });
// //   }

// //   List<GroupedTransactionItem> _getGroupedTransactionItems(List<TransactionModel> transactions) {
// //     final List<GroupedTransactionItem> items = [];
// //     if (transactions.isEmpty) return items;

// //     transactions.sort((a, b) => (b.date ?? DateTime.now()).compareTo(a.date ?? DateTime.now()));

// //     DateTime? lastDateHeader;
// //     for (var tx in transactions) {
// //       final txDate = tx.date ?? DateTime.now();
// //       final normalizedTxDate = DateTime(txDate.year, txDate.month, txDate.day);

// //       if (lastDateHeader == null || !normalizedTxDate.isAtSameMomentAs(lastDateHeader)) {
// //           items.add(GroupedTransactionItem.date(normalizedTxDate));
// //           lastDateHeader = normalizedTxDate;
// //       }
// //       items.add(GroupedTransactionItem.transaction(tx));
// //     }
// //     return items;
// //   }

// //   Future<void> _confirmAndDelete(BuildContext context, TransactionModel transaction) async {
// //     final bool confirm = await showDialog(
// //       context: context,
// //       builder: (BuildContext dialogContext) {
// //         return AlertDialog(
// //           backgroundColor: AppColors.card,
// //           title: Text('Delete Transaction?', style: TextStyle(color: AppColors.textPrimary)),
// //           content: Text(
// //             'Are you sure you want to delete "${transaction.title ?? 'this transaction'}"?',
// //             style: TextStyle(color: AppColors.textPrimary),
// //           ),
// //           actions: <Widget>[
// //             TextButton(
// //               onPressed: () => Navigator.of(dialogContext).pop(false),
// //               child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
// //             ),
// //             ElevatedButton(
// //               onPressed: () => Navigator.of(dialogContext).pop(true),
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: AppColors.delete,
// //                 foregroundColor: AppColors.buttonText,
// //               ),
// //               child: const Text('Delete'),
// //             ),
// //           ],
// //         );
// //       },
// //     ) ?? false;

// //     if (!mounted) {
// //       return;
// //     }

// //     if (confirm) {
// //       try {
// //         await ref.read(transactionsProvider.notifier).deleteTransaction(transaction.id!);
// //         scaffoldMessengerKey.currentState?.showSnackBar(
// //           SnackBar(
// //             content: Text('Transaction "${transaction.title ?? 'Unknown'}" deleted.', style: TextStyle(color: AppColors.textPrimary)),
// //             backgroundColor: AppColors.success,
// //           ),
// //         );
// //       } catch (e) {
// //         scaffoldMessengerKey.currentState?.showSnackBar(
// //           SnackBar(
// //             content: Text(e.toString().replaceFirst('Exception: ', ''), style: TextStyle(color: AppColors.buttonText)),
// //             backgroundColor: AppColors.error,
// //           ),
// //         );
// //       }
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final transactionsAsync = ref.watch(transactionsProvider);

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text(
// //           'Ledger',
// //           style: TextStyle(
// //             fontWeight: FontWeight.bold,
// //             fontSize: 22,
// //           ),
// //         ),
// //         centerTitle: true,
// //       ),
// //       body: transactionsAsync.when(
// //         loading: () => const Center(child: CircularProgressIndicator()),
// //         error: (e, st) => Center(
// //             child: Text('Error: $e', style: const TextStyle(color: AppColors.delete))),
// //         data: (transactions) {
// //           List<TransactionModel> filtered = transactions;

// //           final List<String> categories = {
// //             'All',
// //             ...transactions.map((tx) => tx.category ?? '')
// //           }
// //               .where((category) => category.isNotEmpty)
// //               .toList();
// //           categories.sort();
// //           if (categories.contains('All')) {
// //             categories.remove('All');
// //           }
// //           categories.insert(0, 'All');

// //           final List<String> accounts = {
// //             'All',
// //             ...transactions.map((tx) => tx.account ?? '')
// //           }
// //               .where((account) => account.isNotEmpty)
// //               .toList();
// //           accounts.sort();
// //           if (accounts.contains('All')) {
// //             accounts.remove('All');
// //           }
// //           accounts.insert(0, 'All');

// //           DateTime start;
// //           DateTime end;
// //           String dateRangeDisplay = '';

// //           if (_selectedView == 'Daily') {
// //             start = DateTime(_currentDate.year, _currentDate.month, _currentDate.day);
// //             end = start.add(const Duration(days: 1));
// //             dateRangeDisplay = DateFormat.yMMMd().format(_currentDate);
// //           } else if (_selectedView == 'Weekly') {
// //             start = _currentDate.subtract(Duration(days: _currentDate.weekday - 1));
// //             end = start.add(const Duration(days: 7));
// //             dateRangeDisplay =
// //                 '${DateFormat.yMMMd().format(start)} - ${DateFormat.yMMMd().format(end.subtract(const Duration(days: 1)))}';
// //           } else if (_selectedView == 'Monthly') {
// //             start = DateTime(_currentDate.year, _currentDate.month, 1);
// //             end = DateTime(_currentDate.year, _currentDate.month + 1, 1);
// //             dateRangeDisplay = DateFormat.yMMMM().format(_currentDate);
// //           } else if (_selectedView == 'Custom' && _customRange != null) {
// //             start = _customRange!.start;
// //             end = _customRange!.end.add(const Duration(days: 1));
// //             dateRangeDisplay =
// //                 '${DateFormat.yMMMd().format(_customRange!.start)} - ${DateFormat.yMMMd().format(_customRange!.end)}';
// //           } else {
// //             start = DateTime(2000, 1, 1);
// //             end = DateTime.now().add(const Duration(days: 365 * 10));
// //             dateRangeDisplay = 'All Time';
// //           }

// //           filtered = filtered.where((tx) {
// //             final txDate = tx.date ?? DateTime.now();
// //             final matchesCategory = _selectedCategory == 'All' ||
// //                 (tx.category ?? '') == _selectedCategory;
// //             final matchesAccount = _selectedAccount == 'All' ||
// //                 (tx.account ?? '') == _selectedAccount;

// //             return txDate.isAfter(start.subtract(const Duration(milliseconds: 1))) &&
// //                 txDate.isBefore(end) &&
// //                 matchesCategory &&
// //                 matchesAccount;
// //           }).toList();

// //           final incomeTotal = filtered
// //               .where((tx) => tx.type == TransactionType.income)
// //               .fold<double>(0, (sum, tx) => sum + (tx.amount ?? 0));
// //           final expenseTotal = filtered
// //               .where((tx) => tx.type == TransactionType.expense)
// //               .fold<double>(0, (sum, tx) => sum + (tx.amount ?? 0));
// //           final net = incomeTotal - expenseTotal;

// //           final List<GroupedTransactionItem> groupedItems = _getGroupedTransactionItems(filtered);

// //           return Column(
// //             children: [
// //               Padding(
// //                 padding: const EdgeInsets.all(16.0),
// //                 child: Row(
// //                   children: [
// //                     Expanded(
// //                       child: DropdownButtonFormField<String>(
// //                         value: _selectedCategory,
// //                         isExpanded: true,
// //                         decoration: const InputDecoration(
// //                           labelText: 'Category',
// //                         ),
// //                         items: categories.map((cat) {
// //                           return DropdownMenuItem(
// //                             value: cat,
// //                             child: Text(
// //                               cat == 'All'
// //                                   ? 'All Categories'
// //                                   : (cat.isEmpty ? 'Uncategorized' : cat),
// //                               style: const TextStyle(fontSize: 14),
// //                               overflow: TextOverflow.ellipsis,
// //                             ),
// //                           );
// //                         }).toList(),
// //                         onChanged: (value) {
// //                           if (value != null) {
// //                             setState(() => _selectedCategory = value);
// //                           }
// //                         },
// //                         selectedItemBuilder: (BuildContext context) {
// //                           return categories.map((String value) {
// //                             return Text(
// //                               value == 'All'
// //                                   ? 'All Categories'
// //                                   : (value.isEmpty ? 'Uncategorized' : value),
// //                               style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
// //                               overflow: TextOverflow.ellipsis,
// //                             );
// //                           }).toList();
// //                         },
// //                       ),
// //                     ),
// //                     const SizedBox(width: 12),
// //                     Expanded(
// //                       child: DropdownButtonFormField<String>(
// //                         value: _selectedAccount,
// //                         isExpanded: true,
// //                         decoration: const InputDecoration(
// //                           labelText: 'Account',
// //                         ),
// //                         items: accounts.map((acc) {
// //                           return DropdownMenuItem(
// //                             value: acc,
// //                             child: Text(
// //                               acc == 'All'
// //                                   ? 'All Accounts'
// //                                   : (acc.isEmpty ? 'Unnamed' : acc),
// //                               style: const TextStyle(fontSize: 14),
// //                               overflow: TextOverflow.ellipsis,
// //                             ),
// //                           );
// //                         }).toList(),
// //                         onChanged: (value) {
// //                           if (value != null) {
// //                             setState(() => _selectedAccount = value);
// //                           }
// //                         },
// //                         selectedItemBuilder: (BuildContext context) {
// //                           return accounts.map((String value) {
// //                             return Text(
// //                               value == 'All'
// //                                   ? 'All Accounts'
// //                                   : (value.isEmpty ? 'Unnamed' : value),
// //                               style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
// //                               overflow: TextOverflow.ellipsis,
// //                             );
// //                           }).toList();
// //                         },
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               Padding(
// //                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
// //                 child: Row(
// //                   children: _views.map((view) {
// //                     final isSelected = _selectedView == view;
// //                     return Expanded(
// //                       child: Padding(
// //                         padding: const EdgeInsets.symmetric(horizontal: 4.0),
// //                         child: ElevatedButton(
// //                           style: ElevatedButton.styleFrom(
// //                             backgroundColor: isSelected
// //                                 ? AppColors.primary
// //                                 : AppColors.chip,
// //                             foregroundColor:
// //                                 isSelected ? AppColors.buttonText : AppColors.textPrimary,
// //                             elevation: isSelected ? 4 : 0,
// //                             shadowColor: isSelected ? AppColors.primary.withOpacity(0.3) : Colors.transparent,
// //                           ),
// //                           onPressed: () async {
// //                             if (view == 'Custom') {
// //                               final picked = await showDateRangePicker(
// //                                 context: context,
// //                                 firstDate: DateTime(2000),
// //                                 lastDate: DateTime(2100),
// //                                 helpText: 'Select Custom Date Range',
// //                                 confirmText: 'Confirm',
// //                                 cancelText: 'Cancel',
// //                                 builder: (context, child) {
// //                                   return Theme(
// //                                     data: ThemeData.dark().copyWith(
// //                                       primaryColor: AppColors.primary,
// //                                       colorScheme: ColorScheme.dark(
// //                                         primary: AppColors.primary,
// //                                         onPrimary: AppColors.buttonText,
// //                                         surface: AppColors.card,
// //                                         onSurface: AppColors.textPrimary,
// //                                       ),
// //                                       textTheme: const TextTheme(
// //                                         titleLarge: TextStyle(color: AppColors.textPrimary),
// //                                         bodyLarge: TextStyle(color: AppColors.textPrimary),
// //                                         labelLarge: TextStyle(color: AppColors.textPrimary),
// //                                       ),
// //                                       dialogBackgroundColor: AppColors.background,
// //                                     ),
// //                                     child: child!,
// //                                   );
// //                                 },
// //                               );
// //                               if (!mounted) {
// //                                 return;
// //                               }
// //                               if (picked != null) {
// //                                 setState(() {
// //                                   _customRange = picked;
// //                                   _selectedView = view;
// //                                 });
// //                               }
// //                             } else {
// //                               setState(() {
// //                                 _selectedView = view;
// //                                 if (view == 'Daily' || view == 'Weekly' || view == 'Monthly') {
// //                                   bool shouldReset = false;
// //                                   if (view == 'Daily' && !(_currentDate.year == DateTime.now().year && _currentDate.month == DateTime.now().month && _currentDate.day == DateTime.now().day)) {
// //                                     shouldReset = true;
// //                                   } else if (view == 'Weekly') {
// //                                     final currentWeekMonday = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
// //                                     final selectedWeekMonday = _currentDate.subtract(Duration(days: _currentDate.weekday - 1));
// //                                     if (currentWeekMonday.difference(selectedWeekMonday).inDays != 0) {
// //                                       shouldReset = true;
// //                                     }
// //                                   } else if (view == 'Monthly' && !(_currentDate.year == DateTime.now().year && _currentDate.month == DateTime.now().month)) {
// //                                     shouldReset = true;
// //                                   }

// //                                   if (shouldReset) {
// //                                     _currentDate = DateTime.now();
// //                                   }
// //                                 }
// //                               });
// //                             }
// //                           },
// //                           child:
// //                               Text(view, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
// //                         ),
// //                       ),
// //                     );
// //                   }).toList(),
// //                 ),
// //               ),
// //               const SizedBox(height: 12),

// //               if (_selectedView != 'Total' && _selectedView != 'Custom')
// //                 Padding(
// //                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
// //                   child: Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     children: [
// //                       IconButton(
// //                         icon: const Icon(Icons.arrow_back_ios, size: 18),
// //                         color: AppColors.textPrimary,
// //                         onPressed: () => _navigatePeriod(-1, _selectedView),
// //                       ),
// //                       Expanded(
// //                         child: Center(
// //                           child: Text(
// //                             dateRangeDisplay,
// //                             style: const TextStyle(
// //                               fontSize: 16,
// //                               fontWeight: FontWeight.bold,
// //                               color: AppColors.textPrimary,
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                       IconButton(
// //                         icon: const Icon(Icons.arrow_forward_ios, size: 18),
// //                         color: AppColors.textPrimary,
// //                         onPressed: () => _navigatePeriod(1, _selectedView),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               const SizedBox(height: 12),

// //               Container(
// //                 margin: const EdgeInsets.symmetric(horizontal: 16.0),
// //                 padding: const EdgeInsets.all(16.0),
// //                 decoration: BoxDecoration(
// //                   color: AppColors.card,
// //                   borderRadius: BorderRadius.circular(12.0),
// //                   boxShadow: [
// //                     BoxShadow(
// //                       color: Colors.black.withOpacity(0.2),
// //                       spreadRadius: 1,
// //                       blurRadius: 5,
// //                       offset: const Offset(0, 3),
// //                     ),
// //                   ],
// //                 ),
// //                 child: Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                   children: [
// //                     _buildSummaryTile('Income', incomeTotal, AppColors.incomeDisplay),
// //                     _buildSummaryTile('Expense', expenseTotal, AppColors.expenseDisplay),
// //                     _buildSummaryTile(
// //                         'Net', net, net >= 0 ? AppColors.primary : AppColors.expenseDisplay),
// //                   ],
// //                 ),
// //               ),
// //               const SizedBox(height: 16),
// //               const Padding(
// //                 padding: EdgeInsets.symmetric(horizontal: 16.0),
// //                 child: Align(
// //                   alignment: Alignment.centerLeft,
// //                   child: Text(
// //                     'Transactions',
// //                     style: TextStyle(
// //                       fontSize: 18,
// //                       fontWeight: FontWeight.bold,
// //                       color: AppColors.textPrimary,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               const Divider(height: 24, thickness: 1, color: AppColors.border),
// //               Expanded(
// //                 child: groupedItems.isEmpty
// //                     ? Center(
// //                         child: Column(
// //                           mainAxisAlignment: MainAxisAlignment.center,
// //                           children: [
// //                             Icon(Icons.receipt_long, size: 60, color: AppColors.textSecondary),
// //                             const SizedBox(height: 10),
// //                             Text(
// //                               'No transactions found for this period.',
// //                               style: TextStyle(
// //                                 fontSize: 16,
// //                                 color: AppColors.textSecondary,
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       )
// //                     : ListView.builder(
// //                         itemCount: groupedItems.length,
// //                         itemBuilder: (context, index) {
// //                           final item = groupedItems[index];

// //                           if (item.isDateHeader) {
// //                             return Padding(
// //                               padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
// //                               child: Text(
// //                                 DateFormat('EEEE, MMM d, y').format(item.date!),
// //                                 style: const TextStyle(
// //                                   fontSize: 16,
// //                                   fontWeight: FontWeight.bold,
// //                                   color: AppColors.textPrimary,
// //                                 ),
// //                               ),
// //                             );
// //                           } else {
// //                             final tx = item.transaction!;
// //                             return Slidable(
// //                               key: ValueKey(tx.id),
// //                               endActionPane: ActionPane(
// //                                 motion: const DrawerMotion(),
// //                                 extentRatio: 0.25,
// //                                 children: [
// //                                   SlidableAction(
// //                                     onPressed: (context) => _confirmAndDelete(context, tx),
// //                                     backgroundColor: AppColors.delete,
// //                                     foregroundColor: AppColors.buttonText,
// //                                     icon: Icons.delete,
// //                                     label: 'Delete',
// //                                   ),
// //                                 ],
// //                               ),
// //                               child: Card(
// //                                 margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
// //                                 elevation: 2,
// //                                 child: ListTile(
// //                                   contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
// //                                   leading: CircleAvatar(
// //                                     backgroundColor: tx.type == TransactionType.income
// //                                         ? AppColors.incomeDisplay.withOpacity(0.2)
// //                                         : AppColors.expenseDisplay.withOpacity(0.2),
// //                                     child: Icon(
// //                                       tx.type == TransactionType.income
// //                                           ? Icons.arrow_downward_rounded
// //                                           : Icons.arrow_upward_rounded,
// //                                       color: tx.type == TransactionType.income
// //                                           ? AppColors.incomeDisplay
// //                                           : AppColors.expenseDisplay,
// //                                     ),
// //                                   ),
// //                                   title: Text(
// //                                     tx.title ?? 'No Title',
// //                                     style: const TextStyle(
// //                                       fontWeight: FontWeight.bold,
// //                                       fontSize: 16,
// //                                       color: AppColors.cardText,
// //                                     ),
// //                                   ),
// //                                   subtitle: Text(
// //                                     '${DateFormat('MMMM d, y').format(tx.date ?? DateTime.now())} ${DateFormat('h:mm a').format(tx.date ?? DateTime.now())} • ${tx.account ?? 'N/A'} • ${tx.category ?? 'N/A'}',
// //                                     style: const TextStyle(
// //                                       fontSize: 12,
// //                                       color: AppColors.textSecondary,
// //                                     ),
// //                                   ),
// //                                   trailing: Text(
// //                                     '₹${tx.amount?.toStringAsFixed(2)}',
// //                                     style: TextStyle(
// //                                       fontWeight: FontWeight.w800,
// //                                       fontSize: 16,
// //                                       color: tx.type == TransactionType.income
// //                                           ? AppColors.incomeDisplay
// //                                           : AppColors.expenseDisplay,
// //                                     ),
// //                                   ),
// //                                 ),
// //                               ),
// //                             );
// //                           }
// //                         },
// //                       ),
// //               ),
// //             ],
// //           );
// //         },
// //       ),
// //     );
// //   }

// //   Widget _buildSummaryTile(String label, double amount, Color color) {
// //     return Column(
// //       children: [
// //         Text(
// //           label,
// //           style: const TextStyle(
// //             fontWeight: FontWeight.bold,
// //             fontSize: 14,
// //             color: AppColors.textSecondary,
// //           ),
// //         ),
// //         const SizedBox(height: 4),
// //         Text(
// //           '₹${amount.toStringAsFixed(2)}',
// //           style: TextStyle(
// //             color: color,
// //             fontSize: 18,
// //             fontWeight: FontWeight.w800,
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }
// // lib/pages/ledger.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
// import 'package:notegoexpense/model/transaction_notifier.dart';
// import '../model/transaction_model.dart';
// import '../extras/AppColors.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:notegoexpense/main.dart'; // For scaffoldMessengerKey

// class GroupedTransactionItem {
//   final DateTime? date;
//   final TransactionModel? transaction;

//   GroupedTransactionItem.date(this.date) : transaction = null;
//   GroupedTransactionItem.transaction(this.transaction) : date = null;

//   bool get isDateHeader => date != null;
//   bool get isTransaction => transaction != null;
// }

// class LedgerPage extends ConsumerStatefulWidget {
//   const LedgerPage({super.key});

//   @override
//   ConsumerState<LedgerPage> createState() => _LedgerPageState();
// }

// class _LedgerPageState extends ConsumerState<LedgerPage> {
//   String _selectedView = 'Daily';
//   DateTimeRange? _customRange;
//   DateTime _currentDate = DateTime.now();

//   String _selectedCategory = 'All';
//   String _selectedAccount = 'All';

//   final List<String> _views = ['Daily', 'Weekly', 'Monthly', 'Total', 'Custom'];

//   void _navigatePeriod(int amount, String viewType) {
//     setState(() {
//       if (viewType == 'Daily') {
//         _currentDate = _currentDate.add(Duration(days: amount));
//       } else if (viewType == 'Weekly') {
//         _currentDate = _currentDate.add(Duration(days: amount * 7));
//       } else if (viewType == 'Monthly') {
//         _currentDate = DateTime(
//           _currentDate.year,
//           _currentDate.month + amount,
//           _currentDate.day.clamp(
//               1,
//               DateTime(_currentDate.year, _currentDate.month + amount + 1, 0)
//                   .day),
//         );
//       }
//     });
//   }

//   List<GroupedTransactionItem> _getGroupedTransactionItems(
//       List<TransactionModel> transactions) {
//     final List<GroupedTransactionItem> items = [];
//     if (transactions.isEmpty) return items;

//     transactions.sort((a, b) =>
//         (b.date ?? DateTime.now()).compareTo(a.date ?? DateTime.now()));

//     DateTime? lastDateHeader;
//     for (var tx in transactions) {
//       final txDate = tx.date ?? DateTime.now();
//       final normalizedTxDate = DateTime(txDate.year, txDate.month, txDate.day);

//       if (lastDateHeader == null ||
//           !normalizedTxDate.isAtSameMomentAs(lastDateHeader)) {
//         items.add(GroupedTransactionItem.date(normalizedTxDate));
//         lastDateHeader = normalizedTxDate;
//       }
//       items.add(GroupedTransactionItem.transaction(tx));
//     }
//     return items;
//   }

//   Future<void> _confirmAndDelete(
//       BuildContext context, TransactionModel transaction) async {
//     final bool confirm = await showDialog(
//           context: context,
//           builder: (BuildContext dialogContext) {
//             return AlertDialog(
//               backgroundColor: AppColors.card,
//               title: Text('Delete Transaction?',
//                   style: TextStyle(color: AppColors.textPrimary)),
//               content: Text(
//                 'Are you sure you want to delete "${transaction.title ?? 'this transaction'}"?',
//                 style: TextStyle(color: AppColors.textPrimary),
//               ),
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: () => Navigator.of(dialogContext).pop(false),
//                   child: Text('Cancel',
//                       style: TextStyle(color: AppColors.textSecondary)),
//                 ),
//                 ElevatedButton(
//                   onPressed: () => Navigator.of(dialogContext).pop(true),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.delete,
//                     foregroundColor: AppColors.buttonText,
//                   ),
//                   child: const Text('Delete'),
//                 ),
//               ],
//             );
//           },
//         ) ??
//         false;

//     if (!mounted) {
//       return;
//     }

//     if (confirm) {
//       try {
//         await ref
//             .read(transactionsProvider.notifier)
//             .deleteTransaction(transaction.id!);
//         scaffoldMessengerKey.currentState?.showSnackBar(
//           SnackBar(
//             content: Text(
//                 'Transaction "${transaction.title ?? 'Unknown'}" deleted.',
//                 style: TextStyle(color: AppColors.textPrimary)),
//             backgroundColor: AppColors.success,
//           ),
//         );
//       } catch (e) {
//         scaffoldMessengerKey.currentState?.showSnackBar(
//           SnackBar(
//             content: Text(e.toString().replaceFirst('Exception: ', ''),
//                 style: TextStyle(color: AppColors.buttonText)),
//             backgroundColor: AppColors.error,
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final transactionsAsync = ref.watch(transactionsProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Ledger',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 22,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: transactionsAsync.when(
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (e, st) => Center(
//             child: Text('Error: $e',
//                 style: const TextStyle(color: AppColors.delete))),
//         data: (transactions) {
//           List<TransactionModel> filtered = transactions;

//           final List<String> categories = {
//             'All',
//             ...transactions.map((tx) => tx.category ?? '')
//           }.where((category) => category.isNotEmpty).toList();
//           categories.sort();
//           if (categories.contains('All')) {
//             categories.remove('All');
//           }
//           categories.insert(0, 'All');

//           final List<String> accounts = {
//             'All',
//             ...transactions.map((tx) => tx.account ?? '')
//           }.where((account) => account.isNotEmpty).toList();
//           accounts.sort();
//           if (accounts.contains('All')) {
//             accounts.remove('All');
//           }
//           accounts.insert(0, 'All');

//           DateTime start;
//           DateTime end;
//           String dateRangeDisplay = '';

//           if (_selectedView == 'Daily') {
//             start = DateTime(
//                 _currentDate.year, _currentDate.month, _currentDate.day);
//             end = start.add(const Duration(days: 1));
//             dateRangeDisplay = DateFormat.yMMMd().format(_currentDate);
//           } else if (_selectedView == 'Weekly') {
//             start =
//                 _currentDate.subtract(Duration(days: _currentDate.weekday - 1));
//             end = start.add(const Duration(days: 7));
//             dateRangeDisplay =
//                 '${DateFormat.yMMMd().format(start)} - ${DateFormat.yMMMd().format(end.subtract(const Duration(days: 1)))}';
//           } else if (_selectedView == 'Monthly') {
//             start = DateTime(_currentDate.year, _currentDate.month, 1);
//             end = DateTime(_currentDate.year, _currentDate.month + 1, 1);
//             dateRangeDisplay = DateFormat.yMMMM().format(_currentDate);
//           } else if (_selectedView == 'Custom' && _customRange != null) {
//             start = _customRange!.start;
//             end = _customRange!.end.add(const Duration(days: 1));
//             dateRangeDisplay =
//                 '${DateFormat.yMMMd().format(_customRange!.start)} - ${DateFormat.yMMMd().format(_customRange!.end)}';
//           } else {
//             start = DateTime(2000, 1, 1);
//             end = DateTime.now().add(const Duration(days: 365 * 10));
//             dateRangeDisplay = 'All Time';
//           }

//           filtered = filtered.where((tx) {
//             final txDate = tx.date ?? DateTime.now();
//             final matchesCategory = _selectedCategory == 'All' ||
//                 (tx.category ?? '') == _selectedCategory;
//             final matchesAccount = _selectedAccount == 'All' ||
//                 (tx.account ?? '') == _selectedAccount;

//             return txDate
//                     .isAfter(start.subtract(const Duration(milliseconds: 1))) &&
//                 txDate.isBefore(end) &&
//                 matchesCategory &&
//                 matchesAccount;
//           }).toList();

//           final incomeTotal = filtered
//               .where((tx) => tx.type == TransactionType.income)
//               .fold<double>(0, (sum, tx) => sum + (tx.amount ?? 0));
//           final expenseTotal = filtered
//               .where((tx) => tx.type == TransactionType.expense)
//               .fold<double>(0, (sum, tx) => sum + (tx.amount ?? 0));
//           final net = incomeTotal - expenseTotal;

//           final List<GroupedTransactionItem> groupedItems =
//               _getGroupedTransactionItems(filtered);

//           return Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: DropdownButtonFormField<String>(
//                         value: _selectedCategory,
//                         isExpanded: true,
//                         decoration: const InputDecoration(
//                           labelText: 'Category',
//                         ),
//                         items: categories.map((cat) {
//                           return DropdownMenuItem(
//                             value: cat,
//                             child: Text(
//                               cat == 'All'
//                                   ? 'All Categories'
//                                   : (cat.isEmpty ? 'Uncategorized' : cat),
//                               style: const TextStyle(fontSize: 14),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           );
//                         }).toList(),
//                         onChanged: (value) {
//                           if (value != null) {
//                             setState(() => _selectedCategory = value);
//                           }
//                         },
//                         selectedItemBuilder: (BuildContext context) {
//                           return categories.map((String value) {
//                             return Text(
//                               value == 'All'
//                                   ? 'All Categories'
//                                   : (value.isEmpty ? 'Uncategorized' : value),
//                               style: TextStyle(
//                                   color: Theme.of(context)
//                                       .textTheme
//                                       .bodyLarge
//                                       ?.color),
//                               overflow: TextOverflow.ellipsis,
//                             );
//                           }).toList();
//                         },
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: DropdownButtonFormField<String>(
//                         value: _selectedAccount,
//                         isExpanded: true,
//                         decoration: const InputDecoration(
//                           labelText: 'Account',
//                         ),
//                         items: accounts.map((acc) {
//                           return DropdownMenuItem(
//                             value: acc,
//                             child: Text(
//                               acc == 'All'
//                                   ? 'All Accounts'
//                                   : (acc.isEmpty ? 'Unnamed' : acc),
//                               style: const TextStyle(fontSize: 14),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           );
//                         }).toList(),
//                         onChanged: (value) {
//                           if (value != null) {
//                             setState(() => _selectedAccount = value);
//                           }
//                         },
//                         selectedItemBuilder: (BuildContext context) {
//                           return accounts.map((String value) {
//                             return Text(
//                               value == 'All'
//                                   ? 'All Accounts'
//                                   : (value.isEmpty ? 'Unnamed' : value),
//                               style: TextStyle(
//                                   color: Theme.of(context)
//                                       .textTheme
//                                       .bodyLarge
//                                       ?.color),
//                               overflow: TextOverflow.ellipsis,
//                             );
//                           }).toList();
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: Row(
//                   children: _views.map((view) {
//                     final isSelected = _selectedView == view;
//                     return Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor:
//                                 isSelected ? AppColors.primary : AppColors.chip,
//                             foregroundColor: isSelected
//                                 ? AppColors.buttonText
//                                 : AppColors.textPrimary,
//                             elevation: isSelected ? 4 : 0,
//                             shadowColor: isSelected
//                                 ? AppColors.primary.withOpacity(0.3)
//                                 : Colors.transparent,
//                           ),
//                           onPressed: () async {
//                             if (view == 'Custom') {
//                               final picked = await showDateRangePicker(
//                                 context: context,
//                                 firstDate: DateTime(2000),
//                                 lastDate: DateTime(2100),
//                                 helpText: 'Select Custom Date Range',
//                                 confirmText: 'Confirm',
//                                 cancelText: 'Cancel',
//                                 builder: (context, child) {
//                                   return Theme(
//                                     data: ThemeData.dark().copyWith(
//                                       primaryColor: AppColors.primary,
//                                       colorScheme: ColorScheme.dark(
//                                         primary: AppColors.primary,
//                                         onPrimary: AppColors.buttonText,
//                                         surface: AppColors.card,
//                                         onSurface: AppColors.textPrimary,
//                                       ),
//                                       textTheme: const TextTheme(
//                                         titleLarge: TextStyle(
//                                             color: AppColors.textPrimary),
//                                         bodyLarge: TextStyle(
//                                             color: AppColors.textPrimary),
//                                         labelLarge: TextStyle(
//                                             color: AppColors.textPrimary),
//                                       ),
//                                       dialogBackgroundColor:
//                                           AppColors.background,
//                                     ),
//                                     child: child!,
//                                   );
//                                 },
//                               );
//                               if (!mounted) {
//                                 return;
//                               }
//                               if (picked != null) {
//                                 setState(() {
//                                   _customRange = picked;
//                                   _selectedView = view;
//                                 });
//                               }
//                             } else {
//                               setState(() {
//                                 _selectedView = view;
//                                 if (view == 'Daily' ||
//                                     view == 'Weekly' ||
//                                     view == 'Monthly') {
//                                   bool shouldReset = false;
//                                   if (view == 'Daily' &&
//                                       !(_currentDate.year ==
//                                               DateTime.now().year &&
//                                           _currentDate.month ==
//                                               DateTime.now().month &&
//                                           _currentDate.day ==
//                                               DateTime.now().day)) {
//                                     shouldReset = true;
//                                   } else if (view == 'Weekly') {
//                                     final currentWeekMonday = DateTime.now()
//                                         .subtract(Duration(
//                                             days: DateTime.now().weekday - 1));
//                                     final selectedWeekMonday =
//                                         _currentDate.subtract(Duration(
//                                             days: _currentDate.weekday - 1));
//                                     if (currentWeekMonday
//                                             .difference(selectedWeekMonday)
//                                             .inDays !=
//                                         0) {
//                                       shouldReset = true;
//                                     }
//                                   } else if (view == 'Monthly' &&
//                                       !(_currentDate.year ==
//                                               DateTime.now().year &&
//                                           _currentDate.month ==
//                                               DateTime.now().month)) {
//                                     shouldReset = true;
//                                   }

//                                   if (shouldReset) {
//                                     _currentDate = DateTime.now();
//                                   }
//                                 }
//                               });
//                             }
//                           },
//                           child: Text(view,
//                               style: const TextStyle(
//                                   fontSize: 13, fontWeight: FontWeight.w500)),
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               if (_selectedView != 'Total' && _selectedView != 'Custom')
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.arrow_back_ios, size: 18),
//                         color: AppColors.textPrimary,
//                         onPressed: () => _navigatePeriod(-1, _selectedView),
//                       ),
//                       Expanded(
//                         child: Center(
//                           child: Text(
//                             dateRangeDisplay,
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: AppColors.textPrimary,
//                             ),
//                           ),
//                         ),
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.arrow_forward_ios, size: 18),
//                         color: AppColors.textPrimary,
//                         onPressed: () => _navigatePeriod(1, _selectedView),
//                       ),
//                     ],
//                   ),
//                 ),
//               const SizedBox(height: 12),
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 16.0),
//                 padding: const EdgeInsets.all(16.0),
//                 decoration: BoxDecoration(
//                   color: AppColors.card,
//                   borderRadius: BorderRadius.circular(12.0),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.2),
//                       spreadRadius: 1,
//                       blurRadius: 5,
//                       offset: const Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     _buildSummaryTile(
//                         'Income', incomeTotal, AppColors.incomeDisplay),
//                     _buildSummaryTile(
//                         'Expense', expenseTotal, AppColors.expenseDisplay),
//                     _buildSummaryTile(
//                         'Net',
//                         net,
//                         net >= 0
//                             ? AppColors.primary
//                             : AppColors.expenseDisplay),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 16),
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 16.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     'Transactions',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.textPrimary,
//                     ),
//                   ),
//                 ),
//               ),
//               const Divider(height: 24, thickness: 1, color: AppColors.border),
//               Expanded(
//                 child: groupedItems.isEmpty
//                     ? Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.receipt_long,
//                                 size: 60, color: AppColors.textSecondary),
//                             const SizedBox(height: 10),
//                             Text(
//                               'No transactions found for this period.',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: AppColors.textSecondary,
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     : ListView.builder(
//                         itemCount: groupedItems.length,
//                         itemBuilder: (context, index) {
//                           final item = groupedItems[index];

//                           if (item.isDateHeader) {
//                             return Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 16.0, vertical: 8.0),
//                               child: Text(
//                                 DateFormat('EEEE, MMM d, y').format(item.date!),
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: AppColors.textPrimary,
//                                 ),
//                               ),
//                             );
//                           } else {
//                             final tx = item.transaction!;
//                             return Slidable(
//                               key: ValueKey(tx.id),
//                               endActionPane: ActionPane(
//                                 motion: const DrawerMotion(),
//                                 extentRatio: 0.25,
//                                 children: [
//                                   SlidableAction(
//                                     onPressed: (context) =>
//                                         _confirmAndDelete(context, tx),
//                                     backgroundColor: AppColors.delete,
//                                     foregroundColor: AppColors.buttonText,
//                                     icon: Icons.delete,
//                                     label: 'Delete',
//                                   ),
//                                 ],
//                               ),
//                               child: Card(
//                                 margin: const EdgeInsets.symmetric(
//                                     horizontal: 16, vertical: 6),
//                                 elevation: 2,
//                                 child: ListTile(
//                                   contentPadding: const EdgeInsets.symmetric(
//                                       horizontal: 16.0, vertical: 8.0),
//                                   leading: CircleAvatar(
//                                     backgroundColor:
//                                         tx.type == TransactionType.income
//                                             ? AppColors.incomeDisplay
//                                                 .withOpacity(0.2)
//                                             : AppColors.expenseDisplay
//                                                 .withOpacity(0.2),
//                                     child: Icon(
//                                       tx.type == TransactionType.income
//                                           ? Icons.arrow_downward_rounded
//                                           : Icons.arrow_upward_rounded,
//                                       color: tx.type == TransactionType.income
//                                           ? AppColors.incomeDisplay
//                                           : AppColors.expenseDisplay,
//                                     ),
//                                   ),
//                                   title: Text(
//                                     tx.title ?? 'No Title',
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16,
//                                       color: AppColors.cardText,
//                                     ),
//                                   ),
//                                   subtitle: Text(
//                                     '${DateFormat('MMMM d, y').format(tx.date ?? DateTime.now())} ${DateFormat('h:mm a').format(tx.date ?? DateTime.now())} • ${tx.account ?? 'N/A'} • ${tx.category ?? 'N/A'}',
//                                     style: const TextStyle(
//                                       fontSize: 12,
//                                       color: AppColors.textSecondary,
//                                     ),
//                                   ),
//                                   trailing: Text(
//                                     '₹${tx.amount?.toStringAsFixed(2)}',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.w800,
//                                       fontSize: 16,
//                                       color: tx.type == TransactionType.income
//                                           ? AppColors.incomeDisplay
//                                           : AppColors.expenseDisplay,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           }
//                         },
//                       ),
//               ),
//             ],
//           );
//         },
//       ),
//       // --- ADD THESE LINES FOR THE FLOATING ACTION BUTTON ---
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Navigate to your Add Transaction Page
//           Navigator.pushNamed(context, '/addTransaction');
//         },
//         backgroundColor:
//             AppColors.primary, // Use your primary color from AppColors
//         foregroundColor:
//             AppColors.buttonText, // Set icon/text color for visibility
//         shape: RoundedRectangleBorder(
//           borderRadius:
//               BorderRadius.circular(15.0), // Adjust for desired roundness
//         ),
//         child: const Icon(Icons.add, size: 30),
//       ),
//       floatingActionButtonLocation:
//           FloatingActionButtonLocation.endFloat, // Positions it at bottom right
//       // --------------------------------------------------------
//     );
//   }

//   Widget _buildSummaryTile(String label, double amount, Color color) {
//     return Column(
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 14,
//             color: AppColors.textSecondary,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           '₹${amount.toStringAsFixed(2)}',
//           style: TextStyle(
//             color: color,
//             fontSize: 18,
//             fontWeight: FontWeight.w800,
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:notegoexpense/model/transaction_notifier.dart';
import '../model/transaction_model.dart';
import '../extras/AppColors.dart'; // Ensure this path is correct
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:notegoexpense/main.dart'; // For scaffoldMessengerKey

class GroupedTransactionItem {
  final DateTime? date;
  final TransactionModel? transaction;

  GroupedTransactionItem.date(this.date) : transaction = null;
  GroupedTransactionItem.transaction(this.transaction) : date = null;

  bool get isDateHeader => date != null;
  bool get isTransaction => transaction != null;
}

bool isOpeningBalance(TransactionModel tx) {
  return tx.title == 'Opening Balance' &&
      tx.category == 'Opening Balance' &&
      tx.note == 'Auto-added on account creation';
}

class LedgerPage extends ConsumerStatefulWidget {
  const LedgerPage({super.key});

  @override
  ConsumerState<LedgerPage> createState() => _LedgerPageState();
}

class _LedgerPageState extends ConsumerState<LedgerPage> {
  String _selectedView = 'Daily';
  DateTimeRange? _customRange;
  DateTime _currentDate = DateTime.now();

  String _selectedCategory = 'All';
  String _selectedAccount = 'All';

  final List<String> _views = ['Daily', 'Weekly', 'Monthly', 'Total', 'Custom'];

  void _navigatePeriod(int amount, String viewType) {
    setState(() {
      if (viewType == 'Daily') {
        _currentDate = _currentDate.add(Duration(days: amount));
      } else if (viewType == 'Weekly') {
        _currentDate = _currentDate.add(Duration(days: amount * 7));
      } else if (viewType == 'Monthly') {
        _currentDate = DateTime(
          _currentDate.year,
          _currentDate.month + amount,
          _currentDate.day.clamp(
              1,
              DateTime(_currentDate.year, _currentDate.month + amount + 1, 0)
                  .day),
        );
      }
    });
  }

  List<GroupedTransactionItem> _getGroupedTransactionItems(
      List<TransactionModel> transactions) {
    final List<GroupedTransactionItem> items = [];
    if (transactions.isEmpty) return items;

    transactions.sort((a, b) =>
        (b.date ?? DateTime.now()).compareTo(a.date ?? DateTime.now()));

    DateTime? lastDateHeader;
    for (var tx in transactions) {
      final txDate = tx.date ?? DateTime.now();
      final normalizedTxDate = DateTime(txDate.year, txDate.month, txDate.day);

      if (lastDateHeader == null ||
          !normalizedTxDate.isAtSameMomentAs(lastDateHeader)) {
        items.add(GroupedTransactionItem.date(normalizedTxDate));
        lastDateHeader = normalizedTxDate;
      }
      items.add(GroupedTransactionItem.transaction(tx));
    }
    return items;
  }

  Future<void> _confirmAndDelete(
      BuildContext context, TransactionModel transaction) async {
    final bool confirm = await showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              backgroundColor: AppColors.card,
              title: Text('Delete Transaction?',
                  style: TextStyle(color: AppColors.textPrimary)),
              content: Text(
                'Are you sure you want to delete "${transaction.title ?? 'this transaction'}"?',
                style: TextStyle(color: AppColors.textPrimary),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: Text('Cancel',
                      style: TextStyle(color: AppColors.textSecondary)),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.delete,
                    foregroundColor: AppColors.buttonText,
                  ),
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        ) ??
        false;

    if (!mounted) {
      return;
    }

    if (confirm) {
      try {
        await ref
            .read(transactionsProvider.notifier)
            .deleteTransaction(transaction.id!);
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text(
                'Transaction "${transaction.title ?? 'Unknown'}" deleted.',
                style: TextStyle(
                    color: AppColors
                        .buttonText)), // Changed to buttonText for visibility
            backgroundColor: AppColors.success,
          ),
        );
      } catch (e) {
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', ''),
                style: TextStyle(color: AppColors.buttonText)),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(transactionsProvider);

    return Scaffold(
      backgroundColor: AppColors.background, // Use AppColors.background
      appBar: AppBar(
        title: const Text(
          'Ledger',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background, // Use AppColors.background
        foregroundColor: AppColors.textPrimary, // Use AppColors.textPrimary
      ),
      body: transactionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
            child: Text('Error: $e',
                style: const TextStyle(
                    color: AppColors.error))), // Use AppColors.error
        data: (transactions) {
          List<TransactionModel> filtered = transactions;

          final List<String> categories = {
            'All',
            ...transactions.map((tx) => tx.category ?? '')
          }.where((category) => category.isNotEmpty).toList();
          categories.sort();
          if (categories.contains('All')) {
            categories.remove('All');
          }
          categories.insert(0, 'All');

          final List<String> accounts = {
            'All',
            ...transactions.map((tx) => tx.account ?? '')
          }.where((account) => account.isNotEmpty).toList();
          accounts.sort();
          if (accounts.contains('All')) {
            accounts.remove('All');
          }
          accounts.insert(0, 'All');

          DateTime start;
          DateTime end;
          String dateRangeDisplay = '';

          if (_selectedView == 'Daily') {
            start = DateTime(
                _currentDate.year, _currentDate.month, _currentDate.day);
            end = start.add(const Duration(days: 1));
            dateRangeDisplay = DateFormat.yMMMd().format(_currentDate);
          } else if (_selectedView == 'Weekly') {
            start =
                _currentDate.subtract(Duration(days: _currentDate.weekday - 1));
            end = start.add(const Duration(days: 7));
            dateRangeDisplay =
                '${DateFormat.yMMMd().format(start)} - ${DateFormat.yMMMd().format(end.subtract(const Duration(days: 1)))}';
          } else if (_selectedView == 'Monthly') {
            start = DateTime(_currentDate.year, _currentDate.month, 1);
            end = DateTime(_currentDate.year, _currentDate.month + 1, 1);
            dateRangeDisplay = DateFormat.yMMMM().format(_currentDate);
          } else if (_selectedView == 'Custom' && _customRange != null) {
            start = _customRange!.start;
            end = _customRange!.end.add(const Duration(days: 1));
            dateRangeDisplay =
                '${DateFormat.yMMMd().format(_customRange!.start)} - ${DateFormat.yMMMd().format(_customRange!.end)}';
          } else {
            start = DateTime(2000, 1, 1);
            end = DateTime.now().add(const Duration(days: 365 * 10));
            dateRangeDisplay = 'All Time';
          }

          filtered = filtered.where((tx) {
            final txDate = tx.date ?? DateTime.now();
            final matchesCategory = _selectedCategory == 'All' ||
                (tx.category ?? '') == _selectedCategory;
            final matchesAccount = _selectedAccount == 'All' ||
                (tx.account ?? '') == _selectedAccount;

            return txDate
                    .isAfter(start.subtract(const Duration(milliseconds: 1))) &&
                txDate.isBefore(end) &&
                matchesCategory &&
                matchesAccount;
          }).toList();

          final incomeTotal = filtered
              .where((tx) => tx.type == TransactionType.income)
              .fold<double>(0, (sum, tx) => sum + (tx.amount ?? 0));
          final expenseTotal = filtered
              .where((tx) => tx.type == TransactionType.expense)
              .fold<double>(0, (sum, tx) => sum + (tx.amount ?? 0));
          final net = incomeTotal - expenseTotal;

          final List<GroupedTransactionItem> groupedItems =
              _getGroupedTransactionItems(filtered);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: 'Category',
                          labelStyle:
                              const TextStyle(color: AppColors.textSecondary),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.border),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.primary, width: 2.0),
                          ),
                          prefixIconColor:
                              AppColors.textSecondary, // For dropdown arrow
                        ),
                        dropdownColor:
                            AppColors.card, // Background of the dropdown menu
                        style: const TextStyle(
                            color: AppColors
                                .textPrimary), // Default text style for selected item
                        items: categories.map((cat) {
                          return DropdownMenuItem(
                            value: cat,
                            child: Text(
                              cat == 'All'
                                  ? 'All Categories'
                                  : (cat.isEmpty ? 'Uncategorized' : cat),
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors
                                      .textPrimary), // Text style for items in dropdown
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedCategory = value);
                          }
                        },
                        selectedItemBuilder: (BuildContext context) {
                          return categories.map((String value) {
                            return Text(
                              value == 'All'
                                  ? 'All Categories'
                                  : (value.isEmpty ? 'Uncategorized' : value),
                              style: const TextStyle(
                                  color: AppColors
                                      .textPrimary), // Color of the selected item in the field
                              overflow: TextOverflow.ellipsis,
                            );
                          }).toList();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedAccount,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: 'Account',
                          labelStyle:
                              const TextStyle(color: AppColors.textSecondary),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.border),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.primary, width: 2.0),
                          ),
                          prefixIconColor:
                              AppColors.textSecondary, // For dropdown arrow
                        ),
                        dropdownColor:
                            AppColors.card, // Background of the dropdown menu
                        style: const TextStyle(
                            color: AppColors
                                .textPrimary), // Default text style for selected item
                        items: accounts.map((acc) {
                          return DropdownMenuItem(
                            value: acc,
                            child: Text(
                              acc == 'All'
                                  ? 'All Accounts'
                                  : (acc.isEmpty ? 'Unnamed' : acc),
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors
                                      .textPrimary), // Text style for items in dropdown
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedAccount = value);
                          }
                        },
                        selectedItemBuilder: (BuildContext context) {
                          return accounts.map((String value) {
                            return Text(
                              value == 'All'
                                  ? 'All Accounts'
                                  : (value.isEmpty ? 'Unnamed' : value),
                              style: const TextStyle(
                                  color: AppColors
                                      .textPrimary), // Color of the selected item in the field
                              overflow: TextOverflow.ellipsis,
                            );
                          }).toList();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: _views.map((view) {
                    final isSelected = _selectedView == view;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isSelected ? AppColors.primary : AppColors.chip,
                            foregroundColor: isSelected
                                ? AppColors.buttonText
                                : AppColors.textPrimary,
                            elevation: isSelected ? 4 : 0,
                            shadowColor: isSelected
                                ? AppColors.primary.withOpacity(0.3)
                                : Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onPressed: () async {
                            if (view == 'Custom') {
                              final picked = await showDateRangePicker(
                                context: context,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                helpText: 'Select Custom Date Range',
                                confirmText: 'Confirm',
                                cancelText: 'Cancel',
                                builder: (context, child) {
                                  return Theme(
                                    data: ThemeData.dark().copyWith(
                                        colorScheme: ColorScheme.dark(
                                          primary: AppColors
                                              .primary, // Selected date background
                                          onPrimary: AppColors
                                              .buttonText, // Selected date text
                                          surface: AppColors
                                              .background, // Calendar background
                                          onSurface: AppColors
                                              .textPrimary, // Calendar day text
                                          onSurfaceVariant: AppColors
                                              .textSecondary, // Non-selected month text (e.g. adjacent month days)
                                        ),
                                        dialogBackgroundColor: AppColors
                                            .card, // Dialog background itself
                                        textButtonTheme: TextButtonThemeData(
                                          style: TextButton.styleFrom(
                                            foregroundColor: AppColors
                                                .primary, // Button text for "CANCEL", "OK"
                                          ),
                                        ),
                                        textTheme: TextTheme(
                                          labelLarge: TextStyle(
                                              color: AppColors
                                                  .textPrimary), // e.g. Year picker text
                                          bodyLarge: TextStyle(
                                              color: AppColors
                                                  .textPrimary), // Date numbers (non-selected)
                                          titleMedium: TextStyle(
                                              color: AppColors
                                                  .textPrimary), // Month/Year title
                                        ),
                                        appBarTheme: AppBarTheme(
                                          backgroundColor: AppColors.background,
                                          foregroundColor:
                                              AppColors.textPrimary,
                                        )),
                                    child: child!,
                                  );
                                },
                              );
                              if (!mounted) {
                                return;
                              }
                              if (picked != null) {
                                setState(() {
                                  _customRange = picked;
                                  _selectedView = view;
                                });
                              }
                            } else {
                              setState(() {
                                _selectedView = view;
                                if (view == 'Daily' ||
                                    view == 'Weekly' ||
                                    view == 'Monthly') {
                                  bool shouldReset = false;
                                  if (view == 'Daily' &&
                                      !(_currentDate.year ==
                                              DateTime.now().year &&
                                          _currentDate.month ==
                                              DateTime.now().month &&
                                          _currentDate.day ==
                                              DateTime.now().day)) {
                                    shouldReset = true;
                                  } else if (view == 'Weekly') {
                                    final currentWeekMonday = DateTime.now()
                                        .subtract(Duration(
                                            days: DateTime.now().weekday - 1));
                                    final selectedWeekMonday =
                                        _currentDate.subtract(Duration(
                                            days: _currentDate.weekday - 1));
                                    if (currentWeekMonday
                                            .difference(selectedWeekMonday)
                                            .inDays !=
                                        0) {
                                      shouldReset = true;
                                    }
                                  } else if (view == 'Monthly' &&
                                      !(_currentDate.year ==
                                              DateTime.now().year &&
                                          _currentDate.month ==
                                              DateTime.now().month)) {
                                    shouldReset = true;
                                  }

                                  if (shouldReset) {
                                    _currentDate = DateTime.now();
                                  }
                                }
                              });
                            }
                          },
                          child: Text(view,
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
              if (_selectedView != 'Total' && _selectedView != 'Custom')
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, size: 18),
                        color: AppColors.textPrimary,
                        onPressed: () => _navigatePeriod(-1, _selectedView),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            dateRangeDisplay,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, size: 18),
                        color: AppColors.textPrimary,
                        onPressed: () => _navigatePeriod(1, _selectedView),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 12),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: AppColors.card, // Use AppColors.card
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow
                          .withOpacity(0.2), // Use AppColors.shadow
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSummaryTile(
                        'Income', incomeTotal, AppColors.incomeDisplay),
                    _buildSummaryTile(
                        'Expense', expenseTotal, AppColors.expenseDisplay),
                    _buildSummaryTile(
                        'Net',
                        net,
                        net >= 0
                            ? AppColors.primary
                            : AppColors.expenseDisplay),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Transactions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              const Divider(height: 24, thickness: 1, color: AppColors.border),
              Expanded(
                child: groupedItems.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.receipt_long,
                                size: 60, color: AppColors.textSecondary),
                            const SizedBox(height: 10),
                            Text(
                              'No transactions found for this period.',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: groupedItems.length,
                        itemBuilder: (context, index) {
                          final item = groupedItems[index];

                          if (item.isDateHeader) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Text(
                                DateFormat('EEEE, MMM d, y').format(item.date!),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            );
                          } else {
                            final tx = item.transaction!;

                            if (isOpeningBalance(tx)) {
                              return Card(
                                color: AppColors.card,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 6),
                                elevation: 2,
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  leading: CircleAvatar(
                                    backgroundColor:
                                        AppColors.primary.withOpacity(0.2),
                                    child: const Icon(
                                      Icons.account_balance_wallet_rounded,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  title: const Text(
                                    'Opening Balance',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: AppColors.cardText,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${DateFormat('MMMM d, y').format(tx.date ?? DateTime.now())} ${DateFormat('h:mm a').format(tx.date ?? DateTime.now())} • ${tx.account ?? 'N/A'}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  trailing: Text(
                                    '₹${tx.amount?.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              );
                            }

                            return Slidable(
                              key: ValueKey(tx.id),
                              startActionPane: ActionPane(
                                motion: const DrawerMotion(),
                                extentRatio: 0.25,
                                children: [
                                  SlidableAction(
                                    onPressed: (context) =>
                                        _confirmAndDelete(context, tx),
                                    backgroundColor: AppColors.delete,
                                    foregroundColor: AppColors.buttonText,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                  ),
                                ],
                              ),
                              endActionPane: ActionPane(
                                motion: const DrawerMotion(),
                                extentRatio: 0.25,
                                children: [
                                  SlidableAction(
                                    onPressed: (context) {
                                      Navigator.pushNamed(
                                        context,
                                        '/addTransaction',
                                        arguments: tx,
                                      );
                                    },
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: AppColors.buttonText,
                                    icon: Icons.edit,
                                    label: 'Edit',
                                  ),
                                ],
                              ),
                              child: Card(
                                color: AppColors.card,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 6),
                                elevation: 2,
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  leading: CircleAvatar(
                                    backgroundColor:
                                        tx.type == TransactionType.income
                                            ? AppColors.incomeDisplay
                                                .withOpacity(0.2)
                                            : AppColors.expenseDisplay
                                                .withOpacity(0.2),
                                    child: Icon(
                                      tx.type == TransactionType.income
                                          ? Icons.arrow_downward_rounded
                                          : Icons.arrow_upward_rounded,
                                      color: tx.type == TransactionType.income
                                          ? AppColors.incomeDisplay
                                          : AppColors.expenseDisplay,
                                    ),
                                  ),
                                  title: Text(
                                    tx.title ?? 'No Title',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: AppColors.cardText,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${DateFormat('MMMM d, y').format(tx.date ?? DateTime.now())} ${DateFormat('h:mm a').format(tx.date ?? DateTime.now())} • ${tx.account ?? 'N/A'} • ${tx.category ?? 'N/A'}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  trailing: Text(
                                    '₹${tx.amount?.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                      color: tx.type == TransactionType.income
                                          ? AppColors.incomeDisplay
                                          : AppColors.expenseDisplay,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to your Add Transaction Page
          Navigator.pushNamed(context, '/addTransaction');
        },
        backgroundColor:
            AppColors.primary, // Use your primary color from AppColors
        foregroundColor:
            AppColors.buttonText, // Set icon/text color for visibility
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(15.0), // Adjust for desired roundness
        ),
        child: const Icon(Icons.add, size: 30),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, // Positions it at bottom right
    );
  }

  Widget _buildSummaryTile(String label, double amount, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: AppColors.textSecondary, // Use AppColors.textSecondary
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
