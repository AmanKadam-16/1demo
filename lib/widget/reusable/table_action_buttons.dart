import 'package:flutter/material.dart';

class TableActionButtons extends StatelessWidget {
  final bool isAnySelected;
  final VoidCallback? onDownload;
  final VoidCallback? onCancel;

  const TableActionButtons({
    Key? key,
    required this.isAnySelected,
    this.onDownload,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.download),
          tooltip: 'Download Selected',
          onPressed: isAnySelected ? onDownload : null,
        ),
        IconButton(
          icon: Icon(Icons.cancel),
          tooltip: 'Cancel Selected',
          onPressed: isAnySelected ? onCancel : null,
        ),
      ],
    );
  }
}
