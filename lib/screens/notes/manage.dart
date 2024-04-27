import 'package:badger/models/note.dart';
import 'package:badger/repositories/notes.dart';
import 'package:badger/utils/constants.dart';
import 'package:badger/utils/functions.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ManageNote extends StatefulWidget {
  const ManageNote({super.key});

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

    return PopScope(
      onPopInvoked: (didPop) async {
        if (didPop) {
          if (_titleFocusNode.hasFocus) {
            _titleFocusNode.unfocus();
          }

          if (_bodyFocusNode.hasFocus) {
            _bodyFocusNode.unfocus();
          }

          ScaffoldMessenger.of(context).clearSnackBars();
        }
      },
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleInput(),
            _mode != ManagementModes.view
                ? Flexible(
                    child: _getBodyInput(),
                  )
                : _buildMarkdownPreview(),
            if (_mode != ManagementModes.view) _getFormattingOptionsBar(),
          ],
        ),
      ),
    );
  }

  Widget _getFormattingOptionsBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              _formatAndUpdateBody(MarkdownStyles.bold);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade300
                    : Colors.black54,
                borderRadius: BorderRadius.circular(4.0),
              ),
              padding: const EdgeInsets.all(2.0),
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                Icons.format_bold_rounded,
                size: 24.0,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black54
                    : Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _formatAndUpdateBody(MarkdownStyles.italic);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade300
                    : Colors.black54,
                borderRadius: BorderRadius.circular(4.0),
              ),
              padding: const EdgeInsets.all(2.0),
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                Icons.format_italic_rounded,
                size: 24.0,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black54
                    : Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _formatAndUpdateBody(MarkdownStyles.strikeThrough);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade300
                    : Colors.black54,
                borderRadius: BorderRadius.circular(4.0),
              ),
              padding: const EdgeInsets.all(2.0),
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                Icons.format_strikethrough_rounded,
                size: 24.0,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black54
                    : Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _formatAndUpdateBody(MarkdownStyles.blockQuote);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade300
                    : Colors.black54,
                borderRadius: BorderRadius.circular(4.0),
              ),
              padding: const EdgeInsets.all(2.0),
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                Icons.format_quote_rounded,
                size: 24.0,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black54
                    : Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _formatAndUpdateBody(MarkdownStyles.divider);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade300
                    : Colors.black54,
                borderRadius: BorderRadius.circular(4.0),
              ),
              padding: const EdgeInsets.all(2.0),
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: const Text(
                '---',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _formatAndUpdateBody(MarkdownStyles.inlineCode);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade300
                    : Colors.black54,
                borderRadius: BorderRadius.circular(4.0),
              ),
              padding: const EdgeInsets.all(2.0),
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                Icons.code_rounded,
                size: 24.0,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black54
                    : Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _formatAndUpdateBody(MarkdownStyles.code);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade300
                    : Colors.black54,
                borderRadius: BorderRadius.circular(4.0),
              ),
              padding: const EdgeInsets.all(2.0),
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                width: 24.0,
                height: 24.0,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2.0,
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black54
                                  : Colors.grey.shade300,
                        ),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: const Icon(
                        Icons.code_rounded,
                        size: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _formatAndUpdateBody(MarkdownStyles.unorderedList);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade300
                    : Colors.black54,
                borderRadius: BorderRadius.circular(4.0),
              ),
              padding: const EdgeInsets.all(2.0),
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                Icons.format_list_bulleted_rounded,
                size: 24.0,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black54
                    : Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _formatAndUpdateBody(MarkdownStyles.orderedList);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade300
                    : Colors.black54,
                borderRadius: BorderRadius.circular(4.0),
              ),
              padding: const EdgeInsets.all(2.0),
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                Icons.format_list_numbered_outlined,
                size: 24.0,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black54
                    : Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _formatAndUpdateBody(MarkdownStyles.checkList);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade300
                    : Colors.black54,
                borderRadius: BorderRadius.circular(4.0),
              ),
              padding: const EdgeInsets.all(2.0),
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                Icons.checklist_rounded,
                size: 24.0,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black54
                    : Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _formatAndUpdateBody(MarkdownStyles.image);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade300
                    : Colors.black54,
                borderRadius: BorderRadius.circular(4.0),
              ),
              padding: const EdgeInsets.all(2.0),
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                Icons.image,
                size: 24.0,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black54
                    : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _formatAndUpdateBody(MarkdownStyles style) {
    String originalText = _bodyController.text;
    TextSelection selection = _bodyController.selection;

    final selectionIndependentStyles = [
      MarkdownStyles.inlineCode,
      MarkdownStyles.code,
      MarkdownStyles.blockQuote,
      MarkdownStyles.divider,
      MarkdownStyles.image,
    ];

    if (selection.textInside(originalText).isNotEmpty ||
        selectionIndependentStyles.contains(style)) {
      String selectedText = selection.textInside(originalText);

      int start = selection.start;
      int end = selection.end;

      String formattedText = textToMarkdown(style, selectedText);

      String updatedBody = originalText.replaceRange(start, end, formattedText);

      _bodyController.text = updatedBody;

      TextSelection newSelection = TextSelection.collapsed(offset: end);

      _bodyController.selection = newSelection;
    }
  }

  Widget _getBodyInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 48.0),
      child: TextField(
        controller: _bodyController,
        focusNode: _bodyFocusNode,
        maxLines: null,
        expands: true,
        decoration: const InputDecoration(
          hintText: 'Start from here...',
          hintStyle: TextStyle(),
          border: InputBorder.none,
        ),
        cursorOpacityAnimates: false,
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: _mode != ManagementModes.view
          ? IconButton(
              icon: const Icon(
                Icons.close,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          : null,
      actions: [
        if (_mode == ManagementModes.view)
          PopupMenuButton<String>(
            offset: const Offset(0, kToolbarHeight + 8),
            icon: const Icon(
              Icons.more_vert,
            ),
            elevation: 0,
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
        if (_mode != ManagementModes.view)
          IconButton(
            icon: const Icon(
              Icons.done,
            ),
            onPressed: () {
              if (_mode == ManagementModes.add) {
                _saveNote(context);
              }

              if (_mode == ManagementModes.edit) {
                _updateNote(context);
              }

              Navigator.pop(context);
            },
          ),
      ],
    );
  }

  void _showDeleteNoteConfirmation(BuildContext context) {
    SnackBar snackBar = getSnackBar(
      'Are you sure you want to delete this note?',
      action: SnackBarAction(
          label: 'Delete',
          onPressed: () {
            _notesRepository.delete(_note).then((_) => Navigator.pop(context));
          }),
      duration: const Duration(seconds: 5),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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

  Widget _buildMarkdownPreview() {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_mode == ManagementModes.view) {
            _mode = ManagementModes.edit;
          }
        });
      },
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 24.0,
          ),
          height: screenSize(context).height * 2 / 3,
          child: MarkdownBody(
            data: _note.body,
            fitContent: false,
            styleSheet: MarkdownStyleSheet(
              blockSpacing: 12.0,
              code: const TextStyle(
                fontFamily: 'SourceCodePro',
                fontWeight: FontWeight.w500,
              ),
              codeblockDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              codeblockPadding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              blockquoteDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              blockquotePadding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 8.0),
      child: TextField(
        controller: _titleController,
        focusNode: _titleFocusNode,
        decoration: InputDecoration(
          hintText: 'Enter a title',
          hintStyle: Theme.of(context).textTheme.headlineMedium,
          border: InputBorder.none,
        ),
        style: Theme.of(context).textTheme.headlineMedium,
        cursorOpacityAnimates: false,
        onTap: () {
          setState(() {
            if (_mode == ManagementModes.view) {
              _mode = ManagementModes.edit;
            }
          });
        },
        onSubmitted: (_) {
          setState(() {
            _bodyFocusNode.requestFocus();
          });
        },
      ),
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
      date: DateTime.now().toString(),
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
          date: DateTime.now().toString(),
        ),
      );

      return false;
    }
  }
}
