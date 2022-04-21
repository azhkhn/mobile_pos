// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'vat_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

VatModel _$VatModelFromJson(Map<String, dynamic> json) {
  return _VatModel.fromJson(json);
}

/// @nodoc
mixin _$VatModel {
  @JsonKey(name: '_id')
  int? get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String get rate => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VatModelCopyWith<VatModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VatModelCopyWith<$Res> {
  factory $VatModelCopyWith(VatModel value, $Res Function(VatModel) then) =
      _$VatModelCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey(name: '_id') int? id,
      String name,
      String code,
      String rate,
      String type});
}

/// @nodoc
class _$VatModelCopyWithImpl<$Res> implements $VatModelCopyWith<$Res> {
  _$VatModelCopyWithImpl(this._value, this._then);

  final VatModel _value;
  // ignore: unused_field
  final $Res Function(VatModel) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? code = freezed,
    Object? rate = freezed,
    Object? type = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      code: code == freezed
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      rate: rate == freezed
          ? _value.rate
          : rate // ignore: cast_nullable_to_non_nullable
              as String,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$VatModelCopyWith<$Res> implements $VatModelCopyWith<$Res> {
  factory _$VatModelCopyWith(_VatModel value, $Res Function(_VatModel) then) =
      __$VatModelCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey(name: '_id') int? id,
      String name,
      String code,
      String rate,
      String type});
}

/// @nodoc
class __$VatModelCopyWithImpl<$Res> extends _$VatModelCopyWithImpl<$Res>
    implements _$VatModelCopyWith<$Res> {
  __$VatModelCopyWithImpl(_VatModel _value, $Res Function(_VatModel) _then)
      : super(_value, (v) => _then(v as _VatModel));

  @override
  _VatModel get _value => super._value as _VatModel;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? code = freezed,
    Object? rate = freezed,
    Object? type = freezed,
  }) {
    return _then(_VatModel(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      code: code == freezed
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      rate: rate == freezed
          ? _value.rate
          : rate // ignore: cast_nullable_to_non_nullable
              as String,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_VatModel extends _VatModel {
  const _$_VatModel(
      {@JsonKey(name: '_id') this.id,
      required this.name,
      required this.code,
      required this.rate,
      required this.type})
      : super._();

  factory _$_VatModel.fromJson(Map<String, dynamic> json) =>
      _$$_VatModelFromJson(json);

  @override
  @JsonKey(name: '_id')
  final int? id;
  @override
  final String name;
  @override
  final String code;
  @override
  final String rate;
  @override
  final String type;

  @override
  String toString() {
    return 'VatModel(id: $id, name: $name, code: $code, rate: $rate, type: $type)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VatModel &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.code, code) &&
            const DeepCollectionEquality().equals(other.rate, rate) &&
            const DeepCollectionEquality().equals(other.type, type));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(code),
      const DeepCollectionEquality().hash(rate),
      const DeepCollectionEquality().hash(type));

  @JsonKey(ignore: true)
  @override
  _$VatModelCopyWith<_VatModel> get copyWith =>
      __$VatModelCopyWithImpl<_VatModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_VatModelToJson(this);
  }
}

abstract class _VatModel extends VatModel {
  const factory _VatModel(
      {@JsonKey(name: '_id') final int? id,
      required final String name,
      required final String code,
      required final String rate,
      required final String type}) = _$_VatModel;
  const _VatModel._() : super._();

  factory _VatModel.fromJson(Map<String, dynamic> json) = _$_VatModel.fromJson;

  @override
  @JsonKey(name: '_id')
  int? get id => throw _privateConstructorUsedError;
  @override
  String get name => throw _privateConstructorUsedError;
  @override
  String get code => throw _privateConstructorUsedError;
  @override
  String get rate => throw _privateConstructorUsedError;
  @override
  String get type => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$VatModelCopyWith<_VatModel> get copyWith =>
      throw _privateConstructorUsedError;
}
