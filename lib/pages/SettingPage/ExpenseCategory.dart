// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:notegoexpense/pages/SettingPage/AddExpenseCategory.dart';
// import '../../model/category_model.dart';

// class Expensecategory extends StatefulWidget {
//   const Expensecategory({super.key});

//   @override
//   State<Expensecategory> createState() => _ExpensecategoryState();
// }

// class _ExpensecategoryState extends State<Expensecategory> {
//   late Future<Box<ExpenseCategory>> _boxFuture;

//   final Set<String> confirmDeleteCategoryIds = {};
//   final Set<String> confirmDeleteSubIds = {};
//   final Map<String, bool> expandedStates = {};

//   @override
//   void initState() {
//     super.initState();
//     _boxFuture = Hive.openBox<ExpenseCategory>('expense_categories');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: _boxFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Scaffold(
//             backgroundColor: Colors.black,
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }

//         if (snapshot.hasError) {
//           return Scaffold(
//             body: Center(child: Text('Error: \${snapshot.error}')),
//           );
//         }

//         final box = snapshot.data!;
//         return Scaffold(
//           appBar: AppBar(
//             title: const Text('Expense Categories'),
//             backgroundColor: Colors.grey[700],
//             foregroundColor: Colors.white,
//             actions: [
//               IconButton(
//                 icon: const Icon(Icons.add),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => AddExpenseCategory(),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//           backgroundColor: Colors.grey[600],
//           body: ValueListenableBuilder(
//             valueListenable: box.listenable(),
//             builder: (context, Box<ExpenseCategory> box, _) {
//               if (box.values.isEmpty) {
//                 return const Center(
//                   child: Text(
//                     'No categories added yet',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 );
//               }

//               return ListView.builder(
//                 itemCount: box.length,
//                 itemBuilder: (context, index) {
//                   final category = box.getAt(index)!;
//                   final name = category.expenseCategoryName;
//                   final isExpanded = expandedStates[name] ?? false;
//                   final isConfirmingDelete =
//                       confirmDeleteCategoryIds.contains(name);
//                   return Column(
//                     children: [
//                       columnTile(
//                         tileName: name,
//                         subCategoryCount: category.subExpenseCategory.length,
//                         isConfirmingDelete: isConfirmingDelete,
//                         onDeleteTap: () {
//                           setState(() {
//                             if (isConfirmingDelete) {
//                               confirmDeleteCategoryIds.remove(name);
//                             } else {
//                               confirmDeleteCategoryIds.add(name);
//                             }
//                           });
//                         },
//                         onConfirmDelete: () {
//                           box.deleteAt(index);
//                           setState(() {
//                             confirmDeleteCategoryIds.remove(name);
//                             expandedStates.remove(name);
//                           });
//                         },
//                         onTap: () {
//                           setState(() {
//                             expandedStates[name] = !isExpanded;
//                           });
//                         },
//                         onEdit: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => AddExpenseCategory(
//                                   category: category, index: index),
//                             ),
//                           );
//                         },
//                       ),
//                       if (isExpanded)
//                         ...category.subExpenseCategory.map((sub) {
//                           final subKey = '$name::$sub';
//                           final isSubConfirmingDelete =
//                               confirmDeleteSubIds.contains(subKey);

//                           return Padding(
//                             padding: const EdgeInsets.only(left: 24.0),
//                             child: columnTile(
//                               tileName: sub,
//                               isConfirmingDelete: isSubConfirmingDelete,
//                               onDeleteTap: () {
//                                 setState(() {
//                                   if (isSubConfirmingDelete) {
//                                     confirmDeleteSubIds.remove(subKey);
//                                   } else {
//                                     confirmDeleteSubIds.add(subKey);
//                                   }
//                                 });
//                               },
//                               onConfirmDelete: () {
//                                 setState(() {
//                                   category.subExpenseCategory.remove(sub);
//                                   category.save();
//                                   confirmDeleteSubIds.remove(subKey);
//                                 });
//                               },
//                               onEdit: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => AddExpenseCategory(
//                                         category: category, index: index),
//                                   ),
//                                 );
//                               },
//                             ),
//                           );
//                         }).toList(),
//                     ],
//                   );
//                 },
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }

