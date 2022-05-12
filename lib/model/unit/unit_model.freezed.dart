// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'unit_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UnitModel _$UnitModelFromJson(Map<String, dynamic> json) {
  return _UnitModel.fromJson(json);
}

/// @nodoc
mixin _$UnitModel {
  @JsonKey(name: '_id')
  int? get id => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UnitModelCopyWith<UnitModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UnitModelCopyWith<$Res> {
  factory $UnitModelCopyWith(UnitModel value, $Res Function(UnitModel) then) =
      _$UnitModelCopyWithImpl<$Res>;
  $Res call({@JsonKey(name: '_id') int? id, String unit});
}

/// @nodoc
class _$UnitModelCopyWithImpl<$Res> implements $UnitModelCopyWith<$Res> {
  _$UnitModelCopyWithImpl(this._value, this._then);

  final UnitModel _value;
  // ignore: unused_field
  final $Res Function(UnitModel) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? unit = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      unit: unit == freezed
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_UnitModelCopyWith<$Res> implements $UnitModelCopyWith<$Res> {
  factory _$$_UnitModelCopyWith(
          _$_UnitModel value, $Res Function(_$_UnitModel) then) =
      __$$_UnitModelCopyWithImpl<$Res>;
  @override
  $Res call({@JsonKey(name: '_id') int? id, String unit});
}

/// @nodoc
class __$$_UnitModelCopyWithImpl<$Res> extends _$UnitModelCopyWithImpl<$Res>
    implements _$$_UnitModelCopyWith<$Res> {
  __$$_UnitModelCopyWithImpl(
      _$_UnitModel _value, $Res Function(_$_UnitModel) _then)
      : super(_value, (v) => _then(v as _$_UnitModel));

  @override
  _$_UnitModel get _value => super._value as _$_UnitModel;

  @override
  $Res call({
    Object? id = freezed,
    Object? unit = freezed,
  }) {
    return _then(_$_UnitModel(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      unit: unit == freezed
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_UnitModel extends _UnitModel {
  const _$_UnitModel({@JsonKey(name: '_id') this.id, required this.unit})
      : super._();

  factory _$_UnitModel.fromJson(Map<String, dynamic> json) =>
      _$$_UnitModelFromJson(json);

  @override
  @JsonKey(name: '_id')
  final int? id;
  @override
  final String unit;

  @override
  String toString() {
    return 'UnitModel(id: $id, unit: $unit)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UnitModel &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.unit, unit));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(unit));

  @JsonKey(ignore: true)
  @override
  _$$_UnitModelCopyWith<_$_UnitModel> get copyWith =>
      __$$_UnitModelCopyWithImpl<_$_UnitModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UnitModelToJson(this);
  }
}

abstract class _UnitModel extends UnitModel {
  const factory _UnitModel(
      {@JsonKey(name: '_id') final int? id,
      required final String unit}) = _$_UnitModel;
  const _UnitModel._() : super._();

  factory _UnitModel.fromJson(Map<String, dynamic> json) =
      _$_UnitModel.fromJson;

  @override
  @JsonKey(name: '_id')
  int? get id => throw _privateConstructorUsedError;
  @override
  String get unit => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_UnitModelCopyWith<_$_UnitModel> get copyWith =>
      throw _privateConstructorUsedError;
}
