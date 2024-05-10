import 'package:badger/models/exports.dart';
import 'package:badger/providers/exports.dart';
import 'package:badger/repositories/exports.dart';
import 'package:badger/utils/exports.dart';
import 'package:badger/widgets/exports.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageNoteScreen extends ConsumerStatefulWidget {
  static const String routePath = '/manage_note';

  const ManageNoteScreen({super.key});

  @override
  ConsumerState<ManageNoteScreen> createState() => _ManageNoteScreenState();
}

class _ManageNoteScreenState extends ConsumerState<ManageNoteScreen> {
  ManagementModes mode = ManagementModes.view;

  late NoteModel note;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  final FocusNode titleFocusNode = FocusNode();
  final FocusNode bodyFocusNode = FocusNode();

  bool initialModeSetup = true;
  bool initialNoteSetup = true;
  bool initialFocus = true;

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();

    titleFocusNode.dispose();
    bodyFocusNode.dispose();

    super.dispose();
  }

  void setInitialInputFocus() {
    if (mode != ManagementModes.view && initialFocus) {
      titleFocusNode.requestFocus();
    }

    initialFocus = false;
  }

  @override
  Widget build(BuildContext context) {
    setMode(context);
    setNote(context);
    setInitialInputFocus();

    return PopScope(
      onPopInvoked: (didPop) async {
        if (didPop) {
          if (titleFocusNode.hasFocus) {
            titleFocusNode.unfocus();
          }

          if (bodyFocusNode.hasFocus) {
            bodyFocusNode.unfocus();
          }

          ScaffoldMessenger.of(context).clearSnackBars();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: mode != ManagementModes.view
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
            if (mode == ManagementModes.view)
              PopupMenuButton<String>(
                offset: const Offset(0, kToolbarHeight + 8),
                icon: const Icon(
                  Icons.more_vert,
                ),
                elevation: 2,
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
                    copyNoteBody(context);
                  }

                  if (value == 'deleteNote') {
                    showDeleteNoteConfirmation(context);
                  }
                },
              ),
            if (mode != ManagementModes.view)
              IconButton(
                icon: const Icon(
                  Icons.done,
                ),
                onPressed: () {
                  if (mode == ManagementModes.add) {
                    saveNote(context);
                  }

                  if (mode == ManagementModes.edit) {
                    updateNote(context);
                  }
                },
              ),
          ],
        ),
        body: mode == ManagementModes.view
            ? SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getTitleInput(),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (mode == ManagementModes.view) {
                            mode = ManagementModes.edit;
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 24.0,
                        ),
                        child: MarkdownBody(
                          data: note.body,
                          fitContent: false,
                          styleSheet: getMarkdownStyleSheet(context),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getTitleInput(),
                  Flexible(
                    child: Padding(
                      padding:
                          const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 48.0),
                      child: TextField(
                        controller: bodyController,
                        focusNode: bodyFocusNode,
                        maxLines: null,
                        expands: true,
                        decoration: const InputDecoration(
                          hintText: 'Start from here...',
                          hintStyle: TextStyle(),
                          border: InputBorder.none,
                        ),
                        cursorOpacityAnimates: false,
                      ),
                    ),
                  ),
                  FormattingOptionsBar(bodyController: bodyController),
                ],
              ),
      ),
    );
  }

  Widget getTitleInput() {
    return NoteTitleInput(
      titleController: titleController,
      titleFocusNode: titleFocusNode,
      bodyFocusNode: bodyFocusNode,
      onTap: () {
        setState(() {
          if (mode == ManagementModes.view) {
            mode = ManagementModes.edit;
          }
        });
      },
    );
  }

  void showDeleteNoteConfirmation(BuildContext context) {
    final notesNotifier = ref.read(notesProvider.notifier);

    SnackBar snackBar = SnackBar(
      content: const Text(
        'Are you sure you want to delete this note?',
      ),
      action: SnackBarAction(
          label: 'Delete',
          onPressed: () {
            notesNotifier.deleteNote(note);

            Navigator.pop(context);
          }),
      duration: const Duration(seconds: 5),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void copyNoteBody(BuildContext context) {
    if (bodyController.text.isNotEmpty) {
      FlutterClipboard.copy(note.body).then((_) {
        SnackBar snackBar = const SnackBar(
          content: Text('Copied note body to clipboard'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }).catchError((_) {
        SnackBar snackBar = const SnackBar(
          content: Text(
            'Something went wrong!',
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    } else {
      SnackBar snackBar = const SnackBar(
        content: Text('Did not copy as the note body is empty'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void setMode(BuildContext context) {
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    if (mode != ManagementModes.edit && initialModeSetup) {
      mode = arguments['mode'] as ManagementModes;
    }

    initialModeSetup = false;
  }

  void setNote(BuildContext context) {
    if (mode != ManagementModes.add && initialNoteSetup) {
      Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

      note = arguments['note'] as NoteModel;

      titleController.text = note.title;
      bodyController.text = note.body;
    }

    initialNoteSetup = false;
  }

  Future<void> saveNote(BuildContext context) async {
    final notesRepository = NotesRepository();
    final notesNotifier = ref.read(notesProvider.notifier);

    int id = await notesRepository.getLastInsertedId() + 1;

    String title = titleController.text.trim();
    String body = bodyController.text.trim();

    note = NoteModel(
      id: id,
      title: title,
      body: body,
      date: DateTime.now().toString(),
    );

    if (title == '' && body == '') {
      SnackBar snackBar = const SnackBar(
        content: Text('Empty note discarded'),
      );

      if (context.mounted) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      notesNotifier.addNote(note);

      setState(() {
        mode = ManagementModes.view;
      });
    }
  }

  void updateNote(BuildContext context) {
    String title = titleController.text.trim();
    String body = bodyController.text.trim();

    final notesNotifier = ref.read(notesProvider.notifier);

    note.title = title;
    note.body = body;

    if (title == '' && body == '') {
      notesNotifier.deleteNote(note);

      SnackBar snackBar = const SnackBar(
        content: Text('Note deleted'),
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      Navigator.pop(context);
    } else {
      notesNotifier.updateNote(
        note.copyWith(
          title: title,
          body: body,
          date: DateTime.now().toString(),
        ),
      );

      setState(() {
        mode = ManagementModes.view;
      });
    }
  }
}
