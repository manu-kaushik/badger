import 'package:badger/providers/exports.dart';
import 'package:badger/utils/colors.dart';
import 'package:badger/utils/enums.dart';
import 'package:badger/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodoTile extends ConsumerWidget {
  final int index;

  const TodoTile({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(todoModeProvider);
    final todos = ref.watch(todosProvider);
    final todosNotifier = ref.read(todosProvider.notifier);
    final currentTodoIndex = ref.watch(currentTodoIndexProvider);
    final todoController = ref.watch(todoInputControllerProvider);
    final todoFocusNode = ref.watch(todoFocusNodeProvider);

    final currentTodoIndexNotifier =
        ref.watch(currentTodoIndexProvider.notifier);

    final isEditMode =
        mode == ManagementModes.edit && currentTodoIndex == index;

    final todo = todos[index];

    if (isEditMode) {
      todoController.text = todo.title;
    }

    bool isCompleted = todo.completed;

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
        title: isEditMode
            ? TextField(
                controller: todoController,
                focusNode: todoFocusNode,
                decoration: const InputDecoration(
                  hintText: 'Enter a todo',
                  border: InputBorder.none,
                ),
                readOnly: mode == ManagementModes.view,
                onSubmitted: (todoTitle) {
                  if (todoTitle.isNotEmpty) {
                    todosNotifier.updateTodo(
                      todo.copyWith(
                        title: todoTitle,
                        date: DateTime.now().toString(),
                      ),
                    );
                  } else {
                    todosNotifier.deleteTodo(todo);

                    SnackBar snackBar = const SnackBar(
                      content: Text('Empty todo deleted'),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }

                  ref
                      .read(todoModeProvider.notifier)
                      .setMode(ManagementModes.view);

                  todoController.clear();
                },
                onTapOutside: (_) {
                  if (mode != ManagementModes.view) {
                    ref
                        .read(todoModeProvider.notifier)
                        .setMode(ManagementModes.view);
                  }
                },
              )
            : GestureDetector(
                onTap: () {
                  if (!todo.completed) {
                    ref
                        .read(todoModeProvider.notifier)
                        .setMode(ManagementModes.edit);

                    currentTodoIndexNotifier.setCurrentTodoIndex(index);

                    todoFocusNode.requestFocus();
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      todo.title,
                      style: TextStyle(
                        decoration:
                            todo.completed ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    if (todo.date != null) const SizedBox(height: 4.0),
                    if (todo.date != null)
                      Text(
                        formatDateToTimeAgo(todo.date!),
                        style: const TextStyle(fontSize: 10.0),
                      ),
                  ],
                ),
              ),
        horizontalTitleGap: 4.0,
        leading: Checkbox(
          value: isCompleted,
          onChanged: (value) async {
            todosNotifier.updateTodo(
              todo.copyWith(
                completed: value,
                date: DateTime.now().toString(),
              ),
            );

            ref.read(todoModeProvider.notifier).setMode(ManagementModes.view);

            todoController.clear();
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
