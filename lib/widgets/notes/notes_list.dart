import 'package:badger/models/note_model.dart';
import 'package:badger/repositories/notes_repository.dart';
import 'package:badger/widgets/common/empty_state_view.dart';
import 'package:badger/widgets/common/error_state_view.dart';
import 'package:badger/widgets/notes/note_card.dart';
import 'package:flutter/material.dart';

class NotesList extends StatefulWidget {
  const NotesList({super.key});

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  final notesRepository = NotesRepository();

  @override
  Widget build(BuildContext context) {
    return SliverList.list(
      children: [
        const SizedBox(
          height: 16.0,
        ),
        FutureBuilder<List<NoteModel>>(
          future: notesRepository.getAll(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 1.0,
                ),
              );
            } else if (snapshot.hasError) {
              return const ErrorStateView();
            } else if (snapshot.data!.isEmpty) {
              return const EmptyStateView(
                icon: Icons.note,
                text: 'No notes yet! Try adding one!',
              );
            } else {
              final notes = snapshot.data!;

              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 16.0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];

                  return NoteCard(
                    note: note,
                  );
                },
              );
            }
          },
        ),
      ],
    );
  }
}
