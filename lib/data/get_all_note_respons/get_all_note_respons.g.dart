// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_note_respons.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllNoteRespons _$GetAllNoteResponsFromJson(Map<String, dynamic> json) =>
    GetAllNoteRespons(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => NoteModal.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$GetAllNoteResponsToJson(GetAllNoteRespons instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
