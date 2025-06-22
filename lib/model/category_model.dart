import 'package:hive/hive.dart';

part 'category_model.g.dart';

@HiveType(typeId: 4)
class ExpenseCategory extends HiveObject {
  @HiveField(0)
  String expenseCategoryName;

  @HiveField(1)
  List<String> subExpenseCategory;

  ExpenseCategory(
      {required this.expenseCategoryName, this.subExpenseCategory = const []});
}


