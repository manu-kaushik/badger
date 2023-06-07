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
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).clearSnackBars();

        if (_mode == ManagementModes.add) {
          setState(() {
            _mode = ManagementModes.view;
          });

          return false;
        }

        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: _buildTodosList(),
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
        child: const Icon(Icons.add_task),
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
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 48.0),
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
    );
  }

  Container _getNoTodosView(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      alignment: Alignment.center,
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

  AppBar _buildAppBar() {
    return AppBar(
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
    );
  }

  ListTile _getTodoInput(BuildContext context) {
    _todoFocusNode.requestFocus();

    return ListTile(
      contentPadding: EdgeInsets.zero,
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
          if (todoTitle.isNotEmpty) {
            final todo = Todo(
              id: await _todosRepository.getLastInsertedId() + 1,
              title: todoTitle,
              date: getCurrentTimestamp(),
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
        ),
        activeColor: themeColor.shade300,
      ),
    );
  }

  ListTile _getTodoTile(int index, Todo todo) {
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
              color: todo.completed ? themeColor.shade300 : themeColor,
              decoration: todo.completed ? TextDecoration.lineThrough : null,
            ),
          ),
          if (todo.date != null)
            const SizedBox(
              height: 4.0,
            ),
          if (todo.date != null)
            Text(
              todo.date!,
              style: TextStyle(
                color: themeColor.shade300,
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
        decoration: InputDecoration(
          hintText: 'Enter a todo',
          hintStyle: TextStyle(color: themeColor),
          border: InputBorder.none,
        ),
        readOnly: _mode == ManagementModes.view,
        onSubmitted: (todoTitle) {
          if (todoTitle.isNotEmpty) {
            _todosRepository.update(
              todo.copyWith(
                title: todoTitle,
                date: getCurrentTimestamp(),
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

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: child,
      horizontalTitleGap: 4.0,
      leading: Checkbox(
        value: todo.completed,
        onChanged: (value) async {
          await _todosRepository.update(
            todo.copyWith(
              completed: value,
              date: getCurrentTimestamp(),
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
        activeColor: themeColor.shade300,
      ),
    );
  }
}
