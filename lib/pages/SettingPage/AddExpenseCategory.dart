import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../model/category_model.dart';

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
        const SnackBar(content: Text('Category name cannot be empty')),
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
    } else {
      await box.putAt(widget.index!, newCategory);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.category != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Expense Category' : 'Add Expense Category'),
        backgroundColor: Colors.grey[700],
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[600],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _categoryController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Category Name',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _subCategoryController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Subcategories (comma separated)',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveCategory,
              child: Text(isEdit ? 'Update' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }
}
