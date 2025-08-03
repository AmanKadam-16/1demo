import 'package:flutter/material.dart';

// Delete confirmation dialog
class DeleteConfirmationDialog extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onConfirm;

  const DeleteConfirmationDialog({
    Key? key,
    required this.selectedCount,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Delete'),
      content: Text('Are you sure you want to delete $selectedCount selected device(s)?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            onConfirm();
            Navigator.pop(context);
          },
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}