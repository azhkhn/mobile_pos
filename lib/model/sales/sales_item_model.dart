// const String tableSalesItems = 'sales';

// class SalesFields {
//   static const id = '_id';
//   static const salesId = 'salesId';
//   static const productId = 'productId';
//   static const productName = 'productName';
//   static const cusomerId = 'cusomerId';
//   static const customerName = 'customerName';
//   static const billerId = 'billerId';
//   static const billerName = 'billerName';
//   static const vatId = 'vatId';
//   static const vatAmount = 'vatAmount';
//   static const subTotal = 'subTotal';
//   static const discount = 'discount';
//   static const grantTotal = 'grantTotal';
//   static const salesStatus = 'salesStatus';
//   static const paymentStatus = 'paymentStatus';
//   static const createdBy = 'createdBy';
//   static const totalItems = 'totalItems';
// }

// class SalesModel {
//   int? id;
//   final String salesId,
//       productName,
//       cusomerId,
//       customerName,
//       billerId,
//       billerName,
//       productId,
//       vatId,
//       vatAmount,
//       subTotal,
//       discount,
//       grantTotal,
//       salesStatus,
//       paymentStatus,
//       createdBy,
//       totalItems;

//   SalesModel({
//     this.id,
//     required this.salesId,
//     required this.productName,
//     required this.cusomerId,
//     required this.customerName,
//     required this.billerId,
//     required this.billerName,
//     required this.productId,
//     required this.vatId,
//     required this.vatAmount,
//     required this.subTotal,
//     required this.discount,
//     required this.grantTotal,
//     required this.salesStatus,
//     required this.paymentStatus,
//     required this.createdBy,
//     required this.totalItems,
//   });

//   Map<String, Object?> toJson() => {
//         SalesFields.id: id,
//         SalesFields.salesId: salesId,
//         SalesFields.productName: productName,
//         SalesFields.cusomerId: cusomerId,
//         SalesFields.customerName: customerName,
//         SalesFields.billerId: billerId,
//         SalesFields.billerName: billerName,
//         SalesFields.productId: productId,
//         SalesFields.vatId: vatId,
//         SalesFields.vatAmount: vatAmount,
//         SalesFields.subTotal: subTotal,
//         SalesFields.discount: discount,
//         SalesFields.grantTotal: grantTotal,
//         SalesFields.salesStatus: salesStatus,
//         SalesFields.paymentStatus: paymentStatus,
//         SalesFields.createdBy: createdBy,
//         SalesFields.totalItems: totalItems,
//       };

//   static SalesModel fromJson(Map<String, Object?> json) => SalesModel(
//         id: json[SalesFields.id] as int,
//         productName: json[SalesFields.productName] as String,
//         salesId: json[SalesFields.salesId] as String,
//         cusomerId: json[SalesFields.cusomerId] as String,
//         customerName: json[SalesFields.customerName] as String,
//         billerId: json[SalesFields.billerId] as String,
//         billerName: json[SalesFields.billerName] as String,
//         productId: json[SalesFields.productId] as String,
//         vatId: json[SalesFields.vatId] as String,
//         vatAmount: json[SalesFields.vatAmount] as String,
//         subTotal: json[SalesFields.subTotal] as String,
//         discount: json[SalesFields.discount] as String,
//         grantTotal: json[SalesFields.grantTotal] as String,
//         salesStatus: json[SalesFields.salesStatus] as String,
//         paymentStatus: json[SalesFields.paymentStatus] as String,
//         createdBy: json[SalesFields.createdBy] as String,
//         totalItems: json[SalesFields.totalItems] as String,
//       );
// }
