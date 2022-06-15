// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ChatModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatModel _$ChatModelFromJson(Map<String, dynamic> json) {
  return ChatModel(
    id: json['id'],
    to: json['to'],
    key: json['key'],
    from: json['from'],
    type: json['type'],
    content: json['content'],
    date: json['date'],
    status: json['status'] as int,
    size: json['size'],
    isGroupMessage: json['isGroupMessage'],
    subtype: json['subtype'],
    readCount: json['readCount'],
    participantsRead: (json['participantsRead'])?.map((e) => e as int).toList(),
  );
}

Map<String, dynamic> _$ChatModelToJson(ChatModel instance) => <String, dynamic>{
      'id': instance.id,
      'to': instance.to,
      'key': instance.key,
      'from': instance.from,
      'type': instance.type,
      'content': instance.content,
      'date': instance.date,
      'status': instance.status,
      'size': instance.size,
      'isGroupMessage': instance.isGroupMessage,
      'subtype': instance.subtype,
      'readCount': instance.readCount,
      'participantsRead': instance.participantsRead,
    };
