import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:notegoexpense/model/category_model.dart';
import 'package:notegoexpense/model/transaction_model.dart';
import 'package:notegoexpense/pages/SettingPage/AddExpenseCategory.dart';
import 'package:notegoexpense/pages/SettingPage/AddIncomeCategory.dart';
import 'package:notegoexpense/pages/SettingPage/ExpenseCategory.dart';
import 'package:notegoexpense/pages/account_management.dart';
import 'package:notegoexpense/pages/add_transactions.dart';
import 'package:notegoexpense/pages/hivedata.dart';
import 'package:notegoexpense/pages/home_screen.dart';
import 'package:notegoexpense/pages/ledger.dart';
import 'package:notegoexpense/pages/SettingPage/settings.dart';
import 'package:notegoexpense/pages/welcome.dart';
import 'package:notegoexpense/pages/SettingPage/IncomeCategoryPage.dart';
import 'package:notegoexpense/widgets/BottomBar.dart';
import 'package:permission_handler/permission_handler.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
// Register all Adapters
  Hive.registerAdapter(ExpenseCategoryAdapter());
  Hive.registerAdapter(IncomeCategoryAdapter());
  Hive.registerAdapter(TransactionTypeAdapter());
  Hive.registerAdapter(TransactionModelAdapter());
  Hive.registerAdapter(AccountRoleAdapter());
  Hive.registerAdapter(AccountAdapter());
  

// Open all required boxes
  await Hive.openBox<ExpenseCategory>('expense_categories');
  await Hive.openBox<IncomeCategory>('income_categories');
  await Hive.openBox<TransactionModel>('transactions');

// Preload default categories AFTER opening relevant boxes
  await preloadDefaultIncomeCategories();
  await preloadDefaultExpenseCategories();

  await Permission.sms.request();

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
      title: 'Note & GoExpense',
      scaffoldMessengerKey:
          scaffoldMessengerKey, // <--- Assign the global key here

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WelcomePage(),
      routes: {
        '/home': (context) => HomeScreen(),
        '/addTransaction': (context) {
          final tx =
              ModalRoute.of(context)!.settings.arguments as TransactionModel?;
          return AddTransactionPage(transaction: tx);
        },
        '/ledger': (context) => const LedgerPage(),
        '/accountManagement': (context) => const AccountManagementPage(),
        '/hiveDebug': (context) => const HiveDebugPage(),
        '/settings': (context) => const Settings(),
        '/expenseCategory': (context) => const Expensecategory(),
        '/incomeCategory': (context) => const IncomeCategoryPage(),
        '/addincomecategory': (context) => const AddIncomeCategory(),
        '/addexpensecategory': (context) => const AddExpenseCategory(),
      },
    );
  }
}
