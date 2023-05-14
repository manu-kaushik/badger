import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart';
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

  ManagementModes _mode = ManagementModes.view;

  late Note _note;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

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
    setNote(context);

    return WillPopScope(
      onWillPop: () async {
        if (_titleFocusNode.hasFocus) {
          _titleFocusNode.unfocus();

          return false;
        }
        if (_bodyFocusNode.hasFocus) {
          _bodyFocusNode.unfocus();

          return false;
        }

        if (_mode == ManagementModes.edit) {
          setState(() {
            _mode = ManagementModes.view;
          });

          return false;
        }

        ScaffoldMessenger.of(context).clearSnackBars();

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
            readOnly: _mode == ManagementModes.view,
            onTap: () {
              if (_mode == ManagementModes.view) {
                setState(() {
                  _mode = ManagementModes.edit;
                });
              }
            },
          ),
          actions: [
            Visibility(
              visible: _mode != ManagementModes.view,
              child: IconButton(
                icon: getActionIcon(),
                color: notesThemeColor,
                onPressed: () {
                  if (_mode == ManagementModes.add) {
                    _saveNote(context).then((bool isNoteSaved) {
                      if (isNoteSaved) {
                        Navigator.pop(context);
                      }
                    });
                  }

                  if (_mode == ManagementModes.edit) {
                    _updateNote(context).then((bool isNoteUpdated) {
                      if (isNoteUpdated) {
                        Navigator.pop(context);
                      }
                    });
                  }
                },
              ),
            ),
            Visibility(
              visible: _mode == ManagementModes.view,
              child: IconButton(
                icon: const Icon(Icons.delete_outline_rounded),
                color: Colors.red,
                onPressed: () {
                  if (_mode != ManagementModes.add) {
                    SnackBar snackBar = getSnackBar(
                      'Are you sure you want to delete this note?',
                      action: SnackBarAction(
                          label: 'Delete',
                          textColor: Colors.red,
                          onPressed: () {
                            _notesRepository
                                .delete(_note)
                                .then((_) => Navigator.pop(context));
                          }),
                      duration: const Duration(seconds: 5),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
              ),
            ),
          ],
          backgroundColor: notesThemeColor.shade50,
          elevation: 0,
          iconTheme: IconThemeData(color: notesThemeColor),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 24.0,
          ),
          child: _mode == ManagementModes.view
              ? GestureDetector(
                  onTap: () {
                    if (_mode == ManagementModes.view) {
                      setState(() {
                        _mode = ManagementModes.edit;
                      });
                    }
                  },
                  child: MarkdownBody(
                    data: _note.body,
                    extensionSet: ExtensionSet(
                      ExtensionSet.gitHubFlavored.blockSyntaxes,
                      [
                        EmojiSyntax(),
                        ...ExtensionSet.gitHubFlavored.inlineSyntaxes,
                      ],
                    ),
                  ),
                )
              : TextField(
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

  Icon getActionIcon() {
    if (_mode == ManagementModes.view) {
      return const Icon(Icons.edit_rounded);
    } else {
      return const Icon(Icons.done_rounded);
    }
  }

  void setMode(BuildContext context) {
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    if (_mode != ManagementModes.edit) {
      _mode = arguments['mode'] as ManagementModes;
    }
  }

  void setNote(BuildContext context) {
    if (_mode != ManagementModes.add) {
      Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

      _note = arguments['note'] as Note;

      _titleController.text = _note.title;
      _bodyController.text = _note.body;
    }
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

  Future<bool> _updateNote(BuildContext context) async {
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
      await _notesRepository.update(_note.copyWith(
        title: title,
        body: body,
      ));

      return true;
    }
  }
}
