// column_selector.dart

import 'package:flutter/material.dart';

class ColumnSelector extends StatefulWidget {
  final List<String> availableColumns;
  final List<String> selectedColumns;
  final Function(List<String>) onColumnsChanged;
  final bool isLoading;

  const ColumnSelector({
    Key? key,
    required this.availableColumns,
    required this.selectedColumns,
    required this.onColumnsChanged,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<ColumnSelector> createState() => _ColumnSelectorState();
}

class _ColumnSelectorState extends State<ColumnSelector> {
  late List<String> _selectedColumns;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _selectedColumns = List.from(widget.selectedColumns);
  }

  @override
  void didUpdateWidget(ColumnSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedColumns != widget.selectedColumns) {
      _selectedColumns = List.from(widget.selectedColumns);
    }
  }

  void _toggleColumn(String column) {
    setState(() {
      if (_selectedColumns.contains(column)) {
        if (_selectedColumns.length > 1) {
          _selectedColumns.remove(column);
        }
      } else {
        _selectedColumns.add(column);
      }
      widget.onColumnsChanged(_selectedColumns);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<void>(
      onSelected: (_) {},
      position: PopupMenuPosition.under,
      offset: const Offset(0, 8),
      onOpened: () => setState(() => _isOpen = true),
      onCanceled: () => setState(() => _isOpen = false),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: _isOpen ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: _isOpen
                ? Theme.of(context).primaryColor
                : Colors.grey.withOpacity(0.5),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.view_column_outlined,
              size: 20,
              color: _isOpen ? Theme.of(context).primaryColor : Colors.grey[700],
            ),
            const SizedBox(width: 8),
            Text(
              'Columns',
              style: TextStyle(
                color: _isOpen ? Theme.of(context).primaryColor : Colors.grey[700],
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              _isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: _isOpen ? Theme.of(context).primaryColor : Colors.grey[700],
            ),
          ],
        ),
      ),
      itemBuilder: (context) => [
        if (widget.isLoading)
          const PopupMenuItem(
            enabled: false,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        else
          ...widget.availableColumns.map(
            (column) => PopupMenuItem(
              child: Row(
                children: [
                  Checkbox(
                    value: _selectedColumns.contains(column),
                    onChanged: (_) => _toggleColumn(column),
                  ),
                  Text(column),
                ],
              ),
              onTap: () => _toggleColumn(column),
            ),
          ),
      ],
    );
  }
}