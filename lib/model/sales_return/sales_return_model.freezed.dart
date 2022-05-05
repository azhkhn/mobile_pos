// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'sales_return_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SalesReturnModal _$SalesReturnModalFromJson(Map<String, dynamic> json) {
  return _SalesReturnModal.fromJson(json);
}

/// @nodoc
mixin _$SalesReturnModal {
  @JsonKey(name: '_id')
  int? get id => throw _privateConstructorUsedError;
  String? get invoiceNumber => throw _privateConstructorUsedError;
  String? get originalInvoiceNumber => throw _privateConstructorUsedError;
  int get customerId => throw _privateConstructorUsedError;
  String get dateTime => throw _privateConstructorUsedError;
  String get customerName => throw _privateConstructorUsedError;
  String get billerName => throw _privateConstructorUsedError;
  String get salesNote => throw _privateConstructorUsedError;
  String get totalItems => throw _privateConstructorUsedError;
  String get vatAmount => throw _privateConstructorUsedError;
  String get subTotal => throw _privateConstructorUsedError;
  String get discount => throw _privateConstructorUsedError;
  String get grantTotal => throw _privateConstructorUsedError;
  String get paid => throw _privateConstructorUsedError;
  String get balance => throw _privateConstructorUsedError;
  String get paymentType => throw _privateConstructorUsedError;
  String get salesStatus => throw _privateConstructorUsedError;
  String get paymentStatus => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SalesReturnModalCopyWith<SalesReturnModal> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalesReturnModalCopyWith<$Res> {
  factory $SalesReturnModalCopyWith(
          SalesReturnModal value, $Res Function(SalesReturnModal) then) =
      _$SalesReturnModalCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey(name: '_id') int? id,
      String? invoiceNumber,
      String? originalInvoiceNumber,
      int customerId,
      String dateTime,
      String customerName,
      String billerName,
      String salesNote,
      String totalItems,
      String vatAmount,
      String subTotal,
      String discount,
      String grantTotal,
      String paid,
      String balance,
      String paymentType,
      String salesStatus,
      String paymentStatus,
      String createdBy});
}

/// @nodoc
class _$SalesReturnModalCopyWithImpl<$Res>
    implements $SalesReturnModalCopyWith<$Res> {
  _$SalesReturnModalCopyWithImpl(this._value, this._then);

  final SalesReturnModal _value;
  // ignore: unused_field
  final $Res Function(SalesReturnModal) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? invoiceNumber = freezed,
    Object? originalInvoiceNumber = freezed,
    Object? customerId = freezed,
    Object? dateTime = freezed,
    Object? customerName = freezed,
    Object? billerName = freezed,
    Object? salesNote = freezed,
    Object? totalItems = freezed,
    Object? vatAmount = freezed,
    Object? subTotal = freezed,
    Object? discount = freezed,
    Object? grantTotal = freezed,
    Object? paid = freezed,
    Object? balance = freezed,
    Object? paymentType = freezed,
    Object? salesStatus = freezed,
    Object? paymentStatus = freezed,
    Object? createdBy = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      invoiceNumber: invoiceNumber == freezed
          ? _value.invoiceNumber
          : invoiceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      originalInvoiceNumber: originalInvoiceNumber == freezed
          ? _value.originalInvoiceNumber
          : originalInvoiceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      customerId: customerId == freezed
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as int,
      dateTime: dateTime == freezed
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as String,
      customerName: customerName == freezed
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      billerName: billerName == freezed
          ? _value.billerName
          : billerName // ignore: cast_nullable_to_non_nullable
              as String,
      salesNote: salesNote == freezed
          ? _value.salesNote
          : salesNote // ignore: cast_nullable_to_non_nullable
              as String,
      totalItems: totalItems == freezed
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as String,
      vatAmount: vatAmount == freezed
          ? _value.vatAmount
          : vatAmount // ignore: cast_nullable_to_non_nullable
              as String,
      subTotal: subTotal == freezed
          ? _value.subTotal
          : subTotal // ignore: cast_nullable_to_non_nullable
              as String,
      discount: discount == freezed
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as String,
      grantTotal: grantTotal == freezed
          ? _value.grantTotal
          : grantTotal // ignore: cast_nullable_to_non_nullable
              as String,
      paid: paid == freezed
          ? _value.paid
          : paid // ignore: cast_nullable_to_non_nullable
              as String,
      balance: balance == freezed
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as String,
      paymentType: paymentType == freezed
          ? _value.paymentType
          : paymentType // ignore: cast_nullable_to_non_nullable
              as String,
      salesStatus: salesStatus == freezed
          ? _value.salesStatus
          : salesStatus // ignore: cast_nullable_to_non_nullable
              as String,
      paymentStatus: paymentStatus == freezed
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: createdBy == freezed
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$SalesReturnModalCopyWith<$Res>
    implements $SalesReturnModalCopyWith<$Res> {
  factory _$SalesReturnModalCopyWith(
          _SalesReturnModal value, $Res Function(_SalesReturnModal) then) =
      __$SalesReturnModalCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey(name: '_id') int? id,
      String? invoiceNumber,
      String? originalInvoiceNumber,
      int customerId,
      String dateTime,
      String customerName,
      String billerName,
      String salesNote,
      String totalItems,
      String vatAmount,
      String subTotal,
      String discount,
      String grantTotal,
      String paid,
      String balance,
      String paymentType,
      String salesStatus,
      String paymentStatus,
      String createdBy});
}

