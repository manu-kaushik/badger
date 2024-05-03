import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrentTodoIndexNotifier extends Notifier<int> {
  @override
  int build() {
    return -1;
  }

  void setCurrentTodoIndex(int index) {
    state = index;
  }
}

final currentTodoIndexProvider =
    NotifierProvider<CurrentTodoIndexNotifier, int>(() {
  return CurrentTodoIndexNotifier();
});
