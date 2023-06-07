import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:badger/models/note.dart';
import 'package:badger/repositories/notes.dart';
import 'package:badger/utils/colors.dart';
import 'package:badger/utils/constants.dart';
import 'package:badger/utils/functions.dart';

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

  bool _initialModeSetup = true;
  bool _initialNoteSetup = true;
  bool _initialFocus = true;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();

    _titleFocusNode.dispose();
    _bodyFocusNode.dispose();

    super.dispose();
  }

  void _setInitialInputFocus() {
    if (_mode != ManagementModes.view && _initialFocus) {
      _titleFocusNode.requestFocus();
    }

    _initialFocus = false;
  }

  @override
  Widget build(BuildContext context) {
    _setMode(context);
    _setNote(context);
    _setInitialInputFocus();

    return WillPopScope(
      onWillPop: () async {
        if (_titleFocusNode.hasFocus) {
          _titleFocusNode.unfocus();
        }

        if (_bodyFocusNode.hasFocus) {
          _bodyFocusNode.unfocus();
        }

        if (_mode == ManagementModes.add) {
          bool shouldClose = await _saveNote(context);

          if (shouldClose) {
            return true;
          }

          setState(() {
            _mode = ManagementModes.view;
          });

          return false;
        }

        if (_mode == ManagementModes.edit) {
          bool shouldClose = await _updateNote(context);

          if (shouldClose) {
            return true;
          }

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
        appBar: _buildAppBar(context),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return _mode == ManagementModes.view
        ? GestureDetector(
            onTap: () {
              if (_mode == ManagementModes.view) {
                setState(() {
                  _mode = ManagementModes.edit;
                });

                _bodyFocusNode.requestFocus();
              }
            },
            child: _buildMarkdownPreview(),
          )
        : _getBodyInput();
  }

  Widget _getBodyInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 24.0,
      ),
      child: TextField(
        controller: _bodyController,
        focusNode: _bodyFocusNode,
        maxLines: null,
        expands: true,
        decoration: InputDecoration(
          hintText: 'Start writing here...',
          hintStyle: TextStyle(color: themeColor),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildMarkdownPreview() {
    return Container(
      width: screenSize(context).width,
      height: screenSize(context).height,
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 24.0,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
      ),
      child: MarkdownBody(
        data: _note.body,
        fitContent: false,
        styleSheet: MarkdownStyleSheet(
          blockSpacing: 12.0,
          code: TextStyle(
            color: themeColor,
            backgroundColor: themeColor.shade50,
            fontFamily: 'SourceCodePro',
            fontWeight: FontWeight.w500,
          ),
          codeblockDecoration: BoxDecoration(
            color: themeColor.shade50,
            borderRadius: BorderRadius.circular(8.0),
          ),
          codeblockPadding:
              const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          blockquoteDecoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(8.0),
          ),
          blockquotePadding:
              const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: _buildTitleInput(),
      actions: [
        if (_mode == ManagementModes.view)
          PopupMenuButton<String>(
            offset: const Offset(0, kToolbarHeight + 8),
            icon: Icon(
              Icons.more_vert,
              color: themeColor, // Set the desired color here
            ),
            elevation: 0,
            color: themeColor.shade50,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'copyNoteBody',
                child: Text('Copy Note Body'),
              ),
              const PopupMenuItem(
                value: 'deleteNote',
                child: Text('Delete Note'),
              ),
            ],
            onSelected: (value) {
              if (value == 'copyNoteBody') {
                _copyNoteBody(context);
              }

              if (value == 'deleteNote') {
                _showDeleteNoteConfirmation(context);
              }
            },
          ),
      ],
    );
  }

  void _showDeleteNoteConfirmation(BuildContext context) {
    if (_mode == ManagementModes.add) {
      SnackBar snackBar = getSnackBar(
        'Note discarded',
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Navigator.pop(context);
    } else {
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
  }

  void _copyNoteBody(BuildContext context) {
    if (_bodyController.text.isNotEmpty) {
      FlutterClipboard.copy(_note.body).then((_) {
        SnackBar snackBar = getSnackBar('Copied note body to clipboard');

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }).catchError((_) {
        SnackBar snackBar = getSnackBar(
          'Something went wrong!',
          type: AlertTypes.error,
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    } else {
      SnackBar snackBar = getSnackBar('Did not copy as the note body is empty');

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  TextField _buildTitleInput() {
    return TextField(
      controller: _titleController,
      focusNode: _titleFocusNode,
      decoration: InputDecoration(
        hintText: 'Enter a title',
        hintStyle: TextStyle(color: themeColor),
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
      onSubmitted: (_) {
        _bodyFocusNode.requestFocus();
      },
    );
  }

  void _setMode(BuildContext context) {
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    if (_mode != ManagementModes.edit && _initialModeSetup) {
      _mode = arguments['mode'] as ManagementModes;
    }

    _initialModeSetup = false;
  }

  void _setNote(BuildContext context) {
    if (_mode != ManagementModes.add && _initialNoteSetup) {
      Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

      _note = arguments['note'] as Note;

      _titleController.text = _note.title;
      _bodyController.text = _note.body;
    }

    _initialNoteSetup = false;
  }

  Future<bool> _saveNote(BuildContext context) async {
    int id = await _notesRepository.getLastInsertedId() + 1;

    String title = _titleController.text.trim();
    String body = _bodyController.text.trim();

    _note = Note(
      id: id,
      title: title,
      body: body,
      date: getCurrentTimestamp(),
    );

    if (title == '' && body == '') {
      SnackBar snackBar = getSnackBar('Empty note discarded');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      return true;
    } else {
      final note = _note;

      await _notesRepository.insert(note);

      return false;
    }
  }

  Future<bool> _updateNote(BuildContext context) async {
    String title = _titleController.text.trim();
    String body = _bodyController.text.trim();

    _note.title = title;
    _note.body = body;

    if (title == '' && body == '') {
      _notesRepository.delete(_note);

      SnackBar snackBar = getSnackBar('Note deleted');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      return true;
    } else {
      await _notesRepository.update(
        _note.copyWith(
          title: title,
          body: body,
          date: getCurrentTimestamp(),
        ),
      );

      return false;
    }
  }
}
