import 'package:flutter/material.dart';

class EmptyStateView extends StatelessWidget {
  final IconData icon;
  final String text;

  const EmptyStateView({
    super.key,
    this.icon = Icons.error_outline,
    this.text = 'Nothing to show here!',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(
        vertical: 128.0,
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 48.0,
          ),
          const SizedBox(
            height: 16.0,
          ),
          Text(
            text,
          ),
        ],
      ),
    );
  }
}
