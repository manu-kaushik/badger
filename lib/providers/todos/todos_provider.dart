import 'package:badger/models/exports.dart';
import 'package:badger/repositories/exports.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodosNotifier extends Notifier<List<TodoModel>> {
  final TodosRepository _repository = TodosRepository();

  TodosNotifier() {
    loadTodos();
  }

  @override
  List<TodoModel> build() {
    return [];
  }

  Future<void> loadTodos() async {
    state = await _repository.getAll();
  }

  void addTodo(TodoModel todo) async {
    state = [...state, todo];

    await _repository.insert(todo);
  }

  void updateTodo(TodoModel todo) async {
    final index = state.indexWhere((element) => element.id == todo.id);

    if (index >= 0) {
      state = [...state.take(index), todo, ...state.skip(index + 1)];

      await _repository.update(todo);
    }
  }

  void deleteTodo(TodoModel todo) async {
    state = state.where((element) => element.id != todo.id).toList();

    await _repository.delete(todo);
  }

  void deleteCompletedTodos() async {
    state = state.where((element) => !element.isComplete).toList();

    await _repository.deleteCompletedTodos();
  }
}

final todosProvider = NotifierProvider<TodosNotifier, List<TodoModel>>(() {
  return TodosNotifier();
});
