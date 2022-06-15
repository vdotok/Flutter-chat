// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GroupModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupModel _$GroupModelFromJson(Map<String, dynamic> json) {
  return GroupModel(
    admin_id: json['admin_id'],
    auto_created: json['auto_created'],
    channel_key: json['channel_key'],
    channel_name: json['channel_name'],
    group_title: json['group_title'],
    created_datetime: json['created_datetime'],
    typingstatus: json['typingstatus'],
    id: json['id'],
    counter: json['counter'],
    chatList: (json['chatList'])
        ?.map((e) =>
            e == null ? null : ChatModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    participants: (json['participants'] as List)
        .map((e) => e == null
            ? null
            : ParticipantsModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$GroupModelToJson(GroupModel instance) =>
    <String, dynamic>{
      'admin_id': instance.admin_id,
      'auto_created': instance.auto_created,
      'channel_key': instance.channel_key,
      'channel_name': instance.channel_name,
      'group_title': instance.group_title,
      'id': instance.id,
      'created_datetime': instance.created_datetime,
      'counter': instance.counter,
      'typingstatus': instance.typingstatus,
      'participants': instance.participants,
      'chatList': instance.chatList,
    };
