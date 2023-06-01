import 'package:flutter/material.dart';
import 'package:badger/models/note.dart';
import 'package:badger/repositories/notes.dart';
import 'package:badger/utils/colors.dart';

import 'package:badger/utils/constants.dart';

class NotesTab extends StatefulWidget {
  const NotesTab({Key? key}) : super(key: key);

  @override
  State<NotesTab> createState() => _NotesTabState();
}

class _NotesTabState extends State<NotesTab> {
  final _notesRepository = NotesRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _getAppBar(),
      body: _buildNotesList(),
      floatingActionButton: _getAddNoteBtn(context),
    );
  }

  FloatingActionButton _getAddNoteBtn(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'addNoteBtn',
      onPressed: () {
        Navigator.pushNamed(
          context,
          manageNoteRoute,
          arguments: {
            'mode': ManagementModes.add,
          },
        ).then((_) => setState(() {}));
      },
      child: const Icon(Icons.edit_note),
    );
  }

  FutureBuilder<List<Note>> _buildNotesList() {
    return FutureBuilder<List<Note>>(
      future: _notesRepository.getAll(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: themeColor,
              strokeWidth: 1.0,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Something went wrong!',
              style: TextStyle(color: themeColor),
            ),
          );
        } else if (snapshot.data!.isEmpty) {
          return _getNoNotesView();
        } else {
          final notes = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 48.0),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return _buildNoteCard(context, note);
            },
          );
        }
      },
    );
  }

  AppBar _getAppBar() {
    return AppBar(
      title: Row(
        children: [
          Image.asset(
            'assets/images/icons/app_icon.png',
            width: 36.0,
            height: 36.0,
          ),
          const SizedBox(
            width: 16.0,
          ),
          Text(
            'Notes',
            style: TextStyle(
              color: themeColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard(BuildContext context, Note note) {
    return InkWell(
      onTap: () async {
        await Navigator.pushNamed(
          context,
          manageNoteRoute,
          arguments: {
            'mode': ManagementModes.view,
            'note': note,
          },
        );

        setState(() {});
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        color: themeColor.shade100,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                _getTrimmedContent(note.body),
                style: const TextStyle(
                  fontSize: 16.0,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getNoNotesView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.note,
            color: themeColor.shade400,
            size: 48.0,
          ),
          const SizedBox(
            height: 16.0,
          ),
          Text(
            'No notes yet! Try adding one!',
            style: TextStyle(color: themeColor),
          ),
        ],
      ),
    );
  }

  String _getTrimmedContent(String body, {int length = 48}) {
    if (body.length > length) {
      return '${body.substring(0, length)}...';
    } else {
      return body;
    }
  }
}
