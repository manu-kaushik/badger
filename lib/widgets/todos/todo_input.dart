import 'package:badger/models/todo_model.dart';
import 'package:badger/providers/exports.dart';
import 'package:badger/repositories/todos_repository.dart';
import 'package:badger/utils/colors.dart';
import 'package:badger/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodoInput extends ConsumerWidget {
  final bool isEditMode;

  const TodoInput({
    super.key,
    required this.isEditMode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosNotifier = ref.read(todosProvider.notifier);
    final todosRepository = TodosRepository();
    final todoController = ref.watch(todoInputControllerProvider);
    final todoFocusNode = ref.watch(todoFocusNodeProvider);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? primaryColor.shade50
            : Colors.black38,
        borderRadius: BorderRadius.circular(16.0),
      ),
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: TextField(
          controller: todoController,
          focusNode: todoFocusNode,
          decoration: const InputDecoration(
            hintText: 'Enter a todo',
            border: InputBorder.none,
          ),
          readOnly: isEditMode,
          onSubmitted: (todoTitle) async {
            if (todoTitle.isNotEmpty) {
              final todo = TodoModel(
                id: await todosRepository.getLastInsertedId() + 1,
                title: todoTitle,
                date: DateTime.now().toString(),
              );

              todosNotifier.addTodo(todo);
            } else {
              SnackBar snackBar = const SnackBar(
                content: Text('Empty todo discarded'),
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }

            ref.read(todoModeProvider.notifier).setMode(ManagementModes.view);

            todoController.clear();
          },
        ),
        leading: Checkbox(
          value: false,
          onChanged: (_) async {},
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: const BorderSide(width: 2.0),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () {
            ref.read(todoModeProvider.notifier).setMode(ManagementModes.view);
          },
        ),
      ),
    );
  }
}
