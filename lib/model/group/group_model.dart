import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_model.freezed.dart';
part 'group_model.g.dart';

const String tableGroup = 'groups';

class GroupFields {
  static const String id = '_id';
  static const String name = 'name';
  static const String description = 'description';
}

@freezed
class GroupModel with _$GroupModel {
  const factory GroupModel({
    @JsonKey(name: '_id') int? id,
    required String name,
    required String description,
  }) = _GroupModel;

  factory GroupModel.fromJson(Map<String, dynamic> json) => _$GroupModelFromJson(json);
}
