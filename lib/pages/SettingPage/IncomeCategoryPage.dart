import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notegoexpense/pages/SettingPage/AddIncomeCategory.dart';
import '../../model/category_model.dart';

class IncomeCategoryPage extends StatefulWidget {
  const IncomeCategoryPage({super.key});

  @override
  State<IncomeCategoryPage> createState() => _IncomeCategoryPageState();
}

class _IncomeCategoryPageState extends State<IncomeCategoryPage> {
  late Future<Box<IncomeCategory>> _boxFuture;

  final Set<String> confirmDeleteCategoryIds = {};
  final Set<String> confirmDeleteSubIds = {};
  final Map<String, bool> expandedStates = {};

  @override
  void initState() {
    super.initState();
    _boxFuture = Hive.openBox<IncomeCategory>('income_categories');
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
            title: const Text('Income Categories'),
            backgroundColor: Colors.grey[700],
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddIncomeCategory()),
                  );
                },
              ),
            ],
          ),
          backgroundColor: Colors.grey[600],
          body: ValueListenableBuilder(
            valueListenable: box.listenable(),
            builder: (context, Box<IncomeCategory> box, _) {
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
                  final name = category.incomeCategoryName;
                  final isExpanded = expandedStates[name] ?? false;
                  final isConfirmingDelete =
                      confirmDeleteCategoryIds.contains(name);
                  return Column(
                    children: [
                      columnTile(
                        tileName: name,
                        subCategoryCount: category.subIncomeCategory.length,
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddIncomeCategory(
                                  category: category, index: index),
                            ),
                          );
                        },
                      ),
                      if (isExpanded)
                        ...category.subIncomeCategory.map((sub) {
                          final subKey = '$name::$sub';
                          final isSubConfirmingDelete =
                              confirmDeleteSubIds.contains(subKey);

                          return Padding(
                            padding: const EdgeInsets.only(left: 24.0),
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
                                  category.subIncomeCategory.remove(sub);
                                  category.save();
                                  confirmDeleteSubIds.remove(subKey);
                                });
                              },
                              onEdit: () {
                                // Handle subcategory edit
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddIncomeCategory(
                                        category: category, index: index),
                                  ),
                                );
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
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Row(
            children: [
              IconButton(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    isConfirmingDelete
                        ? Icons.cancel
                        : Icons.remove_circle_outline,
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
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: isConfirmingDelete
                    ? Container(
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          key: ValueKey('confirmDelete'),
                          icon: const Icon(Icons.delete, color: Colors.white),
                          onPressed: onConfirmDelete,
                        ),
                      )
                    : IconButton(
                        key: ValueKey('edit'),
                        icon: const Icon(Icons.edit, color: Colors.white),
                        onPressed: onEdit,
                      ),
              ),
            ],
          ),
        ),
        const Divider(
          color: Colors.grey,
          height: 1,
          thickness: 0.5,
        ),
      ],
    ),
  );
}
// import '../../model/category_model.dart' as model;
// import 'package:hive/hive.dart';

Future<void> preloadDefaultIncomeCategories() async {
  final box = await Hive.openBox<IncomeCategory>('income_categories');

  if (box.isEmpty) {
    final List<IncomeCategory> defaultCategories = [
      IncomeCategory(
        incomeCategoryName: 'Salary',
        subIncomeCategory: ['Base Pay', 'Bonus', 'Incentives'],
      ),
      IncomeCategory(
        incomeCategoryName: 'Freelance',
        subIncomeCategory: ['Projects', 'Consulting'],
      ),
      IncomeCategory(
        incomeCategoryName: 'Investments',
        subIncomeCategory: ['Dividends', 'Interest', 'Other Income'],
      ),
      IncomeCategory(
        incomeCategoryName: 'Gifts',
        subIncomeCategory: ['Cash Gifts', 'Other Gifts'],
      ),
      IncomeCategory(
        incomeCategoryName: 'Other',
        subIncomeCategory: ['Miscellaneous'],
      ),
    ];

    for (final category in defaultCategories) {
      await box.add(category);
    }
  }
}
