import 'package:json_annotation/json_annotation.dart';
import '../../core/models/ParticipantsModel.dart';
import '../models/ChatModel.dart';
part 'GroupModel.g.dart';

@JsonSerializable()
class GroupModel {
  dynamic admin_id;
  dynamic auto_created;
  dynamic channel_key;
  dynamic channel_name;
  dynamic group_title;
  dynamic id;
  dynamic created_datetime;
  dynamic counter;
  dynamic typingstatus;
  List<ParticipantsModel?>? participants = [];
  List<ChatModel?>? chatList = [];

  GroupModel(
      {this.admin_id,
      this.auto_created,
      this.channel_key,
      this.channel_name,
      this.group_title,
      this.created_datetime,
      this.typingstatus,
      this.id,
      this.counter,
      this.chatList,
      this.participants});

  factory GroupModel.fromJson(Map<String, dynamic> json) =>
      _$GroupModelFromJson(json);
  Map<String, dynamic> toJson() => _$GroupModelToJson(this);
}
