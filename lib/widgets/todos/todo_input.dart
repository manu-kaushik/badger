import 'package:badger/models/todo_model.dart';
import 'package:badger/repositories/todos_repository.dart';
import 'package:badger/utils/colors.dart';
import 'package:badger/utils/enums.dart';
import 'package:flutter/material.dart';

class TodoInput extends StatefulWidget {
  final bool isEditMode;
  final FocusNode todoFocusNode;
  final TextEditingController todoController;
  final TodosRepository todosRepository;
  final Function(ManagementModes) setMode;

  const TodoInput({
    super.key,
    required this.isEditMode,
    required this.todoFocusNode,
    required this.todoController,
    required this.todosRepository,
    required this.setMode,
  });

  @override
  State<TodoInput> createState() => _TodoInputState();
}

class _TodoInputState extends State<TodoInput> {
  late TodosRepository todosRepository;

  @override
  void initState() {
    super.initState();

    todosRepository = widget.todosRepository;
  }

  @override
  Widget build(BuildContext context) {
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
        title: TextField(
          controller: widget.todoController,
          focusNode: widget.todoFocusNode,
          decoration: const InputDecoration(
            hintText: 'Enter a todo',
            border: InputBorder.none,
          ),
          readOnly: widget.isEditMode,
          onSubmitted: (todoTitle) async {
            if (todoTitle.isNotEmpty) {
              final todo = TodoModel(
                id: await todosRepository.getLastInsertedId() + 1,
                title: todoTitle,
                date: DateTime.now().toString(),
              );

              todosRepository.insert(todo);
            } else {
              SnackBar snackBar = const SnackBar(
                content: Text('Empty todo discarded'),
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }

            setState(() {
              widget.setMode(ManagementModes.view);
            });

            widget.todoController.clear();
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
      ),
    );
  }
}
