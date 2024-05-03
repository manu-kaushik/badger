import 'package:badger/providers/notes/notes_provider.dart';
import 'package:badger/widgets/common/empty_state_view.dart';
import 'package:badger/widgets/notes/note_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotesList extends ConsumerWidget {
  const NotesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(notesProvider);

    return SliverList.list(
      children: [
        const SizedBox(
          height: 16.0,
        ),
        notes.isEmpty
            ? const EmptyStateView(
                icon: Icons.note,
                text: 'No notes yet! Try adding one!',
              )
            : ListView.builder(
                padding: const EdgeInsets.only(bottom: 16.0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: notes.length,
                itemBuilder: (context, index) => NoteCard(index: index),
              ),
      ],
    );
  }
}
