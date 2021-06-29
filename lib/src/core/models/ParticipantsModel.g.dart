// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ParticipantsModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParticipantsModel _$ParticipantsModelFromJson(Map<String, dynamic> json) {
  return ParticipantsModel(
    color_code: json['color_code'],
    color_id: json['color_id'],
    email: json['email'],
    full_name: json['full_name'],
    ref_id: json['ref_id'],
    user_id: json['user_id'],
  );
}

Map<String, dynamic> _$ParticipantsModelToJson(ParticipantsModel instance) =>
    <String, dynamic>{
      'color_code': instance.color_code,
      'color_id': instance.color_id,
      'full_name': instance.full_name,
      'email': instance.email,
      'user_id': instance.user_id,
      'ref_id': instance.ref_id,
    };
