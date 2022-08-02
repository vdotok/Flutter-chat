import 'package:json_annotation/json_annotation.dart';
part 'ChatModel.g.dart';

@JsonSerializable()
class ChatModel {
  var id;
  var to;
  var key;
  var from;
  var type;
  var content;
  var date;
  int? status;
  var size;
  var isGroupMessage;
  var subtype;
  var readCount;
  var fileExtension;
  List<int?>? participantsRead;
  ChatModel(
      {this.id,
      this.to,
      this.key,
      this.from,
      this.type,
      this.content,
      this.date,
      this.status,
      this.size,
      this.isGroupMessage,
      this.subtype,
      this.readCount,
      this.fileExtension,
      this.participantsRead});

  factory ChatModel.fromJson(Map<String, dynamic> json) =>
      _$ChatModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChatModelToJson(this);
}
