import 'package:json_annotation/json_annotation.dart';
import 'package:noteapp/data/note_modal/note_modal.dart';

part 'get_all_note_respons.g.dart';

@JsonSerializable()
class GetAllNoteRespons {
  @JsonKey(name: 'data')
  List<NoteModal> data;

  GetAllNoteRespons({this.data = const []});

  factory GetAllNoteRespons.fromJson(Map<String, dynamic> json) {
    return _$GetAllNoteResponsFromJson(json);
  }

  Map<String, dynamic> toJson() => _$GetAllNoteResponsToJson(this);
}
