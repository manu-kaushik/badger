import 'package:badger/repositories/todos_repository.dart';
import 'package:badger/utils/enums.dart';
import 'package:badger/widgets/todos/todos_list.dart';
import 'package:flutter/material.dart';

class TodosTab extends StatefulWidget {
  const TodosTab({super.key});

  @override
  State<TodosTab> createState() => _TodosTabState();
}

class _TodosTabState extends State<TodosTab> {
  final todosRepository = TodosRepository();

  late ManagementModes mode;

  final TextEditingController todoController = TextEditingController();

  final FocusNode todoFocusNode = FocusNode();

  int currentTodoIndex = -1;

  @override
  void initState() {
    super.initState();

    mode = ManagementModes.view;
  }

  @override
  void dispose() {
    todoController.dispose();

    todoFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          ScaffoldMessenger.of(context).clearSnackBars();

          if (mode == ManagementModes.add) {
            setState(() {
              mode = ManagementModes.view;
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
                        todosRepository.deleteCompletedTodos();

                        setState(() {});
                      }
                    },
                  ),
                ],
              ),
              TodosList(
                mode: mode,
                currentTodoIndex: currentTodoIndex,
                todoFocusNode: todoFocusNode,
                todoController: todoController,
                todosRepository: todosRepository,
                setMode: setMode,
              ),
            ],
          ),
        ),
        floatingActionButton: Visibility(
          visible: mode == ManagementModes.view,
          child: FloatingActionButton(
            heroTag: 'addTodoBtn',
            onPressed: () {
              setState(() {
                mode = ManagementModes.add;
              });
            },
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  void setMode(ManagementModes value) {
    setState(() {
      mode = value;
    });
  }
}
