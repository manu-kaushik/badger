import 'package:badger/models/todo_model.dart';
import 'package:badger/repositories/todos_repository.dart';
import 'package:badger/utils/colors.dart';
import 'package:badger/utils/enums.dart';
import 'package:badger/utils/functions.dart';
import 'package:flutter/material.dart';

class TodoTile extends StatefulWidget {
  final TodoModel todo;
  final ManagementModes mode;
  final int currentTodoIndex;
  final int index;
  final FocusNode todoFocusNode;
  final TextEditingController todoController;
  final TodosRepository todosRepository;

  const TodoTile({
    super.key,
    required this.todo,
    required this.mode,
    required this.currentTodoIndex,
    required this.index,
    required this.todoFocusNode,
    required this.todoController,
    required this.todosRepository,
  });

  @override
  State<TodoTile> createState() => _TodoTileState();
}

class _TodoTileState extends State<TodoTile> {
  bool isEditMode = false;

  late ManagementModes mode;
  late int currentTodoIndex;
  late int index;
  late TodoModel todo;
  late TodosRepository todosRepository;

  @override
  void initState() {
    super.initState();

    mode = widget.mode;

    currentTodoIndex = widget.currentTodoIndex;
    index = widget.index;

    todo = widget.todo;

    todosRepository = widget.todosRepository;

    isEditMode = mode == ManagementModes.edit && currentTodoIndex == index;
  }

  @override
  Widget build(BuildContext context) {
    if (isEditMode) {
      widget.todoController.text = todo.title;
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.black54,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: primaryColor.shade200,
          ),
        ],
      ),
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: isEditMode
            ? TextField(
                controller: widget.todoController,
                focusNode: widget.todoFocusNode,
                decoration: const InputDecoration(
                  hintText: 'Enter a todo',
                  border: InputBorder.none,
                ),
                readOnly: mode == ManagementModes.view,
                onSubmitted: (todoTitle) {
                  if (todoTitle.isNotEmpty) {
                    todosRepository.update(
                      todo.copyWith(
                        title: todoTitle,
                        date: DateTime.now().toString(),
                      ),
                    );
                  } else {
                    todosRepository.delete(todo);

                    SnackBar snackBar = const SnackBar(
                      content: Text('Empty todo deleted'),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }

                  setState(() {
                    mode = ManagementModes.view;
                  });

                  widget.todoController.clear();
                },
                onTapOutside: (_) {
                  if (mode != ManagementModes.view) {
                    setState(() {
                      mode = ManagementModes.view;
                    });
                  }
                },
              )
            : GestureDetector(
                onTap: () {
                  if (!todo.completed) {
                    setState(() {
                      mode = ManagementModes.edit;
                      currentTodoIndex = index;
                    });
                    widget.todoFocusNode.requestFocus();
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
                    if (todo.date != null)
                      const SizedBox(
                        height: 4.0,
                      ),
                    if (todo.date != null)
                      Text(
                        formatDateToTimeAgo(todo.date!),
                        style: const TextStyle(
                          fontSize: 12.0,
                        ),
                      )
                  ],
                ),
              ),
        horizontalTitleGap: 4.0,
        leading: Checkbox(
          value: todo.completed,
          onChanged: (value) async {
            await todosRepository.update(
              todo.copyWith(
                completed: value,
                date: DateTime.now().toString(),
              ),
            );

            setState(() {
              mode = ManagementModes.view;
            });

            widget.todoController.clear();
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
