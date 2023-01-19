

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:noteapp/data/get_all_note_respons/get_all_note_respons.dart';
import 'package:noteapp/data/note_modal/note_modal.dart';
import 'package:noteapp/data/url.dart';

abstract class ApiCalls {
  Future<NoteModal?> createNote(NoteModal value);
  Future<List<NoteModal?>> getAllNote();
  Future<NoteModal?> updateNote(NoteModal value);
  Future<void> deleteNote(String id);
}

class NoteDB extends ApiCalls {
  //singleton
  NoteDB.internal();
  static NoteDB instance = NoteDB.internal();
  NoteDB factory() {
    return instance;
  }
//end singleton

  final dio = Dio();
  final url = Url();
  ValueNotifier<List<NoteModal>> noteListNotifier = ValueNotifier([]);

  NoteDB() {
    dio.options =
        BaseOptions(baseUrl: url.baseUrl, responseType: ResponseType.plain);
  }

  @override
  Future<NoteModal?> createNote(NoteModal value) async {
    try {
      final result =
          await dio.post(url.baseUrl + url.createNote, data: value.toJson());
      // final resultAsjson = jsonDecode(result.data);
      final note = NoteModal.fromJson(result.data as Map<String, dynamic>);
      noteListNotifier.value.insert(0, note);
      noteListNotifier.notifyListeners();
      return note;
    } on DioError catch (e) {
      return null;
    } catch (e) {}
    return null;
  }

  @override
  Future<List<NoteModal>> getAllNote() async {
    final result = await dio.get(url.baseUrl + url.getAllNote);

    if (result.data != null) {
      // final resultAsjson = jsonDecode(result.data);
      final getNoteResp = GetAllNoteRespons.fromJson(result.data);
      noteListNotifier.value.clear();
      noteListNotifier.value.addAll(getNoteResp.data.reversed);
      noteListNotifier.notifyListeners();
      return getNoteResp.data;
    } else {
      noteListNotifier.value.clear();
      return [];
    }
  }

  @override
  Future<NoteModal?> updateNote(NoteModal value) async {
    final result =
        await dio.put(url.baseUrl + url.updateNote, data: value.toJson());
    if (result.data == null) {
      return null;
    }

    //find index

    final index =
        noteListNotifier.value.indexWhere((note) => note.id == value.id);
    if (index == -1) {
      return null;
    }
    //remove from index

    noteListNotifier.value.removeAt(index);

    //add note in that index
    noteListNotifier.value.insert(index, value);
    noteListNotifier.notifyListeners();
    return value;
  }

  @override
  Future<void> deleteNote(String id) async {
    final result =
        await dio.delete(url.baseUrl + url.deleteNote.replaceFirst('{id}', id));
    if (result.data == null) {
      return;
    }
    final index = noteListNotifier.value.indexWhere((note) => note.id == id);
    if (index == null) {
      return;
    }
    noteListNotifier.value.removeAt(index);
    noteListNotifier.notifyListeners();
  }

  NoteModal? getNoteById(String id) {
    try {
      return noteListNotifier.value.firstWhere((note) => note.id == id);
    } catch (_) {
      return null;
    }
  }
}
