import 'package:badger/models/note.dart';
import 'package:badger/repositories/notes.dart';
import 'package:badger/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:timeago/timeago.dart';

class NotesTab extends StatefulWidget {
  const NotesTab({super.key});

  @override
  State<NotesTab> createState() => _NotesTabState();
}

class _NotesTabState extends State<NotesTab> {
  final _notesRepository = NotesRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 144.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Notes',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                titlePadding: const EdgeInsets.only(bottom: 16.0),
                expandedTitleScale: 2.0,
              ),
            ),
            SliverList.list(
              children: [
                const SizedBox(
                  height: 16.0,
                ),
                _buildNotesList(),
              ],
            ),
          ],
        ),
      ),
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
      child: const Icon(Icons.add),
    );
  }

  FutureBuilder<List<Note>> _buildNotesList() {
    return FutureBuilder<List<Note>>(
      future: _notesRepository.getAll(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 1.0,
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Something went wrong!',
            ),
          );
        } else if (snapshot.data!.isEmpty) {
          return _getNoNotesView();
        } else {
          final notes = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 16.0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
        ),
        margin: const EdgeInsets.only(bottom: 12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (note.title.isNotEmpty)
                Text(
                  note.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              if (note.title.isNotEmpty) const SizedBox(height: 8.0),
              if (note.body.isNotEmpty)
                MarkdownBody(
                  data: _getTrimmedContent(note.body),
                ),
              if (note.date != null)
                Text(
                  format(DateTime.parse(note.date!)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getNoNotesView() {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(
        vertical: 128.0,
      ),
      child: const Column(
        children: [
          Icon(
            Icons.note,
            size: 48.0,
          ),
          SizedBox(
            height: 16.0,
          ),
          Text(
            'No notes yet! Try adding one!',
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
