import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:notegoexpense/model/transaction_model.dart';
import 'package:notegoexpense/pages/account_management.dart';
import 'package:notegoexpense/pages/add_transactions.dart';
import 'package:notegoexpense/pages/hivedata.dart';
import 'package:notegoexpense/pages/ledger.dart';
import 'package:notegoexpense/pages/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(TransactionTypeAdapter());
  Hive.registerAdapter(TransactionModelAdapter());
  Hive.registerAdapter(AccountRoleAdapter());

  Hive.registerAdapter(AccountAdapter());
  await Hive.openBox<TransactionModel>('transactions');

  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WelcomePage(),
      routes: {
        '/addTransaction': (context) => const AddTransactionPage(),
        '/ledger': (context) => const LedgerPage(),
        '/accountManagement': (context) => const AccountManagementPage(),
        '/hiveDebug': (context) => const HiveDebugPage(),
      },
    );
  }
}
