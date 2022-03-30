const String tableExpenseCategory = 'expense_category';

class ExpenseCategoryFields {
  static const String id = '_id';
  static const String expense = 'expense';
}

class ExpenseCategoryModel {
  final int? id;
  final String expense;
  ExpenseCategoryModel({
    this.id,
    required this.expense,
  });

  Map<String, Object?> toJson() => {
        ExpenseCategoryFields.id: id,
        ExpenseCategoryFields.expense: expense,
      };

  static ExpenseCategoryModel fromJson(Map<String, Object?> json) =>
      ExpenseCategoryModel(
        id: json[ExpenseCategoryFields.id] as int,
        expense: json[ExpenseCategoryFields.expense] as String,
      );

  String get() {
    return expense;
  }
}
