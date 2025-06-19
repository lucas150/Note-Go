import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../model/transaction_model.dart';
import '../model/transaction_notifier.dart';
import '../model/account_notifier.dart';
import 'package:uuid/uuid.dart';

class AddTransactionPage extends ConsumerStatefulWidget {
  const AddTransactionPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends ConsumerState<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();

  String _title = '';
  String _account = '';
  double _amount = 0.0;
  String _category = '';
  String _note = '';
  DateTime _selectedDate = DateTime.now();
  TransactionType _transactionType = TransactionType.expense;

  final TextEditingController _customCategoryController =
      TextEditingController();

  final List<String> _expenseCategories = [
    'Food',
    'Transport',
    'Rent',
    'Utilities',
    'Shopping',
    'Other'
  ];
  final List<String> _incomeCategories = [
    'Salary',
    'Freelance',
    'Investment',
    'Gift',
    'Other'
  ];
  final List<String> _savingCategories = [
    'Emergency Fund',
    'Vacation',
    'Investments',
    'Other'
  ];

  bool get _isIncome => _transactionType == TransactionType.income;
  bool get _isExpense => _transactionType == TransactionType.expense;
  bool get _isSavings => _transactionType == TransactionType.savings;

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _saveTransaction() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Handle custom category
      if (_category == 'Other') {
        final newCategory = _customCategoryController.text.trim();
        _category = newCategory;

        if (_isIncome && !_incomeCategories.contains(newCategory)) {
          setState(() => _incomeCategories.insert(
              _incomeCategories.length - 1, newCategory));
        } else if (_isExpense && !_expenseCategories.contains(newCategory)) {
          setState(() => _expenseCategories.insert(
              _expenseCategories.length - 1, newCategory));
        } else if (_isSavings && !_savingCategories.contains(newCategory)) {
          setState(() => _savingCategories.insert(
              _savingCategories.length - 1, newCategory));
        }
      }

      // Create transaction
      final newTransaction = TransactionModel(
        id: const Uuid().v4(),
        type: _transactionType,
        title: _title,
        amount: _amount,
        date: _selectedDate,
        category: _category,
        account: _account,
        note: _note,
      );

      await ref
          .read(transactionsProvider.notifier)
          .addTransaction(newTransaction);

      // 🌟 Update account balance
      final accountsNotifier = ref.read(accountsProvider.notifier);
      final accountsAsync = ref.read(accountsProvider);

      final accounts = accountsAsync.maybeWhen(
        data: (data) => data,
        orElse: () => [],
      );

      final selectedAccount = accounts.firstWhere(
        (acc) => acc.name == _account,
        orElse: () => throw Exception('Account not found'),
      );

      double updatedBalance = selectedAccount.balance;
      if (_isIncome) {
        updatedBalance += _amount;
      } else if (_isExpense || _isSavings) {
        updatedBalance -= _amount;
      }

      final updatedAccount = selectedAccount.copyWith(balance: updatedBalance);
      await accountsNotifier.updateAccount(updatedAccount);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction added!')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountList = ref.watch(accountsProvider).value ?? [];
    final categories = _isIncome
        ? _incomeCategories
        : _isExpense
            ? _expenseCategories
            : _savingCategories;

    if (_category.isEmpty) {
      _category = categories.first;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Add Transaction')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceChip(
                    label: const Text('Expense'),
                    selected: _isExpense,
                    onSelected: (_) => setState(() {
                      _transactionType = TransactionType.expense;
                      _category = _expenseCategories.first;
                    }),
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    label: const Text('Income'),
                    selected: _isIncome,
                    onSelected: (_) => setState(() {
                      _transactionType = TransactionType.income;
                      _category = _incomeCategories.first;
                    }),
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    label: const Text('Savings'),
                    selected: _isSavings,
                    onSelected: (_) => setState(() {
                      _transactionType = TransactionType.savings;
                      _category = _savingCategories.first;
                    }),
                  ),
                ],
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Date'),
                subtitle: Text(DateFormat.yMMMd().format(_selectedDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                onSaved: (val) => _title = val ?? '',
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter title' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Amount (₹)'),
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Enter amount';
                  final value = double.tryParse(val.trim());
                  if (value == null || value <= 0) return 'Enter valid amount';
                  return null;
                },
                onSaved: (val) => _amount = double.tryParse(val ?? '') ?? 0.0,
              ),
              DropdownButtonFormField<String>(
                value: _category.isNotEmpty && categories.contains(_category)
                    ? _category
                    : 'Other',
                decoration: const InputDecoration(labelText: 'Category'),
                items: categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) => setState(() {
                  _category = val!;
                  if (_category == 'Other') _customCategoryController.clear();
                }),
              ),
              if (_category == 'Other')
                TextFormField(
                  controller: _customCategoryController,
                  decoration:
                      const InputDecoration(labelText: 'Enter Custom Category'),
                  validator: (val) => val == null || val.isEmpty
                      ? 'Enter custom category'
                      : null,
                ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Account'),
                value: accountList.any((acc) => acc.name == _account)
                    ? _account
                    : null,
                items: accountList.map((acc) {
                  return DropdownMenuItem(
                    value: acc.name,
                    child: Text('${acc.name} • ₹${acc.balance}'),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _account = val ?? ''),
                validator: (val) => val == null || val.isEmpty
                    ? 'Please select an account'
                    : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Note'),
                onSaved: (val) => _note = val ?? '',
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Save Transaction'),
                onPressed: _saveTransaction,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
