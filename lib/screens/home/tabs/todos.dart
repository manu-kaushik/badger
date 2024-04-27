import 'package:badger/models/todo.dart';
import 'package:badger/repositories/todos.dart';
import 'package:badger/utils/colors.dart';
import 'package:badger/utils/constants.dart';
import 'package:badger/utils/functions.dart';
import 'package:flutter/material.dart';

class TodosTab extends StatefulWidget {
  const TodosTab({super.key});

  @override
  State<TodosTab> createState() => _TodosTabState();
}

class _TodosTabState extends State<TodosTab> {
  final _todosRepository = TodosRepository();

  late ManagementModes _mode;

  final TextEditingController _todoController = TextEditingController();

  final FocusNode _todoFocusNode = FocusNode();

  int _currentTodoIndex = -1;

  @override
  void initState() {
    super.initState();

    _mode = ManagementModes.view;
  }

  @override
  void dispose() {
    _todoController.dispose();

    _todoFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          ScaffoldMessenger.of(context).clearSnackBars();

          if (_mode == ManagementModes.add) {
            setState(() {
              _mode = ManagementModes.view;
            });
          }
        }
      },
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 144.0,
                surfaceTintColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Todos',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  titlePadding: const EdgeInsets.only(bottom: 16.0),
                  expandedTitleScale: 2.0,
                ),
                actions: [
                  PopupMenuButton<String>(
                    offset: const Offset(0, kToolbarHeight + 8),
                    icon: const Icon(
                      Icons.more_vert, // Set the desired color here
                    ),
                    elevation: 4,
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'clearCompleted',
                        child: Text('Clear Completed'),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'clearCompleted') {
                        _todosRepository.deleteCompletedTodos();

                        setState(() {});
                      }
                    },
                  ),
                ],
              ),
              SliverList.list(
                children: [
                  const SizedBox(
                    height: 16.0,
                  ),
                  _buildTodosList(),
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: _buildAddTodoBtn(),
      ),
    );
  }

  Widget _buildAddTodoBtn() {
    return Visibility(
      visible: _mode == ManagementModes.view,
      child: FloatingActionButton(
        heroTag: 'addTodoBtn',
        onPressed: () {
          setState(() {
            _mode = ManagementModes.add;
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  FutureBuilder<List<Todo>> _buildTodosList() {
    return FutureBuilder<List<Todo>>(
      future: _todosRepository.getAll(order: Orders.asc),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final todos = snapshot.data!;

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 16.0),
            itemCount: todos.isEmpty
                ? 1
                : (_mode == ManagementModes.add
                    ? todos.length + 1
                    : todos.length),
            itemBuilder: (context, index) {
              if (todos.isEmpty && index == 0) {
                return _mode == ManagementModes.add
                    ? _getTodoInput(context)
                    : _getNoTodosView(context);
              } else if (index == todos.length) {
                return _getTodoInput(context);
              }

              final todo = todos[index];
              return _getTodoTile(index, todo);
            },
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Something went wrong!',
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 1,
            ),
          );
        }
      },
    );
  }

  Container _getNoTodosView(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(
        vertical: 128.0,
      ),
      child: const Column(
        children: [
          Icon(
            Icons.view_list_rounded,
            size: 48.0,
          ),
          SizedBox(
            height: 16.0,
          ),
          Text(
            'No todos yet! Try adding one!',
          ),
        ],
      ),
    );
  }

  Widget _getTodoInput(BuildContext context) {
    _todoFocusNode.requestFocus();

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
          controller: _todoController,
          focusNode: _todoFocusNode,
          decoration: const InputDecoration(
            hintText: 'Enter a todo',
            border: InputBorder.none,
          ),
          readOnly: _mode == ManagementModes.view,
          onSubmitted: (todoTitle) async {
            if (todoTitle.isNotEmpty) {
              final todo = Todo(
                id: await _todosRepository.getLastInsertedId() + 1,
                title: todoTitle,
                date: DateTime.now().toString(),
              );

              _todosRepository.insert(todo);
            } else {
              SnackBar snackBar = getSnackBar('Empty todo discarded');

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }

            setState(() {
              _mode = ManagementModes.view;
            });

            _todoController.clear();
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

  Widget _getTodoTile(int index, Todo todo) {
    final isEditMode =
        _mode == ManagementModes.edit && _currentTodoIndex == index;

    Widget child = GestureDetector(
      onTap: () {
        if (!todo.completed) {
          setState(() {
            _mode = ManagementModes.edit;
            _currentTodoIndex = index;
          });
          _todoFocusNode.requestFocus();
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            todo.title,
            style: TextStyle(
              decoration: todo.completed ? TextDecoration.lineThrough : null,
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
    );

    if (isEditMode) {
      _todoController.text = todo.title;

      child = TextField(
        controller: _todoController,
        focusNode: _todoFocusNode,
        decoration: const InputDecoration(
          hintText: 'Enter a todo',
          border: InputBorder.none,
        ),
        readOnly: _mode == ManagementModes.view,
        onSubmitted: (todoTitle) {
          if (todoTitle.isNotEmpty) {
            _todosRepository.update(
              todo.copyWith(
                title: todoTitle,
                date: DateTime.now().toString(),
              ),
            );
          } else {
            _todosRepository.delete(todo);

            SnackBar snackBar = getSnackBar('Empty todo deleted');

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }

          setState(() {
            _mode = ManagementModes.view;
          });

          _todoController.clear();
        },
        onTapOutside: (_) {
          if (_mode != ManagementModes.view) {
            setState(() {
              _mode = ManagementModes.view;
            });
          }
        },
      );
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
        title: child,
        horizontalTitleGap: 4.0,
        leading: Checkbox(
          value: todo.completed,
          onChanged: (value) async {
            await _todosRepository.update(
              todo.copyWith(
                completed: value,
                date: DateTime.now().toString(),
              ),
            );

            setState(() {
              _mode = ManagementModes.view;
            });

            _todoController.clear();
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
