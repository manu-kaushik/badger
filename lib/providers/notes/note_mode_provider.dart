import 'package:badger/utils/exports.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoteModeNotifier extends Notifier<ManagementModes> {
  @override
  ManagementModes build() {
    return ManagementModes.view;
  }

  void setMode(ManagementModes mode) {
    state = mode;
  }
}

final noteModeProvider =
    NotifierProvider<NoteModeNotifier, ManagementModes>(() {
  return NoteModeNotifier();
});
