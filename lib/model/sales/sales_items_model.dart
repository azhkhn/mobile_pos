const String tableSalesItems = 'sales_items';

class SalesItemsFields {
  static const id = '_id';
  static const salesId = 'salesId';
  static const productId = 'productId';
  static const productType = 'productType';
  static const productCode = 'productCode';
  static const productName = 'productName';
  static const category = 'category';
  static const productCost = 'productCost';
  static const unitPrice = 'unitPrice';
  static const quantity = 'quantity';
  static const subTotal = 'subTotal';
  static const vatId = 'vatId';
  static const vatPercentage = 'vatPercentage';
  static const vatTotal = 'vatTotal';
  static const unitCode = 'unitCode';
  static const netUnitPrice = 'netUnitPrice';
}

class SalesItemsModel {
  int? id, salesId;
  final String productId,
      productType,
      productCode,
      productName,
      category,
      productCost,
      unitPrice,
      quantity,
      subTotal,
      vatId,
      vatPercentage,
      vatTotal,
      unitCode,
      netUnitPrice;

  SalesItemsModel({
    this.id,
    this.salesId,
    required this.productId,
    required this.productType,
    required this.productCode,
    required this.productName,
    required this.category,
    required this.productCost,
    required this.unitPrice,
    required this.quantity,
    required this.subTotal,
    required this.vatId,
    required this.vatPercentage,
    required this.vatTotal,
    required this.unitCode,
    required this.netUnitPrice,
  });

  SalesItemsModel copyWith({
    int? id,
    int? salesId,
    String? productId,
    String? productType,
    String? productCode,
    String? productName,
    String? category,
    String? productCost,
    String? unitPrice,
    String? quantity,
    String? subTotal,
    String? vatId,
    String? vatPercentage,
    String? vatTotal,
    String? unitCode,
    String? netUnitPrice,
  }) =>
      SalesItemsModel(
        id: id ?? this.id,
        salesId: salesId ?? this.salesId,
        productId: productId ?? this.productId,
        productType: productType ?? this.productType,
        productCode: productCode ?? this.productCode,
        productName: productName ?? this.productName,
        category: category ?? this.category,
        productCost: productCost ?? this.productCost,
        unitPrice: unitPrice ?? this.unitPrice,
        quantity: quantity ?? this.quantity,
        subTotal: subTotal ?? this.subTotal,
        vatId: vatId ?? this.vatId,
        vatPercentage: vatPercentage ?? this.vatPercentage,
        vatTotal: vatTotal ?? this.vatTotal,
        unitCode: unitCode ?? this.unitCode,
        netUnitPrice: netUnitPrice ?? this.netUnitPrice,
      );

  Map<String, Object?> toJson() => {
        SalesItemsFields.id: id,
        SalesItemsFields.salesId: salesId,
        SalesItemsFields.productId: productId,
        SalesItemsFields.productType: productType,
        SalesItemsFields.productCode: productCode,
        SalesItemsFields.productName: productName,
        SalesItemsFields.category: category,
        SalesItemsFields.productCost: productCost,
        SalesItemsFields.unitPrice: unitPrice,
        SalesItemsFields.quantity: quantity,
        SalesItemsFields.subTotal: subTotal,
        SalesItemsFields.vatId: vatId,
        SalesItemsFields.vatPercentage: vatPercentage,
        SalesItemsFields.vatTotal: vatTotal,
        SalesItemsFields.unitCode: unitCode,
        SalesItemsFields.netUnitPrice: netUnitPrice,
      };

  static SalesItemsModel fromJson(Map<String, Object?> json) => SalesItemsModel(
        id: json[SalesItemsFields.id] as int,
        salesId: json[SalesItemsFields.salesId] as int,
        productId: json[SalesItemsFields.productId] as String,
        productType: json[SalesItemsFields.productType] as String,
        productCode: json[SalesItemsFields.productCode] as String,
        productName: json[SalesItemsFields.productName] as String,
        category: json[SalesItemsFields.category] as String,
        productCost: json[SalesItemsFields.productCost] as String,
        unitPrice: json[SalesItemsFields.unitPrice] as String,
        quantity: json[SalesItemsFields.quantity] as String,
        subTotal: json[SalesItemsFields.subTotal] as String,
        vatId: json[SalesItemsFields.vatId] as String,
        vatPercentage: json[SalesItemsFields.vatPercentage] as String,
        vatTotal: json[SalesItemsFields.vatTotal] as String,
        unitCode: json[SalesItemsFields.unitCode] as String,
        netUnitPrice: json[SalesItemsFields.netUnitPrice] as String,
      );
}
