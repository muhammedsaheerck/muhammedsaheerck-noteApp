import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:noteapp/data/data.dart';
import 'package:noteapp/data/note_modal/note_modal.dart';

enum ActionType {
  addNote,
  editNote,
}

class ScreenAddNote extends StatelessWidget {
  final ActionType type;
  String? id;
  ScreenAddNote({super.key, required this.type, this.id});

  Widget get saveButton => TextButton.icon(
      onPressed: (() {
        switch (type) {
          case ActionType.addNote:
            saveNote();
            break;
          case ActionType.editNote:
            saveEditedNote();
            break;
        }
      }),
      icon: const Icon(
        Icons.save,
        color: Colors.white,
      ),
      label: const Text(
        'save',
        style: TextStyle(color: Colors.white),
      ));

  final titleEditingController = TextEditingController();
  final contentEditingController = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    if (type == ActionType.editNote) {
      if (id == null) {
        Navigator.of(context).pop();
      }

      final note = NoteDB.instance.getNoteById(id!);
      if (note == null) {
        Navigator.of(context).pop();
      }

      titleEditingController.text = note!.title ?? 'No Title';
      contentEditingController.text = note.content ?? 'No Contet';
    }
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(type.name.toUpperCase()),
        actions: [
          saveButton,
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextFormField(
              controller: titleEditingController,
              maxLength: 10,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: 'Title'),
            ),
            //  const SizedBox(
            //     height: 5,
            //   ),
            TextFormField(
              controller: contentEditingController,
              maxLength: 100,
              maxLines: 5,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: 'Content'),
            )
          ],
        ),
      ),
    );
  }

  Future<void> saveNote() async {
    final title = titleEditingController.text;
    final content = contentEditingController.text;

    final newNote = NoteModal.create(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title,
        content: content);

    final _newNote = await NoteDB.instance.createNote(newNote);
    print(_newNote);
    if (_newNote != null) {
      print('Note Saved');
      Navigator.of(scaffoldKey.currentContext!).pop();
    } else {
      print('Error while saving note');
    }
  }

  FutureOr<void> saveEditedNote() async {
    final editedNote = NoteModal.create(
        id: id,
        title: titleEditingController.text,
        content: contentEditingController.text);
    final updateNote = NoteDB.instance.updateNote(editedNote);
    if (updateNote == null) {
      return null;
    } else {
      Navigator.of(scaffoldKey.currentContext!).pop();
    }
  }
}
