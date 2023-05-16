import 'package:flutter/material.dart';
import 'package:badger/models/todo.dart';
import 'package:badger/repositories/todos.dart';
import 'package:badger/utils/colors.dart';
import 'package:badger/utils/constants.dart';
import 'package:badger/utils/functions.dart';

class TodosTab extends StatefulWidget {
  const TodosTab({Key? key}) : super(key: key);

  @override
  State<TodosTab> createState() => _TodosTabState();
}

class _TodosTabState extends State<TodosTab> {
  final _todosRepository = TodosRepository();

  ManagementModes _mode = ManagementModes.view;

  final TextEditingController _todoController = TextEditingController();

  final FocusNode _todoFocusNode = FocusNode();

  int _currentTodoIndex = -1;

  @override
  void dispose() {
    _todoController.dispose();

    _todoFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/icons/app_icon.png',
              width: 36.0,
              height: 36.0,
            ),
            const SizedBox(
              width: 16.0,
            ),
            Text(
              'Todos',
              style: TextStyle(
                color: themeColor,
              ),
            ),
          ],
        ),
        backgroundColor: themeColor.shade50,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            offset: const Offset(0, kToolbarHeight + 8),
            icon: Icon(
              Icons.more_vert,
              color: themeColor, // Set the desired color here
            ),
            elevation: 0,
            color: themeColor.shade50,
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
      body: FutureBuilder<List<Todo>>(
        future: _todosRepository.getAll(order: Orders.asc),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final todos = snapshot.data!;

            if (todos.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.view_list_rounded,
                      color: themeColor.shade400,
                      size: 48.0,
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      'No todos yet! Try adding one!',
                      style: TextStyle(color: themeColor),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: _mode == ManagementModes.add
                  ? todos.length + 1
                  : todos.length,
              itemBuilder: (context, index) {
                if (index == todos.length) {
                  _todoFocusNode.requestFocus();

                  return ListTile(
                    title: TextField(
                      controller: _todoController,
                      focusNode: _todoFocusNode,
                      decoration: InputDecoration(
                        hintText: 'Enter a todo',
                        hintStyle: TextStyle(color: themeColor),
                        border: InputBorder.none,
                      ),
                      readOnly: _mode == ManagementModes.view,
                      onSubmitted: (todoTitle) async {
                        if (todoTitle != '') {
                          final todo = Todo(
                            id: await _todosRepository.getLastInsertedId() + 1,
                            title: todoTitle,
                          );

                          _todosRepository.insert(todo);

                          setState(() {
                            _mode = ManagementModes.view;
                          });

                          _todoController.clear();
                        } else {
                          SnackBar snackBar =
                              getSnackBar('Todo cannot be empty');

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);

                          _todoFocusNode.requestFocus();
                        }
                      },
                    ),
                    leading: Checkbox(
                      value: false,
                      onChanged: (_) async {},
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      activeColor: themeColor.shade300,
                    ),
                  );
                } else {
                  final todo = todos[index];

                  return getTodoTile(index, todo);
                }
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong!',
                style: TextStyle(color: themeColor),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: themeColor,
                strokeWidth: 1,
              ),
            );
          }
        },
      ),
      floatingActionButton: Visibility(
        visible: _mode == ManagementModes.view,
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              _mode = ManagementModes.add;
            });
          },
          backgroundColor: themeColor,
          elevation: 0,
          child: const Icon(Icons.add_task),
        ),
      ),
    );
  }

  ListTile getTodoTile(int index, Todo todo) {
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
      child: Text(
        todo.title,
        style: TextStyle(
          color: todo.completed ? themeColor.shade300 : themeColor,
          decoration: todo.completed ? TextDecoration.lineThrough : null,
        ),
      ),
    );

    if (_mode == ManagementModes.edit && _currentTodoIndex == index) {
      _todoController.text = todo.title;

      child = TextField(
        controller: _todoController,
        focusNode: _todoFocusNode,
        decoration: InputDecoration(
          hintText: todo.title,
          hintStyle: TextStyle(color: themeColor),
          border: InputBorder.none,
        ),
        readOnly: _mode == ManagementModes.view,
        onSubmitted: (todoTitle) {
          _todosRepository.update(todo.copyWith(title: todoTitle));

          setState(() {
            _mode = ManagementModes.view;
          });
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

    return ListTile(
      title: child,
      leading: Checkbox(
        value: todo.completed,
        onChanged: (value) async {
          await TodosRepository().update(todo.copyWith(completed: value));

          setState(() {
            _mode = ManagementModes.view;
          });
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        activeColor: themeColor.shade300,
      ),
    );
  }
}
