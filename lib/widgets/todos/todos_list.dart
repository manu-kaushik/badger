import 'package:badger/models/todo_model.dart';
import 'package:badger/repositories/todos_repository.dart';
import 'package:badger/utils/enums.dart';
import 'package:badger/widgets/common/empty_state_view.dart';
import 'package:badger/widgets/common/error_state_view.dart';
import 'package:badger/widgets/todos/todo_input.dart';
import 'package:badger/widgets/todos/todo_tile.dart';
import 'package:flutter/material.dart';

class TodosList extends StatelessWidget {
  final ManagementModes mode;
  final int currentTodoIndex;
  final FocusNode todoFocusNode;
  final TextEditingController todoController;
  final TodosRepository todosRepository;
  final Function(ManagementModes) setMode;

  const TodosList({
    super.key,
    required this.mode,
    required this.currentTodoIndex,
    required this.todoFocusNode,
    required this.todoController,
    required this.todosRepository,
    required this.setMode,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList.list(
      children: [
        const SizedBox(
          height: 16.0,
        ),
        FutureBuilder<List<TodoModel>>(
          future: todosRepository.getAll(order: Orders.asc),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final todos = snapshot.data!;

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 16.0),
                itemCount: todos.isEmpty
                    ? 1
                    : (mode == ManagementModes.add
                        ? todos.length + 1
                        : todos.length),
                itemBuilder: (context, index) {
                  if (todos.isEmpty && index == 0) {
                    if (mode == ManagementModes.add) {
                      todoFocusNode.requestFocus();

                      return TodoInput(
                        isEditMode: mode == ManagementModes.edit && currentTodoIndex == index,
                        todoFocusNode: todoFocusNode,
                        todoController: todoController,
                        todosRepository: todosRepository, 
                        setMode: setMode,
                      );
                    } else {
                      return const EmptyStateView(
                        icon: Icons.view_list_rounded,
                        text: 'No todos yet! Try adding one!',
                      );
                    }
                  } else if (index == todos.length) {
                    todoFocusNode.requestFocus();

                    return TodoInput(
                        isEditMode: mode == ManagementModes.edit && currentTodoIndex == index,
                      todoFocusNode: todoFocusNode,
                      todoController: todoController,
                      todosRepository: todosRepository,
                        setMode: setMode,
                    );
                  }

                  final todo = todos[index];

                  return TodoTile(
                    todo: todo,
                    mode: mode,
                    currentTodoIndex: currentTodoIndex,
                    index: index,
                    todoFocusNode: todoFocusNode,
                    todoController: todoController,
                    todosRepository: todosRepository,
                  );
                },
              );
            } else if (snapshot.hasError) {
              return const ErrorStateView();
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
