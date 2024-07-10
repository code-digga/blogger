import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({super.key, required this.requestType});
  final String requestType;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('$requestType this post?'),
      content: Text(
          'You are about to ${requestType.toLowerCase()} this post.\n Do you wish to continue?'),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('YES')),
        TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('NO')),
      ],
      actionsAlignment: MainAxisAlignment.spaceAround,
    );
  }
}
