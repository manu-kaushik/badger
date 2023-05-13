import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';
import 'package:notes/repositories/notes.dart';
import 'package:notes/utils/colors.dart';
import 'package:notes/utils/constants.dart';
import 'package:notes/utils/functions.dart';

class ManageNote extends StatefulWidget {
  const ManageNote({Key? key}) : super(key: key);

  @override
  State<ManageNote> createState() => _ManageNoteState();
}

class _ManageNoteState extends State<ManageNote> {
  final _notesRepository = NotesRepository();

  late NotesMangementModes _mode;

  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _bodyFocusNode = FocusNode();

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();

    _titleFocusNode.dispose();
    _bodyFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setMode(context);

    return WillPopScope(
      onWillPop: () async {
        if (_titleFocusNode.hasFocus) {
          _titleFocusNode.unfocus();

          return false;
        } else if (_bodyFocusNode.hasFocus) {
          _bodyFocusNode.unfocus();

          return false;
        }

        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: TextField(
            controller: _titleController,
            focusNode: _titleFocusNode,
            decoration: InputDecoration(
              hintText: 'Enter a title',
              hintStyle: TextStyle(color: darkColor),
              border: InputBorder.none,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.done_rounded),
              color: primaryColor,
              onPressed: () {
                _saveNote(context).then((bool isNoteSaved) {
                  if (isNoteSaved) {
                    Navigator.pop(context);
                  }
                });
              },
            )
          ],
          backgroundColor: primaryColor.shade50,
          elevation: 0,
          iconTheme: IconThemeData(color: primaryColor),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 16.0,
          ),
          child: TextField(
            controller: _bodyController,
            focusNode: _bodyFocusNode,
            maxLines: null,
            expands: true,
            decoration: InputDecoration(
              hintText: 'Start writing here...',
              hintStyle: TextStyle(color: darkColor),
              border: InputBorder.none,
            ),
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

  Future<bool> _saveNote(BuildContext context) async {
    int id = await _notesRepository.getLastInsertedId() + 1;
    String title = _titleController.text;
    String body = _bodyController.text;

    if (title == '') {
      SnackBar snackBar = getSnackBar('Note title cannot be empty');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      return false;
    } else if (body == '') {
      SnackBar snackBar = getSnackBar('Note body cannot be empty');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      return false;
    } else {
      final note = Note(
        id: id,
        title: title,
        body: body,
      );

      await _notesRepository.insert(note);

      return true;
    }
  }
}
