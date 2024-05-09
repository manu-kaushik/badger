import 'package:badger/providers/exports.dart';
import 'package:badger/utils/enums.dart';
import 'package:badger/widgets/todos/todos_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodosTab extends ConsumerStatefulWidget {
  const TodosTab({super.key});

  @override
  ConsumerState<TodosTab> createState() => _TodosTabState();
}

class _TodosTabState extends ConsumerState<TodosTab> {
  late TextEditingController todoController;
  late FocusNode todoFocusNode;

  @override
  void dispose() {
    todoController.dispose();
    todoFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    todoController = ref.watch(todoInputControllerProvider);
    todoFocusNode = ref.watch(todoFocusNodeProvider);
    final mode = ref.watch(todoModeProvider);

    return Scaffold(
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
                    Icons.more_vert,
                  ),
                  elevation: 2,
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'clearCompleted',
                      child: Text('Clear Completed'),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'clearCompleted') {
                      ref.read(todosProvider.notifier).deleteCompletedTodos();
                    }
                  },
                ),
              ],
            ),
            const TodosList(),
          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: mode == ManagementModes.view,
        child: FloatingActionButton(
          heroTag: 'addTodoBtn',
          onPressed: () {
            ref.read(todoModeProvider.notifier).setMode(ManagementModes.add);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
