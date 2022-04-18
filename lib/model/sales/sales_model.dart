const String tableSales = 'sales';

class SalesFields {
  static const id = '_id';
  static const invoiceNumber = 'invoiceNumber';
  static const salesNote = 'salesNote';
  static const dateTime = 'dateTime';
  static const cusomerId = 'cusomerId';
  static const customerName = 'customerName';
  static const billerName = 'billerName';
  static const totalItems = 'totalItems';
  static const vatAmount = 'vatAmount';
  static const subTotal = 'subTotal';
  static const discount = 'discount';
  static const grantTotal = 'grantTotal';
  static const paid = 'paid';
  static const balance = 'balance';
  static const paymentType = 'paymentType';
  static const salesStatus = 'salesStatus';
  static const paymentStatus = 'paymentStatus';
  static const createdBy = 'createdBy';
}

class SalesModel {
  int? id;
  String? invoiceNumber;
  final int cusomerId;
  final String dateTime,
      customerName,
      billerName,
      salesNote,
      totalItems,
      vatAmount,
      subTotal,
      discount,
      grantTotal,
      paid,
      balance,
      paymentType,
      salesStatus,
      paymentStatus,
      createdBy;

  SalesModel({
    this.id,
    this.invoiceNumber,
    required this.dateTime,
    required this.cusomerId,
    required this.customerName,
    required this.billerName,
    required this.salesNote,
    required this.totalItems,
    required this.vatAmount,
    required this.subTotal,
    required this.discount,
    required this.grantTotal,
    required this.paid,
    required this.balance,
    required this.paymentType,
    required this.salesStatus,
    required this.paymentStatus,
    required this.createdBy,
  });

  SalesModel copyWith({
    int? id,
    String? invoiceNumber,
    dateTime,
    cusomerId,
    customerName,
    billerName,
    salesNote,
    totalItems,
    vatAmount,
    subTotal,
    discount,
    grantTotal,
    paid,
    balance,
    paymentType,
    salesStatus,
    paymentStatus,
    createdBy,
  }) =>
      SalesModel(
        id: id ?? this.id,
        invoiceNumber: invoiceNumber ?? this.invoiceNumber,
        dateTime: dateTime ?? this.dateTime,
        cusomerId: cusomerId ?? this.cusomerId,
        customerName: customerName ?? this.customerName,
        billerName: billerName ?? this.billerName,
        salesNote: salesNote ?? this.salesNote,
        totalItems: totalItems ?? this.totalItems,
        vatAmount: vatAmount ?? this.vatAmount,
        subTotal: subTotal ?? this.subTotal,
        discount: discount ?? this.discount,
        grantTotal: grantTotal ?? this.grantTotal,
        paid: paid ?? this.paid,
        balance: balance ?? this.balance,
        paymentType: paymentType ?? this.paymentType,
        salesStatus: salesStatus ?? this.salesStatus,
        paymentStatus: paymentStatus ?? this.paymentStatus,
        createdBy: createdBy ?? this.createdBy,
      );

  Map<String, Object?> toJson() => {
        SalesFields.id: id,
        SalesFields.invoiceNumber: invoiceNumber,
        SalesFields.dateTime: dateTime,
        SalesFields.cusomerId: cusomerId,
        SalesFields.customerName: customerName,
        SalesFields.billerName: billerName,
        SalesFields.salesNote: salesNote,
        SalesFields.totalItems: totalItems,
        SalesFields.vatAmount: vatAmount,
        SalesFields.subTotal: subTotal,
        SalesFields.discount: discount,
        SalesFields.grantTotal: grantTotal,
        SalesFields.paid: paid,
        SalesFields.balance: balance,
        SalesFields.paymentType: paymentType,
        SalesFields.salesStatus: salesStatus,
        SalesFields.paymentStatus: paymentStatus,
        SalesFields.createdBy: createdBy,
      };

  static SalesModel fromJson(Map<String, Object?> json) => SalesModel(
        id: json[SalesFields.id] as int,
        dateTime: json[SalesFields.dateTime] as String,
        invoiceNumber: json[SalesFields.invoiceNumber] as String,
        cusomerId: json[SalesFields.cusomerId] as int,
        customerName: json[SalesFields.customerName] as String,
        billerName: json[SalesFields.billerName] as String,
        salesNote: json[SalesFields.salesNote] as String,
        totalItems: json[SalesFields.totalItems] as String,
        vatAmount: json[SalesFields.vatAmount] as String,
        subTotal: json[SalesFields.subTotal] as String,
        discount: json[SalesFields.discount] as String,
        grantTotal: json[SalesFields.grantTotal] as String,
        paid: json[SalesFields.paid] as String,
        balance: json[SalesFields.balance] as String,
        paymentType: json[SalesFields.paymentType] as String,
        salesStatus: json[SalesFields.salesStatus] as String,
        paymentStatus: json[SalesFields.paymentStatus] as String,
        createdBy: json[SalesFields.createdBy] as String,
      );
}
