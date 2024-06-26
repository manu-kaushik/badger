import 'package:badger/providers/exports.dart';
import 'package:badger/utils/exports.dart';
import 'package:badger/widgets/exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodosList extends ConsumerWidget {
  const TodosList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(todoModeProvider);
    final todos = ref.watch(todosProvider);
    final currentTodoIndex = ref.watch(currentTodoIndexProvider);
    final todoFocusNode = ref.watch(todoFocusNodeProvider);

    return SliverList.list(
      children: [
        const SizedBox(
          height: 16.0,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 16.0),
          itemCount: todos.isEmpty
              ? 1
              : (mode == ManagementModes.add ? todos.length + 1 : todos.length),
          itemBuilder: (context, index) {
            final isEditMode =
                mode == ManagementModes.edit && currentTodoIndex == index;

            if (todos.isEmpty && index == 0) {
              if (mode == ManagementModes.add) {
                todoFocusNode.requestFocus();

                return TodoInput(isEditMode: isEditMode);
              } else {
                return const EmptyStateView(
                  icon: Icons.view_list_rounded,
                  text: 'No todos yet! Try adding one!',
                );
              }
            } else if (index == todos.length) {
              todoFocusNode.requestFocus();

              return TodoInput(isEditMode: isEditMode);
            }

            return TodoTile(index: index);
          },
        ),
      ],
    );
  }
}
