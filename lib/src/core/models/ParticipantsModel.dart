import 'package:json_annotation/json_annotation.dart';
part 'ParticipantsModel.g.dart';

@JsonSerializable()
class ParticipantsModel {
  dynamic color_code;
  dynamic color_id;
  dynamic full_name;
  dynamic email;
  dynamic user_id;
  dynamic ref_id;

  ParticipantsModel({
    this.color_code,
    this.color_id,
    this.email,
    this.full_name,
    this.ref_id,
    this.user_id,
  });

  factory ParticipantsModel.fromJson(Map<String, dynamic> json) =>
      _$ParticipantsModelFromJson(json);
  Map<String, dynamic> toJson() => _$ParticipantsModelToJson(this);
}