// Widget columnTile({
//   required String tileName,
//   int? subCategoryCount,
//   required bool isConfirmingDelete,
//   required VoidCallback onDeleteTap,
//   required VoidCallback onConfirmDelete,
//   VoidCallback? onEdit,
//   VoidCallback? onTap,
// }) {
//   return InkWell(
//     onTap: onTap,
//     child: Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
//           child: Row(
//             children: [
//               IconButton(
//                 icon: AnimatedSwitcher(
//                   duration: const Duration(milliseconds: 300),
//                   child: Icon(
//                     isConfirmingDelete
//                         ? Icons.cancel
//                         : Icons.remove_circle_outline,
//                     key: ValueKey(isConfirmingDelete),
//                     color: Colors.red,
//                   ),
//                 ),
//                 onPressed: onDeleteTap,
//               ),
//               Expanded(
//                 child: AnimatedPadding(
//                   duration: const Duration(milliseconds: 300),
//                   padding: EdgeInsets.only(left: isConfirmingDelete ? 4 : 12),
//                   child: Text(
//                     subCategoryCount != null
//                         ? '$tileName ($subCategoryCount)'
//                         : tileName,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       color: Colors.white,
//                       fontWeight: FontWeight.w800,
//                     ),
//                   ),
//                 ),
//               ),
//               AnimatedSwitcher(
//                 duration: const Duration(milliseconds: 300),
//                 child: isConfirmingDelete
//                     ? Container(
//                         decoration: const BoxDecoration(
//                           color: Colors.red,
//                           shape: BoxShape.circle,
//                         ),
//                         child: IconButton(
//                           key: ValueKey('confirmDelete'),
//                           icon: const Icon(Icons.delete, color: Colors.white),
//                           onPressed: onConfirmDelete,
//                         ),
//                       )
//                     : IconButton(
//                         key: ValueKey('edit'),
//                         icon: const Icon(Icons.edit, color: Colors.white),
//                         onPressed: onEdit,
//                       ),
//               ),
//             ],
//           ),
//         ),
//         const Divider(
//           color: Colors.grey,
//           height: 1,
//           thickness: 0.5,
//         ),
//       ],
//     ),
//   );
// }

// Future<void> preloadDefaultExpenseCategories() async {
//   final box = await Hive.openBox<ExpenseCategory>('expense_categories');

//   // ✅ Only insert if the box is empty
//   if (box.isEmpty) {
//     final List<ExpenseCategory> defaultCategories = [
//       ExpenseCategory(
//         expenseCategoryName: 'Food',
//         subExpenseCategory: ['Lunch', 'Dinner', 'Snacks', 'Eating Out'],
//       ),
//       ExpenseCategory(
//         expenseCategoryName: 'Social Life',
//         subExpenseCategory: ['Parties', 'Clubbing', 'Bars', 'Events'],
//       ),
//       ExpenseCategory(
//         expenseCategoryName: 'Gifts',
//         subExpenseCategory: ['Birthday', 'Wedding', 'Festival'],
//       ),
//       ExpenseCategory(
//         expenseCategoryName: 'Household',
//         subExpenseCategory: ['Groceries', 'Cleaning', 'Appliances'],
//       ),
//       ExpenseCategory(
//         expenseCategoryName: 'Movies',
//         subExpenseCategory: ['Cinema', 'Streaming', 'Theatre'],
//       ),
//       ExpenseCategory(
//         expenseCategoryName: 'Transport',
//         subExpenseCategory: ['Bus', 'Train', 'Cab', 'Fuel'],
//       ),
//       ExpenseCategory(
//         expenseCategoryName: 'Shopping',
//         subExpenseCategory: ['Clothing', 'Electronics', 'Accessories'],
//       ),
//       ExpenseCategory(
//         expenseCategoryName: 'SIP',
//         subExpenseCategory: ['Mutual Funds', 'Recurring Investment'],
//       ),
//       ExpenseCategory(
//         expenseCategoryName: 'Stocks',
//         subExpenseCategory: ['Equity', 'ETF', 'Trading'],
//       ),
//       ExpenseCategory(
//         expenseCategoryName: 'Other',
//         subExpenseCategory: ['Miscellaneous'],
//       ),
//     ];

