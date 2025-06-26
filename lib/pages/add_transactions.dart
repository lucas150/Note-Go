import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../model/transaction_model.dart';
import '../model/category_model.dart';
import '../model/transaction_notifier.dart';
import '../model/account_notifier.dart';
import '../extras/GetAvailableBalance.dart';
import '../extras/AppColors.dart';

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
  String _mainCategory = '';
  String _subCategory = '';
  String _note = '';
  DateTime _selectedDate = DateTime.now();
  TransactionType _transactionType = TransactionType.expense;
  late final Future<Map<String, dynamic>> _categoryFuture;

  // State for selected account within the bottom sheet
  String _tempSelectedAccount = '';

  // State for selected main category within the category bottom sheet
  String _tempSelectedMainCategoryForSheet = '';

  @override
  void initState() {
    super.initState();
    _categoryFuture = _loadCategoryBoxes();
  }

  Future<Map<String, dynamic>> _loadCategoryBoxes() async {
    final expenseBox =
        await Hive.openBox<ExpenseCategory>('expense_categories');
    final incomeBox = await Hive.openBox<IncomeCategory>('income_categories');
    return {
      'expense': expenseBox.values.toList(),
      'income': incomeBox.values.toList(),
    };
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.buttonText,
              onSurface: AppColors.card,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _showCategoryBottomSheet(List<ExpenseCategory> expenseCategories,
      List<IncomeCategory> incomeCategories) {
    _tempSelectedMainCategoryForSheet = _mainCategory;
    String tempSelectedSubCategoryForSheet = _subCategory;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (BuildContext sheetContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            final List<String> mainCats = _transactionType ==
                    TransactionType.expense
                ? expenseCategories.map((e) => e.expenseCategoryName).toList()
                : incomeCategories.map((e) => e.incomeCategoryName).toList();

            final List<String> currentSubCategories =
                _tempSelectedMainCategoryForSheet.isNotEmpty
                    ? (_transactionType == TransactionType.expense
                        ? (expenseCategories
                                .firstWhere(
                                    (e) =>
                                        e.expenseCategoryName ==
                                        _tempSelectedMainCategoryForSheet,
                                    orElse: () => ExpenseCategory(
                                        expenseCategoryName: '',
                                        subExpenseCategory: []))
                                .subExpenseCategory ??
                            [])
                        : (incomeCategories
                                .firstWhere(
                                    (e) =>
                                        e.incomeCategoryName ==
                                        _tempSelectedMainCategoryForSheet,
                                    orElse: () => IncomeCategory(
                                        incomeCategoryName: '',
                                        subIncomeCategory: []))
                                .subIncomeCategory ??
                            []))
                    : [];

            final ScrollController mainCatController = ScrollController();
            final ScrollController subCatController = ScrollController();

            return Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Select Category',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Divider(color: AppColors.border, height: 1),
                  Expanded(
                    child: Row(
                      children: [
                        // Main Categories Column
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
                                child: Text('Main Category',
                                    style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Expanded(
                                child: Scrollbar(
                                  thumbVisibility: true,
                                  controller: mainCatController,
                                  child: ListView.builder(
                                    controller: mainCatController,
                                    itemCount: mainCats.length,
                                    itemBuilder: (context, index) {
                                      final cat = mainCats[index];
                                      final isSelected =
                                          _tempSelectedMainCategoryForSheet ==
                                              cat;
                                      return ListTile(
                                        tileColor: isSelected
                                            ? AppColors.primary.withOpacity(0.2)
                                            : null,
                                        title: Text(cat,
                                            style: TextStyle(
                                                color: AppColors.textPrimary)),
                                        onTap: () {
                                          setModalState(() {
                                            _tempSelectedMainCategoryForSheet =
                                                cat;
                                            tempSelectedSubCategoryForSheet =
                                                '';
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        VerticalDivider(color: AppColors.border, width: 1),
                        // Sub-Categories Column
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
                                child: Text('Sub-Category',
                                    style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.bold)),
                              ),
                              _tempSelectedMainCategoryForSheet.isEmpty
                                  ? const Expanded(
                                      child: Center(
                                        child: Text(
                                          'Select a main category first',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: AppColors.textSecondary),
                                        ),
                                      ),
                                    )
                                  : currentSubCategories.isEmpty
                                      ? Expanded(
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'No sub-categories available for "${_tempSelectedMainCategoryForSheet}"',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: AppColors
                                                          .textSecondary),
                                                ),
                                                const SizedBox(height: 16),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _mainCategory =
                                                          _tempSelectedMainCategoryForSheet;
                                                      _subCategory = '';
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        AppColors.primary,
                                                    foregroundColor:
                                                        AppColors.buttonText,
                                                  ),
                                                  child: const Text(
                                                      'Confirm Main Category'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : Expanded(
                                          child: Scrollbar(
                                            thumbVisibility: true,
                                            controller: subCatController,
                                            child: ListView.builder(
                                              controller: subCatController,
                                              itemCount:
                                                  currentSubCategories.length,
                                              itemBuilder: (context, index) {
                                                final sub =
                                                    currentSubCategories[index];
                                                final isSelected =
                                                    tempSelectedSubCategoryForSheet ==
                                                        sub;
                                                return ListTile(
                                                  tileColor: isSelected
                                                      ? AppColors.primary
                                                          .withOpacity(0.2)
                                                      : null,
                                                  title: Text(sub,
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .textPrimary)),
                                                  onTap: () {
                                                    setModalState(() {
                                                      tempSelectedSubCategoryForSheet =
                                                          sub;
                                                    });
                                                    setState(() {
                                                      _mainCategory =
                                                          _tempSelectedMainCategoryForSheet;
                                                      _subCategory =
                                                          tempSelectedSubCategoryForSheet;
                                                    });
                                                    // Navigator.pop(context);
                                                    Future.delayed(
                                                        const Duration(
                                                            seconds: 1), () {
                                                      if (context.mounted) {
                                                        Navigator.pop(context);
                                                      }
                                                    });
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_tempSelectedMainCategoryForSheet.isNotEmpty &&
                      currentSubCategories.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _mainCategory = _tempSelectedMainCategoryForSheet;
                              _subCategory = '';
                            });
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            foregroundColor: AppColors.primary,
                            side: BorderSide(color: AppColors.primary),
                          ),
                          child: const Text('Use Selected Main Category Only'),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAccountBottomSheet(List<Account> accounts) {
    // Changed Account to AccountModel
    // Initialize temporary selected account when sheet opens
    _tempSelectedAccount = _account;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true, // Make it scrollable if content overflows
      builder: (BuildContext sheetContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height *
                  0.5, // Set a fixed height for the modal
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Select Account',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Divider(color: AppColors.border, height: 1),
                  // --- START OF CHANGES FOR ACCOUNT BOTTOM SHEET ---
                  SizedBox(
                    // Replaced Expanded with SizedBox to control max height
                    height: MediaQuery.of(context).size.height *
                        0.25, // Approx 5-6 items, same as categories
                    child: ListView.builder(
                      shrinkWrap:
                          true, // Needed for fixed height with scrolling
                      physics:
                          const ClampingScrollPhysics(), // Ensures proper scrolling
                      itemCount: accounts.length,
                      itemBuilder: (context, index) {
                        final acc = accounts[index];
                        final isSelected = _tempSelectedAccount == acc.name;
                        final balance = calculateAccountBalance(ref, acc.name);

                        return ListTile(
                          tileColor: isSelected
                              ? AppColors.primary.withOpacity(0.2)
                              : null,
                          title: Text(acc.name,
                              style: TextStyle(color: AppColors.textPrimary)),
                          subtitle: Text(
                            'Available Balance: ₹${balance.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          onTap: () {
                            setModalState(() {
                              _tempSelectedAccount =
                                  acc.name; // Update temp state for highlight
                            });
                            // Update main widget's state and close sheet on final selection
                            setState(() => _account = _tempSelectedAccount);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                  // --- END OF CHANGES FOR ACCOUNT BOTTOM SHEET ---
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _saveTransaction() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_mainCategory.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a main category.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_account.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an account.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final categoryString = _subCategory.isNotEmpty
          ? '$_mainCategory/$_subCategory'
          : _mainCategory; // Use only main if sub is empty

      final newTransaction = TransactionModel(
        id: const Uuid().v4(),
        type: _transactionType,
        title: _title,
        amount: _amount,
        date: _selectedDate,
        category: categoryString,
        account: _account,
        note: _note,
      );
      await ref
          .read(transactionsProvider.notifier)
          .addTransaction(newTransaction);
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

    return FutureBuilder<Map<String, dynamic>>(
      future: _categoryFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')));
        }
        if (!snapshot.hasData) {
          return const Scaffold(
              body: Center(child: Text('No categories found')));
        }

        final expenseCategories =
            snapshot.data!['expense'] as List<ExpenseCategory>;
        final incomeCategories =
            snapshot.data!['income'] as List<IncomeCategory>;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.card,
            title: const Text('Add Transaction',
                style: TextStyle(color: AppColors.textPrimary)),
            elevation: 0.5,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ToggleButtons(
                  color: AppColors.textSecondary,
                  selectedColor: AppColors.primary,
                  fillColor: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  borderColor: AppColors.border,
                  selectedBorderColor: AppColors.primary,
                  onPressed: (index) {
                    setState(() {
                      _transactionType = index == 0
                          ? TransactionType.expense
                          : TransactionType.income;
                      _mainCategory = '';
                      _subCategory = '';
                    });
                  },
                  isSelected: [
                    _transactionType == TransactionType.expense,
                    _transactionType == TransactionType.income,
                  ],
                  children: const [
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('Expense')),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('Income')),
                  ],
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Date Picker
                  Card(
                    color: AppColors.card,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: AppColors.border, width: 1),
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      title: const Text('Date',
                          style: TextStyle(color: AppColors.textSecondary)),
                      subtitle: Text(DateFormat.yMMMd().format(_selectedDate),
                          style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold)),
                      trailing: const Icon(Icons.calendar_today,
                          color: AppColors.primary),
                      onTap: _pickDate,
                    ),
                  ),
                  // Title Text Field
                  _buildTextFormField(
                    labelText: 'Title',
                    onSaved: (val) => _title = val ?? '',
                    validator: (val) => val == null || val.isEmpty
                        ? 'Please enter a title'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  // Amount Text Field
                  _buildTextFormField(
                    labelText: 'Amount (₹)',
                    keyboardType: TextInputType.number,
                    onSaved: (val) =>
                        _amount = double.tryParse(val ?? '') ?? 0.0,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty)
                        return 'Please enter an amount';
                      final value = double.tryParse(val.trim());
                      if (value == null || value <= 0)
                        return 'Please enter a valid amount';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  // Category Selection
                  _buildDropdownField(
                    label: _mainCategory.isEmpty
                        ? 'Select Category'
                        : (_subCategory.isEmpty
                            ? _mainCategory
                            : '$_mainCategory / $_subCategory'),
                    onTap: () => _showCategoryBottomSheet(
                        expenseCategories, incomeCategories),
                    icon: Icons.category,
                  ),
                  const SizedBox(height: 12),
                  // Account Selection
                  _buildDropdownField(
                    label: _account.isEmpty ? 'Select Account' : _account,
                    onTap: () => _showAccountBottomSheet(accountList),
                    icon: Icons.account_balance_wallet,
                  ),
                  const SizedBox(height: 12),
                  // Note Text Field
                  _buildTextFormField(
                    labelText: 'Note (Optional)',
                    onSaved: (val) => _note = val ?? '',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.save, color: AppColors.buttonText),
                      label: const Text('Save Transaction',
                          style: TextStyle(color: AppColors.buttonText)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      onPressed: _saveTransaction,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Helper method to create consistent TextFormField
  Widget _buildTextFormField({
    required String labelText,
    required FormFieldSetter<String> onSaved,
    FormFieldValidator<String>? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: AppColors.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        hintStyle: const TextStyle(color: AppColors.textSecondary),
      ),
      style: const TextStyle(color: AppColors.textPrimary),
      onSaved: onSaved,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      cursorColor: AppColors.primary,
    );
  }

  // Helper method to create consistent dropdown-like fields
  Widget _buildDropdownField({
    required String label,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(color: AppColors.textPrimary),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(icon, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
