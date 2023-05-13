import 'package:flutter/material.dart';
import 'package:notes/models/todo.dart';
import 'package:notes/repositories/todos.dart';
import 'package:notes/utils/colors.dart';

class TodosTab extends StatefulWidget {
  const TodosTab({Key? key}) : super(key: key);

  @override
  State<TodosTab> createState() => _TodosTabState();
}

class _TodosTabState extends State<TodosTab> {
  final _todosRepository = TodosRepository();

  @override
  void initState() {
    Todo todo = Todo(
      id: 2,
      title: "Play Minecraft",
      description: "",
      completed: false,
      color: "",
    );

    _todosRepository.insert(todo);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Todo>>(
      future: _todosRepository.getAll(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final todos = snapshot.data!;

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return ListTile(
                title: Text(
                  todo.title,
                  style: TextStyle(
                    color: todo.completed ? darkColor.shade300 : darkColor,
                    decoration:
                        todo.completed ? TextDecoration.lineThrough : null,
                  ),
                ),
                leading: Checkbox(
                  value: todo.completed,
                  onChanged: (value) async {
                    await TodosRepository()
                        .update(todo.copyWith(completed: value));

                    setState(() {});
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  activeColor: darkColor.shade300,
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Something went wrong!',
              style: TextStyle(color: darkColor),
            ),
          );
        } else if (!snapshot.hasData) {
          return Center(
            child: Text(
              'No todos yet! Try adding one!',
              style: TextStyle(color: darkColor),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: secondaryColor,
              strokeWidth: 1,
            ),
          );
        }
      },
    );
  }
}