/// @nodoc
class __$SalesReturnModalCopyWithImpl<$Res>
    extends _$SalesReturnModalCopyWithImpl<$Res>
    implements _$SalesReturnModalCopyWith<$Res> {
  __$SalesReturnModalCopyWithImpl(
      _SalesReturnModal _value, $Res Function(_SalesReturnModal) _then)
      : super(_value, (v) => _then(v as _SalesReturnModal));

  @override
  _SalesReturnModal get _value => super._value as _SalesReturnModal;

  @override
  $Res call({
    Object? id = freezed,
    Object? invoiceNumber = freezed,
    Object? originalInvoiceNumber = freezed,
    Object? customerId = freezed,
    Object? dateTime = freezed,
    Object? customerName = freezed,
    Object? billerName = freezed,
    Object? salesNote = freezed,
    Object? totalItems = freezed,
    Object? vatAmount = freezed,
    Object? subTotal = freezed,
    Object? discount = freezed,
    Object? grantTotal = freezed,
    Object? paid = freezed,
    Object? balance = freezed,
    Object? paymentType = freezed,
    Object? salesStatus = freezed,
    Object? paymentStatus = freezed,
    Object? createdBy = freezed,
  }) {
    return _then(_SalesReturnModal(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      invoiceNumber: invoiceNumber == freezed
          ? _value.invoiceNumber
          : invoiceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      originalInvoiceNumber: originalInvoiceNumber == freezed
          ? _value.originalInvoiceNumber
          : originalInvoiceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      customerId: customerId == freezed
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as int,
      dateTime: dateTime == freezed
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as String,
      customerName: customerName == freezed
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      billerName: billerName == freezed
          ? _value.billerName
          : billerName // ignore: cast_nullable_to_non_nullable
              as String,
      salesNote: salesNote == freezed
          ? _value.salesNote
          : salesNote // ignore: cast_nullable_to_non_nullable
              as String,
      totalItems: totalItems == freezed
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as String,
      vatAmount: vatAmount == freezed
          ? _value.vatAmount
          : vatAmount // ignore: cast_nullable_to_non_nullable
              as String,
      subTotal: subTotal == freezed
          ? _value.subTotal
          : subTotal // ignore: cast_nullable_to_non_nullable
              as String,
      discount: discount == freezed
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as String,
      grantTotal: grantTotal == freezed
          ? _value.grantTotal
          : grantTotal // ignore: cast_nullable_to_non_nullable
              as String,
      paid: paid == freezed
          ? _value.paid
          : paid // ignore: cast_nullable_to_non_nullable
              as String,
      balance: balance == freezed
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as String,
      paymentType: paymentType == freezed
          ? _value.paymentType
          : paymentType // ignore: cast_nullable_to_non_nullable
              as String,
      salesStatus: salesStatus == freezed
          ? _value.salesStatus
          : salesStatus // ignore: cast_nullable_to_non_nullable
              as String,
      paymentStatus: paymentStatus == freezed
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: createdBy == freezed
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_SalesReturnModal implements _SalesReturnModal {
  const _$_SalesReturnModal(
      {@JsonKey(name: '_id') this.id,
      this.invoiceNumber,
      required this.originalInvoiceNumber,
      required this.customerId,
      required this.dateTime,
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
      required this.createdBy});

  factory _$_SalesReturnModal.fromJson(Map<String, dynamic> json) =>
      _$$_SalesReturnModalFromJson(json);

  @override
  @JsonKey(name: '_id')
  final int? id;
  @override
  final String? invoiceNumber;
  @override
  final String? originalInvoiceNumber;
  @override
  final int customerId;
  @override
  final String dateTime;
  @override
  final String customerName;
  @override
  final String billerName;
  @override
  final String salesNote;
  @override
  final String totalItems;
  @override
  final String vatAmount;
  @override
  final String subTotal;
  @override
  final String discount;
  @override
  final String grantTotal;
  @override
  final String paid;
  @override
  final String balance;
  @override
  final String paymentType;
  @override
  final String salesStatus;
  @override
  final String paymentStatus;
  @override
  final String createdBy;

  @override
  String toString() {
    return 'SalesReturnModal(id: $id, invoiceNumber: $invoiceNumber, originalInvoiceNumber: $originalInvoiceNumber, customerId: $customerId, dateTime: $dateTime, customerName: $customerName, billerName: $billerName, salesNote: $salesNote, totalItems: $totalItems, vatAmount: $vatAmount, subTotal: $subTotal, discount: $discount, grantTotal: $grantTotal, paid: $paid, balance: $balance, paymentType: $paymentType, salesStatus: $salesStatus, paymentStatus: $paymentStatus, createdBy: $createdBy)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SalesReturnModal &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality()
                .equals(other.invoiceNumber, invoiceNumber) &&
            const DeepCollectionEquality()
                .equals(other.originalInvoiceNumber, originalInvoiceNumber) &&
            const DeepCollectionEquality()
                .equals(other.customerId, customerId) &&
            const DeepCollectionEquality().equals(other.dateTime, dateTime) &&
            const DeepCollectionEquality()
                .equals(other.customerName, customerName) &&
            const DeepCollectionEquality()
                .equals(other.billerName, billerName) &&
            const DeepCollectionEquality().equals(other.salesNote, salesNote) &&
            const DeepCollectionEquality()
                .equals(other.totalItems, totalItems) &&
            const DeepCollectionEquality().equals(other.vatAmount, vatAmount) &&
            const DeepCollectionEquality().equals(other.subTotal, subTotal) &&
            const DeepCollectionEquality().equals(other.discount, discount) &&
            const DeepCollectionEquality()
                .equals(other.grantTotal, grantTotal) &&
            const DeepCollectionEquality().equals(other.paid, paid) &&
            const DeepCollectionEquality().equals(other.balance, balance) &&
            const DeepCollectionEquality()
                .equals(other.paymentType, paymentType) &&
            const DeepCollectionEquality()
                .equals(other.salesStatus, salesStatus) &&
            const DeepCollectionEquality()
                .equals(other.paymentStatus, paymentStatus) &&
            const DeepCollectionEquality().equals(other.createdBy, createdBy));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        const DeepCollectionEquality().hash(id),
        const DeepCollectionEquality().hash(invoiceNumber),
        const DeepCollectionEquality().hash(originalInvoiceNumber),
        const DeepCollectionEquality().hash(customerId),
        const DeepCollectionEquality().hash(dateTime),
        const DeepCollectionEquality().hash(customerName),
        const DeepCollectionEquality().hash(billerName),
        const DeepCollectionEquality().hash(salesNote),
        const DeepCollectionEquality().hash(totalItems),
        const DeepCollectionEquality().hash(vatAmount),
        const DeepCollectionEquality().hash(subTotal),
        const DeepCollectionEquality().hash(discount),
        const DeepCollectionEquality().hash(grantTotal),
        const DeepCollectionEquality().hash(paid),
        const DeepCollectionEquality().hash(balance),
        const DeepCollectionEquality().hash(paymentType),
        const DeepCollectionEquality().hash(salesStatus),
        const DeepCollectionEquality().hash(paymentStatus),
        const DeepCollectionEquality().hash(createdBy)
      ]);

  @JsonKey(ignore: true)
  @override
  _$SalesReturnModalCopyWith<_SalesReturnModal> get copyWith =>
      __$SalesReturnModalCopyWithImpl<_SalesReturnModal>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SalesReturnModalToJson(this);
  }
}

abstract class _SalesReturnModal implements SalesReturnModal {
  const factory _SalesReturnModal(
      {@JsonKey(name: '_id') final int? id,
      final String? invoiceNumber,
      required final String? originalInvoiceNumber,
      required final int customerId,
      required final String dateTime,
      required final String customerName,
      required final String billerName,
      required final String salesNote,
      required final String totalItems,
      required final String vatAmount,
      required final String subTotal,
      required final String discount,
      required final String grantTotal,
      required final String paid,
      required final String balance,
      required final String paymentType,
      required final String salesStatus,
      required final String paymentStatus,
      required final String createdBy}) = _$_SalesReturnModal;

  factory _SalesReturnModal.fromJson(Map<String, dynamic> json) =
      _$_SalesReturnModal.fromJson;

  @override
  @JsonKey(name: '_id')
  int? get id => throw _privateConstructorUsedError;
  @override
  String? get invoiceNumber => throw _privateConstructorUsedError;
  @override
  String? get originalInvoiceNumber => throw _privateConstructorUsedError;
  @override
  int get customerId => throw _privateConstructorUsedError;
  @override
  String get dateTime => throw _privateConstructorUsedError;
  @override
  String get customerName => throw _privateConstructorUsedError;
  @override
  String get billerName => throw _privateConstructorUsedError;
  @override
  String get salesNote => throw _privateConstructorUsedError;
  @override
  String get totalItems => throw _privateConstructorUsedError;
  @override
  String get vatAmount => throw _privateConstructorUsedError;
  @override
  String get subTotal => throw _privateConstructorUsedError;
  @override
  String get discount => throw _privateConstructorUsedError;
  @override
  String get grantTotal => throw _privateConstructorUsedError;
  @override
  String get paid => throw _privateConstructorUsedError;
  @override
  String get balance => throw _privateConstructorUsedError;
  @override
  String get paymentType => throw _privateConstructorUsedError;
  @override
  String get salesStatus => throw _privateConstructorUsedError;
  @override
  String get paymentStatus => throw _privateConstructorUsedError;
  @override
  String get createdBy => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$SalesReturnModalCopyWith<_SalesReturnModal> get copyWith =>
      throw _privateConstructorUsedError;
}
