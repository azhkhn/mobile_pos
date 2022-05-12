// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'invoice_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

InvoiceItemModel _$InvoiceItemModelFromJson(Map<String, dynamic> json) {
  return _InvoiceItem.fromJson(json);
}

/// @nodoc
mixin _$InvoiceItemModel {
  String get no => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get quantity => throw _privateConstructorUsedError;
  String get unitPrice => throw _privateConstructorUsedError;
  String get subTotal => throw _privateConstructorUsedError;
  String get vatPercentage => throw _privateConstructorUsedError;
  String get vatAmount => throw _privateConstructorUsedError;
  String get totalAmount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InvoiceItemModelCopyWith<InvoiceItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvoiceItemModelCopyWith<$Res> {
  factory $InvoiceItemModelCopyWith(
          InvoiceItemModel value, $Res Function(InvoiceItemModel) then) =
      _$InvoiceItemModelCopyWithImpl<$Res>;
  $Res call(
      {String no,
      String description,
      String quantity,
      String unitPrice,
      String subTotal,
      String vatPercentage,
      String vatAmount,
      String totalAmount});
}

/// @nodoc
class _$InvoiceItemModelCopyWithImpl<$Res>
    implements $InvoiceItemModelCopyWith<$Res> {
  _$InvoiceItemModelCopyWithImpl(this._value, this._then);

  final InvoiceItemModel _value;
  // ignore: unused_field
  final $Res Function(InvoiceItemModel) _then;

  @override
  $Res call({
    Object? no = freezed,
    Object? description = freezed,
    Object? quantity = freezed,
    Object? unitPrice = freezed,
    Object? subTotal = freezed,
    Object? vatPercentage = freezed,
    Object? vatAmount = freezed,
    Object? totalAmount = freezed,
  }) {
    return _then(_value.copyWith(
      no: no == freezed
          ? _value.no
          : no // ignore: cast_nullable_to_non_nullable
              as String,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: quantity == freezed
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as String,
      unitPrice: unitPrice == freezed
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as String,
      subTotal: subTotal == freezed
          ? _value.subTotal
          : subTotal // ignore: cast_nullable_to_non_nullable
              as String,
      vatPercentage: vatPercentage == freezed
          ? _value.vatPercentage
          : vatPercentage // ignore: cast_nullable_to_non_nullable
              as String,
      vatAmount: vatAmount == freezed
          ? _value.vatAmount
          : vatAmount // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: totalAmount == freezed
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_InvoiceItemCopyWith<$Res>
    implements $InvoiceItemModelCopyWith<$Res> {
  factory _$$_InvoiceItemCopyWith(
          _$_InvoiceItem value, $Res Function(_$_InvoiceItem) then) =
      __$$_InvoiceItemCopyWithImpl<$Res>;
  @override
  $Res call(
      {String no,
      String description,
      String quantity,
      String unitPrice,
      String subTotal,
      String vatPercentage,
      String vatAmount,
      String totalAmount});
}

/// @nodoc
class __$$_InvoiceItemCopyWithImpl<$Res>
    extends _$InvoiceItemModelCopyWithImpl<$Res>
    implements _$$_InvoiceItemCopyWith<$Res> {
  __$$_InvoiceItemCopyWithImpl(
      _$_InvoiceItem _value, $Res Function(_$_InvoiceItem) _then)
      : super(_value, (v) => _then(v as _$_InvoiceItem));

  @override
  _$_InvoiceItem get _value => super._value as _$_InvoiceItem;

  @override
  $Res call({
    Object? no = freezed,
    Object? description = freezed,
    Object? quantity = freezed,
    Object? unitPrice = freezed,
    Object? subTotal = freezed,
    Object? vatPercentage = freezed,
    Object? vatAmount = freezed,
    Object? totalAmount = freezed,
  }) {
    return _then(_$_InvoiceItem(
      no: no == freezed
          ? _value.no
          : no // ignore: cast_nullable_to_non_nullable
              as String,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: quantity == freezed
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as String,
      unitPrice: unitPrice == freezed
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as String,
      subTotal: subTotal == freezed
          ? _value.subTotal
          : subTotal // ignore: cast_nullable_to_non_nullable
              as String,
      vatPercentage: vatPercentage == freezed
          ? _value.vatPercentage
          : vatPercentage // ignore: cast_nullable_to_non_nullable
              as String,
      vatAmount: vatAmount == freezed
          ? _value.vatAmount
          : vatAmount // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: totalAmount == freezed
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_InvoiceItem implements _InvoiceItem {
  const _$_InvoiceItem(
      {required this.no,
      required this.description,
      required this.quantity,
      required this.unitPrice,
      required this.subTotal,
      required this.vatPercentage,
      required this.vatAmount,
      required this.totalAmount});

  factory _$_InvoiceItem.fromJson(Map<String, dynamic> json) =>
      _$$_InvoiceItemFromJson(json);

  @override
  final String no;
  @override
  final String description;
  @override
  final String quantity;
  @override
  final String unitPrice;
  @override
  final String subTotal;
  @override
  final String vatPercentage;
  @override
  final String vatAmount;
  @override
  final String totalAmount;

  @override
  String toString() {
    return 'InvoiceItemModel(no: $no, description: $description, quantity: $quantity, unitPrice: $unitPrice, subTotal: $subTotal, vatPercentage: $vatPercentage, vatAmount: $vatAmount, totalAmount: $totalAmount)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_InvoiceItem &&
            const DeepCollectionEquality().equals(other.no, no) &&
            const DeepCollectionEquality()
                .equals(other.description, description) &&
            const DeepCollectionEquality().equals(other.quantity, quantity) &&
            const DeepCollectionEquality().equals(other.unitPrice, unitPrice) &&
            const DeepCollectionEquality().equals(other.subTotal, subTotal) &&
            const DeepCollectionEquality()
                .equals(other.vatPercentage, vatPercentage) &&
            const DeepCollectionEquality().equals(other.vatAmount, vatAmount) &&
            const DeepCollectionEquality()
                .equals(other.totalAmount, totalAmount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(no),
      const DeepCollectionEquality().hash(description),
      const DeepCollectionEquality().hash(quantity),
      const DeepCollectionEquality().hash(unitPrice),
      const DeepCollectionEquality().hash(subTotal),
      const DeepCollectionEquality().hash(vatPercentage),
      const DeepCollectionEquality().hash(vatAmount),
      const DeepCollectionEquality().hash(totalAmount));

  @JsonKey(ignore: true)
  @override
  _$$_InvoiceItemCopyWith<_$_InvoiceItem> get copyWith =>
      __$$_InvoiceItemCopyWithImpl<_$_InvoiceItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_InvoiceItemToJson(this);
  }
}

abstract class _InvoiceItem implements InvoiceItemModel {
  const factory _InvoiceItem(
      {required final String no,
      required final String description,
      required final String quantity,
      required final String unitPrice,
      required final String subTotal,
      required final String vatPercentage,
      required final String vatAmount,
      required final String totalAmount}) = _$_InvoiceItem;

  factory _InvoiceItem.fromJson(Map<String, dynamic> json) =
      _$_InvoiceItem.fromJson;

  @override
  String get no => throw _privateConstructorUsedError;
  @override
  String get description => throw _privateConstructorUsedError;
  @override
  String get quantity => throw _privateConstructorUsedError;
  @override
  String get unitPrice => throw _privateConstructorUsedError;
  @override
  String get subTotal => throw _privateConstructorUsedError;
  @override
  String get vatPercentage => throw _privateConstructorUsedError;
  @override
  String get vatAmount => throw _privateConstructorUsedError;
  @override
  String get totalAmount => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_InvoiceItemCopyWith<_$_InvoiceItem> get copyWith =>
      throw _privateConstructorUsedError;
}
