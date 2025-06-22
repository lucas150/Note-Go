import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../model/category_model.dart';

class Expensecategory extends StatefulWidget {
  const Expensecategory({super.key});

  @override
  State<Expensecategory> createState() => _ExpensecategoryState();
}

class _ExpensecategoryState extends State<Expensecategory> {
  late Future<Box<ExpenseCategory>> _boxFuture;

  final Set<String> confirmDeleteCategoryIds = {};
  final Set<String> confirmDeleteSubIds = {};
  final Map<String, bool> expandedStates = {};

  @override
  void initState() {
    super.initState();
    _boxFuture = Hive.openBox<ExpenseCategory>('expense_categories');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _boxFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: \${snapshot.error}')),
          );
        }

        final box = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Expense Categories'),
            backgroundColor: Colors.grey[600],
            foregroundColor: Colors.white,
          ),
          backgroundColor: Colors.grey[900],
          body: ValueListenableBuilder(
            valueListenable: box.listenable(),
            builder: (context, Box<ExpenseCategory> box, _) {
              if (box.values.isEmpty) {
                return const Center(
                  child: Text(
                    'No categories added yet',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              return ListView.builder(
                itemCount: box.length,
                itemBuilder: (context, index) {
                  final category = box.getAt(index)!;
                  final name = category.expenseCategoryName;
                  final isExpanded = expandedStates[name] ?? false;
                  final isConfirmingDelete =
                      confirmDeleteCategoryIds.contains(name);

                  return Column(
                    children: [
                      columnTile(
                        tileName: name,
                        subCategoryCount: category.subExpenseCategory.length,
                        isConfirmingDelete: isConfirmingDelete,
                        onDeleteTap: () {
                          setState(() {
                            if (isConfirmingDelete) {
                              confirmDeleteCategoryIds.remove(name);
                            } else {
                              confirmDeleteCategoryIds.add(name);
                            }
                          });
                        },
                        onConfirmDelete: () {
                          box.deleteAt(index);
                          setState(() {
                            confirmDeleteCategoryIds.remove(name);
                            expandedStates.remove(name);
                          });
                        },
                        onTap: () {
                          setState(() {
                            expandedStates[name] = !isExpanded;
                          });
                        },
                        onEdit: () {
                          // Handle category edit
                        },
                      ),
                      if (isExpanded)
                        ...category.subExpenseCategory.map((sub) {
                          final subKey =
                              '$name::$sub'; // ✅ Correct string interpolation
                          final isSubConfirmingDelete =
                              confirmDeleteSubIds.contains(subKey);

                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 24.0), // ✅ Subcategory indentation
                            child: columnTile(
                              tileName: sub,
                              isConfirmingDelete: isSubConfirmingDelete,
                              onDeleteTap: () {
                                setState(() {
                                  if (isSubConfirmingDelete) {
                                    confirmDeleteSubIds.remove(subKey);
                                  } else {
                                    confirmDeleteSubIds.add(subKey);
                                  }
                                });
                              },
                              onConfirmDelete: () {
                                setState(() {
                                  category.subExpenseCategory.remove(sub);
                                  category.save();
                                  confirmDeleteSubIds.remove(subKey);
                                });
                              },
                              onEdit: () {
                                // Handle subcategory edit
                              },
                            ),
                          );
                        }).toList(),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

Widget columnTile({
  required String tileName,
  int? subCategoryCount,
  required bool isConfirmingDelete,
  required VoidCallback onDeleteTap,
  required VoidCallback onConfirmDelete,
  VoidCallback? onEdit,
  VoidCallback? onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        children: [
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                isConfirmingDelete ? Icons.cancel : Icons.remove_circle_outline,
                key: ValueKey(isConfirmingDelete),
                color: Colors.red,
              ),
            ),
            onPressed: onDeleteTap,
          ),
          Expanded(
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.only(left: isConfirmingDelete ? 4 : 12),
              child: Text(
                subCategoryCount != null
                    ? '$tileName ($subCategoryCount)'
                    : tileName,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.yellow,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: isConfirmingDelete
                ? IconButton(
                    key: const ValueKey('confirmDelete'),
                    icon: const Icon(Icons.delete, color: Colors.white),
                    onPressed: onConfirmDelete,
                  )
                : IconButton(
                    key: const ValueKey('edit'),
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: onEdit,
                  ),
          ),
        ],
      ),
    ),
  );
}

Future<void> preloadDefaultExpenseCategories() async {
  final box = await Hive.openBox<ExpenseCategory>('expense_categories');

  // ✅ Only insert if the box is empty
  if (box.isEmpty) {
    final List<ExpenseCategory> defaultCategories = [
      ExpenseCategory(
        expenseCategoryName: 'Food',
        subExpenseCategory: ['Lunch', 'Dinner', 'Snacks', 'Eating Out'],
      ),
      ExpenseCategory(
        expenseCategoryName: 'Social Life',
        subExpenseCategory: ['Parties', 'Clubbing', 'Bars', 'Events'],
      ),
      ExpenseCategory(
        expenseCategoryName: 'Gifts',
        subExpenseCategory: ['Birthday', 'Wedding', 'Festival'],
      ),
      ExpenseCategory(
        expenseCategoryName: 'Household',
        subExpenseCategory: ['Groceries', 'Cleaning', 'Appliances'],
      ),
      ExpenseCategory(
        expenseCategoryName: 'Movies',
        subExpenseCategory: ['Cinema', 'Streaming', 'Theatre'],
      ),
      ExpenseCategory(
        expenseCategoryName: 'Transport',
        subExpenseCategory: ['Bus', 'Train', 'Cab', 'Fuel'],
      ),
      ExpenseCategory(
        expenseCategoryName: 'Shopping',
        subExpenseCategory: ['Clothing', 'Electronics', 'Accessories'],
      ),
      ExpenseCategory(
        expenseCategoryName: 'SIP',
        subExpenseCategory: ['Mutual Funds', 'Recurring Investment'],
      ),
      ExpenseCategory(
        expenseCategoryName: 'Stocks',
        subExpenseCategory: ['Equity', 'ETF', 'Trading'],
      ),
      ExpenseCategory(
        expenseCategoryName: 'Other',
        subExpenseCategory: ['Miscellaneous'],
      ),
    ];

    for (final category in defaultCategories) {
      await box.add(category);
    }
  }
}
