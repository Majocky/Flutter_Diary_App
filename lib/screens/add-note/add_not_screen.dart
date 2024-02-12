import 'package:flutter/material.dart';
import 'package:sqliteflutter/models/note.dart';
import 'package:sqliteflutter/repository/notes_repo.dart';

class AddNoteScreen extends StatefulWidget {
  final Note? note;
  const AddNoteScreen({super.key, this.note});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final title = TextEditingController();
  final description = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    if (widget.note != null) {
      title.text = widget.note!.title;
      description.text = widget.note!.description;

      print(description.text);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Note"),
        centerTitle: true,
        actions: [
          widget.note != null
              ? IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              content: const Text(
                                  'Are you sure you want to delete this note?'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("No")),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _deleteNote();
                                    },
                                    child: const Text("Yes"))
                              ],
                            ));
                  },
                  icon: Icon(Icons.delete_outlined),
                )
              : const SizedBox(),
          IconButton(
            onPressed: widget.note == null ? _insertNote : _updateNote,
            icon: Icon(Icons.done),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          TextField(
            controller: title,
            decoration: InputDecoration(
                hintText: "Title",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: TextField(
              controller: description,
              decoration: InputDecoration(
                  hintText: "Start tying here....",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
              maxLines: 40,
            ),
          )
        ]),
      ),
    );
  }

  _insertNote() async {
    final note = Note(
        title: title.text,
        description: description.text,
        createdAt: DateTime.now());
    await NotesRepository.insert(note: note);
  }

  _updateNote() async {
    final note = Note(
        id: widget.note!.id!,
        title: title.text,
        description: description.text,
        createdAt: widget.note!.createdAt);
    await NotesRepository.updateNote(note: note);
  }

  _deleteNote() async {
    NotesRepository.delete(note: widget.note!).then((e) {
      Navigator.pop(context);
    });
  }
}
