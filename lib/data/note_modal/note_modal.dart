import 'package:json_annotation/json_annotation.dart';

part 'note_modal.g.dart';

@JsonSerializable()
class NoteModal {
  @JsonKey(name: '_id')
  String? id;

  @JsonKey(name: 'title')
  String? title;

  @JsonKey(name: 'content')
  String? content;

  NoteModal({this.id, this.title, this.content});
  NoteModal.create(
      {required this.id, required this.title, required this.content});

  factory NoteModal.fromJson(Map<String, dynamic> json) {
    return _$NoteModalFromJson(json);
  }

  Map<String, dynamic> toJson() => _$NoteModalToJson(this);
}
