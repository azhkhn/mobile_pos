// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'brand_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

BrandModel _$BrandModelFromJson(Map<String, dynamic> json) {
  return _BrandModel.fromJson(json);
}

/// @nodoc
mixin _$BrandModel {
  @JsonKey(name: '_id')
  int? get id => throw _privateConstructorUsedError;
  String get brand => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BrandModelCopyWith<BrandModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BrandModelCopyWith<$Res> {
  factory $BrandModelCopyWith(
          BrandModel value, $Res Function(BrandModel) then) =
      _$BrandModelCopyWithImpl<$Res>;
  $Res call({@JsonKey(name: '_id') int? id, String brand});
}

/// @nodoc
class _$BrandModelCopyWithImpl<$Res> implements $BrandModelCopyWith<$Res> {
  _$BrandModelCopyWithImpl(this._value, this._then);

  final BrandModel _value;
  // ignore: unused_field
  final $Res Function(BrandModel) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? brand = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      brand: brand == freezed
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$BrandModelCopyWith<$Res> implements $BrandModelCopyWith<$Res> {
  factory _$BrandModelCopyWith(
          _BrandModel value, $Res Function(_BrandModel) then) =
      __$BrandModelCopyWithImpl<$Res>;
  @override
  $Res call({@JsonKey(name: '_id') int? id, String brand});
}

/// @nodoc
class __$BrandModelCopyWithImpl<$Res> extends _$BrandModelCopyWithImpl<$Res>
    implements _$BrandModelCopyWith<$Res> {
  __$BrandModelCopyWithImpl(
      _BrandModel _value, $Res Function(_BrandModel) _then)
      : super(_value, (v) => _then(v as _BrandModel));

  @override
  _BrandModel get _value => super._value as _BrandModel;

  @override
  $Res call({
    Object? id = freezed,
    Object? brand = freezed,
  }) {
    return _then(_BrandModel(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      brand: brand == freezed
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_BrandModel extends _BrandModel {
  const _$_BrandModel({@JsonKey(name: '_id') this.id, required this.brand})
      : super._();

  factory _$_BrandModel.fromJson(Map<String, dynamic> json) =>
      _$$_BrandModelFromJson(json);

  @override
  @JsonKey(name: '_id')
  final int? id;
  @override
  final String brand;

  @override
  String toString() {
    return 'BrandModel(id: $id, brand: $brand)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BrandModel &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.brand, brand));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(brand));

  @JsonKey(ignore: true)
  @override
  _$BrandModelCopyWith<_BrandModel> get copyWith =>
      __$BrandModelCopyWithImpl<_BrandModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_BrandModelToJson(this);
  }
}

abstract class _BrandModel extends BrandModel {
  const factory _BrandModel(
      {@JsonKey(name: '_id') final int? id,
      required final String brand}) = _$_BrandModel;
  const _BrandModel._() : super._();

  factory _BrandModel.fromJson(Map<String, dynamic> json) =
      _$_BrandModel.fromJson;

  @override
  @JsonKey(name: '_id')
  int? get id => throw _privateConstructorUsedError;
  @override
  String get brand => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$BrandModelCopyWith<_BrandModel> get copyWith =>
      throw _privateConstructorUsedError;
}
