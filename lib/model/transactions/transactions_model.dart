const String tableTransactions = 'transactions';

class TransactionsField {
  static const id = '_id';
  static const category = 'category';
  static const transactionType = 'transactionType';
  static const dateTime = 'dateTime';
  static const amount = 'amount';
  static const status = 'status';
  static const description = 'description';
  static const salesId = 'salesId';
  static const purchaseId = 'purchaseId';
}

class TransactionsModel {
  int? id;
  final int? salesId, purchaseId;
  final String category, transactionType, dateTime, amount, status, description;

  TransactionsModel({
    this.id,
    required this.category,
    required this.transactionType,
    required this.dateTime,
    required this.amount,
    required this.status,
    required this.description,
    this.salesId,
    this.purchaseId,
  });

  Map<String, Object?> toJson() => {
        TransactionsField.id: id,
        TransactionsField.category: category,
        TransactionsField.transactionType: transactionType,
        TransactionsField.dateTime: dateTime,
        TransactionsField.amount: amount,
        TransactionsField.status: status,
        TransactionsField.description: description,
        TransactionsField.salesId: salesId,
        TransactionsField.purchaseId: purchaseId,
      };

  static TransactionsModel fromJson(Map<String, Object?> json) =>
      TransactionsModel(
        id: json[TransactionsField.id] as int,
        category: json[TransactionsField.category] as String,
        transactionType: json[TransactionsField.transactionType] as String,
        dateTime: json[TransactionsField.dateTime] as String,
        amount: json[TransactionsField.amount] as String,
        status: json[TransactionsField.status] as String,
        description: json[TransactionsField.description] as String,
        salesId: json[TransactionsField.salesId] as int,
        purchaseId: json[TransactionsField.purchaseId] as int,
      );
}
