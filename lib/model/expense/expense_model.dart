const String tableExpense = 'expense';

class ExpenseFields {
  static const String id = '_id';
  static const String expenseCategory = 'expenseCategory';
  static const String expenseTitle = 'expenseTitle';
  static const String paidBy = 'paidBy';
  static const String date = 'date';
  static const String note = 'note';
  static const String voucherNumber = 'voucherNumber';
  static const String documents = 'documents';
}

class ExpenseModel {
  final int? id;
  final String expenseCategory;
  final String expenseTitle;
  final String paidBy;
  final String date;
  final String? note;
  final String? voucherNumber;
  final String? documents;

  ExpenseModel({
    this.id,
    required this.expenseCategory,
    required this.expenseTitle,
    required this.paidBy,
    required this.date,
    required this.note,
    required this.voucherNumber,
    required this.documents,
  });

  Map<String, Object?> toJson() => {
        ExpenseFields.id: id,
        ExpenseFields.expenseCategory: expenseCategory,
        ExpenseFields.expenseTitle: expenseTitle,
        ExpenseFields.paidBy: paidBy,
        ExpenseFields.date: date,
        ExpenseFields.note: note,
        ExpenseFields.voucherNumber: voucherNumber,
        ExpenseFields.documents: documents,
      };

  static ExpenseModel fromJson(Map<String, Object?> json) => ExpenseModel(
        id: json[ExpenseFields.id] as int,
        expenseCategory: json[ExpenseFields.expenseCategory] as String,
        expenseTitle: json[ExpenseFields.expenseTitle] as String,
        paidBy: json[ExpenseFields.paidBy] as String,
        date: json[ExpenseFields.date] as String,
        note: json[ExpenseFields.note] as String,
        voucherNumber: json[ExpenseFields.voucherNumber] as String,
        documents: json[ExpenseFields.documents] as String,
      );
}
