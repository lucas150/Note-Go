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
  Set<String> confirmDeleteIds = {};

  @override
  void initState() {
    super.initState();
    _boxFuture = Hive.openBox<ExpenseCategory>('expense_categories');
  }

  void toggleConfirmDelete(String key) {
    setState(() {
      if (confirmDeleteIds.contains(key)) {
        confirmDeleteIds.remove(key);
      } else {
        confirmDeleteIds.add(key);
      }
    });
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
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        final box = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Expense Category'),
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

                  return StatefulBuilder(
                    builder: (context, setTileState) {
                      bool isExpanded = false;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          columnTile(
                            tileName: category.expenseCategoryName,
                            subCategoryCount:
                                category.subExpenseCategory.length,
                            isConfirmingDelete: confirmDeleteIds
                                .contains(category.expenseCategoryName),
                            onTap: () {
                              setTileState(() => isExpanded = !isExpanded);
                            },
                            onEdit: () {
                              // Edit logic here
                            },
                            onDeleteTap: () {
                              final name = category.expenseCategoryName;
                              if (confirmDeleteIds.contains(name)) {
                                box.deleteAt(index);
                                confirmDeleteIds.remove(name);
                              } else {
                                toggleConfirmDelete(name);
                              }
                            },
                          ),
                          if (isExpanded)
                            Padding(
                              padding: const EdgeInsets.only(left: 32.0),
                              child: Column(
                                children: category.subExpenseCategory
                                    .map((sub) => columnTile(
                                          tileName: sub,
                                          isConfirmingDelete: false,
                                          onEdit: () {
                                            // Edit subcategory
                                          },
                                          onDeleteTap: () {
                                            category.subExpenseCategory
                                                .remove(sub);
                                            category.save();
                                            setState(() {});
                                          },
                                          onTap: () {},
                                        ))
                                    .toList(),
                              ),
                            ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget columnTile({
    required String tileName,
    int? subCategoryCount,
    required bool isConfirmingDelete,
    required VoidCallback onDeleteTap,
    required VoidCallback onEdit,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            IconButton(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: isConfirmingDelete
                    ? const Icon(Icons.delete_forever,
                        key: ValueKey('confirm'), color: Colors.red)
                    : const Icon(Icons.remove_circle_outline,
                        key: ValueKey('ask'), color: Colors.red),
              ),
              onPressed: onDeleteTap,
            ),
            Expanded(
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
            if (!isConfirmingDelete)
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: onEdit,
              ),
          ],
        ),
      ),
    );
  }
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
