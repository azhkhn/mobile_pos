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
  static const netUnitPrice = 'netUnitPrice';
  static const unitPrice = 'unitPrice';
  static const quantity = 'quantity';
  static const unitCode = 'unitCode';
  static const subTotal = 'subTotal';
  static const vatId = 'vatId';
  static const vatPercentage = 'vatPercentage';
  static const vatTotal = 'vatTotal';
}

class SalesItemsModel {
  int? id;
  int salesId;
  final String productId,
      productType,
      productCode,
      productName,
      category,
      productCost,
      netUnitPrice,
      unitPrice,
      quantity,
      unitCode,
      subTotal,
      vatId,
      vatPercentage,
      vatTotal;

  SalesItemsModel({
    this.id,
    required this.salesId,
    required this.productId,
    required this.productType,
    required this.productCode,
    required this.productName,
    required this.category,
    required this.productCost,
    required this.netUnitPrice,
    required this.unitPrice,
    required this.quantity,
    required this.unitCode,
    required this.subTotal,
    required this.vatId,
    required this.vatPercentage,
    required this.vatTotal,
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
    String? netUnitPrice,
    String? unitPrice,
    String? quantity,
    String? unitCode,
    String? subTotal,
    String? vatId,
    String? vatPercentage,
    String? vatTotal,
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
        netUnitPrice: netUnitPrice ?? this.netUnitPrice,
        unitPrice: unitPrice ?? this.unitPrice,
        quantity: quantity ?? this.quantity,
        unitCode: unitCode ?? this.unitCode,
        subTotal: subTotal ?? this.subTotal,
        vatId: vatId ?? this.vatId,
        vatPercentage: vatPercentage ?? this.vatPercentage,
        vatTotal: vatTotal ?? this.vatTotal,
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
        SalesItemsFields.netUnitPrice: netUnitPrice,
        SalesItemsFields.unitPrice: unitPrice,
        SalesItemsFields.quantity: quantity,
        SalesItemsFields.unitCode: unitCode,
        SalesItemsFields.subTotal: subTotal,
        SalesItemsFields.vatId: vatId,
        SalesItemsFields.vatPercentage: vatPercentage,
        SalesItemsFields.vatTotal: vatTotal,
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
        netUnitPrice: json[SalesItemsFields.netUnitPrice] as String,
        unitPrice: json[SalesItemsFields.unitPrice] as String,
        quantity: json[SalesItemsFields.quantity] as String,
        unitCode: json[SalesItemsFields.unitCode] as String,
        subTotal: json[SalesItemsFields.subTotal] as String,
        vatId: json[SalesItemsFields.vatId] as String,
        vatPercentage: json[SalesItemsFields.vatPercentage] as String,
        vatTotal: json[SalesItemsFields.vatTotal] as String,
      );
}
