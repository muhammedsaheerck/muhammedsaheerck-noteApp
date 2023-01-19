import 'package:flutter/material.dart';

import 'package:noteapp/data/data.dart';
import 'package:noteapp/data/note_modal/note_modal.dart';
import 'package:noteapp/screens/screen_add_note.dart';

class ScreenAllNotes extends StatelessWidget {
  const ScreenAllNotes({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await NoteDB.instance.getAllNote();
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Notes', textAlign: TextAlign.center),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ValueListenableBuilder(
              valueListenable: NoteDB.instance.noteListNotifier,
              builder: (context, List<NoteModal> newNotes, _) {
                return GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    children: List.generate(newNotes.length, (index) {
                      final note =
                          NoteDB.instance.noteListNotifier.value[index];
                      if (note.id == null) {
                        const SizedBox();
                      }
                      return NoteItem(
                          id: note.id!,
                          title: note.title ?? 'Note title',
                          content: note.content ?? 'Note content');
                    }));
              }),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 130),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: ((context) => ScreenAddNote(
                      type: ActionType.addNote,
                    ))));
          },
          label: const Text('Add Note'),
        ),
      ),
    );
  }
}

class NoteItem extends StatelessWidget {
  final String id;
  final String title;
  final String content;
  const NoteItem(
      {super.key,
      required this.id,
      required this.title,
      required this.content});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: ((context) => ScreenAddNote(
                  type: ActionType.editNote,
                  id: id,
                ))));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: (() {
                        NoteDB.instance.deleteNote(id);
                      }),
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ))
                ],
              ),
              Expanded(
                  child: Text(
                content,
                overflow: TextOverflow.ellipsis,
                maxLines: 7,
              ))
            ],
          ),
        ),
      ),
    );
  }
}
