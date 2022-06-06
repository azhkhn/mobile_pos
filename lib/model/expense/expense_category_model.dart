import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense_category_model.freezed.dart';
part 'expense_category_model.g.dart';

const String tableExpenseCategory = 'expense_category';

class ExpenseCategoryFields {
  static const String id = '_id';
  static const String expense = 'expense';
}

@freezed
class ExpenseCategoryModel with _$ExpenseCategoryModel {
  const ExpenseCategoryModel._();
  const factory ExpenseCategoryModel({
    @JsonKey(name: '_id') int? id,
    required String expense,
  }) = _ExpenseCategoryModel;

  factory ExpenseCategoryModel.fromJson(Map<String, dynamic> json) => _$ExpenseCategoryModelFromJson(json);

  String get() {
    return expense;
  }
}


// class ExpenseCategoryModel {
//   final int? id;
//   final String expense;
//   ExpenseCategoryModel({
//     this.id,
//     required this.expense,
//   });

//   Map<String, Object?> toJson() => {
//         ExpenseCategoryFields.id: id,
//         ExpenseCategoryFields.expense: expense,
//       };

//   static ExpenseCategoryModel fromJson(Map<String, Object?> json) =>
//       ExpenseCategoryModel(
//         id: json[ExpenseCategoryFields.id] as int,
//         expense: json[ExpenseCategoryFields.expense] as String,
//       );

//   String get() {
//     return expense;
//   }
// }
