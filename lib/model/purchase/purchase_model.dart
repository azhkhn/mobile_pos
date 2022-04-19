const String tablePurchase = 'purchase';

class PurchaseFields {
  static const id = '_id';
  static const invoiceNumber = 'invoiceNumber';
  static const purchaseNote = 'purchaseNote';
  static const dateTime = 'dateTime';
  static const supplierId = 'supplierId';
  static const supplierName = 'supplierName';
  static const billerName = 'billerName';
  static const totalItems = 'totalItems';
  static const vatAmount = 'vatAmount';
  static const subTotal = 'subTotal';
  static const discount = 'discount';
  static const grantTotal = 'grantTotal';
  static const paid = 'paid';
  static const balance = 'balance';
  static const paymentType = 'paymentType';
  static const purchaseStatus = 'purchaseStatus';
  static const paymentStatus = 'paymentStatus';
  static const createdBy = 'createdBy';
}

class PurchaseModel {
  int? id;
  String? invoiceNumber;
  final int supplierId;
  final String dateTime,
      supplierName,
      billerName,
      purchaseNote,
      totalItems,
      vatAmount,
      subTotal,
      discount,
      grantTotal,
      paid,
      balance,
      paymentType,
      purchaseStatus,
      paymentStatus,
      createdBy;

  PurchaseModel({
    this.id,
    this.invoiceNumber,
    required this.dateTime,
    required this.supplierId,
    required this.supplierName,
    required this.billerName,
    required this.purchaseNote,
    required this.totalItems,
    required this.vatAmount,
    required this.subTotal,
    required this.discount,
    required this.grantTotal,
    required this.paid,
    required this.balance,
    required this.paymentType,
    required this.purchaseStatus,
    required this.paymentStatus,
    required this.createdBy,
  });

  PurchaseModel copyWith({
    int? id,
    String? invoiceNumber,
    dateTime,
    supplierId,
    supplierName,
    billerName,
    purchaseNote,
    totalItems,
    vatAmount,
    subTotal,
    discount,
    grantTotal,
    paid,
    balance,
    paymentType,
    purchaseStatus,
    paymentStatus,
    createdBy,
  }) =>
      PurchaseModel(
        id: id ?? this.id,
        invoiceNumber: invoiceNumber ?? this.invoiceNumber,
        dateTime: dateTime ?? this.dateTime,
        supplierId: supplierId ?? this.supplierId,
        supplierName: supplierName ?? this.supplierName,
        billerName: billerName ?? this.billerName,
        purchaseNote: purchaseNote ?? this.purchaseNote,
        totalItems: totalItems ?? this.totalItems,
        vatAmount: vatAmount ?? this.vatAmount,
        subTotal: subTotal ?? this.subTotal,
        discount: discount ?? this.discount,
        grantTotal: grantTotal ?? this.grantTotal,
        paid: paid ?? this.paid,
        balance: balance ?? this.balance,
        paymentType: paymentType ?? this.paymentType,
        purchaseStatus: purchaseStatus ?? this.purchaseStatus,
        paymentStatus: paymentStatus ?? this.paymentStatus,
        createdBy: createdBy ?? this.createdBy,
      );

  Map<String, Object?> toJson() => {
        PurchaseFields.id: id,
        PurchaseFields.invoiceNumber: invoiceNumber,
        PurchaseFields.dateTime: dateTime,
        PurchaseFields.supplierId: supplierId,
        PurchaseFields.supplierName: supplierName,
        PurchaseFields.billerName: billerName,
        PurchaseFields.purchaseNote: purchaseNote,
        PurchaseFields.totalItems: totalItems,
        PurchaseFields.vatAmount: vatAmount,
        PurchaseFields.subTotal: subTotal,
        PurchaseFields.discount: discount,
        PurchaseFields.grantTotal: grantTotal,
        PurchaseFields.paid: paid,
        PurchaseFields.balance: balance,
        PurchaseFields.paymentType: paymentType,
        PurchaseFields.purchaseStatus: purchaseStatus,
        PurchaseFields.paymentStatus: paymentStatus,
        PurchaseFields.createdBy: createdBy,
      };

  static PurchaseModel fromJson(Map<String, Object?> json) => PurchaseModel(
        id: json[PurchaseFields.id] as int,
        dateTime: json[PurchaseFields.dateTime] as String,
        invoiceNumber: json[PurchaseFields.invoiceNumber] as String,
        supplierId: json[PurchaseFields.supplierId] as int,
        supplierName: json[PurchaseFields.supplierName] as String,
        billerName: json[PurchaseFields.billerName] as String,
        purchaseNote: json[PurchaseFields.purchaseNote] as String,
        totalItems: json[PurchaseFields.totalItems] as String,
        vatAmount: json[PurchaseFields.vatAmount] as String,
        subTotal: json[PurchaseFields.subTotal] as String,
        discount: json[PurchaseFields.discount] as String,
        grantTotal: json[PurchaseFields.grantTotal] as String,
        paid: json[PurchaseFields.paid] as String,
        balance: json[PurchaseFields.balance] as String,
        paymentType: json[PurchaseFields.paymentType] as String,
        purchaseStatus: json[PurchaseFields.purchaseStatus] as String,
        paymentStatus: json[PurchaseFields.paymentStatus] as String,
        createdBy: json[PurchaseFields.createdBy] as String,
      );
}
