// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import '../../model/category_model.dart';

// class AddExpenseCategory extends StatefulWidget {
//   final ExpenseCategory? category; // If null => Add mode, else Edit mode
//   final int? index; // Needed for edit mode to update box at index

//   const AddExpenseCategory({super.key, this.category, this.index});

//   @override
//   State<AddExpenseCategory> createState() => _AddExpenseCategoryState();
// }

// class _AddExpenseCategoryState extends State<AddExpenseCategory> {
//   final TextEditingController _categoryController = TextEditingController();
//   final TextEditingController _subCategoryController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     if (widget.category != null) {
//       _categoryController.text = widget.category!.expenseCategoryName;
//       _subCategoryController.text =
//           widget.category!.subExpenseCategory.join(", ");
//     }
//   }

//   Future<void> _saveCategory() async {
//     final name = _categoryController.text.trim();
//     final subcategories = _subCategoryController.text
//         .split(',')
//         .map((e) => e.trim())
//         .where((e) => e.isNotEmpty)
//         .toList();

//     if (name.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Category name cannot be empty')),
//       );
//       return;
//     }

//     final newCategory = ExpenseCategory(
//       expenseCategoryName: name,
//       subExpenseCategory: subcategories,
//     );

//     final box = await Hive.openBox<ExpenseCategory>('expense_categories');

//     if (widget.category == null) {
//       await box.add(newCategory);
//     } else {
//       await box.putAt(widget.index!, newCategory);
//     }

//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isEdit = widget.category != null;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(isEdit ? 'Edit Expense Category' : 'Add Expense Category'),
//         backgroundColor: Colors.grey[700],
//         foregroundColor: Colors.white,
//       ),
//       backgroundColor: Colors.grey[600],
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _categoryController,
//               style: const TextStyle(color: Colors.white),
//               decoration: const InputDecoration(
//                 labelText: 'Category Name',
//                 labelStyle: TextStyle(color: Colors.white),
//                 enabledBorder: UnderlineInputBorder(
//                   borderSide: BorderSide(color: Colors.white),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _subCategoryController,
//               style: const TextStyle(color: Colors.white),
//               decoration: const InputDecoration(
//                 labelText: 'Subcategories (comma separated)',
//                 labelStyle: TextStyle(color: Colors.white),
//                 enabledBorder: UnderlineInputBorder(
//                   borderSide: BorderSide(color: Colors.white),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: _saveCategory,
//               child: Text(isEdit ? 'Update' : 'Save'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../model/category_model.dart';
import '../../extras/AppColors.dart'; // Import your AppColors

class AddExpenseCategory extends StatefulWidget {
  final ExpenseCategory? category; // If null => Add mode, else Edit mode
  final int? index; // Needed for edit mode to update box at index

  const AddExpenseCategory({super.key, this.category, this.index});

  @override
  State<AddExpenseCategory> createState() => _AddExpenseCategoryState();
}

class _AddExpenseCategoryState extends State<AddExpenseCategory> {
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _subCategoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _categoryController.text = widget.category!.expenseCategoryName;
      _subCategoryController.text =
          widget.category!.subExpenseCategory.join(", ");
    }
  }

  Future<void> _saveCategory() async {
    final name = _categoryController.text.trim();
    final subcategories = _subCategoryController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Category name cannot be empty',
              style: TextStyle(color: AppColors.buttonText)),
          backgroundColor:
              AppColors.error, // Use AppColors.error for validation feedback
        ),
      );
      return;
    }

    final newCategory = ExpenseCategory(
      expenseCategoryName: name,
      subExpenseCategory: subcategories,
    );

    final box = await Hive.openBox<ExpenseCategory>('expense_categories');

    if (widget.category == null) {
      await box.add(newCategory);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Expense category "$name" added!',
              style: TextStyle(color: AppColors.buttonText)),
          backgroundColor:
              AppColors.success, // Use AppColors.success for success feedback
        ),
      );
    } else {
      await box.putAt(widget.index!, newCategory);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Expense category "$name" updated!',
              style: TextStyle(color: AppColors.buttonText)),
          backgroundColor: AppColors.success, // Use AppColors.success
        ),
      );
    }

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _subCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.category != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Expense Category' : 'Add Expense Category',
          style: const TextStyle(
            fontWeight: FontWeight.bold, // Make AppBar title bold
          ),
        ),
        backgroundColor: AppColors.background, // Use AppColors.background
        foregroundColor: AppColors.textPrimary, // Use AppColors.textPrimary
      ),
      backgroundColor: AppColors.background, // Use AppColors.background
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _categoryController,
              style: const TextStyle(
                  color: AppColors.textPrimary), // Use AppColors.textPrimary
              decoration: InputDecoration(
                labelText: 'Category Name',
                labelStyle: const TextStyle(
                    color: AppColors
                        .textSecondary), // Use AppColors.textSecondary for label
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: AppColors.border), // Use AppColors.border
                ),
                focusedBorder: const UnderlineInputBorder(
                  // Add focused border for better UX
                  borderSide: BorderSide(
                      color: AppColors.primary,
                      width: 2.0), // Use AppColors.primary
                ),
                hintStyle: const TextStyle(
                    color: AppColors.textSecondary), // Hint text style
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _subCategoryController,
              style: const TextStyle(
                  color: AppColors.textPrimary), // Use AppColors.textPrimary
              decoration: InputDecoration(
                labelText: 'Subcategories (comma separated)',
                labelStyle: const TextStyle(
                    color: AppColors
                        .textSecondary), // Use AppColors.textSecondary for label
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: AppColors.border), // Use AppColors.border
                ),
                focusedBorder: const UnderlineInputBorder(
                  // Add focused border
                  borderSide: BorderSide(
                      color: AppColors.primary,
                      width: 2.0), // Use AppColors.primary
                ),
                hintStyle: const TextStyle(
                    color: AppColors.textSecondary), // Hint text style
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveCategory,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary, // Use AppColors.primary
                foregroundColor: AppColors
                    .buttonText, // Use AppColors.buttonText for text color
                minimumSize:
                    const Size(double.infinity, 50), // Make button full width
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      10), // Rounded corners for the button
                ),
              ),
              child: Text(
                isEdit ? 'Update' : 'Save',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
