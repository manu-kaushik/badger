import 'package:badger/models/note_model.dart';
import 'package:badger/repositories/notes_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotesNotifier extends Notifier<List<NoteModel>> {
  final NotesRepository _repository = NotesRepository();

  NotesNotifier() {
    loadNotes();
  }

  @override
  List<NoteModel> build() {
    return [];
  }

  Future<void> loadNotes() async {
    state = await _repository.getAll();
  }

  void addNote(NoteModel note) async {
    state = [...state, note];

    await _repository.insert(note);
  }

  void updateNote(NoteModel note) async {
    final index = state.indexWhere((element) => element.id == note.id);

    if (index >= 0) {
      state = [...state.take(index), note, ...state.skip(index + 1)];

      await _repository.update(note);
    }
  }

  void deleteNote(NoteModel note) async {
    state = state.where((element) => element.id != note.id).toList();

    await _repository.delete(note);
  }
}

final notesProvider = NotifierProvider<NotesNotifier, List<NoteModel>>(() {
  return NotesNotifier();
});
