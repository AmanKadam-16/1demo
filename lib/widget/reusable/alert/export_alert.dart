import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExportAlertDialog extends StatelessWidget {
  ExportAlertDialog({
    super.key,
    required this.onExport,
  });

  final Function(String fileType) onExport;
  final _selectedFileType = 'PDF'.obs;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Export Report'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() => Column(
                children: [
                  RadioListTile(
                    title: const Text('PDF'),
                    value: 'PDF',
                    groupValue: _selectedFileType.value,
                    onChanged: (value) => _selectedFileType.value = value!,
                  ),
                  RadioListTile(
                    title: const Text('Excel'),
                    value: 'Excel',
                    groupValue: _selectedFileType.value,
                    onChanged: (value) => _selectedFileType.value = value!,
                  ),
                ],
              )),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            onExport(_selectedFileType.value);
            Navigator.of(context).pop();
          },
          child: const Text('Generate Report'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}