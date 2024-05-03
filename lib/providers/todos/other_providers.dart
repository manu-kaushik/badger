import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final todoFocusNodeProvider = StateProvider((ref) => FocusNode());

final todoInputControllerProvider = StateProvider((ref) => TextEditingController());
