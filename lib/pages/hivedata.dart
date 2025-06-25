import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../model/transaction_model.dart';
import '../model/category_model.dart';

class HiveDebugPage extends StatefulWidget {
  const HiveDebugPage({super.key});

  @override
  State<HiveDebugPage> createState() => _HiveDebugPageState();
}

class _HiveDebugPageState extends State<HiveDebugPage> {
  Box<Account>? _accountBox;
  Box<TransactionModel>? _transactionBox;
  Box<ExpenseCategory>? _categoryBox;
  Box<IncomeCategory>? _incomeCategoryBox;

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _openBoxes();
  }

  Future<void> _openBoxes() async {
    _accountBox = await Hive.openBox<Account>('accounts');
    _transactionBox = await Hive.openBox<TransactionModel>('transactions');
    _categoryBox = await Hive.openBox<ExpenseCategory>('expense_categories');
    _incomeCategoryBox =
        await Hive.openBox<IncomeCategory>('income_categories');
    setState(() => _loading = false);
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading ||
        _accountBox == null ||
        _transactionBox == null ||
        _categoryBox == null ||
        _incomeCategoryBox == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Hive DB Viewer")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("📦 Hive Debug Viewer"),
        backgroundColor: Colors.grey[800],
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("🔐 Accounts",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 8),
          if (_accountBox!.isEmpty)
            const Text("No accounts found",
                style: TextStyle(color: Colors.white70)),
          ..._accountBox!.values.map((acc) => Card(
                color: Colors.grey[850],
                child: ListTile(
                  title: Text(acc.name,
                      style: const TextStyle(color: Colors.white)),
                  subtitle: Text(
                    "ID: ${acc.id}\nBalance: ₹${acc.balance.toStringAsFixed(2)}\n"
                    "Type: ${acc.type}\nRole: ${acc.role.name}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              )),
          const Divider(color: Colors.white54),
          const Text("💸 Transactions",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 8),
          if (_transactionBox!.isEmpty)
            const Text("No transactions found",
                style: TextStyle(color: Colors.white70)),
          ..._transactionBox!.values.map((tx) => Card(
                color: Colors.grey[850],
                child: ListTile(
                  title: Text(tx.title ?? "No Title",
                      style: const TextStyle(color: Colors.white)),
                  subtitle: Text(
                    "ID: ${tx.id}\nAccount: ${tx.account}\nAmount: ₹${tx.amount?.toStringAsFixed(2) ?? 'N/A'}\n"
                    "Category: ${tx.category}\nType: ${tx.type.name}\nDate: ${_formatDate(tx.date)}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              )),
          const Divider(color: Colors.white54),
          const Text("📂 Expense Categories",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 8),
          if (_categoryBox!.isEmpty)
            const Text("No categories found",
                style: TextStyle(color: Colors.white70)),
          ..._categoryBox!.values.map((cat) => Card(
                color: Colors.grey[850],
                child: ListTile(
                  title: Text(cat.expenseCategoryName,
                      style: const TextStyle(color: Colors.white)),
                  subtitle: Text(
                    "Subcategories: ${cat.subExpenseCategory.join(', ')}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              )),
          const Divider(color: Colors.white54),
          const Text("📈 Income Categories",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 8),
          if (_incomeCategoryBox!.isEmpty)
            const Text("No categories found",
                style: TextStyle(color: Colors.white70)),
          ..._incomeCategoryBox!.values.map((cat) => Card(
                color: Colors.grey[850],
                child: ListTile(
                  title: Text(cat.incomeCategoryName,
                      style: const TextStyle(color: Colors.white)),
                  subtitle: Text(
                    "Subcategories: ${cat.subIncomeCategory.join(', ')}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