//     for (final category in defaultCategories) {
//       await box.add(category);
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notegoexpense/pages/SettingPage/AddExpenseCategory.dart';
import '../../model/category_model.dart';
import '../../extras/AppColors.dart'; // Ensure this path is correct

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
          return Scaffold(
            backgroundColor: AppColors.background, // Use AppColors
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: AppColors.background, // Use AppColors
            body: Center(
                child: Text('Error: ${snapshot.error}',
                    style: TextStyle(color: AppColors.error))), // Use AppColors
          );
        }

        final box = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Expense Categories',
              style: TextStyle(
                fontWeight:
                    FontWeight.bold, // Often desirable for AppBar titles
              ),
            ),
            backgroundColor: AppColors.background, // Use AppColors
            foregroundColor: AppColors.textPrimary, // Use AppColors
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                color: AppColors.textPrimary, // Ensure icon color is consistent
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddExpenseCategory(),
                    ),
                  );
                },
              ),
            ],
          ),
          backgroundColor: AppColors.background, // Use AppColors
          body: ValueListenableBuilder(
            valueListenable: box.listenable(),
            builder: (context, Box<ExpenseCategory> box, _) {
              if (box.values.isEmpty) {
                return Center(
                  child: Text(
                    'No categories added yet',
                    style: TextStyle(
                        color: AppColors.textSecondary), // Use AppColors
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
                      // Main Category Tile
                      _CategoryTile(
                        // Using helper widget
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddExpenseCategory(
                                  category: category, index: index),
                            ),
                          );
                        },
                        context:
                            context, // Pass context to the helper for theme access
                      ),
                      // Sub Categories
                      if (isExpanded)
                        ...category.subExpenseCategory.map((sub) {
                          final subKey = '$name::$sub';
                          final isSubConfirmingDelete =
                              confirmDeleteSubIds.contains(subKey);

                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 24.0), // Indent subcategories
                            child: _CategoryTile(
                              // Using helper widget for subcategories too
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
                                  // Create a modifiable copy of the list before removing
                                  final List<String> updatedSubCategories =
                                      List.from(category.subExpenseCategory);
                                  updatedSubCategories.remove(sub);
                                  category.subExpenseCategory =
                                      updatedSubCategories; // Assign the updated list
                                  category.save(); // Save changes to Hive
                                  confirmDeleteSubIds.remove(subKey);
                                });
                              },
                              onEdit: () {
                                // Handle subcategory edit (navigate to AddExpenseCategory for parent,
                                // but you might want a specific subcategory edit flow)
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddExpenseCategory(
                                        category: category, index: index),
                                  ),
                                );
                              },
                              context: context,
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

// Helper widget for category tiles (moved outside _ExpensecategoryState)
class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.tileName,
    this.subCategoryCount,
    required this.isConfirmingDelete,
    required this.onDeleteTap,
    required this.onConfirmDelete,
    this.onEdit,
    this.onTap,
    required this.context, // Received context
  });

  final String tileName;
  final int? subCategoryCount;
  final bool isConfirmingDelete;
  final VoidCallback onDeleteTap;
  final VoidCallback onConfirmDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onTap;
  final BuildContext context; // Pass context to the helper for theme access

  @override
  Widget build(BuildContext context) {
    // Local context is good for this build method
    return InkWell(
      onTap: onTap,
      child: Container(
        color: AppColors.card, // Use AppColors.card for tile background
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
                        color: AppColors.delete, // Use AppColors.delete
                      ),
                    ),
                    onPressed: onDeleteTap,
                  ),
                  Expanded(
                    child: AnimatedPadding(
                      duration: const Duration(milliseconds: 300),
                      padding:
                          EdgeInsets.only(left: isConfirmingDelete ? 4 : 12),
                      child: Text(
                        // Only show count if it's a main category and has subcategories
                        subCategoryCount != null && subCategoryCount! > 0
                            ? '$tileName ($subCategoryCount)'
                            : tileName,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors
                              .textPrimary, // Use AppColors.textPrimary
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
                              color: AppColors.delete, // Use AppColors.delete
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              key: const ValueKey('confirmDelete'),
                              icon: const Icon(Icons.delete,
                                  color: AppColors
                                      .buttonText), // Use AppColors.buttonText
                              onPressed: onConfirmDelete,
                            ),
                          )
                        : (onEdit !=
                                null // Only show edit if onPressed is provided
                            ? IconButton(
                                key: const ValueKey('edit'),
                                icon: const Icon(Icons.edit,
                                    color: AppColors
                                        .textPrimary), // Use AppColors.textPrimary
                                onPressed: onEdit,
                              )
                            : const SizedBox
                                .shrink()), // Hide if no edit action
                  ),
                ],
              ),
            ),
            const Divider(
              color: AppColors.border, // Use AppColors.border
              height: 1,
              thickness: 0.5,
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> preloadDefaultExpenseCategories() async {
  final box = await Hive.openBox<ExpenseCategory>('expense_categories');

  // Only insert if the box is empty
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
