import 'package:badger/utils/exports.dart';
import 'package:flutter/material.dart';

class NoteTitleInput extends StatefulWidget {
  final TextEditingController titleController;
  final FocusNode titleFocusNode;
  final FocusNode bodyFocusNode;
  final VoidCallback onTap;

  const NoteTitleInput({
    super.key,
    required this.titleController,
    required this.titleFocusNode,
    required this.bodyFocusNode,
    required this.onTap,
  });

  @override
  State<NoteTitleInput> createState() => _NoteTitleInputState();
}

class _NoteTitleInputState extends State<NoteTitleInput> {
  late ManagementModes mode;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 8.0),
      child: TextField(
        controller: widget.titleController,
        focusNode: widget.titleFocusNode,
        decoration: InputDecoration(
          hintText: 'Enter a title',
          hintStyle: Theme.of(context).textTheme.headlineMedium,
          border: InputBorder.none,
        ),
        style: Theme.of(context).textTheme.headlineMedium,
        cursorOpacityAnimates: false,
        onTap: widget.onTap,
        onSubmitted: (_) {
          setState(() {
            widget.bodyFocusNode.requestFocus();
          });
        },
      ),
    );
  }
}
