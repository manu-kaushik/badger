import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';
import 'package:notes/repositories/notes.dart';
import 'package:notes/utils/constants.dart';

class ManageNote extends StatefulWidget {
  const ManageNote({Key? key}) : super(key: key);

  @override
  State<ManageNote> createState() => _ManageNoteState();
}

class _ManageNoteState extends State<ManageNote> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  final _notesRepository = NotesRepository();

  Future<void> _saveNote() async {
    int id = await _notesRepository.getLastInsertedId() + 1;
    String title = _titleController.text;
    String body = _bodyController.text;

    if (_formKey.currentState!.validate()) {
      final note = Note(
        id: id,
        title: title,
        body: body,
      );

      await _notesRepository.insert(note);
    }
  }

  late NotesMangementModes _mode;

  @override
  Widget build(BuildContext context) {
    setMode(context);

    return Scaffold(
      appBar: AppBar(
        title: getTitle(),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              _saveNote().then((_) {
                Navigator.pop(context);
              });
            },
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _bodyController,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget? getTitle() => _mode == NotesMangementModes.add
      ? const Text('Add Note')
      : _mode == NotesMangementModes.edit
          ? const Text('Edit Note')
          : null;

  void setMode(BuildContext context) {
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    _mode = arguments['mode'];
  }
}
