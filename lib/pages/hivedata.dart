import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../model/transaction_model.dart';

class HiveDebugPage extends StatefulWidget {
  const HiveDebugPage({super.key});

  @override
  State<HiveDebugPage> createState() => _HiveDebugPageState();
}

class _HiveDebugPageState extends State<HiveDebugPage> {
  late Box<Account> _accountBox;
  late Box<TransactionModel> _transactionBox;

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _openBoxes();
  }

  Future<void> _openBoxes() async {
    _accountBox = await Hive.openBox<Account>('accounts');
    _transactionBox = await Hive.openBox<TransactionModel>('transactions');
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text("Hive DB Viewer")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("📦 Hive Debug Viewer")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("🔐 Accounts",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ..._accountBox.values.map((acc) => Card(
                child: ListTile(
                  title: Text(acc.name),
                  subtitle: Text(
                      "ID: ${acc.id}\nBalance: ₹${acc.balance.toStringAsFixed(2)}\nType: ${acc.type}"),
                ),
              )),
          const Divider(),
          const Text("💸 Transactions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ..._transactionBox.values.map((tx) => Card(
                child: ListTile(
                  title: Text(tx.title ?? "No Title"),
                  subtitle: Text(
                    "ID: ${tx.id}\nAccount: ${tx.account}\nAmount: ₹${tx.amount?.toStringAsFixed(2)}\n"
                    "Category: ${tx.category}\nType: ${tx.type.name}\nDate: ${tx.date}",
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
