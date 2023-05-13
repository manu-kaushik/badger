import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';
import 'package:notes/repositories/notes.dart';
import 'package:notes/utils/colors.dart';

import '../../../utils/constants.dart';

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
      body: FutureBuilder<List<Note>>(
        future: _notesRepository.getAll(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final notes = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 48),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];

                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      manageNoteRoute,
                      arguments: {
                        'mode': ManagementModes.view,
                        'note': note,
                      },
                    ).then((_) => setState(() {}));
                  },
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    color: primaryColor.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            getShortContent(note.body),
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong!',
                style: TextStyle(color: darkColor),
              ),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: Text(
                'No notes yet! Try adding one!',
                style: TextStyle(color: darkColor),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: primaryColor,
                strokeWidth: 1,
              ),
            );
          }
        },
      ),
    );
  }

  String getShortContent(String body, {int length = 48}) {
    if (body.length > length) {
      return '${body.substring(0, length)}...';
    } else {
      return body;
    }
  }
}
