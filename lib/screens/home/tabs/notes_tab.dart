import 'package:badger/screens/notes/manage_note_screen.dart';
import 'package:badger/utils/enums.dart';
import 'package:badger/widgets/notes/notes_list.dart';
import 'package:flutter/material.dart';

class NotesTab extends StatelessWidget {
  const NotesTab({super.key});

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
              surfaceTintColor: Colors.transparent,
            ),
            const NotesList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addNoteBtn',
        onPressed: () {
          Navigator.pushNamed(
            context,
            ManageNoteScreen.routePath,
            arguments: {
              'mode': ManagementModes.add,
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
