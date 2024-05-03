import 'package:badger/utils/enums.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodoModeNotifier extends Notifier<ManagementModes> {
  @override
  ManagementModes build() {
    return ManagementModes.view;
  }

  void setMode(ManagementModes mode) {
    state = mode;
  }
}

final todoModeProvider =
    NotifierProvider<TodoModeNotifier, ManagementModes>(() {
  return TodoModeNotifier();
});
