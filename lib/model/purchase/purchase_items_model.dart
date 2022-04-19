const String tablePurchaseItems = 'purchase_items';

class PurchaseItemsFields {
  static const id = '_id';
  static const purchaseId = 'purchaseId';
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

class PurchaseItemsModel {
  int? id;
  int purchaseId;
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

  PurchaseItemsModel({
    this.id,
    required this.purchaseId,
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

  PurchaseItemsModel copyWith({
    int? id,
    int? purchaseId,
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
      PurchaseItemsModel(
        id: id ?? this.id,
        purchaseId: purchaseId ?? this.purchaseId,
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
        PurchaseItemsFields.id: id,
        PurchaseItemsFields.purchaseId: purchaseId,
        PurchaseItemsFields.productId: productId,
        PurchaseItemsFields.productType: productType,
        PurchaseItemsFields.productCode: productCode,
        PurchaseItemsFields.productName: productName,
        PurchaseItemsFields.category: category,
        PurchaseItemsFields.productCost: productCost,
        PurchaseItemsFields.netUnitPrice: netUnitPrice,
        PurchaseItemsFields.unitPrice: unitPrice,
        PurchaseItemsFields.quantity: quantity,
        PurchaseItemsFields.unitCode: unitCode,
        PurchaseItemsFields.subTotal: subTotal,
        PurchaseItemsFields.vatId: vatId,
        PurchaseItemsFields.vatPercentage: vatPercentage,
        PurchaseItemsFields.vatTotal: vatTotal,
      };

  static PurchaseItemsModel fromJson(Map<String, Object?> json) =>
      PurchaseItemsModel(
        id: json[PurchaseItemsFields.id] as int,
        purchaseId: json[PurchaseItemsFields.purchaseId] as int,
        productId: json[PurchaseItemsFields.productId] as String,
        productType: json[PurchaseItemsFields.productType] as String,
        productCode: json[PurchaseItemsFields.productCode] as String,
        productName: json[PurchaseItemsFields.productName] as String,
        category: json[PurchaseItemsFields.category] as String,
        productCost: json[PurchaseItemsFields.productCost] as String,
        netUnitPrice: json[PurchaseItemsFields.netUnitPrice] as String,
        unitPrice: json[PurchaseItemsFields.unitPrice] as String,
        quantity: json[PurchaseItemsFields.quantity] as String,
        unitCode: json[PurchaseItemsFields.unitCode] as String,
        subTotal: json[PurchaseItemsFields.subTotal] as String,
        vatId: json[PurchaseItemsFields.vatId] as String,
        vatPercentage: json[PurchaseItemsFields.vatPercentage] as String,
        vatTotal: json[PurchaseItemsFields.vatTotal] as String,
      );
}
