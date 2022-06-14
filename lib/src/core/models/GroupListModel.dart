import 'package:json_annotation/json_annotation.dart';
import '../models/GroupModel.dart';
part 'GroupListModel.g.dart';

@JsonSerializable()
class GroupListModel {
  List<GroupModel?>? groups = [];

  GroupListModel({this.groups});

  factory GroupListModel.fromJson(Map<String, dynamic> json) =>
      _$GroupListModelFromJson(json);
  Map<String, dynamic> toJson() => _$GroupListModelToJson(this);
}
