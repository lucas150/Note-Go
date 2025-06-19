import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../model/transaction_model.dart';
import '../model/account_notifier.dart';

// Account management page for adding, editing, and deleting accounts
class AccountManagementPage extends ConsumerStatefulWidget {
  const AccountManagementPage({super.key});

  @override
  ConsumerState<AccountManagementPage> createState() =>
      _AccountManagementPageState();
}

// State for the AccountManagementPage
class _AccountManagementPageState extends ConsumerState<AccountManagementPage> {
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  String _type = 'Bank';
  AccountRole _role = AccountRole.transaction;
  Account? _editingAccount;

// Reset the form fields and state
  void _resetForm() {
    _nameController.clear();
    _balanceController.clear();
    _type = 'Bank';
    _role = AccountRole.transaction;
    _editingAccount = null;
    setState(() {});
  }

// Submit the form to add or update an account
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

// If editing, update the existing account; otherwise, add a new one
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('Account Manager')),
      body: accountsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (accounts) => Column(
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _editingAccount == null
                            ? 'Add Account'
                            : 'Edit Account',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _nameController,
                        decoration:
                            const InputDecoration(labelText: 'Account Name'),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _balanceController,
                        decoration: const InputDecoration(labelText: 'Balance'),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _type,
                        decoration: const InputDecoration(labelText: 'Type'),
                        onChanged: (val) => setState(() => _type = val!),
                        items: ['Bank', 'Wallet', 'Cash', 'UPI', 'Credit Card']
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<AccountRole>(
                        value: _role,
                        decoration: const InputDecoration(labelText: 'Role'),
                        onChanged: (val) => setState(() => _role = val!),
                        items: AccountRole.values
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.name.capitalize()),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: _submitForm,
                            child: Text(
                                _editingAccount == null ? 'Add' : 'Update'),
                          ),
                          const SizedBox(width: 8),
                          if (_editingAccount != null)
                            TextButton(
                              onPressed: _resetForm,
                              child: const Text('Cancel'),
                            )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            const Divider(thickness: 1),
            Expanded(
              flex: 6,
              child: accounts.isEmpty
                  ? const Center(
                      child: Text(
                        'No accounts added yet.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      itemCount: accounts.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, index) {
                        final acc = accounts[index];
                        final isEditing = _editingAccount?.id == acc.id;

                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color:
                                isEditing ? Colors.blue.shade50 : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    acc.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      acc.type,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Balance
                              Text(
                                '₹${acc.balance.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),

                              const SizedBox(height: 8),

                              // Role badge and actions
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Chip(
                                    backgroundColor: Colors.grey.shade100,
                                    label: Text(
                                      acc.role.name.toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blueAccent),
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
                                            color: Colors.redAccent),
                                        onPressed: () => ref
                                            .read(accountsProvider.notifier)
                                            .deleteAccount(acc.id),
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
    );
  }
}

extension on String {
  String capitalize() =>
      isEmpty ? this : this[0].toUpperCase() + substring(1).toLowerCase();
}
