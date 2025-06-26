import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../model/transaction_model.dart';
import '../model/account_notifier.dart';
import '../extras/AppColors.dart';

class AccountManagementPage extends ConsumerStatefulWidget {
  const AccountManagementPage({super.key});

  @override
  ConsumerState<AccountManagementPage> createState() =>
      _AccountManagementPageState();
}

class _AccountManagementPageState extends ConsumerState<AccountManagementPage> {
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  String _type = 'Bank';
  AccountRole _role = AccountRole.transaction;
  Account? _editingAccount;

  void _resetForm() {
    _nameController.clear();
    _balanceController.clear();
    _type = 'Bank';
    _role = AccountRole.transaction;
    _editingAccount = null;
    setState(() {});
  }

  void _submitForm() {
    final name = _nameController.text.trim();
    final balance = double.tryParse(_balanceController.text.trim()) ?? 0.0;
    if (name.isEmpty) return;

    final acc = Account(
      id: _editingAccount?.id ?? const Uuid().v4(),
      name: name,
      balance: balance,
      type: _type,
      role: _role,
    );

    final notifier = ref.read(accountsProvider.notifier);
    if (_editingAccount == null) {
      notifier.addAccount(acc);
    } else {
      notifier.updateAccount(acc);
    }

    _resetForm();
  }

  @override
  Widget build(BuildContext context) {
    final accountsAsync = ref.watch(accountsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Account Manager',
            style: TextStyle(color: AppColors.textPrimary)),
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        elevation: 0,
      ),
      body: accountsAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, _) => Center(
            child: Text('Error: $err',
                style: TextStyle(color: AppColors.textPrimary))),
        data: (accounts) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                color: AppColors.card,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        _editingAccount == null
                            ? 'Add Account'
                            : 'Edit Account',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _nameController,
                        decoration: _inputDecoration('Account Name'),
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _balanceController,
                        decoration: _inputDecoration('Balance'),
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _type,
                        dropdownColor: AppColors.card,
                        decoration: _inputDecoration('Type'),
                        iconEnabledColor: AppColors.primary,
                        style: const TextStyle(color: AppColors.textPrimary),
                        onChanged: (val) => setState(() => _type = val!),
                        items: ['Bank', 'Wallet', 'Cash', 'UPI', 'Credit Card']
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<AccountRole>(
                        value: _role,
                        dropdownColor: AppColors.card,
                        decoration: _inputDecoration('Role'),
                        iconEnabledColor: AppColors.primary,
                        style: const TextStyle(color: AppColors.textPrimary),
                        onChanged: (val) => setState(() => _role = val!),
                        items: AccountRole.values
                            .map((e) => DropdownMenuItem(
                                value: e, child: Text(e.name.capitalize())))
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            icon: Icon(
                              _editingAccount == null
                                  ? Icons.add
                                  : Icons.update,
                              color: AppColors.buttonText,
                              size: 18,
                            ),
                            label: Text(
                              _editingAccount == null ? 'Add' : 'Update',
                              style:
                                  const TextStyle(color: AppColors.buttonText),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _submitForm,
                          ),
                          if (_editingAccount != null)
                            TextButton(
                              onPressed: _resetForm,
                              child: const Text('Cancel',
                                  style: TextStyle(
                                      color: AppColors.textSecondary)),
                            ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: accounts.isEmpty
                    ? const Center(
                        child: Text('No accounts added yet.',
                            style: TextStyle(color: AppColors.textSecondary)),
                      )
                    : ListView.separated(
                        itemCount: accounts.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, index) {
                          final acc = accounts[index];
                          final isEditing = _editingAccount?.id == acc.id;

                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                )
                              ],
                              border: isEditing
                                  ? Border.all(
                                      color: AppColors.primary, width: 2)
                                  : null,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(acc.name,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.cardText)),
                                    Text(acc.type,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondary)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text('₹${acc.balance.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.secondary)),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Chip(
                                      backgroundColor: AppColors.chip,
                                      label: Text(
                                        acc.role.name.toUpperCase(),
                                        style: const TextStyle(
                                            color: AppColors.textPrimary,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit,
                                              color: AppColors.primary),
                                          onPressed: () {
                                            setState(() {
                                              _editingAccount = acc;
                                              _nameController.text = acc.name;
                                              _balanceController.text =
                                                  acc.balance.toString();
                                              _type = acc.type;
                                              _role = acc.role;
                                            });
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: AppColors.delete),
                                          onPressed: () => showDialog(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                              backgroundColor: AppColors.card,
                                              title: const Text(
                                                  'Delete Account?',
                                                  style: TextStyle(
                                                      color: AppColors
                                                          .textPrimary)),
                                              content: const Text(
                                                  'Are you sure you want to delete this account?',
                                                  style: TextStyle(
                                                      color: AppColors
                                                          .textSecondary)),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: const Text('Cancel',
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .textSecondary)),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    ref
                                                        .read(accountsProvider
                                                            .notifier)
                                                        .deleteAccount(acc.id);
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Delete',
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .delete)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.textSecondary),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.textSecondary),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.primary),
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: AppColors.background.withOpacity(0.05),
    );
  }
}

extension on String {
  String capitalize() =>
      isEmpty ? this : this[0].toUpperCase() + substring(1).toLowerCase();
}
